"""
    similarnames(name::AbstractString)

Returns a list (as a vector of pairs) mapping an NCBI taxon to a similarity
score for the name given as argument.

Note that the function can return the same taxon more than once with different
scores, because it will look through the *entire* list of names, and not only
the scientific ones.

It may also return multiple taxa with the same score if the names are ambiguous,
in which case *all* alternative are given.

That being said, the taxa/score pairs will always be equal. For example, the
string `"mouse"` will match both the vernacular for Bryophyta (`"mosses"`) and
its synonym (`"Musci"`) with an equal dissimilarity under the Levenshtein
distance - the pair will be returned only once.
"""
function similarnames(name::AbstractString; kwargs...)
    df = NCBITaxonomy.names_table
    return similarnames(df, name; kwargs...)
end

"""
    similarnames(df::DataFrame, name::AbstractString; dist::Type{SD}=Levenshtein, threshold::Float64=0.8) where {SD <: StringDistance}

Generic version of similarnames
"""
function similarnames(df::DataFrame, name::AbstractString; dist::Type{SD}=Levenshtein, threshold::Float64=0.8) where {SD <: StringDistance}
    distance_matches = findall(name, df.name, dist(); min_score=threshold)
    _names = df.name[distance_matches]
    _ids = df.tax_id[distance_matches]
    _distances = [compare(name, _name, dist()) for _name in _names]
    _taxa = taxon.(_ids)
    _choices = [Pair(_taxa[i], _distances[i]) for i in 1:length(_taxa)]
    sort!(_choices; by=(x) -> x.second, rev=true)
    return unique(_choices)
end

"""
    alternativetaxa(df::DataFrame, name::AbstractString)

Generic version of `alternativetaxa` with an arbitrary data frame
"""
function alternativetaxa(df::DataFrame, name::AbstractString)
    positions = findall(isequal(name), df.name)
    length(positions) == 1 && return [df.tax_id[first(positions)]]
    return taxon.(df.tax_id[positions])
end

"""
    alternativetaxa(name::AbstractString)

Returns an array of taxa that share the same `name` -- note that this function
does *strict*, *case-sensitive* searches only at the moment, but this may be
extended through keyword arguments in a future release.
"""
function alternativetaxa(name::AbstractString)
    df = NCBITaxonomy.names_table
    return alternativetaxa(df, name)
end