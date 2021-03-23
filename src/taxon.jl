_id_from_name(name::AbstractString; kwargs...) = _id_from_name(NCBITaxonomy.names_table, name; kwargs...)
_sciname_from_taxid(id::Integer) = _sciname_from_taxid(NCBITaxonomy.names_table, id)

function _id_from_name(df::DataFrame, name::AbstractString; strict::Bool=true, verbose::Bool=false, dist::Type{SD}=Levenshtein) where {SD <: StringDistance}
    if strict
        position = findfirst(isequal(name), df.name)
        return isnothing(position) ? nothing : df.tax_id[position]
    else
        correct_name, position = findnearest(name, df.name, dist())
        return df.tax_id[position]
    end
end

function _sciname_from_taxid(df::DataFrame, id::Integer)
    return df.name[findfirst((df.tax_id .== id).&(df.class .== NCBITaxonomy.class_scientific_name))]
end

taxon(name::AbstractString; kwargs...) = taxon(NCBITaxonomy.names_table, name; kwargs...)

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