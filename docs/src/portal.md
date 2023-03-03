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

We will store our results in a data frame:

```@example portal
cleanup = DataFrame(
    code = String[],
    portal = String[],
    name = String[],
    rank = Symbol[],
    order = String[],
    taxid = Int[],
    same = Bool[],
    fuzzy = Bool[]
)
```

The next step is to loop through the species, and figure out what to do
with them:

```@example portal
for sp in species
    portal_name = sp["species"] == "sp." ? sp["genus"] : sp["genus"]*" "*sp["species"]
    local ncbi_tax
    local fuzzy = false
    try
        ncbi_tax = taxon(portal_name)
    catch y
        if isa(y, NameHasNoDirectMatch)
            fuzzy = true
            ncbi_tax = taxon(portal_name; strict=false)
        else
            continue
        end
    end
    ncbi_lin = lineage(ncbi_tax)
    push!(cleanup,
        (
            sp["species_id"], portal_name, ncbi_tax.name, rank(ncbi_tax),
            first(filter(t -> isequal(:order)(rank(t)), lineage(ncbi_tax))).name,
            ncbi_tax.id, portal_name == ncbi_tax.name, fuzzy
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

Out of these, some required to use fuzzy matching to get a proper name, so we
can look at there taxa, as they are likely to require manual curation:

```@example portal
filter(r -> r.fuzzy, cleanup)
```

Out of these, only `Lizard` has a strange identification as a `Hemiptera`:

```@example portal
filter(t -> isequal(:class)(rank(t)), lineage(ncbi"Lisarda"))
```

Right. We can dig into this example a little more, because it shows how much
*data entry* can condition the success of name finding.

```@example portal
similarnames("Lizard"; threshold=0.7)
```

The *Lisarda* taxon (which is an insect!) is the closest match, simply because
"Lizards" is not a classification we can use -- lizards are a paraphyletic
group, containing a handful of different groups. Based on the information
available, the only information we can say about the taxon identified as
"Lizards" is that it belongs to *Squamata*.

