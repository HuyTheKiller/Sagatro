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

local drink_me = {
    key = "drink_me",
    name = "Drink Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pos = { x = 1, y = 0 },
    config = { extra = 1 },
	rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[1] == card and not context.blueprint and G.jokers.cards[#G.jokers.cards].ability.name ~= "Eat Me!" then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if SMODS.has_no_rank(v) or v:get_id() > 2 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.base.id = SMODS.has_no_rank(v) and v.base.id or 2
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
    in_pool = function(self, args)
        if SMODS.Mods["Sagatro"].config.DisableOtherJokers then
            return next(find_joker("White Rabbit"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
}

local eat_me = {
    key = "eat_me",
    name = "Eat Me!",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pos = { x = 2, y = 0 },
    config = { extra = 1 },
	rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if G and G.jokers and G.jokers.cards and G.jokers.cards[1]
        and G.jokers.cards[#G.jokers.cards] == card and not context.blueprint and G.jokers.cards[1].ability.name ~= "Drink Me!" then
            if context.before then
                for _, v in ipairs(context.scoring_hand) do
                    if SMODS.has_no_rank(v) or v:get_id() < 14 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.base.id = SMODS.has_no_rank(v) and v.base.id or 14
                                local rank_suffix = sgt_get_rank_suffix(v)
                                assert(SMODS.change_base(v, nil, rank_suffix))

                                return true
                            end
                        }))
                    end
                end
                return {
                    message = localize("k_enlarged_ex"),
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
    in_pool = function(self, args)
        if SMODS.Mods["Sagatro"].config.DisableOtherJokers then
            return next(find_joker("White Rabbit"))
        end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
}

local chesire_cat = {
    key = "chesire_cat",
    name = "Cheshire Cat",
    atlas = "alice_in_wonderland",
    saga_group = "alice_in_wonderland",
    pos = { x = 0, y = 0 },
    config = {extra = {copied_joker = nil, copied_joker_value_id = 0, copied_joker_buffer_name = nil, odds = 4}},
	rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            card.ability.extra.copied_joker = nil
            local potential_jokers = {}
            for i=1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.key ~= "j_sgt_chesire_cat" and G.jokers.cards[i].config.center.blueprint_compat then
                    potential_jokers[#potential_jokers+1] = G.jokers.cards[i]
                end
            end
            if #potential_jokers > 0 then
                local chosen_joker = pseudorandom_element(potential_jokers, pseudoseed('chesire_cat'))
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
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            if pseudorandom('chesire_cat_vanish') < G.GAME.probabilities.normal/card.ability.extra.odds then
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
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.copied_joker then
            if G.P_CENTERS[card.ability.extra.copied_joker.config.center_key] then
                info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.copied_joker.config.center_key]
            end
            return {vars = {localize{type = 'name_text', set = "Joker", key = card.ability.extra.copied_joker.config.center_key, nodes = {}}, G.GAME.probabilities.normal, card.ability.extra.odds, Sagatro.debug and card.ability.extra.copied_joker_value_id}}
        else
            return {vars = {localize('k_none'), G.GAME.probabilities.normal, card.ability.extra.odds, Sagatro.debug and card.ability.extra.copied_joker_value_id}}
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

local joker_table = {
    white_rabbit,
    drink_me,
    eat_me,
    chesire_cat,
}

for _, v in ipairs(joker_table) do
    SMODS.Joker(v)
end