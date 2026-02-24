-- Alice in Wonderland
local white_rabbit = {
    key = "white_rabbit",
    name = "White Rabbit",
    artist_credits = {"amy"},
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    saga_difficulty = 3,
    order = 1,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true, [SAGA_GROUP_POOL.story_starter] = true },
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
                return nil, true
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
            if G.GAME.story_mode and not (Sagatro.storyline_check("none") or Sagatro.storyline_check(self.saga_group)) then
                local func = function()
                    card_eval_status_text(card, 'extra', nil, 1, nil, {message = localize('k_not_allowed_ex'), sound = "tarot1", volume = 1, instant = true})
                    ease_dollars(card.cost)
                end
                Sagatro.self_destruct(card, {no_destruction_context = true, no_sound = true}, func)
                return
            end
            Sagatro.init_storyline(self.saga_group)
            if next(SMODS.find_card("j_sgt_dodo_bird", true)) then
                Sagatro.progress_storyline("white_rabbit_house", "add", self.saga_group, G.GAME.interwoven_storyline)
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("white_rabbit_house", "remove", self.saga_group, G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return (Sagatro.storyline_check("none") and args.source == "buf") or Sagatro.storyline_check(self.saga_group)
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("cry_into_flood", false) and Sagatro.storyline_check(self.saga_group))
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "white_rabbit"}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "fusion_hint", title = localize("saga_fusion_tooltip")}
        end
        if Sagatro.storyline_check("none") or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers and not card.displaying_save) then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "storyline_start",
            specific_vars = {localize('ph_alice_in_wond'), self.saga_difficulty, colours = {G.C.SAGA_DIFFICULTY[self.saga_difficulty]}}, title = localize("saga_storyline_start")}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "alice_in_wonderland_mech", title = localize("saga_mechanic")}
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
    artist_credits = {"amy"},
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
        if Sagatro.storyline_check("pocket_mirror") then
            return Sagatro.event_check("facing_egliette")
        end
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_white_rabbit", true))
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
    artist_credits = {"amy"},
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
                            G.GAME.blind:disable("do_not_cut_score")
                        end
                    return true end }))
                end
                if card.ability.extra - 1 <= 0 then
                    Sagatro.self_destruct(card)
                    if Sagatro.storyline_check("pocket_mirror") then
                        Sagatro.progress_storyline("conditional_game_over", "remove", "pocket_mirror", G.GAME.interwoven_storyline)
                    elseif Sagatro.event_check("little_bill") and Sagatro.event_check("huge_dog", nil, true) then
                        Sagatro.progress_storyline("little_bill", "finish", self.saga_group, G.GAME.interwoven_storyline)
                        Sagatro.progress_storyline("huge_dog", "add", self.saga_group, G.GAME.interwoven_storyline)
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
        if Sagatro.storyline_check("pocket_mirror") then
            return Sagatro.event_check("facing_egliette")
        end
        if G.GAME.story_mode then
            return (next(SMODS.find_card("j_sgt_white_rabbit", true)) or next(SMODS.find_card("j_sgt_little_bill", true)))
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
    artist_credits = {"huycorn"},
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
            return next(SMODS.find_card("j_sgt_kid_gloves_and_fan", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_splash"]
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("cry_into_flood"))
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
    artist_credits = {"amy"},
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    order = 5,
    pools = { [SAGA_GROUP_POOL.fsd] = true, [SAGA_GROUP_POOL.alice] = true },
    pos = { x = 5, y = 0 },
    config = {extra = {rank_drop = 1, chips = 0}},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
            return {
                chip_mod = card.ability.extra.chips*G.GAME.alice_multiplier,
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips*G.GAME.alice_multiplier}}
            }
        end
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint then
            if context.individual and context.cardarea == G.play then
                if not context.other_card.debuff then
                    local temp = context.other_card
                    if not SMODS.has_no_rank(temp) and temp:get_id() ~= 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for _ = 1, G.GAME.alice_multiplier do
                                    if temp:get_id() == 2 then break end
                                    assert(SMODS.modify_rank(temp, -card.ability.extra.rank_drop))
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
                    if not SMODS.has_no_rank(temp) and temp:get_id() == 2 then
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
        if not from_debuff then
            Sagatro.progress_storyline("cry_into_flood", "add", self.saga_group, G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("cry_into_flood"))
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "kid_gloves_and_fan"}
        end
        local ret = {vars = {card.ability.extra.rank_drop*G.GAME.alice_multiplier}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            ret.vars[#ret.vars+1] = card.ability.extra.chips*G.GAME.alice_multiplier
        end
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
                { ref_table = "card.joker_display_values", ref_value = "plus", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS }
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
                card.joker_display_values.ranks_per_decrease = card.ability.extra.rank_drop*G.GAME.alice_multiplier
                card.joker_display_values.plus = G.GAME.story_mode and "+" or ""
                card.joker_display_values.chips = G.GAME.story_mode and card.ability.extra.chips*G.GAME.alice_multiplier or ""
            end,
        }
    end,
}

local dodo_bird = {
    key = "dodo_bird",
    name = "Dodo Bird",
    artist_credits = {"amy"},
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
            if not context.other_joker.ability.inactive then
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
        end
        if context.forcetrigger then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult*G.GAME.alice_multiplier}},
                Xmult_mod = card.ability.extra.xmult*G.GAME.alice_multiplier
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("cry_into_flood", "finish", self.saga_group, G.GAME.interwoven_storyline)
            if next(SMODS.find_card("j_sgt_white_rabbit", true)) then
                Sagatro.progress_storyline("white_rabbit_house", "add", self.saga_group, G.GAME.interwoven_storyline)
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("white_rabbit_house", "remove", self.saga_group, G.GAME.interwoven_storyline)
            if Sagatro.event_check("white_rabbit_house", nil, true) then
                Sagatro.progress_storyline("game_over", "force_add", self.saga_group, G.GAME.interwoven_storyline)
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("cry_into_flood", nil, {contain = true})
        and Sagatro.event_check("white_rabbit_house", nil, true))
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
                return { x_mult = (card.ability.set == "Joker" and not card.ability.inactive and G.GAME.current_round.hands_left <= 1 and G.GAME.current_round.discards_left == 0 and mod_joker:can_calculate() and (mod_joker.ability.extra.xmult*G.GAME.alice_multiplier) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
            end
        }
    end,
}

local unlabeled_bottle = {
    key = "unlabeled_bottle",
    name = "Unlabeled Bottle",
    artist_credits = {"amy"},
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
                    Sagatro.progress_storyline("little_bill", "add", self.saga_group, G.GAME.interwoven_storyline)
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
        Sagatro.progress_storyline("white_rabbit_house", "finish", self.saga_group, G.GAME.interwoven_storyline)
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("white_rabbit_house", nil, {contain = true})
        and Sagatro.event_check("little_bill", false))
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
    artist_credits = {"amy"},
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
            return Sagatro.event_check("little_bill")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_eat_me"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_eat_me"]
        end
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("little_bill"))
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
                if not joker_card:can_calculate() then
                    return 0
                end
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
    artist_credits = {"huycorn"},
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
        if not from_debuff then
            Sagatro.progress_storyline("huge_dog", "finish", self.saga_group, G.GAME.interwoven_storyline)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("caterpillar", "add", self.saga_group, G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.event_check("huge_dog")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("huge_dog", nil, {contain = true})
        and Sagatro.event_check("caterpillar", false))
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
                if not joker_card:can_calculate() then
                    return 0
                end
                if held_in_hand then return 0 end
                local valid_cards, all_cards = 0, 0
                for _, playing_card in ipairs(scoring_hand or {}) do
                    all_cards = all_cards + 1
                    if playing_card:get_id() == 2 or playing_card:get_id() == 14 then
                        valid_cards = valid_cards + 1
                    end
                end
                if all_cards == 0 then valid_cards = 1 end
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
    artist_credits = {"huycorn", "amy"},
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
                        local mushroom = SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_mushroom",
                            edition = card.edition and card.edition.key or nil,
                            stickers = card.ability.sgt_mirrored and {"sgt_mirrored"} or nil,
                            force_stickers = card.ability.sgt_mirrored and true or nil,
                        })
                        if card.ability.pumpkin_edition then
                            mushroom.ability.pumpkin_edition = true
                        end
                        return true
                    end
                }))
                Sagatro.self_destruct(card)
                Sagatro.progress_storyline("caterpillar", "finish", self.saga_group, G.GAME.interwoven_storyline)
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
            return Sagatro.event_check("caterpillar")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS["j_sgt_mushroom"] then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_mushroom"]
        end
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("caterpillar"))
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
    artist_credits = {"huycorn"},
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
                    local game_over = Sagatro.event_check("pig_and_pepper", nil, {contain = true})
                    Sagatro.progress_storyline("pig_and_pepper", "add", self.saga_group, G.GAME.interwoven_storyline)
                    if Sagatro.event_check("mad_hatter") then -- allows leniency (you don't have to take March Hare and Dormouse)
                        Sagatro.progress_storyline("the_party", "force_finish", self.saga_group, G.GAME.interwoven_storyline)
                        Sagatro.progress_storyline("red_queen", "add", self.saga_group, G.GAME.interwoven_storyline)
                        game_over = false
                    end
                    if card.ability.extra - 1 <= 0 then
                        if game_over then
                            Sagatro.progress_storyline("game_over", "force_add", self.saga_group, G.GAME.interwoven_storyline)
                        end
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
                    local game_over = Sagatro.event_check("pig_and_pepper", nil, {contain = true})
                    Sagatro.progress_storyline("pig_and_pepper", "add", self.saga_group, G.GAME.interwoven_storyline)
                    if Sagatro.event_check("mad_hatter") then -- allows leniency (you don't have to take March Hare and Dormouse)
                        Sagatro.progress_storyline("the_party", "force_finish", self.saga_group, G.GAME.interwoven_storyline)
                        Sagatro.progress_storyline("red_queen", "add", self.saga_group, G.GAME.interwoven_storyline)
                        game_over = false
                    end
                    if card.ability.extra - 1 <= 0 then
                        if game_over then
                            Sagatro.progress_storyline("game_over", "force_add", self.saga_group, G.GAME.interwoven_storyline)
                        end
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
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("caterpillar", nil, {contain = true})
        and Sagatro.event_check("pig_and_pepper", false))
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
    artist_credits = {"amy"},
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
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint) or context.forcetrigger then
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
    artist_credits = {"huycorn"},
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
                if Sagatro.event_check("goodbye_frog", false) then
                    Sagatro.progress_storyline("pig_and_pepper", "finish", self.saga_group, G.GAME.interwoven_storyline)
                    Sagatro.progress_storyline("goodbye_frog", "add", self.saga_group, G.GAME.interwoven_storyline)
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
        G.consumeables:change_size(card.ability.consumable_slot*G.GAME.alice_multiplier)
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
        G.consumeables:change_size(-1*card.ability.consumable_slot*G.GAME.alice_multiplier)
        -- return true end }))
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.event_check("pig_and_pepper")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("pig_and_pepper"))
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
    artist_credits = {"huycorn"},
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
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.odds = card.ability.value_shift_init[2][1]
        card.ability.extra.xmult = card.ability.value_shift_init[2][2]
    end,
    calculate = function(self, card, context)
        if context.sgt_stay_flipped and context.trigger == card
        and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card:juice_up(0.7)
        end
        if context.sgt_played_cards and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            card.ability.extra.card_list = {}
            for i = 1, #context.sgt_played_cards do
                if context.sgt_played_cards[i].facing == 'back' then
                    table.insert(card.ability.extra.card_list, context.sgt_played_cards[i])
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
        if context.end_of_round and not context.game_over and context.main_eval
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
            return Sagatro.event_check("goodbye_frog")
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
    artist_credits = {"huycorn"},
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
        card.ability.extra.odds = Sagatro.event_check("goodbye_frog") and 1 or 3
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval and not context.game_over and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, 'cheshire_cat_vanish', 1, card.ability.extra.odds*(Sagatro.event_check("goodbye_frog") and 1 or G.GAME.alice_multiplier), "cheshire_cat") then
                Sagatro.self_destruct(card)
                if Sagatro.event_check("goodbye_frog") then
                    Sagatro.progress_storyline("goodbye_frog", "finish", self.saga_group, G.GAME.interwoven_storyline)
                    Sagatro.progress_storyline("the_party", "add", self.saga_group, G.GAME.interwoven_storyline)
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
            return Sagatro.event_check("pig_and_pepper", nil, {contain = true})
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("goodbye_frog"))
        or Sagatro.debug then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "cheshire_cat"}
        end
        local ret = {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds*(Sagatro.event_check("goodbye_frog") and 1 or G.GAME.alice_multiplier), "cheshire_cat")}}
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
                card.joker_display_values.cat_odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds*(Sagatro.event_check("goodbye_frog") and 1 or G.GAME.alice_multiplier), "cheshire_cat") } }
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
    artist_credits = {"amy"},
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
            return Sagatro.event_check("goodbye_frog")
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
    artist_credits = {"huycorn"},
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
            return Sagatro.event_check("goodbye_frog")
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
                if not joker_card:can_calculate() then
                    return 0
                end
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
    artist_credits = {"amy"},
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
        if context.retrigger_joker_check and not context.retrigger_joker then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier),
                card = card,
            }
        end
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
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
            return next(SMODS.find_card("j_sgt_the_cook", true))
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
                if not retrigger_joker:can_calculate() then
                    return 0
                end
                return retrigger_joker.ability.extra.retriggers*(not Sagatro.mod_compat.talisman and 1 or G.GAME.alice_multiplier)
            end,
        }
    end,
}

local mad_hatter = {
    key = "mad_hatter",
    name = "Mad Hatter",
    artist_credits = {"huycorn"},
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
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if card.ability then
                if card.ability.inactive and not card.ability.extra.trivial_off then
                    card.ability.extra.trivial_off = true
                    Sagatro.update_blind_amounts()
                    for k, v in pairs(G.GAME) do
                        if string.len(k) > 4 and string.find(k, "_mod")
                        and type(v) == "number" and k ~= "sgt_trivial_mod" then
                            if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                            and not table.contains(Sagatro.mad_hatter_whitelist, k)
                            then
                                G.GAME[k] = G.GAME[k]*1e18
                            end
                        end
                    end
                elseif not card.ability.inactive and card.ability.extra.trivial_off then
                    card.ability.extra.trivial_off = nil
                    Sagatro.update_blind_amounts()
                    for k, v in pairs(G.GAME) do
                        if string.len(k) > 4 and string.find(k, "_mod")
                        and type(v) == "number" and k ~= "sgt_trivial_mod" then
                            if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                            and not table.contains(Sagatro.mad_hatter_whitelist, k)
                            then
                                G.GAME[k] = G.GAME[k]/1e18
                            end
                        end
                    end
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("mad_hatter", "force_add", self.saga_group, G.GAME.interwoven_storyline)
        end
        Sagatro.update_blind_amounts()
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                and not table.contains(Sagatro.mad_hatter_whitelist, k)
                then
                    -- consider this infinitesimal, I can't find another way that wouldn't break with multiple Mad Hatters
                    G.GAME[k] = G.GAME[k]/1e18
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.progress_storyline("mad_hatter", "force_finish", self.saga_group, G.GAME.interwoven_storyline)
            if G.GAME.story_mode and not Sagatro.event_check("the_party", nil, {contain = true}) then
                Sagatro.progress_storyline("game_over", "force_add", self.saga_group, G.GAME.interwoven_storyline)
            end
        end
        Sagatro.update_blind_amounts()
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod")
            and type(v) == "number" and k ~= "sgt_trivial_mod" then
                if (k ~= "uncommon_mod" or not G.GAME.story_mode)
                and not table.contains(Sagatro.mad_hatter_whitelist, k)
                then
                    G.GAME[k] = G.GAME[k]*1e18
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.event_check("the_party") and Sagatro.event_check("mad_hatter", false)
        end
        return not G.GAME.won
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("the_party", nil, true))
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
    artist_credits = {"huycorn"},
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
        return next(Sagatro.find_active_card("j_sgt_mad_hatter")) or not G.GAME.story_mode, {allow_duplicates = true}
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
    name = "Teapot",
    artist_credits = {"huycorn"},
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
        return next(Sagatro.find_active_card("j_sgt_mad_hatter")) or not G.GAME.story_mode, {allow_duplicates = true}
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
    name = "Sugarcube",
    artist_credits = {"huycorn"},
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
        return next(Sagatro.find_active_card("j_sgt_mad_hatter")) or not G.GAME.story_mode, {allow_duplicates = true}
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
    artist_credits = {"amy"},
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
                return nil, true
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
            return Sagatro.event_check("mad_hatter")
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
    artist_credits = {"amy"},
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
            return Sagatro.event_check("mad_hatter")
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
    artist_credits = {"huycorn"},
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
                if v ~= card and not SMODS.is_eternal(v, card) then
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
        if context.first_hand_drawn and not context.blueprint and not context.retrigger_joker and #G.jokers.cards == 1 then
            Sagatro.progress_storyline("game_over", "force_add", self.saga_group, G.GAME.interwoven_storyline)
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
            return Sagatro.event_check("red_queen")
        end
        return not G.GAME.red_queen_blind
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("red_queen"))
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
    artist_credits = {"huycorn"},
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
        if G.GAME.relief_factor >= 25 and Sagatro.event_check("red_queen") then
            if next(SMODS.find_card("j_sgt_flamingo", true)) then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center_key == "j_sgt_red_queen" then
                        v:set_eternal(nil)
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_amnestied_ex'), colour = Sagatro.badge_colour, instant = true})
                    end
                end
            end
            Sagatro.progress_storyline("red_queen", "finish", self.saga_group, G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("gryphon", "add", self.saga_group, G.GAME.interwoven_storyline)
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
    artist_credits = {"amy"},
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
        if G.GAME.relief_factor >= 25 and Sagatro.event_check("red_queen") then
            if next(SMODS.find_card("j_sgt_king", true)) then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center_key == "j_sgt_red_queen" then
                        v:set_eternal(nil)
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_amnestied_ex'), colour = Sagatro.badge_colour, instant = true})
                    end
                end
            end
            Sagatro.progress_storyline("red_queen", "finish", self.saga_group, G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("gryphon", "add", self.saga_group, G.GAME.interwoven_storyline)
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
    artist_credits = {"amy"},
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
            return Sagatro.event_check("gryphon")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.event_check("gryphon"))
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
    artist_credits = {"huycorn"},
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
        if not from_debuff and Sagatro.event_check("gryphon") then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_trial_begins'), colour = G.C.RED, instant = true})
            Sagatro.progress_storyline("gryphon", "finish", self.saga_group, G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("final_showdown", "add", self.saga_group, G.GAME.interwoven_storyline)
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
    artist_credits = {"amy"},
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
        if not from_debuff then
            Sagatro.init_storyline(self.saga_group)
        end
        if G.STAGE == G.STAGES.RUN then
            G.GAME.alice_multiplier = G.GAME.alice_multiplier*card.ability.extra
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key == "j_sgt_frog_footman" then
                    -- G.E_MANAGER:add_event(Event({trigger = "immediate", func = function()
                    G.consumeables:change_size(G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
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
                    G.consumeables:change_size(G.GAME.alice_multiplier-v.ability.alice_mult_buffer)
                    -- return true end }))
                    v.ability.alice_mult_buffer = G.GAME.alice_multiplier
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group) and not G.GAME.invsersed_scaling
        end
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
    artist_credits = {"huycorn"},
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
                return nil, true
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
        if context.joker_main or context.forcetrigger then
            for i = 1, #context.scoring_hand do
                local temp = context.scoring_hand[i]
                if temp:get_id() == 11 or context.forcetrigger then
                    return {
                        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
                    return nil, true
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
    atlas = "misc_jokers",
    saga_group = "aladdin_and_the_magic_lamp",
    order = 1004,
    pos = { x = 2, y = 0 },
    config = {buffed = false, extra = {tax = 0.25, xmult = 1, xmult_mod = 0.25, chips = 0}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if not card.ability.buffed then
            if (context.end_of_round and not context.game_over and context.main_eval
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
                    return nil, true
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            card.ability.magic_lamp_rounds = card.ability.magic_lamp_rounds + 1
            if (card.ability.magic_lamp_rounds >= card.ability.extra.rounds_goal) or context.forcetrigger then
                local has_aladdin = false
                for _, v in ipairs(G.jokers.cards) do
                    if (v.config.center_key == "j_sgt_aladdin") or context.forcetrigger then
                        has_aladdin = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "immediate",
                            func = function()
                                local genie = SMODS.add_card({
                                    set = "Joker",
                                    skip_materialize = true,
                                    key = "j_sgt_lamp_genie",
                                    edition = card.edition and card.edition.key or nil,
                                    stickers = card.ability.sgt_mirrored and {"sgt_mirrored"} or nil,
                                    force_stickers = card.ability.sgt_mirrored and true or nil,
                                })
                                if card.ability.pumpkin_edition then
                                    genie.ability.pumpkin_edition = true
                                end
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
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_aladdin"]
            info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_lamp_genie"]
        end
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "aladdin_and_the_magic_lamp",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 1006,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 2, y = 0, sgt_extra = { x = 1, y = 0 } },
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
            if not (card.ability.from_wish_card or card.ability.inactive) then
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
        if not (card.ability.from_wish_card or card.ability.inactive or G.SETTINGS.paused) then
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
                if not retrigger_joker:can_calculate() then
                    return 0
                end
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
    artist_credits = {"amy"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    saga_difficulty = 4,
    order = 61,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL.story_starter] = true},
    pos = { x = 0, y = 0 },
    config = {extra = {mult = 8}},
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
        if not from_debuff then
            if G.GAME.story_mode and not (Sagatro.storyline_check("none") or Sagatro.storyline_check(self.saga_group)) then
                local func = function()
                    card_eval_status_text(card, 'extra', nil, 1, nil, {message = localize('k_not_allowed_ex'), sound = "tarot1", volume = 1, instant = true})
                    ease_dollars(card.cost)
                end
                Sagatro.self_destruct(card, {no_destruction_context = true, no_sound = true}, func)
                return
            end
            Sagatro.init_storyline(self.saga_group)
            Sagatro.progress_storyline("finding_the_submarine", "add", self.saga_group, G.GAME.interwoven_storyline)
            G.GAME.submarine_hint_to_progress = Sagatro.storyline_check(self.saga_group) or nil
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return (Sagatro.storyline_check("none") and args.source == "buf") or Sagatro.storyline_check(self.saga_group)
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_splash"]
        if Sagatro.storyline_check(self.saga_group) and not next(SMODS.find_card("j_sgt_submarine", true)) then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "lincoln_ship"}
        end
        if Sagatro.storyline_check("none") or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers and not card.displaying_save) then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "storyline_start",
            specific_vars = {localize('ph_20k'), self.saga_difficulty, colours = {G.C.SAGA_DIFFICULTY[self.saga_difficulty]}}, title = localize("saga_storyline_start")}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "20k_miles_under_the_sea_mech", title = localize("saga_mechanic")}
        end
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
    artist_credits = {"huycorn"},
    atlas = "submarine",
    saga_group = "20k_miles_under_the_sea",
    order = 68,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 0 },
    extra_pos = { x = 0, y = 9 },
    config = {
        immutable = {
            depth_level = 1, old_depth_level = 1, armor_level = 1,
            states = {
                fuel_left = 6.5,
                max_fuel = 10.0,
                hunger_left = 6.5,
                max_hunger = 10.0,
            }
        },
        extra = {
            joker_slot = 2, consumable_slot = 2, hand_size = 2,
            joker_slot_story_mode = 0,
            consumable_slot_story_mode = 1,
            hand_size_story_mode = 0,
        }
    },
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.anim_dt = 0
        card.ability.anim_pos = { x = 0, y = 0 }
        card.ability.anim_transition_path = 0
        card.ability.in_transition = false
    end,
    calculate = function(self, card, context)
        if Sagatro.storyline_check(self.saga_group) then
            if not (context.blueprint or context.retrigger_joker) then
                if context.ante_change and context.ante_end then
                    Sagatro.resolve_fuel(-1)
                elseif context.reroll_shop then
                    Sagatro.resolve_fuel(-0.2)
                elseif context.open_booster or (context.buying_card and context.card.ability.set == "Voucher") then
                    Sagatro.resolve_fuel(-0.1)
                end
                if context.after then
                    G.E_MANAGER:add_event(Event({func = function()
                        Sagatro.resolve_hunger(-0.1*#context.full_hand)
                    return true end }))
                elseif context.discard or (context.buying_card and context.card.ability.set ~= "Voucher") then
                    Sagatro.resolve_hunger(-0.05)
                end
                if context.retrigger_joker_check
                and card.ability.immutable.states.nourished then
                    local leftmost_fish = nil
                    for _, v in ipairs(G.jokers.cards) do
                        if v.ability.immutable
                        and v.ability.immutable.weight_level then
                            leftmost_fish = v
                            break
                        end
                    end
                    if context.other_card == leftmost_fish then
                        return {
                            message = localize("k_again_ex"),
                            repetitions = 1,
                            card = card,
                        }
                    end
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not G.GAME.story_mode then
            G.jokers:change_size(card.ability.extra.joker_slot)
            G.consumeables:change_size(card.ability.extra.consumable_slot)
            G.hand:change_size(card.ability.extra.hand_size)
        end
        if Sagatro.storyline_check(self.saga_group) and not from_debuff then
            G.GAME.supply_rate = 4
            G.GAME.fish_vars = true
            G.GAME.pending_fish_var_tooltip_removal = 2
            G.GAME.submarine_hint_to_progress = true
            SMODS.debuff_card(card, "prevent_debuff", "j_sgt_submarine")
            G.jokers:change_size(card.ability.extra.joker_slot_story_mode)
            G.consumeables:change_size(card.ability.extra.consumable_slot_story_mode)
            G.hand:change_size(card.ability.extra.hand_size_story_mode)
            Sagatro.progress_storyline("finding_the_submarine", "finish", self.saga_group, G.GAME.interwoven_storyline)
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not G.GAME.story_mode then
            G.jokers:change_size(-card.ability.extra.joker_slot)
            G.consumeables:change_size(-card.ability.extra.consumable_slot)
            G.hand:change_size(-card.ability.extra.hand_size)
        end
        if Sagatro.storyline_check(self.saga_group) and not from_debuff then
            G.jokers:change_size(-card.ability.extra.joker_slot_story_mode)
            G.consumeables:change_size(-card.ability.extra.consumable_slot_story_mode)
            G.hand:change_size(-card.ability.extra.hand_size_story_mode)
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
            card.ability.anim_dt = card.ability.anim_dt + dt/G.SPEEDFACTOR
            card.ability.anim_transition_path = card.ability.immutable.old_depth_level - card.ability.immutable.depth_level
            if card.ability.anim_dt > 0.125 then
                card.ability.anim_dt = card.ability.anim_dt - 0.125
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
                    card.ability.transition_finished = true
                    card.ability.immutable.old_depth_level = card.ability.immutable.depth_level
                    card.ability.anim_transition_path = card.ability.immutable.old_depth_level - card.ability.immutable.depth_level
                else
                    card.ability.anim_pos.x = card.ability.anim_pos.x + 1
                end
                local pending_up = 0
                if card.ability.anim_transition_path ~= 0 then
                    if card.ability.anim_transition_path > 0 and not card.ability.in_transition then
                        pending_up = 1
                    end
                else
                    if G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED and card.ability.transition_finished then
                        G.P_CENTERS.j_sgt_seawater.pos.x = card.ability.immutable.depth_level - 1
                        for _, seawater in ipairs(SMODS.find_card("j_sgt_seawater", true)) do
                            seawater.children.center:set_sprite_pos(G.P_CENTERS.j_sgt_seawater.pos)
                        end
                        card.ability.transition_finished = nil
                        ease_background_colour_blind(G.STATE)
                    end
                end
                card.ability.anim_pos.y = (math.min(card.ability.immutable.old_depth_level, card.ability.immutable.depth_level) - 1 + pending_up)
                + (card.ability.in_transition and 5 or 0)
                card.children.center:set_sprite_pos(card.ability.anim_pos)
            end
            if card.children.movement_buttons then
                card.children.movement_buttons:recalculate()
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
        card = card or SMODS.Center.create_fake_card(self)
        if not (card.ability.sgt_imminent_doom or card.fake_card) then
            local states = {"low_fuel", "high_fuel", "starvation", "nourished"}
            for i = 1, #states do
                if card.ability.immutable.states[states[i]] then
                    info_queue[#info_queue+1] = {set = "Other", key = "sgt_"..states[i]}
                end
            end
        end
        if G.GAME.submarine_movement_cooldown then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_movement_cooldown"}
        end
        if G.GAME.ante_reduction_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "ante_reduction_tooltip", specific_vars = {G.GAME.sgt_lenient_score and 8 or 4}}
        end
        if G.GAME.submarine_hint_to_progress then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "submarine"}
        end
        local ret = {}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            ret.vars = {
                card.ability.immutable.states.fuel_left,
                card.ability.immutable.states.max_fuel,
                card.ability.immutable.states.hunger_left,
                card.ability.immutable.states.max_hunger,
                card.ability.immutable.depth_level,
                card.ability.immutable.armor_level,
                card.ability.extra.joker_slot_story_mode,
                card.ability.extra.consumable_slot_story_mode,
                card.ability.extra.hand_size_story_mode,
                colours = {
                    card.ability.immutable.states.low_fuel and G.C.RED
                    or card.ability.immutable.states.high_fuel and G.C.GREEN
                    or G.C.FILTER,
                    card.ability.immutable.states.starvation and G.C.RED
                    or card.ability.immutable.states.nourished and G.C.GREEN
                    or G.C.FILTER,
                    G.C.SUBMARINE_DEPTH[Sagatro.get_submarine_depth_colour()],
                }
            }
        else
            ret.vars = {card.ability.extra.joker_slot, card.ability.extra.consumable_slot, card.ability.extra.hand_size}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "fuel_left", colour = G.C.FILTER },
                { ref_table = "card.joker_display_values", ref_value = "slash" },
                { ref_table = "card.joker_display_values", ref_value = "max_fuel" },
                { ref_table = "card.joker_display_values", ref_value = "comma" },
                { ref_table = "card.joker_display_values", ref_value = "hunger_left", colour = G.C.FILTER },
                { ref_table = "card.joker_display_values", ref_value = "slash" },
                { ref_table = "card.joker_display_values", ref_value = "max_hunger" },
            },
            text_config = { colour = G.C.UI.TEXT_INACTIVE },
            calc_function = function(card)
                card.joker_display_values.fuel_left = G.GAME.story_mode and card.ability.immutable.states.fuel_left or ""
                card.joker_display_values.max_fuel = G.GAME.story_mode and card.ability.immutable.states.max_fuel or ""
                card.joker_display_values.hunger_left = G.GAME.story_mode and card.ability.immutable.states.hunger_left or ""
                card.joker_display_values.max_hunger = G.GAME.story_mode and card.ability.immutable.states.max_hunger or ""
                card.joker_display_values.slash = G.GAME.story_mode and "/" or ""
                card.joker_display_values.comma = G.GAME.story_mode and ", " or ""
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    text.children[1].config.colour = card.ability.immutable.states.low_fuel and G.C.RED
                    or card.ability.immutable.states.high_fuel and G.C.GREEN or G.C.FILTER
                end
                if text and text.children[5] then
                    text.children[5].config.colour = card.ability.immutable.states.starvation and G.C.RED
                    or card.ability.immutable.states.nourished and G.C.GREEN or G.C.FILTER
                end
                return false
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                local leftmost_fish = nil
                for _, v in ipairs(G.jokers.cards) do
                    if v.ability.immutable
                    and v.ability.immutable.weight_level then
                        leftmost_fish = v
                        break
                    end
                end
                return card == leftmost_fish and retrigger_joker.ability.immutable.states.nourished and 1 or 0
            end,
        }
    end,
}

local sub_engineer = {
    key = "sub_engineer",
    name = "Sub Engineer",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 62,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 0 },
    config = {amount = 1},
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_booster_limit(card.ability.amount)
        Sagatro.progress_storyline("the_sub_engineer", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_booster_limit(-card.ability.amount)
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return next(SMODS.find_card("j_sgt_submarine", true))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            info_queue[#info_queue+1] = G.P_CENTERS.p_sgt_supply
        end
        return {vars = {card.ability.amount}}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local clownfish = {
    key = "clownfish",
    name = "Clownfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 70,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 5, y = 0 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {mult = 4}},
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
                mult = card.ability.extra.mult,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.mult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 71,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 6, y = 0 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {chips = 25}},
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
                chips = card.ability.extra.chips,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.chips},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 72,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {xmult = 3}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_dolphin
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        local ret = {vars = {card.ability.extra.xmult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 73,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {every = 2, xmult = 2.25, odds = 4}},
    no_pool_flag = "white_jellyfish_pop",
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.wj_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.wj_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.wj_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            else
                if card.ability.wj_remaining == 0 then
                    local eval = function(_card) return (_card.ability.wj_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.wj_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.wj_remaining == card.ability.extra.every) or context.forcetrigger then
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "white_jellyfish")
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.wj_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.wj_remaining or card.ability.extra.every}}},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                local wj_remaining = card.ability.wj_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (wj_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { wj_remaining } }
                card.joker_display_values.x_mult = (wj_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.xmult or 1)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "white_jellyfish") } }
            end
        }
    end,
}

local red_jellyfish = {
    key = "red_jellyfish",
    name = "Red Jellyfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 74,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 2}}, extra = {every = 2, xmult = 4, odds = 32}},
    yes_pool_flag = "white_jellyfish_pop",
    no_pool_flag = "red_jellyfish_pop",
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.rj_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.rj_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.rj_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            else
                if card.ability.rj_remaining == 0 then
                    local eval = function(_card) return (_card.ability.rj_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.rj_remaining == card.ability.extra.every then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.rj_remaining == card.ability.extra.every) or context.forcetrigger then
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_jellyfish")
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.rj_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.rj_remaining or card.ability.extra.every}}},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                local rj_remaining = card.ability.rj_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (rj_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { rj_remaining } }
                card.joker_display_values.x_mult = (rj_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.xmult or 1)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_jellyfish") } }
            end
        }
    end,
}

local queen_jellyfish = {
    key = "queen_jellyfish",
    name = "Queen Jellyfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 75,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 3}}, extra = {every = 2, e_mult = 1.25, odds = 256}},
    yes_pool_flag = "red_jellyfish_pop",
    rarity = "sgt_obscure",
    cost = 15,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.qj_remaining = card.ability.extra.every
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.qj_remaining = (card.ability.extra.every-1-(G.GAME.hands_played - card.ability.hands_played_at_create))%(card.ability.extra.every+1)
            if context.blueprint then
                if card.ability.qj_remaining == card.ability.extra.every then
                    return {
                        sgt_e_mult = card.ability.extra.e_mult
                    }
                end
            else
                if card.ability.qj_remaining == 0 then
                    local eval = function(_card) return (_card.ability.qj_remaining == 0) end
                    juice_card_until(card, eval, true)
                elseif card.ability.qj_remaining == card.ability.extra.every then
                    return {
                        sgt_e_mult = card.ability.extra.e_mult
                    }
                end
            end
        end
        if (context.after and not context.blueprint and not context.retrigger_joker
        and card.ability.qj_remaining == card.ability.extra.every) or context.forcetrigger then
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "queen_jellyfish")
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.e_mult, card.ability.extra.every+1, n, d,
        localize{type = 'variable', key = (card.ability.qj_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.qj_remaining or card.ability.extra.every}}},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                local qj_remaining = card.ability.qj_remaining + (next(G.play.cards) and 1 or 0)
                card.joker_display_values.loyalty_text = localize { type = 'variable', key = (qj_remaining % (card.ability.extra.every + 1) == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { qj_remaining } }
                card.joker_display_values.e_mult = (qj_remaining % (card.ability.extra.every + 1) == 0 and card.ability.extra.e_mult or 1)
                local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "queen_jellyfish") } }
            end
        }
    end,
}

local mandarin_fish = {
    key = "mandarin_fish",
    name = "Mandarin Fish",
    artist_credits = {"kazumi"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 76,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {money = 75}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.money},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 83,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 1 },
    config = {immutable = {depth_level = 1, weight_level = 2, depth_range = {1, 1}, target_offset = 1}, extra = {mult = 0, mult_mod = 10}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode or (G.STAGE == G.STAGES.MAIN_MENU and not Sagatro.config.DisableOtherJokers) then
            card.ability.extra.mult = 10
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.forcetrigger
        and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables then return end
            local pos = Sagatro.get_pos(card)
            local joker = nil
            if pos then joker = G.jokers.cards[pos+card.ability.immutable.target_offset] end
            if joker and not card.getting_sliced
            and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
            and joker.ability.immutable and joker.ability.immutable.weight_level
            and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                local eaten_fish = joker
                eaten_fish.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if not SMODS.scale_card then
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    end
                    card:juice_up(0.8, 0.8)
                    eaten_fish:start_dissolve({G.C.RED}, true, 1.6)
                    play_sound('sgt_swallow', 0.96+math.random()*0.08, 0.7)
                return true end }))
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
                    return nil, true
                else
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 63,
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
        if (context.pre_discard and not context.blueprint and not context.retrigger_joker
        and not context.hook) or context.forcetrigger then
            card.ability.triggered = true
            if #G.hand.highlighted == 1 or context.forcetrigger then
                for _, v in ipairs(G.hand.cards) do
                    if not (v.area ~= G.hand or v.highlighted or table.contains(G.hand.highlighted, v)) then
                        G.hand.highlighted[#G.hand.highlighted+1] = v
                        v:highlight(true)
                    end
                end
                play_sound('cardSlide1')
                G.FUNCS.discard_cards_from_highlighted(nil, true)
            end
        end
        if context.hand_drawn and not context.first_hand_drawn
        and not context.blueprint and not context.retrigger_joker and card.ability.triggered then
            card.ability.triggered = nil
            table.remove_duplicate(G.discard.cards, G.discard.cards[#G.discard.cards])
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group)
        end
        return true
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
    artist_credits = {"amy"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 77,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 0, y = 2 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {money = 1}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.money},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 81,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {money = 4}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.money, localize("Jack", 'ranks'), localize("Diamonds", 'suits_plural')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 85,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 3 },
    config = {immutable = {depth_level = 2, weight_level = 3, depth_range = {1, 2}, target_offset = 1}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
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
            return { main_end = main_end,
                fish_vars = {
                    card.ability.immutable.depth_level,
                    self.rarity,
                    card.ability.immutable.weight_level,
                    card.ability.immutable.depth_range[1],
                    card.ability.immutable.depth_range[2],
                }
            }
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
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
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local squid = {
    key = "squid",
    name = "Squid",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 86,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 3 },
    config = {immutable = {depth_level = 2, weight_level = 3, depth_range = {1, 2}, target = "leftmost"}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
        local other_joker_ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
        if other_joker_ret then
            other_joker_ret.colour = G.C.FILTER
        end
        return other_joker_ret
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
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
            return { main_end = main_end,
                fish_vars = {
                    card.ability.immutable.depth_level,
                    self.rarity,
                    card.ability.immutable.weight_level,
                    card.ability.immutable.depth_range[1],
                    card.ability.immutable.depth_range[2],
                }
            }
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            get_blueprint_joker = function(card)
                return G.jokers.cards[1]
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local turtle_egg = {
    key = "turtle_egg",
    name = "Turtle Egg",
    artist_credits = {"amy"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 66,
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, "turtle_egg_hatched", 1, card.ability.extra.odds, "turtle_egg_hatch") and not G.GAME.turtle_egg_hatched then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        local bturtle = SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_baby_turtle",
                            edition = card.edition and card.edition.key or nil,
                            stickers = card.ability.sgt_mirrored and {"sgt_mirrored"} or nil,
                            force_stickers = card.ability.sgt_mirrored and true or nil,
                        })
                        if card.ability.pumpkin_edition then
                            bturtle.ability.pumpkin_edition = true
                        end
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
                    return nil, true
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
                        local bturtle = SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_baby_turtle",
                            edition = card.edition and card.edition.key or nil,
                            stickers = card.ability.sgt_mirrored and {"sgt_mirrored"} or nil,
                            force_stickers = card.ability.sgt_mirrored and true or nil,
                        })
                        if card.ability.pumpkin_edition then
                            bturtle.ability.pumpkin_edition = true
                        end
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
    artist_credits = {"amy"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 67,
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 87,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 2 },
    config = {immutable = {depth_level = 2, weight_level = 3, depth_range = {1, 2}, target = "rightmost"}, extra = {xmult = 1.5}},
    yes_pool_flag = "mature_turtle",
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end
}

local electric_eel = {
    key = "electric_eel",
    name = "Electric Eel",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 106,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 2 },
    config = {immutable = {depth_level = 4, weight_level = 3, depth_range = {3, 4}, target_offset = -1}, extra = {}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.electric_eel_info_queue_append(info_queue, Sagatro.electric_eel_info_queue)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
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
                    local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                    count = count + (joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                    and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                    and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0)
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
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local sea_angel = {
    key = "sea_angel",
    name = "Sea Angel",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 100,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 4 },
    config = {type = "Three of a Kind", immutable = {depth_level = 5, weight_level = 1, depth_range = {1, 5}}, extra = {e_mult = 1.23}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.e_mult, localize(card.ability.type, 'poker_hands')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 82,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 2}}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local blobfish = {
    key = "blobfish",
    name = "Blobfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 115,
    pools = {[SAGA_GROUP_POOL["20k"]] = true, [SAGA_GROUP_POOL["common_fish"]] = true},
    pos = { x = 5, y = 2 },
    config = {immutable = {depth_level = 5, weight_level = 2, depth_range = {4, 5}, target_offset = -1}, extra = {mult = 0, mult_mod = 3}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
        if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
            }
        end
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local ugly_blobfish = {
    key = "ugly_blobfish",
    name = "Ugly Blobfish",
    artist_credits = {"amy"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 65,
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
        return not G.GAME.story_mode
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 64,
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
                    return nil, true
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
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group)
        end
        return true
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 91,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 3 },
    config = {immutable = {depth_level = 3, weight_level = 3, depth_range = {1, 3}, target_offset = 1}, extra = {xmult = 1, xmult_mod = 0.2}, enhancement_gate = "m_lucky"},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
                    return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local coelacanthiformes = {
    key = "coelacanthiformes",
    name = "Coelacanthiformes",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 102,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 3 },
    config = {immutable = {depth_level = 3, weight_level = 3, depth_range = {2, 3}, target_offset = -1}, extra = {}},
    rarity = 3,
    cost = 7,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_death
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {localize{type = 'name_text', set = "Tarot", key = "c_death", nodes = {}}},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    text.children[1].config.colour = card.joker_display_values.active and #G.hand.highlighted == 1
                    and G.C.SECONDARY_SET.Tarot or G.C.UI.TEXT_INACTIVE
                end
                return false
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end
}

local sunfish = {
    key = "sunfish",
    name = "Sunfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 92,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 4, depth_range = {1, 3}, target_offset = 1}, extra = {}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local moonfish = {
    key = "moonfish",
    name = "Moonfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 93,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 3 },
    config = {immutable = {depth_level = 1, weight_level = 3, depth_range = {1, 3}, target_offset = -1}, extra = {}},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end
}

local swordfish = {
    key = "swordfish",
    name = "Swordfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 94,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 3, depth_range = {1, 3}, target_range = "leftward", eternal_block = true}, extra = {chips = 0, chip_mod = 24, chip_mod_mod = 3}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
                return nil, true
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.chip_mod_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local penguin = {
    key = "penguin",
    name = "Penguin",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 90,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 2, depth_range = {1, 3}, target = "rightmost"}, extra = {times = 2}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local count = 0
                if not held_in_hand then
                    count = not G.GAME.first_hand_played and G.GAME.current_round.discards_used == 0
                    and joker_card.ability.extra.times or 0
                end
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                count = held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or count
                return count
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local seal = {
    key = "seal",
    name = "Seal",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 98,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 4 },
    config = {immutable = {depth_level = 1, weight_level = 3, depth_range = {1, 4}, target_offset = -1}, type = "Flush"},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {localize(card.ability.type, 'poker_hands')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local ray = {
    key = "ray",
    name = "Ray",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 95,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 5 },
    config = {immutable = {depth_level = 2, weight_level = 3, depth_range = {1, 3}, target_offset = -1}, extra = {mult = 0, base_mult = 11}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.base_mult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local orca = {
    key = "orca",
    name = "Orca",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 96,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 5 },
    config = {immutable = {depth_level = 3, weight_level = 4, depth_range = {1, 3}, target_offset = -1}, extra = {xmult = 1, found_add = 0.3, unfound_sub = 0.15, target_rank = "Ace", target_id = 14}},
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
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
                    return nil, true
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
                        return nil, true
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
                card.ability.extra.target_rank = target.base.value
                card.ability.extra.target_id = target.base.id
                return {
                    message = localize(card.ability.extra.target_rank, "ranks")
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.found_add, card.ability.extra.unfound_sub, localize(card.ability.extra.target_rank, "ranks")},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local sperm_whale = {
    key = "sperm_whale",
    name = "Sperm Whale",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 110,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 5 },
    config = {immutable = {depth_level = 4, weight_level = 5, depth_range = {3, 4}, target_range = "leftward", eternal_block = true}, extra = {poker_hand = "High Card", amount = 5}},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_sperm_whale' or 'sperm_whale'))
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
        end
        if context.before and not context.retrigger_joker
        and G.GAME.current_round.hands_played == 0 and context.scoring_name == card.ability.extra.poker_hand then
            SMODS.smart_level_up_hand(context.blueprint_card or card, card.ability.extra.poker_hand, nil, card.ability.extra.amount)
            if not context.blueprint then
                card.ability.extra.triggered = true
            end
        end
        if context.destroy_card and context.cardarea == G.play and card.ability.extra.triggered then
            return {remove = true}
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.triggered = nil
            return true end }))
        end
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('sperm_whale'))
            return {
                message = localize(card.ability.extra.poker_hand, "poker_hands"),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {localize(card.ability.extra.poker_hand, "poker_hands"), card.ability.extra.amount},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.poker_hand = localize(card.ability.extra.poker_hand, 'poker_hands')
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local sea_urchin = {
    key = "sea_urchin",
    name = "Sea Urchin",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 88,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 2}}, extra = {odds = 15}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "sea_urchin")},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 78,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {chips = 15}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.chips*(card.ability.five_tally or 0), card.ability.extra.chips},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 97,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 5 },
    config = {immutable = {depth_level = 1, weight_level = 4, depth_range = {1, 3}, target_range = {-2, -1}}, extra = {chips = 0, eat_add = 25, eor_sub = 25}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode or (G.STAGE == G.STAGES.MAIN_MENU and not Sagatro.config.DisableOtherJokers) then
            card.ability.extra.chips = 125
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = Sagatro.get_pos(card)
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
            if #eaten_fish > 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if not SMODS.scale_card then
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.eat_add*total_addition
                    end
                    card:juice_up(0.8, 0.8)
                    for _, fish in ipairs(eaten_fish) do
                        fish:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_swallow', 0.96+math.random()*0.08, 0.7)
                return true end }))
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
                    return nil, true
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips + card.ability.extra.eat_add*total_addition}}, colour = G.C.BLUE, no_juice = true})
                end
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.chips, card.ability.extra.eat_add, card.ability.extra.eor_sub},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 104,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 5 },
    config = {immutable = {depth_level = 4, weight_level = 1, depth_range = {2, 4}}, extra = {rarity_mod = 3}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.rarity_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local nautilus = {
    key = "nautilus",
    name = "Nautilus",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 103,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 6 },
    config = {immutable = {depth_level = 3, weight_level = 1, depth_range = {2, 3}}, extra = {rank_ids = {14, 2, 3, 5, 8, 13}, count = 0}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 105,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 6 },
    config = {immutable = {depth_level = 4, weight_level = 1, depth_range = {2, 4}}, extra = {xmult = 1, spade_add = 0.5, eor_sub = 1}},
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
                if v:is_suit("Spades", nil, true) then
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
                    return nil, true
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
                if not SMODS.has_no_rank(temp) and temp:get_id() == 2 and temp:is_suit("Spades") then
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.spade_add, card.ability.extra.eor_sub},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 79,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 6 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {mult = 16}, type = "Full House"},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.mult, localize(card.ability.type, 'poker_hands')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 101,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 6 },
    config = {immutable = {depth_level = 2, weight_level = 2, depth_range = {2, 3}, target_range = {-1, 1}}, fixed_type = "Two Pair"},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {localize(card.ability.fixed_type, 'poker_hands')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local big_red_jelly = {
    key = "big_red_jelly",
    name = "Big Red Jelly",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 107,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 6 },
    config = {immutable = {depth_level = 4, weight_level = 3, depth_range = {3, 4}, target_offset = 1}, extra = {xmult = 1, xmult_mod = 0.1}},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
                    return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local narwhal = {
    key = "narwhal",
    name = "Narwhal",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 99,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 6 },
    config = {immutable = {depth_level = 4, weight_level = 4, depth_range = {1, 4}}, extra = {xmult = 1, xmult_mod = 0.2}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = Sagatro.get_pos(card)
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
            if #impaled_jokers > 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if not SMODS.scale_card then
                        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod*total_sell_cost
                    end
                    card:juice_up(0.8, 0.8)
                    for _, impaled_joker in ipairs(impaled_jokers) do
                        impaled_joker:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_narwhal_impale', 0.96+math.random()*0.08, 0.7)
                return true end }))
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
                    return nil, true
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult + card.ability.extra.xmult_mod*total_sell_cost}}, colour = G.C.RED, no_juice = true})
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 80,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 6 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 1}}, extra = {odds = 3}},
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_strength
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "seahorse")
        return {vars = {n, d, localize{type = 'name_text', set = "Tarot", key = "c_strength", nodes = {}}},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 108,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3, depth_range = {3, 4}, target_range = {-2, -1}}, extra = {dollars = 0, dollar_mod = 5, sub_per_hand = 1}},
    rarity = 3,
    cost = 9,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.GAME.story_mode or (G.STAGE == G.STAGES.MAIN_MENU and not Sagatro.config.DisableOtherJokers) then
            card.ability.extra.dollars = 15
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[1] == card then return end
            local pos = Sagatro.get_pos(card)
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
            if #eaten_fish > 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if not SMODS.scale_card then
                        card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollar_mod*total_addition
                    end
                    card:juice_up(0.8, 0.8)
                    for _, fish in ipairs(eaten_fish) do
                        fish:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_swallow', 0.96+math.random()*0.08, 0.7)
                return true end }))
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
                    return nil, true
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("$")..(card.ability.extra.dollars + card.ability.extra.dollar_mod*total_addition), colour = G.C.GOLD, no_juice = true})
                end
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
            return nil, true
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
                return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.dollars, card.ability.extra.dollar_mod, card.ability.extra.sub_per_hand},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 109,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3, depth_range = {3, 4}, target = "leftmost"}, extra = {target_ids = {10, 11, 12, 13, 14}}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {localize("k_face_cards"), localize("Ace", "ranks")},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local count = 0
                count = table.contains(joker_card.ability.extra.target_ids, playing_card:get_id())
                and JokerDisplay.calculate_joker_triggers(joker_card) or 0
                if held_in_hand then
                    local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                    count = count + (joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                    and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                    and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0)
                end
                return count
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local chimaera = {
    key = "chimaera",
    name = "Chimaera",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 111,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 7 },
    config = {immutable = {depth_level = 4, weight_level = 3, depth_range = {3, 5}}, extra = {spectral_count = 0, spectral_mod = 1, spectral_sub = 1}},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.retrigger_joker then
            if card.area == G.consumeables or G.jokers.cards[#G.jokers.cards] == card then return end
            local pos = Sagatro.get_pos(card)
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
            if #killed_jokers > 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    if not SMODS.scale_card then
                        card.ability.extra.spectral_count = card.ability.extra.spectral_count + card.ability.extra.spectral_mod*#killed_jokers
                    end
                    card:juice_up(0.8, 0.8)
                    for _, killed_joker in ipairs(killed_jokers) do
                        killed_joker:start_dissolve({G.C.RED}, true, 1.6)
                    end
                    play_sound('sgt_narwhal_impale', 0.96+math.random()*0.08, 0.7)
                return true end }))
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
                    return nil, true
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_killed_ex"), colour = G.C.SECONDARY_SET.Spectral, no_juice = true})
                end
            end
        end
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker
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
                return nil, true
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
                return nil, true
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.spectral_count, card.ability.extra.spectral_mod, card.ability.extra.spectral_sub},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 112,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {3, 5}}, extra = {retriggers = 8}},
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
                    repetitions = card.ability.extra.retriggers,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.retriggers, localize("8", "ranks"), localize("Diamonds", 'suits_plural')},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 113,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {3, 5}}, extra = {rarity_mod = 5, xmult = 20, xmult_sub = 1}},
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
            return nil, true
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.rarity_mod, card.ability.extra.xmult, card.ability.extra.xmult_sub},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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

local faceless_cusk = {
    key = "faceless_cusk",
    name = "Faceless Cusk",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 116,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 5, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {4, 5}}, extra = {xmult = 1, xmult_mod = 0.5}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for _, v in ipairs(context.full_hand) do
                if v:is_face() then
                    local last_mult = card.ability.extra.xmult
                    card.ability.extra.xmult = 1
                    if last_mult > 1 then
                        return {
                            message = localize("k_reset"),
                            card = card,
                        }
                    else return end
                end
            end
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_mod",
                })
                return nil, true
            else
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    card = card,
                }
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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

local brittle_star = {
    key = "brittle_star",
    name = "Brittle Star",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 117,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 6, y = 7 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {4, 5}}, extra = {xmult = 1.75, odds = 4}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.triggered = nil
            if #context.full_hand >= 5 then
                card.triggered = true
            end
        end
        if context.individual and context.cardarea == G.play and card.triggered then
            return {
                x_mult = card.ability.extra.xmult,
                colour = G.C.RED,
                card = card
            }
        end
        if context.destroy_card and context.cardarea == G.play and card.triggered
        and SMODS.pseudorandom_probability(card, 'brittle_cards', 1, card.ability.extra.odds, "brittle_star") then
            return {remove = true}
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "brittle_star")
        return {vars = {n, d, card.ability.extra.xmult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' and #scoring_hand >= 5 then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.xmult = card.ability.extra.xmult ^ count
            end,
        }
    end,
}

local comb_jellyfish = {
    key = "comb_jellyfish",
    name = "Comb Jellyfish",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 114,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 8 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {3, 5}}, extra = {}, suit_ge = 4},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        for _, v in pairs(SMODS.Suits) do
            card.ability.extra[v.key] = 0
        end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.triggered = nil
            -- First loop: record the suits
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_any_suit(v) then
                    card.ability.extra[v.base.suit] = card.ability.extra[v.base.suit] + 1
                end
            end
            -- Second loop: fill in missing suits with wild cards
            for _, v in ipairs(context.scoring_hand) do
                if SMODS.has_any_suit(v) then
                    Sagatro.suit_scan(card.ability.extra, v.base.suit)
                end
            end
            if Sagatro.check_suit_record(card.ability.extra, card.ability.suit_ge) then
                card.triggered = true
            end
        end
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            if card.triggered and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        assert(SMODS.add_card({
                            set = "Spectral",
                            key_append = "comb_jellyfish",
                        }))
                        G.GAME.consumeable_buffer = 0
                        for _, v in pairs(SMODS.Suits) do
                            card.ability.extra[v.key] = 0
                        end
                        return true
                    end
                }))
                return {
                    message = localize{type='variable', key='sgt_plus_spectrals', vars={1}},
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local _, count = Sagatro.check_suit_record(card.ability.extra, card.ability.suit_ge)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.suit_ge, count},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "count" },
                { text = "/" },
                { ref_table = "card.ability", ref_value = "suit_ge" },
                { text = ")" },
            },
            calc_function = function(card)
                local _, count = Sagatro.check_suit_record(card.ability.extra, card.ability.suit_ge)
                card.joker_display_values.count = count
            end,
        }
    end,
}

local lobster = {
    key = "lobster",
    name = "Lobster",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 89,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 1, y = 8 },
    config = {immutable = {depth_level = 1, weight_level = 1, depth_range = {1, 3}}, extra = {retriggers = 2}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.play then
                local first_diamond = nil
                for _, v in ipairs(context.scoring_hand) do
                    if v:is_suit("Diamonds") then first_diamond = v break end
                end
                if context.other_card == first_diamond then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = card.ability.extra.retriggers,
                        card = card,
                    }
                end
            end
            if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                local first_diamond = nil
                for _, v in ipairs(G.hand.cards) do
                    if v:is_suit("Diamonds") then first_diamond = v break end
                end
                if context.other_card == first_diamond then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = card.ability.extra.retriggers,
                        card = card,
                    }
                end
            end
        end
        if context.end_of_round and context.repetition
        and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
            local first_diamond = nil
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Diamonds") then first_diamond = v break end
            end
            if context.other_card == first_diamond then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra.retriggers,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.retriggers},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_diamond = nil
                for _, v in ipairs(scoring_hand or {}) do
                    if v:is_suit("Diamonds") then first_diamond = v break end
                end
                return playing_card == first_diamond and joker_card.ability.extra.retriggers*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local fangtooth = {
    key = "fangtooth",
    name = "Fangtooth",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 118,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 2, y = 8 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {4, 5}}, extra = {xmult = 1.5}},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
        end
        if context.discard and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.discards_used <= 0
        and #context.full_hand == 1 and not SMODS.has_no_rank(context.full_hand[1]) then
            card.ability.extra.stored_rank = context.full_hand[1].base.value
            return {remove = true}
        end
        if context.individual and context.cardarea == G.play and card.ability.extra.stored_rank then
            if not SMODS.has_no_rank(context.other_card)
            and context.other_card.base.value == card.ability.extra.stored_rank then
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
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local text = card.ability.extra.stored_rank
        and localize(card.ability.extra.stored_rank, "ranks")
        or localize("k_none")
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.xmult, text},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
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
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "stored_rank", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' and card.ability.extra.stored_rank then
                    for _, scoring_card in pairs(scoring_hand) do
                        if not SMODS.has_no_rank(scoring_card)
                        and scoring_card.base.value == card.ability.extra.stored_rank then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.xmult = card.ability.extra.xmult ^ count
                card.joker_display_values.stored_rank = card.ability.extra.stored_rank
                and localize(card.ability.extra.stored_rank, "ranks") or localize("k_none")
            end,
        }
    end,
}

local grenadier = {
    key = "grenadier",
    name = "Grenadier",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 119,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 3, y = 8 },
    config = {immutable = {depth_level = 5, weight_level = 1, depth_range = {4, 5}}},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.before and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            local ranks = {}
            local temp_ID, lowest_card = 15, nil
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    ranks[v.base.value] = (ranks[v.base.value] or 0) + 1
                    if temp_ID > v.base.id then
                        temp_ID = v.base.id
                        lowest_card = v
                    end
                end
            end
            if table.size(ranks) > 1 or context.forcetrigger then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if lowest_card then
                            lowest_card:set_seal(SMODS.poll_seal{type_key = 'grenasl', guaranteed = true}, nil, true)
                        end
                        return true
                    end,
                }))
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {
            fish_vars = {
                card.ability.immutable.depth_level,
                self.rarity,
                card.ability.immutable.weight_level,
                card.ability.immutable.depth_range[1],
                card.ability.immutable.depth_range[2],
            }
        }
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
                local _, _, scoring_hand = JokerDisplay.evaluate_hand()
                local ranks = {}
                for _, scoring_card in pairs(scoring_hand) do
                    ranks[scoring_card.base.value] = (ranks[scoring_card.base.value] or 0) + 1
                end
                card.joker_display_values.active = table.size(ranks) > 1
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local mahimahi = {
    key = "mahimahi",
    name = "Mahi-mahi",
    artist_credits = {"huycorn"},
    atlas = "20k_miles_under_the_sea",
    saga_group = "20k_miles_under_the_sea",
    order = 84,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 4, y = 8 },
    config = {immutable = {depth_level = 2, weight_level = 2, depth_range = {1, 2}, target_offset = -1}, extra = {h_mult = 8}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.immutable.eaten_weight then
            Sagatro.process_edible_fish(card, context)
        end
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.triggered = nil
            local played_ranks, held_in_hand_ranks = {}, {}
            for _, v in ipairs(context.full_hand) do
                if not SMODS.has_no_rank(v) then
                    played_ranks[v.base.value] = (played_ranks[v.base.value] or 0) + 1
                end
            end
            for _, v in ipairs(G.hand.cards) do
                if not SMODS.has_no_rank(v) then
                    held_in_hand_ranks[v.base.value] = (held_in_hand_ranks[v.base.value] or 0) + 1
                end
            end
            for k, _ in pairs(played_ranks) do
                if held_in_hand_ranks[k] then card.triggered = true break end
            end
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round and card.triggered then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                    card = card,
                }
            else
                return {
                    h_mult = card.ability.extra.h_mult,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
            if submarine then
                local i_start, i_end = self.config.immutable.depth_range[1], self.config.immutable.depth_range[2]
                for i = i_start, i_end do
                    if i == submarine.ability.immutable.depth_level then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        Sagatro.fish_loc_vars(info_queue, card)
        if G.GAME.fish_vars and Sagatro.config.ViewFishProperties then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fish_vars"}
        end
        return {vars = {card.ability.extra.h_mult},
        fish_vars = {
            card.ability.immutable.depth_level,
            self.rarity,
            card.ability.immutable.weight_level,
            card.ability.immutable.depth_range[1],
            card.ability.immutable.depth_range[2],
        }}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "h_mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local count = 0
                local triggered = false
                local playing_hand = next(G.play.cards)
                local played_ranks, held_in_hand_ranks = {}, {}
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if not SMODS.has_no_rank(playing_card) then
                            held_in_hand_ranks[playing_card.base.value] = (held_in_hand_ranks[playing_card.base.value] or 0) + 1
                        end
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    else
                        played_ranks[playing_card.base.value] = (played_ranks[playing_card.base.value] or 0) + 1
                    end
                end
                if playing_hand then
                    for _, playing_card in ipairs(G.play.cards) do
                        if playing_card.config.card and playing_card.base.value then
                            if not SMODS.has_no_rank(playing_card) then
                                played_ranks[playing_card.base.value] = (played_ranks[playing_card.base.value] or 0) + 1
                            end
                        end
                    end
                end
                for k, _ in pairs(played_ranks) do
                    if held_in_hand_ranks[k] then triggered = true break end
                end
                card.joker_display_values.h_mult = triggered and card.ability.extra.h_mult*count or 0
                card.joker_display_values.is_high_card = false
                if card.ability.immutable.eaten_weight == 3 and card.ability.immutable.eaten_type == 2 then
                    local text, _, _ = JokerDisplay.evaluate_hand()
                    if text == "High Card" then
                        card.joker_display_values.is_high_card = true
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return held_in_hand and joker_card.joker_display_values and joker_card.joker_display_values.is_high_card and first_card and playing_card == first_card
                and (joker_card.ability.immutable or {}).eaten_weight == 3 and (joker_card.ability.immutable or {}).eaten_type == 2
                and 2*JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            retrigger_joker_function = function(card, retrigger_joker)
                if card == retrigger_joker and card.ability.immutable and retrigger_joker.ability.immutable then
                    if retrigger_joker.ability.immutable.eaten_weight == 3 and retrigger_joker.ability.immutable.eaten_type == 2 then
                        return 1
                    elseif retrigger_joker.ability.immutable.eaten_weight == 4 and retrigger_joker.ability.immutable.eaten_type == 1 then
                        return 2
                    end
                end
                return 0
            end,
        }
    end,
}

local seawater = {
    key = "seawater",
    name = "Seawater",
    artist_credits = {"huycorn"},
    atlas = "seawater",
    saga_group = "20k_miles_under_the_sea",
    order = 69,
    pools = {[SAGA_GROUP_POOL["20k"]] = true},
    pos = { x = 0, y = 0 },
    config = {immutable = {depth_level = 1}},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint and not context.retrigger_joker and not context.forcetrigger then
            return {
                add_to_hand = true,
                no_retrigger = true
            }
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group)
        end
        return true
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_20k'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local nemo = {
    key = "nemo",
    name = "Cpt. Nemo",
    artist_credits = {"amy"},
    atlas = "nemo",
    saga_group = "20k_miles_under_the_sea",
    order = 120,
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
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.init_storyline(self.saga_group)
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group)
        end
        return true
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

local mirror = {
    key = "mirror",
    name = "Mirror",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    saga_difficulty = 5,
    order = 31,
    pos = { x = 0, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {type = "Pair"},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.type then
            local ranks = {}
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    ranks[v.base.value] = (ranks[v.base.value] or 0) + 1
                end
            end
            local max_count, rank = 0, nil
            for k, v in pairs(ranks) do
                if max_count < v then max_count = v; rank = k end
            end
            local i = 1
            local _card = context.scoring_hand[i]
            while _card and SMODS.has_no_rank(_card)
            and _card.base.value ~= rank do
                i = i + 1
                _card = context.scoring_hand[i]
            end
            local orig_card = _card
            i = i + 1
            _card = context.scoring_hand[i]
            while _card and SMODS.has_no_rank(_card)
            and _card.base.value ~= rank do
                i = i + 1
                _card = context.scoring_hand[i]
            end
            if _card then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:juice_up()
                        assert(SMODS.change_base(_card, orig_card.base.suit, nil))
                        return true
                    end
                }))
                return {
                    message = localize("k_smeared_ex"),
                    colour = G.C.FILTER,
                    no_retrigger = true,
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            Sagatro.init_storyline(self.saga_group, true)
            if Sagatro.storyline_check("alice_in_wonderland") then
                G.GAME.mirror_hint_to_progress = true
            elseif Sagatro.storyline_check("pocket_mirror") then
                G.GAME.show_main_storyline = true
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check("pocket_mirror") then
            return Sagatro.event_check("facing_egliette")
        end
        if G.GAME.story_mode then
            return Sagatro.storyline_check("alice_in_wonderland") and not G.GAME.won
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if (Sagatro.storyline_check("alice_in_wonderland") and not Sagatro.storyline_check(self.saga_group))
        or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers and not card.displaying_save) then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "interwoven_storyline_start",
            specific_vars = {localize('ph_alice_in_mirr'), self.saga_difficulty, colours = {G.C.SAGA_DIFFICULTY[self.saga_difficulty]}}, title = localize("saga_storyline_start")}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "alice_in_mirrorworld_mech", title = localize("saga_mechanic")}
        end
        if Sagatro.storyline_check(self.saga_group) and not Sagatro.storyline_check("pocket_mirror") then
            info_queue[#info_queue+1] = G.GAME.inversed_scaling
            and {set = "Other", key = "sgt_mirrorworld_tooltip", specific_vars = {G.GAME.switch_bonus}}
            or {set = "Other", key = "sgt_realworld_tooltip", specific_vars = {G.GAME.switch_bonus}}
        end
        if G.GAME.mirror_switch_cooldown then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_switch_cooldown"}
        end
        if G.GAME.free_reroll_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "free_reroll_tooltip", specific_vars = {Sagatro.ability.switch_bonus}}
        end
        if G.GAME.mirror_hint_to_progress then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "mirror"}
        end
        return {vars = {localize(card.ability.type, "poker_hands")}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local text, _, _ = JokerDisplay.evaluate_hand()
                local is_pair = text == card.ability.type
                card.joker_display_values.active = is_pair and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local white_pawn = {
    key = "white_pawn",
    name = "Oyster",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 32,
    pos = { x = 1, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {type = "Straight", extra_type = "Straight Flush"},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.poker_hands and next(context.poker_hands[card.ability.type]) then
            local hearts_diamonds = 0
            local target
            for _, v in ipairs(context.scoring_hand) do
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    hearts_diamonds = hearts_diamonds + 1
                    v.white_pawn_marked = hearts_diamonds == 1 or nil
                    target = hearts_diamonds == 1 and v or target
                end
            end
            if hearts_diamonds == 1 then
                card.ability.triggered = true
            elseif target then
                target.white_pawn_marked = nil
            end
        end
        if context.destroy_card and card.ability.triggered and context.destroy_card.white_pawn_marked then
            card.ability.triggered = nil
            return {remove = true}
        end
        if context.after and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.extra_type then
            local temp_ID, highest_card = 0, nil
            for _, v in ipairs(context.scoring_hand) do
                if v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
                    if not SMODS.has_no_rank(v) then
                        if temp_ID < v.base.id then
                            temp_ID = v.base.id
                            highest_card = v
                        end
                    end
                end
            end
            if highest_card then
                local percent = 1.15 - (1 - 0.999) / (1 - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if card.facing == "front" then
                            card.genuine_flip = true
                            play_sound('card1', percent)
                            card:juice_up(0.3, 0.3)
                            card:flip()
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local chess_pieces = {"j_sgt_white_rook", "j_sgt_white_knight", "j_sgt_white_bishop", "j_sgt_white_queen"}
                        local chess_piece = pseudorandom_element(chess_pieces, pseudoseed("white_pawn_promote"))
                        card:set_ability(chess_piece)
                        card:set_cost()
                        SMODS.calculate_effect({message = localize("k_promoted_ex"), colour = G.C.FILTER, instant = true}, card)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if card.genuine_flip then
                            card.genuine_flip = nil
                            card:flip()
                            play_sound('tarot2', percent, 0.6)
                        end
                        return true
                    end
                }))
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.type, "poker_hands"), localize(card.ability.extra_type, "poker_hands")}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
                local is_straight_flush = text == card.ability.extra_type
                local straight_active, straight_flush_active
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    straight_active = true
                    local hearts_diamonds = 0
                    local temp_ID, highest_card = 0, nil
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:is_suit("Hearts") or scoring_card:is_suit("Diamonds") then
                            hearts_diamonds = hearts_diamonds + 1
                        elseif is_straight_flush and scoring_card:is_suit("Spades", nil, true) or scoring_card:is_suit("Clubs", nil, true) then
                            if not SMODS.has_no_rank(scoring_card) then
                                if temp_ID < scoring_card.base.id then
                                    temp_ID = scoring_card.base.id
                                    highest_card = scoring_card
                                end
                            end
                        end
                    end
                    if hearts_diamonds ~= 1 then
                        straight_active = false
                    end
                    if highest_card then
                        straight_flush_active = true
                    end
                end
                card.joker_display_values.active = card:can_calculate()
                and (straight_active or straight_flush_active)
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local white_queen = {
    key = "white_queen",
    name = "White Queen",
    artist_credits = {"dj"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 36,
    pos = { x = 2, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 10}},
    rarity = 2,
    cost = 7,
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
                    }
                else
                    return {
                        h_mult = card.ability.extra.mult,
                    }
                end
            end
        end
        if context.joker_main then
            local hearts_diamonds, spades_clubs = 0, 0
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    hearts_diamonds = hearts_diamonds + 1
                elseif v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
                    spades_clubs = spades_clubs + 1
                end
            end
            if spades_clubs - hearts_diamonds ~= 0 then
                local difference = spades_clubs - hearts_diamonds
                return {
                    mult = card.ability.extra.mult*difference,
                }
            end
        end
        if context.forcetrigger then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local count = 0
                local hearts_diamonds, spades_clubs = 0, 0
                local mult = card.ability.extra.mult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            if playing_card:get_id() == 12 then
                                count = count + JokerDisplay.calculate_card_triggers(playing_card)
                            end
                            if playing_card:is_suit("Hearts", nil, true) or playing_card:is_suit("Diamonds", nil, true) then
                                hearts_diamonds = hearts_diamonds + 1
                            elseif playing_card:is_suit("Spades", nil, true) or playing_card:is_suit("Clubs", nil, true) then
                                spades_clubs = spades_clubs + 1
                            end
                        end
                    end
                end
                card.joker_display_values.plus = "+"
                card.joker_display_values.mult = mult*(count + spades_clubs - hearts_diamonds)
                if not card:can_calculate() then
                    card.joker_display_values.mult = 0
                end
                if card.joker_display_values.mult < 0 then
                    card.joker_display_values.plus = ""
                end
            end,
        }
    end,
}

local white_king = {
    key = "white_king",
    name = "White King",
    artist_credits = {"dj"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 37,
    pos = { x = 3, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xmult = 1.2}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if context.other_card:get_id() == 13 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                    }
                else
                    return {
                        x_mult = card.ability.extra.xmult,
                    }
                end
            end
        end
        if context.joker_main then
            local hearts_diamonds, spades_clubs = 0, 0
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    hearts_diamonds = hearts_diamonds + 1
                elseif v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
                    spades_clubs = spades_clubs + 1
                end
            end
            if hearts_diamonds == 0 then hearts_diamonds = 1 end
            if spades_clubs / hearts_diamonds ~= 0 then
                local quotient = spades_clubs / hearts_diamonds
                return {
                    x_mult = card.ability.extra.xmult*quotient,
                }
            end
        end
        if context.forcetrigger then
            return {
                x_mult = card.ability.extra.xmult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                local count = 0
                local hearts_diamonds, spades_clubs = 0, 0
                local xmult = card.ability.extra.xmult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            if playing_card:get_id() == 13 then
                                count = count + JokerDisplay.calculate_card_triggers(playing_card)
                            end
                            if playing_card:is_suit("Hearts", nil, true) or playing_card:is_suit("Diamonds", nil, true) then
                                hearts_diamonds = hearts_diamonds + 1
                            elseif playing_card:is_suit("Spades", nil, true) or playing_card:is_suit("Clubs", nil, true) then
                                spades_clubs = spades_clubs + 1
                            end
                        end
                    end
                end
                if hearts_diamonds == 0 then hearts_diamonds = 1 end
                local result = 1
                if xmult*(spades_clubs / hearts_diamonds) ~= 0 then
                    result = xmult*(spades_clubs / hearts_diamonds)
                end
                card.joker_display_values.xmult = (xmult^count)*result
                if not card:can_calculate() then
                    card.joker_display_values.xmult = 1
                end
            end,
        }
    end,
}

local live_flowers = {
    key = "live_flowers",
    name = "Tiger Lily",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 38,
    pos = { x = 4, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 20, mult_sub = 1}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult,
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.mult - card.ability.extra.mult_sub <= 0 then
                Sagatro.self_destruct(card)
                return {
                    message = localize('k_poof_ex'),
                    colour = G.C.FILTER,
                    no_retrigger = true
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_sub",
                    message_key = 'a_mult_minus',
                    colour = G.C.MULT,
                    operation = '-'
                })
                return nil, true
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_sub}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card:can_calculate()
                and card.ability.extra.mult or 0
            end,
        }
    end,
}

local ticket_checker = {
    key = "ticket_checker",
    name = "Ticket Checker",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 39,
    pos = { x = 5, y = 0 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xmult = 3}},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and table.size(G.GAME.used_vouchers) > 0) or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                card.joker_display_values.xmult = card:can_calculate()
                and table.size(G.GAME.used_vouchers) > 0 and card.ability.extra.xmult or 1
            end,
        }
    end,
}

local man_in_white = {
    key = "man_in_white",
    name = "Aged Man",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 40,
    pos = { x = 0, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 0, mult_mod = 16, mult_sub = 4}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ace_found = false
            for _, v in ipairs(context.scoring_hand) do
                if v:get_id() == 14 then
                    ace_found = true
                    break
                end
            end
            if ace_found and next(context.poker_hands["Straight"]) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    scaling_message = {
                        message = localize("k_elegant_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
                return nil, true
            else
                local prev_mult = card.ability.extra.mult
                if prev_mult ~= 0 then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_sub",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = math.max(initial - scaling, 0)
                        end,
                        scaling_message = {
                            message = localize("k_upset_ex"),
                            colour = G.C.FILTER,
                            card = card
                        }
                    })
                    return nil, true
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.mult) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_add",
                    no_message = true
                })
            end
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
        if context.other_joker and context.other_joker.config.center_key == "j_sgt_goat" then
            if Sagatro.get_pos(card) + 1 == Sagatro.get_pos(context.other_joker) then
                return {
                    xmult = 1.5,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_goat
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.mult_sub}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card:can_calculate()
                and card.ability.extra.mult or 0
            end,
            mod_function = function(card, mod_joker)
                local ret = {}
                if mod_joker:can_calculate() and card.config.center_key == "j_sgt_goat" then
                    if Sagatro.get_pos(mod_joker) + 1 == Sagatro.get_pos(card) then
                        ret.x_mult = 1.5
                    end
                end
                return ret
            end
        }
    end,
}

local goat = {
    key = "goat",
    name = "Goat",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 41,
    pos = { x = 2, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 0, mult_mod = 8, mult_sub = 2}},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local king_found = false
            for _, v in ipairs(context.scoring_hand) do
                if v:get_id() == 13 then
                    king_found = true
                    break
                end
            end
            if king_found and next(context.poker_hands["Straight"]) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    scaling_message = {
                        message = localize("k_baah_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
                return nil, true
            else
                local prev_mult = card.ability.extra.mult
                if prev_mult ~= 0 then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_sub",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = math.max(initial - scaling, 0)
                        end,
                        scaling_message = {
                            message = localize("k_baah_ex"),
                            colour = G.C.FILTER,
                            card = card
                        }
                    })
                    return nil, true
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.mult) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_add",
                    no_message = true
                })
            end
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
        if context.other_joker and context.other_joker.config.center_key == "j_sgt_beetle" then
            if Sagatro.get_pos(card) + 1 == Sagatro.get_pos(context.other_joker) then
                return {
                    xmult = 1.5,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_beetle
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.mult_sub}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card:can_calculate()
                and card.ability.extra.mult or 0
            end,
            mod_function = function(card, mod_joker)
                local ret = {}
                if mod_joker:can_calculate() and card.config.center_key == "j_sgt_beetle" then
                    if Sagatro.get_pos(mod_joker) + 1 == Sagatro.get_pos(card) then
                        ret.x_mult = 1.5
                    end
                end
                return ret
            end
        }
    end,
}

local beetle = {
    key = "beetle",
    name = "Beetle",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 42,
    pos = { x = 3, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 0, mult_mod = 4, mult_sub = 1}},
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local queen_found = false
            for _, v in ipairs(context.scoring_hand) do
                if v:get_id() == 12 then
                    queen_found = true
                    break
                end
            end
            if queen_found and next(context.poker_hands["Straight"]) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                    scaling_message = {
                        message = localize("k_bzzz_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
                return nil, true
            else
                local prev_mult = card.ability.extra.mult
                if prev_mult ~= 0 then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_sub",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = math.max(initial - scaling, 0)
                        end,
                        scaling_message = {
                            message = localize("k_bzzz_ex"),
                            colour = G.C.FILTER,
                            card = card
                        }
                    })
                    return nil, true
                end
            end
        end
        if (context.joker_main and to_big(card.ability.extra.mult) > to_big(0)) or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_add",
                    no_message = true
                })
            end
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.mult_sub}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                card.joker_display_values.mult = card:can_calculate()
                and card.ability.extra.mult or 0
            end,
        }
    end,
}

local dinah = {
    key = "dinah",
    name = "Dinah",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 53,
    pos = { x = 1, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {e_mult = 1, e_mult_mod = 0.05}},
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local targets = {}
            for _, v in ipairs(context.scoring_hand) do
                if v:get_id() == G.GAME.current_round.dinah_card.id
                and v:is_suit(G.GAME.current_round.dinah_card.suit)
                and not v.dinah_marked then
                    targets[#targets+1] = v
                    v.dinah_marked = true
                end
            end
            if next(targets) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "e_mult",
                    scalar_value = "e_mult_mod",
                    operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial + scaling*#targets
                        end,
                    scaling_message = {
                        message = localize("k_happy_ex"),
                        colour = G.C.FILTER,
                        card = card
                    }
                })
                return nil, true
            end
        end
        if (context.joker_main and to_big(card.ability.extra.e_mult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "e_mult",
                    scalar_value = "e_mult_mod",
                    no_message = true
                })
            end
            return {
                sgt_e_mult = card.ability.extra.e_mult,
            }
        end
        if context.destroy_card and context.destroy_card.dinah_marked then
            return {remove = true}
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult, card.ability.extra.e_mult_mod,
        localize(G.GAME.current_round.dinah_card.rank, 'ranks'),
        localize(G.GAME.current_round.dinah_card.suit, 'suits_plural'),
        colours = {G.C.SUITS[G.GAME.current_round.dinah_card.suit]}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "^" },
                        { ref_table = "card.joker_display_values", ref_value = "emult", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
            reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "dinah_card", colour = G.C.FILTER },
            { text = ")" },
        },
            calc_function = function(card)
                card.joker_display_values.dinah_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = {localize(G.GAME.current_round.dinah_card.rank, 'ranks'), localize(G.GAME.current_round.dinah_card.suit, 'suits_plural') } }
                card.joker_display_values.emult = card:can_calculate()
                and card.ability.extra.e_mult or 1
            end,
        }
    end,
}

local tweedledum = {
    key = "tweedledum",
    name = "Tweedledum",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 43,
    pos = { x = 4, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xmult = 1.2, xchips = 1.2}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and not card.getting_sliced
        and context.card.config.center_key == "j_sgt_white_king" then
            Sagatro.self_destruct(card)
            return {
                message = localize('k_castled_ex'),
                colour = G.C.FILTER,
                no_retrigger = true,
                no_destroy = true,
            }
        end
        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0)
            or context.other_card:get_id() == 14 then
                if context.other_card:get_id() % 2 == 0 and context.other_card:get_id() ~= 14 then
                    return {
                        Xchip_mod = card.ability.extra.xchips,
                        message = localize{type='variable', key='a_xchips', vars={card.ability.extra.xchips}}
                    }
                else
                    return {
                        Xmult_mod = card.ability.extra.xmult,
                        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}}
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                Xmult_mod = card.ability.extra.xmult,
                Xchip_mod = card.ability.extra.xchips,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_white_king
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xchips}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                },
                { text = " " },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xchips", retrigger_type = "exp" }
                    },
                    border_colour = G.C.CHIPS
                },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local xmult_count, xchips_count = 0, 0
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if (scoring_card:get_id() <= 10 and scoring_card:get_id() >= 0)
                        or scoring_card:get_id() == 14 then
                            if scoring_card:get_id() % 2 == 0 and scoring_card:get_id() ~= 14 then
                                xchips_count = xchips_count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            else
                                xmult_count = xmult_count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            end
                        end
                    end
                end
                card.joker_display_values.xmult = card.ability.extra.xmult^xmult_count
                card.joker_display_values.xchips = card.ability.extra.xchips^xchips_count
                if not card:can_calculate() then
                    card.joker_display_values.xmult = 1
                    card.joker_display_values.xchips = 1
                end
            end,
        }
    end,
}

local tweedledee = {
    key = "tweedledee",
    name = "Tweedledee",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 44,
    pos = { x = 5, y = 1 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xmult = 1.2, xchips = 1.2}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and not card.getting_sliced
        and context.card.config.center_key == "j_sgt_white_king" then
            Sagatro.self_destruct(card)
            return {
                message = localize('k_castled_ex'),
                colour = G.C.FILTER,
                no_retrigger = true,
                no_destroy = true,
            }
        end
        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0)
            or context.other_card:get_id() == 14 then
                if context.other_card:get_id() % 2 == 0 and context.other_card:get_id() ~= 14 then
                    return {
                        Xmult_mod = card.ability.extra.xmult,
                        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}}
                    }
                else
                    return {
                        Xchip_mod = card.ability.extra.xchips,
                        message = localize{type='variable', key='a_xchips', vars={card.ability.extra.xchips}}
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                Xmult_mod = card.ability.extra.xmult,
                Xchip_mod = card.ability.extra.xchips,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_white_king
        end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xchips}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                },
                { text = " " },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xchips", retrigger_type = "exp" }
                    },
                    border_colour = G.C.CHIPS
                },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local xmult_count, xchips_count = 0, 0
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if (scoring_card:get_id() <= 10 and scoring_card:get_id() >= 0)
                        or scoring_card:get_id() == 14 then
                            if scoring_card:get_id() % 2 == 0 and scoring_card:get_id() ~= 14 then
                                xmult_count = xmult_count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            else
                                xchips_count = xchips_count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                            end
                        end
                    end
                end
                card.joker_display_values.xmult = card.ability.extra.xmult^xmult_count
                card.joker_display_values.xchips = card.ability.extra.xchips^xchips_count
                if not card:can_calculate() then
                    card.joker_display_values.xmult = 1
                    card.joker_display_values.xchips = 1
                end
            end,
        }
    end,
}

local sheep = {
    key = "sheep",
    name = "Sheep",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 45,
    pos = { x = 0, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xscore = 1.08, xscore_mod = 0.01}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.after then
            if card.ability.extra.xscore - card.ability.extra.xscore_mod*(Sagatro.get_pos(card)-1) ~= 1 then
                return {
                    sgt_x_score = card.ability.extra.xscore - card.ability.extra.xscore_mod*(Sagatro.get_pos(card)-1),
                }
            end
        end
        if context.forcetrigger then
            return {
                sgt_x_score = card.ability.extra.xscore,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xscore, card.ability.extra.xscore_mod,
            card.ability.extra.xscore - card.ability.extra.xscore_mod*(Sagatro.get_pos(card)-1)}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xscore", retrigger_type = "exp" }
                    },
                    border_colour = G.C.DARK_EDITION
                }
            },
            calc_function = function(card)
                card.joker_display_values.xscore = card.ability.extra.xscore - card.ability.extra.xscore_mod*(Sagatro.get_pos(card)-1)
                if not card:can_calculate() then
                    card.joker_display_values.xscore = 1
                end
            end,
        }
    end,
}

local rocking_horse_fly = {
    key = "rocking_horse_fly",
    name = "Rocking-Horse-Fly",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 46,
    pos = { x = 1, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {type = "Two Pair"},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if next(context.poker_hands[card.ability.type]) then
                local temp_minID, lowest_card = 15, nil
                local temp_maxID, highest_card = 0, nil
                local temp_maxMult, temp_minMult = 0, 15
                for _, v in ipairs(context.scoring_hand) do
                    if not SMODS.has_no_rank(v) then
                        if temp_minID > v.base.id then
                            temp_minMult = v.base.nominal
                            temp_minID = v.base.id
                            lowest_card = v
                        end
                        if temp_maxID < v.base.id then
                            temp_maxMult = v.base.nominal
                            temp_maxID = v.base.id
                            highest_card = v
                        end
                    end
                end
                local finalMult = temp_maxMult - temp_minMult
                if (lowest_card == context.other_card or highest_card == context.other_card)
                and finalMult > 0 then
                    return {
                        mult = finalMult*2,
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                mult = 36,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.type, 'poker_hands')}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local _, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                    local temp_minID, lowest_card = 15, nil
                    local temp_maxID, highest_card = 0, nil
                    local temp_maxMult, temp_minMult = 0, 15
                    for _, scoring_card in pairs(scoring_hand) do
                        if not SMODS.has_no_rank(scoring_card) then
                            if temp_minID > scoring_card.base.id then
                                temp_minMult = scoring_card.base.nominal
                                temp_minID = scoring_card.base.id
                                lowest_card = scoring_card
                            end
                            if temp_maxID < scoring_card.base.id then
                                temp_maxMult = scoring_card.base.nominal
                                temp_maxID = scoring_card.base.id
                                highest_card = scoring_card
                            end
                        end
                    end
                    local finalMult = temp_maxMult - temp_minMult
                    if highest_card and not highest_card.debuff and highest_card.facing ~= 'back' then
                        mult = mult + finalMult*2*JokerDisplay.calculate_card_triggers(highest_card, nil, true)
                    end
                    if lowest_card and not lowest_card.debuff and lowest_card.facing ~= 'back' then
                        mult = mult + finalMult*2*JokerDisplay.calculate_card_triggers(lowest_card, nil, true)
                    end
                end
                card.joker_display_values.mult = mult
                if not card:can_calculate() then
                    card.joker_display_values.mult = 0
                end
                card.joker_display_values.localized_text = localize(card.ability.type, 'poker_hands')
            end
        }
    end,
}

local bread_and_butter_fly = {
    key = "bread_and_butter_fly",
    name = "Bread-and-Butter-Fly",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 47,
    pos = { x = 2, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {min_money = 5}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if to_big(card.ability.extra.min_money) > G.GAME.dollars + (G.GAME.dollar_buffer or 0) or context.forcetrigger then
                ease_dollars(card.ability.extra.min_money - (to_number(G.GAME.dollars) + (G.GAME.dollar_buffer or 0)))
                card_eval_status_text(card, 'dollars', card.ability.extra.min_money)
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min_money}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+$", colour = G.C.GOLD },
                { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.GOLD },
            },
            calc_function = function(card)
                card.joker_display_values.money = math.max(card.ability.extra.min_money - to_number(G.GAME.dollars), 0)
                if not card:can_calculate() then
                    card.joker_display_values.money = 0
                end
            end,
        }
    end,
}

local snap_dragon_fly = {
    key = "snap_dragon_fly",
    name = "Snap-Dragon-Fly",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 48,
    pos = { x = 3, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 12}},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
            if context.other_card:get_id() == 2 then
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
                mult = card.ability.extra.mult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local mult = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 2 then
                            mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.mult = mult
                if not card:can_calculate() then
                    card.joker_display_values.mult = 0
                end
            end
        }
    end,
}

local white_rook = {
    key = "white_rook",
    name = "Fawn",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 33,
    pos = { x = 4, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 3}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local hearts_diamonds, spades_clubs = 0, 0
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    hearts_diamonds = hearts_diamonds + 1
                elseif v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
                    spades_clubs = spades_clubs + 1
                end
            end
            if spades_clubs - hearts_diamonds ~= 0 then
                local difference = spades_clubs - hearts_diamonds
                return {
                    mult = card.ability.extra.mult*difference,
                }
            end
        end
        if context.forcetrigger then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_four_fingers
        end
        return {vars = {card.ability.extra.mult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local hearts_diamonds, spades_clubs = 0, 0
                local mult = card.ability.extra.mult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            if playing_card:is_suit("Hearts", nil, true) or playing_card:is_suit("Diamonds", nil, true) then
                                hearts_diamonds = hearts_diamonds + 1
                            elseif playing_card:is_suit("Spades", nil, true) or playing_card:is_suit("Clubs", nil, true) then
                                spades_clubs = spades_clubs + 1
                            end
                        end
                    end
                end
                card.joker_display_values.plus = "+"
                card.joker_display_values.mult = mult*(spades_clubs - hearts_diamonds)
                if not card:can_calculate() then
                    card.joker_display_values.mult = 0
                end
                if card.joker_display_values.mult < 0 then
                    card.joker_display_values.plus = ""
                end
            end,
        }
    end,
}

local white_knight = {
    key = "white_knight",
    name = "White Knight",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 34,
    pos = { x = 5, y = 2 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 3}},
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local hearts_diamonds, spades_clubs = 0, 0
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    hearts_diamonds = hearts_diamonds + 1
                elseif v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
                    spades_clubs = spades_clubs + 1
                end
            end
            if spades_clubs - hearts_diamonds ~= 0 then
                local difference = spades_clubs - hearts_diamonds
                return {
                    mult = card.ability.extra.mult*difference,
                }
            end
        end
        if context.forcetrigger then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if not card.fake_card then
            info_queue[#info_queue+1] = G.P_CENTERS.j_shortcut
        end
        return {vars = {card.ability.extra.mult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus" },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
            },
            text_config = { colour = G.C.MULT },
            calc_function = function(card)
                local hearts_diamonds, spades_clubs = 0, 0
                local mult = card.ability.extra.mult
                local playing_hand = next(G.play.cards)
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            if playing_card:is_suit("Hearts", nil, true) or playing_card:is_suit("Diamonds", nil, true) then
                                hearts_diamonds = hearts_diamonds + 1
                            elseif playing_card:is_suit("Spades", nil, true) or playing_card:is_suit("Clubs", nil, true) then
                                spades_clubs = spades_clubs + 1
                            end
                        end
                    end
                end
                card.joker_display_values.plus = "+"
                card.joker_display_values.mult = mult*(spades_clubs - hearts_diamonds)
                if not card:can_calculate() then
                    card.joker_display_values.mult = 0
                end
                if card.joker_display_values.mult < 0 then
                    card.joker_display_values.plus = ""
                end
            end,
        }
    end,
}

local white_bishop = {
    key = "white_bishop",
    name = "Daisy",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 35,
    pos = { x = 0, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {xmult = 3}},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local spades_clubs = true
            for _, v in ipairs(context.scoring_hand) do
                if not (v:is_suit("Spades", true) or v:is_suit("Clubs", true)) then
                    spades_clubs = false
                end
            end
            if spades_clubs or context.forcetrigger then
                return {
                    x_mult = card.ability.extra.xmult,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local spades_clubs = true
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if not (scoring_card:is_suit("Spades", true) or scoring_card:is_suit("Clubs", true)) then
                            spades_clubs = false
                        end
                    end
                end
                card.joker_display_values.xmult = spades_clubs and card.ability.extra.xmult or 1
                if not card:can_calculate() then
                    card.joker_display_values.xmult = 1
                end
            end,
        }
    end,
}

local jabberwock = {
    key = "jabberwock",
    name = "Jabberwock",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 54,
    pos = { x = 1, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {},
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local total_chips = 0
            for _, v in ipairs(context.scoring_hand) do
                total_chips = total_chips + v:get_chip_bonus()
                + Sagatro.get_edition_chips(v) + Sagatro.get_seal_chips(v)
            end
            return {
                x_mult = total_chips/((#context.scoring_hand)^2),
            }
        end
        if context.forcetrigger then
            return {
                x_mult = 11, -- equivalent to playing a High Card Ace
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {colours = {G.C.SGT_OBSCURE}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local total_chips = 0
                card.joker_display_values.xmult = 0
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        total_chips = total_chips + scoring_card:get_chip_bonus()
                        + Sagatro.get_edition_chips(scoring_card)
                        + Sagatro.get_seal_chips(scoring_card)
                    end
                    card.joker_display_values.xmult = total_chips/(#scoring_hand > 0 and (#scoring_hand)^2 or 1)
                end
                if card.joker_display_values.xmult == 0 or not card:can_calculate() then
                    card.joker_display_values.xmult = 1
                end
            end,
        }
    end,
}

local bandersnatch = {
    key = "bandersnatch",
    name = "Bandersnatch",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 55,
    pos = { x = 2, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {},
    rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.setting_blind and not card.getting_sliced
        and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            local target = card.area and card.area.cards[Sagatro.get_pos(card)+1]
            if target and target.ability.set == "Joker" then
                target:set_edition("e_negative")
                if not target.ability.perishable then
                    target:add_sticker("perishable", true)
                end
                return {
                    message = localize("k_roar_ex"),
                    colour = G.C.FILTER,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'e_negative', set = 'Edition', config = {extra = 1}}
        return {vars = {colours = {G.C.SGT_OBSCURE}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local jubjub_bird = {
    key = "jubjub_bird",
    name = "Jubjub Bird",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 56,
    pos = { x = 3, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {value_loss = 3},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.sgt_jjb_reduction and not context.blueprint and not context.retrigger_joker then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_value = "value_loss",
                operation = "-",
                scaling_message = {
                    message = localize('k_again_ex'),
                    colour = G.C.FILTER,
                }
            })
            card:set_cost()
            return nil, true
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.signed_dollars(card.ability.value_loss), colours = {G.C.SGT_OBSCURE}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "sell_cost", colour = G.C.GOLD },
                { text = ")" },
            },
            reminder_text_config = { scale = 0.35 },
            calc_function = function(card)
                card.joker_display_values.sell_cost = SMODS.signed_dollars(card.sell_cost)
            end,
        }
    end,
}

local humpty_dumpty = {
    key = "humpty_dumpty",
    name = "Humpty Dumpty",
    artist_credits = {"amy"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 49,
    pos = { x = 4, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {value_gain = 3, odds = 6}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.discard and not context.blueprint and not context.other_card.debuff
        and context.other_card:get_id() == G.GAME.current_round.humdum_card.id) or context.forcetrigger then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_table = card.ability.extra,
                scalar_value = "value_gain",
                scaling_message = {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            })
            card:set_cost()
            return nil, true
        end
        if context.end_of_round and not context.game_over and context.main_eval and not context.game_over and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, 'humdum_irreversible', 1, card.ability.extra.odds, "humpty_dumpty") then
                if Sagatro.storyline_check(self.saga_group) then
                    local eligible_jokers = {}
                    for _, v in ipairs(G.jokers.cards) do
                        if v.ability.set == "Joker" and not v.config.center.mirrorworld and v.config.center_key ~= "j_sgt_mirror" then
                            if v.ability.sgt_mirrored then
                                v:remove_sticker("sgt_mirrored")
                            else
                                table.insert(eligible_jokers, v)
                            end
                        end
                    end
                    local target = pseudorandom_element(eligible_jokers, pseudoseed("humpty_magic"))
                    if target then
                        target:add_sticker("sgt_mirrored", true)
                        target:juice_up()
                    end
                end
                Sagatro.self_destruct(card)
                return {
                    message = localize("k_shattered_ex"),
                    no_retrigger = true
                }
            else
                return {
                    message = localize("k_safe_ex"),
                    no_retrigger = true
                }
            end
        end
        if context.selling_self and not context.blueprint and not context.retrigger_joker then
            if Sagatro.storyline_check(self.saga_group) then
                local eligible_jokers = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v.ability.set == "Joker" and not v.config.center.mirrorworld and v.config.center_key ~= "j_sgt_mirror" then
                        if v.ability.sgt_mirrored then
                            v:remove_sticker("sgt_mirrored")
                        else
                            table.insert(eligible_jokers, v)
                        end
                    end
                end
                local target = pseudorandom_element(eligible_jokers, pseudoseed("humpty_magic"))
                if target then
                    target:add_sticker("sgt_mirrored", true)
                    target:juice_up()
                end
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        if (Sagatro.storyline_check(self.saga_group) and G.GAME.inversed_scaling)
        or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            info_queue[#info_queue+1] = {key = "sgt_mirrored", set = "Other"}
        end
        return {vars = {card.ability.extra.value_gain, localize(G.GAME.current_round.humdum_card.rank, 'ranks'),
        SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "humpty_dumpty")}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "$" },
                { ref_table = "card", ref_value = "sell_cost" },
                { text = "+$" },
                { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.GOLD },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "humdum_card_rank", colour = G.C.ORANGE },
                { text = ")" }
            },
            reminder_text_config = { scale = 0.35 },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local dollars = 0
                local hand = G.hand.highlighted
                for _, playing_card in pairs(hand) do
                    if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff
                    and playing_card:get_id() and playing_card:get_id() == G.GAME.current_round.humdum_card.id then
                        dollars = dollars + card.ability.extra.value_gain
                    end
                end
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "humpty_dumpty") } }
                card.joker_display_values.dollars = G.GAME.current_round.discards_left > 0 and card:can_calculate() and dollars or 0
                card.joker_display_values.humdum_card_rank = localize(G.GAME.current_round.humdum_card.rank, 'ranks')
            end,
        }
    end,
}

local seal_and_carpenter = {
    key = "seal_and_carpenter",
    name = "Carpenter",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 50,
    pos = { x = 5, y = 3 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.first_hand_drawn and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            G.E_MANAGER:add_event(Event({func = function()
                SMODS.destroy_cards(Sagatro.random_select("snc_destroy", G.hand, 1), nil, true)
                if not context.forcetrigger then
                    G.E_MANAGER:add_event(Event({triggger = "after", delay = 0.6, func = function()
                        save_run()
                    return true end}))
                end
            return true end}))
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local lion = {
    key = "lion",
    name = "Lion",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 51,
    pos = { x = 0, y = 4 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {times = 1, extra_times = 1}},
    rarity = 3,
    cost = 9,
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
                if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
                    valid_cards = valid_cards + 1
                end
            end
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.times + (valid_cards == all_cards and card.ability.extra.extra_times or 0),
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.times, card.ability.extra.extra_times}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "x" },
                { ref_table = "card.joker_display_values", ref_value = "retriggers", retrigger_type = "mult" },
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards) or next(G.hand.highlighted)
                local valid_cards, all_cards = 0, 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        all_cards = all_cards + 1
                        if scoring_card:is_suit("Hearts", nil, true) or scoring_card:is_suit("Diamonds", nil, true) then
                            valid_cards = valid_cards + 1
                        end
                    end
                else
                    valid_cards = 1 -- Face down cards force retrigger count to be 1
                end
                local count = playing_hand and valid_cards == all_cards
                and card.ability.extra.times+card.ability.extra.extra_times
                or card.ability.extra.times

                card.joker_display_values.retriggers = count
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if not joker_card:can_calculate() then
                    return 0
                end
                if held_in_hand then return 0 end
                local valid_cards, all_cards = 0, 0
                for _, playing_card in ipairs(scoring_hand or {}) do
                    all_cards = all_cards + 1
                    if playing_card:is_suit("Hearts", nil, true) or playing_card:is_suit("Diamonds", nil, true) then
                        valid_cards = valid_cards + 1
                    end
                end
                if all_cards == 0 then valid_cards = 1 end
                local count = valid_cards == all_cards
                and joker_card.ability.extra.times+joker_card.ability.extra.extra_times
                or joker_card.ability.extra.times
                return count * JokerDisplay.calculate_joker_triggers(joker_card)
            end,
        }
    end,
}

local unicorn = {
    key = "unicorn",
    name = "Unicorn",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 52,
    pos = { x = 1, y = 4 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {debt_amount = 0, debt_mod = 25 }},
    rarity = 3,
    cost = 7,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.debt_amount = G.GAME.skips*card.ability.extra.debt_mod
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint and not context.retrigger_joker then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "debt_amount",
                scalar_value = "debt_mod",
                scaling_message = {
                    message = "$"..(card.ability.extra.debt_amount+card.ability.extra.debt_mod),
                    colour = G.C.RED,
                }
            })
            G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt_mod
            return nil, true
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if card.ability then
                if card.ability.inactive and not card.ability.extra.debt_off then
                    card.ability.extra.debt_off = true
                    G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt_amount
                elseif not card.ability.inactive and card.ability.extra.debt_off then
                    card.ability.extra.debt_off = nil
                    G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt_amount
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt_amount
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt_amount
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.debt_amount, card.ability.extra.debt_mod}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { text = "$" },
                { ref_table = "card.ability.extra", ref_value = "debt_amount" },
            },
            text_config = { colour = G.C.RED },
        }
    end,
}

local true_red_queen = {
    key = "true_red_queen",
    name = "Red Queen",
    artist_credits = {"dj"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 58,
    pos = { x = 2, y = 4 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {type = "Straight", extra = {e_mult = 1.1}},
    rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.poker_hands and next(context.poker_hands[card.ability.type])
        and context.individual and context.cardarea == G.play and not context.forcetrigger then
            if context.other_card:is_suit("Hearts", nil, true)
            or context.other_card:is_suit("Diamonds", nil, true) then
                return {
                    sgt_e_mult = card.ability.extra.e_mult,
                }
            end
        end
        if context.forcetrigger then
            return {
                sgt_e_mult = card.ability.extra.e_mult,
            }
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling and not G.GAME.true_red_queen_blind
        end
        return not (G.GAME.story_mode or G.GAME.true_red_queen_blind)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.type, card.ability.extra.e_mult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    if poker_hands[card.ability.type] and next(poker_hands[card.ability.type]) then
                        for _, scoring_card in pairs(scoring_hand) do
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.e_mult = card:can_calculate() and card.ability.extra.e_mult^count or 1
            end,
        }
    end,
}

local red_king = {
    key = "red_king",
    name = "Red King",
    artist_credits = {"dj", "huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 59,
    pos = { x = 3, y = 4 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {odds = 2}},
    rarity = "sgt_obscure",
    cost = 14,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.ending_shop or context.forcetrigger then
            if context.forcetrigger or SMODS.pseudorandom_probability(card, 'red_king_zzz', 1, card.ability.extra.odds, "red_king") then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        assert(SMODS.add_card({
                            set = "Tarot",
                            key = "c_fool",
                            edition = "e_negative",
                        }))
                    return true
                end)}))
                return {
                    message = localize('k_zzz'),
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling and not G.GAME.red_king_blind
        end
        return not (G.GAME.story_mode or G.GAME.red_king_blind)
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        info_queue[#info_queue+1] = G.P_CENTERS.c_fool
        return {vars = {localize{type = 'name_text', set = "Tarot", key = "c_fool", nodes = {}},
        SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_king")}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "red_king") } }
            end,
        }
    end,
}

local vorpal_sword = {
    key = "vorpal_sword",
    name = "Vorpal Sword",
    artist_credits = {"huycorn"},
    atlas = "alice_in_mirrorworld",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 57,
    pos = { x = 4, y = 4 },
    pools = { [SAGA_GROUP_POOL.alice_m] = true },
    config = {extra = {mult = 0, odds = 20, sliced_beasts = {}}},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            if card.area and card.area.cards[Sagatro.get_pos(card)+1]
            and not SMODS.is_eternal(card.area.cards[Sagatro.get_pos(card)+1], card)
            and not card.area.cards[Sagatro.get_pos(card)+1].getting_sliced then
                local potential_target = card.area.cards[Sagatro.get_pos(card)+1]
                if card.ability.extra.sliced_beasts.bandersnatch_sliced and context.blind.boss
                and potential_target.config.center_key ~= "j_sgt_bandersnatch"
                and potential_target.config.center_key ~= "j_sgt_jubjub_bird"
                and potential_target.config.center_key ~= "j_sgt_jabberwock" then
                    potential_target:set_edition("e_negative")
                    return {
                        message = localize("k_sheathe_ex"),
                        no_retrigger = true,
                    }
                elseif (potential_target.config.center_key == "j_sgt_bandersnatch"
                or potential_target.config.center_key == "j_sgt_jubjub_bird"
                or potential_target.config.center_key == "j_sgt_jabberwock") then
                    card.temp_paused = true
                    card.ability.extra.obscure_bloodshed = true
                    for k, _ in pairs(card.ability.extra.sliced_beasts) do
                        card.ability.extra.sliced_beasts[k] = nil
                    end
                    card.ability.extra.sliced_beasts[potential_target.config.center_key:sub(7).."_sliced"] = true
                    card.ability.extra.jubjub_odds = 20
                    potential_target.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card:juice_up(0.8, 0.8)
                        potential_target:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                    return {
                        message = localize("k_bloodshed_ex"),
                        colour = G.C.RED,
                    }
                elseif not card.ability.extra.obscure_bloodshed then
                    potential_target.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card:juice_up(0.8, 0.8)
                        potential_target:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_table = potential_target,
                        scalar_value = "sell_cost",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial + 8*scaling
                        end,
                        scaling_message = {
                            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult+8*potential_target.sell_cost}},
                            colour = G.C.RED,
                            no_juice = true
                        }
                    })
                    return nil, true
                end
            end
        end
        if context.sgt_jjb_reduction and not context.blueprint and not context.retrigger_joker
        and card.ability.extra.sliced_beasts.jubjub_bird_sliced then
            if SMODS.pseudorandom_probability(card, 'vorpal_jubjub_poof', 1, card.ability.extra.odds, "vorpal") then
                Sagatro.self_destruct(card)
                return {
                    message = localize("k_poof_ex"),
                    colour = G.C.FILTER,
                }
            else
                card.ability.extra.odds = card.ability.extra.odds - 1
                return {
                    message = localize('k_again_ex'),
                    colour = G.C.FILTER,
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.obscure_bloodshed then
                if card.ability.extra.sliced_beasts.jabberwock_sliced then
                    local total_chips = 0
                    for _, v in ipairs(G.hand.cards) do
                        total_chips = total_chips + v:get_chip_bonus()
                        + Sagatro.get_edition_chips(v) + Sagatro.get_seal_chips(v)
                    end
                    local final_xmult = total_chips/((#context.scoring_hand)^2)
                    if final_xmult == 0 then final_xmult = 1 end
                    if final_xmult ~= 1 then
                        return {
                            x_mult = final_xmult,
                        }
                    end
                end
            elseif card.ability.extra.mult > 0 then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        for k, _ in pairs(card.ability.extra.sliced_beasts) do
            local info = {set = "Other", key = k}
            if k == "jubjub_bird_sliced" then
                info.specific_vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "vorpal")}
            end
            info_queue[#info_queue+1] = info
        end
        return {key = card.ability.extra.obscure_bloodshed and "j_sgt_vorpal_sword_bloodshed" or nil,
        vars = {card.ability.extra.mult, colours = {G.C.SGT_OBSCURE}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            extra = {
                {
                    { ref_table = "card.joker_display_values", ref_value = "open_bracket" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { ref_table = "card.joker_display_values", ref_value = "close_bracket" },
                }
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "times" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                local jabber, bander, jubjub =
                card.ability.extra.sliced_beasts.jabberwock_sliced and card:can_calculate(),
                card.ability.extra.sliced_beasts.bandersnatch_sliced and card:can_calculate(),
                card.ability.extra.sliced_beasts.jubjub_bird_sliced and card:can_calculate()
                local normal = not (jabber or bander or jubjub) and card:can_calculate()
                card.joker_display_values.open_bracket = jubjub and "(" or ""
                card.joker_display_values.odds = jubjub
                and localize { type = 'variable', key = "jdis_odds", vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "vorpal") } }
                or ""
                card.joker_display_values.close_bracket = jubjub and ")" or ""
                card.joker_display_values.plus = normal and "+" or ""
                card.joker_display_values.mult = normal and card.ability.extra.mult or ""
                card.joker_display_values.times = jabber and "X" or ""
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local total_chips = 0
                local xmult = 0
                local playing_hand = next(G.play.cards)
                if text ~= 'Unknown' then
                    for _, playing_card in ipairs(G.hand.cards) do
                        if playing_hand or not playing_card.highlighted then
                            total_chips = total_chips + playing_card:get_chip_bonus()
                            + Sagatro.get_edition_chips(playing_card)
                            + Sagatro.get_seal_chips(playing_card)
                        end
                    end
                    xmult = total_chips/(#scoring_hand > 0 and (#scoring_hand)^2 or 1)
                end
                if xmult == 0 then
                    xmult = 1
                end
                card.joker_display_values.xmult = jabber and xmult or ""
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[3] then
                    text.children[3].config.colour =
                    card.ability.extra.sliced_beasts.jabberwock_sliced and card:can_calculate()
                    and G.C.MULT or G.C.CLEAR
                end
                return false
            end,
        }
    end
}

local ecila = {
    key = "ecila",
    name = "Ecila",
    artist_credits = {"amy"},
    atlas = "ecila",
    saga_group = "alice_in_mirrorworld",
    mirrorworld = true,
    order = 60,
    pos = { x = 0, y = 0 },
    pools = { [SAGA_GROUP_POOL.legend] = true },
    soul_pos = { x = 1, y = 0 },
    config = {extra = {xmult = 3}},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.other_joker and not context.forcetrigger then
            if context.other_joker.config.center.saga_group == "alice_in_mirrorworld" then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
        if context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if Sagatro.storyline_check("alice_in_wonderland") and not from_debuff then
            Sagatro.init_storyline(self.saga_group, true)
        end
    end,
    in_pool = function(self, args)
        if Sagatro.storyline_check(self.saga_group) then
            return G.GAME.inversed_scaling
        end
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_alice_in_mirr'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            mod_function = function(card, mod_joker)
                return { x_mult = card.config.center.saga_group == "alice_in_mirrorworld" and card:can_calculate() and mod_joker.ability.extra.xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil }
            end
        }
    end,
}

local goldia = {
    key = "goldia",
    name = "Goldia",
    artist_credits = {"huycorn", "amy"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    saga_difficulty = 5,
    order = 121,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 4 },
    soul_pos = { x = 2, y = 4, sgt_extra = { x = 1, y = 4, no_scale = true }, name_tag = { x = 3, y = 4 } },
    config = {immutable = {dt = 0, stage = 0, tolerance_index = 0}, extra = {
        stage0_mult = 2, stage0_mult_xmod = 2,
        full_queen_xmult = 2, full_glass_xmult = 2,
    }, shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.stage0_mult =
        card.ability.extra.stage0_mult*math.floor(2^(G.GAME.round_resets.ante + (G.GAME.ante_reduced or 0)))
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.retrigger_joker then
            if context.setting_blind and not card.getting_sliced then
                if Sagatro.event_check("entering_mirror_maze") and not G.GAME.entering_mirror_maze then
                    G.GAME.entering_mirror_maze = true
                    Sagatro.progress_storyline("entering_mirror_maze", "finish", self.saga_group, G.GAME.inverwoven_storyline)
                    Sagatro.progress_storyline("mirror_maze", "add", self.saga_group, G.GAME.inverwoven_storyline)
                    for _, v in ipairs(G.playing_cards) do
                        v.ability.old_enh = v.config.center_key
                        v.ability.old_edition = v.edition and v.edition.key or nil
                        v.ability.old_seal = v.seal
                        v:set_ability("m_sgt_mirror")
                        if v.ability.old_edition then v:set_edition(nil, nil, true) end
                        if v.ability.old_seal then v:set_seal(nil, true) end
                    end
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                        ease_background_colour_blind(G.STATE)
                    return true end }))
                end
                if Sagatro.event_check("harpae_patience", nil, {contain = true})
                and not (Sagatro.event_check("dull_glass") or Sagatro.event_check("dull_glass", nil, {contain = true})) then
                    Sagatro.progress_storyline("dull_glass", "add", self.saga_group, G.GAME.interwoven_storyline)
                    for _, v in ipairs(G.playing_cards) do
                        v.ability.old_enh = v.config.center_key
                        v.ability.old_edition = v.edition and v.edition.key or nil
                        v.ability.old_seal = v.seal
                        v:set_ability("m_sgt_mirror")
                        if v.ability.old_edition then v:set_edition(nil, nil, true) end
                        if v.ability.old_seal then v:set_seal(nil, true) end
                    end
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                        ease_background_colour_blind(G.STATE)
                    return true end }))
                end
                if Sagatro.event_check("door_puzzle") and not G.GAME.door_puzzle_active then
                    G.GAME.door_puzzle_active = true
                    G.GAME.delay_door_puzzle_colour = true
                    G.GAME.shelved_chains.hand_drawn = "sgt_door_puzzle_prep"
                    if context.blind.boss then
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.blind:disable()
                        return true end }))
                    end
                end
            end
            if context.first_hand_drawn then
                if Sagatro.event_check("mirror_maze")
                and not (G.GAME.entering_mirror_maze or G.GAME.leaving_mirror_maze) then
                    G.GAME.leaving_mirror_maze = true
                    G.GAME.sgt_no_saving = true
                    Sagatro.progress_storyline("mirror_maze", "finish", self.saga_group, G.GAME.inverwoven_storyline)
                    Sagatro.progress_storyline("lisette_chase", "add", self.saga_group, G.GAME.inverwoven_storyline)
                    card:add_sticker("pinned", true)
                end
                if Sagatro.event_check("dull_glass") then
                    if card.ability.immutable.tolerance_index >= 2 and not next(SMODS.find_card("m_sgt_mirror", true)) then
                        SMODS.add_card{key = "m_sgt_mirror", area = G.jokers, edition = "e_holo"}
                    end
                end
            end
            if context.sgt_draw_from_play and Sagatro.event_check("door_puzzle") and G.GAME.door_puzzle_active then
                if SMODS.has_enhancement(context.other_card, "m_sgt_pm_door") then
                    return {
                        sgt_draw_card = {
                            to = G.hand,
                            dir = "up",
                        }
                    }
                end
            end
            if context.before then
                if Sagatro.event_check("door_puzzle") and G.GAME.door_puzzle_active then
                    local i = G.GAME.current_round.hands_played + 1
                    G.GAME.door_completed[i] = context.scoring_hand[1].ability.door_colour
                    if G.GAME.door_order[i] ~= G.GAME.door_completed[i] then
                        G.E_MANAGER:add_event(Event({func = function()
                            Sagatro.game_over("ph_dead_end_door")
                        return true end}))
                    elseif G.GAME.current_round.hands_left == 0 then
                        card.ability.immutable.plot_armor = true
                    end
                end
            end
            if context.end_of_round then
                if not context.game_over and context.main_eval then
                    if Sagatro.event_check("dull_glass") then
                        card.ability.immutable.tolerance_index = card.ability.immutable.tolerance_index or 0
                        local lisette_pos = {}
                        for _, lisette in ipairs(SMODS.find_card("j_sgt_lisette", true)) do
                            table.insert(lisette_pos, Sagatro.get_pos(lisette))
                        end
                        for _, pos in ipairs(lisette_pos) do
                            if math.abs(Sagatro.get_pos(card) - pos) == 2 then
                                card.ability.immutable.tolerance_index = card.ability.immutable.tolerance_index + 1
                                return {
                                    message = localize("k_calm_down_ex"),
                                }
                            end
                        end
                    end
                end
                if not context.individual and not context.repetition
                and context.game_over then
                    if card.ability.immutable.plot_armor then
                        if Sagatro.event_check("door_puzzle") and G.GAME.door_puzzle_active then
                            SMODS.destroy_cards(G.hand.cards, nil, true)
                            SMODS.change_play_limit((G.GAME.old_play_limit or 5) - 1)
                            card.ability.immutable.plot_armor = nil
                            G.GAME.solving_door_puzzle = nil
                            G.GAME.old_play_limit = nil
                        end
                        return {
                            saved = G.GAME.door_puzzle_active and "ph_door_solved" or "ph_plot_armor",
                        }
                    end
                end
            end
        end
        if card.ability.immutable.stage == 0 or card.ability.immutable.stage == "dawn" then
            if context.ante_change and context.ante_end
            and not context.blueprint and not context.retrigger_joker then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "stage0_mult",
                    scalar_value = "stage0_mult_xmod",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial * scaling
                    end,
                    no_message = true
                })
                return nil, true
            end
            if context.joker_main or context.forcetrigger then
                if context.forcetrigger then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "stage0_mult",
                        scalar_value = "stage0_mult_xmod",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial * scaling
                        end,
                        no_message = true
                    })
                end
                return not G.GAME.door_puzzle_active and {
                    mult = card.ability.extra.stage0_mult,
                } or nil
            end
        elseif card.ability.immutable.stage == "name_recalled" then
            if context.repetition and context.cardarea == G.play then
                if context.other_card:get_id() == 12 then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 1,
                        card = card,
                    }
                end
            end
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 12 and context.other_card:is_suit("Hearts") then
                    return {
                        xmult = card.ability.extra.full_queen_xmult,
                        extra = Sagatro.omniscient(context.other_card, {"m_glass", "m_sgt_nyx_glass"}) and
                        {xmult = card.ability.extra.full_glass_xmult} or nil,
                    }
                end
                if Sagatro.omniscient(context.other_card, {"m_glass", "m_sgt_nyx_glass"}) then
                    return {
                        xmult = card.ability.extra.full_glass_xmult,
                    }
                end
            end
            if context.forcetrigger then
                return {
                    xmult = card.ability.extra.full_queen_xmult,
                    extra = {xmult = card.ability.extra.full_glass_xmult},
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            Sagatro.init_storyline(self.saga_group)
            Sagatro.progress_storyline("the_pocket_mirror", "add", self.saga_group, G.GAME.interwoven_storyline)
            if G.GAME.story_mode then
                G.GAME.regalia_list = G.GAME.regalia_list or {}
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                    ease_background_colour_blind(G.STATE)
                return true end }))
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                Sagatro.game_over("ph_shattered_pm")
            return true end}))
        end
    end,
    update = function(self, card, dt)
        card.ability.hide_name_tag = card.ability.immutable.stage ~= "name_recalled"
        and card.ability.immutable.stage ~= "dawn" and (G.GAME.story_mode or card.displaying_save)
        if G.STAGE == G.STAGES.RUN then
            if card.area and card.area == G.jokers then
                if Sagatro.event_check("dull_glass") then
                    if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or (G.STATE == G.STATES.PLAY_TAROT and G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND)) then
                        card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                        if card.ability.immutable.dt > (120*48/135) then
                            card.ability.immutable.dt = card.ability.immutable.dt - (120*48/135)
                            local lisette = SMODS.add_card{key = "j_sgt_lisette"}
                            if Sagatro.get_pos(card) > math.floor(#G.jokers.cards/2) then
                                Sagatro.swap(lisette, "leftmost")
                            end
                        end
                    else
                        card.ability.immutable.dt = 120*48/135
                    end
                elseif Sagatro.event_check("pocket_mirror_chase") then
                    G.GAME.pm_chase = G.GAME.pm_chase or {}
                    G.GAME.pm_chase.goldia_pos = Sagatro.get_pos(card)
                    if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or (G.STATE == G.STATES.PLAY_TAROT and G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND)) then
                        card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                        if card.ability.immutable.dt > (240/170) then
                            card.ability.immutable.dt = card.ability.immutable.dt - (240/170)
                            if not card.states.drag.is and G.jokers.cards[Sagatro.get_pos(card)+1]
                            and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                            and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_enjel" then
                                Sagatro.swap(card)
                            end
                        end
                    else
                        card.ability.immutable.dt = 0
                    end
                elseif Sagatro.event_check("enjel_chase") then
                    if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or (G.STATE == G.STATES.PLAY_TAROT and G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND)) then
                        card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                        if card.ability.immutable.dt > (120/170) then
                            card.ability.immutable.dt = card.ability.immutable.dt - (120/170)
                            if not card.states.drag.is and G.jokers.cards[Sagatro.get_pos(card)+1]
                            and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                            and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_enjel" then
                                Sagatro.swap(card)
                            end
                        end
                    else
                        card.ability.immutable.dt = 0
                    end
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check("none")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if G.STAGE == G.STAGES.RUN and not card.fake_card
        and Sagatro.storyline_check(self.saga_group) then
            local events = {
                "the_pocket_mirror",
                "knife_and_fork",
                "facing_egliette",
                "pm_mirrorworld",
                "fleta_challenges",
                "entering_mirror_maze",
                "mirror_maze",
                "lisette_chase",
                "harpae_patience",
                "facing_lisette",
                "dull_glass",
            }
            for _, event in ipairs(events) do
                if G.GAME.goldia_tooltip_key then
                    info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = G.GAME.goldia_tooltip_key}
                    break
                elseif Sagatro.event_check(event)
                or (event == "facing_lisette" and Sagatro.event_check("harpae_patience", nil, {contain = true})
                and not (Sagatro.event_check("dull_glass") or Sagatro.event_check("dull_glass", nil, {contain = true}))) then
                    if event == "dull_glass" then
                        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = event, specific_vars = {card.ability.immutable.tolerance_index}}
                    elseif event ~= "facing_egliette" then
                        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = event}
                        break
                    elseif Sagatro.event_check("pm_mirrorworld", nil, true) then
                        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = event}
                        break
                    elseif Sagatro.event_check("pm_mirrorworld", nil, {contain = true}) then
                        info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "exiting_pm_mirrorworld"}
                        break
                    end
                end
            end
        end
        if Sagatro.storyline_check("none") or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers and not card.displaying_save) then
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "storyline_start",
            specific_vars = {localize('ph_pmirror'), self.saga_difficulty, colours = {G.C.SAGA_DIFFICULTY[self.saga_difficulty]}}, title = localize("saga_storyline_start")}
            info_queue[#info_queue+1] = {generate_ui = saga_tooltip, set = "Saga Tooltip", key = "pocket_mirror_mech", title = localize("saga_mechanic")}
        end
        local ret = {vars = {card.ability.extra.stage0_mult, card.ability.extra.stage0_mult_xmod}}
        if card.area and card.area ~= Sagatro.temp_areas.jokers and card.area.config.type == "title" then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_play_pocket_mirror"}
        end
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_stage_"..card.ability.immutable.stage
            if card.ability.immutable.stage == 0 or card.ability.immutable.stage == "dawn" then
                ret.vars = {card.ability.extra.stage0_mult, card.ability.extra.stage0_mult_xmod}
            elseif card.ability.immutable.stage == "name_recalled" then
                ret.vars = {card.ability.extra.full_queen_xmult, card.ability.extra.full_glass_xmult}
                info_queue[#info_queue+1] = G.P_CENTERS.m_glass
            end
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "plus", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "times" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            calc_function = function(card)
                card.joker_display_values.plus = (card.ability.immutable.stage == 0 or card.ability.immutable.stage == "dawn")
                and "+" or ""
                card.joker_display_values.mult = (card.ability.immutable.stage == 0 or card.ability.immutable.stage == "dawn")
                and card.ability.extra.stage0_mult or ""
                if G.GAME.door_puzzle_active then
                    card.joker_display_values.mult = 0
                end
                card.joker_display_values.times = ""
                card.joker_display_values.xmult = ""
                if card.ability.immutable.stage == "name_recalled" then
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    local queen_count, glass_count = 0, 0
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            if scoring_card:get_id() == 12 then
                                queen_count = queen_count + 1
                            end
                            if Sagatro.omniscient(scoring_card, {"m_glass", "m_sgt_nyx_glass"}) then
                                glass_count = glass_count + 1
                            end
                        end
                    end
                    local final_queen_xmult = card.ability.extra.full_queen_xmult ^ queen_count
                    local final_glass_xmult = card.ability.extra.full_glass_xmult ^ glass_count
                    card.joker_display_values.times = "X"
                    card.joker_display_values.xmult = final_queen_xmult * final_glass_xmult
                    if G.GAME.door_puzzle_active then
                        card.joker_display_values.mult = 0
                    end
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if not joker_card:can_calculate() then return 0 end
                if held_in_hand then return 0 end
                return joker_card.ability.immutable.stage == "name_recalled" and playing_card:get_id() == 12
                and JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[3] then
                    text.children[3].config.colour = card.ability.immutable.stage == "name_recalled"
                    and G.C.MULT or G.C.CLEAR
                end
                return false
            end,
        }
    end,
}

local pocket_mirror = {
    key = "pocket_mirror",
    name = "Pocket Mirror",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 126,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 4 },
    config = {shatters_on_destroy = true},
    rarity = "sgt_obscure",
    cost = 16,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker then
            if card.area and card.area == context.other_card.area then
                local pos, other_pos = Sagatro.get_pos(card), Sagatro.get_pos(context.other_card)
                if math.abs(pos - other_pos) == 1 then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 1,
                        card = card,
                    }
                end
            end
        end
        if ((context.end_of_round and not context.game_over and context.main_eval)
        or (context.setting_blind and not card.getting_sliced))
        and not context.blueprint and not context.retrigger_joker then
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                local pos, other_pos = Sagatro.get_pos(card), Sagatro.get_pos(goldia)
                if math.abs(pos - other_pos) ~= 1 and not card.shattered and not Sagatro.event_check("ending_reached", nil, {contain = true}) then
                    card.shattered = true
                    G.E_MANAGER:add_event(Event({func = function()
                        card:shatter()
                    return true end}))
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            Sagatro.progress_storyline("the_pocket_mirror", "finish", self.saga_group, G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("knife_and_fork", "add", self.saga_group, G.GAME.interwoven_storyline)
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia and not goldia.shattered then
                goldia.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    goldia:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if card.displaying_save then
                for _, v in ipairs((Sagatro.temp_areas or {jokers = {}}).jokers.cards or {}) do
                    if v.config.center_key == "j_sgt_goldia" then
                        goldia = v
                        break
                    end
                end
            end
            if not Sagatro.event_check("ending_reached", nil, {contain = true}) then
                info_queue[#info_queue+1] = {set = "Other", key = "sgt_pocket_mirror", specific_vars = {
                    localize{type = "name_text", set = "Joker",
                    key = "j_sgt_goldia_stage_"..(goldia and goldia.ability.immutable.stage or 0)}
                }}
            end
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_joker_function = function(card, retrigger_joker)
                if not retrigger_joker:can_calculate() then
                    return 0
                end
                return (card == retrigger_joker.area.cards[Sagatro.get_pos(retrigger_joker)-1]
                or card == retrigger_joker.area.cards[Sagatro.get_pos(retrigger_joker)+1])
                and 1 or 0
            end,
        }
    end,
}

local knife_fork = {
    key = "knife_fork",
    name = "Messer And Gabel",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 132,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 5 },
    config = {extra = {retriggers = 2}, shatters_on_destroy = true},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 12 then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra.retriggers,
                    card = card,
                }
            end
        end
        if context.setting_blind and not card.getting_sliced
        and not context.blueprint and not context.retrigger_joker and G.GAME.pm_mirrorworld
        and Sagatro.event_check("conditional_game_over", false) and next(SMODS.find_card("j_sgt_egliette", true)) then
            Sagatro.progress_storyline("conditional_game_over", "force_add", "pocket_mirror", G.GAME.interwoven_storyline)
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            Sagatro.progress_storyline("knife_and_fork", "finish", self.saga_group, G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("facing_egliette", "add", self.saga_group, G.GAME.interwoven_storyline)
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local pmirror = SMODS.find_card("j_sgt_pocket_mirror", true)[1]
            if pmirror and not pmirror.shattered then
                pmirror.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    for _, regalia in ipairs{"j_sgt_knife_fork", "j_sgt_rose_bell", "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe"} do
                        regalia = SMODS.find_card(regalia, true)[1]
                        if regalia and not regalia.shattered then
                            regalia:shatter()
                        end
                    end
                    pmirror:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            return Sagatro.storyline_check(self.saga_group) and Sagatro.event_check("knife_and_fork")
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.retriggers, colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if not joker_card:can_calculate() then return 0 end
                if held_in_hand then return 0 end
                return playing_card:get_id() == 12 and
                joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local rose_bell = {
    key = "rose_bell",
    name = "Rosen Glöckchen",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 127,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 0 },
    config = {extra = {xmult = 1, xmult_mod = 0.25}, shatters_on_destroy = true},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:get_id() == 12 and context.other_card:is_suit("Hearts") then
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
                return nil, true
            end
        end
        if (context.joker_main and to_big(card.ability.extra.xmult) > to_big(1)) or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_mod",
                    no_message = true
                })
            end
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local pmirror = SMODS.find_card("j_sgt_pocket_mirror", true)[1]
            if pmirror and not pmirror.shattered then
                pmirror.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    for _, regalia in ipairs{"j_sgt_knife_fork", "j_sgt_rose_bell", "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe"} do
                        regalia = SMODS.find_card(regalia, true)[1]
                        if regalia and not regalia.shattered then
                            regalia:shatter()
                        end
                    end
                    pmirror:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod, colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "bell_card", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.bell_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = {localize("Queen", 'ranks'), localize("Hearts", 'suits_plural') } }
                card.joker_display_values.xmult = card:can_calculate()
                and card.ability.extra.xmult or 1
            end,
        }
    end,
}

local moon_hairbrush = {
    key = "moon_hairbrush",
    name = "Haarbürste des Mondes",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 128,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 1 },
    config = {extra = {poker_hand = "High Card", xmult = 4}, shatters_on_destroy = true},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) then
            -- Fixed list so that modded poker hands won't interfere with story mode\
            -- Also exclude harder hands for ease of access
            _poker_hands = {"Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card"}
        else
            for k, v in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_moon_hairbrush' or 'moon_hairbrush'))
    end,
    calculate = function(self, card, context)
        if (context.joker_main and context.scoring_name == card.ability.extra.poker_hand) or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            local _poker_hands = {}
            if G.GAME.story_mode then
                _poker_hands = {"Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card"}
            else
                for k, v in pairs(G.GAME.hands) do
                    if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('moon_hairbrush'))
            return {
                message = localize(card.ability.extra.poker_hand, "poker_hands"),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local pmirror = SMODS.find_card("j_sgt_pocket_mirror", true)[1]
            if pmirror and not pmirror.shattered then
                pmirror.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    for _, regalia in ipairs{"j_sgt_knife_fork", "j_sgt_rose_bell", "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe"} do
                        regalia = SMODS.find_card(regalia, true)[1]
                        if regalia and not regalia.shattered then
                            regalia:shatter()
                        end
                    end
                    pmirror:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.xmult, localize(card.ability.extra.poker_hand, 'poker_hands'), colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.poker_hand = localize(card.ability.extra.poker_hand, 'poker_hands')
                card.joker_display_values.is_poker_hand = false
                local text, _, _ = JokerDisplay.evaluate_hand()
                if text == card.ability.extra.poker_hand then
                    card.joker_display_values.is_poker_hand = true
                end
                card.joker_display_values.xmult = card:can_calculate()
                and card.joker_display_values.is_poker_hand and card.ability.extra.xmult or 1
            end,
        }
    end,
}

local snow_scissors = {
    key = "snow_scissors",
    name = "Schnee Schere",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 129,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 2 },
    config = {extra = {xmult = 1.5}, shatters_on_destroy = true},
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if Sagatro.omniscient(context.other_card, {"m_glass", "m_sgt_nyx_glass"}) then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
        if context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local pmirror = SMODS.find_card("j_sgt_pocket_mirror", true)[1]
            if pmirror and not pmirror.shattered then
                pmirror.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    for _, regalia in ipairs{"j_sgt_knife_fork", "j_sgt_rose_bell", "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe"} do
                        regalia = SMODS.find_card(regalia, true)[1]
                        if regalia and not regalia.shattered then
                            regalia:shatter()
                        end
                    end
                    pmirror:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        local ret = {vars = {card.ability.extra.xmult, colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
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
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text",  colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if Sagatro.omniscient(scoring_card, {"m_glass", "m_sgt_nyx_glass"}) then
                            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.xmult = card:can_calculate() and card.ability.extra.xmult ^ count or 1
                card.joker_display_values.localized_text = localize{type = 'name_text', set = "Enhanced", key = "m_glass", nodes = {}}
            end
        }
    end,
}

local angel_scythe = {
    key = "angel_scythe",
    name = "Engelssense",
    artist_credits = {"huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 130,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 0 },
    soul_pos = { x = 5, y = 3 },
    config = {extra = {xchip = 1, xchip_mod = 0.15}, shatters_on_destroy = true},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xchip",
                scalar_value = "xchip_mod",
                scaling_message = {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.FILTER,
                    card = card,
                }
            })
            return nil, true
        end
        if context.joker_main or context.forcetrigger then
            if context.forcetrigger then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xchip",
                    scalar_value = "xchip_mod",
                    no_message = true
                })
            end
            return {
                xchips = card.ability.extra.xchips,
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            table.insert(G.GAME.regalia_list, card.config.center_key)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff and not Sagatro.event_check("goldia_transformation") then
            local pmirror = SMODS.find_card("j_sgt_pocket_mirror", true)[1]
            if pmirror and not pmirror.shattered then
                pmirror.shattered = true
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2*G.SETTINGS.GAMESPEED, func = function()
                    for _, regalia in ipairs{"j_sgt_knife_fork", "j_sgt_rose_bell", "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe"} do
                        regalia = SMODS.find_card(regalia, true)[1]
                        if regalia and not regalia.shattered then
                            regalia:shatter()
                        end
                    end
                    pmirror:shatter()
                return true end}))
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.xchip, card.ability.extra.xchip_mod, colours = {G.C.GOLD}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xchips", retrigger_type = "exp" }
                    },
                    border_colour = G.C.CHIPS
                }
            },
            calc_function = function(card)
                card.joker_display_values.xchips = card:can_calculate() and card.ability.extra.xchips or 1
            end,
        }
    end,
}

local egliette = {
    key = "egliette",
    name = "Egliette",
    artist_credits = {"temp"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 131,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 5, y = 6 },
    config = {extra = {retriggers = 6}},
    rarity = "sgt_obscure",
    cost = 12,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode then
            if context.end_of_round and not context.game_over and context.main_eval
            and not context.blueprint and not context.retrigger_joker then
                Sagatro.progress_storyline("pm_mirrorworld", "force_finish", self.saga_group, G.GAME.interwoven_storyline)
                G.GAME.storyline_progress_iw = 100
                Sagatro.self_destruct(card)
                return {
                    message = localize("k_poof_ex"),
                    colour = G.C.FILTER
                }
            end
        else
            if context.repetition and context.cardarea == G.play then
                if context.other_card:get_id() == 12 then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = card.ability.extra.retriggers,
                        card = card,
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.retriggers}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if not joker_card:can_calculate() then return 0 end
                if held_in_hand then return 0 end
                return not G.GAME.story_mode and playing_card:get_id() == 12 and
                joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end,
        }
    end,
}

local fleta = {
    key = "fleta",
    name = "Fleta",
    artist_credits = {"amy", "huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 122,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 2, y = 0, sgt_extra = { x = 1, y = 0, no_scale = true }, name_tag = { x = 3, y = 0 } },
    config = {immutable = {stage = 0, butterfly_collected = {goldia = 0, fleta = 0}, hands = {}, completed = {}}, extra = {xmult = 5}, shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.retrigger_joker
        and not card.ability.platinum_reflection then
            if context.ending_shop and G.GAME.round_resets.blind_states.Small == "Upcoming"
            and card.ability.immutable.stage == 0 then
                card.ability.immutable.ready = true
                G.GAME.modifiers.sgt_no_tags = true
                card.ability.immutable.stage = 1
                card.ability.immutable.pairs_played = 0
            end
            if context.before and not G.GAME.shelved_chains.end_of_round
            and G.GAME.blind_on_deck == "Boss" and card.ability.immutable.stage == 3 then
                G.GAME.shelved_chains.end_of_round = "sgt_fleta_crashout"
            end
            if context.ante_change and context.ante_end then
                if not card.ability.immutable.ready then
                    card.ability.immutable.ready = true
                    G.GAME.modifiers.sgt_no_tags = true
                    card.ability.immutable.stage = 1
                elseif card.ability.immutable.stage < 3 then
                    card.ability.immutable.stage = card.ability.immutable.stage + 1
                end
            end
            if card.ability.immutable.stage == 1 then
                if (context.ante_change and context.ante_end)
                or (context.end_of_round and not context.game_over and context.main_eval) then
                    card.ability.immutable.pairs_played = card.ability.immutable.pairs_played or 0
                    if card.ability.immutable.pairs_played >= 3 then
                        card.ability.immutable.completed.memory = true
                    else
                        card.ability.immutable.pairs_played = 0
                    end
                end
                if context.before and context.scoring_name == "Pair"
                and not card.ability.immutable.completed.memory then
                    card.ability.immutable.pairs_played = card.ability.immutable.pairs_played + 1
                end
            elseif card.ability.immutable.stage == 2 then
                if context.setting_blind and not card.getting_sliced
                and not card.ability.immutable.butterfly_uncaged then
                    card.ability.immutable.butterfly_uncaged = true
                    local i = 0
                    while i < 20 do -- yikes, this is not the optimal way to mass-assign stickers
                        for _, v in ipairs(G.playing_cards) do
                            if not v.ability.sgt_butterfly and i < 20 then
                                if pseudorandom("uncaged_butterfly") > 0.67 then
                                    v:add_sticker("sgt_butterfly", true)
                                    i = i + 1
                                end
                            end
                        end
                    end
                end
                if context.before then
                    local goldia_collected, fleta_collected = false, false
                    for _, v in ipairs(context.scoring_hand) do
                        if v.ability.sgt_butterfly then
                            goldia_collected = true
                            card.ability.immutable.butterfly_collected.goldia =
                            card.ability.immutable.butterfly_collected.goldia + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    v:remove_sticker("sgt_butterfly")
                                    v:juice_up()
                                    return true
                                end
                            }))
                        end
                    end
                    if goldia_collected then
                        local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
                        if goldia then
                            SMODS.calculate_effect({message = localize('k_caught_ex'), colour = G.C.FILTER}, goldia)
                        end
                    end
                    local eligible_cards, chosen_cards = {}, {}
                    for _, v in ipairs(G.playing_cards) do
                        if v.ability.sgt_butterfly and not table.contains(context.scoring_hand, v) then
                            table.insert(eligible_cards, v)
                        end
                    end
                    if next(eligible_cards) then
                        local times = pseudorandom("fleta_catches", 0, 2)
                        for _ = 1, math.min(times, #eligible_cards) do
                            local chosen_card = pseudorandom_element(eligible_cards, pseudoseed("fleta_target"))
                            local i = 1
                            while table.contains(chosen_cards, chosen_card) do
                                chosen_card = pseudorandom_element(eligible_cards, pseudoseed("fleta_target_resample"..i))
                                i = i + 1
                            end
                            table.insert(chosen_cards, chosen_card)
                        end
                        for _, v in ipairs(chosen_cards) do
                            fleta_collected = true
                            card.ability.immutable.butterfly_collected.fleta =
                            card.ability.immutable.butterfly_collected.fleta + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    v:remove_sticker("sgt_butterfly")
                                    v:juice_up()
                                    return true
                                end
                            }))
                        end
                    end
                    if fleta_collected then
                        return {
                            message = localize('k_caught_ex'),
                            colour = G.C.FILTER,
                            card = card,
                        }
                    end
                end
                if context.end_of_round and not context.game_over and context.main_eval then
                    if G.GAME.blind_on_deck == "Boss"
                    and card.ability.immutable.butterfly_collected.goldia
                    > card.ability.immutable.butterfly_collected.fleta then
                        card.ability.immutable.completed.butterflies = true
                    end
                end
            elseif card.ability.immutable.stage == 3 then
                if context.setting_blind and not card.getting_sliced then
                    for _, v in ipairs(G.playing_cards) do
                        v:remove_sticker("sgt_butterfly")
                    end
                end
                if context.before then
                    G.E_MANAGER:add_event(Event({func = function()
                        if card.ability.immutable.hands[context.scoring_name] then
                            -- game over screen blocks the Notification box from appearing for some reason
                            -- this notify_alert call serves as a scapegoat, allowing the real one to be on a proper queue
                            notify_alert("ach_sgt_pm_bad_end_1")
                            check_for_unlock{type = "pm_bad_end_1"}
                            Sagatro.game_over("ph_losing_musical_chair")
                        end
                    return true end}))
                end
                if context.after then
                    G.E_MANAGER:add_event(Event({func = function()
                        card.ability.immutable.hands[context.scoring_name] = true
                    return true end}))
                end
                if context.end_of_round and not context.game_over and context.main_eval then
                    card.ability.immutable.hands = {}
                end
            end
        elseif not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 12 and context.other_card:is_suit("Hearts") then
                    return {
                        xmult = card.ability.extra.xmult,
                    }
                end
            end
            if context.forcetrigger then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.xmult}}
        if (G.GAME.story_mode and not card.ability.platinum_reflection) or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_stage_"..card.ability.immutable.stage
            if card.ability.immutable.stage == 1 then
                ret.vars = {card.ability.immutable.pairs_played, colours = {card.ability.immutable.completed.memory and G.C.GREEN or G.C.FILTER}}
            elseif card.ability.immutable.stage == 2 then
                ret.vars = {card.ability.immutable.butterfly_collected.goldia,
                card.ability.immutable.butterfly_collected.fleta}
            elseif card.ability.immutable.stage == 3 then
            end
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "open_bracket", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "current_progress" },
                { ref_table = "card.joker_display_values", ref_value = "slash", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "target_value" },
                { ref_table = "card.joker_display_values", ref_value = "close_bracket", colour = G.C.UI.TEXT_INACTIVE },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "times" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "fleta_reminder", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.open_bracket = ""
                card.joker_display_values.close_bracket = ""
                card.joker_display_values.current_progress = ""
                card.joker_display_values.slash = ""
                card.joker_display_values.target_value = ""
                card.joker_display_values.times = ""
                card.joker_display_values.xmult = ""
                card.joker_display_values.fleta_reminder = ""
                if G.GAME.story_mode and not card.ability.platinum_reflection then
                    if card.ability.immutable.stage == 1 then
                        card.joker_display_values.open_bracket = " ("
                        card.joker_display_values.close_bracket = ") "
                        card.joker_display_values.current_progress = card.ability.immutable.pairs_played
                        card.joker_display_values.slash = "/"
                        card.joker_display_values.target_value = 3
                        card.joker_display_values.fleta_reminder = localize("Pair", "poker_hands")
                    elseif card.ability.immutable.stage == 2 then
                        card.joker_display_values.open_bracket = " ("
                        card.joker_display_values.close_bracket = ") "
                        card.joker_display_values.current_progress = card.ability.immutable.butterfly_collected.goldia
                        card.joker_display_values.slash = "/"
                        card.joker_display_values.target_value = card.ability.immutable.butterfly_collected.fleta
                    elseif card.ability.immutable.stage == 3 or card.ability.immutable.stage == 0 then
                        card.joker_display_values.open_bracket = " ("
                        card.joker_display_values.close_bracket = ") "
                        card.joker_display_values.current_progress = 0
                        card.joker_display_values.slash = "/"
                        card.joker_display_values.target_value = 0
                    end
                else
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    local count = 0
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            if scoring_card:get_id() == 12 and scoring_card:is_suit("Hearts") then
                                count = count + 1
                            end
                        end
                    end
                    card.joker_display_values.times = "X"
                    card.joker_display_values.xmult = 1
                    if not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                    and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
                        card.joker_display_values.xmult = card.ability.extra.xmult ^ count
                    end
                    card.joker_display_values.fleta_reminder = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize("Queen", 'ranks'), localize("Hearts", 'suits_plural') } }
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text then
                    if text.children[2] then
                        text.children[2].config.colour =
                        (card.ability.immutable.stage == 1 and (card.ability.immutable.completed.memory and G.C.GREEN or G.C.FILTER))
                        or (card.ability.immutable.stage == 2 and G.C.SGT_GOLDIATTENTION)
                        or G.C.UI.TEXT_INACTIVE
                    end
                    if text.children[4] then
                        text.children[4].config.colour =
                        (card.ability.immutable.stage == 1 and G.C.UI.TEXT_INACTIVE)
                        or (card.ability.immutable.stage == 2 and G.C.GREEN)
                        or G.C.UI.TEXT_INACTIVE
                    end
                    if text.children[6] then
                        text.children[6].config.colour = (G.GAME.story_mode and not card.ability.platinum_reflection) and G.C.CLEAR
                        or (not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum")) and G.C.MULT
                        or G.C.CLEAR
                    end
                end
                return false
            end,
        }
    end,
}

local harpae = {
    key = "harpae",
    name = "Harpae",
    artist_credits = {"amy", "huycorn"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 123,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 1 },
    soul_pos = { x = 2, y = 1, sgt_extra = { x = 1, y = 1, no_scale = true }, name_tag = { x = 3, y = 1 } },
    config = {immutable = {blindness = true, obedience_count = 0}, extra = {poker_hand = "High Card", xmult = 4}, shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) then
            card.ability.immutable.appeared = true
            -- Fixed list so that modded poker hands won't interfere with story mode\
            -- Also exclude harder hands for ease of access
            _poker_hands = {"Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card"}
        else
            for k, v in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_moon_hairbrush' or 'moon_hairbrush'))
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.retrigger_joker
        and not card.ability.platinum_reflection then
            if context.starting_shop then
                card.ability.immutable.appeared = nil
            end
            if context.before then
                if context.scoring_name == card.ability.extra.poker_hand then
                    card.ability.immutable.obedience_count = card.ability.immutable.obedience_count + 1
                    if card.ability.immutable.obedience_count >= 10 then
                        G.GAME.shelved_chains.end_of_round = "sgt_harpae_ending"
                    end
                    return {
                        message = localize("k_good_ex"),
                        colour = G.C.FILTER,
                        card = card,
                    }
                else
                    card.ability.immutable.blindness = nil
                    if card.ability.immutable.down then
                        card.ability.immutable.bad_end = true
                    end
                end
            end
            if context.after then
                local _poker_hands = {"Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card"}
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('moon_hairbrush'))
                card.ability.immutable.down = pseudorandom("harpae_down") < 0.25
                return {
                    message = localize(card.ability.extra.poker_hand, "poker_hands"),
                    colour = G.C.FILTER,
                    card = card,
                    extra = card.ability.immutable.down and {
                        message = localize("k_down_ex"),
                        colour = G.C.FILTER,
                    } or nil,
                }
            end
        elseif not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
            if context.individual and context.cardarea == G.play then
                if context.scoring_name == card.ability.extra.poker_hand then
                    return {
                        xmult = card.ability.extra.xmult,
                    }
                end
            end
            if context.forcetrigger then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
                local _poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
                end
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('moon_hairbrush'))
                return {
                    message = localize(card.ability.extra.poker_hand, "poker_hands"),
                    colour = G.C.FILTER,
                    card = card,
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    update = function(self, card, dt)
        if G.GAME.story_mode and G.STAGE == G.STAGES.RUN then
            G.GAME.no_savebox = card.ability.immutable.appeared
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.xmult, localize(card.ability.extra.poker_hand, 'poker_hands')}}
        if (G.GAME.story_mode and not card.ability.platinum_reflection) or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            ret.vars[1] = card.ability.immutable.obedience_count
            ret.vars.colours = {card.ability.immutable.obedience_count >= 10 and G.C.GREEN or G.C.FILTER,
            card.ability.immutable.down and G.C.RED or G.C.UI.TEXT_INACTIVE}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "open_bracket", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "current_progress", colour = G.C.FILTER },
                { ref_table = "card.joker_display_values", ref_value = "slash", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "target_value", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "close_bracket", colour = G.C.UI.TEXT_INACTIVE },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "times" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "harpae_reminder", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.open_bracket = ""
                card.joker_display_values.close_bracket = ""
                card.joker_display_values.current_progress = ""
                card.joker_display_values.slash = ""
                card.joker_display_values.target_value = ""
                card.joker_display_values.times = ""
                card.joker_display_values.xmult = ""
                card.joker_display_values.harpae_reminder = localize(card.ability.extra.poker_hand, "poker_hands")
                if G.GAME.story_mode and not card.ability.platinum_reflection then
                    card.joker_display_values.open_bracket = " ("
                    card.joker_display_values.close_bracket = ") "
                    card.joker_display_values.current_progress = card.ability.immutable.obedience_count
                    card.joker_display_values.slash = "/"
                    card.joker_display_values.target_value = 10
                else
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    local count = 0
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            count = count + 1
                        end
                    end
                    card.joker_display_values.times = "X"
                    card.joker_display_values.xmult = 1
                    if not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                    and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
                        card.joker_display_values.xmult = card.ability.extra.xmult ^ count
                    end
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text then
                    if text.children[3] then
                        text.children[3].config.colour =
                        card.ability.immutable.down and G.C.RED
                        or G.C.UI.TEXT_INACTIVE
                    end
                    if text.children[6] then
                        text.children[6].config.colour = (G.GAME.story_mode and not card.ability.platinum_reflection) and G.C.CLEAR
                        or (not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum")) and G.C.MULT
                        or G.C.CLEAR
                    end
                end
                return false
            end,
        }
    end,
}

local lisette = {
    key = "lisette",
    name = "Lisette",
    artist_credits = {"amy", "huythekiller"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 124,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 2 },
    soul_pos = { x = 2, y = 2, sgt_extra = { x = 1, y = 2, no_scale = true }, name_tag = { x = 3, y = 2 } },
    config = {immutable = {dt = 0, random_interval = (120*3/135)}, extra = {xmult = 2.5, glass_odds_mod = 2}, shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not card.ability.platinum_reflection then
            if Sagatro.event_check("dull_glass") then
                if context.repetition and context.cardarea == G.play then
                    if SMODS.has_enhancement(context.other_card, "m_sgt_mirror") then
                        return {
                            message = localize("k_again_ex"),
                            repetitions = 1,
                            card = card,
                        }
                    end
                end
            end
        elseif not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
            if context.mod_probability and not context.blueprint then
                if context.trigger_obj and Sagatro.omniscient(context.trigger_obj, {"m_glass", "m_sgt_nyx_glass"}) then
                    return { denominator = context.denominator*card.ability.extra.glass_odds_mod }
                end
            end
            if context.individual and context.cardarea == G.play then
                if Sagatro.omniscient(context.other_card, {"m_glass", "m_sgt_nyx_glass"}) then
                    return {
                        xmult = card.ability.extra.xmult,
                    }
                end
            end
            if context.forcetrigger then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if card.area and card.area == G.jokers then
                if Sagatro.event_check("lisette_chase") then
                    card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                    if card.ability.immutable.dt > (5/6) then
                        card.ability.immutable.dt = card.ability.immutable.dt - (5/6)
                        if not card.states.drag.is then
                            if G.STATE == G.STATES.HAND_PLAYED then
                                if Sagatro.get_pos(card) > 4 then
                                    if G.jokers.cards[Sagatro.get_pos(card)-1]
                                    and not G.jokers.cards[Sagatro.get_pos(card)-1].states.drag.is
                                    and G.jokers.cards[Sagatro.get_pos(card)-1].config.center_key ~= "j_sgt_lisette" then
                                        Sagatro.swap(card, "left")
                                    end
                                elseif Sagatro.get_pos(card) < 4 then
                                    if G.jokers.cards[Sagatro.get_pos(card)+1]
                                    and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                                    and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_lisette" then
                                        Sagatro.swap(card)
                                    end
                                end
                            elseif Sagatro.get_pos(card) > 2 then
                                if G.STATE ~= G.STATES.ROUND_EVAL and G.STATE ~= G.STATES.NEW_ROUND then
                                    if G.jokers.cards[Sagatro.get_pos(card)-1]
                                    and not G.jokers.cards[Sagatro.get_pos(card)-1].states.drag.is
                                    and G.jokers.cards[Sagatro.get_pos(card)-1].config.center_key ~= "j_sgt_lisette" then
                                        Sagatro.swap(card, "left")
                                    end
                                end
                            else
                                Sagatro.game_over("j_sgt_lisette")
                            end
                        end
                    end
                elseif Sagatro.event_check("dull_glass") and not card.executing_ending then
                    card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                    if card.ability.immutable.dt > card.ability.immutable.random_interval then
                        card.ability.immutable.dt = card.ability.immutable.dt - card.ability.immutable.random_interval
                        card.ability.immutable.random_interval = (120*3*pseudorandom("lisette_interval", 1, 2)/135)
                        if not card.states.drag.is then
                            if G.STATE ~= G.STATES.ROUND_EVAL and G.STATE ~= G.STATES.NEW_ROUND then
                                if math.abs(Sagatro.get_pos(card) - (Sagatro.get_pos(SMODS.find_card("j_sgt_goldia", true)[1] or {}) or 1)) > 1 then
                                    if Sagatro.get_pos(card) - (Sagatro.get_pos(SMODS.find_card("j_sgt_goldia", true)[1] or {}) or 1) > 0 then
                                        if G.jokers.cards[Sagatro.get_pos(card)-1]
                                        and not G.jokers.cards[Sagatro.get_pos(card)-1].states.drag.is
                                        and G.jokers.cards[Sagatro.get_pos(card)-1].config.center_key ~= "j_sgt_lisette" then
                                            Sagatro.swap(card, "left")
                                        end
                                    else
                                        if G.jokers.cards[Sagatro.get_pos(card)+1]
                                        and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                                        and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_lisette" then
                                            Sagatro.swap(card)
                                        end
                                    end
                                else
                                    Sagatro.game_over("j_sgt_lisette")
                                end
                            end
                        end
                    end
                else
                    card.ability.immutable.dt = 0
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        local ret = {vars = {card.ability.extra.xmult}}
        if (G.GAME.story_mode and not card.ability.platinum_reflection) or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            info_queue[#info_queue] = nil
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if card.displaying_save then
                for _, v in ipairs((Sagatro.temp_areas or {jokers = {}}).jokers.cards or {}) do
                    if v.config.center_key == "j_sgt_goldia" then
                        goldia = v
                        break
                    end
                end
            end
            ret.vars = {localize{type = "name_text", set = "Joker",
            key = "j_sgt_goldia_stage_"..(goldia or {ability = {immutable = {stage = 0}}}).ability.immutable.stage}}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "open_bracket", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "current_progress", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "slash", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "target_value", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "close_bracket", colour = G.C.UI.TEXT_INACTIVE },
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "times" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    },
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "lisette_reminder", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.open_bracket = ""
                card.joker_display_values.close_bracket = ""
                card.joker_display_values.current_progress = ""
                card.joker_display_values.slash = ""
                card.joker_display_values.target_value = ""
                card.joker_display_values.times = ""
                card.joker_display_values.xmult = ""
                card.joker_display_values.lisette_reminder = ""
                if G.GAME.story_mode and not card.ability.platinum_reflection then
                    card.joker_display_values.open_bracket = " ("
                    card.joker_display_values.close_bracket = ") "
                    card.joker_display_values.current_progress = 0
                    card.joker_display_values.slash = "/"
                    card.joker_display_values.target_value = 0
                else
                    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    local count = 0
                    if text ~= 'Unknown' then
                        for _, scoring_card in pairs(scoring_hand) do
                            if Sagatro.omniscient(scoring_card, {"m_glass", "m_sgt_nyx_glass"}) then
                                count = count + 1
                            end
                        end
                    end
                    card.joker_display_values.times = "X"
                    card.joker_display_values.xmult = 1
                    if not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                    and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
                        card.joker_display_values.xmult = card.ability.extra.xmult ^ count
                    end
                    card.joker_display_values.lisette_reminder = localize{type = 'name_text', set = "Enhanced", key = "m_glass", nodes = {}}
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text then
                    if text.children[6] then
                        text.children[6].config.colour = (G.GAME.story_mode and not card.ability.platinum_reflection) and G.C.CLEAR
                        or (not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum")) and G.C.MULT
                        or G.C.CLEAR
                    end
                end
                return false
            end,
        }
    end,
}

local enjel = {
    key = "enjel",
    name = "Enjel",
    artist_credits = {"huycorn", "amy"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 125,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 3 },
    soul_pos = { x = 2, y = 3, sgt_extra = { x = 1, y = 3, no_scale = true }, name_tag = { x = 3, y = 3 } },
    config = {immutable = {dt = 0}, extra = {chips = 50, chip_xmod = 2}, shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.chips =
        card.ability.extra.chips*math.floor(2^(G.GAME.round_resets.ante + (G.GAME.ante_reduced or 0)))
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.retrigger_joker
        and not card.ability.platinum_reflection then
        elseif not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
            if context.ante_change and context.ante_end
            and not context.blueprint and not context.retrigger_joker then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_xmod",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial * scaling
                    end,
                    no_message = true
                })
                return nil, true
            end
            if context.joker_main or context.forcetrigger then
                if context.forcetrigger then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chip_xmod",
                        operation = function(ref_table, ref_value, initial, scaling)
                            ref_table[ref_value] = initial * scaling
                        end,
                        no_message = true
                    })
                end
                return {
                    chip_mod = card.ability.extra.chips,
                    message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and not from_debuff then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.06*G.SETTINGS.GAMESPEED, func = function()
                ease_background_colour_blind(G.STATE)
            return true end }))
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if card.area and card.area == G.jokers then
                if Sagatro.event_check("pocket_mirror_chase") then
                    G.GAME.pm_chase = G.GAME.pm_chase or {}
                    G.GAME.pm_chase.enjel_pos = Sagatro.get_pos(card)
                    if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or (G.STATE == G.STATES.PLAY_TAROT and G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND)) then
                        card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                        if card.ability.immutable.dt > (120/170) then
                            card.ability.immutable.dt = card.ability.immutable.dt - (120/170)
                            if not card.states.drag.is and G.jokers.cards[Sagatro.get_pos(card)+1]
                            and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                            and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_goldia" then
                                Sagatro.swap(card)
                            end
                        end
                    else
                        card.ability.immutable.dt = 0
                    end
                elseif Sagatro.event_check("enjel_chase") then
                    if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or (G.STATE == G.STATES.PLAY_TAROT and G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND)) then
                        card.ability.immutable.dt = card.ability.immutable.dt + dt/G.SPEEDFACTOR
                        if card.ability.immutable.dt > (120/170) then
                            card.ability.immutable.dt = card.ability.immutable.dt - (120/170)
                            if not card.states.drag.is and G.jokers.cards[Sagatro.get_pos(card)+1]
                            and not G.jokers.cards[Sagatro.get_pos(card)+1].states.drag.is
                            and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key ~= "j_sgt_goldia"
                            and (not G.jokers.cards[Sagatro.get_pos(card)+2]
                            or G.jokers.cards[Sagatro.get_pos(card)+2].config.center_key ~= "j_sgt_goldia") then
                                Sagatro.swap(card)
                            end
                        end
                    else
                        card.ability.immutable.dt = 0
                    end
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.chips, card.ability.extra.chip_xmod}}
        if (G.GAME.story_mode and not card.ability.platinum_reflection) or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            text = {
                { ref_table = "card.joker_display_values", ref_value = "open_bracket", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "current_progress", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "slash", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "target_value", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "close_bracket", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.joker_display_values", ref_value = "plus" },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
            },
            calc_function = function(card)
                card.joker_display_values.open_bracket = ""
                card.joker_display_values.close_bracket = ""
                card.joker_display_values.current_progress = ""
                card.joker_display_values.slash = ""
                card.joker_display_values.target_value = ""
                card.joker_display_values.plus = ""
                card.joker_display_values.chips = ""
                if G.GAME.story_mode and not card.ability.platinum_reflection then
                    card.joker_display_values.open_bracket = "("
                    card.joker_display_values.close_bracket = ")"
                    card.joker_display_values.current_progress = 0
                    card.joker_display_values.slash = "/"
                    card.joker_display_values.target_value = 0
                else
                    card.joker_display_values.plus = "+"
                    card.joker_display_values.chips = 0
                    if not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                    and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum") then
                        card.joker_display_values.chips = card.ability.extra.chips
                    end
                end
            end,
            style_function = function(card, text, reminder_text, extra)
                if text then
                    if text.children[6] then
                        text.children[6].config.colour = (G.GAME.story_mode and not card.ability.platinum_reflection) and G.C.CLEAR
                        or (not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum")) and G.C.CHIPS
                        or G.C.CLEAR
                    end
                    if text.children[7] then
                        text.children[7].config.colour = (G.GAME.story_mode and not card.ability.platinum_reflection) and G.C.CLEAR
                        or (not card.ability.platinum_reflection or Sagatro.event_check("ending_reached", nil, {contain = true}) or (card.ability.platinum_reflection
                        and (card.area.cards[Sagatro.get_pos(card)+1] or {config = {}}).config.center_key == "j_sgt_platinum")) and G.C.CHIPS
                        or G.C.CLEAR
                    end
                end
                return false
            end,
        }
    end,
}

local rusty_scissors = {
    key = "rusty_scissors",
    name = "Rusty Scissors",
    artist_credits = {"huythekiller"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 133,
    pools = { [SAGA_GROUP_POOL.pmirror] = true },
    pos = { x = 4, y = 6 },
    config = {},
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    can_use = function(self, card) -- evil joker trying to be a consumable trollface
        return card.area == G.jokers and G.jokers.cards[Sagatro.get_pos(card)+1]
        and G.jokers.cards[Sagatro.get_pos(card)+1].config.center_key == "m_sgt_mirror"
        and G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local mirror = SMODS.find_card("m_sgt_mirror", true)[1]
                if mirror then
                    mirror:shatter()
                    G.GAME.shelved_chains.end_of_round = "sgt_lisette_ending"
                    for _, scissors in ipairs(SMODS.find_card("j_sgt_rusty_scissors", true)) do
                        scissors:start_dissolve({G.C.GOLD})
                    end
                end
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.retrigger_joker then
        else
            if context.fix_probability then
                if context.trigger_obj and Sagatro.omniscient(context.trigger_obj, {"m_glass", "m_sgt_nyx_glass"}) then
                    return { numerator = context.denominator }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.story_mode and #SMODS.find_card("j_sgt_rusty_scissors", true) >= 2 then
            local func = function()
                ease_dollars(card.cost)
            end
            Sagatro.self_destruct(card, {no_destruction_context = true, no_sound = true}, func)
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if G.GAME.story_mode and card.area
            and card.area == G.jokers and not card.ability.consumeable then
                card.ability.consumeable = {}
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode then
            local goldia, is_tolerating, options = SMODS.find_card("j_sgt_goldia", true)[1], false, nil
            if goldia then
                is_tolerating = goldia.ability.immutable.tolerance_index >= 4
                options = {allow_duplicates = #SMODS.find_card("j_sgt_rusty_scissors", true) < 2}
            end
            return Sagatro.event_check("dull_glass") and is_tolerating, options
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {}}
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            info_queue[#info_queue] = G.P_CENTERS.m_sgt_mirror
            info_queue[#info_queue+1] = G.P_CENTERS.j_sgt_lisette
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = ""
                if not G.GAME.story_mode then
                    card.joker_display_values.localized_text = localize{type = 'name_text', set = "Enhanced", key = "m_glass", nodes = {}}
                end
            end,
        }
    end,
}

local platinum = {
    key = "platinum",
    name = "Platinum",
    artist_credits = {"amy"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 134,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 5 },
    soul_pos = { x = 2, y = 5, sgt_extra = { x = 1, y = 5, no_scale = true }, name_tag = { x = 3, y = 5 } },
    config = {shatters_on_destroy = true},
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local reflections = {"j_sgt_fleta", "j_sgt_harpae", "j_sgt_lisette"}
            if not G.GAME.story_mode then
                table.insert(reflections, "j_sgt_enjel")
            end
            for _, v in ipairs(reflections) do
                local reflection = SMODS.add_card{key = v}
                if not G.GAME.story_mode then
                    reflection.ability.extra_slots_used = -1
                end
                reflection.ability.platinum_reflection = true
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            for i = #G.jokers.cards, 1, -1 do
                if G.jokers.cards[i].ability.platinum_reflection then
                    G.jokers.cards[i]:remove()
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {colours = {G.C.FLETA_RED, G.C.HARPAE_BLUE, G.C.LISETTE_PURPLE, G.C.ENJEL_MIDNIGHT, mix_colours(G.C.GOLDIA_PINK, G.C.PLATINUM_PINK, 0.5)}}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = "j_sgt_platinum_ending"
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local ozzy = {
    key = "ozzy",
    name = "Ozzy",
    artist_credits = {"temp"},
    atlas = "pocket_mirror",
    saga_group = "pocket_mirror",
    order = 135,
    pools = { [SAGA_GROUP_POOL.pmirror] = true, [SAGA_GROUP_POOL.legend] = true },
    pos = { x = 0, y = 6 },
    soul_pos = { x = 2, y = 6, sgt_extra = { x = 1, y = 6, no_scale = true }, name_tag = { x = 3, y = 6 } },
    config = {extra = {shop_slots = 1, spectral_rate = 20}},
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.story_mode and G.STATE == G.STATES.PLAY_TAROT then
            if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                card.ability.saved_once = true
            end
        end
    end,
    calculate = function(self, card, context)
        if G.GAME.story_mode and not context.blueprint and not context.trigger_joker then
            if context.end_of_round and not context.individual
            and not context.repetition and context.game_over and not card.ability.saved_once then
                card.ability.saved_once = true
                return {
                    saved = "ph_ozzy_saved",
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        change_shop_size(card.ability.extra.shop_slots)
        for k, v in pairs(G.GAME) do
            if string.len(k) > 5 and string.find(k, "_rate")
            and type(v) == "number" and k ~= "joker_rate" and k ~= "edition_rate"
            and k ~= "spectral_rate" and k ~= "eldritch_rate" and k ~= "playing_card_rate" then
                if v ~= 0 then
                    G.GAME[k] = G.GAME[k]/1e18
                end
            end
        end
        if G.GAME.spectral_rate ~= 0 then
            G.GAME.old_spectral_rate = G.GAME.spectral_rate
        end
        G.GAME.spectral_rate = card.ability.extra.spectral_rate
        if G.GAME.used_vouchers.v_sgt_abyss_pact then
            G.GAME.eldritch_rate = 8
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        change_shop_size(-card.ability.extra.shop_slots)
        for k, v in pairs(G.GAME) do
            if string.len(k) > 5 and string.find(k, "_rate")
            and type(v) == "number" and k ~= "joker_rate" and k ~= "edition_rate"
            and k ~= "spectral_rate" and k ~= "eldritch_rate" and k ~= "playing_card_rate" then
                if v ~= 0 then
                    G.GAME[k] = G.GAME[k]*1e18
                end
            end
        end
        if not next(SMODS.find_card("j_sgt_ozzy")) then
            if G.GAME.old_spectral_rate then
                G.GAME.spectral_rate = G.GAME.old_spectral_rate
                G.GAME.old_spectral_rate = nil
            else
                G.GAME.spectral_rate = 0
            end
            if G.GAME.used_vouchers.v_sgt_abyss_pact then
                G.GAME.eldritch_rate = 1
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.story_mode
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.extra.shop_slots}}
        if G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or card.displaying_save then
            ret.key = self.key.."_storymode"
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_inflation"}
        end
        return ret
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('ph_pmirror'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
    joker_display_def = function(JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.SECONDARY_SET.Spectral },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.localized_text = localize("b_spectral_cards")
            end,
        }
    end,
}

local hansels_cheat_dice = {
    key = "hansels_cheat_dice",
    name = "Hansel's Cheat Dice",
    artist_credits = {"amy"},
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
        if context.ending_shop and not context.blueprint and not context.retrigger_joker
        and not card.ability.immutable.debug_guaranteed then
            card.ability.immutable.current_roll = pseudorandom("cheat_dice_roll", 1, 6)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_roll_ex')})
            if card.ability.immutable.current_roll == 1 then
                Sagatro.ease_ante(1)
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
                return triggered and not card.ability.pre_ragnarok and Sagatro.mod_compat.talisman and not G.RESET_JIGGLES
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
                    if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
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
                        if v:is_suit("Hearts", nil, true) or v:is_suit("Diamonds", nil, true) then
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
                    if v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
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
                    if v:is_suit("Spades", nil, true) or v:is_suit("Clubs", nil, true) then
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
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
                return triggered and not card.ability.pre_ragnarok and Sagatro.mod_compat.talisman and not G.RESET_JIGGLES
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
    artist_credits = {"huycorn"},
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
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            card.ability.three_winters_rounds = card.ability.three_winters_rounds + 1
            if (card.ability.three_winters_rounds >= card.ability.extra.rounds_goal) or context.forcetrigger then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        local ragnarok = SMODS.add_card({
                            set = "Joker",
                            skip_materialize = true,
                            key = "j_sgt_ragnarok",
                            edition = card.edition and card.edition.key or nil,
                            stickers = card.ability.sgt_mirrored and {"sgt_mirrored"} or nil,
                            force_stickers = card.ability.sgt_mirrored and true or nil,
                        })
                        if card.ability.pumpkin_edition then
                            ragnarok.ability.pumpkin_edition = true
                        end
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
    artist_credits = {"huycorn"},
    atlas = "misc_jokers",
    saga_group = "adams_original_sin",
    order = 996,
    pos = { x = 3, y = 1 },
    config = {},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    demicoloncompat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker then
            if (Ortalab and context.other_card.curse)
            or (not Ortalab and context.other_card.ability.perishable) then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 1,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
                if not retrigger_joker:can_calculate() then
                    return 0
                end
                return ((Ortalab and card.curse) or (not Ortalab and card.ability.perishable)) and 1 or 0
            end,
        }
    end,
}

local saint_germain = {
    key = "saint_germain",
    name = "Saint Germain",
    artist_credits = {"amy"},
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                card.joker_display_values.active = text ~= 'Unknown' and #scoring_hand == 1 and scoring_hand[1]:get_id() == 13
                and localize("jdis_active") or localize("jdis_inactive")
            end,
        }
    end,
}

local necronomicon = {
    key = "necronomicon",
    name = "Necronomicon",
    artist_credits = {"huycorn"},
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
                local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                    card = card
                }
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
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
                local eligible_card = pseudorandom_element(card.eligible_strength_jokers, pseudoseed('pumpkin_carriage'))
                eligible_card:set_edition(poll_edition("pumcar", nil, nil, true), nil, nil, true)
                eligible_card.ability.pumpkin_edition = true
                return {
                    message = localize("k_glowup_ex"),
                    colour = G.C.FILTER,
                    card = card,
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
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                            if v.ability.set == 'Joker' and v.ability.pumpkin_edition then
                                v:set_edition(nil, true, true)
                                v.ability.pumpkin_edition = nil
                            end
                        end
                        return true
                    end
                }))
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
                    v.ability.pumpkin_edition = nil
                end
            end
        end
    end,
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn", "huythekiller"},
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
                local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
        end
        if context.before and not context.blueprint and not context.retrigger_joker
        and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
            local _card = context.full_hand[1]
            if not (SMODS.has_no_rank(_card) or SMODS.has_no_suit(_card) or _card.abducted) then
                _card.abducted = true
                card.ability.extra.held_card = {}
                card.ability.extra.held_card.suit = _card.base.suit
                card.ability.extra.held_card.rank = _card.base.value
                card.ability.extra.triggered = true
            end
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
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if Sagatro.storyline_check("none") and G.pack_cards then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_fallback_joker"}
        end
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
    artist_credits = {"huycorn"},
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
                local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
        end
        if (context.before and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.hands_played == 0
        and context.poker_hands and next(context.poker_hands[card.ability.type])) or context.forcetrigger then
            local ranks = {}
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    ranks[v.base.value] = (ranks[v.base.value] or 0) + 1
                end
            end
            local max_count, rank = 0, nil
            for k, v in pairs(ranks) do
                if max_count < v then max_count = v; rank = k end
            end
            for _, v in ipairs(context.scoring_hand) do
                if ranks[v.base.value] and ranks[v.base.value] ~= max_count then
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
    in_pool = function(self, args)
        if G.GAME.story_mode and args
        and args.source == "sho" and not G.GAME.won then
            return pseudorandom(self.key.."_story_mode") < 0.2
        end
        return true
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 4000,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 2 },
    soul_pos = { x = 2, y = 2, sgt_extra = { x = 1, y = 2 } },
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
                        assert(SMODS.change_base(new_card, nil, _rank.key))
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2000,
    pos = { x = 0, y = 3 },
    soul_pos = { x = 2, y = 3, sgt_extra = { x = 1, y = 3 } },
    config = {extra = {e_mult = 1, e_mult_mod_boss = 0.25, e_mult_mod_showdown = 0.5}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and G.GAME.blind.boss then
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
                    return nil, true
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
                    return nil, true
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2001,
    pools = { [SAGA_GROUP_POOL.norse] = true },
    pos = { x = 3, y = 0 },
    soul_pos = { x = 5, y = 0, sgt_extra = { x = 4, y = 0 } },
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2002,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 1 },
    soul_pos = { x = 5, y = 1, sgt_extra = { x = 4, y = 1 } },
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
                if not joker_card:can_calculate() then
                    return 0
                end
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2003,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 2 },
    soul_pos = { x = 5, y = 2, sgt_extra = { x = 4, y = 2 } },
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "norse_mythology",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 2004,
    pools = { [SAGA_GROUP_POOL.norse] = true, [SAGA_GROUP_POOL.ngods] = true },
    pos = { x = 3, y = 3 },
    soul_pos = { x = 5, y = 3, sgt_extra = { x = 4, y = 3 } },
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
                        local new_tag = Tag(tag, false, 'Small')
                        if tag == 'tag_orbital' then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
                            end
                            if new_tag.ability.orbital_hand == '['..localize('k_poker_hand')..']' then
                                new_tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('orbital'))
                            end
                        end
                        add_tag(new_tag)
                        -- add_tag{key = tag} TODO: use this in next release of SMODS
                    end
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    save_run()
                    return true
                end)
            }))
            if not context.blueprint and not context.retrigger_joker then
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
            return nil, true
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

local three_body = {
    key = "three_body",
    name = "Three-body Dynamics",
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "celestaverse",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 3000,
    pools = { [SAGA_GROUP_POOL.celestaverse] = true },
    pos = { x = 6, y = 0 },
    soul_pos = { x = 8, y = 0, sgt_extra = { x = 7, y = 0 } },
    config = {extra = {amount = 1}},
    rarity = "sgt_esoteric",
    cost = 50,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.before or context.forcetrigger then
            SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
            if (G.SETTINGS.FASTFORWARD or 0) == 0 then
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = true
                    return true end }))
                update_hand_text({delay = 0}, {mult = '+', StatusText = true})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    return true end }))
                update_hand_text({delay = 0}, {chips = '+', StatusText = true})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = nil
                    return true end }))
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+'..card.ability.extra.amount})
                delay(1.3)
                for _, v in ipairs(G.handlist) do
                    if SMODS.is_poker_hand_visible(v) then
                        level_up_hand(card, v, true, card.ability.extra.amount)
                    end
                end
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(context.scoring_name, 'poker_hands'),chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level=G.GAME.hands[context.scoring_name].level})
            else
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                return true end }))
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0.3}, {chips = '+', mult = '+', level='+'..card.ability.extra.amount, StatusText = true})
                delay(1.3)
                for _, v in ipairs(G.handlist) do
                    if SMODS.is_poker_hand_visible(v) then
                        level_up_hand(card, v, true, card.ability.extra.amount)
                    end
                end
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(context.scoring_name, 'poker_hands'),chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level=G.GAME.hands[context.scoring_name].level})
            end
        end
        if (context.setting_blind and not card.getting_sliced
        and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            local removed_levels = to_big(0)
            local three_most_played_hands_table = {}
            local three_most_played_hands_list = {}
            for _ = 1, 3 do
                local _hand, _tally = nil, -1
                for _, v in ipairs(G.handlist) do
                    if SMODS.is_poker_hand_visible(v) and G.GAME.hands[v].played > _tally
                    and not table.contains(three_most_played_hands_list, v) then
                        _hand = v
                        _tally = G.GAME.hands[v].played
                    end
                end
                if _hand then
                    three_most_played_hands_table[_hand] = 0
                    table.insert(three_most_played_hands_list, _hand)
                end
            end
            for _, v in pairs(G.handlist) do
                if to_big(G.GAME.hands[v].level) > to_big(1) then
                    local this_removed_levels = G.GAME.hands[v].level - 1
                    removed_levels = removed_levels + this_removed_levels
                    level_up_hand(card, v, true, -to_number(this_removed_levels))
                end
            end
            local safe_removed_levels = math.min(to_number(removed_levels), 1e25)
            for i = 1, safe_removed_levels do
                local chosen_hand = pseudorandom_element(three_most_played_hands_list, pseudoseed("three_body_distribute"..i))
                three_most_played_hands_table[chosen_hand] = three_most_played_hands_table[chosen_hand] + 1
            end
            for hand_type, amount in pairs(three_most_played_hands_table) do
                if amount > 0 then
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type, nil, amount)
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount}}
    end,
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge(localize('ph_celestaverse'), G.C.SGT_SAGADITION, G.C.WHITE, 1 )
    end,
}

local azathoth = {
    key = "azathoth",
    name = "Azathoth",
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 4001,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 4 },
    soul_pos = { x = 2, y = 4, sgt_extra = { x = 1, y = 4 } },
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
                return true
            end)}))
            if not context.blueprint and not context.retrigger_joker then
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
                    return nil, true
                else
                    card.ability.extra.amount = card.ability.extra.amount + card.ability.extra.amount_mod
                    return {
                        message = localize('k_zzz'),
                        colour = G.C.SECONDARY_SET.Tarot,
                        card = card
                    }
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
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
    artist_credits = {"huycorn"},
    atlas = "esoteric",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 4002,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 3, y = 4 },
    soul_pos = { x = 5, y = 4, sgt_extra = { x = 4, y = 4 } },
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
    artist_credits = {"huycorn"},
    atlas = "nameless",
    saga_group = "lovecraft",
    no_collection = not Sagatro.mod_compat.talisman,
    order = 4003,
    pools = { [SAGA_GROUP_POOL.lcraft] = true },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 2, sgt_extra = { x = 0, y = 1 } },
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
        if (context.end_of_round and not context.game_over and context.main_eval and not context.blueprint) or context.forcetrigger then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.jokers then
                        G.jokers:change_size(card.ability.amount)
                    end
                    return true
                end,
            }))
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not (from_debuff or next(Sagatro.find_active_card("j_sgt_nameless"))) then
            G.GAME.antimatter_overload = 0.2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.antimatter_overload = next(Sagatro.find_active_card("j_sgt_nameless")) and G.GAME.antimatter_overload or nil
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
    artist_credits = {"amy"},
    atlas = "mabel",
    no_collection = not Sagatro.mod_compat.talisman,
    saga_group = "black_soul",
    order = 4004,
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
                    if (card.ability.immutable.switch or false) ~= Sagatro.mabel_stall() then
                        Sagatro.update_blind_amounts(true)
                        card.ability.immutable.switch = Sagatro.mabel_stall()
                    end
                    break
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.ending_shop and not context.blueprint and not context.retrigger_joker) or context.forcetrigger then
            if (G.jokers.cards[1] == card and G.jokers.cards[#G.jokers.cards].config.center_key ~= "j_sgt_mabel") or context.forcetrigger then
                Sagatro.ease_ante(-card.ability.amount)
            elseif G.jokers.cards[#G.jokers.cards] == card and G.jokers.cards[1].config.center_key ~= "j_sgt_mabel" then
                Sagatro.ease_ante(card.ability.amount)
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

Sagatro.test_joker = {
    hyperscore = {1, 1}
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
            "{X:dark_edition,C:white}#1##2##3##4#{} Score",
        }
    },
    order = 9999,
    debug_obj = true,
    config = {},
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.after then
            local ret = {}
            if next(Sagatro.test_joker.hyperscore) then
                local operator = "sgt_e_score"
                if Sagatro.test_joker.hyperscore[1] == 1 then
                    operator = "sgt_e_score"
                elseif Sagatro.test_joker.hyperscore[1] == 2 then
                    operator = "sgt_ee_score"
                elseif Sagatro.test_joker.hyperscore[1] == 3 then
                    operator = "sgt_eee_score"
                elseif Sagatro.test_joker.hyperscore[1] >= 4 then
                    operator = "sgt_hyper_score"
                end
                if operator ~= "sgt_hyper_score" then
                    ret[operator] = Sagatro.test_joker.hyperscore[2]
                else
                    ret[operator] = {Sagatro.test_joker.hyperscore[1], Sagatro.test_joker.hyperscore[2]}
                end
            end
            return ret
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {"{", Sagatro.test_joker.hyperscore[1], "}", Sagatro.test_joker.hyperscore[2]}}
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
    sub_engineer,
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
    faceless_cusk,
    brittle_star,
    comb_jellyfish,
    lobster,
    fangtooth,
    grenadier,
    mahimahi,
    seawater,
    nemo,
    mirror,
    white_pawn,
    white_queen,
    white_king,
    live_flowers,
    ticket_checker,
    man_in_white,
    goat,
    beetle,
    dinah,
    tweedledum,
    tweedledee,
    sheep,
    rocking_horse_fly,
    bread_and_butter_fly,
    snap_dragon_fly,
    white_rook,
    white_knight,
    white_bishop,
    jabberwock,
    bandersnatch,
    jubjub_bird,
    humpty_dumpty,
    seal_and_carpenter,
    lion,
    unicorn,
    true_red_queen,
    red_king,
    vorpal_sword,
    ecila,
    goldia,
    pocket_mirror,
    rose_bell,
    moon_hairbrush,
    snow_scissors,
    angel_scythe,
    egliette,
    fleta,
    harpae,
    lisette,
    enjel,
    knife_fork,
    rusty_scissors,
    platinum,
    ozzy,
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
    three_body,
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
        if v.debug_obj then
            v.exclude_from_pool = true
            v.no_doe = true
        end
        v.debug_obj = nil
        SMODS.Joker(v)
    end
end