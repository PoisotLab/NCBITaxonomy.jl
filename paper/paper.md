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
of results. `NCBITaxonomy.jl` works with version 1.6 of the Julia programming
language [@Bezanson2017JulFre], and relies on the Apache Arrow format to store a
local copy of the NCBI raw taxonomy files. The design of `NCBITaxonomy.jl` has
been inspired by recent proposals, like the R package `taxadb`
[@Norman2020TaxHig].

# Statement of need

Identifying species in an inambiguous way is a far more challenging task than it
may appears. There are a number of reasons for this. First, different databases
keep different taxonomic "backbones", *i.e.* the data structure mapping both
species to names, and hierarchy of species. Second, not all names are unique
identifiers to groups; for example, the genus *Io* can either refer to plants
from the aster family, or to a genus of molluscs; the genus *Mus* (of which the
house mouse *Mus musculus* is a species), contains a sub-genus *also* named
*Mus*. Third, most taxa name are at some point manually typed, and this
introduces the potential for typos; it is likely that many biologists will
stumble when attempting to write down the (perfectly valid) names of the
bacterial isolate known as *Myxococcus
llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogochensis*, or of the
crowned slaty flycatcher  *Griseotyrannus aurantioatrocristatus*. Finally, the
taxoonmy of species changes on a regular basis, with groups being split, merged,
or moved to a new position in the bush of life; this is very remarkable with
viral taxonomy, each subsequent version of which can differ markedly from the
last [compare, *e.g* @Lefkowitz2018VirTax to @Walker2020ChaVir]. As such, a
package with the ability to handle these situations will reduce the amount of
friction introduced by the need to reconcile and clean taxonomic names.

# Overview of functionalities


## Improved name matching

## Name filtering functions

## Quality of life functions

@Gibb2021DatPro allowed to generate *clover*

**Acknowledgements:** TP was supported by funding to the Viral Emergence
Research Initiative (VERENA) consortium including NSF BII 2021909 and a grant
from Institut de Valorisation des Données (IVADO), by the NSERC Discovery Grants
and Discovery Acceleration Supplement programs, and by a donation from the
Courtois Foundation. Benchmarking of this package on distributed systems was
enabled by support provided by Calcul Québec (`www.calculquebec.ca`) and Compute
Canada (`www.computecanada.ca`).

# References