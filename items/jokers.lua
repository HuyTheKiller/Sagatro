-- Alice in Wonderland
local white_rabbit = {
    key = "white_rabbit",
    name = "White Rabbit",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 1,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 0 },
    config = {extra = {chips = 0, chip_gain = 6}},
	rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if context.before and G.GAME.current_round.discards_used == 0 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize("k_in_a_hurry_ex"),
				colour = G.C.FILTER,
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
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            if next(SMODS.find_card("j_sgt_dodo_bird", true))
            and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house then
                G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = true
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.saga_event.alice_in_wonderland.white_rabbit_house then
            G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and not G.GAME.saga_event.alice_in_wonderland.cry_into_flood
        and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "white_rabbit"}
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "fusion_hint", title = localize("saga_fusion_tooltip")}
        end
		return {vars = {card.ability.extra.chips*G.GAME.alice_multiplier, card.ability.extra.chip_gain*G.GAME.alice_multiplier}}
	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            calc_function = function(card)
                card.joker_display_values.chips = card.ability.extra.chips*G.GAME.alice_multiplier
            end,
        }
    end,
}

local drink_me = {
    key = "drink_me",
    name = "Drink Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 2,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
        and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me" then
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
            if context.after and not context.blueprint and not context.retrigger_joker then
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
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_white_rabbit", true)) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_eat_me"] and not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_eat_me"]
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = (G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me")
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local eat_me = {
    key = "eat_me",
    name = "Eat Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 3,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
        and (G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me" and G.jokers.cards[1].config.center_key ~= "j_sgt_unlabeled_bottle") then
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
            if context.after and not context.blueprint and not context.retrigger_joker then
                if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_sgt_red_queen" then
                    G.E_MANAGER:add_event(Event({func = function()
                        local do_not_cut_score = true
                        G.GAME.blind:disable(do_not_cut_score)
                    return true end }))
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
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return (next(SMODS.find_card("j_sgt_white_rabbit", true)) or next(SMODS.find_card("j_sgt_little_bill", true))) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_drink_me"] and not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_drink_me"]
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_drink_me", nodes = {}}}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = (G.jokers.cards[#G.jokers.cards] == card
                and G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me"
                and G.jokers.cards[1].config.center_key ~= "j_sgt_unlabeled_bottle")
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local mouse = {
    key = "mouse",
    name = "Mouse",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 4,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
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
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_kid_gloves_and_fan", true)) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.cry_into_flood
        and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "fusion_hint", title = localize("saga_fusion_tooltip")}
        end
        return {vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "debuff_position" },
                { text = ")" },
            },
            calc_function = function(card)
                local positions = card.ability.extra.debuff_position
                if #positions == 0 then positions = nil
                else table.sort(positions, function(a, b) return a < b end) end

                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
                card.joker_display_values.debuff_position = positions and table.concat(positions, ", ") or ""
            end
        }
    end,
}

local kid_gloves_and_fan = {
    key = "kid_gloves_and_fan",
    name = "Kid-gloves And The Fan",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 5,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
                                temp.base.id = SMODS.has_no_rank(temp) and temp.base.id or math.max(2, temp.base.id - card.ability.extra*G.GAME.alice_multiplier)
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
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood then
            G.GAME.saga_event.alice_in_wonderland.cry_into_flood = true
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.cry_into_flood
        and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "kid_gloves_and_fan"}
        end
        return {vars = {card.ability.extra*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "ranks_per_decrease" },
                { text = " "..localize("k_rank") },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = G.jokers.cards[1] == card
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.ranks_per_decrease = card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local dodo_bird = {
    key = "dodo_bird",
    name = "Dodo Bird",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 6,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra*G.GAME.alice_multiplier}},
                    Xmult_mod = card.ability.extra*G.GAME.alice_multiplier
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.saga_event.alice_in_wonderland.cry_into_flood then
            G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood = true
            G.GAME.saga_event.alice_in_wonderland.cry_into_flood = false
            if next(SMODS.find_card("j_sgt_white_rabbit", true))
            and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house then
                G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = true
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.saga_event.alice_in_wonderland.white_rabbit_house then
            G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = false
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood
        and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "dodo_bird"}
        end
        return {vars = {card.ability.extra*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            mod_function = function(card, mod_joker)
                card.joker_display_values.active = G.GAME
                and G.GAME.current_round.hands_left <= 1
                and G.GAME.current_round.discards_left == 0
                and localize("jdis_active") or localize("jdis_inactive")
                return { x_mult = (G.GAME.current_round.hands_left <= 1 and G.GAME.current_round.discards_left == 0 and (mod_joker.ability.extra*G.GAME.alice_multiplier) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
            end
        }
    end,
}

local unlabeled_bottle = {
    key = "unlabeled_bottle",
    name = "Unlabeled Bottle",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 7,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
                    colour = G.C.FILTER
                }
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
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
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = false
        G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house = true
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house
        and not G.GAME.saga_event.alice_in_wonderland.little_bill
        and not G.GAME.saga_event.alice_in_wonderland.final_showdown)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "unlabeled_bottle"}
        end
        if card.ability.taken or Sagatro.debug then
            return {
                key = "j_sgt_unlabeled_bottle",
                vars = {card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier}
            }
        else return {
            key = "j_sgt_unlabeled_bottle_collection"
        }
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = G.jokers.cards[1] == card
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local little_bill = {
    key = "little_bill",
    name = "Little Bill",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 8,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 2, y = 1 },
    config = {},
	rarity = 1,
    cost = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.little_bill and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_eat_me"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_eat_me"]
        end
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.little_bill
        and not G.GAME.saga_event_check.alice_in_wonderland.little_bill)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "little_bill"}
        end
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}
            end,
        }
    end,
}

local huge_dog = {
    key = "huge_dog",
    name = "Huge Puppy",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 9,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
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
            for _, v in ipairs(context.scoring_hand) do
                all_cards = all_cards + 1
                if v:get_id() == 14 or v:get_id() == 2 then
                    valid_cards = valid_cards + 1
                end
            end
            if temp:get_id() == 14 or temp:get_id() == 2 then
                return {
                    message = localize("k_again_ex"),
                    repetitions = (card.ability.extra.times + (valid_cards == all_cards and card.ability.extra.extra_times or 0))*G.GAME.alice_multiplier,
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
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.huge_dog and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and (G.GAME.saga_event.alice_in_wonderland.huge_dog or G.GAME.saga_event_check.alice_in_wonderland.huge_dog)
        and not G.GAME.saga_event.alice_in_wonderland.caterpillar
        and not G.GAME.saga_event_check.alice_in_wonderland.caterpillar)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "huge_dog"}
        end
        return {vars = {card.ability.extra.times*G.GAME.alice_multiplier, card.ability.extra.extra_times*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers" },
            },
            reminder_text = {
                { text = "(2, " },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_ace" },
                { text = ")" },
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards) or next(G.hand.highlighted)
                local valid_cards, all_cards = 0, 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        all_cards = all_cards + 1
                        if scoring_card:get_id() == 2 or scoring_card:get_id() == 14 then
                            valid_cards = valid_cards + 1
                        end
                    end
                else
                    valid_cards = 1 -- Face down cards force retrigger count to be 1
                end
                local count = playing_hand and valid_cards == all_cards
                and (card.ability.extra.times+card.ability.extra.extra_times)*G.GAME.alice_multiplier
                or card.ability.extra.times*G.GAME.alice_multiplier

                card.joker_display_values.retriggers = count
                card.joker_display_values.localized_text_ace = localize("Ace", "ranks")
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                local valid_cards, all_cards = 0, 0
                for _, playing_card in ipairs(G.play.cards) do
                    all_cards = all_cards + 1
                    if playing_card:get_id() == 2 or playing_card:get_id() == 14 then
                        valid_cards = valid_cards + 1
                    end
                end
                local count = valid_cards == all_cards
                and (joker_card.ability.extra.times+joker_card.ability.extra.extra_times)*G.GAME.alice_multiplier
                or joker_card.ability.extra.times*G.GAME.alice_multiplier
                return (playing_card:get_id() == 2 or playing_card:get_id() == 14)
                and count * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end
}

local caterpillar = {
    key = "caterpillar",
    name = "Caterpillar",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 10,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 1 },
    config = {extra = 12, taken = false},
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
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.caterpillar and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_mushroom"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_mushroom"]
        end
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.caterpillar
        and not G.GAME.saga_event_check.alice_in_wonderland.caterpillar)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "caterpillar"}
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_mushroom", nodes = {}}}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local mushroom = {
    key = "mushroom",
    name = "Mushroom",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 11,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 1 },
    config = {extra = 10, times = 1, taken = false},
	rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1] and not context.blueprint then
            if G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, card.ability.times*G.GAME.alice_multiplier do
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
                if context.after and not context.blueprint and not context.retrigger_joker then
                    if G.GAME.saga_event.alice_in_wonderland.the_party then
                        G.GAME.saga_event.alice_in_wonderland.the_party = false
                        G.GAME.saga_event_check.alice_in_wonderland.the_party = true
                        G.GAME.saga_event.alice_in_wonderland.red_queen = true
                    end
                    if not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper then
                        print("mushroom used")
                        G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = true
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
            elseif G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, card.ability.times*G.GAME.alice_multiplier do
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
                if context.after and not context.blueprint and not context.retrigger_joker then
                    if G.GAME.saga_event.alice_in_wonderland.the_party then
                        G.GAME.saga_event.alice_in_wonderland.the_party = false
                        G.GAME.saga_event_check.alice_in_wonderland.the_party = true
                        G.GAME.saga_event.alice_in_wonderland.red_queen = true
                    end
                    if not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper then
                        G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = true
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
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event_check.alice_in_wonderland.caterpillar
        and not G.GAME.saga_event.alice_in_wonderland.pig_and_pepper
        and not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "mushroom"}
        end
        return {vars = {card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier, card.ability.times*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active =
                ((G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me")
                or (G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me"))
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local pigeon = {
    key = "pigeon",
    name = "Pigeon",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 12,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 2 },
    config = {extra = 3, egg_boost = 1, triggered = false, extra_value = -14},
	rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_egg" then
                    card.ability.triggered = true
                    v.ability.extra_value = v.ability.extra_value + card.ability.egg_boost*G.GAME.alice_multiplier
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
            if context.card.config.center_key == "j_egg" then
                card:set_debuff(true)
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        for _ = 1, card.ability.extra*G.GAME.alice_multiplier do
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
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_mushroom", true)) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_egg
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_egg", nodes = {}}, card.ability.extra*G.GAME.alice_multiplier, card.ability.egg_boost*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$", colour = G.C.GOLD },
                { ref_table = "card.joker_display_values", ref_value = "egg_boost", colour = G.C.GOLD },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.egg_boost = card.ability.egg_boost*G.GAME.alice_multiplier
                card.joker_display_values.localized_text = localize{type = 'name_text', set = "Joker", key = "j_egg", nodes = {}}
            end,
        }
    end,
}

local frog_footman = {
    key = "frog_footman",
    name = "Frog-Footman",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 13,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 2 },
    config = {extra = 2, consumable_slot = 1, alice_mult_buffer = 1, taken = false},
	rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint and not context.retrigger_joker
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local times = G.consumeables.config.card_limit - #G.consumeables.cards
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + times
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    for _ = 1, times do
                        local forced_key = sgt_get_random_consumable('frog_footman', nil, nil)
                        local _card = create_card('Consumeables',G.consumeables, nil, nil, nil, nil, forced_key.config.center_key, 'frog_footman')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
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
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.consumable_slot*G.GAME.alice_multiplier
        -- return true end }))
        if G.GAME and G.GAME.alice_multiplier then
            card.ability.alice_mult_buffer = G.GAME.alice_multiplier
        end
        if not from_debuff then
            card.ability.extra = card.ability.extra*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.consumable_slot*G.GAME.alice_multiplier
        -- return true end }))
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.pig_and_pepper and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.pig_and_pepper
        and not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "frog_footman"}
        end
        return {vars = {card.ability.consumable_slot*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra or card.ability.extra*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability", ref_value = "extra" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra*G.GAME.alice_multiplier
            end,
        }
    end,
}

local the_cook = {
    key = "the_cook",
    name = "The Cook",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 14,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
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
                x_mult = card.ability.extra.xmult*G.GAME.alice_multiplier,
                colour = G.C.RED,
                card = card
            }
            end
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint and not context.retrigger_joker then
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
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.goodbye_frog and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.xmult*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult" }
                    }
                },
                { ref_table = "card.joker_display_values", ref_value = "localized_text" }
            },
            calc_function = function(card)
                card.joker_display_values.xmult = card.ability.extra.xmult*G.GAME.alice_multiplier
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
                card.joker_display_values.localized_text = localize("ph_per_face_down")
            end,
        }
    end
}

local cheshire_cat = {
    key = "cheshire_cat",
    name = "Cheshire Cat",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 16,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 3, y = 0 },
    config = {extra = {copied_joker = nil, copied_joker_value_id = 0, copied_joker_buffer_key = nil, odds = 3}},
	rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.retrigger_joker then
            card.ability.extra.copied_joker = nil
            card.ability.extra.copied_joker_buffer_key = nil
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
                        -- Store buffer key
                        card.ability.extra.copied_joker_buffer_key = v.config.center_key
                        -- Store value ID if applicable
                        if v.ability.extra then
                            card.ability.extra.copied_joker_value_id = table.extract_total_value(v.ability.extra)
                        end
                        break
                    end
                end
                card.ability.extra.copied_joker = chosen_joker
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), instant = true})
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        chosen_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
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
            if pseudorandom('cheshire_cat_vanish') < G.GAME.probabilities.normal/(card.ability.extra.odds*G.GAME.alice_multiplier) then
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
                if G.GAME.saga_event.alice_in_wonderland.goodbye_frog then
                    G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog = true
                    G.GAME.saga_event.alice_in_wonderland.goodbye_frog = false
                    G.GAME.saga_event.alice_in_wonderland.the_party = true
                end
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
        if G.GAME.story_mode then
            return G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.copied_joker then
            if G.P_CENTERS[card.ability.extra.copied_joker.config.center_key] then
                info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.copied_joker.config.center_key]
            end
            if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
            and G.GAME.saga_event.alice_in_wonderland.goodbye_frog
            and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog)
            or Sagatro.debug then
                info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "cheshire_cat"}
            end
            return {vars = {localize{type = 'name_text', set = "Joker", key = card.ability.extra.copied_joker.config.center_key, nodes = {}}, G.GAME.probabilities.normal, card.ability.extra.odds*G.GAME.alice_multiplier, Sagatro.debug and card.ability.extra.copied_joker_value_id}}
        else
            if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
            and G.GAME.saga_event.alice_in_wonderland.goodbye_frog
            and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog)
            or Sagatro.debug then
                info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "cheshire_cat"}
            end
            return {vars = {localize('k_none'), G.GAME.probabilities.normal, card.ability.extra.odds*G.GAME.alice_multiplier, Sagatro.debug and card.ability.extra.copied_joker_value_id}}
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            if card.ability.extra.copied_joker_buffer_key then
                local filtered_list = {}
                -- Scan for jokers matching buffer key
                for _, v in ipairs(G.jokers.cards) do
                    if card.ability.extra.copied_joker_buffer_key == v.config.center_key then
                        filtered_list[#filtered_list+1] = v
                    end
                end
                --[[If there is more than one, check value ID to pin-point the exact joker
                (useful for detecting among duplicates of scaling jokers)]]
                if #filtered_list > 1 then
                    for _, v in ipairs(filtered_list) do
                        if v.ability.extra then
                            --[[This complicated check would simply fall apart if
                            a modded scaling joker didn't store its initial variables in config.extra,
                            but who cares anyway, it's the modder's fault, not mine]]
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
                    --[[Select itself as a fallback if copied joker is sold
                    This would be entirely your fault for doing such abomination in a live run]]
                end
            end
            card.loaded = false
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize('k_none')
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds*G.GAME.alice_multiplier } }
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                JokerDisplay.copy_display(card, copied_joker, copied_debuff)
            end,
            get_blueprint_joker = function(card)
                local filtered_list = {}
                for _, v in ipairs(G.jokers.cards) do
                    if card.ability.extra.copied_joker_buffer_key == v.config.center_key then
                        filtered_list[#filtered_list+1] = v
                    end
                end
                if #filtered_list > 1 then
                    for _, v in ipairs(filtered_list) do
                        if v.ability.extra then
                            if card.ability.extra.copied_joker_value_id == table.extract_total_value(v.ability.extra) then
                                return v
                            end
                        else
                            return filtered_list[1]
                        end
                    end
                elseif #filtered_list == 1 then
                    return filtered_list[1]
                end
                return nil
            end
        }
    end,
}

local duchess = {
    key = "duchess",
    name = "Duchess",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 17,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
    pos = { x = 3, y = 2 },
    config = {triggered = false, extra = {e_mult = 1.5, odds = 3, probability_list = {}}},
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
            return {
                e_mult = card.ability.extra.e_mult*G.GAME.alice_multiplier
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.triggered = false
            return true end }))
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.goodbye_frog and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.e_mult*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.joker_display_values", ref_value = "e_mult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
                card.joker_display_values.e_mult = card.ability.triggered and card.ability.extra.e_mult*G.GAME.alice_multiplier or 1
            end,
        }
    end,
}

local the_baby = {
    key = "the_baby",
    name = "The Baby",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 18,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.gfrog] = true },
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
                    repetitions = card.ability.extra*G.GAME.alice_multiplier,
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
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.goodbye_frog and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_duchess"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_duchess"]
        end
        return {vars = {card.ability.extra*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_duchess", nodes = {}}}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_left <= 1
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.localized_text = next(SMODS.find_card("j_sgt_duchess", true)) and localize("k_safe_ex") or localize("k_self_destruct_ex")
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = next(SMODS.find_card("j_sgt_duchess", true))
                    and G.C.GREEN or G.C.RED
                end
                return false
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return G.GAME and G.GAME.current_round.hands_left <= 1
                and (joker_card.ability.extra*G.GAME.alice_multiplier)*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local pepper_caster = {
    key = "pepper_caster",
    name = "Pepper-caster",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 15,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 2 },
    config = {extra = {retriggers = 1, uses = 10}, taken = false},
	rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center_key ~= "j_sgt_pepper_caster" then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.retriggers*G.GAME.alice_multiplier,
                card = card,
            }
		end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint and not context.retrigger_joker then
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
            card.ability.extra.uses = card.ability.extra.uses*G.GAME.alice_multiplier
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_the_cook", true)) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "uses" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses*G.GAME.alice_multiplier
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                return card.config.center_key ~= "j_sgt_pepper_caster" and
                    retrigger_joker.ability.extra.retriggers*G.GAME.alice_multiplier or 0
            end,
        }
    end,
}

local mad_hatter = {
    key = "mad_hatter",
    name = "Mad Hatter",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 19,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 3 },
    config = {extra = {ante_loss = 1}, temp_table = {}},
	rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual
        and not context.blueprint and not context.retrigger_joker and G.GAME.blind.boss then
            ease_ante(-card.ability.extra.ante_loss)
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.ante_loss
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and not G.GAME.saga_event_check.alice_in_wonderland.mad_hatter then
            G.GAME.saga_event.alice_in_wonderland.mad_hatter = true
        end
        card.ability.temp_table = {}
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if k ~= "uncommon_mod" or not G.GAME.story_mode then
                    table.insert(card.ability.temp_table, {[k] = v})
                    G.GAME[k] = 0
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.saga_event.alice_in_wonderland.mad_hatter then
            G.GAME.saga_event.alice_in_wonderland.mad_hatter = false
            G.GAME.saga_event_check.alice_in_wonderland.mad_hatter = true
        end
        card.ability.temp_table = card.ability.temp_table or {}
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if k ~= "uncommon_mod" or not G.GAME.story_mode then
                    G.GAME[k] = card.ability.temp_table[k] or 1
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.the_party and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.the_party
        and not G.GAME.saga_event_check.alice_in_wonderland.the_party)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "mad_hatter"}
        end
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize('k_sgt_trivial')
            end,
        }
    end,
}

local tea = {
    key = "tea",
    name = "Tea",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 20,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 3 },
    config = {extra = {chips = 10, uses = 1}, taken = false},
	rarity = "sgt_trivial",
    cost = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if context.after and not context.blueprint and not context.retrigger_joker then
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
                    message = localize('k_drank_ex'),
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
            card.ability.extra.uses = card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        return true, {allow_duplicates = true}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "uses" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses*G.GAME.alice_multiplier
                card.joker_display_values.chips = card.ability.extra.chips*G.GAME.alice_multiplier
            end,
        }
    end,
}

local bread = {
    key = "bread",
    name = "Bread",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 21,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 2, y = 3 },
    config = {extra = {chips = 20, uses = 1}, taken = false},
	rarity = "sgt_trivial",
    cost = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if context.after and not context.blueprint and not context.retrigger_joker then
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
            card.ability.extra.uses = card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        return true, {allow_duplicates = true}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "uses" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses*G.GAME.alice_multiplier
                card.joker_display_values.chips = card.ability.extra.chips*G.GAME.alice_multiplier
            end,
        }
    end,
}

local butter = {
    key = "butter",
    name = "Butter",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 22,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 3, y = 3 },
    config = {extra = {mult = 2, uses = 1}, taken = false},
	rarity = "sgt_trivial",
    cost = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
		end
        if context.after and not context.blueprint and not context.retrigger_joker then
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
            card.ability.extra.uses = card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)
        end
        card.ability.taken = true
    end,
    in_pool = function(self, args)
        return true, {allow_duplicates = true}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*G.GAME.alice_multiplier*(G.GAME.story_mode and 1 or 24)}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "uses" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses*G.GAME.alice_multiplier
                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
            end,
        }
    end,
}

local march_hare = {
    key = "march_hare",
    name = "March Hare",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 23,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 3 },
    config = {extra = {mult = 0, mult_gain = 3}},
	rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
			return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
		end
        if context.before and G.GAME.current_round.discards_used == 0 and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize("k_shared_ex"),
				colour = G.C.FILTER,
				card = card
			}
		end
        if context.discard and not context.blueprint and context.other_card == context.full_hand[1] and not context.hook then
            if G.GAME.current_round.discards_used <= 0 then
                return {
                    message = localize("k_avoided_ex"),
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.the_party and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult*G.GAME.alice_multiplier, card.ability.extra.mult_gain*G.GAME.alice_multiplier}}
	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
            end
        }
    end,
}

local dormouse = {
    key = "dormouse",
    name = "Dormouse",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 24,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 3 },
    config = {extra = {mult = 80, odds = 4}},
	rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main and pseudorandom("dormouse") < G.GAME.probabilities.normal/card.ability.extra.odds then
            return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.the_party and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.mult*G.GAME.alice_multiplier}}
	end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
            end
        }
    end,
}

local red_queen = {
    key = "red_queen",
    name = "Red Queen",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 25,
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 4 },
    config = {extra = {e_mult = 1.1, odds = 1}},
	rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.story_mode and next(SMODS.find_card("j_sgt_cheshire_cat", true))
        and not context.blueprint and not card.getting_sliced and not context.retrigger_joker then
            for _, v in ipairs(G.jokers.cards) do
                if v ~= card and not v.ability.eternal then
                    v.getting_sliced = true
                end
            end
            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.8, 0.8)
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and v.getting_sliced then
                        v:start_dissolve({G.C.RED}, nil, 1.6)
                    end
                end
            return true end }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_enraged_ex'), colour = G.C.RED})
        end
        if context.individual and context.cardarea == G.play then
            if not context.other_card.debuff then
                return {
                    e_mult = card.ability.extra.e_mult*G.GAME.alice_multiplier
                }
            end
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if not context.destroying_card.debuff and pseudorandom("red_queen_decapitate") < G.GAME.probabilities.normal/(card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor) then
                return {
                    message = localize("k_die_ex"),
                    colour = G.C.RED,
                    remove = true
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode then
            if not card.ability.perishable or G.GAME.modifiers.cry_eternal_perishable_compat then
                card:set_eternal(true)
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.red_queen and true or false
        end
        return not G.GAME.red_queen_blind
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.red_queen
        and not G.GAME.saga_event_check.alice_in_wonderland.red_queen)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "red_queen"}
        end
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor, card.ability.extra.e_mult*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.joker_display_values", ref_value = "e_mult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
            calc_function = function(card)
                local count = 0
                local emult = card.ability.extra.e_mult*G.GAME.alice_multiplier
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor } }
                card.joker_display_values.e_mult = emult^count
            end,
        }
    end,
}

local king = {
    key = "king",
    name = "The King",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 26,
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 1, y = 4 },
    config = {extra = {mult = 10, relief = 5}},
	rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor*card.ability.extra.relief
        if G.GAME.relief_factor >= 25 and G.GAME.saga_event.alice_in_wonderland.red_queen then
            if next(SMODS.find_card("j_sgt_flamingo", true)) then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center_key == "j_sgt_red_queen" then
                        v:set_eternal(nil)
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_amnestied_ex'), colour = Sagatro.badge_colour, instant = true})
                    end
                end
            end
            G.GAME.saga_event.alice_in_wonderland.red_queen = false
            G.GAME.saga_event_check.alice_in_wonderland.red_queen = true
            G.GAME.saga_event.alice_in_wonderland.gryphon = true
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor/card.ability.extra.relief
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_red_queen", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_red_queen"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_red_queen"]
        end
		return {vars = {card.ability.extra.mult*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_red_queen", nodes = {}}, card.ability.extra.relief}}
	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
            end,
        }
    end,
}

local flamingo = {
    key = "flamingo",
    name = "The Flamingo",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 27,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 2, y = 4 },
    config = {extra = {chips = 50, relief = 5}},
	rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor*card.ability.extra.relief
        if G.GAME.relief_factor >= 25 and G.GAME.saga_event.alice_in_wonderland.red_queen then
            if next(SMODS.find_card("j_sgt_king", true)) then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center_key == "j_sgt_red_queen" then
                        v:set_eternal(nil)
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_amnestied_ex'), colour = Sagatro.badge_colour, instant = true})
                    end
                end
            end
            G.GAME.saga_event.alice_in_wonderland.red_queen = false
            G.GAME.saga_event_check.alice_in_wonderland.red_queen = true
            G.GAME.saga_event.alice_in_wonderland.gryphon = true
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor/card.ability.extra.relief
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_red_queen", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_red_queen"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_red_queen"]
        end
		return {vars = {card.ability.extra.chips*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_sgt_red_queen", nodes = {}}, card.ability.extra.relief}}
	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            calc_function = function(card)
                card.joker_display_values.chips = card.ability.extra.chips*G.GAME.alice_multiplier
            end,
        }
    end,
}

local gryphon = {
    key = "gryphon",
    name = "Gryphon",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 28,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 3, y = 4 },
    config = {extra = {e_mult = 1.2}},
	rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card:get_id() == 12 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                else
                    return {
                        e_mult = card.ability.extra.e_mult*G.GAME.alice_multiplier,
                        card = context.other_card,
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.gryphon and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.gryphon
        and not G.GAME.saga_event_check.alice_in_wonderland.gryphon)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_hint_tooltip, key = "gryphon"}
        end
        return {vars = {card.ability.extra.e_mult*G.GAME.alice_multiplier}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.joker_display_values", ref_value = "e_mult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
            calc_function = function(card)
                local count = 0
                local emult = card.ability.extra.e_mult*G.GAME.alice_multiplier
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 12 then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.e_mult = emult^count
            end,
        }
    end,
}

local mock_turtle = {
    key = "mock_turtle",
    name = "Mock Turtle",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 29,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 4 },
    config = {extra = {e_mult = 2, e_mult_odds = 6, self_destruct_odds = 18, probability_list = {e_mult = false, self_destruct = false}}, taken = false},
	rarity = 3,
    cost = 10,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.probability_list.e_mult
            = pseudorandom("mock_turtle_critical") < G.GAME.probabilities.normal/card.ability.extra.e_mult_odds
            card.ability.extra.probability_list.self_destruct
            = pseudorandom("mock_turtle_vanish") < G.GAME.probabilities.normal/card.ability.extra.self_destruct_odds
        end
        if context.joker_main and (card.ability.extra.probability_list.e_mult or card.ability.extra.probability_list.self_destruct) then
            if not context.blueprint then
                card.ability.extra.self_destruct_odds = card.ability.extra.self_destruct_odds - 1
            end
            return {
                e_mult = card.ability.extra.e_mult*G.GAME.alice_multiplier
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.probability_list.self_destruct then
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
                    message = localize('k_poof_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.gryphon then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_trial_begins'), colour = G.C.RED, instant = true})
            G.GAME.saga_event.alice_in_wonderland.gryphon = false
            G.GAME.saga_event_check.alice_in_wonderland.gryphon = true
            G.GAME.saga_event.alice_in_wonderland.final_showdown = true
        end
        card.ability.taken = true
        card.ability.extra.self_destruct_odds = G.GAME.story_mode and 100 or 18
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_gryphon", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.e_mult_odds, card.ability.extra.e_mult*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra.self_destruct_odds or (G.GAME.story_mode and 100 or 18)}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "e_mult_odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.joker_display_values", ref_value = "e_mult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "self_destruct_odds", colour = G.C.GREEN },
                { text = " "..localize("k_to") },
                { text = " "..localize("k_self_destruct"), colour = G.C.RED },
                { text = ")" },
            },
            reminder_text_config = { scale = 0.2 },
            calc_function = function(card)
                card.joker_display_values.e_mult = card.ability.extra.e_mult*G.GAME.alice_multiplier
                card.joker_display_values.e_mult_odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.e_mult_odds } }
                card.joker_display_values.self_destruct_odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.self_destruct_odds } }
            end,
        }
    end,
}

local alice = {
    key = "alice",
    name = "Alice",
    atlas = "alice",
    saga_group = "alice_in_wonderland",
    order = 30,
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
            if v.config.center_key == "j_sgt_frog_footman" then
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
            if v.config.center_key == "j_sgt_frog_footman" then
                -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + (G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                -- return true end }))
                v.ability.alice_mult_buffer = G.GAME.alice_multiplier
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "extra"},
            },
            text_config = { colour = G.C.ORANGE },
        }
    end,
}

-- The Boy who cried wolf
local shepherd_boy = {
    key = "shepherd_boy",
    name = "Shepherd Boy",
    atlas = "the_boy_who_cried_wolf",
    saga_group = "the_boy_who_cried_wolf",
    order = 31,
    config = {extra = {mult = 0, mult_gain = 6, odds = 6}},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize("k_amused_ex"),
				colour = G.C.FILTER,
				card = card
			}
		end
        if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
        if context.after and not context.blueprint and not context.retrigger_joker
        and pseudorandom("real_wolf_incoming") < G.GAME.probabilities.normal/card.ability.extra.odds then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.mult = 0
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
                end
                local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('wolf_attack')) or nil

                if joker_to_destroy and not card.getting_sliced then
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({func = function()
                        card:juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_wolf_ex'), colour = G.C.RED})
            return true end }))
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain, G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card.ability.extra.mult
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
            end
        }
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
    mad_hatter,
    tea,
    bread,
    butter,
    march_hare,
    dormouse,
    red_queen,
    king,
    flamingo,
    gryphon,
    mock_turtle,
    alice,
    shepherd_boy,
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