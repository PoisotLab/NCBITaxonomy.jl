module TestLineages

    using Test
    using NCBITaxonomy

    @test lineage(ncbi"Lamellodiscus"; stop_at=ncbi"Dactylogyridea") == reverse([ncbi"Lamellodiscus", ncbi"Diplectanidae", ncbi"Dactylogyridea"])
    @test children(ncbi"Lamellodiscus") == descendants(ncbi"Lamellodiscus")
    @test ncbi"Lamellodiscus" in descendants(ncbi"Diplectanidae")

end