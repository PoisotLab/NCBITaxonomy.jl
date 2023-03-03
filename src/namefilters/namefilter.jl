"""
    namefilter(ids::Vector{T}) where {T <: Integer}

Returns a subset of the names table where only the given taxids are present.
"""
function namefilter(ids::Vector{T}) where {T <: Integer}
    return leftjoin(DataFrame(; tax_id = ids), NCBITaxonomy.names_table; on = :tax_id)
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
    ids = findall(isequal(division), NCBITaxonomy.nodes_table.division_code)
    return namefilter(NCBITaxonomy.nodes_table.tax_id[ids])
end

"""
    namefilter(division::Vector{Symbol})

Returns a subset of the names table for all names under a number of multiple
NCBI divisions.
"""
function namefilter(division::Vector{Symbol})
    ids = findall(x -> x in division, NCBITaxonomy.nodes_table.division_code)
    return namefilter(NCBITaxonomy.nodes_table.tax_id[ids])
end