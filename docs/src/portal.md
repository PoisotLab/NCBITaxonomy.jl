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

The next step is to loop throug the species, and figure out what to do with
them:

```@example portal
for sp in species
    portal_name = sp["species"] == "sp." ? sp["genus"] : sp["genus"]*" "*sp["species"]
    ncbi_tax = taxon(portal_name)
    if isnothing(ncbi_tax)
        ncbi_tax = taxon(portal_name; strict=false)
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

Note that these results should *always* be manually curated. For example, two
species have been assigned to groups that are *obviously* wrong:

```@example portal
filter(r -> r.order ∈ ["Gentianales","Hemiptera"], cleanup)
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

However, this approach does not seem to work for the second group:

```@example portal
taxon(vert, "Perognathus hispidus"; strict=false)
```

## The mystery of the hispid pocket mouse

This one will not be solved by our approach, as it is an invalid name --
*Perognathus hispidus* should actually be *Chaetodipus hispidus*. Here are the
list of issues that result in this name not being identifiable easily. First,
*Chaetodipus* is a valid name, for which *Perognathus* is not a synonym. So
searching by genus is not going to help. Second, there are a whole lot of
species that end with *hispidus*, and trying different string distances is not
going to help. We can try:

```@example portal
taxon(vert, "Perognathus hispidus"; strict=false, dist=DamerauLevenshtein) |> vernacular
```

This returns a valid taxon, but an incorrect one. There is no obvious way to
solve this problem. There are techniques relying on code generation, or
dispatching on values, but they are probably not going to be as general as a
good lookup table to correct the names that are knwon to be problematic.

## Wrapping-up

This vignette illustrates how to go through a list of names, and match them
against the NCBI taxonomy. We have seen a number of functions from
`NCBITaxonomy`, including fuzzy string searching, using custom string distances,
and limiting the taxonomic scope of the search.