module TestTaxon
    using Test
    using NCBITaxonomy
    using StringDistances

    # Match with a known ID
    taxon(1234567) == NCBITaxon("Exiligada punctata", 1234567)

    # Strict matching with a scientific name
    bos = taxon("Bos taurus")
    @test typeof(bos) == NCBITaxon
    @test bos.name == "Bos taurus"
    @test bos.id == 9913

    # Strict matching with a vernacular name
    cow = taxon("cow")
    @test typeof(cow) == NCBITaxon
    @test cow.name == "Bos taurus"
    @test cow.id == 9913

    # Test show method
    @test sprint(io -> show(io, cow)) == "Bos taurus (ncbi:9913)"

    # Fuzzy matching with a scientific name
    box = taxon("Box taurus"; strict=false)
    @test typeof(box) == NCBITaxon
    @test box.name == "Bos taurus"
    @test box.id == 9913

    # Fuzzy matching with a scientific name and a custom distance
    box = taxon("Box taurus"; strict=false, dist=StringDistances.DamerauLevenshtein)
    @test typeof(box) == NCBITaxon
    @test box.name == "Bos taurus"
    @test box.id == 9913

    # A species that doesn't exist returns nothing
    fake = taxon("Notus existingensis") # Sweet lord
    @test isnothing(fake)

    #Vernacular name
    chub = vernacular(ncbi"Leuciscus cephalus")
    @test "European chub" in chub
    @test "chub" in chub
    
    # Vernacular missing
    @test isnothing(vernacular(ncbi"Lamellodiscus elegans"))

    # Synonyms
    @test "Bos bovis" in synonyms(ncbi"Bos taurus")
    @test isnothing(synonyms(ncbi"Lamellodiscus elegans"))

end
