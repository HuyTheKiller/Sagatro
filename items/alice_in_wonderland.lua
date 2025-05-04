local white_rabbit = {
    key = "white_rabbit",
    name = "White Rabbit",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 0 },
    config = {extra = {chips = 0, chip_gain = 6}},
	rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips*(G.GAME and G.GAME.alice_multiplier or 1),
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*(G.GAME and G.GAME.alice_multiplier or 1)}}
			}
		end
        if context.before and G.GAME.current_round.discards_used == 0 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize("k_in_a_hurry_ex"),
				colour = G.C.CHIPS,
				card = card
			}
		end
        if context.discard and not context.blueprint and context.other_card == context.full_hand[1] and not context.hook then
            if G.GAME.current_round.discards_used <= 0 then
                return {
                    message = localize("k_too_late_ex"),
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.extra.chip_gain*(G.GAME and G.GAME.alice_multiplier or 1)}}
	end,
}

local drink_me = {
    key = "drink_me",
    name = "Drink Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 0 },
    config = {extra = 1, taken = false},
	rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint and not context.retrigger_joker
        and G.jokers.cards[#G.jokers.cards].ability.name ~= "Eat Me!" then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if SMODS.has_no_rank(v) or v:get_id() > 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.base.id = SMODS.has_no_rank(v) and v.base.id or 2
                                if not SMODS.has_no_rank(v) then v:juice_up() end
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = localize("k_shrunk_ex"),
                    colour = G.C.BLUE
                }
            end
            if context.after then
                if card.ability.extra - 1 <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end}))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return next(SMODS.find_card("j_sgt_white_rabbit", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_eat_me"] and not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_eat_me"]
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
    end,
}

local eat_me = {
    key = "eat_me",
    name = "Eat Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 2, y = 0 },
    config = {extra = 1},
	rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[#G.jokers.cards] == card and not context.blueprint and not context.retrigger_joker
        and (G.jokers.cards[1].ability.name ~= "Drink Me!" and G.jokers.cards[1].ability.name ~= "Unlabeled Bottle") then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if SMODS.has_no_rank(v) or (not next(SMODS.find_card("j_sgt_little_bill", true)) and v:get_id() < 14)
                    or (next(SMODS.find_card("j_sgt_little_bill", true)) and v:get_id() > 2) then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.base.id = (SMODS.has_no_rank(v) and v.base.id)
                                or (not next(SMODS.find_card("j_sgt_little_bill", true)) and 14)
                                or (next(SMODS.find_card("j_sgt_little_bill", true)) and 2)
                                if not SMODS.has_no_rank(v) then v:juice_up() end
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = not next(SMODS.find_card("j_sgt_little_bill", true)) and localize("k_enlarged_ex") or localize("k_shrunk_ex"),
                    colour = G.C.BLUE
                }
            end
            if context.after then
                if card.ability.extra - 1 <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end}))
                            return true
                        end
                    }))
                    if G.GAME.saga_event.alice_in_wonderland.little_bill
                    and not G.GAME.saga_event_check.alice_in_wonderland.huge_dog then
                        G.GAME.saga_event_check.alice_in_wonderland.little_bill = true
                        G.GAME.saga_event.alice_in_wonderland.little_bill = false
                        G.GAME.saga_event.alice_in_wonderland.huge_dog = true
                    end
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return next(SMODS.find_card("j_sgt_white_rabbit", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_drink_me"] and not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_drink_me"]
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), localize{type = 'name_text', set = "Joker", key = "j_sgt_drink_me", nodes = {}}}}
    end,
}

local mouse = {
    key = "mouse",
    name = "Mouse",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 0 },
    config = {extra = {mult = 20, debuff_position = {}}},
	rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult*(G.GAME and G.GAME.alice_multiplier or 1),
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*(G.GAME and G.GAME.alice_multiplier or 1)}}
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            for i, v in ipairs(G.jokers.cards) do
                if v == card then
                    if not table.contains(card.ability.extra.debuff_position, i) then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                table.insert(card.ability.extra.debuff_position, i)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return next(SMODS.find_card("j_sgt_kid_gloves_and_fan", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local kid_gloves_and_fan = {
    key = "kid_gloves_and_fan",
    name = "Kid-gloves And The Fan",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 0 },
    config = {extra = 1},
	rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint then
            if context.individual and context.cardarea == G.play then
                if not context.other_card.debuff then
                    local temp = context.other_card
                    if SMODS.has_no_rank(temp) or temp:get_id() > 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                temp.base.id = SMODS.has_no_rank(temp) and temp.base.id or math.max(2, temp.base.id - card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1))
                                local rank_suffix = sgt_get_rank_suffix(temp)
                                assert(SMODS.change_base(temp, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                end
            end
            if context.destroy_card and context.cardarea == G.play then
                if not context.destroying_card.debuff then
                    local temp = context.destroying_card
                    if not SMODS.has_no_rank(temp) and temp:get_id() <= 2 then
                        return {
                            message = localize("k_poof_ex"),
                            colour = G.C.YELLOW,
                            remove = true
                        }
                    end
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local dodo_bird = {
    key = "dodo_bird",
    name = "Dodo Bird",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 1 },
    config = {extra = 1.5},
	rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.other_joker then
            if G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)}},
                    Xmult_mod = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood = true
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local unlabeled_bottle = {
    key = "unlabeled_bottle",
    name = "Unlabeled Bottle",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 1 },
    config = {extra = 2, taken = false},
	rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint and not context.retrigger_joker then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if SMODS.has_no_rank(v) or v:get_id() < 14 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.base.id = SMODS.has_no_rank(v) and v.base.id or 14
                                if not SMODS.has_no_rank(v) then v:juice_up() end
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = localize("k_enlarged_ex"),
                    colour = G.C.YELLOW
                }
            end
            if context.after then
                for _, v in ipairs(SMODS.find_card("j_sgt_white_rabbit", true)) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('sgt_run_away', 1, 1)
                            G.E_MANAGER:add_event(Event({
                                trigger = "immediate",
                                blockable = false,
                                func = function()
                                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_yeet_ex'), instant = true})
                                    return true
                                end
                            }))
                            v.T.r = -0.2
                            v:juice_up(0.3, 0.4)
                            v.states.drag.is = true
                            v.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                        G.jokers:remove_card(v)
                                        v:remove()
                                        v = nil
                                    return true; end}))
                            return true
                        end
                    }))
                end
                if card.ability.extra - 1 <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end}))
                            return true
                        end
                    }))
                    if not G.GAME.saga_event_check.alice_in_wonderland.little_bill then
                        G.GAME.saga_event.alice_in_wonderland.little_bill = true
                    end
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.taken = true
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house = true
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        if card.ability.taken then
            return {
                key = "j_sgt_unlabeled_bottle",
                vars = {card.ability.extra}
            }
        else return {
            key = "j_sgt_unlabeled_bottle_collection"
        }
        end
    end,
}

local little_bill = {
    key = "little_bill",
    name = "Little Bill",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 2, y = 1 },
    config = {},
	rarity = 1,
    cost = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return G.GAME.saga_event.alice_in_wonderland.little_bill and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_eat_me"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_eat_me"]
        end
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
    end,
}

local huge_dog = {
    key = "huge_dog",
    name = "Huge Puppy",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 3, y = 1 },
    config = {extra = {times = 1, extra_times = 1}},
	rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local valid_cards, all_cards = 0, 0
            local temp = context.other_card
            for _, v in ipairs(context.full_hand) do
                all_cards = all_cards + 1
                if v:get_id() == 14 or v:get_id() == 2 then
                    valid_cards = valid_cards + 1
                end
            end
            if temp:get_id() == 14 or temp:get_id() == 2 then
                return {
                    message = localize("k_again_ex"),
                    repetitions = (card.ability.extra.times + (valid_cards == all_cards and card.ability.extra.extra_times or 0))*(G.GAME and G.GAME.alice_multiplier or 1),
                    card = card,
                }
            end
        end
        if context.selling_self and not context.blueprint and not context.retrigger_joker
        and not G.GAME.saga_event_check.alice_in_wonderland.caterpillar then
            G.GAME.saga_event.alice_in_wonderland.caterpillar = true
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.saga_event.alice_in_wonderland.huge_dog = false
        G.GAME.saga_event_check.alice_in_wonderland.huge_dog = true
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return G.GAME.saga_event.alice_in_wonderland.huge_dog and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.times*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.extra.extra_times*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local caterpillar = {
    key = "caterpillar",
    name = "Caterpillar",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 1 },
    config = {extra = 20, taken = false},
	rarity = 1,
    cost = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint
        and not context.retrigger_joker and card.ability.extra > 0 then
            if not context.other_card.debuff then
                local suits = {}
                local temp = context.other_card
                for _, v in pairs(SMODS.Suits) do
                    suits[#suits+1] = tostring(v.key)
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        temp.base.id = SMODS.has_no_rank(temp) and temp.base.id or pseudorandom("caterpillar_random_rank", 2, 14)
                        local rank_suffix = sgt_get_rank_suffix(temp)
                        assert(SMODS.change_base(temp, pseudorandom_element(suits, pseudoseed("caterpillar_random_suit")), rank_suffix))
                        return true
                    end
                }))
                card.ability.extra = card.ability.extra - 1
            end
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra <= 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        assert(SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_mushroom",
                        }))
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end}))
                        return true
                    end
                }))
                if G.GAME.saga_event.alice_in_wonderland.caterpillar then
                    G.GAME.saga_event.alice_in_wonderland.caterpillar = false
                    G.GAME.saga_event_check.alice_in_wonderland.caterpillar = true
                end
                return {
                    message = localize('k_go_off_ex'),
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return G.GAME.saga_event.alice_in_wonderland.caterpillar and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_mushroom"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_mushroom"]
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), localize{type = 'name_text', set = "Joker", key = "j_sgt_mushroom", nodes = {}}}}
    end,
}

local mushroom = {
    key = "mushroom",
    name = "Mushroom",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 1 },
    config = {extra = 10, times = 1, taken = false},
	rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1] and not context.blueprint then
            if G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].ability.name ~= "Eat Me!" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, card.ability.times*(G.GAME and G.GAME.alice_multiplier or 1) do
                                    v.base.id = SMODS.has_no_rank(v) and v.base.id or v.base.id == 2 and 14 or math.max(v.base.id-1, 2)
                                end
                                if not SMODS.has_no_rank(v) then v:juice_up() end
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                    return {
                        message = localize("k_shrunk_ex"),
                        colour = G.C.BLUE
                    }
                end
                if context.after and not context.retrigger_joker then
                    if card.ability.extra - 1 <= 0 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(card)
                                            card:remove()
                                            card = nil
                                        return true; end}))
                                return true
                            end
                        }))
                        if not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper then
                            G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = true
                        end
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER
                        }
                    else
                        card.ability.extra = card.ability.extra - 1
                        return {
                            message = card.ability.extra..'',
                            colour = G.C.FILTER
                        }
                    end
                end
            elseif G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].ability.name ~= "Drink Me!" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, card.ability.times*(G.GAME and G.GAME.alice_multiplier or 1) do
                                    v.base.id = SMODS.has_no_rank(v) and v.base.id or v.base.id == 14 and 2 or math.min(v.base.id+1, 14)
                                end
                                if not SMODS.has_no_rank(v) then v:juice_up() end
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                    return {
                        message = localize("k_enlarged_ex"),
                        colour = G.C.BLUE
                    }
                end
                if context.after and not context.retrigger_joker then
                    if card.ability.extra - 1 <= 0 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(card)
                                            card:remove()
                                            card = nil
                                        return true; end}))
                                return true
                            end
                        }))
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER
                        }
                    else
                        card.ability.extra = card.ability.extra - 1
                        return {
                            message = card.ability.extra..'',
                            colour = G.C.FILTER
                        }
                    end
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.times*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local pigeon = {
    key = "pigeon",
    name = "Pigeon",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 2 },
    config = {extra = 3, egg_boost = 1, triggered = false, extra_value = -3},
	rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            for _, v in ipairs(G.jokers.cards) do
                if v.ability.name == "Egg" then
                    card.ability.triggered = true
                    v.ability.extra_value = v.ability.extra_value + card.ability.egg_boost*(G.GAME and G.GAME.alice_multiplier or 1)
                    v:set_cost()
                end
            end
            if card.ability.triggered then
                card.ability.triggered = false
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY,
                }
            end
        end
        if context.selling_card and not context.blueprint and not context.retrigger_joker then
            if context.card.ability.name == "Egg" then
                card:set_debuff(true)
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        for _ = 1, card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1) do
            G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                assert(SMODS.add_card({
                    set = "Joker",
                    skip_materialize = true,
                    key = "j_egg",
                }))
                return true
            end)}))
        end
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return next(SMODS.find_card("j_sgt_mushroom", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_egg
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_egg", nodes = {}}, card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.egg_boost*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local frog_footman = {
    key = "frog_footman",
    name = "Frog-Footman",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 2 },
    config = {extra = 2, consumable_slot = 1, alice_mult_buffer = 1, taken = false},
	rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint and not context.retrigger_joker
        and #G.consumeables.cards < G.consumeables.config.card_limit then
            local times = G.consumeables.config.card_limit - #G.consumeables.cards
            for _ = 1, times do
                G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local forced_key = sgt_get_random_consumable('frog_footman', nil, nil)
                        local _card = create_card('Consumeables',G.consumeables, nil, nil, nil, nil, forced_key.config.center_key, 'frog_footman')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                    return true
                end)}))
            end
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_ouch_ex'), colour = G.C.SGT_OBSCURE})
            card.ability.extra = card.ability.extra - 1
            if card.ability.extra <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end}))
                        return true
                    end
                }))
                if not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog then
                    G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = false
                    G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper = true
                    G.GAME.saga_event.alice_in_wonderland.goodbye_frog = true
                end
                return {
                    message = localize('k_goodbye_ex'),
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.consumable_slot*(G.GAME and G.GAME.alice_multiplier or 1)
        -- return true end }))
        if G.GAME and G.GAME.alice_multiplier then
            card.ability.alice_mult_buffer = G.GAME.alice_multiplier
        end
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.consumable_slot*(G.GAME and G.GAME.alice_multiplier or 1)
        -- return true end }))
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return G.GAME.saga_event.alice_in_wonderland.pig_and_pepper and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.consumable_slot*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local the_cook = {
    key = "the_cook",
    name = "The Cook",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 2, y = 2 },
    config = {extra = {odds = 4, xmult = 2, card_list = {}}, value_shift_init = {{3, 1.8}, {4, 2}, {5, 2.2}, {6, 2.4}}},
	rarity = 3,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.sgt_stay_flipped and not context.blueprint and not context.retrigger_joker then
            card:juice_up(0.7)
        end
        if context.sgt_play_cards and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.card_list = {}
            for i = 1, #G.hand.highlighted do
                if G.hand.highlighted[i].facing == 'back' then
                    table.insert(card.ability.extra.card_list, G.hand.highlighted[i])
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            local condition = false
            for i = 1, #card.ability.extra.card_list do
                local flipped_card = card.ability.extra.card_list[i]
                if context.other_card == flipped_card then
                    condition = true
                    break
                end
            end
            if condition then return {
                x_mult = card.ability.extra.xmult*(G.GAME and G.GAME.alice_multiplier or 1),
                colour = G.C.RED,
                card = card
            }
            end
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint and not context.retrigger_joker then
            -- My attempt to make The Cook unique from a Bunco's joker called Vandalism
            local value_shift_list = {}
            for _, v in ipairs(card.ability.value_shift_init) do
                if card.ability.extra.odds ~= v[1] then
                    value_shift_list[#value_shift_list+1] = v
                end
            end
            local chosen_pair = pseudorandom_element(value_shift_list, pseudoseed("the_cook_shift"))
            card.ability.extra.odds = chosen_pair[1]
            card.ability.extra.xmult = chosen_pair[2]
            return {
                message = localize("k_stirred_ex")
            }
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.xmult*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local cheshire_cat = {
    key = "cheshire_cat",
    name = "Cheshire Cat",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 3, y = 0 },
    config = {extra = {copied_joker = nil, copied_joker_value_id = 0, copied_joker_buffer_name = nil, odds = 3}},
	rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.retrigger_joker then
            card.ability.extra.copied_joker = nil
            local potential_jokers = {}
            for i=1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.key ~= "j_sgt_cheshire_cat" and G.jokers.cards[i].config.center.blueprint_compat then
                    potential_jokers[#potential_jokers+1] = G.jokers.cards[i]
                end
            end
            if #potential_jokers > 0 then
                local chosen_joker = pseudorandom_element(potential_jokers, pseudoseed('cheshire_cat'))
                for _, v in ipairs(G.jokers.cards) do
                    if v == chosen_joker then
                        -- Store buffer name
                        card.ability.extra.copied_joker_buffer_name = v.ability.name
                        -- Store value ID if applicable
                        if v.ability.extra then
                            card.ability.extra.copied_joker_value_id = table.extract_total_value(v.ability.extra)
                        end
                        break
                    end
                end
                card.ability.extra.copied_joker = chosen_joker
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex')})
            end
        end
        if card.ability.extra.copied_joker then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card
            if context.blueprint > #G.jokers.cards + 1 then return end
            local other_joker_ret = card.ability.extra.copied_joker:calculate_joker(context)
            context.blueprint = nil
            context.blueprint_card = nil
            -- Recalculate value ID if applicable
            for _, v in ipairs(G.jokers.cards) do
                if v == card.ability.extra.copied_joker and v.ability.extra then
                    card.ability.extra.copied_joker_value_id = table.extract_total_value(v.ability.extra)
                    break
                end
            end
            if other_joker_ret then
                other_joker_ret.card = card
                other_joker_ret.colour = G.C.GREY
                return other_joker_ret
            end
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint and not context.retrigger_joker then
            if pseudorandom('cheshire_cat_vanish') < G.GAME.probabilities.normal/(card.ability.extra.odds*(G.GAME and G.GAME.alice_multiplier or 1)) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize("k_gone_ex")
				}
			else
				return {
					message = localize("k_grin_ex")
				}
			end
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.copied_joker then
            if G.P_CENTERS[card.ability.extra.copied_joker.config.center_key] then
                info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.copied_joker.config.center_key]
            end
            return {vars = {localize{type = 'name_text', set = "Joker", key = card.ability.extra.copied_joker.config.center_key, nodes = {}}, G.GAME.probabilities.normal, card.ability.extra.odds*(G.GAME and G.GAME.alice_multiplier or 1), Sagatro.debug and card.ability.extra.copied_joker_value_id}}
        else
            return {vars = {localize('k_none'), G.GAME.probabilities.normal, card.ability.extra.odds*(G.GAME and G.GAME.alice_multiplier or 1), Sagatro.debug and card.ability.extra.copied_joker_value_id}}
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            if card.ability.extra.copied_joker_buffer_name then
                local filtered_list = {}
                -- Scan for jokers matching buffer name
                for _, v in ipairs(G.jokers.cards) do
                    if card.ability.extra.copied_joker_buffer_name == v.ability.name then
                        filtered_list[#filtered_list+1] = v
                    end
                end
                -- If there is more than one, check value ID to pin-point the exact scaling joker
                if #filtered_list > 1 then
                    for _, v in ipairs(filtered_list) do
                        if v.ability.extra then
                            --[[This complicated check would simply fall apart if
                            a modded scaling joker didn't put its variables in config.extra,
                            but who cares anyway, it's the modder's fault]]
                            if card.ability.extra.copied_joker_value_id == table.extract_total_value(v.ability.extra) then
                                card.ability.extra.copied_joker = v
                                break
                            end
                        else
                            card.ability.extra.copied_joker = filtered_list[1]
                            break
                        end
                    end
                -- If there is only one, simply select it
                elseif #filtered_list == 1 then
                    card.ability.extra.copied_joker = filtered_list[1]
                else
                    card.ability.extra.copied_joker = card
                    --[[Select itself as a fallback if copied joker is sold (does not affect buffer name)
                    This would be entirely your fault for doing such abomination in a live run]]
                end
            end
            card.loaded = false
        end
    end
}

local duchess = {
    key = "duchess",
    name = "Duchess",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 3, y = 2 },
    config = {triggered = false, extra = {e_mult = 1.1, odds = 3, probability_list = {}}},
	rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.probability_list = {}
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    card.ability.extra.probability_list[#card.ability.extra.probability_list+1]
                    = pseudorandom("duchess_execute") < G.GAME.probabilities.normal/card.ability.extra.odds
                else
                    card.ability.extra.probability_list[#card.ability.extra.probability_list+1] = false
                end
            end
            for _, v in ipairs(card.ability.extra.probability_list) do
                if v then card.ability.triggered = true break end
            end
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i] == context.destroying_card and card.ability.extra.probability_list[i] then
                    return {
                        message = localize("k_die_ex"),
                        colour = G.C.RED,
                        remove = true
                    }
                end
            end
        end
        if context.joker_main and card.ability.triggered then
            card.ability.triggered = false
            return {
                e_mult = card.ability.extra.e_mult*(G.GAME and G.GAME.alice_multiplier or 1)
            }
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.e_mult*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local the_baby = {
    key = "the_baby",
    name = "The Baby",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pools = { [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 4, y = 2 },
    config = {extra = 3},
	rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.current_round.hands_left == 0 then
            if context.repetition and context.cardarea == G.play then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1),
                    card = card,
                }
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
                if not next(SMODS.find_card("j_sgt_duchess", true)) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('sgt_run_away', 1, 1)
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end}))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_yeet_ex'),
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_duchess"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_duchess"]
        end
        return {vars = {card.ability.extra*(G.GAME and G.GAME.alice_multiplier or 1), localize{type = 'name_text', set = "Joker", key = "j_sgt_duchess", nodes = {}}}}
    end,
}

local pepper_caster = {
    key = "pepper_caster",
    name = "Pepper-caster",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pos = { x = 5, y = 2 },
    config = {extra = {retriggers = 1, uses = 10}, taken = false},
	rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.retriggers*(G.GAME and G.GAME.alice_multiplier or 1),
                card = card,
            }
		end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.uses - 1 <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end}))
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.uses = card.ability.extra.uses - 1
                return {
                    message = card.ability.extra.uses..'',
                    colour = G.C.FILTER
                }
            end
        end
	end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra.uses = card.ability.extra.uses*(G.GAME and G.GAME.alice_multiplier or 1)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if Sagatro.config.DisableOtherJokers then
            return next(SMODS.find_card("j_sgt_the_cook", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers*(G.GAME and G.GAME.alice_multiplier or 1), card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*(G.GAME and G.GAME.alice_multiplier or 1)}}
    end,
}

local alice = {
    key = "alice",
    name = "Alice",
    atlas = "alice",
    saga_group = "alice_in_wonderland",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    config = {extra = 3},
	rarity = 4,
    cost = 20,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.alice_multiplier = G.GAME.alice_multiplier*card.ability.extra
        for _, v in ipairs(G.jokers.cards) do
            if v.ability.name == "Frog-Footman" then
                -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + (G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                -- return true end })) -- For some ducking reason events don't work here
                v.ability.alice_mult_buffer = G.GAME.alice_multiplier
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.alice_multiplier = G.GAME.alice_multiplier/card.ability.extra
        for _, v in ipairs(G.jokers.cards) do
            if v.ability.name == "Frog-Footman" then
                -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + (G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                -- return true end }))
                v.ability.alice_mult_buffer = G.GAME.alice_multiplier
            end
        end
    end,
    in_pool = function(self, args)
        return not Sagatro.config.DisableOtherJokers
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
}

local joker_table = {
    white_rabbit,
    drink_me,
    eat_me,
    mouse,
    kid_gloves_and_fan,
    dodo_bird,
    unlabeled_bottle,
    little_bill,
    huge_dog,
    caterpillar,
    mushroom,
    pigeon,
    frog_footman,
    the_cook,
    pepper_caster,
    cheshire_cat,
    duchess,
    the_baby,
    alice,
}

for _, v in ipairs(joker_table) do
    SMODS.Joker(v)
    if v.pools and type(v.pools) == "table" then
        for pool, add in pairs(v.pools) do
            if not G.P_CENTER_POOLS[pool] then G.P_CENTER_POOLS[pool] = {} end
            if add then
                SMODS.insert_pool(G.P_CENTER_POOLS[pool], v)
            end
        end
    end
end