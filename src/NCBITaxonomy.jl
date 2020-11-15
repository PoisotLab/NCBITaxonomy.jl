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

nodes_table = join(nodes_table, division_table; on=:division_id)
select!(nodes_table, Not(:division_id))

struct NCBITaxon
    name::String
    id::Int
end

export NCBITaxon
Base.convert(::Type{Pair}, t::NCBITaxon) = t.name => t.id
Base.convert(::Type{NCBITaxon}, p::T) where {T <: Pair{String,Int}} = NCBITaxon(p.first, p.second)

include("taxid.jl")
export taxid

include("string_macro.jl")
export @ncbi_str

end
