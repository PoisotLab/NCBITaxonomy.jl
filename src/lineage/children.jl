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
    c = _children(id)
    isempty(c) && return id
    return vcat(id, _descendants(c)...)
end

_descendants(ids::Vector{T}) where {T <: Int} = map(_descendants, ids)

"""
    children(t::NCBITaxon)

Returns the node immediately below the taxon given as argument, or `nothing` if
the taxon is terminal.
"""
children(t::NCBITaxon) = taxon.(_children(t.id))

"""
    descendants(t::NCBITaxon)

Recurisvely calls `children` until all terminal nodes under the taxon are
reached. Depending on the taxonomic level, and number of taxa under the taxon
considered, this can be a long function to run.
"""
function descendants(t::NCBITaxon)
    c = _descendants(t.id)
    filter!(!isequal(t.id), c)
    return taxon.(c)
end

"""
    descendantsfinder(t::NCBITaxon)

Returns a `namefinder` for all taxa below the one given as argument. This
function calls `descendants` internally, so it might not be the optimal way when
dealing with large groups.
"""
function descendantsfinder(t::NCBITaxon)
    d = descendants(t)
    df = _df_from_taxlist(d)
    return namefinder(df)
end
