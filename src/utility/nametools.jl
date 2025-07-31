"""
    vernacular(t::NCBITaxon)

This function will return `nothing` if no vernacular name is known, and an array
of names if found. It searches the "common name" and "genbank common name"
category of the NCBI taxonomy name table.
"""
function vernacular(tax::NCBITaxon)
    vern = filter(
        r -> r.class in
        [NCBITaxonomy.class_common_name, NCBITaxonomy.class_genbank_common_name],
        NCBITaxonomy.groupedtaxonomy[(tax_id = tax.id,)],
    )
    if isempty(vern)
        return nothing
    end
    return vern.name
end

"""
    synonyms(t::NCBITaxon)

This function will return `nothing` if no synonyms exist, and an array of names
if they do. It returns all of the
"""
function synonyms(tax::NCBITaxon)
    syno = filter(
        r -> r.class == NCBITaxonomy.class_synonym,
        NCBITaxonomy.groupedtaxonomy[(tax_id = tax.id,)],
    )
    if isempty(syno)
        return nothing
    end
    return syno.name
end

"""
    authority(t::NCBITaxon)

This function will return `nothing` if no authority exist, and a string with the
authority if found.
"""
function authority(tax::NCBITaxon)
    auth = filter(
        r -> r.class == NCBITaxonomy.class_authority,
        NCBITaxonomy.groupedtaxonomy[(tax_id = tax.id,)],
    )
    if isempty(auth)
        return nothing
    end
    return only(auth.name)
end
