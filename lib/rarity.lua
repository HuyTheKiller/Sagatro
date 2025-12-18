local trivial = {
    key = "trivial",
	badge_colour = G.C.SGT_TRIVIAL,
	pools = { ["Joker"] = true },
	default_weight = 0.01,
	get_weight = function(self, weight, object_type)
		if G.GAME.story_mode then
			return next(Sagatro.find_active_card("j_sgt_mad_hatter")) and weight or 0
		end
		return G.GAME.modifiers.sgt_disable_sagatro_items and 0 or weight
	end,
}

local obscure = {
    key = "obscure",
	badge_colour = G.C.SGT_OBSCURE,
	default_weight = 0.003,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
        return G.GAME.modifiers.sgt_disable_sagatro_items and 0 or weight
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