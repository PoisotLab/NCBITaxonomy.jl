module TestDivisionFilters

    using Test
    using NCBITaxonomy

    @test typeof(taxon(virusfilter(), "Ebolavirus")) <: NCBITaxon
    @test typeof(taxon(plantfilter(), "Acer")) <: NCBITaxon
   
    @test_throws NameHasNoDirectMatch taxon(mammalfilter(false), "Homo")
    @test_throws NameHasNoDirectMatch taxon(mammalfilter(false), "Mus musculus")
    @test_throws NameHasNoDirectMatch taxon(vertebratefilter(false), "Homo")
    
    @test typeof(taxon(vertebratefilter(true), "Homo")) <: NCBITaxon
    @test typeof(taxon(primatefilter(), "Homo")) <: NCBITaxon
    @test typeof(taxon(vertebratefilter(true), "Homo")) <: NCBITaxon
    @test typeof(taxon(bacteriafilter(), "Pseudomonas")) <: NCBITaxon
    @test typeof(taxon(invertebratefilter(), "Lamellodiscus")) <: NCBITaxon
    @test typeof(taxon(mammalfilter(true), "Mus musculus")) <: NCBITaxon
    @test typeof(taxon(rodentfilter(), "Mus musculus")) <: NCBITaxon

end
