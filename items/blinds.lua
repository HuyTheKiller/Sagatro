local red_queen = {
    key = "red_queen",
    name = "Queen Of Hearts",
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
		end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or next(SMODS.find_card("j_sgt_red_queen", true)) or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local turquoise_jellyfish = {
    key = "turquoise_jellyfish",
    name = "Turquoise Jellyfish",
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
    config = {extra = {triggered = false}},
    press_play = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            local selected_cards = Sagatro.random_select("turquoise_jellyfish", G.play, 2)
            for _, card in pairs(selected_cards) do
                card.ability.perma_debuff = true
                card.ability.debuffed_by_turquoise_jellyfish = true
                card:juice_up(0.8, 0.8)
            end
        return true end }))
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
        if context.after then
            if SMODS.pseudorandom_probability(self, "shadow_seamine", 1, 6) then
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
        return {vars = {'1', '6' }}
    end,
}

local nyx_abyss = {
    key = "nyx_abyss",
    name = "Nyx Abyss",
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

local blind_table = {
    red_queen,
    turquoise_jellyfish,
    aqua_eyeshard,
    black_oil,
    shadow_seamine,
    nyx_abyss,
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
end