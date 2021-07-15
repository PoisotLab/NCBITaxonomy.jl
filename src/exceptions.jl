"""
    MultipleNamesMatched

Throw an exception when the name matches an "in-part" name, *i.e.* a name
that is associated to multiple resolved taxa in the NCBI backbone. The
error message will return the names of the components taxa.
"""
struct MultipleNamesMatched <: Exception
    name::String
    taxa::Vector{NCBITaxonomy.NCBITaxon}
end

function Base.showerror(io::IO, e::MultipleNamesMatched)
    message = "The name $(e.name) is an invalid node.\n"
    message *= "Do you mean\n"
    for taxa in e.taxa
        message *= "→ $(taxa.name) ($(taxa.id))\n"
    end
    message *= "Please pick the correct taxa"
    print(io, message)
end

