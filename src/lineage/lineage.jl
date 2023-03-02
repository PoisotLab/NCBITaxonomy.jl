"""
    lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi"root")

Returns an array of `NCBITaxon` going up to the root of the taxonomy, or to the
optionally specified `stop_at` taxonomic node.
"""
function lineage(tax::NCBITaxon; stop_at::NCBITaxon = ncbi"root")
    full_lineage = [tax]
    while last(full_lineage) != stop_at
        push!(full_lineage, AbstractTrees.parent(last(full_lineage)))
    end
    return reverse(full_lineage)
end

"""
    commonancestor(tax::Vector{NCBITaxon})

Returns the node corresponding to the last common ancestor of taxa in a vector.
This function can be useful to speed up the iteration using the AbstractTrees
interface, notably to find the right node to use for `descendantsfilter`.
"""
function commonancestor(tax::Vector{NCBITaxon})
    
end