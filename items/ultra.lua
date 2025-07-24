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