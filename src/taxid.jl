"""
    _get_sciname_from_taxid(df::T, id::Int) where {T <: DataFrame}

This internal function will return a scientific name from a numerical `id`.
"""
function _get_sciname_from_taxid(df::T, id::Int) where {T <: DataFrame}
    rows = (isequal(id).(df.tax_id)).&(isequal(NCBITaxonomy.class_scientific_name).(df.class))
    return only(NCBITaxonomy.names_table[rows,:].name)
end

"""
    namefinder(df::T) where {T <: DataFrame}

Generates a name-finding function that takes a string as an argument, and a
boolean (`fuzzy`) as a keyword argument to switch from strict to fuzzy matching.
The generated function will return a `NCBITaxon` for a given string. By default,
the function `taxid` is working on the entire names table, which is going to be
slow if there are many names to fuzzy match. The keyword argument `verbose`
(default to `false`) indicates whether the distance to a fuzzy match must be
printed. Finally, the `dist` keyword argument is one of the types implemented by
`StringDistances`, and is used to switch the string distance measure used in
fuzzy matching. The default is Levenshtein distance.

Under strict matching, if no match is found, the namefinder will return
`nothing`. This can be used to switch to the fuzzy namefinder automatically. The
fuzzy namefinder uses the `findnearest` function from `StringDistances`, which
will *always* return something. The `compare` function from the same package may
be used to see how similar the names are, and to decide whether to keep them.

Altough the input dataframe is supposed to be a subset of the (unexported)
`names_table`, all that is required is that it has the columns `tax_id`, `name`,
and `class`. Make of that information what you wish...

As a final note, all `namefinder` functions accept a `strict` argument, which is
restricted to valid scientific names (with the exception of synonyms). This has
the potential to make a number of functions much faster if you know that the
names are valid.
"""
function namefinder(df::T; strict::Bool=false) where {T <: DataFrame}
    if strict
        df = df[df.class .== class_scientific_name, :]
    end
    function _inner_finder(name::K; fuzzy::Bool=false, verbose::Bool=false, dist=Levenshtein) where {K <: AbstractString}
        @assert dist <: StringDistances.StringDistance
        if fuzzy
            correct_name, position = findnearest(name, df.name, dist())
            if verbose
                names_dist = compare(name, correct_name, dist())
                @info "$(name) matched as $(correct_name) - distance: $(names_dist)"
            end
        else
            position = findfirst(isequal(name).(df.name))
            isnothing(position) && return nothing
        end
        row = df[position,:]
        if row.class == class_scientific_name
            return NCBITaxon(row.name, row.tax_id)
        else
            return NCBITaxon(_get_sciname_from_taxid(df, row.tax_id), row.tax_id)
        end
    end
end

"""
    taxid(name::T; fuzzy::Bool = false, verbose::Bool=false, dist=StringDistances.Levenshtein) where {T <: AbstractString}

Returns the taxonomic ID of a taxon, given as a string. This function searches
in the *entire* names table, which is unlikely to give a good performance when
using fuzzy matching. We encourage the use of the `namefinder` function to build
a custom version.
"""
taxid = namefinder(NCBITaxonomy.names_table)

"""
    namefinder(tax::Vector{NCBITaxon}; strict::Bool=false)

Returns a namefinder function that is only limited to taxa from the list.
"""
function namefinder(tax::Vector{NCBITaxon}; strict::Bool=false)
    return namefinder(_df_from_taxlist(tax; strict=strict))
end

"""
    _df_from_taxlist(tax::Vector{NCBITaxon})

Returns a subset of the names dataframe based on a vector of taxa.
"""
function _df_from_taxlist(tax::Vector{NCBITaxon}; strict::Bool=false)
    ids = [t.id for t in tax]
    positions = findall(vec(any(NCBITaxonomy.names_table.tax_id .== permutedims(ids); dims=2)))
    if strict
        return NCBITaxonomy.names_table[positions, :]
    else
        return filter(r -> isequal(class_scientific_name)(r.class), NCBITaxonomy.names_table[positions, :])
    end
end

"""
    descendantsfinder(t::NCBITaxon)

Returns a `namefinder` for all taxa below the one given as argument. This
function calls `descendants` internally, so it might not be the optimal way when
dealing with large groups.
"""
function descendantsfinder(t::NCBITaxon)
    d = descendants(t)
    df = _df_from_taxlist(d; strict=true)
    return namefinder(df)
end