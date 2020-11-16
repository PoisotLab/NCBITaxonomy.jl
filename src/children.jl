function _children_nodes(id::T) where {T <: Int}
    positions = findall(NCBITaxonomy.nodes_table.parent_tax_id .== id)
    return NCBITaxonomy.nodes_table.tax_id[positions]
end

function _descendant_nodes(id::Vector{T}) where {T <: Int}
    return(filter(!isnothing, vcat(_descendant_nodes.(id)...)))
end

function _descendant_nodes(id::T) where {T <: Int}
    c = _children_nodes(id)
    if isempty(c)
        return nothing
    else
        return convert(Vector{T}, vcat(c, _descendant_nodes(c)))
    end
end

function _taxa_from_id(id::Vector{T}) where {T <: Int}
    positions = filter(i -> NCBITaxonomy.names_table.tax_id[i] in id, eachindex(NCBITaxonomy.names_table.tax_id))
    tdf = NCBITaxonomy.names_table[positions,:]
    scientific_names = findall(tdf.class .== Symbol("scientific name"))
    return [NCBITaxon(r.name, r.tax_id) for r in eachrow(tdf[scientific_names,:])]
end

"""
TODO
"""
function children(t::NCBITaxon)
    c = _children_nodes(t.id)
    return _taxa_from_id(c)
end

"""
TODO
"""
function descendants(t::NCBITaxon)
    c = _descendant_nodes(t.id)
    return _taxa_from_id(c)
end
