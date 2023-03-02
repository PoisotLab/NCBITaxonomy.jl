# Use-case: taxonomic tree

In this exmaple, we will use the output of the `lineage` function to build a
tree in the `Phylo.jl` package, then plot it. This example also serves as a
showcase for the support of `AbstractTrees.jl`.

```@example tree

using Phylo
using NCBITaxonomy
using AbstractTrees
```

We will focus on the Lemuriformes infra-order:

```@example tree
tree_root = ncbi"Lemuriformes"
```

We will first create a tree by adding the species as tips -- some of the taxa
are sub-species, but that's OK (we will visualize it later anyways). Because we
support the AbstractTrees interface, we can use the `Leaves` iterator here:

```@example tree
tree_leaves = collect(Leaves(tree_root))
```

We can double-check that these taxa all have the correct common ancestor:

```@example treee
commonancestor(tree_leaves)
```

At this point, we can start creating our tree object:

```@example treee
tree = RootedTree([sp.name for sp in tree_leaves])
```

The next step is to look at the lineage of all taxa, and add the required nodes
and connections between them. We are setting a value of 1.0 as the distance
between two taxonomic ranks, which might not be the best choice, but this is for
illustration only. Note that we use the `PostOrderDFS` tree iteration, which
guarantees that children will be visited before the parents, so we can then use
the `children` function to get the relationships.

```@example tree
for node in AbstractTrees.PostOrderDFS(tree_root)
    hasnode(tree, node.name) || createnode!(tree, node.name)
    sub_nodes = AbstractTrees.children(node)
    if ~isempty(sub_nodes)
        for sub_node in sub_nodes
            createbranch!(tree, node.name, sub_node.name, 1.0)
        end
    end
end
```

We can finally plot the tree:

```@example tree
plot(tree, treetype=:fan)
```