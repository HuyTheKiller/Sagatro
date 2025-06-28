local blue_streak = {
    key = "blue_streak",
    name = "Blue Streak",
    atlas = "colour_streaks",
    pos = {x = 0, y = 0},
    config = {chips = 50},
    badge_colour = HEX('0091E4'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
				sound = "chips1",
                chip_mod = card.ability.seal.chips,
				message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.seal.chips}}
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.chips or self.config.chips}}
    end,
}

local red_streak = {
    key = "red_streak",
    name = "Red Streak",
    atlas = "colour_streaks",
    pos = {x = 1, y = 0},
    config = {mult = 10},
    badge_colour = HEX('ED0000'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult_mod = card.ability.seal.mult,
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.seal.mult}}
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.mult or self.config.mult}}
    end,
}

local gold_streak = {
    key = "gold_streak",
    name = "Gold Streak",
    atlas = "colour_streaks",
    pos = {x = 2, y = 0},
    config = {dollars = 2},
    badge_colour = HEX('E7A73D'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    get_p_dollars = function(self, card)
        return card.ability.seal.dollars
    end,
    draw = function(self, card, layer)
        if card.seal and card.seal == self.key then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.dollars or self.config.dollars}}
    end,
}

local purple_streak = {
    key = "purple_streak",
    name = "Purple Streak",
    atlas = "colour_streaks",
    pos = {x = 3, y = 0},
    config = {xmult = 1.5},
    badge_colour = HEX('8C21E6'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                Xmult_mod = card.ability.seal.xmult,
                message = localize{type='variable', key='a_xmult', vars={card.ability.seal.xmult}}
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.xmult or self.config.xmult}}
    end,
}

local celurean_streak = {
    key = "celurean_streak",
    name = "Celurean Streak",
    atlas = "colour_streaks",
    pos = {x = 4, y = 0},
    config = {xchip = 1.5},
    badge_colour = HEX('3368B8'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                Xchip_mod = card.ability.seal.xchip,
                message = localize{type='variable', key='a_xchips', vars={card.ability.seal.xchip}}
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.xchip or self.config.xchip}}
    end,
}

local cosmic_streak = {
    key = "cosmic_streak",
    name = "Cosmic Streak",
    atlas = "cosmic_streak",
    pos = {x = 0, y = 0},
    config = {planet_count = 1},
    badge_colour = HEX('47666C'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'cos')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    return true
                end)}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.planet_count or self.config.planet_count}}
    end,
}

local crimson_streak = {
    key = "crimson_streak",
    name = "Crimson Streak",
    atlas = "colour_streaks",
    pos = {x = 5, y = 0},
    config = {emult = 1.1},
    badge_colour = HEX('760808'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                e_mult = card.ability.seal.emult,
                card = card
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.emult or self.config.emult}}
    end,
}

local black_streak = {
    key = "black_streak",
    name = "Black Streak",
    atlas = "colour_streaks",
    dependencies = {"Talisman"},
    pos = {x = 6, y = 0},
    config = {eemult = 1.05},
    badge_colour = HEX('2D2E29'),
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                ee_mult = card.ability.seal.eemult,
                card = card
			}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.eemult or self.config.eemult}}
    end,
}

local gods_miracle = {
    key = "gods_miracle",
    name = "God's Miracle",
    atlas = "gods_miracle",
    dependencies = {"Talisman"},
    pos = {x = 0, y = 0},
    config = {eeemult = 1.02},
    badge_colour = G.C.SGT_MIRACLE,
    sound = { sound = 'sgt_painting', per = 1, vol = 1 },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                eee_mult = card.ability.seal.eeemult,
                card = card
			}
        end
        if context.end_of_round and not context.individual and not context.repetition
        and context.game_over and not G.GAME.saved_by_gods_miracle then
            G.GAME.saved_by_gods_miracle = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    if SMODS.shatters(card) then
                        card:shatter()
                    else
                        card:start_dissolve(nil, true)
                    end
                return true end }))
            return {
                message = localize('k_saved_ex'),
                saved = "ph_gods_miracle",
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.eeemult or self.config.eeemult}}
    end,
}

local streak_table = {
    blue_streak,
    red_streak,
    gold_streak,
    purple_streak,
    celurean_streak,
    cosmic_streak,
    crimson_streak,
    black_streak,
    gods_miracle,
}

for _, v in ipairs(streak_table) do
    SMODS.Seal(v) -- LMAO, declaring these stuff as seals is absolute cinema
end