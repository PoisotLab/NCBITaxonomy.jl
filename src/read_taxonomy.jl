function read_taxonomy(tables_path)

    # Prepare the files we will actually use
    names_table = DataFrame(Arrow.Table(joinpath(tables_path, "names.arrow")))
    names_table.class = NCBINameClass.(names_table.class)
    names_table.lowercase = lowercase.(names_table.name)

    division_table = DataFrame(Arrow.Table(joinpath(tables_path, "division.arrow")))
    select!(division_table, Not(:comments))

    nodes_table = DataFrame(Arrow.Table(joinpath(tables_path, "nodes.arrow")))
    select!(nodes_table, Not(r"inherited_"))
    select!(nodes_table, Not(r"_code_id"))
    select!(nodes_table, Not(:genbank_hidden))
    select!(nodes_table, Not(:hidden_subtree))
    select!(nodes_table, Not(:comments))
    select!(nodes_table, Not(:embl))

    nodes_table = innerjoin(nodes_table, division_table; on = :division_id)
    select!(nodes_table, Not(:division_id))

    names_table = leftjoin(
        names_table,
        unique(select(nodes_table, [:tax_id, :rank, :parent_tax_id]));
        on = :tax_id,
    )

    nodes_table = nothing
    division_table = nothing
    GC.gc()

    return names_table

end