macro ncbi_str(s)
    return NCBITaxonomy.names_table[findfirst(isequal(Symbol(s)), NCBITaxonomy.names_table.name),:]
end