# Use-case: the portal data

In this example, we will use `NCBITaxonomy` to validate the names of the species
used in the Portal teaching dataset:

> Ernest, Morgan; Brown, James; Valone, Thomas; White, Ethan P. (2017): Portal
> Project Teaching Database. figshare.
> https://doi.org/10.6084/m9.figshare.1314459.v6

We will download a list of species from figshare, which is given as a JSON file:

```@example portal
using NCBITaxonomy
using DataFrames
using JSON
using StringDistances

species_file = download("https://ndownloader.figshare.com/files/3299486")
species = JSON.parsefile(species_file)
```

## Cleaning up the portal names

There are two things we want to do at this point: extract the species names from
the file, and then validate that they are spelled correctly, or that they are
the most recent taxonomic name according to NCBI.

The portal data are already identified as belonging to a group of taxa, so we
can get a unique list of them:

```@example portal
taxo_groups = unique([tax["taxa"] for tax in species])
```

In order to speed-up the search, and make sure that the names match, we will
create a series of `namefilter`s, based on the descendants of these taxa.

```@example portal
portalfilters = Dict(
    "Bird" => descendantsfilter(ncbi"Aves"),
    "Rodent" => rodentfilter(),
    "Reptile" => descendantsfilter(ncbi"Sauria"),
    "Rabbit" => descendantsfilter(ncbi"Lagomorpha"),
)
```

In practice, because the `descendantfilter` (and any `*filter`) functions return
a `DataFrame`, we could save the content of the groups; this is particularly
important, because the construction of a name finder required to traverse the
entire tree under the root taxon, which is going to be time consuming for larger
groups (such as, for example, *Aves*). If we had the guarantee that the names
are all scientific names, we could further refine the dataframes, but this is
not the case here. In any case, having these filters at hand is going to allow
us to limit the searches to the pool of correct taxa.

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

The next step is to loop through the species, and figure out what to do
with them:

```@example portal
for sp in species
    portal_name = sp["species"] == "sp." ? sp["genus"] : sp["genus"]*" "*sp["species"]
    local ncbi_tax
    try
        ncbi_tax = taxon(portalfinders[species["taxa"]], portal_name)
    catch y
        if isa(y, NameHasNoDirectMatch)
            ncbi_tax = taxon(portalfinders[species["taxa"]], portal_name; strict=false)
        else
            continue
        end
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

## Looking at species with a name discrepancy

Finally, we can look at the codes for which there is a likely issue because the
names do not match -- this can be because of new names, improper use of
vernacular, or spelling issues:

```@example portal
filter(r -> r.portal != r.name, cleanup)
```
