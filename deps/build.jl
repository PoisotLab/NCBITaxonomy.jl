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
    ispath(dest) || mkpath(dest)
    arc = download(url)
    vrf = bytes2hex(open(MD5.md5, arc))
    vrf == chk || throw(ErrorException("Wrong checksum for the NCBI taxonomy archive file - unable to download"))
    write(joinpath(@__DIR__, ".checksum"), vrf)
    Tar.extract(GZip.open(arc), dest)
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

# Paths of the actual files
ncbi_names_file = joinpath(@__DIR__, "dump", "names.dmp")

# Get the data
@info "Building the names file"
ncbi_names = DataFrames.DataFrame(tax_id=Int[], name=Symbol[], unique_name=Union{Symbol,Missing}[], class=Symbol[])
names_columns_types = [eltype(ncbi_names[n]) for n in names(ncbi_names)]
for names_line in readlines(ncbi_names_file)
    t = String.(split(names_line, ncbi_dump_separator)[1:(end-1)])
    r = Vector{Any}(undef, length(t))
    for (i,e) in enumerate(t)
        r[i] = missing
        if e != ""
            T = names_columns_types[i]
            T <: Number && (r[i] = parse(T, e))
            T <: Symbol && (r[i] = Symbol(e))
        end
    end
    push!(ncbi_names, tuple(r...))
end
Arrow.write(joinpath(tables, "names.arrow"), ncbi_names)