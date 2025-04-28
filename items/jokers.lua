local white_rabbit = {
    key = "white_rabbit",
    name = "White Rabbit",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 0, chip_gain = 6 } },
	rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
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
        if context.discard and not context.blueprint and context.other_card == context.full_hand[1] then
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
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
}

local joker_table = {
    white_rabbit,
}

for _, v in ipairs(joker_table) do
    SMODS.Joker(v)
end