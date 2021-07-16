"""
    parent(taxon::NCBITaxon)

Returns the taxon from which the argument is descended.
"""
function Base.parent(tax::NCBITaxon)
    position = findfirst(isequal(tax.id), NCBITaxonomy.nodes_table.tax_id)
    parent_id = NCBITaxonomy.nodes_table.parent_tax_id[position]
    isnothing(parent_id) && return nothing
    return taxon(parent_id)
end
"""
    rank(taxon::NCBITaxon)

Returns the rank of a taxon.
"""
function rank(tax::NCBITaxon)
    position = findfirst(isequal(tax.id), NCBITaxonomy.nodes_table.tax_id)
    return NCBITaxonomy.nodes_table.rank[position]
end

"""
    lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")

Returns an array of `NCBITaxon` going up to the root of the taxonomy, or to the
optionally specified `stop_at` taxonomic node.
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")
    full_lineage = [tax]
    while last(full_lineage) != stop_at
        push!(full_lineage, parent(last(full_lineage)))
    end
    return reverse(full_lineage)
end
