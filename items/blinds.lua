local red_queen = {
    key = "red_queen",
    name = "Queen Of Hearts",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
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
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips/3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("final_showdown", "finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
            if Sagatro.storyline_check("alice_in_mirrorworld") then
                G.GAME.paused_showdown = nil
                G.GAME.mirrorworld_showdown = true
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or next(SMODS.find_card("j_sgt_red_queen", true)) or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local turquoise_jellyfish = {
    key = "turquoise_jellyfish",
    name = "Turquoise Jellyfish",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 1 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("31CFB2"),
    press_play = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            local selected_cards = Sagatro.random_select("turquoise_jellyfish", G.play, 2)
            for _, card in pairs(selected_cards) do
                card.ability.perma_debuff = true
                card.ability.debuffed_by_turquoise_jellyfish = true
                card:juice_up()
            end
        return true end }))
        G.GAME.blind.triggered = true
        delay(0.7)
        return true
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff and card.ability.set ~= "Joker"
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.ability.debuffed_by_turquoise_jellyfish then
                card.ability.perma_debuff = nil
                card.ability.debuffed_by_turquoise_jellyfish = nil
                card:set_debuff()
            end
        end
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuff then
                card:set_debuff()
            end
        end
        if G.GAME.story_mode then
            Sagatro.progress_storyline("turquoise_jellyfish", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            local card = SMODS.find_card("j_sgt_submarine", true)[1]
            if card then
                card.ability.immutable.pending_go_down = nil
                G.FUNCS.submarine_down({config = {ref_table = card}}, true)
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local aqua_eyeshard = {
    key = "aqua_eyeshard",
    name = "Aqua Eyeshard",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 2 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("24B2CE"),
    set_blind = function(self, reset, silent)
        if not reset then
            G.GAME.blind.hands = {}
            for _, v in ipairs(G.handlist) do
                G.GAME.blind.hands[v] = G.GAME.hands[v].played_this_ante > 0
            end
        end
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.hands[handname] then
            G.GAME.blind.triggered = true
            return true
        end
        if not check then G.GAME.blind.hands[handname] = true end
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("aqua_eyeshard", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            local card = SMODS.find_card("j_sgt_submarine", true)[1]
            if card then
                card.ability.immutable.pending_go_down = nil
                G.FUNCS.submarine_down({config = {ref_table = card}}, true)
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local black_oil = {
    key = "black_oil",
    name = "Black Oil",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 3 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("2F6771"),
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("black_oil", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            local card = SMODS.find_card("j_sgt_submarine", true)[1]
            if card then
                card.ability.immutable.pending_go_down = nil
                G.FUNCS.submarine_down({config = {ref_table = card}}, true)
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local shadow_seamine = {
    key = "shadow_seamine",
    name = "Shadow Seamine",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 4 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("086F84"),
    calculate = function(self, blind, context)
        if context.after and not (blind.disabled or context.retrigger_joker) then --???
            if SMODS.pseudorandom_probability(self, "shadow_seamine", 1, 6) then
                blind.triggered = true
                if G.jokers.cards[1] then
                    local eligible_jokers = {}
                    for _, v in ipairs(G.jokers.cards) do
                        if not SMODS.is_eternal(v, blind) then
                            eligible_jokers[#eligible_jokers+1] = v
                        end
                    end
                    if #eligible_jokers > 0 then
                        local selected_joker = pseudorandom_element(eligible_jokers, pseudoseed("seamine_select"))
                        local kaboom = function()
                            card_eval_status_text(selected_joker, 'extra', nil, nil, nil, {message = localize('k_kaboom_ex'), instant = true})
                        end
                        Sagatro.self_destruct(selected_joker, {sound = "sgt_explosion", volume = 0.7}, kaboom)
                    end
                end
            end
        end
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("shadow_seamine", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            local card = SMODS.find_card("j_sgt_submarine", true)[1]
            if card then
                card.ability.immutable.pending_go_down = nil
                G.FUNCS.submarine_down({config = {ref_table = card}}, true)
                G.GAME.nyx_abyss_incoming = true
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
    loc_vars = function(self)
        return {vars = {SMODS.get_probability_vars(self, 1, 6, "shadow_seamine")}}
    end,
    collection_loc_vars = function(self)
        return {vars = {'1', '6'}}
    end,
}

local nyx_abyss = {
    key = "nyx_abyss",
    name = "Nyx Abyss",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 5 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("430D44"),
    config = {extra = {hands_removed = 0, hand_size = 1}},
    calculate = function(self, blind, context)
        if context.after or context.pre_discard then
            blind.effect.extra.hands_removed = blind.effect.extra.hands_removed + blind.effect.extra.hand_size
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.7, func = function()
                G.hand:change_size(-1 * blind.effect.extra.hand_size)
                SMODS.juice_up_blind()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end}))
            delay(0.4)
        end
    end,
    disable = function(self)
        if G.GAME.blind and G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.hands_removed then
            G.hand:change_size(G.GAME.blind.effect.extra.hands_removed)
        end
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("nyx_abyss", "finish", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            local card = SMODS.find_card("j_sgt_submarine", true)[1]
            if card then
                card.ability.immutable.pending_go_down = nil
                G.GAME.nyx_abyss_incoming = nil
            end
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local the_pawn = {
    key = "pawn",
    name = "The Pawn",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 6 },
    mult = 2,
    dollars = 5,
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX("901a1a"),
    config = {extra = {chips = 75}},
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        G.GAME.blind.triggered = true
        if G.GAME.inversed_scaling then
            return mult, hand_chips + G.GAME.blind.effect.extra.chips, true
        end
        return mult, math.max(hand_chips - G.GAME.blind.effect.extra.chips, 0), true
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("the_pawn", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return G.GAME.round_resets.ante >= self.boss.min and not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
    loc_vars = function(self)
        return { vars = { (G.GAME.inversed_scaling and '+' or '-')..(G.GAME.blind and G.GAME.blind.effect
        and G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.chips or self.config.extra.chips) } }
    end,
    collection_loc_vars = function(self)
        return { vars = { (G.GAME.inversed_scaling and '+' or '-')..(G.GAME.blind and G.GAME.blind.effect
        and G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.chips or self.config.extra.chips) } }
    end,
}

local the_rook = {
    key = "rook",
    name = "The Rook",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 7 },
    mult = 2,
    dollars = 5,
    boss = {
        min = 4,
        max = 10,
    },
    boss_colour = HEX("901a1a"),
    press_play = function(self)
        for _, v in ipairs(G.hand.cards) do
            if not v.highlighted then
                v:set_ability("m_stone", nil, true)
                G.E_MANAGER:add_event(Event({func = function()
                    v:juice_up()
                return true end }))
            end
        end
        delay(0.7)
        return true
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("the_rook", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return G.GAME.round_resets.ante >= self.boss.min and not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local the_knight = {
    key = "knight",
    name = "The Knight",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 8 },
    mult = 2,
    dollars = 5,
    boss = {
        min = 5,
        max = 10,
    },
    boss_colour = HEX("901a1a"),
    calculate = function(self, blind, context)
        if context.before then
            for i, v in pairs(context.full_hand) do
                if i ~= 1 and i ~= #context.full_hand and table.contains(context.scoring_hand, v) then
                    blind.triggered = true
                end
            end
        end
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("the_knight", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return G.GAME.round_resets.ante >= self.boss.min and not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local the_bishop = {
    key = "bishop",
    name = "The Bishop",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 9 },
    mult = 2,
    dollars = 5,
    boss = {
        min = 5,
        max = 10,
    },
    boss_colour = HEX("901a1a"),
    recalc_debuff = function(self, card, from_blind)
        if card.ability.set == "Default" or card.ability.set == "Enhanced" then
            return card:is_suit("Spades", true) or card:is_suit("Clubs", true)
        end
        return false
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("the_bishop", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return G.GAME.round_resets.ante >= self.boss.min and not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local true_red_queen = {
    key = "true_red_queen",
    name = "Red Queen",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 10 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("be0606"),
    config = {extra = {cume_modifier = 1}},
    calculate = function(self, blind, context)
        if context.after and not (blind.disabled or context.retrigger_joker) then --???
            if G.GAME.inversed_scaling then
                G.E_MANAGER:add_event(Event({func = function()
                    if to_big(G.GAME.chips) < to_big(blind.chips)/2 then
                        blind.triggered = true
                        blind.chips = blind.chips/2
                        blind.effect.extra.cume_modifier = blind.effect.extra.cume_modifier/2
                        blind.chip_text = number_format(blind.chips)
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                            play_sound('tarot2', 0.76, 0.4);return true end}))
                        play_sound('tarot2', 1, 0.4)
                    end
                return true end }))
            else
                G.E_MANAGER:add_event(Event({func = function()
                    if to_big(G.GAME.chips) < to_big(blind.chips) then
                        blind.triggered = true
                        blind.chips = blind.chips*2
                        blind.effect.extra.cume_modifier = blind.effect.extra.cume_modifier*2
                        blind.chip_text = number_format(blind.chips)
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                            play_sound('tarot2', 0.76, 0.4);return true end}))
                        play_sound('tarot2', 1, 0.4)
                    end
                return true end }))
            end
        end
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips/G.GAME.blind.effect.extra.cume_modifier
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("true_red_queen", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
    loc_vars = function(self)
        return { key = G.GAME.inversed_scaling and "bl_sgt_true_red_queen_inv" or "bl_sgt_true_red_queen"}
    end,
    collection_loc_vars = function(self)
        return { key = G.GAME.inversed_scaling and "bl_sgt_true_red_queen_inv" or "bl_sgt_true_red_queen"}
    end,
}

local red_king = {
    key = "red_king",
    name = "Red King",
    -- artist_credits = {"huycorn"},
    atlas = "blinds",
    pos = { x = 0, y = 11 },
    mult = 2,
    dollars = 8,
    boss = {
        min = 1,
        max = 10,
        showdown = true,
    },
    boss_colour = HEX("be0606"),
    config = {extra = {cume_modifier = 1}},
    calculate = function(self, blind, context)
        if context.before and not (blind.disabled or context.retrigger_joker) then --???
            if G.GAME.hands[context.scoring_name].played > 0 then -- Cryptid compat?
                if G.GAME.inversed_scaling then
                    G.E_MANAGER:add_event(Event({func = function()
                        blind.triggered = true
                        blind.chips = blind.chips/G.GAME.hands[context.scoring_name].played
                        blind.effect.extra.cume_modifier = blind.effect.extra.cume_modifier/G.GAME.hands[context.scoring_name].played
                        blind.chip_text = number_format(blind.chips)
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                            play_sound('tarot2', 0.76, 0.4);return true end}))
                        play_sound('tarot2', 1, 0.4)
                    return true end }))
                else
                    G.E_MANAGER:add_event(Event({func = function()
                        blind.triggered = true
                        blind.chips = blind.chips*G.GAME.hands[context.scoring_name].played
                        blind.effect.extra.cume_modifier = blind.effect.extra.cume_modifier*G.GAME.hands[context.scoring_name].played
                        blind.chip_text = number_format(blind.chips)
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                            play_sound('tarot2', 0.76, 0.4);return true end}))
                        play_sound('tarot2', 1, 0.4)
                    return true end }))
                end
            end
        end
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips/G.GAME.blind.effect.extra.cume_modifier
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
    defeat = function(self)
        if G.GAME.story_mode then
            Sagatro.progress_storyline("red_king", "force_finish", "alice_in_wonderland", G.GAME.interwoven_storyline)
        end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
    loc_vars = function(self)
        return { key = G.GAME.inversed_scaling and "bl_sgt_red_king_inv" or "bl_sgt_red_king"}
    end,
    collection_loc_vars = function(self)
        return { key = G.GAME.inversed_scaling and "bl_sgt_red_king_inv" or "bl_sgt_red_king"}
    end,
}

local blind_table = {
    red_queen,
    turquoise_jellyfish,
    aqua_eyeshard,
    black_oil,
    shadow_seamine,
    nyx_abyss,
    the_pawn,
    the_rook,
    the_knight,
    the_bishop,
    true_red_queen,
    red_king,
}

for _, v in ipairs(blind_table) do
    if Sagatro.debug then
        v.discovered = true
    end
    SMODS.Blind(v)
end

if JokerDisplay then
    local jd_blind_def = JokerDisplay.Blind_Definitions

    jd_blind_def["bl_sgt_red_queen"] = {
        trigger_function = function(blind, text, poker_hands, scoring_hand, full_hand)
            return true
        end
    }
    jd_blind_def["bl_sgt_aqua_eyeshard"] = {
        trigger_function = function(blind, text, poker_hands, scoring_hand, full_hand)
            return blind.hands[text] or false
        end
    }
    jd_blind_def["bl_sgt_knight"] = {
        trigger_function = function(blind, text, poker_hands, scoring_hand, full_hand)
            if text ~= 'Unknown' then
                for i, played_card in pairs(full_hand) do
                    if i ~= 1 and i ~= #full_hand and table.contains(scoring_hand, played_card) then
                        return true
                    end
                end
            end
            return false
        end
    }
    jd_blind_def["bl_sgt_bishop"] = {
        trigger_function = function(blind, text, poker_hands, scoring_hand, full_hand)
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_card:is_suit("Spades", true) or scoring_card:is_suit("Clubs", true) then
                        return true
                    end
                end
            end
            return false
        end
    }
end