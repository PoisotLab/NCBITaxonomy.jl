function uwu(taxon::NCBITaxon)
    l = lineage(taxon)
    if ncbi"Bacteria" in l
        return "🦠"
    end
    if ncbi"Virus" in l
        return "☣️"
    end
    if ncbi"Aves" in l
        if ncbi"Gallus" in l
            return "🐔"
        end
        return "🐦"
    end
    if ncbi"Bovidae" in l
        return "🐄"
    end
    if ncbi"fishes" in l
        return "🐠"
    end
    if ncbi"whales" in l
        return "🐳"
    end
    if ncbi"Culicomorpha" in l
        return "🦟"
    end
    if ncbi"fungi" in l
        return "🍄"
    end
    if ncbi"Ursidae" in l
        return "🐻"
    end
    if ncbi"raccoon" in l
        return "🦝"
    end
    if ncbi"Caniformia" in l
        return "🐶"
    end
    if ncbi"Viridiplantae" in l
        if ncbi"eggplant" in l
            return "🍆"
        end
        if ncbi"Magnioliopsida" in l     
            return "🌻"
        end
        if ncbi"Acereae" in l
            return "🍁"
        end
        return "🍀"
    end
    if ncbi"Bambusoideae" in l
        return "🎍"
    end
    if ncbi"Chiroptera" in l
        return "🦇"
    end
    if ncbi"Panthera" in l
        return "🐅"
    end
    if ncbi"Felidae" in l
        return "🐈"
    end
    return "🤷"
end