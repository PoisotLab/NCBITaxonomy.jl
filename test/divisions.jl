module TestDivisionFinders

    using Test
    using NCBITaxonomy

    @test typeof(virusfinder()("Ebolavirus")) <: NCBITaxon
    @test typeof(plantfinder()("Acer")) <: NCBITaxon
    @test isnothing(mammalfinder(false)("Homo"))
    @test isnothing(mammalfinder(false)("Mus"))
    @test !isnothing(mammalfinder(true)("Mus"))
    @test !isnothing(rodentfinder()("Mus"))
    @test isnothing(vertebratefinder(false)("Homo"))
    @test !isnothing(vertebratefinder(true)("Homo"))
    @test !isnothing(primatefinder()("Homo"))
    @test !isnothing(vertebratefinder(true)("Homo"))
    @test !isnothing(bacteriafinder()("Pseudomonas"))
    @test !isnothing(invertebratefinder()("Lamellodiscus"))

end