# Use-case: the portal data

In this example, we will use `NCBITaxonomy` to validate the names of the species
used in the Portal teaching dataset:

> Ernest, Morgan; Brown, James; Valone, Thomas; White, Ethan P. (2017): Portal
> Project Teaching Database. figshare.
> https://doi.org/10.6084/m9.figshare.1314459.v6

```@example portal
using NCBITaxonomy
using DataFrames
using JSON

species_file = download("https://ndownloader.figshare.com/files/3299483")
species = JSON.parsefile(species_file)
```

