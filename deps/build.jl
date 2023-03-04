import MD5
import GZip
import Tar
import Arrow
import DataFrames
import Downloads

# There are two things we need for the build process: the types, and the
# location of the files
include(joinpath(@__DIR__, "..", "src", "hydrate.jl"))
include(joinpath(@__DIR__, "..", "src", "types.jl"))

# These steps are meant to download and unpack the taxonomy as needed, which is
# to say as unfrequently as possible
remote_info = _remote_archive_path()
local_path = _local_archive_path()
remote_checksum = _get_current_remote_checksum(local_path, remote_info)
local_archive = _unpack_if_needed(local_path, remote_info, remote_checksum)

# We will store the tables used by the package in the tables folder
tables_path = _create_or_get_tables_path(local_path)

# Utility functions
function _class_to_enum(c::T) where {T <: String}
    c = replace(c, " " => "_")
    c = replace(c, "-" => "_")
    return getproperty(@__MODULE__, Symbol("class_$(c)"))
end

"""
This function is responsible for converting a raw line from the taxonomy dump to
a series of correctly typed values. It is quite clearly not the most elegant
version, but it works based on the content of the taxonomy files. As this is
only called at build time, we think that the performance cost is not a big
issue.
"""
function _materialize_data(::Type{T}, v) where {T}
    if v != ""
        T <: Number && return parse(T, v)
        T <: Union{Bool, Missing} && return parse(Bool, v)
        T <: Union{Int, Missing} && return parse(Int, v)
        T <: Symbol && return Symbol(v)
        T <: NCBINameClass && return _class_to_enum(v)
        return v
    else
        return missing
    end
end

function _build_arrow_file(df, dump_file)
    names_columns_types = [eltype(col) for col in eachcol(df)]
    for names_line in readlines(dump_file)
        t = String.(split(names_line, r"\t\|\t?")[1:(end - 1)])
        r = Vector{Any}(undef, length(t))
        for (i, e) in enumerate(t)
            r[i] = _materialize_data(names_columns_types[i], e)
        end
        push!(df, tuple(r...))
    end
    return df
end

# Get the data for the names
ncbi_names_file_in = joinpath(local_path, "dump", "names.dmp")
ncbi_names_file_out = joinpath(tables_path, "names.arrow")
ncbi_names = DataFrames.DataFrame(;
    tax_id = Int[],
    name = String[],
    unique_name = Union{String, Missing}[],
    class = NCBINameClass[],
)
names_df = _build_arrow_file(ncbi_names, ncbi_names_file_in)
names_df.class = Int.(names_df.class)
Arrow.write(ncbi_names_file_out, names_df)
names_df = nothing
GC.gc()

ncbi_division_file_in = joinpath(local_path, "dump", "division.dmp")
ncbi_division_file_out = joinpath(tables_path, "division.arrow")
ncbi_division = DataFrames.DataFrame(;
    division_id = Int[],
    division_code = Symbol[],
    division_name = Symbol[],
    comments = Union{String, Missing}[],
)
division_df = _build_arrow_file(ncbi_division, ncbi_division_file_in)
Arrow.write(ncbi_division_file_out, division_df)
division_df = nothing
GC.gc()

ncbi_nodes_file_in = joinpath(local_path, "dump", "nodes.dmp")
ncbi_nodes_file_out = joinpath(tables_path, "nodes.arrow")
ncbi_nodes = DataFrames.DataFrame(;
    tax_id = Int[], parent_tax_id = Int[],
    rank = Symbol[],
    embl = Union{String, Missing}[],
    division_id = Int[], inherited_div = Union{Bool, Missing}[],
    genetic_code_id = Int[], inherited_gc = Union{Bool, Missing}[],
    mitochondrial_genetic_code_id = Union{Int, Missing}[],
    inherited_mgc = Union{Bool, Missing}[],
    genbank_hidden = Union{Bool, Missing}[],
    hidden_subtree = Union{Bool, Missing}[],
    comments = Union{String, Missing}[],
    plastid_genetic_code_id = Union{Int, Missing}[],
    inherited_pgc = Union{Bool, Missing}[],
    specified_species = Union{Bool, Missing}[],
    hydrogenosome_code_id = Union{Int, Missing}[],
    inherited_hgc = Union{Bool, Missing}[],
)
nodes_df = _build_arrow_file(ncbi_nodes, ncbi_nodes_file_in)
Arrow.write(ncbi_nodes_file_out, nodes_df)
nodes_df = nothing
GC.gc()