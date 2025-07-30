local saga_deck = {
    key = "saga",
    name = "Saga Deck",
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

local grimoire_deck = {
    key = "grimoire",
    name = "Grimoire Deck",
    atlas = "decks",
    pos = { x = 1, y = 0 },
    config = {vouchers = {'v_sgt_oculus_divina', 'v_sgt_shadow_oath'}, consumables = {'c_sgt_rex_divinus'}, ante_scaling = 1.5},
    loc_vars = function(self, info_queue, back)
        return {
            vars = {localize{type = 'name_text', key = self.config.vouchers[1], set = 'Voucher'},
            localize{type = 'name_text', key = self.config.vouchers[2], set = 'Voucher'},
            self.config.ante_scaling,
            localize{type = 'name_text', key = self.config.consumables[1], set = 'Divinatio'}}
        }
    end,
}

local deck_table = {
    saga_deck,
    grimoire_deck,
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

    local grimoire_sleeve = {
        key = "grimoire",
		name = "Grimoire Sleeve",
		atlas = 'sleeves',
		pos = { x = 1, y = 0 },
		unlocked = false,
		unlock_condition = { deck = "b_sgt_grimoire", stake = "stake_purple" },
        apply = function(self, sleeve)
            CardSleeves.Sleeve.apply(sleeve)
            if self.get_current_deck_key() ~= "b_sgt_grimoire"
            and (G.GAME.starting_params.ante_scaling or 1) < self.config.conditional_ante_scaling then
                G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * self.config.conditional_ante_scaling
            elseif self.get_current_deck_key() == "b_sgt_grimoire" then
                G.GAME.starting_params.ante_scaling = self.config.conditional_ante_scaling
            end
		end,
        loc_vars = function(self)
            local key = self.key
			if self.get_current_deck_key() == "b_sgt_grimoire" then
				key = key .. "_alt"
                self.config = {vouchers = {'v_sgt_oculus_omniscientis', 'v_sgt_abyss_pact'}, conditional_ante_scaling = 2}
			else
				key = self.key
                self.config = {vouchers = {'v_sgt_oculus_divina', 'v_sgt_shadow_oath'}, consumables = {'c_sgt_rex_divinus'}, conditional_ante_scaling = 1.5}
			end
            local vars = {localize{type = 'name_text', key = self.config.vouchers[1], set = 'Voucher'},
            localize{type = 'name_text', key = self.config.vouchers[2], set = 'Voucher'},
            self.config.conditional_ante_scaling}
            if self.get_current_deck_key() ~= "b_sgt_grimoire" then
                vars[4] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Divinatio'}
            end
			return { key = key, vars = vars }
		end,
    }

    local sleeve_table = {
        saga_sleeve,
        grimoire_sleeve,
    }

    for _, v in ipairs(sleeve_table) do
        if Sagatro.debug then
            v.unlocked = true
        end
        CardSleeves.Sleeve(v)
    end
end