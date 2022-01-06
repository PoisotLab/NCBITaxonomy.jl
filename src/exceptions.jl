"""
    IDNotFoundInBackbone

This exception is thrown when the ID is not found in the current version of the backbone.
"""
struct IDNotFoundInBackbone <: Exception
    id::Integer
end

function Base.showerror(io::IO, e::IDNotFoundInBackbone)
    message = "The TAX ID $(e.id) is not in the current version of the backbone."
    print(io, message)
end

"""
    NameHasNoDirectMatch

This exception is thrown when the name passed as an argument does not have a
direct match, in which case using `strict=false` to switch to fuzzy matching
may be advised.
"""
struct NameHasNoDirectMatch <: Exception
    name::String
end

function Base.showerror(io::IO, e::NameHasNoDirectMatch)
    message = "The name $(e.name) has no direct match\n"
    message *= "Possible fixes are\n"
    message *= "→ do a lowercase search with `lowercase=true`\n"
    message *= "→ do a fuzzy search with `strict=false`\n"
    message *= "→ look at the output of `similarnames(\"$(e.name)\")`"
    print(io, message)
end

"""
    NameHasMultipleMatches

This exception is thrown when the name is an "in-part" name, which is not a
valid node but an aggregation of multiple nodes. It is also thrown when the name
is valid for several nodes. The error message will return the taxa that could be
used instead. "Reptilia" is an example of a node that will throw this exception
(in-part name); "Mus" will throw this example as it is valid subgenus of itself.

Note that the error object has a `taxa` field, which stores the `NCBITaxon` that
were matched; this allows to catch the error and look for the taxon you want
without relying on *e.g.* `alternativetaxa`.
"""
struct NameHasMultipleMatches <: Exception
    name::String
    taxa::Vector{NCBITaxonomy.NCBITaxon}
end

function Base.showerror(io::IO, e::NameHasMultipleMatches)
    message = "The name $(e.name) is ambiguous.\n"
    message *= "In the NCBI taxonomy, it refers to\n"
    for taxa in e.taxa
        message *= "→ the $(rank(taxa)) $(taxa)\n"
    end
    message *= "Please pick the correct taxa\n"
    message *= "You can get a list of correct taxa using `alternativetaxa(\"$(e.name)\")`\n"
    print(io, message)
end

