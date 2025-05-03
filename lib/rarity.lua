local obscure = {
    key = "obscure",
	badge_colour = G.C.SGT_OBSCURE,
	default_weight = 0.003,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		if Sagatro.DisableOtherJokers then
			return 0
		end
        return 0.003
	end,
}

local esoteric = {
    key = "esoteric",
	badge_colour = G.C.SGT_ESOTERIC,
	default_weight = 0,
	pools = { ["Joker"] = false },
	get_weight = function(self, weight, object_type)
		return weight
	end,
}

local rarity_table = {
    obscure,
    esoteric,
}

for _, v in ipairs(rarity_table) do
    SMODS.Rarity(v)
end