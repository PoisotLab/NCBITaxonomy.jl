"""
    taxon(id::Integer)

Performs a search in the entire taxonomy backbone based on a known ID. This is
the fastest way to get to a taxon, and is used internally by the tree traversal methods.
"""
function taxon(id::Integer)
    (id in NCBITaxonomy.scinames.tax_id) || throw(IDNotFoundInBackbone(id))
    return NCBITaxon(
        only(NCBITaxonomy.groupedscinames[(tax_id = id,)].name),
        only(NCBITaxonomy.groupedscinames[(tax_id = id,)].tax_id),
    )
end

function _id_from_name(name::AbstractString; kwargs...)
    return _id_from_name(NCBITaxonomy.taxonomy, name; kwargs...)
end

function _id_from_name(
    df::T,
    name::String;
    strict::Bool = true,
    dist::Type{SD} = Levenshtein,
    casesensitive::Bool = true,
    rank::Union{Nothing, Symbol} = nothing,
    preferscientific::Bool = false,
    onlysynonyms::Bool = false,
) where {SD <: StringDistance, T <: AbstractDataFrame}
    if !isnothing(rank)
        @assert rank ∈ unique(df.rank)
        df = df[findall(isequal(rank), df.rank), :]
    end
    if onlysynonyms
        df = df[findall(isequal(NCBITaxonomy.class_synonym), df.class), :]
    end
    if strict
        positions = if casesensitive
            findall(isequal(name), df.name)
        else
            findall(isequal(lowercase(name)), df.lowercase)
        end
        # If the array is empty, we throw the "no name" error
        isempty(positions) && throw(NameHasNoDirectMatch(name))
        # If the array has a single element, this is the ticket
        length(positions) == 1 && return df.tax_id[first(positions)]
        # If we prefer scientific names, we can filter with this
        if preferscientific
            if NCBITaxonomy.class_scientific_name in df.class[positions]
                ids = df.tax_id[positions][findall(
                    isequal(NCBITaxonomy.class_scientific_name),
                    df.class[positions],
                )]
                if length(ids) == 1
                    return first(ids)
                else
                    throw(NameHasMultipleMatches(name, taxon.(ids)))
                end
            end
        end
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
  - `casesensitive` (def. `true`), whether to strict match on lowercased names
  - `rank` (def. `nothing`), the taxonomic rank to limit the search
  - `preferscientific` (def. `false`), whether scientific names are prefered
    when the query also matches non-scientific names (synonyms, vernaculars,
    blast names, ...) - this is most likely useful when paired with
    `casesensitive=true`, and is not working with `strict=false`
  - `onlysynonyms` (def. `false`) - limits the search to synonyms, which may be
    useful in case the taxonomy is particularly outdated
"""
taxon(name::AbstractString; kwargs...) = taxon(NCBITaxonomy.taxonomy, name; kwargs...)

"""
    taxon(df::DataFrame, name::AbstractString; kwargs...)

Additional method for `taxon` with an extra dataframe argument, used most often
with a `namefinder`. Accepts the usual `taxon` keyword arguments.
"""
function taxon(df::T, name::String; kwargs...) where {T <: AbstractDataFrame}
    id = _id_from_name(df, name; kwargs...)
    isnothing(id) && return nothing
    return taxon(id)
end

"""
    ncbi_str(s)

A string macro to perform a strict taxonomic search.
"""
macro ncbi_str(s)
    return taxon(s)
end
