function _remote_archive_path(;
    ncbi_ftp = "https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/",
)::NamedTuple{
    (:url, :archive, :checksum),
    Tuple{String, String, String},
}
    return (
        url = ncbi_ftp,
        archive = "new_taxdump.tar.gz",
        checksum = "new_taxdump.tar.gz.md5",
    )
end

"""
    _local_archive_path()

Returns the path where the taxonomy dump is stored, and throws a warning if the
path is not set as an environmental variable. This is used during the build step
*and* during the initial startup of the package.
"""
function _local_archive_path()::String
    if !haskey(ENV, "NCBITAXONOMY_PATH")
        @warn """
        The environmental variable NCBITAXONOMY_PATH is not set, so the tables will
        be stored in your home directory. This is not ideal, and you really should set
        the NCBITAXONOMY_PATH.

        This can be done by adding `ENV["NCBITAXONOMY_PATH"]` in your Julia startup
        file. The path will be created automatically if it does not exist.
        """
    end
    taxpath = get(ENV, "NCBITAXONOMY_PATH", joinpath(homedir(), "NCBITaxonomy"))
    ispath(taxpath) || mkpath(taxpath)
    return taxpath
end

function _get_current_remote_checksum(local_path, remote_info)
    chk_file = Downloads.download(
        remote_info.url * remote_info.checksum,
        joinpath(local_path, ".checksum.remote"),
    )
    return split(readlines(chk_file)[1], " ")[1]
end

function _download_archive(local_path, remote_info)
    Downloads.download(
        remote_info.url * remote_info.archive,
        joinpath(local_path, remote_info.archive),
    )
    return joinpath(local_path, remote_info.archive)
end

function _unpack_if_needed(local_path, remote_info, remote_checksum)
    local_archive = joinpath(local_path, remote_info.archive)
    need_update = false
    if ~isfile(local_archive)
        @warn "There is no local taxonomy dump, we will download one"
        local_archive = _download_archive(local_path, remote_info)
        need_update = true
    end
    local_checksum = bytes2hex(open(MD5.md5, local_archive))
    if local_checksum != remote_checksum
        @warn "The checksum of the taxonomy dump does not match the remote"
        local_archive = _download_archive(local_path, remote_info)
        local_checksum = bytes2hex(open(MD5.md5, local_archive))
        need_update = true
    end
    if need_update
        @warn "We are unpacking the local taxonomy dump"
        rm(joinpath(local_path, "dump"); force=true)
        Tar.extract(GZip.open(local_archive), joinpath(local_path, "dump"))
    end
    return joinpath(local_path, "dump")
end

function _create_or_get_tables_path(local_path)
    tables_path = joinpath(local_path, "tables")
    ispath(tables_path) || mkpath(tables_path)
    return tables_path
end