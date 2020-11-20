struct NCBITaxon
    name::String
    id::Int
end

Base.show(io::IO, t::NCBITaxon) = print(io, "$(t.name) ($(t.id))")

@enum NCBINameClass begin
    class_scientific_name=1
    class_equivalent_name=2
    class_common_name=3
    class_authority=4
    class_synonym=5
    class_in_part=6
    class_includes=7
    class_acronym=8
    class_genbank_common_name=9
    class_genbank_synonym=10
    class_genbank_acronym=11
    class_blast_name=12
end