import MD5
import GZip
import Tar
import Arrow
import DataFrames

# URL for the taxonomy dump
const ncbi_ftp = "https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/"
const archive = ncbi_ftp * "new_taxdump.tar.gz"
const checksum = archive * ".md5"

chk_file = download(checksum)
chk = split(readlines(chk_file)[1], " ")[1]
@info "Checksum of the most recent NCBI taxonomy: $(chk)"

function download_dump(url, chk, dest)
    @info "Downloading the taxonomy data from $(url)"
    dumps = joinpath(@__DIR__, dest)
    if ispath(dumps)
        @info "Removing the previous version of the taxonomy"
        rm(dumps; force=true, recursive=true)
        mkpath(dumps)
    else
        mkpath(dumps)
    end
    arc = download(url)
    vrf = bytes2hex(open(MD5.md5, arc))
    vrf == chk || throw(ErrorException("Wrong checksum for the NCBI taxonomy archive file - unable to download"))
    write(joinpath(@__DIR__, ".checksum"), vrf)
    Tar.extract(GZip.open(arc), dumps)
end

# The next block is about making sure that we don't download something that has
# not changed when we build the package. The taxonomy dump is not gigantic, but
# there is no need to get it over and over again.
if !isfile(joinpath(@__DIR__, ".checksum"))
    @info "No local taxonomy checksum found"
    download_dump(archive, chk, "dump")
else
    if readline(joinpath(@__DIR__, ".checksum")) != chk
        @info "Local and remote checksum do not match"
        download_dump(archive, chk, "dump")
    else
        @info "Local taxonomy dump is up to date"
    end
end

@info "Materializing the taxonomy"

# This is the separator used for fields in all the files
const ncbi_dump_separator = r"\t\|\t?"
tables = joinpath(@__DIR__, "tables")
ispath(tables) || mkpath(tables)

# Utility functions

function _materialize_data(::Type{T}, v) where {T}
    if v != ""
        T <: Number && return parse(T, v)
        T <: Symbol && return Symbol(v)
        return v
    else
        return missing
    end
end

function _build_arrow_file(df, dump_file, arrow_file)
    names_columns_types = [eltype(df[n]) for n in names(df)]
    for names_line in readlines(dump_file)
        t = String.(split(names_line, ncbi_dump_separator)[1:(end-1)])
        r = Vector{Any}(undef, length(t))
        for (i,e) in enumerate(t)
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
