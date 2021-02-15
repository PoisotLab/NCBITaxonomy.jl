function _divisionfinder(division::Symbol)
    nodes_subset = select(NCBITaxonomy.nodes_table, [:tax_id, :division_code])
    filter!((r) -> r.division_code == division, nodes_subset)
    df = leftjoin(nodes_subset, NCBITaxonomy.names_table; on=:tax_id)
    return namefinder(df)
end

function _divisionfinder(division::Vector{Symbol})
    nodes_subset = select(NCBITaxonomy.nodes_table, [:tax_id, :division_code])
    filter!((r) -> r.division_code in division, nodes_subset)
    df = leftjoin(nodes_subset, NCBITaxonomy.names_table; on=:tax_id)
    return namefinder(df)
end

"""
    virusfinder()

Returns a `namefinder` limited to the viral division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments. Note that phage are covered by `phagefinder`.
"""
virusfinder() = _divisionfinder(:VRL)

"""
    bacteriafinder()

Returns a `namefinder` limited to the bacterial division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
bacteriafinder() = _divisionfinder(:BCT)

"""
    plantfinder()

Returns a `namefinder` limited to the "plant and fungi" division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
plantfinder() = _divisionfinder(:PLN)

"""
    primatefinder()

Returns a `namefinder` limited to the primate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
primatefinder() = _divisionfinder(:PRI)

"""
    rodentfinder()

Returns a `namefinder` limited to the rodent division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
rodentfinder() = _divisionfinder(:ROD)

"""
    mammalfinder(;inclusive::Bool=true)

Returns a `namefinder` limited to the mammal division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case rodents (covered by
`rodentfinder`) and primates (covered by `primatefinder`). The default behavior
is to include these groups.
"""
mammalfinder(inclusive::Bool=true) = inclusive ? _divisionfinder([:MAM, :ROD, :PRI]) : _divisionfinder(:MAM)

"""
    vertebratefinder(;inclusive::Bool=true)

Returns a `namefinder` limited to the vertebrate division of the NCBI taxonomy.
See the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case mammals (covered by
`mammalfinder`). The default behavior is to include these groups, which also
include the groups covered by `mammalfinder` itself.
"""
vertebratefinder(inclusive::Bool=true) = inclusive ? _divisionfinder([:VRT, :MAM, :ROD, :PRI]) : _divisionfinder(:VRT)

"""
    invertebratefinder()

Returns a `namefinder` limited to the invertebrate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

Note that this is limited organisms not covered by `plantfinder`,
`bacteriafinder`, and `virusfinder`.
"""
invertebratefinder() = _divisionfinder(:INV)

"""
    phagefinder()

Returns a `namefinder` limited to the phage division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
phagefinder() = _divisionfinder(:PHG)


"""
    environmentalsamplesfinder()

Returns a `namefinder` limited to the environmental samples division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
environmentalsamplesfinder() = _divisionfinder(:ENV)