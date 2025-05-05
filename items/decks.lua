local saga_deck = {
    key = "saga",
    atlas = "decks",
    pos = { x = 0, y = 0 },
    config = {joker_slot = 3, extra = {win_ante_gain = 16}},
    apply = function(self, back)
		G.GAME.win_ante = G.GAME.win_ante + self.config.extra.win_ante_gain
	end,
    loc_vars = function(self)
        return {vars = {self.config.joker_slot, 8 + self.config.extra.win_ante_gain}}
    end,
}

local deck_table = {
    saga_deck,
}

for _, v in ipairs(deck_table) do
    SMODS.Back(v)
end