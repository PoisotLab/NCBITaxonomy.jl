"""
    rank(taxon::NCBITaxon)

Returns the rank of a taxon.
"""
function rank(tax::NCBITaxon)
    return only(NCBITaxonomy.groupedscinames[tax.id].rank)
end
