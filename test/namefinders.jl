module TestNamefinders

    using Test
    using NCBITaxonomy

    dipl = descendants(ncbi"Diplectanidae")

    lam = taxon(namefilter(dipl), "Lamellodiscus elegans")

    @test typeof(lam) == NCBITaxon
    @test lam.name == "Lamellodiscus elegans"

    dipl_2 = namefilter(descendants(ncbi"Diplectanidae"))

    @test !isnothing(taxon(dipl_2, "Lamellodiscus elegans"))
    @test_throws NameHasNoDirectMatch taxon(dipl_2, "Gallus gallus")

end
