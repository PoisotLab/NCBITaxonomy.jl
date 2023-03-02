"""
    descendantsfilter(t::NCBITaxon)

Returns a `namefinder` for all taxa below the one given as argument. This
function calls `descendants` internally, so it might not be the optimal way when
dealing with large groups.
"""
function descendantsfilter(t::NCBITaxon)
    d = descendants(t)
    df = _df_from_taxlist(d)
    return namefinder(df)
end
