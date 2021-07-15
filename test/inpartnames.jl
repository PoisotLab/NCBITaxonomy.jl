module TestInPartNames

using NCBITaxonomy
using Test

# Test that an in-part name returns an error

inpartname = "Reptilia" # This is three different taxa

@test_throws NCBITaxonomy.NCBIMultipleMatchesException ncbi"Reptilia"

end
