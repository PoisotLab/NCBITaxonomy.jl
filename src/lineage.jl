"""
    _parent_of(tax::NCBITaxon)

Returns the taxon from which the argument is descended.
"""
function _parent_of(tax::NCBITaxon)
    position = findfirst(NCBITaxonomy.nodes_table.tax_id .== tax.id)
    id = NCBITaxonomy.nodes_table.parent_tax_id[position]
    isnothing(id) && return nothing
    name = NCBITaxonomy._get_sciname_from_taxid(NCBITaxonomy.names_table, id)
    return NCBITaxon(name, id)
end

"""
    lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")

Returns an array of `NCBITaxon` going up to the root of the taxonomy, or to the
optionally specified `stop_at` taxonomic node.
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")
    lin = [tax]
    while last(lin) != stop_at
        push!(lin, _parent_of(last(lin)))
    end
    return reverse(lin)
end