function _children_nodes(id::T) where {T <: Int}
    nds = @where(NCBITaxonomy.nodes_table, :parent_tax_id .== id)
    return nds.tax_id
end

function _children_nodes(id::Vector{T}) where {T <: Int}
    return vcat(_children_nodes.(id)...)
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
    valid_names_rows = findall(vec(any(NCBITaxonomy.names_table.tax_id .∈ id'; dims=2)))
    nms = @where(NCBITaxonomy.names_table[valid_names_rows,:], :class .== Symbol("scientific name"))
    return [NCBITaxon(r.name, r.tax_id) for r in eachrow(nms)]
end

function children(t::NCBITaxon)
    c = _children_nodes(t.id)
    return _taxa_from_id(c)
end

function descendants(t::NCBITaxon)
    c = _descendant_nodes(t.id)
    return _taxa_from_id(c)
end
