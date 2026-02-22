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
    alice_m = "Alice Through the Looking Glass",
    story_starter = "Story Starter",
    pmirror = "Pocket Mirror",
}

for _, v in pairs(SAGA_GROUP_POOL) do
    SMODS.ObjectType{key = v, default = "j_sgt_abducted_cow"}
end