# Use-case: the portal data

In this example, we will use `NCBITaxonomy` to validate the names of the species
used in the Portal teaching dataset:

> Ernest, Morgan; Brown, James; Valone, Thomas; White, Ethan P. (2017): Portal
> Project Teaching Database. figshare.
> https://doi.org/10.6084/m9.figshare.1314459.v6

## Getting the data

We will download a list of species from figshare, which is given as a JSON file:

```@example portal
using NCBITaxonomy
using DataFrames
using JSON

species_file = download("https://ndownloader.figshare.com/files/3299486")
species = JSON.parsefile(species_file)
```

There is are two things we want to do at this point: extract the species names
from the file, and then validate that they are spelled correctly, or that they
are the most recent taxonomic name according to NCBI.

## Validation

We will store our results in a data frame:

```@example portal
cleanup = DataFrame(
    code = String[],
    portal = String[],
    name = String[],
    rank = Symbol[],
    order = String[],
    taxid = Int[]
)
```

The next step is to loop throug the species, and figure out what to do with
them:

```@example portal
for sp in species
    portal_name = sp["species"] == "sp." ? sp["genus"] : sp["genus"]*" "*sp["species"]
    ncbi_tax = taxid(portal_name)
    if isnothing(ncbi_tax)
        ncbi_tax = taxid(portal_name; fuzzy=true)
    end
    ncbi_lin = lineage(ncbi_tax)
    push!(cleanup,
        (
            sp["species_id"], portal_name, ncbi_tax.name, rank(ncbi_tax),
            first(filter(t -> isequal(:order)(rank(t)), lineage(ncbi_tax))).name,
            ncbi_tax.id
        )
    )
end

first(cleanup, 5)
```

Finally, we can look at the codes for which there is a likely issue because the
names do not match -- this can be because of new names, improper use of
vernacular, or spelling issues:

```@example portal
filter(r -> r.portal != r.name, cleanup)
```

Note that these results should *always* be manually curated. For example, one of
the rodents species got assigned to something which is obviously the wrong
group:

```@example portal
filter(r -> isequal("Gentianales")(r.order), cleanup)
```

How can we fix this?