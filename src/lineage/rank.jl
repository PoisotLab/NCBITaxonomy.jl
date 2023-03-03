"""
    rank(taxon::NCBITaxon)

Returns the rank of a taxon.
"""
function rank(tax::NCBITaxon)
    position = findfirst(isequal(tax.id), NCBITaxonomy.nodes_table.tax_id)
    return NCBITaxonomy.nodes_table.rank[position]
end
