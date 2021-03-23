function namefilter(ids::Vector{T}) where {T <: Integer}
    return leftjoin(DataFrame(tax_id=ids), NCBITaxonomy.names_table; on=:tax_id)
end

function namefilter(taxa::Vector{NCBITaxon})
    return namefilter([t.id for t in taxa])
end

function namefilter(division::Symbol)
    ids = findall(isequal(division), NCBITaxonomy.nodes_table.division_code)
    return namefilter(NCBITaxonomy.nodes_table.tax_id[ids])
end
