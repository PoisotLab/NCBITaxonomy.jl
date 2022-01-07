module TestSynonymsIssues

    using Test
    using NCBITaxonomy

    @test_throws NameHasMultipleMatches taxon("gorilla"; casesensitive=false)
    @test isa(taxon("gorilla"; casesensitive=false, preferscientific=true), NCBITaxon)

end