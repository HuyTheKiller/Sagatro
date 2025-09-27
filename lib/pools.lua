SAGA_GROUP_POOL = {
    legend = "Saga-legendaries",
    alice = "Alice in Wonderland",
    gfrog = "Goodbye Frog",
	fsd = "Final Showdown",
	["20k"] = "20k Miles Under The Sea",
    common_fish = "Common Fish",
    lcraft = "Lovecraft",
    norse = "Norse Mythology",
    ngods = "Norse Gods",
    celestaverse = "Celestaverse",
}

for _, v in pairs(SAGA_GROUP_POOL) do
    SMODS.ObjectType{key = v}
end