"""
    lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")

Returns an array of `NCBITaxon` going up to the root of the taxonomy, or to the
optionally specified `stop_at` taxonomic node.
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon = ncbi"root", prealloc::Int=100)
    full_lineage = Vector{NCBITaxon}(undef, prealloc)
    full_lineage[1] = tax
    idx = 1
    while idx < length(full_lineage)
        full_lineage[idx + 1] = AbstractTrees.parent(full_lineage[idx])
        idx += 1
        isequal(stop_at)(full_lineage[idx]) && break
    end
    return reverse(full_lineage[1:idx])
end

"""
    commonancestor(tax::Vector{NCBITaxon})

Returns the node corresponding to the last common ancestor of taxa in a vector.
This function can be useful to speed up the iteration using the AbstractTrees
interface, notably to find the right node to use for `descendantsfilter`.
"""
function commonancestor(tax::Vector{NCBITaxon})
    return reduce(commonancestor, tax)
end

"""
    commonancestor(t1::NCBITaxon, t2::NCBITaxon)

Returns the node corresponding to the last common ancestor of two taxa. This
function can be useful to speed up the iteration using the AbstractTrees
interface, notably to find the right node to use for `descendantsfilter`.
"""
function commonancestor(t1::NCBITaxon, t2::NCBITaxon)
    # We start by looking up the lineage of the second argument, because in the
    # vectorized version, t1 will be the already identified common ancestor of
    # the previous taxa. This can cut execution time in half for closely related
    # taxa.
    l2 = lineage(t2)
    if t1 in l2
        return t1
    else
        l1 = lineage(t1)
        common = last(l1 ∩ l2)
        return common
    end
end