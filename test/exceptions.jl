module TestInPartNames

using NCBITaxonomy
using Test

# NOTE the @test_throws does not work with annotated strings!
@test_throws MultipleNamesMatched taxon("Reptilia")

end
