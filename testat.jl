using Revise
using NCBITaxonomy
using AbstractTrees

tax = ncbi"Lamellodiscus"

AbstractTrees.children(tax)
AbstractTrees.parent(tax)
AbstractTrees.prevsibling(tax)
AbstractTrees.nextsibling(tax) >
AbstractTrees.isroot(ncbi"root")
AbstractTrees.isroot(ncbi"Procyon")

AbstractTrees.intree(ncbi"Lamellodiscus elegans", ncbi"Diplectanidae")

sps =
    taxon.([
        "Procyon lotor",
        "Didelphidae",
        "Ursus americanus",
        "Giraffa camelopardalis",
        "Balaenoptera acutorostrata",
    ])

commonancestor(sps[1], sps[2])
commonancestor(sps)

