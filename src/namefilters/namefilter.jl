"""
    namefilter(ids::Vector{T}) where {T <: Integer}

Returns a subset of the names table where only the given taxids are present.
"""
function namefilter(ids::Vector{T}) where {T <: Integer}
    return leftjoin(DataFrame(; tax_id = ids), NCBITaxonomy.taxonomy; on = :tax_id)
end

"""
    namefilter(taxa::Vector{NCBITaxon})

Returns a subset of the names table dataset, where the taxids of the taxa are
present. This includes all names, not only the scientific names.
"""
function namefilter(taxa::Vector{NCBITaxon})
    return namefilter([t.id for t in taxa])
end

"""
    namefilter(division::Symbol)

Returns a subset of the names table for all names under a given NCBI division.
"""
function namefilter(division::Symbol)
    return filter(r -> r.division_code == division, NCBITaxonomy.taxonomy)
end

"""
    namefilter(division::Vector{Symbol})

Returns a subset of the names table for all names under a number of multiple
NCBI divisions.
"""
function namefilter(division::Vector{Symbol})
    return filter(r -> r.division_code in division, NCBITaxonomy.taxonomy)
end