# Finding taxa

## The `taxon` function

```@docs
taxon
vernacular
synonyms
authority
```

The `taxon` function will return a `NCBITaxon` object, which has two fields:
`name` and `id`. We do not return the `class` attribute, because the package
will always return the scientific name, as the examples below illustrate:

```@example taxon
using NCBITaxonomy
taxon("Bos taurus")
```

There is a convenience string macro to replace the `taxon` function:

```@example taxon
ncbi"Bos taurus"
```

Note that because the names database contains vernacular and deprecated names,
the *scientific name* will be returned, no matter what you search

```@example taxon
taxon("cow")
```

This may be a good point to note that we can use the `vernacular` function to
get a list of NCBI-known vernacular names:

```@example taxon
taxon("cow") |> vernacular
```

It also work with authorities:

```@example taxon
taxon("cow") |> authority
```

You can pass an additional `strict=false` keyword argument to the `taxon`
function to perform fuzzy name matching using the Levenshtein distance:

```@example taxon
taxon("Paradiplozon homion", strict=false)
```

Note that fuzzy searching comes at a performance cost, so it is preferable to
use the strict matching unless necessary. As a final note, you can specify any
distance function from the `StringDistances` package, using the `dist` argument.

## Errors

```@docs
NameHasNoDirectMatch
NameHasMultipleMatches
```


## Building a better namefilter

The `taxon` function, by default, searches in the entire names table. In many
cases, we can restrict the scope of the search quite a lot by searching only in
the range of names that match a given condition. For this reason, the `taxon`
function also has a method with a first argument being a data frame of names.
These are generated using `namefilter`, as well as a varitety of helper
functions.

```@docs
namefilter
```

Here is an illustration of why using namefilters makes sense. Let's say we have
to search for a potentially misspelled name:

```@example taxon
@time taxon("Ebulavurus"; strict=false);
```

We can use the `virusfilter()` function to generate a table with viruses only:

```@example taxon
viruses = virusfilter()
@time taxon(viruses, "Bumbulu ebolavirus"; strict=false);
```

A `namefilter` can be built in a number of ways, including by passing a list of
taxa:

```@example taxon
diplectanids = namefilter(descendants(ncbi"Diplectanidae"))
taxon(diplectanids, "Lamellodiscus")
```

## Standard namefilters

To save some time, there are namefilters pre-populated with the large-level
taxonomic divisions.

```@docs
bacteriafilter
virusfilter
mammalfilter
vertebratefilter
plantfilter
invertebratefilter
rodentfilter
primatefilter
phagefilter
environmentalsamplesfilter
```

All of these return a dataframe which can be passed to the `taxon` function as a
first argument.
