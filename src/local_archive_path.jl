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

function _create_or_get_tables_path(local_path)
    tables_path = joinpath(local_path, "tables")
    ispath(tables_path) || mkpath(tables_path)
    return tables_path
end