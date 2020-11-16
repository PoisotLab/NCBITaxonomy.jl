import MD5
import GZip
import Tar
import Arrow
import DataFrames

@info @__DIR__

# URL for the taxonomy dump
const ncbi_ftp = "https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/"
const archive = ncbi_ftp * "new_taxdump.tar.gz"
const checksum = archive * ".md5"

chk_file = download(checksum)
chk = split(readlines(chk_file)[1], " ")[1]
@info "Checksum of the most recent NCBI taxonomy: $(chk)"

function download_dump(url, chk, dest)
    @info "Downloading the taxonomy data from $(url)"
    if ispath(joinpath(@__DIR__, dest))
        @info "Removing the previous version of the taxonomy"
        rm(joinpath(@__DIR__, dest); force=true, recursive=true)
        mkpath(joinpath(@__DIR__, dest))
    else
        mkpath(joinpath(@__DIR__, dest))
    end
    arc = download(url)
    vrf = bytes2hex(open(MD5.md5, arc))
    vrf == chk || throw(ErrorException("Wrong checksum for the NCBI taxonomy archive file - unable to download"))
    write(joinpath(@__DIR__, ".checksum"), vrf)
    Tar.extract(GZip.open(arc), joinpath(@__DIR__, dest))
end

# The next block is about making sure that we don't download something that has
# not changed when we build the package. The taxonomy dump is not gigantic, but
# there is no need to get it over and over again.
if !isfile(joinpath(@__DIR__, ".checksum"))
    @info "No local taxonomy checksum found"
    download_dump(archive, chk, "dump")
else
    local_chk = readline(joinpath(@__DIR__, ".checksum"))
    if local_chk != chk
        @info "Local and remote checksum do not match"
        download_dump(archive, chk, "dump")
    else
        @info "Local taxonomy dump ($(local_chk)) is up to date"
    end
end

@info "Materializing the taxonomy"

# This is the separator used for fields in all the files
tables = joinpath(@__DIR__, "tables")
ispath(tables) || mkpath(tables)

# Utility functions

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
        T <: Union{Bool,Missing} && return parse(Bool, v)
        T <: Union{Int,Missing} && return parse(Int, v)
        T <: Symbol && return Symbol(v)
        return v
    else
        return missing
    end
end

function _build_arrow_file(df, dump_file, arrow_file)
    names_columns_types = [eltype(df[Symbol(n)]) for n in names(df)]
    for names_line in readlines(dump_file)
        t = String.(split(names_line, r"\t\|\t?")[1:(end - 1)])
        r = Vector{Any}(undef, length(t))
        for (i, e) in enumerate(t)
            r[i] = _materialize_data(names_columns_types[i], e)
        end
        push!(df, tuple(r...))
    end
    Arrow.write(joinpath(tables, arrow_file), df)
    df = nothing
    GC.gc()
end

# Get the data

@info "Building the names file"
ncbi_names_file_in = joinpath(@__DIR__, "dump", "names.dmp")
ncbi_names_file_out = joinpath(@__DIR__, "tables", "names.arrow")
ncbi_names = DataFrames.DataFrame(tax_id=Int[], name=String[], unique_name=Union{String,Missing}[], class=Symbol[])
_build_arrow_file(ncbi_names, ncbi_names_file_in, ncbi_names_file_out)

@info "Building the division file"
ncbi_division_file_in = joinpath(@__DIR__, "dump", "division.dmp")
ncbi_division_file_out = joinpath(@__DIR__, "tables", "division.arrow")
ncbi_division = DataFrames.DataFrame(division_id=Int[], division_code=Symbol[], division_name=Symbol[], comments=Union{String,Missing}[])
_build_arrow_file(ncbi_division, ncbi_division_file_in, ncbi_division_file_out)

@info "Building the nodes file"
ncbi_nodes_file_in = joinpath(@__DIR__, "dump", "nodes.dmp")
ncbi_nodes_file_out = joinpath(@__DIR__, "tables", "nodes.arrow")
ncbi_nodes = DataFrames.DataFrame(
    tax_id=Int[], parent_tax_id=Int[],
    rank=Symbol[],
    embl=Union{String,Missing}[],
    division_id=Int[], inherited_div=Union{Bool,Missing}[],
    genetic_code_id=Int[], inherited_gc=Union{Bool,Missing}[], 
    mitochondrial_genetic_code_id=Union{Int,Missing}[], inherited_mgc=Union{Bool,Missing}[],
    genbank_hidden=Union{Bool,Missing}[],
    hidden_subtree=Union{Bool,Missing}[],
    comments=Union{String,Missing}[],
    plastid_genetic_code_id=Union{Int,Missing}[], inherited_pgc=Union{Bool,Missing}[],
    specified_species=Union{Bool,Missing}[],
    hydrogenosome_code_id=Union{Int,Missing}[], inherited_hgc=Union{Bool,Missing}[]
    )
_build_arrow_file(ncbi_nodes, ncbi_nodes_file_in, ncbi_nodes_file_out)
