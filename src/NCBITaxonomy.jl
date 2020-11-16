module NCBITaxonomy
using DataFrames
using DataFramesMeta
using Arrow
using StringDistances

names_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "names.arrow")))

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

struct NCBITaxon
    name::String
    id::Int
end

Base.show(io::IO, t::NCBITaxon) = print(io, "$(t.name) ($(t.id))")

export NCBITaxon

include("children.jl")
export children, descendants

include("taxid.jl")
export taxid, namefinder

include("string_macro.jl")
export @ncbi_str

end
