using Revise
using BenchmarkTools
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

sps =
    taxon.([
        "Paradiplozoon",
        "Dactylogyrus",
        "Gyrodactylus",
        "Diplectanum",
        "Echinoplectanum",
        "Diplozoon",
        "Paradiclybothrium"
    ])

@benchmark commonancestor(sps[1], sps[2])

@btime commonancestor(sps)

@profview lineage(tax)