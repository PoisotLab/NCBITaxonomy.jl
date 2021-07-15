struct NCBIMultipleMatchesException <: Exception
    name::String
    taxa::Array{NCBITaxonomy.NCBITaxon}
end

function Base.showerror(io::IO, e::NCBIMultipleMatchesException)
    message = "The name $(e.name) is an in-part name\n"
    message *= "It is composed of the following taxa:\n"
    for taxa in e.taxa
        message *= "\t$(taxa.name) ($(taxa.id))\n"
    end
    message *= "Please pick the correct taxa"
    return print(io, message)
end

