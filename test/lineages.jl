module TestLineages

using Test
using NCBITaxonomy
using AbstractTrees

@test AbstractTrees.parent(ncbi"Lamellodiscus") == ncbi"Diplectanidae"

@test lineage(ncbi"Lamellodiscus"; stop_at = ncbi"Dactylogyridea") ==
      reverse([ncbi"Lamellodiscus", ncbi"Diplectanidae", ncbi"Dactylogyridea"])

@test AbstractTrees.intree(ncbi"Lamellodiscus", ncbi"Diplectanidae")
@test AbstractTrees.intree(ncbi"Lamellodiscus elegans", ncbi"Lamellodiscus")

@test commonancestor(ncbi"Lamellodiscus", ncbi"Dactylogyrus") == ncbi"Dactylogyridea"
@test commonancestor([
    ncbi"Lamellodiscus",
    ncbi"Dactylogyrus",
    ncbi"Paradiplozoon",
    ncbi"Diplectanum",
    ncbi"Echinoplectanum",
]) == ncbi"Monogenea"

end
