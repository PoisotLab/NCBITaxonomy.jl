var documenterSearchIndex = {"docs":
[{"location":"lineages/#Navigating-lineages","page":"Navigating lineages","title":"Navigating lineages","text":"","category":"section"},{"location":"lineages/#Core-functions","page":"Navigating lineages","title":"Core functions","text":"","category":"section"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"lineage\nAbstractTrees.children\nAbstractTrees.parent\nrank\ntaxonomicdistance!\ncommonancestor","category":"page"},{"location":"lineages/#NCBITaxonomy.lineage","page":"Navigating lineages","title":"NCBITaxonomy.lineage","text":"lineage(tax::NCBITaxon; stop_at::NCBITaxon=ncbi\"root\")\n\nReturns an array of NCBITaxon going up to the root of the taxonomy, or to the optionally specified stop_at taxonomic node.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#AbstractTrees.children","page":"Navigating lineages","title":"AbstractTrees.children","text":"AbstractTrees.children(tax::NCBITaxon)\n\nReturns the children of a taxon.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#AbstractTrees.parent","page":"Navigating lineages","title":"AbstractTrees.parent","text":"AbstractTrees.parent(taxon::NCBITaxon)\n\nReturns the taxon from which the argument taxon is descended.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#NCBITaxonomy.rank","page":"Navigating lineages","title":"NCBITaxonomy.rank","text":"rank(taxon::NCBITaxon)\n\nReturns the rank of a taxon.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#NCBITaxonomy.taxonomicdistance!","page":"Navigating lineages","title":"NCBITaxonomy.taxonomicdistance!","text":"This function fills a pre-allocated square matrix D with the taxonomic distance between taxa in a vector tax. The keywords areguments are d (the distance as a function to closest matching level), strict (a boolean to decide whether the distance of a taxon with itself should be read from the distance dictionary, or set to 0), and other keywords passed to the lineage function.\n\nBecause the distances are symetrical, there are only (n(n-1))/2 measurements to do.\n\nBy default, this function uses the distances from Shimatani (2001):\n\nequal rank distance\nspecies 0\ngenus 1\nfamily 2\nsubclass 3\n:fallback 4\n\nShimatani, K. 2001. On the measurement of species diversity incorporating species differences. Oikos 93:135–147.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#NCBITaxonomy.commonancestor","page":"Navigating lineages","title":"NCBITaxonomy.commonancestor","text":"commonancestor(tax::Vector{NCBITaxon})\n\nReturns the node corresponding to the last common ancestor of taxa in a vector. This function can be useful to speed up the iteration using the AbstractTrees interface, notably to find the right node to use for descendantsfilter.\n\n\n\n\n\ncommonancestor(t1::NCBITaxon, t2::NCBITaxon)\n\nReturns the node corresponding to the last common ancestor of two taxa. This function can be useful to speed up the iteration using the AbstractTrees interface, notably to find the right node to use for descendantsfilter.\n\n\n\n\n\n","category":"function"},{"location":"lineages/#Examples","page":"Navigating lineages","title":"Examples","text":"","category":"section"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"The children function will return a list of NCBITaxon that are immediately descending from the one given as argument. For example, the genus Lamellodiscus contains:","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"using NCBITaxonomy\n\nncbi\"Lamellodiscus\" |> AbstractTrees.children","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"Note that the parent function does the opposite of children:","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"ncbi\"Lamellodiscus kechemirae\" |> AbstractTrees.parent","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"To get the full descendants of a taxon (i.e. the children of its children, recursively), we can use the tree traversal opertions in AbstractTrees, e.g.:","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"AbstractTrees.PostOrderDFS(ncbi\"Diplectanidae\")","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"We can also work upwards in the taxonomy, using the lineage function – it takes an optional stop_at argument, which is the farther up it will go:","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"lineage(ncbi\"Lamellodiscus elegans\"; stop_at=ncbi\"Monogenea\")","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"The rank function is useful to know where in the taxonomy you are:","category":"page"},{"location":"lineages/","page":"Navigating lineages","title":"Navigating lineages","text":"[t => rank(t) for t in lineage(ncbi\"Lamellodiscus elegans\"; stop_at=ncbi\"Monogenea\")]","category":"page"},{"location":"phylo/#Use-case:-taxonomic-tree","page":"Phylo.jl use-case","title":"Use-case: taxonomic tree","text":"","category":"section"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"In this exmaple, we will use the output of the lineage function to build a tree in the Phylo.jl package, then plot it. This example also serves as a showcase for the support of AbstractTrees.jl.","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"using Plots\nusing Phylo\nusing NCBITaxonomy\nusing AbstractTrees","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"We will focus on the Lemuriformes infra-order:","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"tree_root = ncbi\"Lemuriformes\"","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"We will first create a tree by adding the species as tips – some of the taxa are sub-species, but that's OK (we will visualize it later anyways). Because we support the AbstractTrees interface, we can use the Leaves iterator here:","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"tree_leaves = collect(Leaves(tree_root))","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"We can double-check that these taxa all have the correct common ancestor:","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"commonancestor(tree_leaves)","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"At this point, we can start creating our tree object. Before we do this, we will add a few overloads to the Phylo.jl functions:","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"Phylo.RootedTree(taxa::Vector{NCBITaxon}) = RootedTree([t.name for t in taxa])\nPhylo._hasnode(tr::RootedTree, tax::NCBITaxon) = Phylo._hasnode(tr, tax.name)\nPhylo._getnode(tr::RootedTree, tax::NCBITaxon) = Phylo._getnode(tr, tax.name)\nPhylo._createnode!(tr::RootedTree, tax::NCBITaxon) = Phylo._createnode!(tr, tax.name)","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"tree = RootedTree(tree_leaves)","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"The next step is to look at the lineage of all taxa, and add the required nodes and connections between them. We are setting a value of 1.0 as the distance between two taxonomic ranks, which might not be the best choice, but this is for illustration only. Note that we use the PostOrderDFS tree iteration, which guarantees that children will be visited before the parents, so we can then use the children function to get the relationships.","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"for node in AbstractTrees.PostOrderDFS(tree_root)\n    hasnode(tree, node) || createnode!(tree, node)\n    sub_nodes = AbstractTrees.children(node)\n    if ~isempty(sub_nodes)\n        for sub_node in sub_nodes\n            createbranch!(tree, node, sub_node, 1.0)\n        end\n    end\nend","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"We can finally plot the tree:","category":"page"},{"location":"phylo/","page":"Phylo.jl use-case","title":"Phylo.jl use-case","text":"sort!(tree, rev=true)\nPlots.plot(tree, treetype=:fan)","category":"page"},{"location":"portal/#Use-case:-the-portal-data","page":"Portal data use-case","title":"Use-case: the portal data","text":"","category":"section"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"In this example, we will use NCBITaxonomy to validate the names of the species used in the Portal teaching dataset:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"Ernest, Morgan; Brown, James; Valone, Thomas; White, Ethan P. (2017): Portal Project Teaching Database. figshare. https://doi.org/10.6084/m9.figshare.1314459.v6","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"We will download a list of species from figshare, which is given as a JSON file:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"using NCBITaxonomy\nusing DataFrames\nusing JSON\nusing StringDistances\n\nspecies_file = download(\"https://ndownloader.figshare.com/files/3299486\")\nspecies = JSON.parsefile(species_file)","category":"page"},{"location":"portal/#Cleaning-up-the-portal-names","page":"Portal data use-case","title":"Cleaning up the portal names","text":"","category":"section"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"There are two things we want to do at this point: extract the species names from the file, and then validate that they are spelled correctly, or that they are the most recent taxonomic name according to NCBI.","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"The portal data are already identified as belonging to a group of taxa, so we can get a unique list of them:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"taxo_groups = unique([tax[\"taxa\"] for tax in species])","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"We will store our results in a data frame:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"cleanup = DataFrame(\n    code = String[],\n    portal = String[],\n    name = String[],\n    rank = Symbol[],\n    order = String[],\n    taxid = Int[],\n    same = Bool[],\n    fuzzy = Bool[]\n)","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"The next step is to loop through the species, and figure out what to do with them:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"for sp in species\n    portal_name = sp[\"species\"] == \"sp.\" ? sp[\"genus\"] : sp[\"genus\"]*\" \"*sp[\"species\"]\n    local ncbi_tax\n    local fuzzy = false\n    try\n        ncbi_tax = taxon(portal_name)\n    catch y\n        if isa(y, NameHasNoDirectMatch)\n            fuzzy = true\n            ncbi_tax = taxon(portal_name; strict=false)\n        else\n            continue\n        end\n    end\n    ncbi_lin = lineage(ncbi_tax)\n    push!(cleanup,\n        (\n            sp[\"species_id\"], portal_name, ncbi_tax.name, rank(ncbi_tax),\n            first(filter(t -> isequal(:order)(rank(t)), lineage(ncbi_tax))).name,\n            ncbi_tax.id, portal_name == ncbi_tax.name, fuzzy\n        )\n    )\nend\n\nfirst(cleanup, 5)","category":"page"},{"location":"portal/#Looking-at-species-with-a-name-discrepancy","page":"Portal data use-case","title":"Looking at species with a name discrepancy","text":"","category":"section"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"Finally, we can look at the codes for which there is a likely issue because the names do not match – this can be because of new names, improper use of vernacular, or spelling issues:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"filter(r -> r.portal != r.name, cleanup)","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"Out of these, some required to use fuzzy matching to get a proper name, so we can look at there taxa, as they are likely to require manual curation:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"filter(r -> r.fuzzy, cleanup)","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"Out of these, only Lizard has a strange identification as a Hemiptera:","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"filter(t -> isequal(:class)(rank(t)), lineage(ncbi\"Lisarda\"))","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"Right. We can dig into this example a little more, because it shows how much data entry can condition the success of name finding.","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"similarnames(\"Lizard\"; threshold=0.7)","category":"page"},{"location":"portal/","page":"Portal data use-case","title":"Portal data use-case","text":"The Lisarda taxon (which is an insect!) is the closest match, simply because \"Lizards\" is not a classification we can use – lizards are a paraphyletic group, containing a handful of different groups. Based on the information available, the only information we can say about the taxon identified as \"Lizards\" is that it belongs to Squamata.","category":"page"},{"location":"#NCBITaxonomy","page":"Index","title":"NCBITaxonomy","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"This package provides an interface to the NCBI Taxonomy. When installed, it will download the latest version of the taxonomy files from the NCBI ftp service. To update the version of the taxonomy you use, you need to build the package again. This package is developed as part of the activities of the Viral Emergence Research Initiative (VERENA) consortium, with financial support from the Institut de Valorisation des Données (IVADO) at Université de Montréal.","category":"page"},{"location":"#Overview-of-capacities","page":"Index","title":"Overview of capacities","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"retrieval of names from the taxonomy\nlisting of children and descendant taxa\nfuzzy matching of names\ntaxonomic distance measurement based on Shimatani distance","category":"page"},{"location":"#How-does-it-work?","page":"Index","title":"How does it work?","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Internally, the package relies on the files provided by NCBI to reconstruct the taxonomy – the README for what the files contain can be found here. Note that the files and their expected MD5 checksum are downloaded when the package is built, and the data are not extracted unless the checksum matches. The package will also check that the checksum on the server is different from the version on disk, to avoid downloading data for nothing.","category":"page"},{"location":"","page":"Index","title":"Index","text":"Data are saved as arrow tables when the package is built, and these are loaded when the package is loaded with import or using, as DataFrames. These data frames are not exported, but they are used by the various function of the package. Note also that a number of fields are removed, and some tables are pre-merged - not at build time (so there is no information loss, and you are welcome to dig into the full data frame by reloading the arrow file), but at load time.","category":"page"},{"location":"","page":"Index","title":"Index","text":"Please note that the taxonomy dump is a big download. If the NCBITAXONOMY_PATH is not set, it will be stored in the package folder under the .julia directory, which is a bad idea. We strongly recommend editing your configuration file.","category":"page"},{"location":"","page":"Index","title":"Index","text":"The package will check that the local version of the taxonomy file is sufficiently recent (no older than about 30 days), and if this is not the case, will prompt the user to update to a more recent version.","category":"page"},{"location":"namefinding/#Finding-taxa","page":"Finding taxa","title":"Finding taxa","text":"","category":"section"},{"location":"namefinding/#The-taxon-function","page":"Finding taxa","title":"The taxon function","text":"","category":"section"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"taxon\nvernacular\nsynonyms\nauthority\nalternativetaxa\nsimilarnames","category":"page"},{"location":"namefinding/#NCBITaxonomy.taxon","page":"Finding taxa","title":"NCBITaxonomy.taxon","text":"taxon(df::DataFrame, id::Integer)\n\nReturns a fully formed NCBITaxon based on its id. The name of the taxon will be the valid scientic name associated to this id.\n\n\n\n\n\ntaxon(id::Integer)\n\nPerforms a search in the entire taxonomy backbone based on a known ID.\n\n\n\n\n\ntaxon(name::AbstractString; kwargs...)\n\nThe taxon function is the core entry point in the NCBI taxonomy. It takes a string, and a series of keywords, and go look for this taxon in the dataframe (by default the entire names table).\n\nThe keywords are:\n\nstrict (def. true), allows fuzzy matching\ndist (def. Levenshtein), the string distance function to use\ncasesensitive (def. true), whether to strict match on lowercased names\nrank (def. nothing), the taxonomic rank to limit the search\npreferscientific (def. false), whether scientific names are prefered when the query also matches non-scientific names (synonyms, vernaculars, blast names, ...) - this is most likely useful when paired with casesensitive=true, and is not working with strict=false\nonlysynonyms (def. false) - limits the search to synonyms, which may be useful in case the taxonomy is particularly outdated\n\n\n\n\n\ntaxon(df::DataFrame, name::AbstractString; kwargs...)\n\nAdditional method for taxon with an extra dataframe argument, used most often with a namefinder. Accepts the usual taxon keyword arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.vernacular","page":"Finding taxa","title":"NCBITaxonomy.vernacular","text":"vernacular(t::NCBITaxon)\n\nThis function will return nothing if no vernacular name is known, and an array of names if found. It searches the \"common name\" and \"genbank common name\" category of the NCBI taxonomy name table.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.synonyms","page":"Finding taxa","title":"NCBITaxonomy.synonyms","text":"synonyms(t::NCBITaxon)\n\nThis function will return nothing if no synonyms exist, and an array of names if they do. It returns all of the\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.authority","page":"Finding taxa","title":"NCBITaxonomy.authority","text":"authority(t::NCBITaxon)\n\nThis function will return nothing if no authority exist, and a string with the authority if found.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.alternativetaxa","page":"Finding taxa","title":"NCBITaxonomy.alternativetaxa","text":"alternativetaxa(df::DataFrame, name::AbstractString)\n\nGeneric version of alternativetaxa with an arbitrary data frame\n\n\n\n\n\nalternativetaxa(name::AbstractString)\n\nReturns an array of taxa that share the same name – note that this function does strict, case-sensitive searches only at the moment, but this may be extended through keyword arguments in a future release.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.similarnames","page":"Finding taxa","title":"NCBITaxonomy.similarnames","text":"similarnames(name::AbstractString)\n\nReturns a list (as a vector of pairs) mapping an NCBI taxon to a similarity score for the name given as argument.\n\nNote that the function can return the same taxon more than once with different scores, because it will look through the entire list of names, and not only the scientific ones.\n\nIt may also return multiple taxa with the same score if the names are ambiguous, in which case all alternative are given.\n\nThat being said, the taxa/score pairs will always be equal. For example, the string \"mouse\" will match both the vernacular for Bryophyta (\"mosses\") and its synonym (\"Musci\") with an equal dissimilarity under the Levenshtein distance - the pair will be returned only once.\n\nAdditional keywords are rank (limit to a given rank) and onlysynonyms.\n\n\n\n\n\nsimilarnames(df::DataFrame, name::AbstractString; dist::Type{SD}=Levenshtein, threshold::Float64=0.8) where {SD <: StringDistance}\n\nGeneric version of similarnames\n\n\n\n\n\n","category":"function"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"The taxon function will return a NCBITaxon object, which has two fields: name and id. We do not return the class attribute, because the package will always return the scientific name, as the examples below illustrate:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"using NCBITaxonomy\ntaxon(\"Bos taurus\")","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"There is a convenience string macro to replace the taxon function:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"ncbi\"Bos taurus\"","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"Note that because the names database contains vernacular and deprecated names, the scientific name will be returned, no matter what you search","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"taxon(\"cow\")","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"This may be a good point to note that we can use the vernacular function to get a list of NCBI-known vernacular names:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"taxon(\"cow\") |> vernacular","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"It also work with authorities:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"taxon(\"cow\") |> authority","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"You can pass an additional strict=false keyword argument to the taxon function to perform fuzzy name matching using the Levenshtein distance:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"taxon(\"Paradiplozon homion\", strict=false)","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"Note that fuzzy searching comes at a performance cost, so it is preferable to use the strict matching unless necessary. As a final note, you can specify any distance function from the StringDistances package, using the dist argument.","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"Some valid names refer to more than one entry in the NCBI taxonomy. This is, for example, the case for Mus (the genus and the sub-genus):","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"alternativetaxa(\"Mus\")","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"In some cases, the fuzzy matched name may not be the one you want. There is a function to get the names ordered by similarity:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"similarnames(\"mouse\"; threshold=0.6)","category":"page"},{"location":"namefinding/#Errors","page":"Finding taxa","title":"Errors","text":"","category":"section"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"NameHasNoDirectMatch\nNameHasMultipleMatches","category":"page"},{"location":"namefinding/#NCBITaxonomy.NameHasNoDirectMatch","page":"Finding taxa","title":"NCBITaxonomy.NameHasNoDirectMatch","text":"NameHasNoDirectMatch\n\nThis exception is thrown when the name passed as an argument does not have a direct match, in which case using strict=false to switch to fuzzy matching may be advised.\n\n\n\n\n\n","category":"type"},{"location":"namefinding/#NCBITaxonomy.NameHasMultipleMatches","page":"Finding taxa","title":"NCBITaxonomy.NameHasMultipleMatches","text":"NameHasMultipleMatches\n\nThis exception is thrown when the name is an \"in-part\" name, which is not a valid node but an aggregation of multiple nodes. It is also thrown when the name is valid for several nodes. The error message will return the taxa that could be used instead. \"Reptilia\" is an example of a node that will throw this exception (in-part name); \"Mus\" will throw this example as it is valid subgenus of itself.\n\nNote that the error object has a taxa field, which stores the NCBITaxon that were matched; this allows to catch the error and look for the taxon you want without relying on e.g. alternativetaxa.\n\n\n\n\n\n","category":"type"},{"location":"namefinding/#Building-a-better-namefilter","page":"Finding taxa","title":"Building a better namefilter","text":"","category":"section"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"The taxon function, by default, searches in the entire names table. In many cases, we can restrict the scope of the search quite a lot by searching only in the range of names that match a given condition. For this reason, the taxon function also has a method with a first argument being a data frame of names. These are generated using namefilter, as well as a varitety of helper functions.","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"namefilter","category":"page"},{"location":"namefinding/#NCBITaxonomy.namefilter","page":"Finding taxa","title":"NCBITaxonomy.namefilter","text":"namefilter(ids::Vector{T}) where {T <: Integer}\n\nReturns a subset of the names table where only the given taxids are present.\n\n\n\n\n\nnamefilter(taxa::Vector{NCBITaxon})\n\nReturns a subset of the names table dataset, where the taxids of the taxa are present. This includes all names, not only the scientific names.\n\n\n\n\n\nnamefilter(division::Symbol)\n\nReturns a subset of the names table for all names under a given NCBI division.\n\n\n\n\n\nnamefilter(division::Vector{Symbol})\n\nReturns a subset of the names table for all names under a number of multiple NCBI divisions.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"Here is an illustration of why using namefilters makes sense. Let's say we have to search for a potentially misspelled name:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"@time taxon(\"Ebulavurus\"; strict=false);","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"We can use the virusfilter() function to generate a table with viruses only:","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"viruses = virusfilter()\n@time taxon(viruses, \"Bumbulu ebolavirus\"; strict=false);","category":"page"},{"location":"namefinding/#Standard-namefilters","page":"Finding taxa","title":"Standard namefilters","text":"","category":"section"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"To save some time, there are namefilters pre-populated with the large-level taxonomic divisions.","category":"page"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"bacteriafilter\nvirusfilter\nmammalfilter\nvertebratefilter\nplantfilter\ninvertebratefilter\nrodentfilter\nprimatefilter\nphagefilter\nenvironmentalsamplesfilter","category":"page"},{"location":"namefinding/#NCBITaxonomy.bacteriafilter","page":"Finding taxa","title":"NCBITaxonomy.bacteriafilter","text":"bacteriafilter()\n\nReturns a namefinder limited to the bacterial division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.virusfilter","page":"Finding taxa","title":"NCBITaxonomy.virusfilter","text":"virusfilter()\n\nReturns a namefinder limited to the viral division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments. Note that phage are covered by phagefinder.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.mammalfilter","page":"Finding taxa","title":"NCBITaxonomy.mammalfilter","text":"mammalfilter(;inclusive::Bool=true)\n\nReturns a namefinder limited to the mammal division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\nIf the keyword argument inclusive is set to false, this will not search for organisms assigned to a lower division, in this case rodents (covered by rodentfinder) and primates (covered by primatefinder). The default behavior is to include these groups.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.vertebratefilter","page":"Finding taxa","title":"NCBITaxonomy.vertebratefilter","text":"vertebratefilter(;inclusive::Bool=true)\n\nReturns a namefinder limited to the vertebrate division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\nIf the keyword argument inclusive is set to false, this will not search for organisms assigned to a lower division, in this case mammals (covered by mammalfinder). The default behavior is to include these groups, which also include the groups covered by mammalfinder itself.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.plantfilter","page":"Finding taxa","title":"NCBITaxonomy.plantfilter","text":"plantfilter()\n\nReturns a namefinder limited to the \"plant and fungi\" division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.invertebratefilter","page":"Finding taxa","title":"NCBITaxonomy.invertebratefilter","text":"invertebratefilter()\n\nReturns a namefinder limited to the invertebrate division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\nNote that this is limited organisms not covered by plantfinder, bacteriafinder, and virusfinder.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.rodentfilter","page":"Finding taxa","title":"NCBITaxonomy.rodentfilter","text":"rodentfilter()\n\nReturns a namefinder limited to the rodent division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.primatefilter","page":"Finding taxa","title":"NCBITaxonomy.primatefilter","text":"primatefilter()\n\nReturns a namefinder limited to the primate division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.phagefilter","page":"Finding taxa","title":"NCBITaxonomy.phagefilter","text":"phagefilter()\n\nReturns a namefinder limited to the phage division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/#NCBITaxonomy.environmentalsamplesfilter","page":"Finding taxa","title":"NCBITaxonomy.environmentalsamplesfilter","text":"environmentalsamplesfilter()\n\nReturns a namefinder limited to the environmental samples division of the NCBI taxonomy. See the documentation for namefinder and taxid for more information about arguments.\n\n\n\n\n\n","category":"function"},{"location":"namefinding/","page":"Finding taxa","title":"Finding taxa","text":"All of these return a dataframe which can be passed to the taxon function as a first argument.","category":"page"}]
}
