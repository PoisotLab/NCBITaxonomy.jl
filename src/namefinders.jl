function namefinder(division::Symbol=:VRL)
    return namefinder(leftjoin(
    @where(
      select(NCBITaxonomy.nodes_table, [:tax_id, :division_code]),
      :division_code .== division
    ),
    NCBITaxonomy.names_table;
    on = :tax_id
  ))
end