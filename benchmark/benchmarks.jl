using BenchmarkTools
using NCBITaxonomy

const SUITE = BenchmarkGroup()

SUITE["name_finders"] = BenchmarkGroup(["namefinding", "utilities"])
SUITE["name_finders"]["mammals_build"] = @benchmarkable mammalfilter()

mf = mammalfilter()

SUITE["taxonsearch"] = BenchmarkGroup(["namefinding", "search"])
SUITE["taxonsearch"]["from_id"] = @benchmarkable taxon(9823)
SUITE["taxonsearch"]["from_name"] = @benchmarkable taxon("Sus scrofa")
SUITE["taxonsearch"]["with_finder"] = @benchmarkable taxon(mf, "Sus scrofa")