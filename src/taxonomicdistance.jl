"""

This function fills a pre-allocated square matrix `D` with the taxonomic
distance between taxa in a vector `tax`. The keywords areguments are `d` (the
distance as a function to closest matching level), `strict` (a boolean to decide
whether the distance of a taxon with itself should be read from the distance
dictionary, or set to 0), and other keywords passed to the `lineage` function.

Because the distances are symetrical, there are only (n(n-1))/2 measurements to
do.

By default, this function uses the distances from Shimatani (2001):

| equal rank  | distance |
|-------------|----------|
| species     | 0        |
| genus       | 1        |
| family      | 2        |
| subclass    | 3        |
| `:fallback` | 4        |

Shimatani, K. 2001. On the measurement of species diversity incorporating
species differences. Oikos 93:135–147. 
"""
function taxonomicdistance!(D::Matrix{Float64}, tax::Vector{NCBITaxon}; d::Dict{Symbol,Float64}=Dict(:species=>0.0, :genus=>1.0, :family=>2.0, :subclass=>3.0, :fallback=>4.0), strict::Bool=true, kwargs...)
    if size(D,1) != size(D,2)
        throw(DimensionMismatch("The matrix `D` ($(size(D))) must be square" )) 
    end
    if size(D,1) != length(tax)
        throw(DimensionMismatch("The matrix `D` ($(size(D,1))) must have the same sizes as the length of `tax` ($(length(tax)))."))
    end
    ancestry = lineage.(tax; kwargs...)
    for i in 1:(length(tax)-1)
        D[i,i] = strict ? get(d, rank(tax[i]), d[:fallback]) : 0.0
        ai = ancestry[i]
        for j in (i+1):length(tax)
            aj = ancestry[j]
            shared = rank.(ai ∩ aj)
            D[i,j] = D[j,i] = minimum([get(d, s, d[:fallback]) for s in shared])
        end
    end
    return D
end

"""
    taxonomicdistance(tax::Vector{NCBITaxon}; kwargs...)

See `taxonomicdistance!`.
"""
function taxonomicdistance(tax::Vector{NCBITaxon}; kwargs...)
    D = zeros(Float64, length(tax), length(tax))
    taxonomicdistance!(D, tax; kwargs...)
    return D
end