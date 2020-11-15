"""
    taxid(name::T) where {T <: String}

Returns the taxonomic ID of a taxon, given as a string.
"""
function taxid(name::T; fuzzy::Bool=false) where {T <: String}
    if fuzzy
        correct_name, position = findnearest(name, NCBITaxonomy.names_table.name, Levenshtein())
    else
        position = findfirst(isequal(name).(NCBITaxonomy.names_table.name))
    end
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