module TestDivisionFinders

    using Test
    using NCBITaxonomy

    @test typeof(virusfinder()("Ebolavirus")) <: NCBITaxon
    @test typeof(plantfinder()("Acer")) <: NCBITaxon
    @test isnothing(mammalfinder(false)("Homo"))
    @test isnothing(vertebratefinder(false)("Homo"))
    @test !isnothing(vertebratefinder(true)("Homo"))
    @test !isnothing(vertebratefinder(true)("Homo"))
    @test !isnothing(bacteriafinder()("Pseudomonas"))
    @test !isnothing(invertebratefinder()("Lamellodiscus"))

end