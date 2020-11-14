module NCBITaxonomy

using DataFrames

# This is the separator used for fields in all the files
const ncbi_dump_separator = r"\t\|\t?"

# This is the path to the downloaded data
const taxonomy_path = joinpath(@__DIR__, "..", "deps", "taxonomy")
@info taxonomy_path

# Paths of the actual files
ncbi_nodes_file = joinpath(taxonomy_path, "nodes.dmp")
ncbi_names_file = joinpath(taxonomy_path, "names.dmp")

# Get the data
ncbi_names = DataFrame(tax_id=Int[], name=Symbol[], unique_name=Union{Symbol,Missing}[], class=Symbol[])
names_columns_types = [eltype(ncbi_names[n]) for n in names(ncbi_names)]
for names_line in readlines(ncbi_names_file)
    t = split(names_line, ncbi_dump_separator)[1:4]
    r = Vector{Any}(undef, length(t))
    for (i,e) in enumerate(t)
        T = names_columns_types[i]
        r[i] = String(e)
        e == "" && (r[i] = missing)
        T <: Number && (r[i] = parse(T, e))
        T <: Symbol && (r[i] = Symbol(e))
    end
    push!(ncbi_names, tuple(r...))
end

include("string_macro.jl")
export @ncbi_str

end