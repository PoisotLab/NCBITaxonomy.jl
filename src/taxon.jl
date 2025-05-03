"""
    taxon(id::Integer)

Performs a search in the entire taxonomy backbone based on a known ID. This is
the fastest way to get to a taxon, and is used internally by the tree traversal methods.
"""
function taxon(id::Integer)
    try
        m = only(NCBITaxonomy.groupedscinames[(tax_id = id,)])
        return NCBITaxon(
            m.name,
            m.tax_id,
        )
    catch
        throw(IDNotFoundInBackbone(id))
    end
end

function _id_from_name(name::String; kwargs...)
    return _id_from_name(NCBITaxonomy.taxonomy, name; kwargs...)
end

function _strict_matches(
    df::T,
    name::String,
    casesensitive::Bool,
) where {T <: AbstractDataFrame}
    positions = if casesensitive
        findall(==(name), df.name)
    else
        findall(==(lowercase(name)), df.lowercase)
    end
    isempty(positions) && return nothing
    return positions
end

function _fuzzy_matches(
    df::T,
    name::String,
    casesensitive::Bool,
    dist::Type{SD}
) where {T <: AbstractDataFrame, SD <: StringDistance}
    positions = if casesensitive
        last(findnearest(name, df.name, dist()))
    else
        last(findnearest(lowercase(name), df.lowercase, dist()))
    end
    isempty(positions) && return nothing
    return positions
end

function _id_from_name(
    df::T,
    name::String;
    strict::Bool = true,
    dist::Type{SD} = Levenshtein,
    casesensitive::Bool = true,
    rank::Union{Nothing, Symbol} = nothing,
    preferscientific::Bool = false,
) where {SD <: StringDistance, T <: AbstractDataFrame}
    # Perform the correct search
    positions = if strict
        _strict_matches(df, name, casesensitive)
    else
        _fuzzy_matches(df, name, casesensitive, dist)
    end
    length(positions) == 1 && return df.tax_id[only(positions)]
    isempty(positions) && throw(NameHasNoDirectMatch(name))
    @info df[positions,:]
    #taxa = taxon.(df.tax_id[positions])
    #throw(NameHasMultipleMatches(name, taxa))
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
taxon(name::String; kwargs...) = taxon(NCBITaxonomy.taxonomy, name; kwargs...)

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
