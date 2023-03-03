module TestLineages

    using Test
    using NCBITaxonomy
    using AbstractTrees

    @test AbstractTrees.parent(ncbi"Lamellodiscus") == ncbi"Diplectanidae"

    @test AbstractTrees.lineage(ncbi"Lamellodiscus"; stop_at=ncbi"Dactylogyridea") == reverse([ncbi"Lamellodiscus", ncbi"Diplectanidae", ncbi"Dactylogyridea"])

    @test AbstractTrees.children(ncbi"Lamellodiscus") collect(AbstractTrees.Leaves(ncbi"Lamellodiscus"))

    @test AbstractTrees.intree(ncbi"Lamellodiscus", ncbi"Diplectanidae")

end
