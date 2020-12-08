module NCBITaxonomy
using DataFrames
using Arrow
using StringDistances

include("types.jl")
export NCBITaxon, NCBINameClass

names_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "names.arrow")))
names_table.class = NCBINameClass.(names_table.class)

division_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "division.arrow")))
select!(division_table, Not(:comments))

nodes_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "nodes.arrow")))
select!(nodes_table, Not(r"inherited_"))
select!(nodes_table, Not(r"_code_id"))
select!(nodes_table, Not(:genbank_hidden))
select!(nodes_table, Not(:hidden_subtree))
select!(nodes_table, Not(:comments))
select!(nodes_table, Not(:embl))

nodes_table = innerjoin(nodes_table, division_table; on=:division_id)
select!(nodes_table, Not(:division_id))

include("taxid.jl")
export taxid, namefinder, descendantsfinder

include("divisions.jl")
export bacteriafinder, virusfinder, mammalfinder, vertebratefinder, plantfinder, invertebratefinder

include("string_macro.jl")
export @ncbi_str

include("children.jl")
export children, descendants

include("lineage.jl")
export lineage, parent, rank

end