module Speedo
    using Test
    using NCBITaxonomy
    using Traceur

    @check taxid("Vulpes vulpes")

    @check taxid("Vulpes vuspes"; fuzzy=true)

    @check children("Vulpes vulpes")

    @check descendants("Vulpes")
    
end