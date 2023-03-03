module TestNamefinders

using Test
using NCBITaxonomy
using AbstractTrees

dipl = collect(AbstractTrees.PreOrderDFS(ncbi"Diplectanidae"))

@test taxon(namefilter(dipl), "Lamellodiscus elegans") == ncbi"Lamellodiscus elegans"
@test taxon(namefilter(dipl), "Lamellodiscus") == ncbi"Lamellodiscus"
@test_throws NameHasNoDirectMatch taxon(namefilter(dipl), "Gallus gallus")

end
