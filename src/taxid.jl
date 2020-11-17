"""
    _get_sciname_from_taxid(df::T, id::Int) where {T <: DataFrame}

This internal function will return a scientific name from a numerical `id`.
"""
function _get_sciname_from_taxid(df::T, id::Int) where {T <: DataFrame}
    ok_taxid = findall(isequal(id).(df.tax_id))
    tdf = df[ok_taxid,:]
    _is_sci = isequal(Symbol("scientific name"))
    scientific_names = findall(_is_sci.(tdf.class))
    return only(tdf[scientific_names,:].name)
end

"""
    namefinder(df::T) where {T <: DataFrame}

Generates a name-finding function that takes a string as an argument, and a
boolean (`fuzzy`) as a keyword argument to switch from strict to fuzzy matching.
The generated function will return a `NCBITaxon` for a given string. By default,
the function `taxid` is working on the entire names table, which is going to be
slow if there are many names to fuzzy match. The keyword argument `verbose`
(default to `false`) indicates whether the distance to a fuzzy match must be
printed.

Under strict matching, if no match is found, the namefinder will return
`nothing`. This can be used to switch to the fuzzy namefinder automatically. The
fuzzy namefinder uses the `findnearest` function from `StringDistances`, which
will *always* return something. The `compare` function from the same package may
be used to see how similar the names are, and to decide whether to keep them.

Altough the input dataframe is supposed to be a subset of the (unexported)
`names_table`, all that is required is that it has the columns `tax_id`, `name`,
and `class`. Make of that information what you wish...
"""
function namefinder(df::T) where {T <: DataFrame}
    function _inner_finder(name::K; fuzzy::Bool=false, verbose::Bool=false) where {K <: String}
        if fuzzy
            correct_name, position = findnearest(name, df.name, Levenshtein())
            if verbose
                names_dist = compare(name, correct_name, Levenshtein())
                @info "$(name) matched as $(correct_name) - distance: $(names_dist)"
            end
        else
            position = findfirst(isequal(name).(df.name))
            isnothing(position) && return nothing
        end
        row = df[position,:] 
        if row.class == Symbol("scientific name")
            return NCBITaxon(row.name, row.tax_id)
        else
            return NCBITaxon(_get_sciname_from_taxid(df, row.tax_id), row.tax_id)
        end
    end 
end

"""
    taxid(name::T; fuzzy::Bool = false) where {T <: String}

Returns the taxonomic ID of a taxon, given as a string. This function searches
in the *entire* names table, which is unlikely to give a good performance when
using fuzzy matching. We encourage the use of the `namefinder` function to build
a custom version.
"""
taxid = namefinder(NCBITaxonomy.names_table)

"""
    _df_from_taxlist(tax::Vector{NCBITaxon})

Returns a subset of the names dataframe based on a vector of taxa.
"""
function _df_from_taxlist(tax::Vector{NCBITaxon})
    ids = [t.id for t in tax]
    positions = findall(vec(any(NCBITaxonomy.names_table.tax_id .== permutedims(ids); dims=2)))
    return NCBITaxonomy.names_table[positions, :]
end

"""
    descendantsfinder(t::NCBITaxon)

Returns a `namefinder` for all taxa below the one given as argument. This
function calls `descendants` internally, so it might not be the optimal way when
dealing with large groups.
"""
function descendantsfinder(t::NCBITaxon)
    d = descendants(t)
    df = _df_from_taxlist(d)
    return namefinder(df)
end