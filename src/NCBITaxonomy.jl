module NCBITaxonomy
using DataFrames
using Arrow
using StringDistances

names_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "names.arrow")))

division_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "division.arrow")))
select!(division_table, Not(:comments))

nodes_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "nodes.arrow")))

include("string_macro.jl")
export @ncbi_str

end