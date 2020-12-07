module TestTaxid
    using Test
    using NCBITaxonomy
    using StringDistances

    # Strict matching with a scientific name
    bos = taxid("Bos taurus")
    @test typeof(bos) == NCBITaxon
    @test bos.name == "Bos taurus"
    @test bos.id == 9913

    # Strict matching with a vernacular name
    cow = taxid("cow")
    @test typeof(cow) == NCBITaxon
    @test cow.name == "Bos taurus"
    @test cow.id == 9913

    # Test show method
    @test sprint(io -> show(io, cow)) == "Bos taurus (9913)"

    # Fuzzy matching with a scientific name
    box = taxid("Box taurus"; fuzzy=true)
    @test typeof(box) == NCBITaxon
    @test box.name == "Bos taurus"
    @test box.id == 9913

    # Fuzzy matching with a scientific name and a custom distance
    box = taxid("Box taurus"; fuzzy=true, dist=StringDistances.DamerauLevenshtein)
    @test typeof(box) == NCBITaxon
    @test box.name == "Bos taurus"
    @test box.id == 9913

    # A species that doesn't exist returns nothing
    fake = taxid("Notus existingensis") # Sweet lord
    @test isnothing(fake)

    # Verbose fuzzy matching
    chicken = taxid("tchiken"; fuzzy=true, verbose=true)
    @test typeof(chicken) == NCBITaxon

end
