# Finding taxa

## The `taxid` function

```@docs
taxid
```

The `taxid` function will return a `NCBITaxon` object, which has two fields:
`name` and `id`. We do not return the `class` attribute, because the package
will always return the scientific name, as the examples below illustrate:

```@example taxid
using NCBITaxonomy
taxid("Bos taurus")
```

Note that because the names database contains vernacular and deprecated names,
the *scientific name* will be returned, no matter what you search

```@example taxid
taxid("cow")
```

You can pass an additional `fuzzy=true` keyword argument to the `taxid` function
to perform fuzzy name matching using the Levenshtein distance:

```@example taxid
taxid("Paradiplozon homion", fuzzy=true)
```

Note that both fuzzy searching and non-standard naming come at a performance
cost, so it is preferable to use the strict matching unless necessary.

## Building a better namefinder

The `namefinder` function has one job: generating a function that works exactly
like `taxid`, but only searches on a smaller subset of the data. In fact,
`taxid` is a special case of `namefinder`, which simply searches the whole
database. At the moment, there is no convenient wrapper to generate namefinders.

```@docs
namefinder
```

Here is an illustration of why using namefinders makes sense. Let's say we have
to search for a potentially misspelled name:

```@example taxid
@time taxid("Evolavirus"; fuzzy=true)
```

We can build a more efficient namefinder by selecting the nodes in the taxonomy
that belong to the `VRL` division. Doing so requires to call `namefinder` on a
`DataFrame`. Note that we are doing some merging here, which results in the data
frame we use having more columns than the names data frame -- but this does not
matter, because the `namefinder` is not picky about having *too much*
information.

```@example taxid
using DataFrames, DataFramesMeta
viralfinder = namefinder(
         join(
           @where(
               select(NCBITaxonomy.nodes_table, [:tax_id, :division_code]),
               :division_code .== Symbol("VRL")
           ),
           NCBITaxonomy.names_table;
           on = :tax_id
         )
       )

@time viralfinder("Evolavirus"; fuzzy=true)
```

## Internal functions

```@docs
NCBITaxonomy._get_sciname_from_taxid
```