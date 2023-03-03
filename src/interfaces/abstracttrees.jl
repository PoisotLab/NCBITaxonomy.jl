"""
    AbstractTrees.children(tax::NCBITaxon)

Returns the children of a taxon.
"""
function AbstractTrees.children(tax::NCBITaxon)
    positions = findall(isequal(tax.id), NCBITaxonomy.scinames_table.parent_tax_id)
    if ~isempty(positions)
        list_of_children = Vector{NCBITaxon}(undef, length(positions))
        for i in axes(positions, 1)
            list_of_children[i] = taxon(NCBITaxonomy.scinames_table.tax_id[positions[i]])
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
        parent_id = NCBITaxonomy.scinames_table.parent_tax_id[position]
        return taxon(parent_id)
    else
        return nothing
    end
end

"""
    _siblings(tax::NCBITaxon)

Returns a list of siblings (node descended from the same parent) for the taxon
given as argument.
"""
function _siblings(tax::NCBITaxon)
    return (AbstractTrees.children ∘ AbstractTrees.parent)(tax)
end

"""
    AbstractTrees.nextsibling(tax::NCBITaxon)

Returns the taxon stored immediately after the one given as argument (among the
list of siblings).
"""
function AbstractTrees.nextsibling(tax::NCBITaxon)
    it = _siblings(tax)
    i = findfirst(isequal(tax), it)
    if i < length(it)
        return it[i + 1]
    else
        return nothing
    end
end

"""
    AbstractTrees.prevsibling(tax::NCBITaxon)

Returns the taxon stored immediately before the one given as argument (among the
list of siblings).
"""
function AbstractTrees.prevsibling(tax::NCBITaxon)
    it = _siblings(tax)
    i = findfirst(isequal(tax), it)
    if i > 1
        return it[i - 1]
    else
        return nothing
    end
end

"""
    AbstractTrees.isroot(tax::NCBITaxon)

Ensure that the node `root:1` is always a root.
"""
function AbstractTrees.isroot(tax::NCBITaxon)
    return tax.id == 1
end

Base.IteratorEltype(::Type{<:TreeIterator{NCBITaxon}}) = Base.HasEltype()
Base.eltype(::Type{<:TreeIterator{NCBITaxon}}) = NCBITaxon