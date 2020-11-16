# NCBI taxonomy

![Proof of concept](https://img.shields.io/badge/status-proof%20of%20concept-lightgrey)

![CI](https://github.com/EcoJulia/NCBITaxonomy.jl/workflows/CI/badge.svg)   
[![codecov](https://codecov.io/gh/EcoJulia/NCBITaxonomy.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EcoJulia/NCBITaxonomy.jl)

![Documentation](https://github.com/EcoJulia/NCBITaxonomy.jl/workflows/Documentation/badge.svg)   
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://ecojulia.github.io/NCBITaxonomy.jl/stable)   
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://ecojulia.github.io/NCBITaxonomy.jl/dev)

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

