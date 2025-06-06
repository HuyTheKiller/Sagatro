local booster_table = {

}

for _, v in ipairs(booster_table) do
    if Sagatro.debug then
        v.no_collection = nil
    end
    SMODS.Booster(v)
end