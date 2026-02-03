local talisman = Sagatro.mod_compat.talisman

local supply = {
    key = "Supply",
    primary_colour = HEX("AFB2B9"),
	secondary_colour = G.C.SGT_SUPPLY,
	collection_rows = { 4, 4 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_small_canned_fish",
}

local consumabletype_table = {
    supply,
}

for _, v in ipairs(consumabletype_table) do
    SMODS.ConsumableType(v)
end

local un_supply = {
    key = "Supply",
    atlas = "supply",
    pos = {x = 4, y = 1},
}

local undiscovered_sprite_table = {
    un_supply,
}

for _, v in ipairs(undiscovered_sprite_table) do
    SMODS.UndiscoveredSprite(v)
end

local streak = {
    key = "streak",
    name = "The Streak",
    artist_credits = {"huycorn"},
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
            seal = (streak_seed < 0.003  and talisman and 9)--0.3% (none without Talisman)
                or (streak_seed < 0.01   and talisman and 8)--0.7% (none without Talisman)
                or (streak_seed < 0.02                and 7)--  1% (2% without Talisman)
                or (streak_seed < 0.05                and 6)--  3%
                or (streak_seed < 0.15                and 5)-- 10%
                or (streak_seed < 0.25                and 4)-- 10%
                or (streak_seed < 0.45                and 3)-- 20%
                or (streak_seed < 0.7                 and 2)-- 25%
                or 1                                        -- 30%
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
    artist_credits = {"huycorn"},
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
    artist_credits = {"huycorn"},
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

local smithing = {
    key = "smithing",
    name = "Smithing",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 0, y = 0},
    config = {target_level = 2},
    cost = 4,
    can_use = function(self, card)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea") then
            return submarine.ability.immutable.armor_level + 1 == card.ability.target_level
        end
        return false
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                submarine.ability.immutable.armor_level = submarine.ability.immutable.armor_level + 1
                submarine:juice_up()
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.target_level or self.config.target_level}}
	end,
    in_pool = function(self, args)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea")
        and args.source == "spl" and next(SMODS.find_card("j_sgt_sub_engineer", true)) then
            return submarine.ability.immutable.armor_level + 1 == self.config.target_level
        end
        return false
    end,
}

local welding = {
    key = "welding",
    name = "Welding",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 1, y = 0},
    config = {target_level = 3, extra = {hand_size = 2}},
    cost = 4,
    can_use = function(self, card)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea") then
            return submarine.ability.immutable.armor_level + 1 == card.ability.target_level
        end
        return false
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                submarine.ability.immutable.armor_level = submarine.ability.immutable.armor_level + 1
                submarine:juice_up()
                G.hand:change_size(card.ability.extra.hand_size)
                submarine.ability.extra.hand_size_story_mode =
                submarine.ability.extra.hand_size_story_mode + card.ability.extra.hand_size
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.target_level or self.config.target_level, card and card.ability.extra.hand_size or self.config.extra.hand_size}}
	end,
    in_pool = function(self, args)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea")
        and args.source == "spl" and next(SMODS.find_card("j_sgt_sub_engineer", true)) then
            return submarine.ability.immutable.armor_level + 1 == self.config.target_level
        end
        return false
    end,
}

local composite = {
    key = "composite",
    name = "Composite",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 2, y = 0},
    config = {target_level = 4, extra = {consumable_slot = 1}},
    cost = 4,
    can_use = function(self, card)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea") then
            return submarine.ability.immutable.armor_level + 1 == card.ability.target_level
        end
        return false
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                submarine.ability.immutable.armor_level = submarine.ability.immutable.armor_level + 1
                submarine:juice_up()
                G.consumeables:change_size(card.ability.extra.consumable_slot)
                submarine.ability.extra.consumable_slot_story_mode =
                submarine.ability.extra.consumable_slot_story_mode + card.ability.extra.consumable_slot
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.target_level or self.config.target_level, card and card.ability.extra.consumable_slot or self.config.extra.consumable_slot}}
	end,
    in_pool = function(self, args)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea")
        and args.source == "spl" and next(SMODS.find_card("j_sgt_sub_engineer", true)) then
            return submarine.ability.immutable.armor_level + 1 == self.config.target_level
        end
        return false
    end,
}

local nanotech = {
    key = "nanotech",
    name = "Nano-tech",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 3, y = 0},
    config = {target_level = 5, extra = {joker_slot = 1}},
    cost = 4,
    can_use = function(self, card)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea") then
            return submarine.ability.immutable.armor_level + 1 == card.ability.target_level
        end
        return false
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                submarine.ability.immutable.armor_level = submarine.ability.immutable.armor_level + 1
                submarine:juice_up()
                G.jokers:change_size(card.ability.extra.joker_slot)
                submarine.ability.extra.joker_slot_story_mode =
                submarine.ability.extra.joker_slot_story_mode + card.ability.extra.joker_slot
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.target_level or self.config.target_level, card and card.ability.extra.joker_slot or self.config.extra.joker_slot}}
	end,
    in_pool = function(self, args)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine and Sagatro.storyline_check("20k_miles_under_the_sea")
        and args.source == "spl" and next(SMODS.find_card("j_sgt_sub_engineer", true)) then
            return submarine.ability.immutable.armor_level + 1 == self.config.target_level
        end
        return false
    end,
}

local small_canned_fish = {
    key = "small_canned_fish",
    name = "Small Canned Fish",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 0, y = 1},
    config = {amount = 2},
    cost = 4,
    can_use = function(self, card)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                Sagatro.resolve_hunger(card.ability.amount)
                submarine:juice_up()
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.amount or self.config.amount}}
	end,
    in_pool = function(self, args)
        return Sagatro.storyline_check("20k_miles_under_the_sea")
    end,
}

local medium_canned_fish = {
    key = "medium_canned_fish",
    name = "Medium Canned Fish",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 1, y = 1},
    config = {amount = 5},
    cost = 4,
    can_use = function(self, card)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                Sagatro.resolve_hunger(card.ability.amount)
                submarine:juice_up()
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.amount or self.config.amount}}
	end,
    in_pool = function(self, args)
        if Sagatro.storyline_check("20k_miles_under_the_sea") then
            return pseudorandom("medium_food_supply") < 0.33
        end
        return false
    end,
}

local large_canned_fish = {
    key = "large_canned_fish",
    name = "Large Canned Fish",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 2, y = 1},
    config = {amount = 10},
    cost = 4,
    can_use = function(self, card)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                Sagatro.resolve_hunger(card.ability.amount)
                submarine:juice_up()
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.amount or self.config.amount}}
	end,
    in_pool = function(self, args)
        if Sagatro.storyline_check("20k_miles_under_the_sea") then
            return pseudorandom("large_food_supply") < 0.11
        end
        return false
    end,
}

local fuel_barrel = {
    key = "fuel_barrel",
    name = "Fuel Barrel",
    artist_credits = {"huycorn"},
    set = "Supply",
    atlas = "supply",
    pos = {x = 3, y = 1},
    config = {amount = 1.5, uses = 3},
    cost = 4,
    can_use = function(self, card)
        return next(SMODS.find_card("j_sgt_submarine", true))
    end,
    keep_on_use = function(self, card)
        return next(SMODS.find_card("j_sgt_submarine", true)) and card.ability.uses > 1
    end,
    use = function(self, card, area, copier)
        local submarine = SMODS.find_card("j_sgt_submarine", true)[1]
        if submarine then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                Sagatro.resolve_fuel(card.ability.amount)
                submarine:juice_up()
                card.ability.uses = card.ability.uses - 1
                return true end }))
            delay(0.6)
        end
	end,
    loc_vars = function(self, info_queue, card)
		return {vars = {card and card.ability.amount or self.config.amount, card and card.ability.uses or self.config.uses}}
	end,
    in_pool = function(self, args)
        return Sagatro.storyline_check("20k_miles_under_the_sea")
    end,
}

local consumable_table = {
    streak,
    omniscience,
    lamp,
    smithing,
    welding,
    composite,
    nanotech,
    small_canned_fish,
    medium_canned_fish,
    large_canned_fish,
    fuel_barrel,
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
    always_scores = true,
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

local mirror = {
    key = "mirror",
    name = "Mirror Card",
    effect = "Mirror",
    atlas = "misc",
    pos = {x = 4, y = 2},
    config = {
        x_mult = 1.5,
    },
    no_collection = true, -- Current no plan on letting it appear outside Pocket Mirror
    eternal_compat = true, -- for eternal check
    replace_base_card = true,
    override_base_rank = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    calculate = function(self, card, context)
        -- Yes, I'm intending for this enhancement to also work like a joker
        if context.joker_main and context.cardarea == G.jokers then
            return {
                xmult = card.ability.x_mult
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.x_mult}}
    end,
}

local enhancement_table = {
    omniscient,
    mirror,
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

local edible = {
    key = "sgt_edible",
    name = "Edible",
    atlas = "misc",
    pos = {x = 3, y = 3},
    hide_badge = true,
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
}

local inedible = {
    key = "sgt_inedible",
    name = "Inedible",
    atlas = "misc",
    pos = {x = 2, y = 3},
    hide_badge = true,
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
}

local not_food = {
    key = "sgt_not_food",
    name = "Not Food",
    atlas = "misc",
    pos = {x = 1, y = 3},
    hide_badge = true,
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
}

local current_depth = {
    key = "sgt_current_depth",
    name = "Current Depth",
    atlas = "current_depth",
    pos = {x = 0, y = 0},
    hide_badge = true,
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
}

local off_depth = {
    key = "sgt_off_depth",
    name = "Off Depth",
    atlas = "misc",
    pos = {x = 4, y = 3},
    badge_colour = HEX("FF0000"),
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability.sgt_off_depth_tally = val and 3 or nil
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if card.ability.sgt_off_depth_tally == 1 then
                card.ability.sgt_off_depth_tally = 0
                SMODS.calculate_effect({message = localize('k_disabled_ex'), colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, card)
                SMODS.debuff_card(card, true, "sgt_off_depth_expired")
            else
                card.ability.sgt_off_depth_tally = card.ability.sgt_off_depth_tally - 1
                SMODS.calculate_effect({message = localize{type='variable',key='a_remaining',vars={card.ability.sgt_off_depth_tally}}, colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, card)
            end
        end
    end,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.sgt_off_depth_tally}}
        if card.ability.immutable and card.ability.immutable.depth_range then
            if card.ability.immutable.depth_range[1] == card.ability.immutable.depth_range[2] then
                ret.key = "sgt_off_depth_singular"
                ret.vars[#ret.vars+1] = card.ability.immutable.depth_range[1]
            else
                ret.vars[#ret.vars+1] = card.ability.immutable.depth_range[1]
                ret.vars[#ret.vars+1] = card.ability.immutable.depth_range[2]
            end
        else
            ret.key = "sgt_off_depth_not_fish"
        end
        return ret
    end,
}

local imminent_doom = {
    key = "sgt_imminent_doom",
    name = "Imminent Doom",
    atlas = "misc",
    pos = {x = 0, y = 3},
    badge_colour = HEX("BE5938"),
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
    loc_vars = function(self, info_queue, card)
        if card then
            if card.config.center_key == "j_sgt_submarine" then
                if card.ability.immutable.states.fuel_left <= 0 then
                    return {key = "sgt_imminent_doom_f"}
                elseif card.ability.immutable.states.hunger_left <= 0 then
                    return {key = "sgt_imminent_doom_h"}
                end
            elseif card.ability.storyline_derailed then
                return {key = "sgt_imminent_doom_sd"}
            end
        end
    end,
}

local easter_egg = {
    key = "sgt_easter_egg",
    name = "Easter Egg",
    atlas = "misc",
    pos = {x = 2, y = 4},
    badge_colour = G.C.SGT_SAGADITION,
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
}

local mirrored = {
    key = "sgt_mirrored",
    name = "Mirrored",
    atlas = "misc",
    pos = {x = 1, y = 4},
    badge_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25),
    prefix_config = { key = false },
    sets = { Joker = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    apply = function(self, card, val)
        card.ability[self.key] = val
        Sagatro.update_inactive_state()
    end,
}

local butterfly = {
    key = "sgt_butterfly",
    name = "Butterfly",
    atlas = "misc",
    pos = {x = 0, y = 4},
    hide_badge = true,
    prefix_config = { key = false },
    sets = { Default = true, Enhanced = true },
    no_collection = true,
    no_sticker_sheet = true,
    should_apply = false,
    draw = function(self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
}

local sticker_table = {
    protected,
    edible,
    inedible,
    not_food,
    current_depth,
    off_depth,
    imminent_doom,
    easter_egg,
    mirrored,
    butterfly,
}

for _, v in ipairs(sticker_table) do
    SMODS.Sticker(v)
end