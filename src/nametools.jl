"""
    vernacular(t::NCBITaxon)

This function will return `nothing` if no vernacular name is known, and an array
of names if found. It searches the "common name" and "genbank common name"
category of the NCBI taxonomy name table.
"""
function vernacular(t::NCBITaxon)
    names_from_tax = filter(r -> r.tax_id == t.id, NCBITaxonomy.names_table)
    common_names = filter(r -> r.class == NCBITaxonomy.class_common_name, names_from_tax)
    genbank_names = filter(r -> r.class == NCBITaxonomy.class_genbank_common_name, names_from_tax)
    all_names = vcat(common_names.name, genbank_names.name)
    length(all_names) == 0 && return nothing
    return unique(all_names)
end

"""
    synonyms(t::NCBITaxon)

This function will return `nothing` if no synonyms exist, and an array of names
if they do. It returns all of the 
"""
function synonyms(t::NCBITaxon)
    names_from_tax = filter(r -> r.tax_id == t.id, NCBITaxonomy.names_table)
    syn = filter(r -> r.class == NCBITaxonomy.class_synonym, names_from_tax)
    size(syn,1) == 0 && return nothing
    return unique(syn.name)
end