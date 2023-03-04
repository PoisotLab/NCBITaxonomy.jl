module NCBITaxonomy
using DataFrames
using Arrow
using StringDistances
using AbstractTrees

# Point to where the taxonomy is located
include("hydrate.jl")
local_path = _local_archive_path()

function __init__()
    name_date = mtime(joinpath(local_path, "tables", "names.arrow"))
    over_30_days = time() - name_date >= 2.6e+6
    if over_30_days 
        @warn("Your local taxonomy version is over 30 days old, we recommend using `] build NCBITaxonomy` to get the most recent version.")
    end
    return nothing
end

include("types.jl")
export NCBITaxon, NCBINameClass, IDNotFoundInBackbone

include("exceptions.jl")
export NameHasNoDirectMatch, NameHasMultipleMatches

names_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "names.arrow")))
names_table.class = NCBINameClass.(names_table.class)
names_table.lowercase = lowercase.(names_table.name)

division_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "division.arrow")))
select!(division_table, Not(:comments))

nodes_table = DataFrame(Arrow.Table(joinpath(taxpath, "tables", "nodes.arrow")))
select!(nodes_table, Not(r"inherited_"))
select!(nodes_table, Not(r"_code_id"))
select!(nodes_table, Not(:genbank_hidden))
select!(nodes_table, Not(:hidden_subtree))
select!(nodes_table, Not(:comments))
select!(nodes_table, Not(:embl))

nodes_table = innerjoin(nodes_table, division_table; on = :division_id)
select!(nodes_table, Not(:division_id))

names_table = leftjoin(
    names_table,
    unique(select(nodes_table, [:tax_id, :rank, :parent_tax_id]));
    on = :tax_id,
)
scinames_table = names_table[findall(names_table.class .== class_scientific_name), :]

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

include("interfaces/abstracttrees.jl")

include("lineage/lineage.jl")
export lineage, commonancestor

include("lineage/rank.jl")
export rank

include("lineage/descendantsfilter.jl")
export descendantsfilter

include("utility/nametools.jl")
include("utility/similarnames.jl")
include("utility/taxonomicdistance.jl")
export vernacular, synonyms, authority, taxonomicdistance, taxonomicdistance!
export similarnames, alternativetaxa

end
