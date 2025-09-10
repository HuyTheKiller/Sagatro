local fertility = {
    key = "fertility",
    name = "Fertility",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 1, y = 0},
    config = {universal = 1},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
		local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_fertility = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.universal
            ease_hands_played(card.ability.universal)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.universal
            ease_discard(card.ability.universal)
            G.hand:change_size(card.ability.universal)
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.universal
            if G.jokers then
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.universal
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.universal or self.config.universal}}
	end,
}

local prosperity = {
    key = "prosperity",
    name = "Prosperity",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 0, y = 0},
    config = {money = 500},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
		local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            ease_dollars(card.ability.money)
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_prosperity = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.money or self.config.money}}
	end,
}

local love = {
    key = "love",
    name = "Love",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 2, y = 0},
    config = {retriggers = 2},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_love = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_lamp_genie"]
        end
		return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_lamp_genie", nodes = {}},
            card and card.ability.retriggers or self.config.retriggers}}
	end,
}

local peace = {
    key = "peace",
    name = "Peace",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 3, y = 0},
    config = {},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_peace = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_lamp_genie"]
        end
		return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_lamp_genie", nodes = {}}}}
	end,
}

local ease = {
    key = "ease",
    name = "Ease",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 4, y = 0},
    config = {chips = 1000, xmult = 10},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_aladdin", true)) then
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_aladdin",
                }))
            end
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_aladdin", true)) do
                v.ability.buffed = true
                v.ability.extra.chips = card.ability.chips
                v.ability.extra.xmult = card.ability.xmult
                v:juice_up(0.5, 0.5)
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_ease = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_aladdin"]
        end
		return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_aladdin", nodes = {}},
        card and card.ability.chips or self.config.chips,
        card and card.ability.xmult or self.config.xmult}}
	end,
}

local asetheticism = {
    key = "aestheticism",
    name = "Aestheticism",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 5, y = 0},
    config = {},
    cost = 16,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_wish_granted_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_aestheticism = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        if G.hand.cards[1] then
            for i=1, #G.hand.cards do
                local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
        end
        G.E_MANAGER:add_event(Event({func = function()
            for c = #G.playing_cards, 1, -1 do
                if not G.playing_cards[c].edition then
                    G.playing_cards[c]:set_edition(poll_edition("aesthetic_edition", nil, nil, true), nil, true)
                end
            end
        return true end }))
        if G.hand.cards[1] then
            for i=1, #G.hand.cards do
                local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
            end
        end
        delay(0.6)
    end,
}

local freedom = {
    key = "freedom",
    name = "Freedom",
    set = "Wish",
    atlas = "wish",
    dependencies = {"Talisman"},
    discovered = true,
    pos = {x = 6, y = 0},
    config = {emult = 3},
    cost = 16,
    no_collection = true,
    hidden = true,
    soul_rate = 0,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            attention_text({
                text = localize('k_released_ex'),
                scale = 0.9,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SGT_WISH,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
            card:juice_up(0.3, 0.5)
            if not next(SMODS.find_card("j_sgt_lamp_genie", true)) then
                G.GAME.wish_card_spawns_genie = true
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_sgt_lamp_genie",
                }))
                G.GAME.wish_card_spawns_genie = nil
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lamp_genie", true)) do
                v.ability.wishlist.c_sgt_freedom = true
                v.ability.collected_wish = v.ability.collected_wish + 1
                v:juice_up(0.5, 0.5)
            end
            return true end }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_lamp_genie"]
        end
		return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_lamp_genie", nodes = {}},
            card and card.ability.emult or self.config.emult}}
	end,
}

local wish = {
    key = "Wish",
    dependencies = {"Talisman"},
    primary_colour = HEX("1350c7"),
	secondary_colour = G.C.SGT_WISH,
	collection_rows = { 3, 3 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_prosperity",
}

local consumabletype_table = {
    wish,
}

for _, v in ipairs(consumabletype_table) do
    SMODS.ConsumableType(v)
end


local wish_table = {
    prosperity,
    fertility,
    love,
    peace,
    ease,
    asetheticism,
    freedom,
}

for _, v in ipairs(wish_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
        v.no_collection = nil
    end
    SMODS.Consumable(v)
end