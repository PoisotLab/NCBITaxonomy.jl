function _get_sciname_from_taxid(df::T, id::Int) where {T <: DataFrame}
    return first(@where(df, :tax_id .== id, :class .== Symbol("scientific name")).name)
end

"""
    namefinder(df::T) where {T <: DataFrame}

Generates a name-finding function that takes a string as an argument, and a
boolean (`fuzzy`) as a keyword argument to switch from strict to fuzzy matching.
The generated function will return a `NCBITaxon` for a given string. By default,
the function `taxid` is working on the entire names table, which is going to be
slow if there are many names to fuzzy match.

Altough the input dataframe is supposed to be a subset of the (unexported)
`names_table`, all that is required is that it has the columns `tax_id`, `name`,
and `class`. Make of that information what you wish...
"""
function namefinder(df::T) where {T <: DataFrame}
    function _inner_finder(name::K; fuzzy::Bool=false) where {K <: String}
        if fuzzy
            correct_name, position = findnearest(name, df.name, Levenshtein())
        else
            position = findfirst(isequal(name).(df.name))
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