# Navigating lineages

## Core functions

```@docs
lineage
children
descendants
```

## Examples

The `children` function will return a list of `NCBITaxon` that are immediately
descending from the one given as argument. For example, the genus
*Lamellodiscus* contains:

```@example lineages
using NCBITaxonomy

ncbi"Lamellodiscus" |> children
```

To get the full descendants of a taxon (*i.e.* the children of its children, recursively), we can do:

```@example lineages
descendants(ncbi"Diplectanidae")
```

We can also work upwards in the taxonomy, using the `lineage` function -- it
takes an optional `stop_at` argument, which is the farther up it will go:

```@example lineages
lineage(ncbi"Lamellodiscus elegans"; stop_at=ncbi"Monogenea")
```

## Internal functions

```@docs
NCBITaxonomy._descendant_nodes
NCBITaxonomy._taxa_from_id
NCBITaxonomy._children_nodes
```