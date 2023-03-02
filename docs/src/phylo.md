# Use-case: taxonomic tree

In this exmaple, we will use the output of the `lineage` function to build a
tree in the `Phylo.jl` package, then plot it. This example also serves as a
showcase for the support of `AbstractTrees.jl`.

```@example tree
using Plots
using Phylo
using NCBITaxonomy
using AbstractTrees
```

We will focus on the Lemuriformes infra-order:

```@example tree
tree_root = ncbi"Lemuriformes"
```

We will first create a tree by adding the species as tips -- some of the taxa
are sub-species, but that's OK (we will visualize it later anyways). Because 

```@example tree
sponke = filter(t -> rank(t) == :species, monken)
tree = RootedTree([sp.name for sp in sponke])
```

The next step is to look at the lineage of all taxa, and add the required nodes
and connections between them. We are setting a value of 1.0 as the distance
between two taxonomic ranks, which might not be the best choice, but this is for
illustration only.

```@example tree
for sp in sponke
    lin = lineage(sp; stop_at=monke)
    for i in 1:(length(lin)-1)
        hasnode(tree, lin[i].name) || createnode!(tree, lin[i].name)
        hasnode(tree, lin[i+1].name) || createnode!(tree, lin[i+1].name)
        hasinbound(tree, lin[i+1].name) || createbranch!(tree, lin[i].name, lin[i+1].name, 1.0)
    end
end
```

We can finally plot the tree:

```@example tree
plot(tree, treetype=:fan)
```