module TestDivisionFilters

    using Test
    using NCBITaxonomy

    @test typeof(taxon(virusfilter(), "Ebolavirus")) <: NCBITaxon
    @test typeof(taxon(plantfilter(), "Acer")) <: NCBITaxon
    @test isnothing(taxon(mammalfilter(false), "Homo"))
    @test isnothing(taxon(mammalfilter(false), "Mus"))
    @test !isnothing(taxon(mammalfilter(true), "Mus"))
    @test !isnothing(taxon(rodentfilter(), "Mus"))
    @test isnothing(taxon(vertebratefilter(false), "Homo"))
    @test !isnothing(taxon(vertebratefilter(true), "Homo"))
    @test !isnothing(taxon(primatefilter(), "Homo"))
    @test !isnothing(taxon(vertebratefilter(true), "Homo"))
    @test !isnothing(taxon(bacteriafilter(), "Pseudomonas"))
    @test !isnothing(taxon(invertebratefilter(), "Lamellodiscus"))

end