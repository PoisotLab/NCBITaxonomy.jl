"""
   _children_nodes(id::T) where {T <: Int}

Internal function to retrieve the id of the children of a given node.
"""
function _children_nodes(id::T) where {T <: Int}
    positions = findall(NCBITaxonomy.nodes_table.parent_tax_id .== id)
    return NCBITaxonomy.nodes_table.tax_id[positions]
end

"""
    _descendant_nodes(id::Vector{T}) where {T <: Int}

Internal function to retrieve the descendants of a given array of nodes.
"""
function _descendant_nodes(id::Vector{T}) where {T <: Int}
    return(filter(!isnothing, vcat(_descendant_nodes.(id)...)))
end

"""
    _descendant_nodes(id::T) where {T <: Int}

Internal function to recursively get the descendants.
"""
function _descendant_nodes(id::T) where {T <: Int}
    c = _children_nodes(id)
    if isempty(c)
        return nothing
    else
        return convert(Vector{T}, vcat(c, _descendant_nodes(c)))
    end
end

"""
    _taxa_from_id(id::Vector{T}) where {T <: Int}

Get a list of `NCBITaxon` from a vector of ids.
"""
function _taxa_from_id(id::Vector{T}) where {T <: Int}
    positions = filter(i -> NCBITaxonomy.names_table.tax_id[i] in id, eachindex(NCBITaxonomy.names_table.tax_id))
    tdf = NCBITaxonomy.names_table[positions,:]
    scientific_names = findall(tdf.class .== Symbol("scientific name"))
    return [NCBITaxon(r.name, r.tax_id) for r in eachrow(tdf[scientific_names,:])]
end

"""
    children(t::NCBITaxon)

Returns the node immediately below the taxon given as argument, or `nothing` if
the taxon is terminal.
"""
function children(t::NCBITaxon)
    c = _children_nodes(t.id)
    return _taxa_from_id(c)
end

"""
    descendants(t::NCBITaxon)

Recurisvely calls `children` until all terminal nodes under the taxon are
reached. Depending on the taxonomic level, and number of taxa under the taxon
considered, this can be a long function to run.
"""
function descendants(t::NCBITaxon)
    c = _descendant_nodes(t.id)
    return _taxa_from_id(c)
end
