"""
    virusfilter()

Returns a `namefinder` limited to the viral division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments. Note that phage are covered by `phagefinder`.
"""
virusfilter() = namefilter(:VRL)

"""
    bacteriafilter()

Returns a `namefinder` limited to the bacterial division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
bacteriafilter() = namefilter(:BCT)

"""
    plantfilter()

Returns a `namefinder` limited to the "plant and fungi" division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
plantfilter() = namefilter(:PLN)

"""
    primatefilter()

Returns a `namefinder` limited to the primate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
primatefilter() = namefilter(:PRI)

"""
    rodentfilter()

Returns a `namefinder` limited to the rodent division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
rodentfilter() = namefilter(:ROD)

"""
    mammalfilter(;inclusive::Bool=true)

Returns a `namefinder` limited to the mammal division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case rodents (covered by
`rodentfinder`) and primates (covered by `primatefinder`). The default behavior
is to include these groups.
"""
mammalfilter(inclusive::Bool=true) = inclusive ? namefilter([:MAM, :ROD, :PRI]) : namefilter(:MAM)

"""
    vertebratefilter(;inclusive::Bool=true)

Returns a `namefinder` limited to the vertebrate division of the NCBI taxonomy.
See the documentation for `namefinder` and `taxid` for more information about
arguments.

If the keyword argument `inclusive` is set to `false`, this will *not* search
for organisms assigned to a lower division, in this case mammals (covered by
`mammalfinder`). The default behavior is to include these groups, which also
include the groups covered by `mammalfinder` itself.
"""
vertebratefilter(inclusive::Bool=true) = inclusive ? namefilter([:VRT, :MAM, :ROD, :PRI]) : namefilter(:VRT)

"""
    invertebratefilter()

Returns a `namefinder` limited to the invertebrate division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.

Note that this is limited organisms not covered by `plantfinder`,
`bacteriafinder`, and `virusfinder`.
"""
invertebratefilter() = namefilter(:INV)

"""
    phagefilter()

Returns a `namefinder` limited to the phage division of the NCBI taxonomy. See
the documentation for `namefinder` and `taxid` for more information about
arguments.
"""
phagefilter() = namefilter(:PHG)


"""
    environmentalsamplesfilter()

Returns a `namefinder` limited to the environmental samples division of the NCBI
taxonomy. See the documentation for `namefinder` and `taxid` for more
information about arguments.
"""
environmentalsamplesfilter() = namefilter(:ENV)