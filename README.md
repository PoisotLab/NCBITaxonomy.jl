# NCBI taxonomy

![Proof of concept](https://img.shields.io/badge/status-proof%20of%20concept-lightgrey)

![CI](https://github.com/EcoJulia/NCBITaxonomy.jl/workflows/CI/badge.svg)

![Documentation](https://github.com/EcoJulia/NCBITaxonomy.jl/workflows/Documentation/badge.svg)

This package provides an interface to the [NCBI Taxonomy][ncbitax]. When
installed, it will download the *latest* version of the taxonomy files from the
NCBI `ftp` service. To update the version of the taxonomy you use, you need to
build the package again.

[ncbitax]: https://www.ncbi.nlm.nih.gov/taxonomy

This package is developed as part of the activities of the Viral Emergence
Research Initiative ([VERENA][verena]) consortium, with financial support from
the Institut de Valorisation des Données ([IVADO][ivado]) at Université de
Montréal.

[verena]: https://www.viralemergence.org/
[ivado]: https://ivado.ca/en/

## How to use

### Get the taxonomic ID of a node

The `taxid` function will return a `NCBITaxon` object, which has two fields:
`name` and `id`. We do not return the `class` attribute, because the package
will always return the scientific name, as the examples below illustrate:

```julia
julia> taxid("Bos taurus")
Bos taurus (9913)
```

Note that because the names database contains vernacular and deprecated names,
the *scientific name* will be returned, no matter what you search

```julia
julia> taxid("cow")
Bos taurus (9913)
```

You can pass an additional `fuzzy=true` keyword argument to the `taxid` function
to perform fuzzy name matching using the Levenshtein distance:

```julia
julia> taxid("Paradiplozon homion", fuzzy=true)
Paradiplozoon homoion (147838)
```

Note that both fuzzy searching and non-standard naming come at a performance cost:

```julia
julia> @time taxid("tchiken", fuzzy=true)
  0.629431 seconds (15.88 M allocations: 438.590 MiB, 6.48% gc time)
Gallus gallus (9031)

julia> @time taxid("Gallus gallus")
  0.103331 seconds (3.16 M allocations: 158.598 MiB)
Gallus gallus (9031)
```

### Working with namefinders

The `namefinder` function has one job: generating a function that works exactly
like `taxid`, but only searches on a smaller subset of the data. In fact,
`taxid` is a special case of `namefinder`, which simply searches the whole
database. At the moment, there is no convenient wrapper to generate namefinders,
but there will soon be a few (using the `children` and `descendants` functions
explained below).

Here is an illustration of why using namefinders makes sense. Let's say we have
to search for a potentially misspelled name:

```julia
julia> @time taxid("Evolavirus"; fuzzy=true)
  0.382734 seconds (12.76 M allocations: 348.658 MiB, 6.03% gc time)
Ebolavirus (186536)
```

We can build a more efficient namefinder by selecting the nodes in the taxonomy
that belong to the `VRL` division. Doing so requires to call `namefinder` on a
`DataFrame`. Note that we are doing some merging here, which results in the data
frame we use having more columns than the names data frame -- but this does not
matter, because the `namefinder` is not picky about having *too much*
information.

```julia
julia> viralfinder = namefinder(
         join(
           @where(
               select(NCBITaxonomy.nodes_table, [:tax_id, :division_code]),
               :division_code .== Symbol("VRL")
           ),
           NCBITaxonomy.names_table;
           on = :tax_id
         )
       )
(::var"#_inner_finder#9"{var"#_inner_finder#8#10"{DataFrame}}) (generic function with 1 method)
```

Is it worth it?

```julia
julia> @time viralfinder("Evolavirus"; fuzzy=true)
  0.028657 seconds (631.35 k allocations: 11.617 MiB)
Ebolavirus (186536)
```

This is almost 10 times faster than the solution using `taxid`.

### Get the children and descendants of a node

The `children` function returns all nodes immediately *below* the node of
reference.

```julia
julia> taxid("Diplectanidae") |> children
22-element Array{NCBITaxon,1}:
```

The `descendants` functions *recursively* returns all nodes below the reference
one, until the tips of the taxonomy are reached. Note that this might include
unidentified or environmental samples.

```julia
julia> taxid("Diplectanidae") |> descendants
126-element Array{NCBITaxon,1}:
```

Note that for the moment, these functions are not optimized. They will be, but
right now, they are not.

## Varia

Internally, the package relies on the files provided by NCBI to reconstruct the
taxonomy -- the README for what the files contain can be found [here][readme].
Note that the files *and* their expected MD5 checksum are downloaded when the
package is built, and the data are *not* extracted unless the checksum matches.
The package will also check that the checksum on the server is different from
the version on disk, to avoid downloading data for nothing.

[readme]: https://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/taxdump_readme.txt

The data are saved as arrow tables when the package is built, and these are
loaded when the package is loaded with `import` or `using`, as `DataFrames`.
These data frames are *not* exported, but they are used by the various function
of the package. Note also that a number of fields are removed, and some tables
are pre-merged - not at build time (so there is no information loss, and you are
welcome to dig into the full data frame by reloading the arrow file), but at
load time.