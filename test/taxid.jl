module TestTaxid
    using Test
    using NCBITaxonomy

    bos = taxid("Bos taurus")

    @test typeof(bos) == NCBITaxon
    @test bos.name == "Bos taurus"
    @test bos.id == 9913

    cow = taxid("cow")

    @test typeof(cow) == NCBITaxon
    @test cow.name == "Bos taurus"
    @test cow.id == 9913

end
