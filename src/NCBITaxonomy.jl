module NCBITaxonomy
using DataFrames
import Arrow
using StringDistances
using AbstractTrees

# Point to where the taxonomy is located
include("local_archive_path.jl")
tables_path = _create_or_get_tables_path(_local_archive_path())

function __init__()
    name_date = mtime(joinpath(tables_path, "names.arrow"))
    over_30_days = time() - name_date >= 2.6e+6
    if over_30_days
        @warn(
            "Your local taxonomy version is over 30 days old, we recommend using `] build NCBITaxonomy` to get the most recent version."
        )
    end
    return nothing
end

include("types.jl")
export NCBITaxon, NCBINameClass

include("exceptions.jl")
export NameHasNoDirectMatch, NameHasMultipleMatches, IDNotFoundInBackbone

# We load the core file with all we need in it
include("read_taxonomy.jl")
taxonomy = read_taxonomy(tables_path)
scinames = filter(r -> r.class == NCBITaxonomy.class_scientific_name, taxonomy)
groupedscinames = groupby(scinames, :tax_id)
groupedtaxonomy = groupby(taxonomy, :tax_id)

include("taxon.jl")
export taxon, @ncbi_str

include("namefilters/namefilter.jl")
include("namefilters/divisions.jl")
export namefilter
export bacteriafilter,
    virusfilter,
    mammalfilter,
    vertebratefilter,
    plantfilter,
    invertebratefilter,
    rodentfilter,
    primatefilter,
    environmentalsamplesfilter,
    phagefilter

include("interfaces/abstracttrees.jl")

include("lineage/lineage.jl")
export lineage, commonancestor

include("lineage/rank.jl")
export rank

include("lineage/descendantsfilter.jl")
export descendantsfilter

include("utility/nametools.jl")
include("utility/similarnames.jl")
include("utility/taxonomicdistance.jl")
export vernacular, synonyms, authority, taxonomicdistance, taxonomicdistance!
export similarnames, alternativetaxa

end
