local trivial = {
    key = "trivial",
	badge_colour = G.C.SGT_TRIVIAL,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		if G.GAME.story_mode then
			return next(SMODS.find_card("j_sgt_mad_hatter")) and 0.75 or 0
		end
        return next(SMODS.find_card("j_sgt_mad_hatter")) and 1 or 0.05
	end,
}

local obscure = {
    key = "obscure",
	badge_colour = G.C.SGT_OBSCURE,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		if G.GAME.story_mode then
			return 0.05
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
    trivial,
	obscure,
    esoteric,
}

for _, v in ipairs(rarity_table) do
    SMODS.Rarity(v)
end