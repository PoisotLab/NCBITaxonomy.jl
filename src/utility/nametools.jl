"""
    vernacular(t::NCBITaxon)

This function will return `nothing` if no vernacular name is known, and an array
of names if found. It searches the "common name" and "genbank common name"
category of the NCBI taxonomy name table.
"""
function vernacular(t::NCBITaxon)
    x = NCBITaxonomy.names_table[findall(NCBITaxonomy.names_table.tax_id .== t.id),:]
    p = findall(!isnothing, indexin(x.class, [NCBITaxonomy.class_common_name, NCBITaxonomy.class_genbank_common_name]))
    return length(p) == 0 ? nothing : x.name[p]
end

"""
    synonyms(t::NCBITaxon)

This function will return `nothing` if no synonyms exist, and an array of names
if they do. It returns all of the 
"""
function synonyms(t::NCBITaxon)
    x = NCBITaxonomy.names_table[findall(NCBITaxonomy.names_table.tax_id .== t.id),:]
    p = findall(isequal(NCBITaxonomy.class_synonym), x.class)
    return length(p) == 0 ? nothing : x.name[p]
end