"""
    taxid(name::T) where {T <: String}

Returns the taxonomic ID of a taxon, given as a string.
"""
function taxid(name::T) where {T <: String}
    f = isequal(name)
    first_index = findfirst(f.(NCBITaxonomy.names_table.name))
    row = NCBITaxonomy.names_table[first_index,:]
    if row.class == Symbol("scientific name")
        return NCBITaxon(row.name, row.tax_id)
    else
        return NCBITaxon(_get_sciname_from_taxid(row.tax_id), row.tax_id)
    end
end

"""
This is a doc
"""
taxid(name::T, f::Symbol) where {T <: String} = taxid(name, Val{f}())
taxid(name::T, ::Val{:strict}) where {T <: String} = taxid(name)

function taxid(name::T, ::Val{:fuzzy}) where {T <: String}
    correct_name, position = findnearest(name, NCBITaxonomy.names_table.name, Levenshtein())
    row = NCBITaxonomy.names_table[position,:]
    if row.class == Symbol("scientific name")
        return NCBITaxon(row.name, row.tax_id)
    else
        return NCBITaxon(_get_sciname_from_taxid(row.tax_id), row.tax_id)
    end
end

function _get_sciname_from_taxid(id::Int)
    return first(@where(NCBITaxonomy.names_table, :tax_id .== id, :class .== Symbol("scientific name")).name)
end