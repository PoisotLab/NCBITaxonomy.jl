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