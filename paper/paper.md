---
title: 'NCBITaxonomy.jl - rapid biological names finding and reconciliation'
tags:
  - Julia
  - biodiversity
  - taxonomy
  - NCBI
  - fuzzy matching
authors:
  - name: Timothée Poisot
    orcid: 0000-0002-0735-5184
    affiliation: 1
affiliations:
 - name: Université de Montréal, Départment de Sciences Biologiques, Montréal QC, CANADA
   index: 1
date: Jul. 30, 2021
bibliography: paper.bib
---

# Summary

`NCBITaxonomy.jl` is a package designed to facilitate the reconciliation and
cleaning of taxonomic names, using a *local* copy of the NCBI taxonomic backbone
[@Federhen2012NcbTax; @Schoch2020NcbTax]; The basic search functions are coupled
with quality-of-life functions including case-insensitive search and custom
fuzzy string matching to facilitate the amount of information that can be
extracted automatically, while allowing efficient manual curation and inspection
of results. `NCBITaxonomy.jl` works with version 1.6 of the Julia programming
language [@Bezanson2017JulFre], and relies on the Apache Arrow format to store a
local copy of the NCBI raw taxonomy files. The design of `NCBITaxonomy.jl` has
been inspired by recent proposals, like the R package `taxadb`
[@Norman2020TaxHig].

# Statement of need

Identifying species in an inambiguous way is a far more challenging task than it
may appears. There are a vast number of reasons for this. Different databases
keep different taxonomic "backbones", *i.e.* the data structure mapping both
species to names, and hierarchy of species. Not all names are unique identifiers
to groups; for example, the genus *Io* can either refer to plants from the aster
family, or to a genus of molluscs; the genus *Mus* (of which the house mouse
*Mus musculus* is a species), contains a sub-genus *also* named *Mus*.
Conversely, the same species can be known by several names, which are valid
synonyms: for example the domestic cow *Bos taurus* admits *Bos primigenius
taurus* as a valid synonym. Finally, the taxoonmy of species changes on a
regular basis, with groups being split, merged, or moved to a new position in
the bush of life; this is very remarkable with viral taxonomy, each subsequent
version of which can differ markedly from the last [compare, *e.g*
@Lefkowitz2018VirTax to @Walker2020ChaVir].

To add to the complexity, one must also consider that most taxa name are at some
point manually typed, and this introduces the potential for typos; it would be
understandable for any biologist to stumble when attempting to write down the
(perfectly valid) names of the bacterial isolate known as *Myxococcus
llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogochensis*, or of the
crowned slaty flycatcher  *Griseotyrannus aurantioatrocristatus*. Finally, the
same species can be known by many vernacular (common) names - *Ovis aries* has
valid vernacular including lab, sheep, wild sheep, and domestic sheep.

All these considerations are actually important when matching species names both
within and across datasets. Let us consider the following species survey of
individal fish, European chub, *Cyprinus cephalus*, *Leuciscus cephalus*,
*Squalius cephalus*: all are the same species (*S. cephalus*), refered to as one
of the vernacular (European chub) and two formerly accepted names now classified
as synonyms. An uncautious estimate of diversity based on the raw list of names
would give $n=4$ species, when there is in fact only one.

As such, a package with the ability to handle the many things that can go wrong
when working with taxonomic names, and provide an authoritative classification
is going to accelerate the work of consuming large volumes of biodiversity data.
For example, this package was used in the process of assembling the *CLOVER*
database [@Gibb2021DatPro] of host-virus associations, and facilitated the
cleaning of names of both mammals and viruses.

# Overview of functionalities

An up-to-date version of the documentation for `NCBITaxonomy.jl` can be found
online at
[https://docs.ecojulia.org/NCBITaxonomy.jl/stable/](https://docs.ecojulia.org/NCBITaxonomy.jl/stable/),
including examples and a documentation of every method. The package is released
under the MIT license. Contributions can be made in the form of issues (bug
reports, questions, features suggestions) and pull requests. The package can be
checked out and install anonymously from the central Julia repository:

~~~julia
using Pkg

# This line should go in the Julia configuration file - note that the path
will be created if it doesn't exist, and will be used to store the raw taxonomic
table
ENV["NCBITAXONOMY_PATH"] = joinpath(homedir(), "data", "NCBITaxonomy.jl")

Pkg.add("NCBITaxonomy")
~~~

The package will download the most recent version of the NCBI taxonomy database,
and transform in into a set of Apache Arrow files ready for use.

## Improved name matching


## Name filtering functions

## Quality of life functions

## Taxonomic lineages navigation

**Acknowledgements:** TP was supported by funding to the Viral Emergence
Research Initiative (VERENA) consortium including NSF BII 2021909 and a grant
from Institut de Valorisation des Données (IVADO), by the NSERC Discovery Grants
and Discovery Acceleration Supplement programs, and by a donation from the
Courtois Foundation. Benchmarking of this package on distributed systems was
enabled by support provided by Calcul Québec (`www.calculquebec.ca`) and Compute
Canada (`www.computecanada.ca`).

# References