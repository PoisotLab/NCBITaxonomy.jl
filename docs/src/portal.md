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

There is are two things we want to do at this point: extract the species names
from the file, and then validate that they are spelled correctly, or that they
are the most recent taxonomic name according to NCBI.

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
        ncbi_tax = taxon(portal_name)
    catch y
        if isa(y, NameHasNoDirectMatch)
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

Note that these results should *always* be manually curated. For example,
some species have been match to *Hemiptera*, which sounds suspect:

```@example portal
filter(r -> r.order ∈ ["Hemiptera"], cleanup)
```

## Fixing the mis-identified species

Well, the obvious choice here is *manual cleaning*. This is a good solution.
Another thing that `NCBITaxonomy` offers is the ability to build a `namefilter`
from a list of known NCBI taxa. This is good if we know that the names we expect
to find are part of a reference list.

In this case, we know that the species are going to be vertebrates, so we can use
the `vertebratefinder` function to restrict the search to these groups:

```@example portal
vert = vertebratefilter(true) # We want taxa that are specific divisions of vertebrates as well
taxon(vert, "Lizard"; strict=false)
```

## Wrapping-up

This vignette illustrates how to go through a list of names, and match them
against the NCBI taxonomy. We have seen a number of functions from
`NCBITaxonomy`, including fuzzy string searching, using custom string distances,
and limiting the taxonomic scope of the search.
