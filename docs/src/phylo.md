# Use-case: taxonomic tree

In this example, we will use the output of the `lineage` function to build a
tree in the `Phylo.jl` package, then plot it. This example also serves as a
showcase for the support of `AbstractTrees.jl`.

```@example tree
using Plots
using Phylo
using NCBITaxonomy
using AbstractTrees
```

We will focus on _Lamellodiscus_:

```@example tree
tree_root = ncbi"Lamellodiscus"
```

We will first create a tree by adding the species as tips -- some of the taxa
are sub-species, but that's OK (we will visualize it later anyways). Because we
support the AbstractTrees interface, we can use the `Leaves` iterator here:

```@example tree
tree_leaves = collect(Leaves(tree_root))
```

We can double-check that these taxa all have the correct common ancestor:

```@example tree
commonancestor(tree_leaves)
```

At this point, we can start creating our tree object. Before we do this, we will
add a few overloads to the `Phylo.jl` functions:

```@example tree
Phylo.RootedTree(taxa::Vector{NCBITaxon}) = RootedTree([t.name for t in taxa])
Phylo._matchnodetype(tr::RootedTree, tax::NCBITaxon) = Phylo._matchnodetype(tr, tax.name)
Phylo._hasnode(tr::RootedTree, tax::NCBITaxon) = Phylo._hasnode(tr, tax.name)
Phylo._getnode(tr::RootedTree, tax::NCBITaxon) = Phylo._getnode(tr, tax.name)
Phylo._createnode!(tr::RootedTree, tax::NCBITaxon) = Phylo._createnode!(tr, tax.name)
```

```@example tree
tree = RootedTree(tree_leaves)
```

The next step is to look at the lineage of all taxa, and add the required nodes
and connections between them. We are setting a value of 1.0 as the distance
between two taxonomic ranks, which might not be the best choice, but this is for
illustration only. Note that we use the `PostOrderDFS` tree iteration, which
guarantees that children will be visited before the parents, so we can then use
the `children` function to get the relationships.

```@example tree
for node in AbstractTrees.PostOrderDFS(tree_root)
    hasnode(tree, node) || createnode!(tree, node)
    sub_nodes = AbstractTrees.children(node)
    if ~isempty(sub_nodes)
        for sub_node in sub_nodes
            createbranch!(tree, node, sub_node, 1.0)
        end
    end
end
```

We can finally plot the tree:

```@example tree
sort!(tree, rev=true)
Plots.plot(tree, treetype=:fan)
```
