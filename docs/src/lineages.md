# Navigating lineages

```@docs
lineage
children
descendants
```

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

