local talisman = Sagatro.mod_compat.talisman

local streak = {
    key = "streak",
    name = "The Streak",
    set = "Spectral",
    atlas = "misc",
    pos = {x = 0, y = 0},
    config = {
        max_highlighted = 1,
        seals = {
            chips = 50,
            mult = 10,
            dollars = 2,
            xmult = 1.5,
            xchip = 1.5,
            planet_count = 1,
            emult = 1.1,
            eemult = 1.05,
            eeemult = 1.02,
        },
    },
    cost = 4,
    hidden = true,
    soul_set = "Tarot",
    soul_rate = 0.05,
    streak_options = function(self)
        local options = {
            "sgt_blue_streak",
            "sgt_red_streak",
            "sgt_gold_streak",
            "sgt_purple_streak",
            "sgt_celurean_streak",
            "sgt_cosmic_streak",
            "sgt_crimson_streak",
            "sgt_black_streak",
            "sgt_gods_miracle",
        }
        local loc_vars = {
            sgt_blue_streak_seal = "chips",
            sgt_red_streak_seal = "mult",
            sgt_gold_streak_seal = "dollars",
            sgt_purple_streak_seal = "xmult",
            sgt_celurean_streak_seal = "xchip",
            sgt_cosmic_streak_seal = "planet_count",
            sgt_crimson_streak_seal = "emult",
            sgt_black_streak_seal = talisman and "eemult" or nil,
            sgt_gods_miracle_seal = talisman and "eeemult" or nil,
        }
        return options, loc_vars
    end,
    use = function(self, card, area, copier)
        local options = self:streak_options()
		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					highlighted:juice_up(0.3, 0.5)
					return true
				end,
			}))
            local streak_seed, seal = pseudorandom("streak_gen"), nil
            seal = (streak_seed < 0.003  and talisman and 9)
                or (streak_seed < 0.01   and talisman and 8)
                or (streak_seed < 0.02                and 7)
                or (streak_seed < 0.05                and 6)
                or (streak_seed < 0.15                and 5)
                or (streak_seed < 0.25                and 4)
                or (streak_seed < 0.45                and 3)
                or (streak_seed < 0.7                 and 2)
                or 1
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(options[seal], nil, true)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
    loc_vars = function(self, info_queue, card)
		local _, loc_vars = self:streak_options()
        for k, v in pairs(loc_vars) do
            info_queue[#info_queue+1] = {set = "Other", key = k, specific_vars = {self.config.seals[v]}}
        end
		return {vars = {card and card.ability.max_highlighted or self.config.max_highlighted}}
	end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end
}

local lamp = {
    key = "lamp",
    name = "The Magic Lamp",
    set = "Spectral",
    atlas = "esoteric",
    no_collection = not Sagatro.mod_compat.talisman,
    pos = {x = 0, y = 1},
    config = {},
    cost = 4,
    hidden = true,
    soul_rate = 0.009,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            assert(SMODS.add_card({
                set = "Joker",
                skip_materialize = true,
                key = "j_sgt_magic_lamp",
            }))
            return true end }))
        delay(0.6)
	end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_sgt_magic_lamp"]
		return {vars = {localize{type = 'name_text', set = "Joker", key = "j_sgt_magic_lamp", nodes = {}}}}
	end,
    in_pool = function(self, args)
        return not (next(SMODS.find_card("j_sgt_lamp_genie", true)) or next(SMODS.find_card("j_sgt_magic_lamp", true))
        or G.GAME.modifiers.sgt_disable_sagatro_items) and Sagatro.mod_compat.talisman
    end
}

local omniscience = {
    key = "omniscience",
    name = "The Omniscience",
    set = "Spectral",
    atlas = "misc",
    pos = {x = 1, y = 0},
    config = {mod_conv = 'm_sgt_omniscient', max_highlighted = 1},
    cost = 4,
    hidden = true,
    soul_set = "Tarot",
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_omniscient
		return {vars = {card and card.ability.max_highlighted or self.config.max_highlighted, localize{type = 'name_text', set = "Enhanced", key = "m_sgt_omniscient", nodes = {}}}}
	end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end
}

local consumable_table = {
    streak,
    omniscience,
    lamp,
}

for _, v in ipairs(consumable_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Consumable(v)
end

local omniscient = {
    key = "omniscient",
    name = "Omniscient Card",
    effect = "Omniscient",
    atlas = "misc",
    pos = {x = 4, y = 4},
    config = {
        bonus = 80,
        mult = 24,
        x_mult = 2,
        h_x_mult = 1.5,
        p_dollars = 20,
        h_dollars = 3,
        extra = 15,
    },
    any_suit = true,
    shatters = true,
    always_score = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card
        and SMODS.pseudorandom_probability(card, 'omniscient_glass', 1, card.ability.extra, "omniscient") then
            card.glass_trigger = true
            return { remove = true }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra, "omniscient")}}
    end,
}

local enhancement_table = {
    omniscient,
}

for _, v in ipairs(enhancement_table) do
    SMODS.Enhancement(v)
end

local protected = {
    key = "sgt_protected",
    name = "Protected",
    atlas = "misc",
    pos = {x = 3, y = 4},
    badge_colour = HEX("70757D"),
    prefix_config = { key = false },
    sets = { Default = true, Enhanced = true, Joker = true },
    no_sticker_sheet = true, -- Cryptid compat
    should_apply = false,
    apply = function(self, card, val)
        if G.STAGE == G.STAGES.RUN then
            SMODS.debuff_card(card, val and "prevent_debuff" or nil, "sgt_protected")
        end
        card.ability[self.key] = val
    end,
}

local sticker_table = {
    protected,
}

for _, v in ipairs(sticker_table) do
    SMODS.Sticker(v)
end