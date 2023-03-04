module TestTaxoDistance
using NCBITaxonomy
using Test

tax = [
    ncbi"Lamellodiscus",
    ncbi"Dactylogyrus",
    ncbi"Paradiplozoon",
    ncbi"Diplectanum",
    ncbi"Echinoplectanum",
]

TD = taxonomicdistance(tax)

ETD = Float64[1 3 4 2 2; 3 1 4 3 3; 4 4 1 4 4; 2 3 4 1 2; 2 3 4 2 1]

@test TD == ETD

end