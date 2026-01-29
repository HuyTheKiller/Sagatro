local saga_deck = {
    key = "saga",
    name = "Saga Deck",
    -- artist_credits = {"amy"},
    atlas = "decks",
    pos = { x = 0, y = 0 },
    config = {joker_slot = 3, extra = {win_ante_gain = 8}},
    apply = function(self, back)
		G.GAME.win_ante = G.GAME.win_ante + self.config.extra.win_ante_gain
        if Sagatro.config.DisableOtherJokers then
            local result = pseudorandom("saga_deck_mc_aura")
            if Sagatro.debug then
                print(result)
            end
            G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd =
            G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd or 0.997
            if result > (G.GAME.seeded and 0.997 or G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd) then
                if Sagatro.debug then
                    print(G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd)
                end
                delay(0.4)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, "c_soul", 'deck')
                        -- card:add_sticker("sgt_easter_egg", true)
                        card:set_edition("e_negative", true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        if result > 0.997 then
                            juice_card_until(card, function(_card) return not _card.states.hover.is end, true)
                        end
                        if not G.GAME.seeded then
                            G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd = 0.997
                        end
                    return true
                    end
                }))
            else
                if Sagatro.debug then
                    print(G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd)
                end
                if not G.GAME.seeded then
                    G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd =
                    G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd
                    - pseudorandom("saga_deck_mc_aura_dec", 10, 50)*0.001
                end
            end
            G:save_settings()
        end
	end,
    loc_vars = function(self)
        return {vars = {self.config.joker_slot, 8 + self.config.extra.win_ante_gain}}
    end,
}

local grimoire_deck = {
    key = "grimoire",
    name = "Grimoire Deck",
    -- artist_credits = {"amy"},
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

local celestaverse_deck = {
    key = "celestaverse",
    name = "Celestaverse Deck",
    -- artist_credits = {"amy"},
    atlas = "decks",
    pos = { x = 2, y = 0 },
    config = {vouchers = {'v_sgt_alien_life', 'v_sgt_civilization'}, consumable_slot = 1},
    loc_vars = function(self, info_queue, back)
        return {
            vars = {localize{type = 'name_text', key = self.config.vouchers[1], set = 'Voucher'},
            localize{type = 'name_text', key = self.config.vouchers[2], set = 'Voucher'},
            self.config.consumable_slot}
        }
    end,
}

local test = {
    key = "test",
    name = "Test Deck",
    loc_txt = {
        name = "Test Deck",
        text = {
            "This deck does {C:attention}something{}",
            "on {C:dark_edition}HuyTheKiller{}'s demand",
            "",
            "Current effect:",
            "Start with {C:dark_edition}Exponent{} operator",
        }
    },
    debug_obj = true,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({func = function()
            SMODS.set_scoring_calculation("exponent")
        return true end }))
    end,
}

local deck_table = {
    saga_deck,
    grimoire_deck,
    celestaverse_deck,
    test,
}

for _, v in ipairs(deck_table) do
    if Sagatro.debug then
        v.unlocked = true
    end
    if not v.debug_obj or (v.debug_obj and Sagatro.debug) then
        v.debug_obj = nil
        SMODS.Back(v)
    end
end

if CardSleeves then
    local saga_sleeve = {
		key = "saga",
		name = "Saga Sleeve",
        -- artist_credits = {"amy"},
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
                if Sagatro.config.DisableOtherJokers then
                    local result = pseudorandom("saga_sleeve_mc_aura")
                    if Sagatro.debug then
                        print(result)
                    end
                    G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd =
                    G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd or 0.997
                    if result > (G.GAME.seeded and 0.997 or G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd) then
                        if Sagatro.debug then
                            print(G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd)
                        end
                        delay(0.4)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, "c_soul", 'deck')
                                -- card:add_sticker("sgt_easter_egg", true)
                                card:set_edition("e_negative", true)
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                if result > 0.997 then
                                    juice_card_until(card, function(_card) return not _card.states.hover.is end, true)
                                end
                                if not G.GAME.seeded then
                                    G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd = 0.997
                                end
                            return true
                            end
                        }))
                    else
                        if Sagatro.debug then
                            print(G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd)
                        end
                        if not G.GAME.seeded then
                            G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd =
                            G.PROFILES[G.SETTINGS.profile].story_mode_mc_aura_odd
                            - pseudorandom("saga_sleeve_mc_aura_dec", 10, 50)*0.001
                        end
                    end
                    G:save_settings()
                end
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
        -- artist_credits = {"amy"},
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

    local celestaverse_sleeve = {
        key = "celestaverse",
		name = "Celestaverse Sleeve",
        -- artist_credits = {"amy"},
		atlas = 'sleeves',
		pos = { x = 2, y = 0 },
		unlocked = false,
		unlock_condition = { deck = "b_sgt_grimoire", stake = "stake_blue" },
        apply = function(self, sleeve)
            CardSleeves.Sleeve.apply(sleeve)
            if self.get_current_deck_key() == "b_sgt_celestaverse" then
                G.GAME.starting_params.ante_scaling = self.config.conditional_ante_scaling
                -- This is called too early, way before Civilization is applied
                -- so I'm pulling it straight from voucher's prototype table
                G.GAME.celestara_rate = G.P_CENTERS.v_sgt_civilization.config.extra.rate * self.config.times_rate
            end
		end,
        loc_vars = function(self)
            local key, vars = self.key, nil
			if self.get_current_deck_key() == "b_sgt_celestaverse" then
				key = key .. "_alt"
                self.config = {times_rate = 3, conditional_ante_scaling = 1.5, consumables = {"c_sgt_sacra_sapientia"}}
                vars = {localize{type = 'name_text', key = self.config.consumables[1], set = 'Divinatio'},
                self.config.times_rate, self.config.conditional_ante_scaling}
			else
				key = self.key
                self.config = {vouchers = {'v_sgt_alien_life', 'v_sgt_civilization'}, consumable_slot = 1}
                vars = {localize{type = 'name_text', key = self.config.vouchers[1], set = 'Voucher'},
                localize{type = 'name_text', key = self.config.vouchers[2], set = 'Voucher'},
                self.config.consumable_slot}
			end
			return { key = key, vars = vars }
		end,
    }

    local sleeve_table = {
        saga_sleeve,
        grimoire_sleeve,
        celestaverse_sleeve,
    }

    for _, v in ipairs(sleeve_table) do
        if Sagatro.debug then
            v.unlocked = true
        end
        CardSleeves.Sleeve(v)
    end
end