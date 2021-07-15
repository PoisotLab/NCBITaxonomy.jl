module NCBITaxonomy
using DataFrames
using Arrow
using StringDistances

if !haskey(ENV, "NCBITAXONOMY_PATH")
    @warn """
    The environmental varialbe NCBITAXONOMY_PATH is not set, so the tables will
    be stored in the package path. This is not ideal, and you really should set
    the NCBITAXONOMY_PATH.
    """
end
const taxpath = get(ENV, "NCBITAXONOMY_PATH", joinpath(@__DIR__, "..", "deps"))
ispath(taxpath) || mkpath(taxpath)

function __init__()
    name_date = mtime(joinpath(taxpath, "tables", "names.arrow"))
    return time() - name_date >= 2.6e+6 && @warn(
        "Your local taxonomy version is over 30 days old, we recommend using `] build NCBITaxonomy` to get the most recent version."
    )
end

include("types.jl")
export NCBITaxon, NCBINameClass

include("exceptions.jl")
export NCBIMultipleMatchesException

names_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "names.arrow")))
names_table.class = NCBINameClass.(names_table.class)

division_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "division.arrow")))
select!(division_table, Not(:comments))

nodes_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "nodes.arrow")))
select!(nodes_table, Not(r"inherited_"))
select!(nodes_table, Not(r"_code_id"))
select!(nodes_table, Not(:genbank_hidden))
select!(nodes_table, Not(:hidden_subtree))
select!(nodes_table, Not(:comments))
select!(nodes_table, Not(:embl))

nodes_table = innerjoin(nodes_table, division_table; on=:division_id)
select!(nodes_table, Not(:division_id))

include("taxon.jl")
export taxon, @ncbi_str

include("namefilters/namefilter.jl")
include("namefilters/divisions.jl")
export namefilter
export bacteriafilter,
    virusfilter,
    mammalfilter,
    vertebratefilter,
    plantfilter,
    invertebratefilter,
    rodentfilter,
    primatefilter,
    environmentalsamplesfilter,
    phagefilter

include("lineage/children.jl")
include("lineage/lineage.jl")
export children, descendants, lineage, parent, rank

include("utility/nametools.jl")
include("utility/taxonomicdistance.jl")
export vernacular, synonyms, authority, taxonomicdistance, taxonomicdistance!

end
