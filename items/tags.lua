local tag_table = {

}

for _, v in ipairs(tag_table) do
    if Sagatro.debug then
        v.no_collection = nil
    end
    SMODS.Tag(v)
end