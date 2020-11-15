# NCBI taxonomy

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

This package provides an interface to the [NCBI Taxonomy][ncbitax]. When
installed, it will download the *latest* version of the taxonomy files from the
NCBI `ftp` service. To update the version of the taxonomy you use, you need to
build the package again.

[ncbitax]: https://www.ncbi.nlm.nih.gov/taxonomy

This package is developed as part of the activities of the Viral Emergence
Research Initiative ([VERENA][verena]) consortium, with financial support from
the Institut de Valorisation des Données ([IVADO][ivado]) at Université de
Montréal.

[verena]: https://www.viralemergence.org/
[ivado]: https://ivado.ca/en/

## How to use

### Get the taxonomic ID of a node

The `taxid` function will return a `NCBITaxon` object, which has two fields:
`name` and `id`. We do not return the `class` attribute, because the package
will always return the scientific name, as the examples below illustrate:

```julia
julia> taxid("Bos taurus")
Bos taurus (9913)
```

Note that because the names database contains vernacular and deprecated names,
the *scientific name* will be returned, no matter what you search

```julia
julia> taxid("cow")
Bos taurus (9913)
```

You can pass an additional `:fuzzy` argument to the `taxid` function to perform
fuzzy name matching using the Levenshtein distance:

```julia
julia> taxid("Paradiplozon homion", :fuzzy)
Paradiplozoon homoion (147838)
```

Note that both fuzzy searching and non-standard naming come at a performance cost:

```julia
julia> @time taxid("tchiken", :fuzzy)
  0.629431 seconds (15.88 M allocations: 438.590 MiB, 6.48% gc time)
Gallus gallus (9031)

julia> @time taxid("Gallus gallus")
  0.103331 seconds (3.16 M allocations: 158.598 MiB)
Gallus gallus (9031)
```

### Get the children and descendants of a node

The `children` function returns all nodes immediately *below* the node of
reference.

```julia
julia> taxid("Diplectanidae") |> children
22-element Array{NCBITaxon,1}:
```

The `descendants` functions *recursively* returns all nodes below the reference
one, until the tips of the taxonomy are reached. Note that this might include
unidentified or environmental samples.

```julia
julia> taxid("Diplectanidae") |> descendants
126-element Array{NCBITaxon,1}:
```

 Note that for the moment, these functions are not optimized. They will be, but
 right now, they are not.

## Varia

Internally, the package relies on the files provided by NCBI to reconstruct the
taxonomy -- the README for what the files contain can be found [here][readme].
Note that the files *and* their expected MD5 checksum are downloaded when the
package is built, and the data are *not* extracted unless the checksum matches.
The package will also check that the checksum on the server is different from
the version on disk, to avoid downloading data for nothing.

[readme]: https://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/taxdump_readme.txt

Internally, the data are saved as arrow tables, which are loaded by
`NCBITaxonomy` as `DataFrames`. These data frames are *not* exported, but they
are used by the various function of the package. Note also that a number of
fields are removed, and some tables are pre-merged - not at build time (so there
is no information loss), but at load time.