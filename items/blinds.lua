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
    drawn_to_hand = function(self)
        if not G.GAME.blind.effect.extra.triggered then
            for _, card in pairs(G.hand.cards) do
                card.ability.true_perma_debuff = true
                card.ability.debuffed_by_turquoise_jellyfish = true
            end
            G.GAME.blind.effect.extra.triggered = true
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.ability.debuffed_by_turquoise_jellyfish then
                card.ability.true_perma_debuff = nil
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
		end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local blind_table = {
    red_queen,
    turquoise_jellyfish,
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