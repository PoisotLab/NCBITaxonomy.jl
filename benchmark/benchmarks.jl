using BenchmarkTools
using NCBITaxonomy
using AbstractTrees

const SUITE = BenchmarkGroup()

# Construction of name finders

SUITE["name finders"] = BenchmarkGroup(["namefinding", "utilities"])

SUITE["name finders"]["mammals"] = @benchmarkable mammalfilter(false)

SUITE["name finders"]["mammals (inclusive)"] =
    @benchmarkable mammalfilter(inclusive = true)

SUITE["name finders"]["phage"] = @benchmarkable phagefilter(true)

# Prepare a mammal filter next
mf = mammalfilter()

# Ability to locate taxa

SUITE["taxon search"] = BenchmarkGroup(["namefinding", "search"])

SUITE["taxon search"]["by ID"] = @benchmarkable taxon(9823)

SUITE["taxon search"]["by name"] = @benchmarkable taxon("Sus scrofa")

SUITE["taxon search"]["with finder"] = @benchmarkable taxon(mf, "Sus scrofa")

SUITE["taxon search"]["lowercase with finder"] =
    @benchmarkable taxon(mf, "Sus scrofa"; lowercase = true)

SUITE["taxon search"]["scientific with finder"] =
    @benchmarkable taxon(mf, "Sus scrofa"; preferscientific = true)

# Ability to traverse a tree

SUITE["traversal"] = BenchmarkGroup(["search", "tree traversal"])

SUITE["traversal"]["children"] = @benchmarkable AbstractTrees.children(ncbi"Monogenea")

SUITE["traversal"]["parent"] = @benchmarkable AbstractTrees.parent(ncbi"Monogenea")

SUITE["traversal"]["in root"] =
    @benchmarkable AbstractTrees.inroot(ncbi"Lamellodiscus elegans", ncbi"Monogenea")

SUITE["traversal"]["lineage"] = @benchmarkable lineage(ncbi"Lamellodiscus ignoratus")

SUITE["traversal"]["common ancestor (pair)"] =
    @benchmarkable commonancestor(ncbi"Lamellodiscus", ncbi"Dactylogyrus")

SUITE["traversal"]["common ancestor (array)"] = @benchmarkable commonancestor([
    ncbi"Lamellodiscus",
    ncbi"Dactylogyrus",
    ncbi"Paradiplozoon",
    ncbi"Diplectanum",
    ncbi"Echinoplectanum",
])
