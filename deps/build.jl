import MD5
import GZip
import Tar

const ncbi_ftp = "https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/"
const archive = ncbi_ftp * "new_taxdump.tar.gz"
const checksum = archive * ".md5"

chk_file = download(checksum)
chk = split(readlines(chk_file)[1], " ")[1]

arc = download(archive)
vrf = bytes2hex(open(MD5.md5, arc))

vrf == chk || throw(ErrorException("Wrong checksum for the NCBI taxonomy archive file - unable to download"))

dest = joinpath(@__DIR__, "taxonomy")
ispath(dest) || mkpath(dest)

Tar.extract(GZip.open(arc), dest)