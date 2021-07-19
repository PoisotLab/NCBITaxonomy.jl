"""
    taxon(df::DataFrame, id::Integer)

Returns a fully formed `NCBITaxon` based on its id. The `name` of the taxon
will be the valid scientic name associated to this id.
"""
function taxon(df::DataFrame, id::Integer)
    matched_indices = findall(isequal(id), df.tax_id)
    isempty(matched_indices) && throw(IDNotFoundInBackbone(id))
    submatches = df[matched_indices, :]
    @assert NCBITaxonomy.class_scientific_name in submatches.class
    sciname_position = findfirst(
        isequal(NCBITaxonomy.class_scientific_name), submatches.class
    )
    return NCBITaxon(submatches.name[sciname_position], id)
end

"""
    taxon(id::Integer)

Performs a search in the entire taxonomy backbone based on a known ID.
"""
taxon(id::Integer) = taxon(NCBITaxonomy.names_table, id)

function _id_from_name(name::AbstractString; kwargs...)
    return _id_from_name(NCBITaxonomy.names_table, name; kwargs...)
end

function _id_from_name(
    df::DataFrame,
    name::AbstractString;
    strict::Bool=true,
    dist::Type{SD}=Levenshtein,
    lowercase::Bool=false,
    rank::Union{Nothing,Symbol}=nothing,
) where {SD<:StringDistance}
    if !isnothing(rank)
        @assert rank ∈ unique(NCBITaxonomy.nodes_table)
    end
    if strict
        positions = if lowercase
            findall(isequal(name), df.lowercase)
        else
            findall(isequal(name), df.name)
        end
        # If the array is empty, we throw the "no name" error
        isempty(positions) && throw(NameHasNoDirectMatch(name))
        # If the array has a single element, this is the ticket
        length(positions) == 1 && return df.tax_id[first(positions)]
        # If neither of these are satisfied, the name has multiple matches and we throw the appropriate error
        taxa = taxon.(df.tax_id[positions])
        throw(NameHasMultipleMatches(name, taxa))
    else
        correct_name, position = findnearest(name, df.name, dist())
        return df.tax_id[position]
    end
end

"""
    taxon(name::AbstractString; kwargs...)

The `taxon` function is the core entry point in the NCBI taxonomy. It takes a
string, and a series of keywords, and go look for this taxon in the dataframe
(by default the entire names table).

The keywords are:

- `strict` (def. `true`), allows fuzzy matching
- `dist` (def. `Levenshtein`), the string distance function to use
- `lowercase` (def. `false`), whether to strict match on lowercased names
- `rank` (def. `nothing`), the taxonomic rank to limit the search
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
    return taxon(df, id)
end

"""
    ncbi_str(s)

A string macro to perform a strict taxonomic search.
"""
macro ncbi_str(s)
    return taxon(s)
end
