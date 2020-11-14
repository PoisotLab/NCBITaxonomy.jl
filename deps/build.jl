import MD5
import GZip
import Tar
import Arrow

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

# Reads the taxonomy dumps and convert them to arrow files
