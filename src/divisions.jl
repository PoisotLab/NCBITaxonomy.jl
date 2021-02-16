function _divisionfinder(division::Symbol; strict::Bool=false)
    nodes_subset = select(NCBITaxonomy.nodes_table, [:tax_id, :division_code])
    filter!((r) -> r.division_code == division, nodes_subset)
    df = leftjoin(nodes_subset, NCBITaxonomy.names_table; on=:tax_id)
    return namefinder(df; strict=strict)
end

function _divisionfinder(division::Vector{Symbol}; strict::Bool=false)
    nodes_subset = select(NCBITaxonomy.nodes_table, [:tax_id, :division_code])
    filter!((r) -> r.division_code in division, nodes_subset)
    df = leftjoin(nodes_subset, NCBITaxonomy.names_table; on=:tax_id)
    return namefinder(df; strict=strict)
end

"""
    virusfinder(;strict::Bool=false)

Returns a `namefinder` limited to the viral division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments. Note that phage are covered by `phagefinder`.
"""
virusfinder(;strict::Bool=false) = _divisionfinder(:VRL; strict=strict)

"""
    bacteriafinder(;strict::Bool=false)

Returns a `namefinder` limited to the bacterial division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
bacteriafinder(;strict::Bool=false) = _divisionfinder(:BCT; strict=strict)

"""
    plantfinder(;strict::Bool=false)

Returns a `namefinder` limited to the "plant and fungi" division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
plantfinder(;strict::Bool=false) = _divisionfinder(:PLN; strict=strict)

"""
    primatefinder(;strict::Bool=false)

Returns a `namefinder` limited to the primate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
primatefinder(;strict::Bool=false) = _divisionfinder(:PRI; strict=strict)

"""
    rodentfinder(;strict::Bool=false)

Returns a `namefinder` limited to the rodent division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
rodentfinder(;strict::Bool=false) = _divisionfinder(:ROD; strict=strict)

"""
    mammalfinder(;inclusive::Bool=true, strict::Bool=false)

Returns a `namefinder` limited to the mammal division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case rodents (covered by
`rodentfinder`) and primates (covered by `primatefinder`). The default behavior
is to include these groups.
"""
mammalfinder(inclusive::Bool=true, strict::Bool=false) = inclusive ? _divisionfinder([:MAM, :ROD, :PRI]; strict=strict) : _divisionfinder(:MAM; strict=strict)

"""
    vertebratefinder(;inclusive::Bool=true, strict::Bool=false)

Returns a `namefinder` limited to the vertebrate division of the NCBI taxonomy.
See the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case mammals (covered by
`mammalfinder`). The default behavior is to include these groups, which also
include the groups covered by `mammalfinder` itself.
"""
vertebratefinder(inclusive::Bool=true, strict::Bool=false) = inclusive ? _divisionfinder([:VRT, :MAM, :ROD, :PRI]; strict=strict) : _divisionfinder(:VRT; strict=strict)

"""
    invertebratefinder(;strict::Bool=false)

Returns a `namefinder` limited to the invertebrate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

Note that this is limited organisms not covered by `plantfinder`,
`bacteriafinder`, and `virusfinder`.
"""
invertebratefinder(;strict::Bool=false) = _divisionfinder(:INV; strict=strict)

"""
    phagefinder(;strict::Bool=false)

Returns a `namefinder` limited to the phage division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
phagefinder(;strict::Bool=false) = _divisionfinder(:PHG; strict=strict)


"""
    environmentalsamplesfinder(;strict::Bool=false)

Returns a `namefinder` limited to the environmental samples division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
environmentalsamplesfinder(;strict::Bool=false) = _divisionfinder(:ENV; strict=strict)