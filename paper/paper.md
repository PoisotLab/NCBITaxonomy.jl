---
title: 'NCBITaxonomy.jl - rapid scientific names reconciliation'
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
of results.
# Statement of need

Identifying species in an inambiguous way is a far more challenging task than it
may appears. There are a number of reasons for this. First, different databases
keep different taxonomic "backbones", *i.e.* the data structure mapping both
species to names, and hierarchy of species. Second, not all names are unique
identifiers to groups; for example, the genus *Io* can either refer to plants
from the aster family, or to a genus of molluscs; the genus *Mus* (of which the
house mouse *Mus musculus* is a species), contains a sub-genus *also* named
*Mus*. Finally, most taxa name are at some point manually typed, and this
introduces the potential for typos; it is likely that many biologists will
stumble when attempting to write down the (perfectly valid) names of the
bacterial isolate known as *Myxococcus
llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogochensis*, or of the
flatworm *Pseudorhabdosynochus hyphessometochus*.

@Norman2020TaxHig `taxadb`

@Gibb2021DatPro allowed to generate *clover*

# Overview of functionalities

# References