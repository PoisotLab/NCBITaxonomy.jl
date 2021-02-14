function taxonomicdistance!(D::Matrix{Float64}, tax::Vector{NCBITaxonomy})
    if size(D,1) != size(D,2)
        throw(DimensionMismatch("The matrix `D` ($(size(D))) must be square" )) 
    end
    if size(D,1) != length(tax)
        throw(DimensionMismatch("The matrix `D` ($(size(D,1))) must have the same sizes as the length of `tax` ($(length(tax)))."))
    end
    ancestry = lineage.(tax)
    
    return D
end