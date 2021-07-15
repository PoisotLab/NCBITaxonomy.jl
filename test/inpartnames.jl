module TestInPartNames

using NCBITaxonomy
using Test

@test_throws NCBIMultipleMatchesException ncbi"Reptilia"

end
