"""
   _children(id::T) where {T <: Int}

Internal function to retrieve the id of the children of a given node.
"""
function _children(id::T) where {T <: Int}
    positions = findall(isequal(id), NCBITaxonomy.nodes_table.parent_tax_id)
    return NCBITaxonomy.nodes_table.tax_id[positions]
end

"""
    _descendants(id::T) where {T <: Int}

Recursively get the descendants of a given node.
"""
function _descendants(id::T) where {T <: Int}
    c = NCBITaxonomy._children(id)
    isempty(c) && return id
    return vcat(id, _descendants(c)...)
end

_children(ids::Vector{T}) where {T <: Int} = map(_children_nodes, ids)
_descendants(ids::Vector{T}) where {T <: Int} = map(_descendants, ids)

"""
    _taxa_from_id(id::Vector{T}) where {T <: Int}

Get a list of `NCBITaxon` from a vector of ids.
"""
function _taxa_from_id(id::Vector{T}) where {T <: Int}
    tax = Vector{NCBITaxon}(undef, length(id))
    positions = findall(vec(any(NCBITaxonomy.names_table.tax_id.==permutedims(id); dims=2)))
    tdf = NCBITaxonomy.names_table[positions,:]
    scientific_names = findall(isequal(class_scientific_name), tdf.class)
    tdf = tdf[scientific_names, :]
    for i in eachindex(id)
        tax[i] = NCBITaxon(tdf.name[i], tdf.tax_id[i])
    end
    return tax
end

"""
    children(t::NCBITaxon)

Returns the node immediately below the taxon given as argument, or `nothing` if
the taxon is terminal.
"""
function children(t::NCBITaxon)
    c = _children(t.id)
    return _taxa_from_id(c)
end

"""
    descendants(t::NCBITaxon)

Recurisvely calls `children` until all terminal nodes under the taxon are
reached. Depending on the taxonomic level, and number of taxa under the taxon
considered, this can be a long function to run.
"""
function descendants(t::NCBITaxon)
    c = _descendants(t.id)
    filter!(!isequal(t.id), c)
    return _taxa_from_id(c)
end
