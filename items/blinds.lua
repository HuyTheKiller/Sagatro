local red_queen = {
    key = "red_queen",
    name = "Red Queen",
    atlas = "red_queen",
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
    disable = function(self, silent)
		G.GAME.blind.chips = G.GAME.blind.chips/3
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end,
    defeat = function(self, silent)
        if G.GAME.story_mode then
            G.GAME.saga_event_check.alice_in_wonderland.final_showdown = true
		end
    end,
    in_pool = function(self)
        return not (G.GAME.story_mode or next(SMODS.find_card("j_sgt_red_queen", true)) or G.GAME.modifiers.sgt_disable_sagatro_items)
    end,
}

local blind_table = {
    red_queen,
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