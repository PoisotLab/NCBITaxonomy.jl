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
function similarnames(name::AbstractString; dist::Type{SD}=Levenshtein, threshold::Float64=0.8) where {SD <: StringDistance}
    distance_matches = findall(name, NCBITaxonomy.names_table.name, dist(); min_score=threshold)
    _names = NCBITaxonomy.names_table.name[distance_matches]
    _ids = NCBITaxonomy.names_table.tax_id[distance_matches]
    _distances = [compare(name, _name, dist()) for _name in _names]
    _taxa = taxon.(_ids)
    _choices = [Pair(_taxa[i], _distances[i]) for i in 1:length(_taxa)]
    sort!(_choices; by=(x) -> x.second, rev=true)
    return unique(_choices)
end
