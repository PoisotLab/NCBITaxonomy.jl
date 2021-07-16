module TestInPartNames

using NCBITaxonomy
using Test

@test_throws IDNotFoundInBackbone taxon(1234567890000000000)
@test_throws NameHasMultipleMatches taxon("Reptilia")
@test_throws NameHasMultipleMatches taxon("Mus")
@test_throws NameHasNoDirectMatch taxon("This is not a name")

end
