local saga_deck = {
    key = "saga",
    atlas = "decks",
    pos = { x = 0, y = 0 },
    config = {joker_slot = 3, extra = {win_ante_gain = 8}},
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
    if Sagatro.debug then
        v.unlocked = true
    end
    SMODS.Back(v)
end

if CardSleeves then
    local saga_sleeve = {
		key = "saga",
		name = "Saga Sleeve",
		atlas = 'sleeves',
		pos = { x = 0, y = 0 },
		unlocked = false,
		unlock_condition = { deck = "b_sgt_saga", stake = "stake_purple" },
		apply = function(self, sleeve)
            CardSleeves.Sleeve.apply(sleeve)
			if self.get_current_deck_key() == "b_sgt_saga" then
				change_shop_size(self.config.extra.bonus_slots)
                SMODS.change_booster_limit(self.config.extra.bonus_slots)
            else
                G.GAME.win_ante = G.GAME.win_ante + self.config.extra.win_ante_gain
            end
		end,
		loc_vars = function(self)
			local key, vars = self.key, nil
			if self.get_current_deck_key() == "b_sgt_saga" then
				key = key .. "_alt"
                self.config = {extra = {bonus_slots = 2}}
                vars = {self.config.extra.bonus_slots}
			else
				key = self.key
                self.config = {joker_slot = 3, extra = {win_ante_gain = 8}}
                vars = {self.config.joker_slot, self.config.extra.win_ante_gain}
			end
			return { key = key, vars = vars }
		end,
	}

    local sleeve_table = {
        saga_sleeve,
    }

    for _, v in ipairs(sleeve_table) do
        if Sagatro.debug then
            v.unlocked = true
        end
        CardSleeves.Sleeve(v)
    end
end