"""
    descendantsfilter(t::NCBITaxon)

Returns a `namefinder` for all taxa below the one given as argument. This
function calls `descendants` internally, so it might not be the optimal way when
dealing with large groups.
"""
function descendantsfilter(t::NCBITaxon)
    desc = collect(AbstractTrees.PostOrderDFS(t))
    return namefilter([d.id for d in desc])
end
