local red_queen = {
    key = "red_queen",
    name = "Red Queen",
    atlas = "red_queen",
    pos = { x = 0, y = 0 },
    mult = 6,
    dollars = 10,
    boss = {
        min = 1,
		max = 10,
		showdown = true,
	},
    boss_colour = HEX("AA0000"),
    recalc_debuff = function(self, card, from_blind)
        if card.area ~= G.jokers and not G.GAME.blind.disabled then
            return true
        end
        return false
    end,
    disable = function(self, silent)
		G.GAME.blind.chips = G.GAME.blind.chips/3
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end,
    in_pool = function(self)
        return not G.GAME.story_mode
    end,
}

local blind_table = {
    red_queen,
}

for _, v in ipairs(blind_table) do
    SMODS.Blind(v)
end