local wish_table = {

}

for _, v in ipairs(wish_table) do
    if Sagatro.debug then
        v.no_collection = nil
    end
    SMODS.Consumable(v)
end