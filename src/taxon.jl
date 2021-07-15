_id_from_name(name::AbstractString; kwargs...) = _id_from_name(NCBITaxonomy.names_table, name; kwargs...)
_sciname_from_taxid(id::Integer) = _sciname_from_taxid(NCBITaxonomy.names_table, id)

function _id_from_name(df::DataFrame, name::AbstractString; strict::Bool=true, dist::Type{SD}=Levenshtein) where {SD <: StringDistance}
    if strict
        positions = findall(isequal(name), df.name)
        @info name
        @info positions
        isempty(positions) && return nothing 
        length(positions) == 1 && return df.tax_id[positions[1]]
        # If neither of these are satisfied, the name has multiple matches
        ids = [df.tax_id[position] for position in positions]
        taxa = [NCBITaxon(_sciname_from_taxid(id), id) for id in ids]
        throw(NCBIMultipleMatchesException(name, taxa))
    else
        correct_name, position = findnearest(name, df.name, dist())
        return df.tax_id[position]
    end
end

function _sciname_from_taxid(df::DataFrame, id::Integer)
    return df.name[findfirst((df.tax_id .== id).&(df.class .== NCBITaxonomy.class_scientific_name))]
end

"""
    taxon(name::AbstractString; kwargs...)

The `taxon` function is the core entry point in the NCBI taxonomy. It takes a
string, and a series of keywords, and go look for this taxon in the dataframe
(by default the entire names table).

The keywords are:

- `strict` (def. `true`), allows fuzzy matching
- `dist` (def. `Levenshtein`), the string distance function to use
"""
taxon(name::AbstractString; kwargs...) = taxon(NCBITaxonomy.names_table, name; kwargs...)

"""
    taxon(df::DataFrame, name::AbstractString; kwargs...)

Additional method for `taxon` with an extra dataframe argument, used most often
with a `namefinder`. Accepts the usual `taxon` keyword arguments.
"""
function taxon(df::DataFrame, name::AbstractString; kwargs...)
    id = _id_from_name(df, name; kwargs...)
    isnothing(id) && return nothing
    return NCBITaxon(_sciname_from_taxid(df, id), id)
end

"""
    ncbi_str(s)

A string macro to perform a strict taxonomic search.
"""
macro ncbi_str(s)
    return taxon(s)
end
