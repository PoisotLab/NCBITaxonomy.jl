"""
    AbstractTrees.children(tax::NCBITaxon)

Returns the children of a taxon.
"""
function AbstractTrees.children(tax::NCBITaxon)
    positions = findall(isequal(tax.id), NCBITaxonomy.scinames_table.parent_tax_id)
    if ~isempty(positions)
        list_of_children = Vector{NCBITaxon}(undef, length(positions))
        for i in axes(positions, 1)
            list_of_children[i] = NCBITaxon(
                NCBITaxonomy.scinames_table.name[positions[i]],
                NCBITaxonomy.scinames_table.tax_id[positions[i]],
            )
        end
        return list_of_children
    else
        return ()
    end
end

"""
    AbstractTrees.parent(taxon::NCBITaxon)

Returns the taxon from which the argument taxon is descended.
"""
function AbstractTrees.parent(tax::NCBITaxon)
    position = findfirst(isequal(tax.id), NCBITaxonomy.scinames_table.tax_id)
    if ~isnothing(position)
        parent_position = findfirst(
            isequal(NCBITaxonomy.scinames_table.parent_tax_id[position]),
            NCBITaxonomy.scinames_table.tax_id,
        )
        return NCBITaxon(
            NCBITaxonomy.scinames_table.name[parent_position],
            NCBITaxonomy.scinames_table.tax_id[parent_position],
        )
    else
        return nothing
    end
end

Base.IteratorEltype(::Type{<:TreeIterator{NCBITaxon}}) = Base.HasEltype()
Base.eltype(::Type{<:TreeIterator{NCBITaxon}}) = NCBITaxon