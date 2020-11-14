module NCBITaxonomy
using DataFrames
using Arrow

names_table = DataFrame(Arrow.Table(joinpath(@__DIR__, "..", "deps", "tables", "names.arrow")))

include("string_macro.jl")
export @ncbi_str

end