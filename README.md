# NCBI taxonomy

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

This package provides an interface to the [NCBI Taxonomy][ncbitax]. When
installed, it will download the *latest* version of the taxonomy files from the
NCBI `ftp` service. To update the version of the taxonomy you use, you need to
build the package again.

[ncbitax]: https://www.ncbi.nlm.nih.gov/taxonomy

## How to use

## Varia

Internally, the package relies on the files provided by NCBI to reconstruct the
taxonomy -- the README for what the files contain can be found [here][readme].
Note that the files *and* their expected MD5 checksum are downloaded when the
package is built, and the data are *not* extracted unless the checksum matches.

[readme]: https://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/taxdump_readme.txt
