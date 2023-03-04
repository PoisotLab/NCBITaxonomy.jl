module TestSynonymsIssues

using Test
using NCBITaxonomy

@test_throws NameHasMultipleMatches taxon("gorilla"; casesensitive = false)
@test isa(taxon("gorilla"; casesensitive = false, preferscientific = true), NCBITaxon)

@test authority(ncbi"Lamellodiscus kechemirae") ==
      "Lamellodiscus kechemirae Amine & Euzet, 2005"

end