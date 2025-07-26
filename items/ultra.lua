local divinatio = {
    key = "Divinatio",
    primary_colour = HEX("f4ff00"),
	secondary_colour = G.C.SGT_DIVINATIO,
	collection_rows = { 5, 6 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_strength",
	can_stack = true,
	can_divide = true,
}

local eldritch = {
    key = "Eldritch",
    primary_colour = HEX("e264f9"),
	secondary_colour = G.C.SGT_ELDRITCH,
	collection_rows = { 4, 5 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_chanting",
	can_stack = true,
	can_divide = true,
}

local consumabletype_table = {
    -- divinatio,
    -- eldritch,
}

for _, v in ipairs(consumabletype_table) do
    SMODS.ConsumableType(v)
end

local consumable_table = {}

for _, v in ipairs(consumable_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Consumable(v)
end

local favor = {
    key = "favor",
    name = "Favor Card",
    effect = "Favor",
    atlas = "ultra",
    pos = {x = 4, y = 2},
    config = {extra = {perma_bonus = 10}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            for _, v in ipairs(context.full_hand) do
                v.ability.perma_bonus = v.ability.perma_bonus + card.ability.extra.perma_bonus
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card,
            }
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.perma_bonus}}
    end,
}

local exponent = {
    key = "exponent",
    name = "Exponent Card",
    effect = "Exponent",
    atlas = "ultra",
    pos = {x = 5, y = 2},
    config = {extra = {e_mult = 1.04}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                e_mult = card.ability.extra.e_mult,
                card = card,
            }
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult}}
    end,
}

local strange = {
    key = "strange",
    name = "Strange Card",
    effect = "Strange",
    atlas = "ultra",
    pos = {x = 6, y = 2},
    config = {extra = {odds = 6}},
    any_suit = true,
    set_ability = function(self, card, initial, delay_sprites)
        SMODS.debuff_card(card, "prevent_debuff", "m_sgt_strange")
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, 'strange_infection', 1, card.ability.extra.odds) then
                local targets = {}
                for i, v in ipairs(context.full_hand) do
                    if v == card then
                        if context.full_hand[i-1] then
                            targets[#targets+1] = context.full_hand[i-1]
                        end
                        if context.full_hand[i+1] then
                            targets[#targets+1] = context.full_hand[i+1]
                        end
                    end
                end
                if #targets > 0 then
                    local target = pseudorandom_element(targets, pseudoseed("strange_target"))
                    target:set_ability(G.P_CENTERS.m_sgt_strange, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "strange_infection")}}
    end,
}

local nyx_glass = {
    key = "nyx_glass",
    name = "Nyx Glass Card",
    effect = "Nyx Glass",
    atlas = "ultra",
    pos = {x = 8, y = 2},
    config = {x_mult = 1.5, extra = {x_mult_mod = 0.1, odds = 50}},
    set_ability = function(self, card, initial, delay_sprites)
        card.no_shadow = true
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.x_mult = card.ability.x_mult + card.ability.extra.x_mult_mod
            card.ability.extra.odds = card.ability.extra.odds - 1
            if card.ability.extra.odds < (Cryptid and 0.001 or 1) then
                card.ability.extra.odds = Cryptid and 0.001 or 1
            end
        end
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card
        and SMODS.pseudorandom_probability(card, 'nyx_glass', 1, card.ability.extra.odds) then
            card.glass_trigger = true
            return { remove = true }
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.x_mult, card.ability.extra.x_mult_mod, SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "nyx_glass")}}
    end,
}

local titanium = {
    key = "titanium",
    name = "Titanium Card",
    effect = "Titanium",
    atlas = "ultra",
    pos = {x = 9, y = 2},
    config = {h_x_mult = 1.5, extra = {h_x_mult_mod = 0.1, held_in_hand_ge = 7}, immutable = {base_h_x_mult = 1.5}},
    update = function(self, card, dt)
        card.ability.h_x_mult = card.ability.immutable.base_h_x_mult
        + (G and G.hand and G.hand.cards and #G.hand.cards > card.ability.extra.held_in_hand_ge
        and #G.hand.cards - card.ability.extra.held_in_hand_ge or 0)*card.ability.extra.h_x_mult_mod
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.h_x_mult, card.ability.extra.h_x_mult_mod, card.ability.extra.held_in_hand_ge}}
    end,
}

local abyss_stone = {
    key = "abyss_stone",
    name = "Abyss Stone Card",
    effect = "Abyss Stone",
    atlas = "ultra",
    pos = {x = 4, y = 5},
    config = {abyss_stone_tally = 0, bonus = 50, extra = {bonus_mod = 25}, immutable = {base_bonus = 50}},
    replace_base_card = true,
    override_base_rank = true,
    no_rank = true,
    no_suit = true,
    update = function(self, card, dt)
        card.ability.abyss_stone_tally = 0
        for _, v in pairs(G.playing_cards or {}) do
            if v ~= card and SMODS.has_no_rank(v) then
                card.ability.abyss_stone_tally = card.ability.abyss_stone_tally + 1
            end
        end
        card.ability.bonus = card.ability.immutable.base_bonus + card.ability.abyss_stone_tally*card.ability.extra.bonus_mod
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.bonus, card.ability.extra.bonus_mod}}
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local always_show = self.config and self.config.always_show or {}
        if specific_vars and specific_vars.nominal_chips and not self.replace_base_card then
            localize { type = 'other', key = 'card_chips', nodes = desc_nodes, vars = { specific_vars.nominal_chips } }
        end
        SMODS.Enhancement.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if specific_vars and specific_vars.bonus_chips then
            local remaining_bonus_chips = specific_vars.bonus_chips - (card.ability.bonus or self.config.bonus or 0)
            if remaining_bonus_chips ~= 0 then
                localize { type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = { SMODS.signed(remaining_bonus_chips) } }
            end
        end
        if specific_vars and specific_vars.bonus_x_chips then
            localize{type = 'other', key = 'card_x_chips', nodes = desc_nodes, vars = {specific_vars.bonus_x_chips}}
        end
        if specific_vars and specific_vars.bonus_mult then
            localize{type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_mult)}}
        end
        if specific_vars and specific_vars.bonus_x_mult then
            localize{type = 'other', key = 'card_x_mult', nodes = desc_nodes, vars = {specific_vars.bonus_x_mult}}
        end
        if specific_vars and specific_vars.bonus_h_chips then
            localize{type = 'other', key = 'card_extra_h_chips', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_h_chips)}}
        end
        if specific_vars and specific_vars.bonus_x_chips then
            localize{type = 'other', key = 'card_h_x_chips', nodes = desc_nodes, vars = {specific_vars.bonus_h_x_chips}}
        end
        if specific_vars and specific_vars.bonus_h_mult then
            localize{type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_h_mult)}}
        end
        if specific_vars and specific_vars.bonus_h_x_mult then
            localize{type = 'other', key = 'card_h_x_mult', nodes = desc_nodes, vars = {specific_vars.bonus_h_x_mult}}
        end
        if specific_vars and specific_vars.bonus_p_dollars then
            localize{type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = {SMODS.signed_dollars(specific_vars.bonus_p_dollars)}}
        end
        if specific_vars and specific_vars.bonus_h_dollars then
            localize{type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = {SMODS.signed_dollars(specific_vars.bonus_h_dollars)}}
        end
    end,
}

local platinum = {
    key = "platinum",
    name = "Platinum Card",
    effect = "Platinum",
    atlas = "ultra",
    pos = {x = 5, y = 5},
    config = {d_dollars = 3},
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            ease_dollars(card.ability.d_dollars)
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.d_dollars}}
    end,
}

local ancient_lucky = {
    key = "ancient_lucky",
    name = "Ancient Lucky Card",
    effect = "Ancient Lucky",
    atlas = "ultra",
    pos = {x = 7, y = 2},
    config = {extra = {perma_mult = 5, perma_p_dollars = 5, mult_odds = 5, dollar_odds = 15}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local mult_up = nil
            if SMODS.pseudorandom_probability(card, 'ancient_lucky_mult', 1, card.ability.extra.mult_odds) then
                card.ability.perma_mult = card.ability.perma_mult + card.ability.extra.perma_mult
                card.lucky_trigger = true
                mult_up = true
            end
            if SMODS.pseudorandom_probability(card, 'ancient_lucky_money', 1, card.ability.extra.dollar_odds) then
                card.ability.perma_p_dollars = card.ability.perma_p_dollars + card.ability.extra.perma_p_dollars
                card.lucky_trigger = true
            end
            if card.lucky_trigger then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = mult_up and G.C.MULT or G.C.MONEY,
                    card = card,
                }
            end
        end
    end,
    -- in_pool = function(self, args)
    --     return false
    -- end,
    loc_vars = function(self, info_queue, card)
        local nm, dm = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds, "ancient_lucky_mult")
        local nd, dd = SMODS.get_probability_vars(card, 1, card.ability.extra.dollar_odds, "ancient_lucky_money")
        return {vars = {nm, dm, card.ability.extra.perma_mult, nd, dd, card.ability.extra.perma_p_dollars}}
    end,
}

local enhancement_table = {
    favor,
    exponent,
    strange,
    nyx_glass,
    titanium,
    abyss_stone,
    platinum,
    ancient_lucky,
}

for _, v in ipairs(enhancement_table) do
    SMODS.Enhancement(v)
end

local voucher_table = {}

for _, v in ipairs(voucher_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Enhancement(v)
end