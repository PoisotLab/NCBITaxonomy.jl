using Documenter, NCBITaxonomy, AbstractTrees

makedocs(;
    sitename = "NCBITaxonomy",
    authors = "Timothée Poisot",
    modules = [NCBITaxonomy],
    warnonly = true,
    pages = [
        "Index" => "index.md",
        "Finding taxa" => "namefinding.md",
        "Navigating lineages" => "lineages.md",
        "Portal data use-case" => "portal.md",        
    ],
)

deploydocs(;
    deps = Deps.pip("pygments", "python-markdown-math"),
    repo = "github.com/PoisotLab/NCBITaxonomy.jl.git",
    devbranch = "main",
    push_preview = true,
)
