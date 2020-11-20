module TestRank

    using Test
    using NCBITaxonomy

    @test rank(ncbi"Vulpes") == :genus
    @test rank(ncbi"Vulpes vulpes") == :species
    @test parent(ncbi"Vulpes vulpes") == ncbi"Vulpes"

end