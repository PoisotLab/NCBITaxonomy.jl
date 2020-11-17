"""
    parent(taxon::NCBITaxon)

Returns the taxon from which the argument is descended.
"""
function Base.parent(taxon::NCBITaxon)
    position = findfirst(isequal(taxon.id), NCBITaxonomy.nodes_table.tax_id)
    id = NCBITaxonomy.nodes_table.parent_tax_id[position]
    isnothing(id) && return nothing
    name = NCBITaxonomy._get_sciname_from_taxid(NCBITaxonomy.names_table, id)
    return NCBITaxon(name, id)
end

"""
    rank(taxon::NCBITaxon)

Returns the rank of a taxon.
"""
function rank(taxon::NCBITaxon)
    position = findfirst(isequal(taxon.id), NCBITaxonomy.nodes_table.tax_id)
    return NCBITaxonomy.nodes_table.rank[position]
end

"""
    lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")

Returns an array of `NCBITaxon` going up to the root of the taxonomy, or to the
optionally specified `stop_at` taxonomic node.
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")
    lin = [tax]
    while last(lin) != stop_at
        push!(lin, parent(last(lin)))
    end
    return reverse(lin)
end