using Revise
using NCBITaxonomy
using AbstractTrees

tax = ncbi"Lamellodiscus"

AbstractTrees.children(tax)
AbstractTrees.parent(tax)
AbstractTrees.prevsibling(tax)
AbstractTrees.nextsibling(tax)

AbstractTrees.isroot(ncbi"root")
AbstractTrees.isroot(ncbi"Procyon")

AbstractTrees.intree(ncbi"Lamellodiscus elegans", ncbi"Diplectanidae")