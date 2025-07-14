SAGA_GROUP_POOL = {
    alice = "Alice in Wonderland",
    gfrog = "Goodbye Frog",
	fsd = "Final Showdown",
	["20k"] = "20k Miles Under The Sea",
    common_fish = "Common Fish",
}

for _, v in pairs(SAGA_GROUP_POOL) do
    SMODS.ObjectType{key = v}
end