module TestInPartNames

using NCBITaxonomy
using Test

# NOTE the @test_throws does not work with annotated strings!
@test_throws NameHasMultipleMatches taxon("Reptilia")
@test_throws NameHasMultipleMatches taxon("Mus")
@test_throws NameHasNoDirectMatch taxon("This is not a name")

end
