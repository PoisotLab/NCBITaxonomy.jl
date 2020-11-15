using Documenter, NCBITaxonomy

makedocs(
    sitename="NCBITaxonomy",
    authors="Timothée Poisot",
    modules=[NCBITaxonomy],
    pages=["Index" => "index.md"]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/NCBITaxonomy.jl.git",
    devbranch="master",
    push_preview=true
)
