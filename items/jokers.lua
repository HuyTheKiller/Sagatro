-- Alice in Wonderland
local white_rabbit = {
    key = "white_rabbit",
    name = "White Rabbit",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 1,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 0 },
    config = {extra = {chips = 0, chip_mod = 6}},
	rarity = 1,
    cost = 4,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if context.before and G.GAME.current_round.discards_used <= 0 and not context.blueprint then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                    scaling_message = {
                        message = localize("k_in_a_hurry_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize("k_in_a_hurry_ex"),
                    colour = G.C.FILTER,
                    card = card
                }
            end
		end
        if context.pre_discard and not context.blueprint and not context.retrigger_joker and not context.forcetrigger and not context.hook then
            if G.GAME.current_round.discards_used <= 0 then
                return {
                    message = localize("k_too_late_ex"),
                    colour = G.C.RED,
                    card = card,
                    no_retrigger = true
                }
            end
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                    no_message = true
                })
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            end
            return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "white_rabbit"}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "fusion_hint", title = localize("saga_fusion_tooltip")}
        end
		return {vars = {card.ability.extra.chips*G.GAME.alice_multiplier, card.ability.extra.chip_mod*G.GAME.alice_multiplier}}
	end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint and not context.retrigger_joker
        and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me" then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if not SMODS.has_no_rank(v) and v:get_id() ~= 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                assert(SMODS.change_base(v, nil, "2"))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = localize("k_shrunk_ex"),
                    colour = G.C.BLUE,
                    no_retrigger = true
                }
            end
            if context.after then
                if card.ability.extra - 1 <= 0 then
                    Sagatro.self_destruct(card)
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)
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
        local ret = {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[#G.jokers.cards] == card and not context.blueprint and not context.retrigger_joker
        and (G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me" and G.jokers.cards[1].config.center_key ~= "j_sgt_unlabeled_bottle") then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if not SMODS.has_no_rank(v) and ((not next(SMODS.find_card("j_sgt_little_bill")) and v:get_id() ~= 14)
                    or (next(SMODS.find_card("j_sgt_little_bill")) and v:get_id() ~= 2)) then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                assert(SMODS.change_base(v, nil, next(SMODS.find_card("j_sgt_little_bill")) and "2" or "Ace"))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = not next(SMODS.find_card("j_sgt_little_bill", true)) and localize("k_enlarged_ex") or localize("k_shrunk_ex"),
                    colour = G.C.BLUE,
                    no_retrigger = true
                }
            end
            if context.after then
                if G.GAME.blind and G.GAME.blind.config.blind.key == "bl_sgt_red_queen" then
                    G.E_MANAGER:add_event(Event({func = function()
                        if to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
                            local do_not_cut_score = true
                            G.GAME.blind:disable(do_not_cut_score)
                        end
                    return true end }))
                end
                if card.ability.extra - 1 <= 0 then
                    Sagatro.self_destruct(card)
                    if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.little_bill
                    and not G.GAME.saga_event_check.alice_in_wonderland.huge_dog then
                        G.GAME.saga_event_check.alice_in_wonderland.little_bill = true
                        G.GAME.saga_event.alice_in_wonderland.little_bill = false
                        G.GAME.saga_event.alice_in_wonderland.huge_dog = true
                    end
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)
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
        local ret = {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), localize{type = 'name_text', set = "Joker", key = "j_sgt_drink_me", nodes = {}}}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    config = {extra = {mult = 20, buffer_mult = 0, debuff_position = {}}},
	rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
			return {
                add_to_hand = true,
                no_retrigger = true
            }
		end
        if (context.joker_main or context.forcetrigger) and to_big(card.ability.extra.mult) > to_big(0) then
            return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
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
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra.buffer_mult = card.ability.extra.mult
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_kid_gloves_and_fan", true)) and not next(SMODS.find_card("j_sgt_mad_hatter"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_splash"]
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.cry_into_flood
        and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "fusion_hint", title = localize("saga_fusion_tooltip")}
        end
        local ret = {vars = {card.ability.extra.mult*G.GAME.alice_multiplier, localize{type = 'name_text', set = "Joker", key = "j_splash", nodes = {}}}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
            end,
            scoring_function = function(playing_card, scoring_hand, joker_card)
                return true
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
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint then
            if context.individual and context.cardarea == G.play then
                if not context.other_card.debuff then
                    local temp = context.other_card
                    if not SMODS.has_no_rank(temp) and temp:get_id() ~= 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, G.GAME.alice_multiplier do
                                    if temp:get_id() <= 2 then break end
                                    assert(SMODS.modify_rank(temp, -1))
                                end

                                return true
                            end
                        }))
                    end
                end
            end
            if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
                if not context.destroy_card.debuff then
                    local temp = context.destroy_card
                    if not SMODS.has_no_rank(temp) and temp:get_id() <= 2 then
                        return {
                            message = localize("k_poof_ex"),
                            colour = G.C.FILTER,
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "kid_gloves_and_fan"}
        end
        local ret = {vars = {card.ability.extra*G.GAME.alice_multiplier}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    config = {extra = {xmult = 1.5}},
	rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.other_joker and not context.forcetrigger then
            if G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult*G.GAME.alice_multiplier}},
                    Xmult_mod = card.ability.extra.xmult*G.GAME.alice_multiplier
                }
            end
        end
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult*G.GAME.alice_multiplier}},
                Xmult_mod = card.ability.extra.xmult*G.GAME.alice_multiplier
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.cry_into_flood then
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "dodo_bird"}
        end
        return {vars = {card.ability.extra.xmult*G.GAME.alice_multiplier}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                if mod_joker.ability.set == "Joker" then
                    return { x_mult = (G.GAME.current_round.hands_left <= 1 and G.GAME.current_round.discards_left == 0 and (mod_joker.ability.extra.xmult*G.GAME.alice_multiplier) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
                end
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
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.taken = not G.GAME.story_mode
    end,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint and not context.retrigger_joker then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if not SMODS.has_no_rank(v) and v:get_id() ~= 14 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                assert(SMODS.change_base(v, nil, "Ace"))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = localize("k_enlarged_ex"),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
            if context.after then
                for _, v in ipairs(SMODS.find_card("j_sgt_white_rabbit", true)) do
                    local yeet_text = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = "immediate",
                            blockable = false,
                            func = function()
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_yeet_ex'), instant = true})
                                return true
                            end
                        }))
                    end
                    Sagatro.self_destruct(v, {sound = "sgt_run_away", pitch = 1, volume = 1}, yeet_text)
                end
                if card.ability.extra - 1 <= 0 then
                    Sagatro.self_destruct(card)
                    if G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.little_bill then
                        G.GAME.saga_event.alice_in_wonderland.little_bill = true
                    end
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                else
                    card.ability.extra = card.ability.extra - 1
                    return {
                        message = card.ability.extra..'',
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.taken = true
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "unlabeled_bottle"}
        end
        local ret
        if card.ability.taken or Sagatro.debug then
            ret = {
                key = "j_sgt_unlabeled_bottle",
                vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)}
            }
            if Ortalab then
                ret.main_end = {}
                localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
                ret.main_end = ret.main_end[1]
            end
        else ret = {
            key = "j_sgt_unlabeled_bottle_collection"
        }
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    config = {type = "Full House", extra = 2},
	rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.poker_hands and next(context.poker_hands[card.ability.type]) and context.repetition and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra*G.GAME.alice_multiplier,
                    card = card
                }
            end
        end
    end,
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "little_bill"}
        end
        return {vars = {card.ability.extra*G.GAME.alice_multiplier, localize(card.ability.type, 'poker_hands'), localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers", retrigger_type = "mult" },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize{type = 'name_text', set = "Joker", key = "j_sgt_eat_me", nodes = {}}
                card.joker_display_values.is_full_house = false
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    card.joker_display_values.is_full_house = true
                end
                card.joker_display_values.retriggers = card.joker_display_values.is_full_house
                and card.ability.extra*G.GAME.alice_multiplier or 0
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return first_card and playing_card == first_card and joker_card.joker_display_values.is_full_house and
                    joker_card.ability.extra*G.GAME.alice_multiplier*JokerDisplay.calculate_joker_triggers(joker_card) or 0
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
    demicoloncompat = false,
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
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode then
            G.GAME.saga_event.alice_in_wonderland.huge_dog = false
            G.GAME.saga_event_check.alice_in_wonderland.huge_dog = true
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.caterpillar then
            G.GAME.saga_event.alice_in_wonderland.caterpillar = true
        end
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "huge_dog"}
        end
        return {vars = {card.ability.extra.times*G.GAME.alice_multiplier, card.ability.extra.extra_times*G.GAME.alice_multiplier}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers", retrigger_type = "mult" },
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
    name = "SauKhongHu",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 10,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 4, y = 1 },
    config = {extra = 12},
	rarity = 1,
    cost = 1,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint
        and not context.retrigger_joker and card.ability.extra > 0 then
            if not context.other_card.debuff then
                local temp = context.other_card
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if not SMODS.has_no_rank(temp) then
                            local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('caterpillar_random_rank'))
                            local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('caterpillar_random_suit'))
                            assert(SMODS.change_base(temp, _suit.key, _rank.key))
                        end
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
                Sagatro.self_destruct(card)
                if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.caterpillar then
                    G.GAME.saga_event.alice_in_wonderland.caterpillar = false
                    G.GAME.saga_event_check.alice_in_wonderland.caterpillar = true
                end
                return {
                    message = localize('k_go_off_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "caterpillar"}
        end
        return {vars = {card.ability.extra, localize{type = 'name_text', set = "Joker", key = "j_sgt_mushroom", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1] and not context.blueprint and not context.retrigger_joker then
            if G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_eat_me" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                for _ = 1, card.ability.times*G.GAME.alice_multiplier do
                                    assert(SMODS.modify_rank(v, -1))
                                end

                                return true
                            end
                        }))
                    end
                    return {
                        message = localize("k_shrunk_ex"),
                        colour = G.C.BLUE,
                        no_retrigger = true
                    }
                end
                if context.after then
                    if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.the_party then
                        G.GAME.saga_event.alice_in_wonderland.the_party = false
                        G.GAME.saga_event_check.alice_in_wonderland.the_party = true
                        G.GAME.saga_event.alice_in_wonderland.red_queen = true
                    end
                    if G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper then
                        G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = true
                    end
                    if card.ability.extra - 1 <= 0 then
                        Sagatro.self_destruct(card)
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER,
                            no_retrigger = true
                        }
                    else
                        card.ability.extra = card.ability.extra - 1
                        return {
                            message = card.ability.extra..'',
                            colour = G.C.FILTER,
                            no_retrigger = true
                        }
                    end
                end
            elseif G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].config.center_key ~= "j_sgt_drink_me" then
                if context.before then
                    for _, v in ipairs(context.scoring_hand) do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                for _ = 1, card.ability.times*G.GAME.alice_multiplier do
                                    assert(SMODS.modify_rank(v, 1))
                                end

                                return true
                            end
                        }))
                    end
                    return {
                        message = localize("k_enlarged_ex"),
                        colour = G.C.BLUE,
                        no_retrigger = true
                    }
                end
                if context.after then
                    if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.the_party then
                        G.GAME.saga_event.alice_in_wonderland.the_party = false
                        G.GAME.saga_event_check.alice_in_wonderland.the_party = true
                        G.GAME.saga_event.alice_in_wonderland.red_queen = true
                    end
                    if G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper then
                        G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = true
                    end
                    if card.ability.extra - 1 <= 0 then
                        Sagatro.self_destruct(card)
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER,
                            no_retrigger = true
                        }
                    else
                        card.ability.extra = card.ability.extra - 1
                        return {
                            message = card.ability.extra..'',
                            colour = G.C.FILTER,
                            no_retrigger = true
                        }
                    end
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra = card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "mushroom"}
        end
        local ret = {vars = {card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), card.ability.times*G.GAME.alice_multiplier}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    config = {extra = 3, egg_boost = 1, triggered = false, value_loss = 2},
	rarity = 2,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval and not context.blueprint) or context.forcetrigger then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_egg" then
                    card.ability.triggered = true
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = v.ability,
                            ref_value = "extra_value",
                            scalar_table = card.ability,
                            scalar_value = "egg_boost",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*G.GAME.alice_multiplier
                            end,
                            no_message = true
                        })
                    else
                        v.ability.extra_value = v.ability.extra_value + card.ability.egg_boost*G.GAME.alice_multiplier
                    end
                    v:set_cost()
                end
            end
            if card.ability.triggered then
                card.ability.triggered = false
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY,
                    card = card,
                }
            end
        end
        if context.selling_card and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            if context.card.config.center_key == "j_egg" then
                card.ability.extra_value = (card.ability.extra_value or 0) - card.ability.value_loss
                card.ability.value_loss = card.ability.value_loss*2
                card:set_cost()
                card:juice_up(0.5, 0.5)
            end
        end
        if context.selling_self and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            local found_egg = false
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_egg" then
                    SMODS.debuff_card(v, true, "j_sgt_pigeon")
                    v:juice_up(0.5, 0.5)
                    if not found_egg then found_egg = true end
                end
            end
            if found_egg then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
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
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_egg" and v.ability.debuff_sources and v.ability.debuff_sources.j_sgt_pigeon then
                    SMODS.debuff_card(v, false, "j_sgt_pigeon")
                    v:juice_up(0.5, 0.5)
                end
            end
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
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_egg", nodes = {}}, card.ability.extra*G.GAME.alice_multiplier, card.ability.egg_boost*G.GAME.alice_multiplier, card.ability.value_loss}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                { text = ", " },
                { text = "-$", colour = G.C.RED },
                { ref_table = "card.ability", ref_value = "value_loss", colour = G.C.RED },
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
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if ((context.open_booster and not context.blueprint and not context.retrigger_joker) or context.forcetrigger)
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local times = G.consumeables.config.card_limit - #G.consumeables.cards
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + times
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    for _ = 1, times do
                        local chosen_set = pseudorandom_element({"Tarot", "Planet", "Spectral"}, pseudoseed("frog_footman"))
                        SMODS.add_card{set = chosen_set, key_append = "fro"}
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_ouch_ex'), colour = G.C.SECONDARY_SET.Tarot})
            card.ability.extra = card.ability.extra - 1
            if card.ability.extra <= 0 then
                Sagatro.self_destruct(card)
                if G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog then
                    G.GAME.saga_event.alice_in_wonderland.pig_and_pepper = false
                    G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper = true
                    G.GAME.saga_event.alice_in_wonderland.goodbye_frog = true
                end
                return {
                    message = localize('k_goodbye_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
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
            card.ability.extra = card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "frog_footman"}
        end
        return {vars = {card.ability.consumable_slot*G.GAME.alice_multiplier, card.ability.taken and card.ability.extra or card.ability.extra*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier)}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
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
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.sgt_stay_flipped and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card:juice_up(0.7)
        end
        if context.sgt_play_cards and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card.ability.extra.card_list = {}
            for i = 1, #G.hand.highlighted do
                if G.hand.highlighted[i].facing == 'back' then
                    table.insert(card.ability.extra.card_list, G.hand.highlighted[i])
                end
            end
        end
        if context.individual and context.cardarea == G.play and not context.forcetrigger then
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
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult*G.GAME.alice_multiplier}},
                Xmult_mod = card.ability.extra.xmult*G.GAME.alice_multiplier
            }
        end
        if context.end_of_round and context.main_eval
        and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
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
                message = localize("k_stirred_ex"),
                colour = G.C.RED,
                no_retrigger = true
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
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "thecook")
        return {vars = {n, d, card.ability.extra.xmult*G.GAME.alice_multiplier}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "thecook") } }
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
    config = {extra = {odds = 3}, taken = false},
	rarity = 1,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.odds = G.GAME.story_mode and 2 or 3
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, 'cheshire_cat_vanish', 1, card.ability.extra.odds*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), "cheshire_cat") then
				Sagatro.self_destruct(card)
                if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.goodbye_frog then
                    G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog = true
                    G.GAME.saga_event.alice_in_wonderland.goodbye_frog = false
                    G.GAME.saga_event.alice_in_wonderland.the_party = true
                end
				return {
					message = localize("k_gone_ex"),
                    no_retrigger = true
				}
			else
				return {
					message = localize("k_grin_ex"),
                    no_retrigger = true
				}
			end
        end
        local left_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                left_joker = G.jokers.cards[i-1]
            end
        end
        if not left_joker and #G.jokers.cards > 1 then
            for i = 1, #G.consumeables.cards do
                if G.consumeables.cards[i] == card then
                    if G.consumeables.cards[i-1] then
                        if G.consumeables.cards[i-1].ability.set == "Joker" then
                            left_joker = G.consumeables.cards[i-1]
                        end
                    else
                        left_joker = G.jokers.cards[#G.jokers.cards]
                    end
                end
            end
        end
        local left_joker_ret = SMODS.blueprint_effect(card, left_joker, context)
        if left_joker_ret then
            left_joker_ret.colour = G.C.SECONDARY_SET.Tarot
        end
        return left_joker_ret
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event_check.alice_in_wonderland.pig_and_pepper and true or false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.goodbye_frog
        and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "cheshire_cat"}
        end
        local ret = {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), "cheshire_cat")}}
        if card.area and (card.area == G.jokers or card.area == G.consumeables) then
            local left_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    left_joker = G.jokers.cards[i-1]
                end
            end
            if not left_joker and #G.jokers.cards > 1 then
                for i = 1, #G.consumeables.cards do
                    if G.consumeables.cards[i] == card then
                        if G.consumeables.cards[i-1] then
                            if G.consumeables.cards[i-1].ability.set == "Joker" then
                                left_joker = G.consumeables.cards[i-1]
                            end
                        else
                            left_joker = G.jokers.cards[#G.jokers.cards]
                        end
                    end
                end
            end
            local left_compatible = left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat
            ret.main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = left_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (left_compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "cat_odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
                { text = ")" }
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            calc_function = function(card)
                card.joker_display_values.cat_odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds*(G.GAME.story_mode and 1 or G.GAME.alice_multiplier), "cheshire_cat") } }
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                card.joker_display_values.blueprint_compat = localize('k_incompatible')
                JokerDisplay.copy_display(card, copied_joker, copied_debuff)
                card.joker_display_values.copy = card.joker_display_values.copy or card
                if copied_joker and copied_joker ~= card.joker_display_values.copy then
                    if Sagatro.init_JDdebug then
                        print(card.joker_display_values.copy)
                        Sagatro.init_JDdebug = nil
                    end
                    card.children.joker_display:add_extra({
                        {
                            { text = "(" },
                            { ref_table = "card.joker_display_values", ref_value = "cat_odds" },
                            { text = ")" },
                        }
                    }, { colour = G.C.GREEN, scale = 0.3 })
                end
                card.joker_display_values.copy = copied_joker
            end,
            get_blueprint_joker = function(card)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        return G.jokers.cards[i-1]
                    end
                end
                for i = 1, #G.consumeables.cards do
                if G.consumeables.cards[i] == card then
                    if G.consumeables.cards[i-1] then
                        if G.consumeables.cards[i-1].ability.set == "Joker" then
                            return G.consumeables.cards[i-1]
                        end
                    else
                        return G.jokers.cards[#G.jokers.cards]
                    end
                end
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
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card.ability.extra.probability_list = {}
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    card.ability.extra.probability_list[#card.ability.extra.probability_list+1]
                    = SMODS.pseudorandom_probability(card, 'duchess_execute', 1, card.ability.extra.odds, "duchess")
                else
                    card.ability.extra.probability_list[#card.ability.extra.probability_list+1] = false
                end
            end
            for _, v in ipairs(card.ability.extra.probability_list) do
                if v then card.ability.triggered = true break end
            end
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i] == context.destroy_card and card.ability.extra.probability_list[i] then
                    return {
                        message = localize("k_die_ex"),
                        colour = G.C.RED,
                        remove = true,
                        no_retrigger = true
                    }
                end
            end
        end
        if (context.joker_main and card.ability.triggered) or context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
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
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "duchess")
        local ret = {vars = {n, d, card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)}}
        if next(SMODS.find_card("j_sgt_alice")) then
            ret.main_end = {}
            if not Sagatro.mod_compat.talisman then
                localize{type = "other", key = "sgt_require_talisman_for_emult", nodes = ret.main_end, vars = {}}
            else
                localize{type = "other", key = "sgt_talisman_detected", nodes = ret.main_end, vars = {}}
            end
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "duchess") } }
                card.joker_display_values.e_mult = card.ability.triggered and card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier) or 1
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
    demicoloncompat = false,
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
                    Sagatro.self_destruct(card, {sound = "sgt_run_away", pitch = 1, volume = 1})
                    return {
                        message = localize('k_yeet_ex'),
                        colour = G.C.FILTER,
                        no_retrigger = true
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center_key ~= "j_sgt_pepper_caster" then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                card = card,
            }
		end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.uses - 1 <= 0 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                card.ability.extra.uses = card.ability.extra.uses - 1
                return {
                    message = card.ability.extra.uses..'',
                    colour = G.C.FILTER,
                    no_retrigger = true
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
        local ret = {vars = {card.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier), card.ability.taken and card.ability.extra.uses or card.ability.extra.uses*G.GAME.alice_multiplier}}
        if next(SMODS.find_card("j_sgt_alice")) then
            ret.main_end = {}
            if not Sagatro.mod_compat.talisman then
                localize{type = "other", key = "sgt_require_talisman_for_retriggers", nodes = ret.main_end, vars = {}}
            else
                localize{type = "other", key = "sgt_talisman_detected", nodes = ret.main_end, vars = {}}
            end
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers" },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "uses" },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "start_count" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.retriggers = card.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                return card.config.center_key ~= "j_sgt_pepper_caster" and
                    retrigger_joker.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier) or 0
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
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and not G.GAME.saga_event_check.alice_in_wonderland.mad_hatter then
            G.GAME.saga_event.alice_in_wonderland.mad_hatter = true
        end
        Sagatro.update_blind_amounts()
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                and k ~= "legendary_mod"
                -- TARGET: exclude rarity that require specific conditions to spawn here
                -- (e.g. Cryptid's Exotic, Entropy's Entropic)
                and k ~= "cry_exotic_mod"
                and k ~= "entr_entropic_mod"
                then
                    -- consider this infinitesimal, I can't find another way that wouldn't break with multiple Mad Hatters
                    G.GAME[k] = G.GAME[k]/1e18
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.mad_hatter then
            G.GAME.saga_event.alice_in_wonderland.mad_hatter = false
            G.GAME.saga_event_check.alice_in_wonderland.mad_hatter = true
        end
        Sagatro.update_blind_amounts()
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                and k ~= "legendary_mod"
                -- TARGET: exclude rarity that require specific conditions to spawn here
                -- (e.g. Cryptid's Exotic, Entropy's Entropic)
                and k ~= "cry_exotic_mod"
                and k ~= "entr_entropic_mod"
                then
                    G.GAME[k] = G.GAME[k]*1e18
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return G.GAME.saga_event.alice_in_wonderland.the_party and true or false
        end
        return not next(SMODS.find_card("j_sgt_mad_hatter", true))
    end,
    loc_vars = function(self, info_queue, card)
        if (G.GAME.story_mode and G.STAGE == G.STAGES.RUN and not card.fake_card
        and G.GAME.saga_event.alice_in_wonderland.the_party
        and not G.GAME.saga_event_check.alice_in_wonderland.the_party)
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "mad_hatter"}
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if (context.after and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if card.ability.extra.uses - 1 <= 0 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_drank_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                card.ability.extra.uses = card.ability.extra.uses - 1
                return {
                    message = card.ability.extra.uses..'',
                    colour = G.C.FILTER,
                    no_retrigger = true
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses
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
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
        if (context.after and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if card.ability.extra.uses - 1 <= 0 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                card.ability.extra.uses = card.ability.extra.uses - 1
                return {
                    message = card.ability.extra.uses..'',
                    colour = G.C.FILTER,
                    no_retrigger = true
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses
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
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
			return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
		end
        if (context.after and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if card.ability.extra.uses - 1 <= 0 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                card.ability.extra.uses = card.ability.extra.uses - 1
                return {
                    message = card.ability.extra.uses..'',
                    colour = G.C.FILTER,
                    no_retrigger = true
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.uses
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
    config = {extra = {mult = 0, mult_mod = 3}},
	rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
			return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
		end
        if context.before and G.GAME.current_round.discards_used <= 0 and not context.blueprint then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    scaling_message = {
                        message = localize("k_shared_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize("k_shared_ex"),
                    colour = G.C.FILTER,
                    card = card
                }
            end
		end
        if context.pre_discard and not context.blueprint and not context.retrigger_joker and not context.forcetrigger and not context.hook then
            if G.GAME.current_round.discards_used <= 0 then
                return {
                    message = localize("k_avoided_ex"),
                    colour = G.C.RED,
                    card = card,
                    no_retrigger = true
                }
            end
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    no_message = true
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            end
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
		return {vars = {card.ability.extra.mult*G.GAME.alice_multiplier, card.ability.extra.mult_mod*G.GAME.alice_multiplier}}
	end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and SMODS.pseudorandom_probability(card, "dormouse", 1, card.ability.extra.odds, "dormouse")) or context.forcetrigger then
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
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "dormouse")
		return {vars = {n, d, card.ability.extra.mult*G.GAME.alice_multiplier}}
	end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "dormouse") } }
                card.joker_display_values.mult = card.ability.extra.mult*G.GAME.alice_multiplier
            end
        }
    end,
}

local red_queen = {
    key = "red_queen",
    name = "Queen Of Hearts",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 25,
    pools = { [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 0, y = 4 },
    config = {extra = {e_mult = 1.1, odds = 1}},
	rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.story_mode and next(SMODS.find_card("j_sgt_cheshire_cat", true))
        and not context.blueprint and not card.getting_sliced and not context.retrigger_joker and not context.forcetrigger then
            for _, v in ipairs(G.jokers.cards) do
                if v ~= card and SMODS.is_eternal(v, card) then
                    v.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                end
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                card:juice_up(0.8, 0.8)
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and v.getting_sliced then
                        v:start_dissolve({G.C.RED}, nil, 1.6)
                    end
                end
            return true end }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_enraged_ex'), colour = G.C.RED})
        end
        if context.individual and context.cardarea == G.play and not context.forcetrigger then
            if not context.other_card.debuff then
                return {
                    sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                }
            end
        end
        if context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                card = card,
            }
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            if not context.destroy_card.debuff and SMODS.pseudorandom_probability(card, "red_queen_decapitate", 1, card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor, "red_queen") then
                return {
                    message = localize("k_die_ex"),
                    colour = G.C.RED,
                    remove = true,
                    no_retrigger = true
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "red_queen"}
        end
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor, "red_queen")
        local ret = {vars = {n, d, card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)}}
        if next(SMODS.find_card("j_sgt_alice")) then
            ret.main_end = {}
            if not Sagatro.mod_compat.talisman then
                localize{type = "other", key = "sgt_require_talisman_for_emult", nodes = ret.main_end, vars = {}}
            else
                localize{type = "other", key = "sgt_talisman_detected", nodes = ret.main_end, vars = {}}
            end
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local emult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds*G.GAME.alice_multiplier*G.GAME.relief_factor, "red_queen") } }
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
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult_mod = card.ability.extra.mult*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult*G.GAME.alice_multiplier}}
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor*card.ability.extra.relief
        if G.GAME.relief_factor >= 25 and G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.red_queen then
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
			return {
				chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
			}
		end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.relief_factor = G.GAME.relief_factor*card.ability.extra.relief
        if G.GAME.relief_factor >= 25 and G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.red_queen then
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
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    config = {extra = {e_mult = 1.1}},
	rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if context.other_card:get_id() == 12 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                        card = card,
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                card = card,
            }
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
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "gryphon"}
        end
        local ret = {vars = {card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)}}
        if next(SMODS.find_card("j_sgt_alice")) then
            ret.main_end = {}
            if not Sagatro.mod_compat.talisman then
                localize{type = "other", key = "sgt_require_talisman_for_emult", nodes = ret.main_end, vars = {}}
            else
                localize{type = "other", key = "sgt_talisman_detected", nodes = ret.main_end, vars = {}}
            end
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local emult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)
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
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.self_destruct_odds = G.GAME.story_mode and 100 or 18
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card.ability.extra.probability_list.e_mult
            = SMODS.pseudorandom_probability(card, "mock_turtle_critical", 1, card.ability.extra.e_mult_odds)
            card.ability.extra.probability_list.self_destruct
            = SMODS.pseudorandom_probability(card, "mock_turtle_vanish", 1, card.ability.extra.self_destruct_odds)
        end
        if (context.joker_main and (card.ability.extra.probability_list.e_mult or card.ability.extra.probability_list.self_destruct)) or context.forcetrigger then
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.extra.self_destruct_odds = card.ability.extra.self_destruct_odds - 1
                    if card.ability.extra.self_destruct_odds < (Cryptid and 0.001 or 1) then
                        card.ability.extra.self_destruct_odds = Cryptid and 0.001 or 1
                    end
                return true end }))
            end
            return {
                sgt_e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            if card.ability.extra.probability_list.self_destruct then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_poof_ex'),
                    colour = G.C.RED,
                    no_retrigger = true
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.gryphon then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_trial_begins'), colour = G.C.RED, instant = true})
            G.GAME.saga_event.alice_in_wonderland.gryphon = false
            G.GAME.saga_event_check.alice_in_wonderland.gryphon = true
            G.GAME.saga_event.alice_in_wonderland.final_showdown = true
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_gryphon", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.e_mult_odds, "mock_turtle_critical")
        local ret = {vars = {n, d,
        card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
        SMODS.get_probability_vars(card, 1, card.ability.extra.self_destruct_odds, "mock_turtle_vanish")}}
        if next(SMODS.find_card("j_sgt_alice")) then
            ret.main_end = {}
            if not Sagatro.mod_compat.talisman then
                localize{type = "other", key = "sgt_require_talisman_for_emult", nodes = ret.main_end, vars = {}}
            else
                localize{type = "other", key = "sgt_talisman_detected", nodes = ret.main_end, vars = {}}
            end
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.e_mult = card.ability.extra.e_mult*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)
                card.joker_display_values.e_mult_odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.e_mult_odds, "mock_turtle_critical") } }
                card.joker_display_values.self_destruct_odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.self_destruct_odds, "mock_turtle_vanish") } }
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
    pools = { [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    config = {extra = 3},
	rarity = 4,
    cost = 20,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN then
            G.GAME.alice_multiplier = G.GAME.alice_multiplier*card.ability.extra
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_sgt_frog_footman" then
                    -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + (G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                    -- return true end })) -- For some ducking reason events don't work here
                    v.ability.alice_mult_buffer = G.GAME.alice_multiplier
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.STAGE == G.STAGES.RUN then
            G.GAME.alice_multiplier = G.GAME.alice_multiplier/card.ability.extra
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_sgt_frog_footman" then
                    -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + (G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                    -- return true end }))
                    v.ability.alice_mult_buffer = G.GAME.alice_multiplier
                end
            end
        end
    end,
    in_pool = function(self, args)
        -- if G.GAME.story_mode then
        --     return G.GAME.saga_event.alice_in_wonderland.final_showdown and true or false
        -- end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_wond'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
    atlas = "misc_jokers",
    saga_group = "the_boy_who_cried_wolf",
    order = 990,
    pos = { x = 0, y = 0 },
    config = {extra = {mult = 0, mult_mod = 12, odds = 6}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    scaling_message = {
                        message = localize("k_amused_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize("k_amused_ex"),
                    colour = G.C.FILTER,
                    card = card
                }
            end
		end
        if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
        if context.after and not context.blueprint and not context.retrigger_joker
        and SMODS.pseudorandom_probability(card, "real_wolf_incoming", 1, card.ability.extra.odds, "shepherd_boy") then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.mult = 0
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
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
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    no_message = true
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            end
            G.E_MANAGER:add_event(Event({func = function()
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
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
            return {
				mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "shepherd_boy")}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "shepherd_boy") } }
            end
        }
    end,
}

-- Puss in Boots
local puss_in_boots = {
    key = "puss_in_boots",
    name = "Puss In Boots",
    atlas = "misc_jokers",
    saga_group = "puss_in_boots",
    order = 991,
    pos = { x = 1, y = 0 },
    config = {extra = {money = 2, xmult = 2, jack_triggered = false}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.forcetrigger then
            card.ability.extra.jack_triggered = false
            if not context.blueprint and not context.retrigger_joker then
                for i = 1, #context.scoring_hand do
                    local temp = context.scoring_hand[i]
                    if temp:get_id() == 11 then
                        card.ability.extra.jack_triggered = true
                        break
                    end
                end
            end
        end
        if context.individual and context.cardarea == G.play and not context.forcetrigger then
            local temp = context.other_card
            if temp:get_id() == 12 or temp:get_id() == 13 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
            if Talisman and not Talisman.config_file.disable_anims then G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)})) else G.GAME.dollar_buffer = 0 end
                return {
                    dollars = card.ability.extra.money
                }
            end
        end
        if context.forcetrigger then
            ease_dollars(card.ability.extra.money)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
            if Talisman and not Talisman.config_file.disable_anims then G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)})) else G.GAME.dollar_buffer = 0 end
        end
        if (context.joker_main and card.ability.extra.jack_triggered) or context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$", colour = G.C.GOLD },
                { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult", colour = G.C.GOLD },
                { text = " " },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local count = 0
                local jack_triggered = false
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() == 13 or scoring_card:get_id() == 12 then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        elseif scoring_card:get_id() == 11 then
                            jack_triggered = true
                        end
                    end
                end
                card.joker_display_values.money = card.ability.extra.money * count
                card.joker_display_values.xmult = jack_triggered and card.ability.extra.xmult or 1
            end,
        }
    end,
}

-- Iron John
local iron_john = {
    key = "iron_john",
    name = "Iron John",
    atlas = "misc_jokers",
    saga_group = "iron_john",
    order = 992,
    pos = { x = 5, y = 0 },
    config = {extra = {xmult = 1, xmult_mod = 1}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1] and (G.jokers.cards[#G.jokers.cards] == card or G.consumeables.cards[#G.consumeables.cards] == card) then
            if context.joker_main and to_big(card.ability.extra.xmult) > to_big(1) then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.extra.xmult = 1
                    return true end }))
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
            end
        else
            if context.before and not context.blueprint then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        message_key = "a_xmult",
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                    return {
                        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                        colour = G.C.FILTER,
                        card = card
                    }
                end
            end
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_mod",
                    no_message = true
                })
            else
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            end
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.xmult = 1
                return true end }))
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = (G.jokers.cards[#G.jokers.cards] == card or G.consumeables.cards[#G.consumeables.cards] == card)
                and localize("k_release") or localize("k_charge")
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = (G.jokers.cards[#G.jokers.cards] == card or G.consumeables.cards[#G.consumeables.cards] == card)
                    and G.C.GREEN or G.C.ORANGE
                end
                return false
            end,
        }
    end,
}

-- Aladdin and the Magic Lamp
local aladdin = {
    key = "aladdin",
    name = "Aladdin",
    atlas = "misc_jokers",
    saga_group = "aladdin_and_the_magic_lamp",
    order = 1004,
    pos = { x = 2, y = 0 },
    config = {buffed = false, extra = {tax = 0.25, xmult = 1, xmult_mod = 0.5, chips = 0}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if not card.ability.buffed then
            if (context.end_of_round and context.main_eval
            and not context.blueprint and not context.retrigger_joker) and G.GAME.dollars > to_big(0) then
                ease_dollars(-math.floor(to_number(G.GAME.dollars)*card.ability.extra.tax))
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        scaling_message = {
                            message = localize("k_steal_ex"),
                            colour = G.C.FILTER,
                            no_retrigger = true
                        }
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                    return {
                        message = localize("k_steal_ex"),
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                end
            end
            if context.joker_main and to_big(card.ability.extra.xmult) > to_big(1) then
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
            end
            if context.forcetrigger then
                ease_dollars(-math.floor(to_number(G.GAME.dollars)*card.ability.extra.tax))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_mod",
                    no_message = true
                })
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
            end
        else
            if context.joker_main or context.forcetrigger then
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult,
                    chip_mod = card.ability.extra.chips,
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if card.ability.buffed then
            ret.key = "j_sgt_aladdin_buffed"
            ret.vars = {card.ability.extra.chips, card.ability.extra.xmult}
        else
            ret.key = "j_sgt_aladdin"
            ret.vars = {card.ability.extra.xmult, card.ability.extra.tax*100, card.ability.extra.xmult_mod}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
                { ref_table = "card.joker_display_values", ref_value = "space" },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "open_bracket" },
                { ref_table = "card.joker_display_values", ref_value = "tax", colour = G.C.ORANGE },
                { ref_table = "card.joker_display_values", ref_value = "percent", colour = G.C.ORANGE },
                { ref_table = "card.joker_display_values", ref_value = "close_bracket" },
                { ref_table = "card.joker_display_values", ref_value = "buffed" },
            },
            calc_function = function(card)
                -- My lord, text abomination
                card.joker_display_values.plus = card.ability.buffed and "+" or ""
                card.joker_display_values.chips = card.ability.buffed and card.ability.extra.chips or ""
                card.joker_display_values.space = card.ability.buffed and " " or ""
                card.joker_display_values.open_bracket = card.ability.buffed and " " or "("
                card.joker_display_values.tax = card.ability.buffed and "" or card.ability.extra.tax*100
                card.joker_display_values.percent = card.ability.buffed and "" or "%"
                card.joker_display_values.close_bracket = card.ability.buffed and "" or ")"
                card.joker_display_values.buffed = card.ability.buffed and localize("k_buffed") or ""
            end,
        }
    end,
}

local magic_lamp = {
    key = "magic_lamp",
    name = "Magic Lamp",
    atlas = "misc_jokers",
    saga_group = "aladdin_and_the_magic_lamp",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 1005,
    pos = { x = 3, y = 0 },
    config = {magic_lamp_rounds = 0, extra = {xmult = 3, rounds_goal = 3}},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
			}
        end
        if (context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            card.ability.magic_lamp_rounds = card.ability.magic_lamp_rounds + 1
            if (card.ability.magic_lamp_rounds >= card.ability.extra.rounds_goal) or context.forcetrigger then
                local has_aladdin = false
                for _, v in ipairs(G.jokers.cards) do
                    if (v.config.center_key == "j_sgt_aladdin") or context.forcetrigger then
                        has_aladdin = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "immediate",
                            func = function()
                                assert(SMODS.add_card({
                                    set = "Joker",
                                    skip_materialize = true,
                                    key = "j_sgt_lamp_genie",
                                    edition = card.edition and card.edition.key or nil,
                                }))
                                return true
                            end
                        }))
                        Sagatro.self_destruct(card)
                        break
                    end
                end
                if not has_aladdin then
                    return {
                        message = localize("k_huh_qm"),
                        colour = G.C.FILTER
                    }
                else
                    return {
                        message = localize("k_poof_ex"),
                        colour = G.C.FILTER
                    }
                end
            else
                return {
                    message = (card.ability.magic_lamp_rounds..'/'..card.ability.extra.rounds_goal),
                    colour = G.C.FILTER
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_aladdin"]
        info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_lamp_genie"]
        return {vars = {card.ability.extra.xmult, card.ability.magic_lamp_rounds, card.ability.extra.rounds_goal,
        localize{type = 'name_text', set = "Joker", key = "j_sgt_aladdin", nodes = {}},
        localize{type = 'name_text', set = "Joker", key = "j_sgt_lamp_genie", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = card.ability.magic_lamp_rounds >= card.ability.extra.rounds_goal and
                localize{type = 'name_text', set = "Joker", key = "j_sgt_aladdin", nodes = {}}
                or (card.ability.magic_lamp_rounds .. "/" .. card.ability.extra.rounds_goal)
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = card.ability.magic_lamp_rounds >= card.ability.extra.rounds_goal
                    and G.C.ORANGE or G.C.UI.TEXT_INACTIVE
                end
                return false
            end,
        }
    end
}

local lamp_genie = {
    key = "lamp_genie",
    name = "Lamp Genie",
    atlas = "esoteric",
    saga_group = "aladdin_and_the_magic_lamp",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 1006,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 2, y = 0, extra = { x = 1, y = 0 } },
    config = { extra = {retriggers = 2, e_mult = 3}, collected_wish = 0,
        wishlist = {
            c_sgt_prosperity = false,
            c_sgt_fertility = false,
            c_sgt_love = false,
            c_sgt_peace = false,
            c_sgt_ease = false,
            c_sgt_aestheticism = false,
            c_sgt_freedom = false,
        }
    },
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.from_wish_card = G.GAME.wish_card_spawns_genie
        if card.ability.from_wish_card then
            card.ability.init = nil
        else
            card.ability.init = not next(SMODS.find_card("j_sgt_lamp_genie", true))
        end
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker
        and card.ability.wishlist.c_sgt_love and not context.forcetrigger then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.retriggers,
                card = card,
            }
		end
        if context.setting_blind and not card.getting_sliced and context.blind.boss and not context.forcetrigger
        and not context.blueprint and not context.retrigger_joker and card.ability.wishlist.c_sgt_peace then
            G.E_MANAGER:add_event(Event({func = function()
                G.E_MANAGER:add_event(Event({func = function()
                    -- Nope, I'm not checking for G.GAME.blind.disabled
                    -- because Chicot never did in the first place
                    -- Enjoy your Lamp Genie + Chicot combo folks
                    G.GAME.blind:disable()
                    play_sound('timpani')
                    delay(0.4)
                    return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            return true end }))
        end
        if context.forcetrigger and G.GAME.blind and G.GAME.blind:get_type() == "Boss" then
            G.GAME.blind:disable()
        end
        if (context.joker_main or context.forcetrigger) and card.ability.wishlist.c_sgt_freedom then
            return {
				sgt_e_mult = card.ability.extra.e_mult,
            }
        end
        -- Aestheticism affects future playing cards as well
        if context.playing_card_added and not card.getting_sliced
        and not context.blueprint and not context.retrigger_joker
        and card.ability.wishlist.c_sgt_aestheticism then
            for _, v in ipairs(context.cards) do
                if not v.edition then
                    v:set_edition(poll_edition("future_aesthetic_edition", nil, nil, true), nil, true)
                end
            end
        end
        if context.skipping_booster and not context.blueprint and not context.retrigger_joker then
            if context.booster.key == "p_sgt_wish_primary" and card.ability.collected_wish == 2 then
                card.ability.skipped_first_pack = true
                if #SMODS.find_card("j_sgt_lamp_genie", true) > 1 then
                    local lamp_genies = SMODS.find_card("j_sgt_lamp_genie", true)
                    for i = 2, #lamp_genies do
                        lamp_genies[i].ability.skipped_first_pack = nil
                    end
                end
            end
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.loaded = nil
            if not card.ability.from_wish_card then
                if card.ability.collected_wish == 0 then
                    card.ability.init = true
                    if #SMODS.find_card("j_sgt_lamp_genie", true) > 1 then
                        local lamp_genies = SMODS.find_card("j_sgt_lamp_genie", true)
                        for i = 2, #lamp_genies do
                            lamp_genies[i].ability.init = nil
                        end
                    end
                elseif card.ability.collected_wish == 2 then
                    card.ability.skipped_first_pack = true
                    if #SMODS.find_card("j_sgt_lamp_genie", true) > 1 then
                        local lamp_genies = SMODS.find_card("j_sgt_lamp_genie", true)
                        for i = 2, #lamp_genies do
                            lamp_genies[i].ability.skipped_first_pack = nil
                        end
                    end
                end
            end
        end
        if not (card.ability.from_wish_card or G.SETTINGS.paused) then
            if G.STATE == G.STATES.BLIND_SELECT and card.ability.init then
                local paused_for_tags = false
                for i = 1, #G.GAME.tags do
                    if G.GAME.tags[i].config.type == "new_blind_choice" then
                        paused_for_tags = true
                        break
                    end
                end
                if not paused_for_tags then
                    card.ability.init = nil
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        G.CONTROLLER.locks.genie_init = true
                        G.E_MANAGER:add_event(Event({func = function()
                            local key = "p_sgt_wish_primary"
                            local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                            G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            _card.cost = 0
                            _card.from_tag = true
                            G.FUNCS.use_card({config = {ref_table = _card}})
                            _card:start_materialize()
                            G.CONTROLLER.locks.genie_init = nil
                        return true end }))
                    return true end }))
                end
            end
            if G.STATE == G.STATES.SHOP and card.ability.skipped_first_pack then
                local paused_for_tags = false
                for i = 1, #G.GAME.tags do
                    if G.GAME.tags[i].config.type == "new_blind_choice" then
                        paused_for_tags = true
                        break
                    end
                end
                if not paused_for_tags then
                    card.ability.skipped_first_pack = nil
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8, func = function()
                        G.CONTROLLER.locks.genie_second_pack = true
                        G.E_MANAGER:add_event(Event({func = function()
                            local key = "p_sgt_wish_secondary"
                            local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                            G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            _card.cost = 0
                            _card.from_tag = true
                            booster_obj = _card.config.center
                            G.FUNCS.use_card({config = {ref_table = _card}})
                            _card:start_materialize()
                            G.CONTROLLER.locks.genie_second_pack = nil
                        return true end }))
                    return true end }))
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        for k, v in pairs(card.ability.wishlist) do
            if v then info_queue[#info_queue+1] = G.P_CENTERS[k] end
        end
        local ret = {}
        if card.ability.init then
            ret.key = "j_sgt_lamp_genie_pending"
            info_queue[#info_queue+1] = G.P_CENTERS.p_sgt_wish_primary
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "pre_space" },
                { ref_table = "card.joker_display_values", ref_value = "times" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers" },
                { ref_table = "card.joker_display_values", ref_value = "space" },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "hat" },
                        { ref_table = "card.joker_display_values", ref_value = "emult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                card.joker_display_values.pre_space = card.ability.wishlist.c_sgt_love and not card.ability.wishlist.c_sgt_freedom
                and " " or ""
                card.joker_display_values.times = card.ability.wishlist.c_sgt_love
                and "x" or ""
                card.joker_display_values.retriggers = card.ability.wishlist.c_sgt_love
                and card.ability.extra.retriggers or ""
                card.joker_display_values.space = card.ability.wishlist.c_sgt_love and card.ability.wishlist.c_sgt_freedom
                and " " or ""
                card.joker_display_values.hat = card.ability.wishlist.c_sgt_freedom
                and "^" or ""
                card.joker_display_values.emult = card.ability.wishlist.c_sgt_freedom
                and card.ability.extra.e_mult or ""
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                return retrigger_joker.ability.wishlist.c_sgt_love
                and retrigger_joker.ability.extra.retriggers or 0
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[5] then
                    text.children[5].config.colour = card.ability.wishlist.c_sgt_freedom
                    and G.C.DARK_EDITION or G.C.CLEAR
                end
                return false
            end,
        }
    end
}

-- 20k miles under the sea
local lincoln_ship = {
    key = "lincoln_ship",
    name = "Lincoln Ship",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 31,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 0 },
    config = {extra = {mult = 4}},
	rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
			return {
                add_to_hand = true,
                no_retrigger = true
            }
		end
        if context.joker_main or context.forcetrigger then
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        -- does nothing for now Ig
    end,
    in_pool = function(self, args)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_splash"]
        return {vars = {card.ability.extra.mult, localize{type = 'name_text', set = "Joker", key = "j_splash", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            scoring_function = function(playing_card, scoring_hand, joker_card)
                return true
            end
        }
    end,
}

local submarine = {
    key = "submarine",
    name = "Submarine",
    atlas = "submarine",
    saga_group = "20k_miles_under_the_sea",
    order = 32,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 0 },
    extra_pos = { x = 0, y = 9 },
    config = {immutable = {depth_level = 1, old_depth_level = 1, depth_list = {0, 100, 300, 750, 1600}}, extra = {chips = 0, chip_mod = 4}},
	rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.anim_dt = 0
        card.ability.anim_pos = { x = 0, y = 0 }
        card.ability.anim_transition_path = 0
        card.ability.in_transition = false
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and not context.forcetrigger then
            if not context.other_card.debuff then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                for i = 5, 1, -1 do
                    if card.ability.extra.chips >= card.ability.immutable.depth_list[i] then
                        card.ability.immutable.depth_level = i
                        ease_background_colour_blind(G.STATE)
                        break
                    end
                end
                return {
                    extra = {focus = card, message = localize("k_submerge_ex")},
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        if (context.joker_main or context.forcetrigger) and to_big(card.ability.extra.chips) > to_big(0) then
            if context.forcetrigger then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            end
            return {
                chip_mod = card.ability.extra.chips,
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            card:set_eternal(true)
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.loaded = nil
            ease_background_colour_blind(G.STATE)
        end
        if card.ability and self.discovered then
            card.ability.anim_dt = card.ability.anim_dt + dt
            card.ability.anim_transition_path = card.ability.immutable.old_depth_level - card.ability.immutable.depth_level
            if card.ability.anim_dt > 0.125*G.SETTINGS.GAMESPEED*(Handy and Handy.speed_multiplier.value or 1) then
                card.ability.anim_dt = card.ability.anim_dt - 0.125*G.SETTINGS.GAMESPEED*(Handy and Handy.speed_multiplier.value or 1)
                if card.ability.anim_pos.x == 11 and card.ability.anim_transition_path ~= 0 and not card.ability.in_transition then
                    if card.ability.anim_transition_path > 0 then
                        card.ability.anim_pos.x = 6
                    elseif card.ability.anim_transition_path < 0 then
                        card.ability.anim_pos.x = 0
                    end
                    card.ability.in_transition = true
                elseif (card.ability.anim_pos.x == 5 and card.ability.anim_transition_path < 0 and card.ability.in_transition)
                or card.ability.anim_pos.x == 11 then
                    card.ability.anim_pos.x = 0
                    card.ability.in_transition = false
                    card.ability.immutable.old_depth_level = card.ability.immutable.depth_level
                else
                    card.ability.anim_pos.x = card.ability.anim_pos.x + 1
                end
                card.ability.anim_pos.y = (math.min(card.ability.immutable.old_depth_level, card.ability.immutable.depth_level) - 1)
                + (card.ability.in_transition and 5 or 0)
                card.children.center:set_sprite_pos(card.ability.anim_pos)
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_lincoln_ship", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.immutable.depth_level}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
                { text = ": " },
                { ref_table = "card.ability.immutable", ref_value = "depth_level", colour = G.C.BLUE },
                { text = ")" },
            },
            text_config = { colour = G.C.CHIPS },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize("ph_depth_level")
            end,
        }
    end,
}

local clownfish = {
    key = "clownfish",
    name = "Clownfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 33,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 5, y = 0 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {mult = 4}},
	rarity = 1,
    cost = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if context.other_card:is_suit("Hearts", nil, true) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        h_mult = card.ability.extra.mult,
                        card = card,
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                mult_mod = card.ability.extra.mult,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        return {vars = {card.ability.extra.mult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local count = 0
                local mult = card.ability.extra.mult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:is_suit("Hearts") then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card)
                        end
                    end
                end
                card.joker_display_values.mult = mult*count
            end,
        }
    end,
}

local blue_tang = {
    key = "blue_tang",
    name = "Blue Tang",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 34,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 6, y = 0 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {chips = 25}},
	rarity = 1,
    cost = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if context.other_card:is_suit("Spades", nil, true) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        h_chips = card.ability.extra.chips,
                        card = card,
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                chip_mod = card.ability.extra.chips,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        return {vars = {card.ability.extra.chips}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            calc_function = function(card)
                local count = 0
                local chips = card.ability.extra.chips
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:is_suit("Spades") then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.chips = chips*count
            end,
        }
    end,
}

local pufferfish = {
    key = "pufferfish",
    name = "Pufferfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 35,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {xmult = 3}},
	rarity = 2,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        local ret = {vars = {card.ability.extra.xmult}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
        }
    end,
}

local white_jellyfish = {
    key = "white_jellyfish",
    name = "White Jellyfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 36,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {every = 2, xmult = 2.25, odds = 4}},
    no_pool_flag = "white_jellyfish_pop",
	rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.loyalty_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.loyalty_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            else
                if card.ability.loyalty_remaining == 0 then
                    local eval = function(_card) return (_card.ability.loyalty_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.loyalty_remaining == card.ability.extra.every) or context.forcetrigger then
            if SMODS.pseudorandom_probability(card, "white_jellyfish_pop", 1, card.ability.extra.odds, "white_jellyfish") or context.forcetrigger then
                Sagatro.self_destruct(card, {no_destruction_context = true})
                G.GAME.pool_flags.white_jellyfish_pop = true
                return {
                    message = localize('k_pop_ex'),
                    colour = G.C.RED,
                    no_retrigger = true
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "white_jellyfish")
        return {vars = {card.ability.extra.xmult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.loyalty_remaining or card.ability.extra.every}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "loyalty_text" },
                { text = ")" },
            },
            calc_function = function(card)
                local loyalty_remaining = card.ability.loyalty_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { loyalty_remaining } }
                card.joker_display_values.x_mult = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.xmult or 1)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "white_jellyfish") } }
            end
        }
    end,
}

local red_jellyfish = {
    key = "red_jellyfish",
    name = "Red Jellyfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 37,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {every = 2, xmult = 4, odds = 32}},
    yes_pool_flag = "white_jellyfish_pop",
    no_pool_flag = "red_jellyfish_pop",
	rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.loyalty_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.loyalty_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            else
                if card.ability.loyalty_remaining == 0 then
                    local eval = function(_card) return (_card.ability.loyalty_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.loyalty_remaining == card.ability.extra.every) or context.forcetrigger then
            if SMODS.pseudorandom_probability(card, "red_jellyfish_pop", 1, card.ability.extra.odds, "red_jellyfish") or context.forcetrigger then
                Sagatro.self_destruct(card, {no_destruction_context = true})
                G.GAME.pool_flags.red_jellyfish_pop = true
                return {
                    message = localize('k_pop_ex'),
                    colour = G.C.RED,
                    no_retrigger = true
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_jellyfish")
        return {vars = {card.ability.extra.xmult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.loyalty_remaining or card.ability.extra.every}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "loyalty_text" },
                { text = ")" },
            },
            calc_function = function(card)
                local loyalty_remaining = card.ability.loyalty_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { loyalty_remaining } }
                card.joker_display_values.x_mult = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.xmult or 1)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_jellyfish") } }
            end
        }
    end,
}

local queen_jellyfish = {
    key = "queen_jellyfish",
    name = "Queen Jellyfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 38,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {every = 2, e_mult = 1.25, odds = 256}},
    yes_pool_flag = "red_jellyfish_pop",
	rarity = "sgt_obscure",
    cost = 15,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.loyalty_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.loyalty_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        sgt_e_mult = card.ability.extra.e_mult
                    }
                end
            else
                if card.ability.loyalty_remaining == 0 then
                    local eval = function(_card) return (_card.ability.loyalty_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.loyalty_remaining == card.ability.extra.every then
                    return {
                        sgt_e_mult = card.ability.extra.e_mult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.loyalty_remaining == card.ability.extra.every) or context.forcetrigger then
            if SMODS.pseudorandom_probability(card, "queen_jellyfish_pop", 1, card.ability.extra.odds, "queen_jellyfish") or context.forcetrigger then
                Sagatro.self_destruct(card, {no_destruction_context = true})
                return {
                    message = localize('k_pop_ex'),
                    colour = G.C.RED,
                    no_retrigger = true
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "queen_jellyfish")
        return {vars = {card.ability.extra.e_mult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.loyalty_remaining or card.ability.extra.every}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "loyalty_text" },
                { text = ")" },
            },
            calc_function = function(card)
                local loyalty_remaining = card.ability.loyalty_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { loyalty_remaining } }
                card.joker_display_values.e_mult = (loyalty_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.e_mult or 1)
                local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "queen_jellyfish") } }
            end
        }
    end,
}

local mandarin_fish = {
    key = "mandarin_fish",
    name = "Mandarin Fish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 39,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {money = 75}},
    no_pool_flag = "mandarin_fish_extinct",
	rarity = 3,
    cost = 7,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = false,
    add_to_deck = function(self, card, from_debuff)
        delay(0.06*G.SETTINGS.GAMESPEED)
        ease_dollars(card.ability.extra.money, true)
        delay(0.06*G.SETTINGS.GAMESPEED)
        local extinct_text = function()
            card_eval_status_text(card, 'extra', nil, 1, nil, {message = localize('k_extinct_ex'), sound = "tarot1", volume = 1, instant = true})
            G.GAME.pool_flags.mandarin_fish_extinct = true
        end
        Sagatro.self_destruct(card, {no_sound = true}, extinct_text)
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        return {vars = {card.ability.extra.money}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = localize("k_self_destruct"), colour = G.C.RED },
            },
        }
    end,
}

local barracuda = {
    key = "barracuda",
    name = "Barracuda",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 40,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 2}, extra = {mult = 0, mult_mod = 10}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode then
            card.ability.extra.mult = 10
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.forcetrigger
        and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local joker = nil
            if pos then joker = G.jokers.cards[pos+1] end
            if joker and not card.getting_sliced
            and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
            and joker.ability.immutable and joker.ability.immutable.weight_level
            and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                local eaten_fish = joker
                eaten_fish.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "mult",
                            scalar_value = "mult_mod",
                            scaling_message = {
                                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult+card.ability.extra.mult_mod}},
                                colour = G.C.RED,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    end
                    card:juice_up(0.8, 0.8)
                    eaten_fish:start_dissolve({G.C.RED}, true, 1.6)
                    play_sound('sgt_swallow', 0.96+math.random()*0.08)
                return true end }))
                if not SMODS.scale_card then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult+card.ability.extra.mult_mod}}, colour = G.C.RED, no_juice = true})
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.mult) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                end
            end
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "OceanMap", key = "sgt_tropical", title = localize("saga_ocean_tooltip")}
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
        }
    end,
}

local school = {
    key = "school",
    name = "School Of Fish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 41,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 6, y = 1 },
    config = {},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.pre_discard and not context.blueprint and not context.hook) or context.forcetrigger then
            if #G.hand.highlighted == 1 or context.forcetrigger then
                for _, v in ipairs(G.hand.cards) do
                    if not v.highlighted then
                        G.hand.highlighted[#G.hand.highlighted+1] = v
					    v:highlight(true)
                    end
                end
                play_sound('cardSlide1')
                G.FUNCS.discard_cards_from_highlighted(nil, true)
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            calc_function = function(card)
                card.joker_display_values.active = G.hand and #G.hand.highlighted == 1
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local prawn = {
    key = "prawn",
    name = "Sugpo Prawn",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 42,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 0, y = 2 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {money = 1}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and context.individual and context.cardarea == G.hand) or context.forcetrigger then
            if context.other_card:is_suit("Diamonds") or context.forcetrigger then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$" },
                { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.GOLD },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                local count = 0
                local dollars = card.ability.extra.money
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:is_suit("Diamonds") then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.dollars = dollars*count
                card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
            end,
        }
    end,
}

local john_dory = {
    key = "john_dory",
    name = "John Dory",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 43,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {money = 4}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if ((context.individual or context.repetition) and context.cardarea == G.play) or context.forcetrigger then
            if (context.other_card:is_suit("Diamonds") and context.other_card:get_id() == 11) or context.forcetrigger then
                if context.repetition then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 1,
                        card = card,
                    }
                end
                if context.individual or context.forcetrigger then
                    return {
                        dollars = card.ability.extra.money,
                        card = context.forcetrigger and card
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, localize("Jack", 'ranks'), localize("Diamonds", 'suits_plural')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$", colour = G.C.GOLD },
                { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult", colour = G.C.GOLD },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "john_dory_card", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:is_suit("Diamonds") and scoring_card:get_id() == 11 then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.money = card.ability.extra.money * count
                card.joker_display_values.john_dory_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize("Jack", 'ranks'), localize("Diamonds", 'suits_plural') } }
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return (playing_card:is_suit("Diamonds") and playing_card:get_id() == 11)
                and JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local octopus = {
    key = "octopus",
    name = "Octopus",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 44,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 3 },
    config = {immutable = {depth_level = 2, weight_level = 3}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                other_joker = G.jokers.cards[i+1]
                if i == #G.jokers.cards and G.consumeables.cards[1] then
                    if G.consumeables.cards[1].ability.set == "Joker" then
                        other_joker = G.consumeables.cards[1]
                    end
                end
            end
        end
        for i = 1, #G.consumeables.cards do
            if G.consumeables.cards[i] == card then
                if G.consumeables.cards[i+1] then
                    if G.consumeables.cards[i+1].ability.set == "Joker" then
                        other_joker = G.consumeables.cards[i+1]
                    end
                end
            end
        end
        local other_joker_ret = SMODS.blueprint_effect(card, other_joker, context)
        if other_joker_ret then
            other_joker_ret.colour = G.C.RED
        end
        return other_joker_ret
        -- simply blueprint for now
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        if card.area and (card.area == G.jokers or card.area == G.consumeables) then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other_joker = G.jokers.cards[i+1]
                    if i == #G.jokers.cards and G.consumeables.cards[1] then
                        if G.consumeables.cards[1].ability.set == "Joker" then
                            other_joker = G.consumeables.cards[1]
                        end
                    end
                end
            end
            for i = 1, #G.consumeables.cards do
            if G.consumeables.cards[i] == card then
                if G.consumeables.cards[i+1] then
                    if G.consumeables.cards[i+1].ability.set == "Joker" then
                        other_joker = G.consumeables.cards[i+1]
                    end
                end
            end
        end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
                { text = ")" }
            },
            calc_function = function(card)
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                card.joker_display_values.blueprint_compat = localize('k_incompatible')
                JokerDisplay.copy_display(card, copied_joker, copied_debuff)
            end,
            get_blueprint_joker = function(card)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        local other_joker = G.jokers.cards[i+1]
                        if i == #G.jokers.cards and G.consumeables.cards[1] then
                            if G.consumeables.cards[1].ability.set == "Joker" then
                                other_joker = G.consumeables.cards[1]
                            end
                        end
                        return other_joker
                    end
                end
                for i = 1, #G.consumeables.cards do
                    if G.consumeables.cards[i] == card then
                        if G.consumeables.cards[i+1] then
                            if G.consumeables.cards[i+1].ability.set == "Joker" then
                                return G.consumeables.cards[i+1]
                            end
                        end
                    end
                end
                return nil
            end
        }
    end,
}

local squid = {
    key = "squid",
    name = "Squid",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 45,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 3 },
    config = {immutable = {depth_level = 2, weight_level = 3}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        local other_joker_ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
        if other_joker_ret then
            other_joker_ret.colour = G.C.FILTER
        end
        return other_joker_ret
        -- simply brainstorm for now
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        if card.area and (card.area == G.jokers or card.area == G.consumeables) then
            local compatible = G.jokers.cards[1] and G.jokers.cards[1] ~= card and
                G.jokers.cards[1].config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
                { text = ")" }
            },
            calc_function = function(card)
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                card.joker_display_values.blueprint_compat = localize('k_incompatible')
                JokerDisplay.copy_display(card, copied_joker, copied_debuff)
            end,
            get_blueprint_joker = function(card)
                return G.jokers.cards[1]
            end
        }
    end,
}

local turtle_egg = {
    key = "turtle_egg",
    name = "Turtle Egg",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 46,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 1, y = 2 },
    config = {extra = {sell_value_mod = 3, odds = 15, sell_odds = 30}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, "turtle_egg_hatched", 1, card.ability.extra.odds, "turtle_egg_hatch") and not G.GAME.turtle_egg_hatched then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        assert(SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_baby_turtle",
                        }))
                        G.GAME.turtle_egg_hatched = true
                        return true
                    end
                }))
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_hatched_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability,
                        ref_value = "extra_value",
                        scalar_table = card.ability.extra,
                        scalar_value = "sell_value_mod",
                        scaling_message = {
                            message = localize('k_val_up'),
                            colour = G.C.MONEY
                        }
                    })
                    card:set_cost()
                else
                    card.ability.extra_value = card.ability.extra_value + card.ability.extra.sell_value_mod
                    card:set_cost()
                    return {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
                end
            end
        end
        if (context.selling_self and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if (SMODS.pseudorandom_probability(card, "sold_turtle_egg_hatched", 1, card.ability.extra.sell_odds, "turtle_egg_sell_hatch")
            and not G.GAME.turtle_egg_hatched) or context.forcetrigger then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_hatched_ex'), instant = true})
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        assert(SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_baby_turtle",
                        }))
                        G.GAME.turtle_egg_hatched = true
                        return true
                    end
                }))
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), instant = true})
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_baby_turtle"]
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "turtle_egg_hatch")
        return {vars = {card.ability.extra.sell_value_mod, localize{type = 'name_text', set = "Joker", key = "j_sgt_baby_turtle", nodes = {}},
        n, d, SMODS.get_probability_vars(card, 1, card.ability.extra.sell_odds, "turtle_egg_sell_hatch")}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
            reminder_text = {
                { text = "(" },
                { text = "$", colour = G.C.GOLD },
                { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
                { text = ")" },
            },
            reminder_text_config = { scale = 0.35 },
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "turtle_egg") } }
            end,
        }
    end
}

local baby_turtle = {
    key = "baby_turtle",
    name = "Baby Turtle",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 47,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 2 },
    config = {extra = {xmult = 2}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local first_found = nil
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 3
                or context.scoring_hand[i]:get_id() == 7
                or context.scoring_hand[i]:get_id() == 9 then
                    first_found = context.scoring_hand[i]
                    break
                end
            end
            if context.other_card == first_found then
                return {
                    x_mult = card.ability.extra.xmult,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.selling_self and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            G.GAME.pool_flags.mature_turtle = true
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, localize{type = 'name_text', set = "Joker", key = "j_sgt_green_turtle", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(3, 7, 9)" },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local target_cards = {}
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() == 3
                        or scoring_card:get_id() == 7
                        or scoring_card:get_id() == 9 then
                            table.insert(target_cards, scoring_card)
                        end
                    end
                end
                local first_found = JokerDisplay.calculate_leftmost_card(target_cards)
                card.joker_display_values.xmult = first_found and
                    (card.ability.extra.xmult ^ JokerDisplay.calculate_card_triggers(first_found, scoring_hand)) or 1
            end
        }
    end,
}

local green_turtle = {
    key = "green_turtle",
    name = "Green Turtle",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 48,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 2 },
    config = {immutable = {depth_level = 2, weight_level = 3}, extra = {xmult = 1.5}},
    yes_pool_flag = "mature_turtle",
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 3
            or context.other_card:get_id() == 7
            or context.other_card:get_id() == 9 then
                return {
                    x_mult = card.ability.extra.xmult,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(3, 7, 9)" },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() == 3
                        or scoring_card:get_id() == 7
                        or scoring_card:get_id() == 9 then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.xmult = card.ability.extra.xmult ^ count
            end,
        }
    end
}

local electric_eel = {
    key = "electric_eel",
    name = "Electric Eel",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 49,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 2 },
    config = {immutable = {depth_level = 4, weight_level = 3}, extra = {}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.play then
                for i, v in ipairs(G.play.cards) do
                    if context.other_card == v then
                        local count = 0
                        if Sagatro.conductive_enhancement(G.play.cards[i-1]) then
                            count = count + 1
                        end
                        if Sagatro.conductive_enhancement(G.play.cards[i+1]) then
                            count = count + 1
                        end
                        if count > 0 then
                            return {
                                message = localize("k_again_ex"),
                                repetitions = count,
                                card = card,
                            }
                        end
                    end
                end
            end
            if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                for i, v in ipairs(G.hand.cards) do
                    if context.other_card == v then
                        local count = 0
                        if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                            count = count + 1
                        end
                        if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                            count = count + 1
                        end
                        if count > 0 then
                            return {
                                message = localize("k_again_ex"),
                                repetitions = count,
                                card = card,
                            }
                        end
                    end
                end
            end
        end
        if context.end_of_round and context.repetition
        and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            for i, v in ipairs(G.hand.cards) do
                if context.other_card == v then
                    local count = 0
                    if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                        count = count + 1
                    end
                    if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                        count = count + 1
                    end
                    if count > 0 then
                        return {
                            message = localize("k_again_ex"),
                            repetitions = count,
                            card = card,
                        }
                    end
                end
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.electric_eel_info_queue_append(info_queue, Sagatro.electric_eel_info_queue)
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then
                    local count = 0
                    for i, v in ipairs(G.hand.cards) do
                        if playing_card == v then
                            if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                                count = count + 1
                            end
                            if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                                count = count + 1
                            end
                        end
                    end
                    return count*JokerDisplay.calculate_joker_triggers(joker_card)
                else
                    local count = 0
                    if scoring_hand then
                        for i, v in ipairs(G.play.cards) do
                            if playing_card == v then
                                if Sagatro.conductive_enhancement(G.play.cards[i-1]) and table.contains(scoring_hand, v) then
                                    count = count + 1
                                end
                                if Sagatro.conductive_enhancement(G.play.cards[i+1]) and table.contains(scoring_hand, v) then
                                    count = count + 1
                                end
                            end
                        end
                    end
                    return count*JokerDisplay.calculate_joker_triggers(joker_card)
                end
            end,
        }
    end,
}

local sea_angel = {
    key = "sea_angel",
    name = "Sea Angel",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 50,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 4 },
    config = {type = "Three of a Kind", immutable = {depth_level = 5, weight_level = 1}, extra = {e_mult = 1.23}},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and next(context.poker_hands[card.ability.type])) or context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult, localize(card.ability.type, 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.is_3oak = false
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    card.joker_display_values.is_3oak = true
                end
                card.joker_display_values.e_mult = card.joker_display_values.is_3oak and card.ability.extra.e_mult or 1
            end,
        }
    end,
}

local stonefish = {
    key = "stonefish",
    name = "Stonefish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 51,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 1}},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local faces = {}
            for _, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    faces[#faces+1] = v
                    v:set_ability(G.P_CENTERS.m_stone, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
            if #faces > 0 then
                return {
                    message = localize('k_petrified_ex'),
                    colour = G.C.FILTER,
                    card = card,
                }
            end
        end
        if context.forcetrigger then
            if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_face() then
						v:set_ability(G.P_CENTERS.m_stone, nil, true)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.4,
							func = function()
								v:juice_up()
								return true
							end,
						}))
					end
				end
			elseif G and G.hand and #G.hand.highlighted > 0 then
				for k, v in ipairs(G.hand.highlighted) do
					if v:is_face() then
						v:set_ability(G.P_CENTERS.m_stone, nil, true)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.4,
							func = function()
								v:juice_up()
								return true
							end,
						}))
					end
				end
			end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local blobfish = {
    key = "blobfish",
    name = "Blobfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 52,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 5, y = 2 },
    config = {immutable = {depth_level = 5, weight_level = 2}, extra = {mult = 0, mult_mod = 3}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + scaling*G.GAME.current_round.discards_left
                    end,
                    scaling_message = {
                        message = localize('k_blob_ex'),
                        colour = G.C.FILTER,
                    }
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod*G.GAME.current_round.discards_left
                return {
                    message = localize('k_blob_ex'),
                    colour = G.C.FILTER,
                }
            end
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + scaling*G.GAME.current_round.discards_left
                    end,
                    no_message = true
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod*G.GAME.current_round.discards_left
            end
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
        }
    end,
}

local ugly_blobfish = {
    key = "ugly_blobfish",
    name = "Ugly Blobfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 53,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 2 },
    config = {extra = {xmult = 5}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            for _, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    return {
                        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local triggered = false
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:is_face() then
                            triggered = true
                        end
                    end
                end
                card.joker_display_values.xmult = triggered and card.ability.extra.xmult or 1
            end,
        }
    end,
}

local coral_kingdom = {
    key = "coral_kingdom",
    name = "Coral Kingdom",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 54,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 4 },
    config = {extra = {joker_count = 2, chips = 0, chip_mod = 15}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced
        and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(card.ability.extra.joker_count, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = 1, jokers_to_create do
                        assert(SMODS.add_card({
                            set = 'Common Fish',
                            area = G.jokers,
                        }))
                        G.GAME.joker_buffer = 0
                    end
                return true
            end}))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
        if context.discard and not context.blueprint then
            if not context.other_card.debuff and SMODS.has_no_rank(context.other_card) then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chip_mod",
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS,
                            card = card,
                        }
                    })
                else
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        card = card,
                    }
                end
            end
        end
        if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
            return {
				chip_mod = card.ability.extra.chips,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
        end
        if context.forcetrigger then
            local jokers_to_create = math.min(card.ability.extra.joker_count, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = 1, jokers_to_create do
                        local card = SMODS.create_card{
                            set = 'Common Fish',
                            area = G.jokers,
                            rarity = 0,
                        }
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                return true
            end}))
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                    no_message = true
                })
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            end
            return {
				chip_mod = card.ability.extra.chips,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.joker_count, card.ability.extra.chips, card.ability.extra.chip_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
        }
    end,
}

local dolphin = {
    key = "dolphin",
    name = "Dolphin",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 55,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 3 },
    config = {immutable = {depth_level = 3, weight_level = 3}, extra = {xmult = 1, xmult_mod = 0.25--[[temporary value]]}},
    rarity = 2,
    cost = 6--[[temporary value]],
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card.lucky_trigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.MULT
                        }
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                end
            end
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                card.joker_display_values.xmult = card.ability.extra.xmult -- More on this later
            end
        }
    end,
}

local coelacanthiformes = {
    key = "coelacanthiformes",
    name = "Coelacanthiformes",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 56,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 3 },
    config = {immutable = {depth_level = 3, weight_level = 3}, extra = {}},
    rarity = 3,
    cost = 7,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if (context.discard and not context.blueprint) or context.forcetrigger then
            if ((G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 and context.other_card:get_id() == 4)
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) or context.forcetrigger then
                if not context.forcetrigger then G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1 end
                return {
                    extra = {focus = card, message = localize('k_prevented_ex'), instant = true, func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                assert(SMODS.add_card({
                                    set = "Tarot",
                                    key = "c_death",
                                }))
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                    end},
                    colour = G.C.SECONDARY_SET.Tarot,
                    remove = not context.forcetrigger,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_death
        return {vars = {localize{type = 'name_text', set = "Tarot", key = "c_death", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "death_count", colour = G.C.GOLD, retrigger_type = "mult" },
            },
            calc_function = function(card)
                local is_discarding_one_card = #G.hand.highlighted == 1
                local is_four = G.hand.highlighted[1] and G.hand.highlighted[1]:get_id() == 4
                card.joker_display_values.active = G.GAME and G.GAME.current_round.discards_used == 0
                and G.GAME.current_round.discards_left > 0
                card.joker_display_values.death_count = card.joker_display_values.active
                and is_discarding_one_card and ("+" .. (is_four and 1 or 0)) or "-"
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    text.children[1].config.colour = card.joker_display_values.active and #G.hand.highlighted == 1
                    and G.C.SECONDARY_SET.Tarot or G.C.UI.TEXT_INACTIVE
                end
                return false
            end
        }
    end
}

local sunfish = {
    key = "sunfish",
    name = "Sunfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 57,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 4}, extra = {}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local moonfish = {
    key = "moonfish",
    name = "Moonfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 58,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 3}, extra = {}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local swordfish = {
    key = "swordfish",
    name = "Swordfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 59,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 3}, extra = {chips = 0, chip_mod = 24, chip_mod_mod = 3}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and next(context.poker_hands['Straight']) then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                    scaling_message = {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                    }
                })
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                }
            end
        end
        if (context.joker_main and to_big(card.ability.extra.chips) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chip_mod",
                        scalar_value = "chip_mod_mod",
                        no_message = true
                    })
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chip_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.chip_mod = card.ability.extra.chip_mod + card.ability.extra.chip_mod_mod
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                end
            end
            return {
                chip_mod = card.ability.extra.chips,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chip_mod",
                    scalar_value = "chip_mod_mod",
                    scaling_message = {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                    }
                })
            else
                card.ability.extra.chip_mod = card.ability.extra.chip_mod + card.ability.extra.chip_mod_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.chip_mod_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
        }
    end,
}

local penguin = {
    key = "penguin",
    name = "Penguin",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 60,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 2}, extra = {times = 2}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 end
                juice_card_until(card, eval, true)
            end
        end
        if context.repetition and context.cardarea == G.play then
            if G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.times,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local seal = {
    key = "seal",
    name = "Seal",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 61,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 3}, type = "Flush"},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.poker_hands and next(context.poker_hands[card.ability.type]) then
            if context.destroy_card and context.cardarea == G.play then
                if context.destroy_card == context.scoring_hand[1]
                or context.destroy_card == context.scoring_hand[#context.scoring_hand] then
                    return {remove = true}
                end
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.type, 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize(card.ability.type, 'poker_hands')
            end
        }
    end,
}

local ray = {
    key = "ray",
    name = "Ray",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 62,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 5 },
    config = {immutable = {depth_level = 2, weight_level = 3}, extra = {mult = 0, base_mult = 11}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local temp_Mult, temp_ID = 0, 0
            for _, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    local last_mult = card.ability.extra.mult
                    card.ability.extra.mult = 0
                    if last_mult > 0 then
                        return {
                            message = localize("k_reset"),
                            card = card,
                        }
                    else return end
                elseif temp_ID <= v.base.id and not SMODS.has_no_rank(v) then
                    temp_Mult = v.base.nominal
                    temp_ID = v.base.id
                end
            end
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "base_mult",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + math.max(scaling - temp_Mult, 0)
                    end,
                    no_message = true
                })
            else
                card.ability.extra.mult = card.ability.extra.mult + math.max(card.ability.extra.base_mult - temp_Mult, 0)
            end
        end
        if (context.joker_main and to_big(card.ability.extra.mult) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "base_mult",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial + scaling - 2
                        end,
                        no_message = true
                    })
                else
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.base_mult - 2
                end
            end
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.base_mult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
        }
    end,
}

local orca = {
    key = "orca",
    name = "Orca",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 63,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 5 },
    config = {immutable = {depth_level = 3, weight_level = 4}, extra = {xmult = 1, found_add = 0.3, unfound_sub = 0.15, target_rank = "Ace", target_id = 14}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        local valid_cards = {}
        for _, v in ipairs(G.playing_cards or {}) do
            if not SMODS.has_no_rank(v) then
                valid_cards[#valid_cards+1] = v
            end
        end
        if valid_cards[1] and not G.SETTINGS.paused then
            local target = pseudorandom_element(valid_cards, pseudoseed('orca'))
            card.ability.extra.target_rank = target.base.value
            card.ability.extra.target_id = target.base.id
        end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local found = false
            for _, v in ipairs(context.full_hand) do
                if v:get_id() == card.ability.extra.target_id then
                    found = true
                end
            end
            if found then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "found_add",
                        scaling_message = {
                            message = localize("k_happy_ex"),
                            colour = G.C.FILTER,
                            card = card
                        }
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.found_add
                    return {
                        message = localize("k_happy_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                end
            else
                local prev_mult = card.ability.extra.xmult
                if prev_mult ~= 1 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "xmult",
                            scalar_value = "unfound_sub",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = math.max(initial - scaling, 1)
                            end,
                            scaling_message = {
                                message = localize("k_upset_ex"),
                                colour = G.C.FILTER,
                                card = card
                            }
                        })
                    else
                        card.ability.extra.xmult = math.max(card.ability.extra.xmult - card.ability.extra.unfound_sub, 1)
                        return {
                            message = localize("k_upset_ex"),
                            colour = G.C.FILTER,
                            card = card
                        }
                    end
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "found_add",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.found_add
                end
            end
            return {
				message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            local valid_cards = {}
            for _, v in ipairs(G.playing_cards or {}) do
                if not SMODS.has_no_rank(v) then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if valid_cards[1] then
                local target = pseudorandom_element(valid_cards, pseudoseed('orca'))
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.extra.target_rank = target.base.value
                    card.ability.extra.target_id = target.base.id
                return true end}))
                return {
                    message = localize(card.ability.extra.target_rank, "ranks")
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.found_add, card.ability.extra.unfound_sub, localize(card.ability.extra.target_rank, "ranks")}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize(card.ability.extra.target_rank, "ranks")
            end,
        }
    end,
}

local sperm_whale = {
    key = "sperm_whale",
    name = "Sperm Whale",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 64,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 5 },
    config = {immutable = {depth_level = 4, weight_level = 5}, extra = {xmult = 1, add_per_wl = 1, sub_per_hand = 0.2}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode then
            card.ability.extra.xmult = 3
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local eaten_fish = {}
            local total_addition = 0
            for i = 1, pos-1 do
                local joker = G.jokers.cards[i]
                if joker and not card.getting_sliced
                and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
                and joker.ability.immutable and joker.ability.immutable.weight_level
                and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                    eaten_fish[#eaten_fish+1] = joker
                    total_addition = total_addition + joker.ability.immutable.weight_level
                end
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer - #eaten_fish
            for _, fish in ipairs(eaten_fish) do
                fish.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                if #eaten_fish > 0 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "xmult",
                            scalar_value = "add_per_wl",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*total_addition
                            end,
                            scaling_message = {
                                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult + card.ability.extra.add_per_wl*total_addition}},
                                colour = G.C.RED,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.add_per_wl*total_addition
                    end
                    card:juice_up(0.8, 0.8)
                    for _, fish in ipairs(eaten_fish) do
                        fish:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_swallow', 0.96+math.random()*0.08)
                end
            return true end }))
            if not SMODS.scale_card then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult + card.ability.extra.add_per_wl*total_addition}}, colour = G.C.RED, no_juice = true})
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "add_per_wl",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.add_per_wl
                end
            end
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            local hungry = to_big(card.ability.extra.xmult - card.ability.extra.sub_per_hand) < to_big(1)
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "sub_per_hand",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = math.max(initial - scaling, 1)
                    end,
                    scaling_message = {
                        message = hungry and localize("k_hungry_ex") or localize("k_digest_ex"),
                        colour = G.C.RED,
                        card = card,
                    }
                })
            else
                card.ability.extra.xmult = math.max(card.ability.extra.xmult - card.ability.extra.sub_per_hand, 1)
                return {
                    message = hungry and localize("k_hungry_ex") or localize("k_digest_ex"),
                    colour = G.C.RED,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.add_per_wl, card.ability.extra.sub_per_hand}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
        }
    end,
}

local sea_urchin = {
    key = "sea_urchin",
    name = "Sea Urchin",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 65,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {odds = 15}},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced
        and not context.blueprint and not context.retrigger_joker and context.blind.boss then
            if SMODS.pseudorandom_probability(card, 'urchin_bomb', 1, card.ability.extra.odds, "sea_urchin") then
                G.E_MANAGER:add_event(Event({func = function()
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.blind:disable()
                        play_sound('timpani')
                        delay(0.4)
                        return true end }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                return true end }))
            else
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return {
                    message = localize("k_nope_ex")
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "sea_urchin")}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "sea_urchin") } }
            end,
        }
    end,
}

local starfish = {
    key = "starfish",
    name = "Starfish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 66,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {chips = 15}},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    update = function(self, card, dt)
        card.ability.five_tally = 0
        for _, v in ipairs(G.playing_cards or {}) do
            if v:get_id() == 5 then
                card.ability.five_tally = card.ability.five_tally + 1
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.joker_main or context.forcetrigger) and card.ability.five_tally > 0 then
            return {
                chip_mod = card.ability.extra.chips*card.ability.five_tally,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*card.ability.five_tally}}
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips*(card.ability.five_tally or 0), card.ability.extra.chips}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
            calc_function = function(card)
                card.joker_display_values.chips = card.ability.extra.chips*(card.ability.five_tally or 0)
            end,
        }
    end,
}

local shark = {
    key = "shark",
    name = "Shark",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 67,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 4}, extra = {chips = 0, eat_add = 25, eor_sub = 25}},
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode then
            card.ability.extra.chips = 125
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local eaten_fish = {}
            local total_addition = 0
            for i = pos-2, pos-1 do
                local joker = G.jokers.cards[i]
                if joker and not card.getting_sliced
                and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
                and joker.ability.immutable and joker.ability.immutable.weight_level
                and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                    eaten_fish[#eaten_fish+1] = joker
                    total_addition = total_addition + joker.ability.immutable.weight_level
                end
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer - #eaten_fish
            for _, fish in ipairs(eaten_fish) do
                fish.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                if #eaten_fish > 0 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_value = "eat_add",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*total_addition
                            end,
                            scaling_message = {
                                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips + card.ability.extra.eat_add*total_addition}},
                                colour = G.C.BLUE,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.eat_add*total_addition
                    end
                    card:juice_up(0.8, 0.8)
                    for _, fish in ipairs(eaten_fish) do
                        fish:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_swallow', 0.96+math.random()*0.08)
                end
            return true end }))
            if not SMODS.scale_card then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips + card.ability.extra.eat_add*total_addition}}, colour = G.C.BLUE, no_juice = true})
            end
        end
        if (context.joker_main and to_big(card.ability.extra.chips) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "eat_add",
                        no_message = true
                    })
                else
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.eat_add
                end
            end
            return {
				chip_mod = card.ability.extra.chips,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "eor_sub",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = math.max(initial - scaling, 0)
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.eor_sub}},
                        colour = G.C.BLUE,
                    }
                })
            else
                card.ability.extra.chips = math.max(card.ability.extra.chips - card.ability.extra.eor_sub, 0)
                return {
                    message = localize{type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.eor_sub}},
                    colour = G.C.BLUE,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.eat_add, card.ability.extra.eor_sub}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.CHIPS },
        }
    end,
}

local lantern_fish = {
    key = "lantern_fish",
    name = "Lantern Fish",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 67,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 5 },
    config = {immutable = {depth_level = 4, weight_level = 1}, extra = {rarity_mod = 3}},
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.rare_mod = G.GAME.rare_mod * card.ability.extra.rarity_mod
        G.GAME.sgt_obscure_mod = G.GAME.sgt_obscure_mod * card.ability.extra.rarity_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.rare_mod = G.GAME.rare_mod / card.ability.extra.rarity_mod
        G.GAME.sgt_obscure_mod = G.GAME.sgt_obscure_mod / card.ability.extra.rarity_mod
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rarity_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local nautilus = {
    key = "nautilus",
    name = "Nautilus",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 68,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 6 },
    config = {immutable = {depth_level = 3, weight_level = 1}, extra = {rank_ids = {14, 2, 3, 5, 8, 13}, count = 0}},
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.count = 0
            for _, v in ipairs(context.scoring_hand) do
                if table.contains(card.ability.extra.rank_ids, v:get_id()) then
                    card.ability.extra.count = card.ability.extra.count + 1
                end
            end
        end
        if context.repetition and context.cardarea == G.play and card.ability.extra.count > 0 then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.count,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers", retrigger_type = "mult" },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_ace" },
                { text = ", 2, 3, 5, 8, " },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_king" },
                { text = ")" },
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards) or next(G.hand.highlighted)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if table.contains(card.ability.extra.rank_ids, scoring_card:get_id()) then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.retriggers = count
                card.joker_display_values.localized_text_ace = localize("Ace", "ranks")
                card.joker_display_values.localized_text_king = localize("King", "ranks")
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return table.contains(joker_card.ability.extra.rank_ids, playing_card:get_id())
                and joker_card.joker_display_values.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local stomiidae = {
    key = "stomiidae",
    name = "Stomiidae",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 69,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 6 },
    config = {immutable = {depth_level = 5, weight_level = 1}, extra = {xmult = 1, spade_add = 0.5, eor_sub = 1}},
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local count = 0
            for _, v in ipairs(context.scoring_hand) do
                if v:is_suit("Spades") then
                    count = count + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
            if count > 0 then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "spade_add",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial + scaling*count
                        end,
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.RED,
                            card = card,
                        }
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.spade_add*count
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED,
                        card = card,
                    }
                end
            end
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if not context.other_card.debuff then
                local temp = context.other_card
                if not SMODS.has_no_rank(temp) and temp:get_id() ~= 2 and temp:is_suit("Spades") then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.modify_rank(temp, -1))
                            return true
                        end
                    }))
                end
            end
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if not context.destroy_card.debuff then
                local temp = context.destroy_card
                if not SMODS.has_no_rank(temp) and temp:get_id() <= 2 and temp:is_suit("Spades") then
                    return {remove = true}
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "spade_add",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.spade_add
                end
            end
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local hungry = to_big(card.ability.extra.xmult - card.ability.extra.eor_sub) < to_big(1)
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "eor_sub",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = math.max(initial - scaling, 1)
                    end,
                    scaling_message = {
                        message = hungry and localize("k_hungry_ex") or localize("k_digest_ex"),
                        colour = G.C.RED,
                        card = card,
                    }
                })
            else
                card.ability.extra.xmult = math.max(card.ability.extra.xmult - card.ability.extra.eor_sub, 1)
                return {
                    message = hungry and localize("k_hungry_ex") or localize("k_digest_ex"),
                    colour = G.C.RED,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.spade_add, card.ability.extra.eor_sub}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "stomiidae_suit", colour = lighten(loc_colour("spades"), 0.35) },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.stomiidae_suit = localize("Spades", 'suits_singular')
            end
        }
    end,
}

local hermit_crab = {
    key = "hermit_crab",
    name = "Hermit Crab",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 70,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 6 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {mult = 16}, type = "Full House"},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and next(context.poker_hands[card.ability.type])) or context.forcetrigger then
            return {
                mult_mod = card.ability.extra.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, localize(card.ability.type, 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local mult = 0
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    mult = card.ability.extra.mult
                end
                card.joker_display_values.mult = mult
                card.joker_display_values.localized_text = localize(card.ability.type, 'poker_hands')
            end
        }
    end,
}

local king_crab = {
    key = "king_crab",
    name = "King Crab",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 71,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 6 },
    config = {immutable = {depth_level = 2, weight_level = 2}, fixed_type = "Two Pair"},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.fixed_type) or context.forcetrigger then
            local _card = context.scoring_hand[1]
            if not SMODS.has_no_rank(_card) and _card:get_id() ~= 13 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:juice_up()
                        assert(SMODS.change_base(_card, nil, "King"))
                        return true
                    end
                }))
            end
            return {
                message = localize("King", "ranks"),
                colour = G.C.RED,
                no_retrigger = true
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.fixed_type, 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize(card.ability.fixed_type, 'poker_hands')
            end
        }
    end,
}

local big_red_jelly = {
    key = "big_red_jelly",
    name = "Big Red Jelly",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 72,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 6 },
    config = {immutable = {depth_level = 4, weight_level = 3}, extra = {xmult = 1, xmult_mod = 0.1}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Hearts") then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        scaling_message = {
                            focus = card,
                            message = localize('k_upgrade_ex'),
                            colour = G.C.RED,
                        }
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                    return {
                        focus = card,
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED,
                    }
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                end
            end
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
        }
    end,
}

local narwhal = {
    key = "narwhal",
    name = "Narwhal",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 73,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 6 },
    config = {immutable = {depth_level = 4, weight_level = 4}, extra = {xmult = 1, xmult_mod = 0.2}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local impaled_jokers = {}
            local total_sell_cost = 0
            for i = pos-1, 1, -1 do
                local joker = G.jokers.cards[i]
                if joker and not card.getting_sliced and not joker.getting_sliced then
                    if not SMODS.is_eternal(joker, card) then
                        impaled_jokers[#impaled_jokers+1] = joker
                        total_sell_cost = total_sell_cost + joker.sell_cost
                    else break end
                end
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer - #impaled_jokers
            for _, impaled_joker in ipairs(impaled_jokers) do
                impaled_joker.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                if #impaled_jokers > 0 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "xmult",
                            scalar_value = "xmult_mod",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*total_sell_cost
                            end,
                            scaling_message = {
                                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult + card.ability.extra.xmult_mod*total_sell_cost}},
                                colour = G.C.RED,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod*total_sell_cost
                    end
                    card:juice_up(0.8, 0.8)
                    for _, impaled_joker in ipairs(impaled_jokers) do
                        impaled_joker:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_narwhal_impale', 0.96+math.random()*0.08)
                end
            return true end }))
            if not SMODS.scale_card then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult + card.ability.extra.xmult_mod*total_sell_cost}}, colour = G.C.RED, no_juice = true})
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                end
            end
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
        }
    end,
}

local seahorse = {
    key = "seahorse",
    name = "Seahorse",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 74,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 6 },
    config = {immutable = {depth_level = 1, weight_level = 1}, extra = {odds = 3}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) or context.forcetrigger then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or context.forcetrigger then
                if ((context.other_card:get_id() == 8) and (SMODS.pseudorandom_probability(card, 'seahorse', 1, card.ability.extra.odds)))
                or context.forcetrigger then
                    if not context.forcetrigger then G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1 end
                    return {
                        extra = {focus = card, message = localize{type = 'name_text', set = "Tarot", key = "c_strength", nodes = {}},
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        assert(SMODS.add_card({
                                            set = "Tarot",
                                            key = "c_strength",
                                        }))
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                        end},
                        colour = G.C.SECONDARY_SET.Tarot,
                        card = card
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_strength
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "seahorse")
        return {vars = {n, d, localize{type = 'name_text', set = "Tarot", key = "c_strength", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.SECONDARY_SET.Tarot },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() and scoring_card:get_id() == 8 then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.count = count
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "seahorse")
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            end
        }
    end,
}

local goblin_shark = {
    key = "goblin_shark",
    name = "Goblin Shark",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 75,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3}, extra = {dollars = 0, dollar_mod = 5, sub_per_hand = 1}},
    rarity = 3,
    cost = 9,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode then
            card.ability.extra.dollars = 15
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local eaten_fish = {}
            local total_addition = 0
            for i = pos-2, pos-1 do
                local joker = G.jokers.cards[i]
                if joker and not card.getting_sliced
                and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
                and joker.ability.immutable and joker.ability.immutable.weight_level
                and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                    eaten_fish[#eaten_fish+1] = joker
                    total_addition = total_addition + joker.ability.immutable.weight_level
                end
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer - #eaten_fish
            for _, fish in ipairs(eaten_fish) do
                fish.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                if #eaten_fish > 0 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "dollars",
                            scalar_value = "dollar_mod",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*total_addition
                            end,
                            scaling_message = {
                                message = localize("$")..(card.ability.extra.dollars + card.ability.extra.dollar_mod*total_addition),
                                colour = G.C.GOLD,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollar_mod*total_addition
                    end
                    card:juice_up(0.8, 0.8)
                    for _, fish in ipairs(eaten_fish) do
                        fish:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_swallow', 0.96+math.random()*0.08)
                end
            return true end }))
            if not SMODS.scale_card then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("$")..(card.ability.extra.dollars + card.ability.extra.dollar_mod*total_addition), colour = G.C.GOLD, no_juice = true})
            end
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "dollars",
                    scalar_value = "dollar_mod",
                    no_message = true
                })
            else
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollar_mod
            end
            ease_dollars(card.ability.extra.dollars)
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "dollars",
                    scalar_value = "sub_per_hand",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = math.max(initial - scaling, 0)
                    end,
                    scaling_message = {
                        message = "-"..localize("$")..card.ability.extra.sub_per_hand,
                        colour = G.C.GOLD,
                    }
                })
            else
                card.ability.extra.dollars = math.max(card.ability.extra.dollars - card.ability.extra.sub_per_hand, 0)
                return {
                    message = "-"..localize("$")..card.ability.extra.sub_per_hand,
                    colour = G.C.GOLD,
                }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.dollars > 0 then
            return card.ability.extra.dollars
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.dollar_mod, card.ability.extra.sub_per_hand}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$" },
                { ref_table = "card.ability.extra", ref_value = "dollars" },
            },
            text_config = { colour = G.C.GOLD },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
            end
        }
    end,
}

local colossal_squid = {
    key = "colossal_squid",
    name = "Colossal Squid",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 76,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3}, extra = {target_ids = {10, 11, 12, 13, 14}}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition and table.contains(card.ability.extra.target_ids, context.other_card:get_id()) then
            if context.cardarea == G.play then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 1,
                    card = card,
                }
            end
            if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 1,
                    card = card,
                }
            end
        end
        if context.end_of_round and context.repetition and table.contains(card.ability.extra.target_ids, context.other_card:get_id())
        and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                message = localize("k_again_ex"),
                repetitions = 1,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize("k_face_cards"), localize("Ace", "ranks")}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(10, " },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_face_cards" },
                { text = ", " },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_ace" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text_face_cards = localize("k_face_cards")
                card.joker_display_values.localized_text_ace = localize("Ace", "ranks")
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                return table.contains(joker_card.ability.extra.target_ids, playing_card:get_id())
                and JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local chimaera = {
    key = "chimaera",
    name = "Chimaera",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 77,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3}, extra = {spectral_count = 0, spectral_mod = 1, spectral_sub = 1}},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[#G.jokers.cards] == card then return end
            local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    pos = i
                    break
                end
            end
            local killed_jokers = {}
            for i = pos+1, pos+2 do
                local joker = G.jokers.cards[i]
                if joker and not card.getting_sliced and not joker.getting_sliced then
                    if not SMODS.is_eternal(joker, card) then
                        killed_jokers[#killed_jokers+1] = joker
                    else break end
                end
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer - #killed_jokers
            for _, killed_joker in ipairs(killed_jokers) do
                killed_joker.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                if #killed_jokers > 0 then
                    if SMODS.scale_card then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "spectral_count",
                            scalar_value = "spectral_mod",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + scaling*#killed_jokers
                            end,
                            scaling_message = {
                                message = localize("k_killed_ex"),
                                G.C.SECONDARY_SET.Spectral,
                                no_juice = true
                            }
                        })
                    else
                        card.ability.extra.spectral_count = card.ability.extra.spectral_count + card.ability.extra.spectral_mod*#killed_jokers
                    end
                    card:juice_up(0.8, 0.8)
                    for _, killed_joker in ipairs(killed_jokers) do
                        killed_joker:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_narwhal_impale', 0.96+math.random()*0.08)
                end
            return true end }))
            if not SMODS.scale_card then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_killed_ex"), colour = G.C.SECONDARY_SET.Spectral, no_juice = true})
            end
        end
        if (context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) or context.forcetrigger then
            local count = 0
            for _ = 1, card.ability.extra.spectral_count do
                if #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit then break end
                count = count + 1
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            end
            if context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "spectral_count",
                        scalar_value = "spectral_mod",
                        no_message = true
                    })
                else
                    card.ability.extra.spectral_count = card.ability.extra.spectral_count + card.ability.extra.spectral_mod
                end
                count = card.ability.extra.spectral_count
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    for _ = 1, count do
                        assert(SMODS.add_card({
                            set = "Spectral",
                            key_append = "chimaera",
                        }))
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            SMODS.calculate_effect({message = localize{type='variable', key='sgt_plus_spectrals', vars={count}}, colour = G.C.SECONDARY_SET.Spectral}, card)
            if not context.forcetrigger then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "spectral_count",
                        scalar_value = "spectral_sub",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = math.max(initial - scaling, 0)
                        end,
                        no_message = true
                    })
                else
                    card.ability.extra.spectral_count = math.max(card.ability.extra.spectral_count - card.ability.extra.spectral_sub, 0)
                end
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.spectral_count, card.ability.extra.spectral_mod, card.ability.extra.spectral_sub}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "spectral_count" },
            },
            text_config = { colour = G.C.SECONDARY_SET.Spectral },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
            end
        }
    end,
}

local dumbo_octopus = {
    key = "dumbo_octopus",
    name = "Dombo Octopus",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 78,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1}, extra = {retriggers = 8}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 8 and context.other_card:is_suit("Diamonds") then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 1,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers, localize("8", "ranks"), localize("Diamonds", 'suits_plural')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.ability.extra", ref_value = "retriggers", retrigger_type = "mult" },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "dumbo_octopus_card", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.dumbo_octopus_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize("8", "ranks"), localize("Diamonds", 'suits_plural') } }
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return (playing_card:is_suit("Diamonds") and playing_card:get_id() == 8)
                and joker_card.ability.extra.retriggers*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local atolla_wyvillei = {
    key = "atolla_wyvillei",
    name = "Atolla wyvillei",
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 79,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1}, extra = {rarity_mod = 5, xmult = 20, xmult_sub = 1}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_sub",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = math.max(initial - scaling*#context.full_hand, 1)
                    end,
                    no_message = true
                })
            else
                card.ability.extra.xmult = math.max(card.ability.extra.xmult - card.ability.extra.xmult_sub*#context.full_hand, 1)
            end
            if card.ability.extra.xmult <= 1 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_poof_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.rare_mod = G.GAME.rare_mod * card.ability.extra.rarity_mod
        G.GAME.sgt_obscure_mod = G.GAME.sgt_obscure_mod * card.ability.extra.rarity_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.rare_mod = G.GAME.rare_mod / card.ability.extra.rarity_mod
        G.GAME.sgt_obscure_mod = G.GAME.sgt_obscure_mod / card.ability.extra.rarity_mod
    end,
    in_pool = function(self, args)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rarity_mod, card.ability.extra.xmult, card.ability.extra.xmult_sub}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                    }
                }
            },
        }
    end,
}

local nemo = {
    key = "nemo",
    name = "Cpt. Nemo",
    atlas = "nemo",
    saga_group = "20k_miles_under_the_sea",
    order = 80,
    pos = { x = 0, y = 0 },
    pools = { [SAGA_GROUP_POOL.legend] = true },
    soul_pos = { x = 1, y = 0 },
    config = {joker_count = 0},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.play then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.joker_count,
                    card = card,
                }
            end
            if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.joker_count,
                    card = card,
                }
            end
        end
        if context.end_of_round and context.repetition
        and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.joker_count,
                card = card,
            }
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.joker_count = 0
            for _, area in ipairs(SMODS.get_card_areas("jokers")) do
                if area.cards then
                    for _, v in ipairs(area.cards) do
                        if v.config.center.saga_group == "20k_miles_under_the_sea" then
                            card.ability.joker_count = card.ability.joker_count + 1
                        end
                    end
                end
            end
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.ability", ref_value = "joker_count", retrigger_type = "mult" },
            },
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                return joker_card.ability.joker_count*JokerDisplay.calculate_joker_triggers(joker_card)
            end,
        }
    end,
}

local hansels_cheat_dice = {
    key = "hansels_cheat_dice",
    name = "Hansel's Cheat Dice",
    atlas = "misc_jokers",
    saga_group = "gambling_hansel",
    order = 993,
    pos = { x = 4, y = 0 },
    config = {immutable = {current_roll = 0}},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint and not context.retrigger_joker then
            card.ability.immutable.current_roll = pseudorandom("cheat_dice_roll", 1, 6)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_roll_ex')})
            if card.ability.immutable.current_roll == 1 then
                ease_ante(1)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
            end
        end
        if card.ability.immutable.current_roll > 0 and not context.blueprint then
            if context.mod_probability then
                if card.ability.immutable.current_roll == 2 then
                    return { numerator = context.numerator + 2 }
                elseif card.ability.immutable.current_roll == 3 then
                    return { denominator = math.max(Cryptid and 0.001 or 1, context.denominator - 3) }
                elseif card.ability.immutable.current_roll == 4 then
                    return { numerator = context.numerator*4 }
                elseif card.ability.immutable.current_roll == 5 then
                    return { numerator = context.numerator/5 }
                end
            end
            if context.fix_probability then
                if card.ability.immutable.current_roll == 6 then
                    return { numerator = context.denominator }
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        if Sagatro.debug then
            for i = 1, 6 do
                info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "HanselsDice",
                key = "sgt_roll"..i, default_colour = true}
            end
        else
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "HanselsDice",
            key = "sgt_roll"..card.ability.immutable.current_roll, default_colour = true}
        end
        return {vars = {card.ability.immutable.current_roll > 0 and card.ability.immutable.current_roll or localize("k_none"),
        colours = {card.ability.immutable.current_roll > 1 and G.C.GREEN or card.ability.immutable.current_roll > 0 and G.C.RED or G.C.UI.TEXT_INACTIVE}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text =
                card.ability.immutable.current_roll == 0 and localize("k_none") or
                card.ability.immutable.current_roll == 1 and localize("ph_plus_ante") or
                card.ability.immutable.current_roll == 2 and localize("ph_numer_plus_2") or
                card.ability.immutable.current_roll == 3 and localize("ph_denom_minus_3") or
                card.ability.immutable.current_roll == 4 and localize("ph_X4_numer") or
                card.ability.immutable.current_roll == 5 and localize("ph_D5_numer") or
                card.ability.immutable.current_roll == 6 and localize("ph_guaranteed")
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    text.children[1].config.colour =
                    card.ability.immutable.current_roll == 0 and G.C.UI.TEXT_INACTIVE or
                    card.ability.immutable.current_roll == 1 and G.C.RED or
                    G.C.GREEN
                end
                return false
            end,
        }
    end,
}

local skoll_n_hati = {
    key = "skoll_n_hati",
    name = "Sköll And Hati",
    atlas = "misc_jokers",
    saga_group = "norse_mythology",
    order = 994,
    pos = { x = 0, y = 1 },
    config = {immutable = {max_count = 7}, extra = {xmult = 1, xmult_mod = 0.2, xchip = 1, xchip_mod = 0.2}, current_mode = "universal"},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.anim_pos = { x = 0, y = 1 }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                local count_table, triggered = {}, true
                for _, v in ipairs(G.playing_cards) do
                    for _, suit in ipairs{"Hearts", "Diamonds", "Spades", "Clubs"} do
                        if v:is_suit(suit, true) and not SMODS.has_any_suit(v) and not SMODS.smeared_check(v, suit) then
                            count_table[suit] = (count_table[suit] or 0) + 1
                        end
                    end
                end
                for _, count in pairs(count_table) do
                    if count > card.ability.immutable.max_count then
                        triggered = false
                        break
                    end
                end
                return triggered and not card.ability.pre_ragnarok and Sagatro.mod_compat.talisman
            end
            if eval() then
                juice_card_until(card, eval, true)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upcoming_ex'), colour = G.C.RED})
            end
        end
        if card.ability.current_mode == "skoll" then
            if context.before and not context.blueprint and not context.retrigger_joker then
                local upgrade = false
                for _, v in ipairs(context.full_hand) do
                    if v:is_suit("Hearts") or v:is_suit("Diamonds") then
                        upgrade = true
                        if SMODS.scale_card then
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "xmult",
                                scalar_value = "xmult_mod",
                                no_message = true
                            })
                        else
                            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                        end
                    end
                end
                if upgrade then
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED,
                        card = card,
                    }
                end
            end
            if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
                if context.forcetrigger then
                    for _, v in ipairs(context.full_hand) do
                        if v:is_suit("Hearts") or v:is_suit("Diamonds") then
                            if SMODS.scale_card then
                                SMODS.scale_card(card, {
                                    ref_table = card.ability.extra,
                                    ref_value = "xmult",
                                    scalar_value = "xmult_mod",
                                    no_message = true
                                })
                            else
                                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                            end
                        end
                    end
                end
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
            end
            if context.destroy_card and (context.cardarea == G.play or context.cardarea == "unscored") and not context.blueprint and not context.retrigger_joker then
                if context.destroy_card:is_suit("Hearts") or context.destroy_card:is_suit("Diamonds") then
                    return {remove = true}
                end
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.current_mode = "hati"
                return true end}))
                return {
                    message = localize('sgt_swap'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        elseif card.ability.current_mode == "hati" then
            if context.before and not context.blueprint and not context.retrigger_joker then
                local upgrade = false
                for _, v in ipairs(G.hand.cards) do
                    if v:is_suit("Spades") or v:is_suit("Clubs") then
                        upgrade = true
                        if SMODS.scale_card then
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "xchip",
                                scalar_value = "xchip_mod",
                                no_message = true
                            })
                        else
                            card.ability.extra.xchip = card.ability.extra.xchip + card.ability.extra.xchip_mod
                        end
                    end
                end
                if upgrade then
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.BLUE,
                        card = card,
                    }
                end
            end
            if (context.joker_main and to_big(card.ability.extra.xchip) > to_big(1)) or context.forcetrigger then
                if context.forcetrigger then
                    for _, v in ipairs(G.hand.cards) do
                    if v:is_suit("Spades") or v:is_suit("Clubs") then
                        if SMODS.scale_card then
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "xchip",
                                scalar_value = "xchip_mod",
                                no_message = true
                            })
                        else
                            card.ability.extra.xchip = card.ability.extra.xchip + card.ability.extra.xchip_mod
                        end
                    end
                end
                end
                return {
                    Xchip_mod = card.ability.extra.xchip,
                    message = localize{type='variable', key='a_xchips', vars={card.ability.extra.xchip}}
                }
            end
            if context.destroy_card and context.cardarea == G.hand and not context.blueprint and not context.retrigger_joker then
                if context.destroy_card:is_suit("Spades") or context.destroy_card:is_suit("Clubs") then
                    return {remove = true}
                end
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.current_mode = "skoll"
                return true end}))
                return {
                    message = localize('sgt_swap'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local eval = function()
                local count_table, triggered = {}, true
                for _, v in ipairs(G.playing_cards) do
                    for _, suit in ipairs{"Hearts", "Diamonds", "Spades", "Clubs"} do
                        if v:is_suit(suit, true) and not SMODS.has_any_suit(v) and not SMODS.smeared_check(v, suit) then
                            count_table[suit] = (count_table[suit] or 0) + 1
                        end
                    end
                end
                for _, count in pairs(count_table) do
                    if count > card.ability.immutable.max_count then
                        triggered = false
                        break
                    end
                end
                return triggered and not card.ability.pre_ragnarok and Sagatro.mod_compat.talisman
            end
            if card.ability.pending_pre_ragnarok then
                card.ability.pending_pre_ragnarok = nil
                card.ability.pre_ragnarok = true
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        assert(SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_three_winters",
                        }))
                        return true
                    end
                }))
            end
            if eval() and not card.ability.pending_pre_ragnarok then
                card.ability.pending_pre_ragnarok = true
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.current_mode = "skoll"
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.loaded = nil
            local eval = function()
                local count_table, triggered = {}, true
                for _, v in ipairs(G.playing_cards) do
                    for _, suit in ipairs{"Hearts", "Diamonds", "Spades", "Clubs"} do
                        if v:is_suit(suit, true) and not SMODS.has_any_suit(v) and not SMODS.smeared_check(v, suit) then
                            count_table[suit] = (count_table[suit] or 0) + 1
                        end
                    end
                end
                for _, count in pairs(count_table) do
                    if count > card.ability.immutable.max_count then
                        triggered = false
                        break
                    end
                end
                return triggered and not card.ability.pre_ragnarok and Sagatro.mod_compat.talisman
            end
            if eval() then juice_card_until(card, eval, true) end
        end
        if card.ability and self.discovered then
            if card.ability.current_mode == "skoll" then
                card.ability.anim_pos.x = 0
            elseif card.ability.current_mode == "hati" then
                card.ability.anim_pos.x = 1
            end
            card.children.center:set_sprite_pos(card.ability.anim_pos)
        end
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card and card.ability.current_mode ~= "universal" then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_skoll_n_hati"]
        end
        local ret = {}
        if card.ability.current_mode == "skoll" then
            ret.key = "j_sgt_skoll"
            ret.vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod}
        elseif card.ability.current_mode == "hati" then
            ret.key = "j_sgt_hati"
            ret.vars = {card.ability.extra.xchip, card.ability.extra.xchip_mod}
        elseif card.ability.current_mode == "universal" then
            ret.vars = {card.ability.extra.xmult_mod, card.ability.extra.xchip_mod}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult_xchip", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                if card.ability.current_mode == "skoll" then
                    card.joker_display_values.xmult_xchip = card.ability.extra.xmult
                elseif card.ability.current_mode == "hati" then
                    card.joker_display_values.xmult_xchip = card.ability.extra.xchip
                else
                    card.joker_display_values.xmult_xchip = card.ability.extra.xmult -- Fallback, just in case
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    text.children[1].config.colour = card.ability.current_mode == "skoll"
                    and G.C.RED or card.ability.current_mode == "hati" and G.C.BLUE or G.C.RED
                end
                return false
            end,
        }
    end,
}

local three_winters = {
    key = "three_winters",
    name = "Fimbulwinter",
    atlas = "misc_jokers",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 995,
    pos = { x = 2, y = 1 },
    config = {three_winters_rounds = 0, extra = {rounds_goal = 3, xblind_amount = 5}},
    rarity = 1,
    cost = 1,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            card.ability.three_winters_rounds = card.ability.three_winters_rounds + 1
            if (card.ability.three_winters_rounds >= card.ability.extra.rounds_goal) or context.forcetrigger then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        assert(SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_ragnarok",
                            edition = card.edition and card.edition.key or nil,
                        }))
                        return true
                    end
                }))
                Sagatro.self_destruct(card)
                return {
                    message = localize("k_poof_ex"),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = (card.ability.three_winters_rounds..'/'..card.ability.extra.rounds_goal),
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        Sagatro.update_blind_amounts()
    end,
    remove_from_deck = function(self, card, from_debuff)
        Sagatro.update_blind_amounts()
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_ragnarok"]
        return {vars = {card.ability.extra.xblind_amount, card.ability.three_winters_rounds, card.ability.extra.rounds_goal,
        localize{type = 'name_text', set = "Joker", key = "j_sgt_ragnarok", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xblind_amount" }
                    },
                    border_colour = G.C.FILTER,
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = card.ability.three_winters_rounds .. "/" .. card.ability.extra.rounds_goal
            end,
        }
    end,
}

local adam = {
    key = "adam",
    name = "Adam And Eva's Original Sin",
    atlas = "misc_jokers",
    saga_group = "adams_original_sin",
    order = 996,
    pos = { x = 3, y = 1 },
    config = {extra = {retriggers = 1}},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center_key ~= "j_sgt_adam" then
            if (Ortalab and context.other_card.curse)
            or (not Ortalab and context.other_card.ability.perishable) then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra.retriggers,
                    card = card,
                }
            end
		end
    end,
    loc_vars = function(self, info_queue, card)
        return {key = Ortalab and "j_sgt_adam_alt" or "j_sgt_adam"}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_joker_function = function(card, retrigger_joker)
                return card.config.center_key ~= "j_sgt_adam" and ((Ortalab and card.curse)
                or (not Ortalab and card.ability.perishable))
                and retrigger_joker.ability.extra.retriggers or 0
            end,
        }
    end,
}

local saint_germain = {
    key = "saint_germain",
    name = "Saint Germain",
    atlas = "misc_jokers",
    saga_group = "saint_germain_immortal",
    order = 997,
    pos = { x = 4, y = 1 },
    config = {},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and #context.full_hand == 1 and context.full_hand[1]:get_id() == 13 then
            local chosen_conductive = SMODS.poll_enhancement{key = "saint_conductive", guaranteed = true, options = Sagatro.electric_eel_info_queue}
            for _, v in ipairs(G.hand.cards) do
                v:set_ability(G.P_CENTERS[chosen_conductive], nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
            return {
                message = localize('k_transmutate_ex'),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.electric_eel_info_queue_append(info_queue, Sagatro.electric_eel_info_queue)
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                local _, _, scoring_hand = JokerDisplay.evaluate_hand()
                card.joker_display_values.active = #scoring_hand == 1 and scoring_hand[1]:get_id() == 13
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local necronomicon = {
    key = "necronomicon",
    name = "Necronomicon",
    atlas = "misc_jokers",
    saga_group = "lovecraft",
    order = 998,
    pos = { x = 5, y = 1 },
    config = {extra = {intrinsic_weight = 0}},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 end
                juice_card_until(card, eval, true)
            end
        end
        if context.before and not context.blueprint and not context.retrigger_joker
        and G.GAME.current_round.hands_played == 0 and #context.scoring_hand >= 5
        and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local total_weight = 0
            for _, v in ipairs(context.scoring_hand) do
                total_weight = total_weight + Sagatro.necronomicon_get_weight(v)
            end
            card.ability.extra.intrinsic_weight = total_weight
            card.ability.extra.triggered = true
        end
        if context.destroy_card and context.cardarea == G.play and card.ability.extra.triggered then
            return {remove = true}
        end
        if (context.joker_main and not context.blueprint and not context.retrigger_joker and card.ability.extra.triggered)
        or context.forcetrigger then
            if not context.forcetrigger then G.GAME.joker_buffer = G.GAME.joker_buffer + 1 end
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.0, func = function()
                local rarity = Sagatro.necronomicon_get_rarity(card.ability.extra.intrinsic_weight)
                assert(SMODS.add_card({
                    set = "Joker",
                    rarity = context.forcetrigger and "Common" or rarity,
                    key_append = not context.forcetrigger and "nec"..Sagatro.necronomicon.rarity_weight[rarity] or nil,
                }))
                G.GAME.joker_buffer = 0
            return true end }))
            return {
                message = localize("k_sacrifice_ex"),
                colour = G.C.RED,
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.triggered = nil
            return true end }))
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_lovecraft'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local count = 0
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + 1
                    end
                end
                card.joker_display_values.active =
                (G.GAME.current_round.hands_played == 0 and count >= 5 and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit)
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local frog_prince = {
    key = "frog_prince",
    name = "Frog Prince",
    atlas = "misc_jokers",
    saga_group = "frog_prince",
    order = 999,
    pos = { x = 0, y = 2 },
    config = {},
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and next(context.poker_hands["Straight"])
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit)
        or context.forcetrigger then
            local kings = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 13 then kings = kings + 1 end
            end
            if kings >= 1 or context.forcetrigger then
                if not context.forcetrigger then G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1 end
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.0, func = (function()
                    assert(SMODS.add_card({
                        set = "Tarot",
                        key_append = "fropr",
                    }))
                    G.GAME.consumeable_buffer = 0
                return true end)}))
            end
            return {
                message = localize('k_plus_tarot'),
                colour = G.C.SECONDARY_SET.Tarot,
                card = card
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_shortcut"]
        return {vars = {localize{type = 'name_text', set = "Joker", key = "j_shortcut", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.SECONDARY_SET.Tarot },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_king", colour = G.C.ORANGE },
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text_straight", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local king_and_straight = false
                local _, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
                if poker_hands["Straight"] and next(poker_hands["Straight"]) then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() and scoring_card:get_id() == 13 then
                            king_and_straight = true
                        end
                    end
                end
                card.joker_display_values.count = king_and_straight and 1 or 0
                card.joker_display_values.localized_text_straight = localize('Straight', "poker_hands")
                card.joker_display_values.localized_text_king = localize("King", "ranks")
            end
        }
    end,
}

local little_prince = {
    key = "little_prince",
    name = "Little Prince",
    atlas = "misc_jokers",
    saga_group = "little_prince",
    order = 1000,
    pos = { x = 4, y = 2 },
    config = {
        streaks = {
            chips = 50,
            mult = 10,
            dollars = 2,
            xmult = 1.5,
            xchip = 1.5,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    streak_options = function(self)
        local options = {
            {key = "sgt_blue_streak", weight = 5},
            {key = "sgt_red_streak", weight = 5},
            {key = "sgt_gold_streak", weight = 5},
            {key = "sgt_purple_streak", weight = 2},
            {key = "sgt_celurean_streak", weight = 2},
        }
        local loc_vars = {
            sgt_blue_streak_seal = "chips",
            sgt_red_streak_seal = "mult",
            sgt_gold_streak_seal = "dollars",
            sgt_purple_streak_seal = "xmult",
            sgt_celurean_streak_seal = "xchip",
        }
        return options, loc_vars
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn or context.forcetrigger then
            G.E_MANAGER:add_event(Event({
            func = function()
                local _card = create_playing_card({
                    front = pseudorandom_element(G.P_CARDS, pseudoseed('litpr_fr')),
                    center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                local options = self:streak_options()
                _card:set_seal(SMODS.poll_seal({type_key = 'litprstr', guaranteed = true, options = options}), nil, true)
                G.GAME.blind:debuff_card(_card)
                G.hand:sort()
                if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                playing_card_joker_effects({_card})
                save_run()
                return true
            end}))
        end
    end,
    loc_vars = function(self, info_queue, card)
        local _, loc_vars = self:streak_options()
        for k, v in pairs(loc_vars) do
            info_queue[#info_queue+1] = {set = "Other", key = k, specific_vars = {self.config.streaks[v]}}
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local pumpkin_carriage = {
    key = "pumpkin_carriage",
    name = "Pumpkin Carriage",
    atlas = "misc_jokers",
    saga_group = "cinderella",
    order = 1001,
    pos = { x = 1, y = 2 },
    config = {extra = 12},
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.eligible_strength_jokers = EMPTY(card.eligible_strength_jokers)
            for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == 'Joker' and not v.edition then
                    table.insert(card.eligible_strength_jokers, v)
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.before and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if next(card.eligible_strength_jokers) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local eligible_card = pseudorandom_element(card.eligible_strength_jokers, pseudoseed('pumpkin_carriage'))
                        eligible_card:set_edition(poll_edition("pumcar", nil, nil, true), true)
                        eligible_card.ability.pumpkin_edition = true
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize("k_glowup_ex"),
                    colour = G.C.FILTER,
                    card = card
                }
            else
                return {
                    message = localize("k_no_other_jokers"),
                    colour = G.C.FILTER,
                    card = card
                }
            end
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra - 1 <= 0 then
                for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                    if v.ability.set == 'Joker' and v.ability.pumpkin_edition then
                        v:set_edition(nil, true, true)
                    end
                end
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_poof_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                card.ability.extra = card.ability.extra - 1
                return {
                    message = card.ability.extra..'',
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            end
        end
        if context.selling_self and not context.blueprint and not context.retrigger_joker then
            for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == 'Joker' and v.ability.pumpkin_edition then
                    v:set_edition(nil, true, true)
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra
            end,
        }
    end,
}

local abducted_cow = {
    key = "abducted_cow",
    name = "Abducted Cow",
    atlas = "misc_jokers",
    saga_group = "common_story",
    order = 1002,
    pos = { x = 3, y = 2 },
    config = {extra = {}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 end
                juice_card_until(card, eval, true)
            end
        end
        if context.before and not context.blueprint and not context.retrigger_joker
        and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
            local _card = context.full_hand[1]
            card.ability.extra.held_card = {}
            card.ability.extra.held_card.suit = _card.base.suit
            card.ability.extra.held_card.rank = _card.config.card.value
            card.ability.extra.triggered = true
        end
        if context.destroy_card and context.cardarea == G.play and card.ability.extra.triggered then
            return {
                message = localize("k_abducted_ex"),
                colour = G.C.FILTER,
                remove = true
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.triggered = nil
            return true end }))
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker
        and card.ability.extra.held_card then
            G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                local _card = create_playing_card({
                    front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr')),
                    center = G.P_CENTERS.c_base}, G.play, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                _card:set_ability(SMODS.poll_enhancement{key = "abducted_enhanced", guaranteed = true, no_replace = true})
                assert(SMODS.change_base(_card, card.ability.extra.held_card.suit, card.ability.extra.held_card.rank))
                SMODS.calculate_effect({message = localize('k_release_ex'), colour = G.C.SECONDARY_SET.Enhanced}, card)
                draw_card(G.play,G.deck, 90,'up', nil)
                playing_card_joker_effects({_card})
                card.ability.extra.held_card = nil
                save_run()
                return true
            end}))
        end
    end,
    loc_vars = function(self, info_queue, card)
        local text = card.ability.extra.held_card
        and localize{type = 'variable', key = 'sgt_rank_of_suit',
        vars = {localize(card.ability.extra.held_card.rank, "ranks"),
        localize(card.ability.extra.held_card.suit, "suits_plural")}}
        or localize("k_none")
        return {vars = {text}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "held_card", colour = G.C.FILTER },
                { text = ")" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local count = 0
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + 1
                    end
                end
                card.joker_display_values.active =
                (G.GAME.current_round.hands_played == 0 and count == 1)
                and localize("jdis_active") or localize("jdis_inactive")
                card.joker_display_values.held_card = card.ability.extra.held_card
                and localize{type = 'variable', key = 'sgt_rank_of_suit',
                vars = {localize(card.ability.extra.held_card.rank, "ranks"),
                localize(card.ability.extra.held_card.suit, "suits_plural")}}
                or localize("k_none")
            end,
        }
    end,
}

local flying_house = {
    key = "flying_house",
    name = "Howl's Flying House",
    atlas = "misc_jokers",
    saga_group = "howls_flying_house",
    order = 1003,
    pos = { x = 2, y = 2 },
    config = {type = "Full House"},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 end
                juice_card_until(card, eval, true)
            end
        end
        if (context.before and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.hands_played == 0
        and context.poker_hands and next(context.poker_hands[card.ability.type])) or context.forcetrigger then
            local ranks = {}
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    ranks[v.config.card.value] = (ranks[v.config.card.value] or 0) + 1
                end
            end
            local max_count, rank = 0, nil
            for k, v in pairs(ranks) do
                if max_count < v then max_count = v; rank = k end
            end
            for _, v in ipairs(context.scoring_hand) do
                if ranks[v.config.card.value] and ranks[v.config.card.value] ~= max_count then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            assert(SMODS.change_base(v, nil, rank))
                            return true
                        end
                    }))
                end
            end
            return {
                message = localize("k_repair_ex"),
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.type, 'poker_hands'),
        localize("Pair", 'poker_hands'),
        localize("Three of a Kind", 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_misc_story'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                local active = false
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    active = true
                end
                card.joker_display_values.active =
                (G.GAME.current_round.hands_played == 0 and active)
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local shub = {
    key = "shub",
    name = "Shub-Niggurath",
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 3000,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 2 },
    soul_pos = { x = 2, y = 2, extra = { x = 1, y = 2 } },
    config = {extra = {e_mult = 1, e_mult_mod = 0.02}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if (context.before and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local new_cards = {}
                    for i=1, #context.full_hand do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local new_card = copy_card(context.full_hand[i], nil, nil, G.playing_card)
                        local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('shub_debaunched'))
                        SMODS.change_base(new_card, nil, _rank.key)
                        table.insert(new_cards, new_card)
                    end
                    for i, new_card in ipairs(new_cards) do
                        new_card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, new_card)
                        G.deck:emplace(new_card)
                        context.full_hand[i]:juice_up()
                        new_card:juice_up()
                    end
                    playing_card_joker_effects(new_cards)
                    G.deck:shuffle('shub_shuffle')
                    return true
                end
            }))
        end
        if context.individual and context.cardarea == G.play and not context.blueprint
        and #G.playing_cards + #context.full_hand > G.GAME.starting_deck_size then
            if not context.other_card.debuff then
                return {
                    -- This is actually delayed - it takes the value before new cards are added by Shub-Niggurath
                    -- I'm adding #context.full_hand to compensate for it
                    sgt_e_mult = card.ability.extra.e_mult
                    + (card.ability.extra.e_mult_mod*(#G.playing_cards + #context.full_hand - G.GAME.starting_deck_size)),
                }
            end
        end
        if context.forcetrigger then
            return { -- not tested
                sgt_e_mult = card.ability.extra.e_mult
                + (card.ability.extra.e_mult_mod*(#G.playing_cards + 2*#context.full_hand - G.GAME.starting_deck_size)),
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult + (card.ability.extra.e_mult_mod*(G.playing_cards and #G.playing_cards > G.GAME.starting_deck_size and #G.playing_cards - G.GAME.starting_deck_size or 0)),
            card.ability.extra.e_mult_mod, G.GAME.starting_deck_size}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_lovecraft'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local emult = card.ability.extra.e_mult + (card.ability.extra.e_mult_mod*(#G.playing_cards - G.GAME.starting_deck_size))
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.e_mult = emult^count
            end,
        }
    end,
}

local ragnarok = {
    key = "ragnarok",
    name = "Ragnarök",
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2000,
    pos = { x = 0, y = 3 },
    soul_pos = { x = 2, y = 3, extra = { x = 1, y = 3 } },
    config = {extra = {e_mult = 1, e_mult_mod_boss = 0.25, e_mult_mod_showdown = 0.5}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and G.GAME.blind.boss then
            if G.GAME.blind.config.blind.boss.showdown then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "e_mult",
                        scalar_value = "e_mult_mod_showdown",
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.FILTER,
                            card = card,
                        }
                    })
                else
                    card.ability.extra.e_mult = card.ability.extra.e_mult + card.ability.extra.e_mult_mod_showdown
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.FILTER,
                        card = card,
                    }
                end
            else
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "e_mult",
                        scalar_value = "e_mult_mod_boss",
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.FILTER,
                            card = card,
                        }
                    })
                else
                    card.ability.extra.e_mult = card.ability.extra.e_mult + card.ability.extra.e_mult_mod_boss
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.FILTER,
                        card = card,
                    }
                end
            end
        end
        if context.joker_main and to_big(card.ability.extra.e_mult) > to_big(1) then
            return {
                sgt_e_mult = card.ability.extra.e_mult
            }
        end
        if context.forcetrigger then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "e_mult",
                    scalar_value = "e_mult_mod_showdown",
                    no_message = true
                })
            else
                card.ability.extra.e_mult = card.ability.extra.e_mult + card.ability.extra.e_mult_mod_showdown
            end
            return {
                sgt_e_mult = card.ability.extra.e_mult
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult, card.ability.extra.e_mult_mod_boss, card.ability.extra.e_mult_mod_showdown}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.ability.extra", ref_value = "e_mult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
        }
    end
}

local yggdrasil = {
    key = "yggdrasil",
    name = "Yggdrasil",
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2001,
    pools = { [SAGA_GROUP_POOL.norse] = true },
    pos = { x = 3, y = 0 },
    soul_pos = { x = 5, y = 0, extra = { x = 4, y = 0 } },
    config = {},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local thor = {
    key = "thor",
    name = "Thórr",
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2002,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 1 },
    soul_pos = { x = 5, y = 1, extra = { x = 4, y = 1 } },
    config = {extra = {e_mult = 1.5}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.play then
                for i, v in ipairs(G.play.cards) do
                    if context.other_card == v then
                        local count = 0
                        if Sagatro.conductive_enhancement(G.play.cards[i-1]) then
                            count = count + 1
                        end
                        if Sagatro.conductive_enhancement(G.play.cards[i+1]) then
                            count = count + 1
                        end
                        if count > 0 then
                            return {
                                message = localize("k_again_ex"),
                                repetitions = count,
                                card = card,
                            }
                        end
                    end
                end
            end
            if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                for i, v in ipairs(G.hand.cards) do
                    if context.other_card == v then
                        local count = 0
                        if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                            count = count + 1
                        end
                        if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                            count = count + 1
                        end
                        if count > 0 then
                            return {
                                message = localize("k_again_ex"),
                                repetitions = count,
                                card = card,
                            }
                        end
                    end
                end
            end
        end
        if context.end_of_round and context.repetition
        and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            for i, v in ipairs(G.hand.cards) do
                if context.other_card == v then
                    local count = 0
                    if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                        count = count + 1
                    end
                    if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                        count = count + 1
                    end
                    if count > 0 then
                        return {
                            message = localize("k_again_ex"),
                            repetitions = count,
                            card = card,
                        }
                    end
                end
            end
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if Sagatro.conductive_enhancement(context.other_card) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        sgt_e_mult = card.ability.extra.e_mult,
                        card = card,
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult,
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.electric_eel_info_queue_append(info_queue, Sagatro.electric_eel_info_queue)
        return {vars = {card.ability.extra.e_mult}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local emult = card.ability.extra.e_mult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and Sagatro.conductive_enhancement(playing_card) then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.e_mult = emult^count
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then
                    local count = 0
                    for i, v in ipairs(G.hand.cards) do
                        if playing_card == v then
                            if Sagatro.conductive_enhancement(G.hand.cards[i-1]) then
                                count = count + 1
                            end
                            if Sagatro.conductive_enhancement(G.hand.cards[i+1]) then
                                count = count + 1
                            end
                        end
                    end
                    return count*JokerDisplay.calculate_joker_triggers(joker_card)
                else
                    local count = 0
                    if scoring_hand then
                        for i, v in ipairs(G.play.cards) do
                            if playing_card == v then
                                if Sagatro.conductive_enhancement(G.play.cards[i-1]) and table.contains(scoring_hand, v) then
                                    count = count + 1
                                end
                                if Sagatro.conductive_enhancement(G.play.cards[i+1]) and table.contains(scoring_hand, v) then
                                    count = count + 1
                                end
                            end
                        end
                    end
                    return count*JokerDisplay.calculate_joker_triggers(joker_card)
                end
            end,
        }
    end,
}

local odin = {
    key = "odin",
    name = "Ódinn",
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2003,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 2 },
    soul_pos = { x = 5, y = 2, extra = { x = 4, y = 2 } },
    config = {},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
			return {
                add_to_hand = true,
                no_retrigger = true
            }
		end
        if context.before and not context.blueprint and not context.retrigger_joker then
            for _, v in ipairs(context.full_hand) do
                v:set_ability(G.P_CENTERS.m_sgt_omniscient, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:add_sticker("sgt_protected", true)
                        v:juice_up()
                        return true
                    end
                }))
            end
            return {
                message = localize('k_omniscient_ex'),
                colour = G.C.FILTER,
                card = card,
            }
        end
        if context.forcetrigger then
            if context.scoring_hand then
				for _, v in ipairs(context.full_hand) do
                    v:set_ability(G.P_CENTERS.m_sgt_omniscient, nil, true)
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.4,
                        func = function()
                            v:juice_up()
                            return true
                        end,
                    }))
				end
			elseif G and G.hand and #G.hand.highlighted > 0 then
				for _, v in ipairs(G.hand.highlighted) do
                    v:set_ability(G.P_CENTERS.m_sgt_omniscient, nil, true)
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.4,
                        func = function()
                            v:juice_up()
                            return true
                        end,
                    }))
				end
			end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_omniscient
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local hermod = {
    key = "hermod",
    name = "Hermódr",
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2004,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 3 },
    soul_pos = { x = 5, y = 3, extra = { x = 4, y = 3 } },
    config = {extra = {amount = 3, amount_mod = 2}, immutable = {max_amount = 25}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    update = function(self, card, dt)
        if card.ability.extra.amount > card.ability.immutable.max_amount then
            card.ability.extra.amount = card.ability.immutable.max_amount
        end
    end,
    calculate = function(self, card, context)
        if context.skip_blind or context.forcetrigger then
            local available_tags = get_current_pool('Tag')
            local selected_tags = {}
            for i = 1, card.ability.extra.amount do
                local tag = pseudorandom_element(available_tags, pseudoseed('hermod'))
                local it = 1
                while tag == 'UNAVAILABLE' do
                    tag = pseudorandom_element(available_tags, pseudoseed('hermod_reroll'..it))
                    it = it + 1
                end
                selected_tags[i] = tag
            end
            G.E_MANAGER:add_event(Event({
                func = (function()
                    for _, tag in pairs(selected_tags) do
                        add_tag(Tag(tag, false, 'Small'))
                    end
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    if not context.blueprint then
                        if SMODS.scale_card then
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "amount",
                                scalar_value = "amount_mod",
                                no_message = true
                            })
                        else
                            card.ability.extra.amount = card.ability.extra.amount + card.ability.extra.amount_mod
                        end
                    end
                    save_run()
                    return true
                end)
            }))
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.amount_mod}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_norse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "amount", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.FILTER },
        }
    end
}

local azathoth = {
    key = "azathoth",
    name = "Azathoth",
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 3001,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 4 },
    soul_pos = { x = 2, y = 4, extra = { x = 1, y = 4 } },
    config = {extra = {amount = 1, amount_mod = 2}, immutable = {max_amount = 25}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    update = function(self, card, dt)
        if card.ability.extra.amount > card.ability.immutable.max_amount then
            card.ability.extra.amount = card.ability.immutable.max_amount
        end
    end,
    calculate = function(self, card, context)
        if context.ending_shop or context.forcetrigger then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    for _ = 1, card.ability.extra.amount do
                        assert(SMODS.add_card({
                            set = "Tarot",
                            key = "c_fool",
                            edition = "e_negative",
                        }))
                    end
                    if not context.blueprint then
                        if SMODS.scale_card then
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "amount",
                                scalar_value = "amount_mod",
                                scaling_message = {
                                    message = localize('k_zzz'),
                                    colour = G.C.SECONDARY_SET.Tarot,
                                    card = card
                                }
                            })
                        else
                            card.ability.extra.amount = card.ability.extra.amount + card.ability.extra.amount_mod
                            return {
                                message = localize('k_zzz'),
                                colour = G.C.SECONDARY_SET.Tarot,
                                card = card
                            }
                        end
                    end
                return true
            end)}))
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_fool
        return {vars = {card.ability.extra.amount, card.ability.extra.amount_mod, localize{type = 'name_text', set = "Tarot", key = "c_fool", nodes = {}}}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_lovecraft'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "amount", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.SECONDARY_SET.Tarot },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize{type = 'name_text', set = "Tarot", key = "c_fool", nodes = {}}
            end,
        }
    end,
}

local darkness = {
    key = "darkness",
    name = "Darkness",
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 3002,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 3, y = 4 },
    soul_pos = { x = 5, y = 4, extra = { x = 4, y = 4 } },
    config = {},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            local chosen_card = pseudorandom_element(context.full_hand, pseudoseed("darkness_negative_playing_card"))
            if not chosen_card.edition then
                chosen_card:set_edition("e_negative")
            end
        end
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_lovecraft'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local nameless = {
    key = "nameless",
    name = "Magnum Innominandum",
    atlas = "nameless",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 3003,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 2, extra = { x = 0, y = 1 } },
    config = {amount = 1, immutable = {max_amount = 100}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    update = function(self, card, dt)
        if card.ability.amount > card.ability.immutable.max_amount then
            card.ability.amount = card.ability.immutable.max_amount
        end
    end,
    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval and not context.blueprint) or context.forcetrigger then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.jokers then
                        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.amount
                    end
                    return true
                end,
            }))
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not (from_debuff or next(SMODS.find_card("j_sgt_nameless"))) then
            G.GAME.antimatter_overload = 0.2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.antimatter_overload = next(SMODS.find_card("j_sgt_nameless")) and G.GAME.antimatter_overload or nil
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.amount}}
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_lovecraft'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
}

local mabel = {
    key = "mabel",
    name = "Mabel",
    atlas = "mabel",
    no_collection = not Sagatro.mod_compat.talisman,
    saga_group = "black_soul",
    order = 3004,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    config = {amount = 1, immutable = {max_amount = 8}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.immutable.max_amount = G.GAME.win_ante or 8
            if card.ability.amount > card.ability.immutable.max_amount then
                card.ability.amount = card.ability.immutable.max_amount
            end
            for i, v in ipairs(G.jokers.cards) do
                if v == card and (card.ability.immutable.position or 0) ~= i then
                    card.ability.immutable.position = i
                    if (card.ability.immutable.switch or false) ~= mabel_stall() then
                        Sagatro.update_blind_amounts(true)
                        card.ability.immutable.switch = mabel_stall()
                    end
                    break
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.ending_shop and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if (G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_mabel") or context.forcetrigger then
                ease_ante(-card.ability.amount)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.amount
            elseif G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].config.center_key ~= "j_sgt_mabel" then
                ease_ante(card.ability.amount)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + card.ability.amount
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.amount}}
        if Ortalab then
            ret.main_end = {}
            localize{type = "other", key = "sgt_only_joker_area", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('ph_black_soul'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
 	end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "sign" },
                { ref_table = "card.joker_display_values", ref_value = "amount" }
            },
            text_config = { colour = G.C.FILTER },
            calc_function = function(card)
                card.joker_display_values.sign = G.jokers.cards[1] == card and "-"
                or G.jokers.cards[#G.jokers.cards] == card and "+" or ""
                card.joker_display_values.amount =
                (G.jokers.cards[1] == card or G.jokers.cards[#G.jokers.cards] == card) and card.ability.amount or 0
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[2] then
                    text.children[2].config.colour =
                    (G.jokers.cards[1] == card or G.jokers.cards[#G.jokers.cards] == card) and G.C.FILTER or G.C.UI.TEXT_INACTIVE
                end
                return false
            end,
        }
    end,
}

local test = {
    key = "test",
    name = "Test Joker",
    loc_txt = {
        name = "Test Joker",
        text = {
            "This joker does {C:attention}something{}",
            "on {C:dark_edition}HuyTheKiller{}'s demand",
            "",
            "Current effect:",
            "{X:dark_edition,C:white}^^^^#1#{} Mult",
        }
    },
    order = 9999,
    debug_obj = true,
    config = {},
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                hyper_mult = {4, 1.01}
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {1.01}}
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
    puss_in_boots,
    iron_john,
    aladdin,
    magic_lamp,
    lamp_genie,
    lincoln_ship,
    submarine,
    clownfish,
    blue_tang,
    pufferfish,
    white_jellyfish,
    red_jellyfish,
    queen_jellyfish,
    mandarin_fish,
    barracuda,
    school,
    prawn,
    john_dory,
    octopus,
    squid,
    turtle_egg,
    baby_turtle,
    green_turtle,
    electric_eel,
    sea_angel,
    stonefish,
    blobfish,
    ugly_blobfish,
    coral_kingdom,
    dolphin,
    coelacanthiformes,
    sunfish,
    moonfish,
    swordfish,
    penguin,
    seal,
    ray,
    orca,
    sperm_whale,
    sea_urchin,
    starfish,
    shark,
    lantern_fish,
    nautilus,
    stomiidae,
    hermit_crab,
    king_crab,
    big_red_jelly,
    narwhal,
    seahorse,
    goblin_shark,
    colossal_squid,
    chimaera,
    dumbo_octopus,
    atolla_wyvillei,
    nemo,
    hansels_cheat_dice,
    skoll_n_hati,
    three_winters,
    adam,
    saint_germain,
    necronomicon,
    frog_prince,
    little_prince,
    pumpkin_carriage,
    abducted_cow,
    flying_house,
    shub,
    ragnarok,
    yggdrasil,
    thor,
    odin,
    hermod,
    azathoth,
    darkness,
    nameless,
    mabel,
    test,
}

table.sort(joker_table, function(a, b) return a.order < b.order end)
for _, v in ipairs(joker_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    if not v.debug_obj or (v.debug_obj and Sagatro.debug) then
        v.debug_obj = nil
        SMODS.Joker(v)
    end
end