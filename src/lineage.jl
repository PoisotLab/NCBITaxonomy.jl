function _parent_of(tax::NCBITaxon)
    position = findfirst(NCBITaxonomy.nodes_table.tax_id .== tax.id)
    id = NCBITaxonomy.nodes_table.parent_tax_id[position]
    isnothing(id) && return nothing
    name = NCBITaxonomy._get_sciname_from_taxid(NCBITaxonomy.names_table, id)
    return NCBITaxon(name, id)
end

"""
TODO
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")
    lin = [tax]
    while last(lin) != stop_at
        push!(lin, _parent_of(last(lin)))
    end
    return reverse(lin)
end