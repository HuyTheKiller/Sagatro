local enchantment = {
    key = "sgt_Enchantment",
    primary_colour = HEX("742fc0"),
    secondary_colour = G.C.SGT_ENCHANTMENT,
    collection_rows = { 5, 5, 5 },
    shop_rate = 0.0,
    loc_txt = {},
    default = "c_sgt_expansion",
}

local consumabletype_table = {
    enchantment,
}

for _, v in ipairs(consumabletype_table) do
    SMODS.ConsumableType(v)
end

local fortification = {
    key = "fortification",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self) + 1
        return ret
    end,
}

local empowerment = {
    key = "empowerment",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local abundance = {
    key = "abundance",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = 2*(Sagatro.get_next_level(card, self) - 1)
        return ret
    end,
}

local foresight = {
    key = "foresight",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            G.hand:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.hand:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.hand:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.hand:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.hand:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.hand:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.hand:change_size(amount)
        end,
    },
    undo_funcs = {
        function()
            G.hand:change_size(-G.GAME.sgt_enchanted_table.sgt_foresight)
        end,
        function()
            G.hand:change_size(-G.GAME.sgt_enchanted_table.sgt_foresight)
        end,
        function()
            G.hand:change_size(-G.GAME.sgt_enchanted_table.sgt_foresight)
        end,
        function()
            G.hand:change_size(-G.GAME.sgt_enchanted_table.sgt_foresight)
        end,
    },
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local mercy = {
    key = "mercy",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            SMODS.change_play_limit(amount)
            SMODS.change_discard_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_play_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_discard_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_play_limit(amount)
            SMODS.change_discard_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_play_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_discard_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_play_limit(amount)
            SMODS.change_discard_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_play_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_discard_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_play_limit(amount)
            SMODS.change_discard_limit(-amount)
        end,
    },
    undo_funcs = {
        function()
            SMODS.change_play_limit(-G.GAME.sgt_enchanted_table.sgt_mercy)
            SMODS.change_discard_limit(G.GAME.sgt_enchanted_table.sgt_mercy)
        end,
        function()
            SMODS.change_play_limit(-G.GAME.sgt_enchanted_table.sgt_mercy)
            SMODS.change_discard_limit(G.GAME.sgt_enchanted_table.sgt_mercy)
        end,
        function()
            SMODS.change_play_limit(-G.GAME.sgt_enchanted_table.sgt_mercy)
            SMODS.change_discard_limit(G.GAME.sgt_enchanted_table.sgt_mercy)
        end,
        function()
            SMODS.change_play_limit(-G.GAME.sgt_enchanted_table.sgt_mercy)
            SMODS.change_discard_limit(G.GAME.sgt_enchanted_table.sgt_mercy)
        end,
    },
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local cruelty = {
    key = "cruelty",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            SMODS.change_discard_limit(amount)
            SMODS.change_play_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_play_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_discard_limit(amount)
            SMODS.change_play_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_play_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_discard_limit(amount)
            SMODS.change_play_limit(-amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table[self.identifier])
                SMODS.change_play_limit(G.GAME.sgt_enchanted_table[self.identifier])
            end
            SMODS.change_discard_limit(amount)
            SMODS.change_play_limit(-amount)
        end,
    },
    undo_funcs = {
        function()
            SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table.sgt_cruelty)
            SMODS.change_play_limit(G.GAME.sgt_enchanted_table.sgt_cruelty)
        end,
        function()
            SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table.sgt_cruelty)
            SMODS.change_play_limit(G.GAME.sgt_enchanted_table.sgt_cruelty)
        end,
        function()
            SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table.sgt_cruelty)
            SMODS.change_play_limit(G.GAME.sgt_enchanted_table.sgt_cruelty)
        end,
        function()
            SMODS.change_discard_limit(-G.GAME.sgt_enchanted_table.sgt_cruelty)
            SMODS.change_play_limit(G.GAME.sgt_enchanted_table.sgt_cruelty)
        end,
    },
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local echo = {
    key = "echo",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
}

local reflection = {
    key = "reflection",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        local level = Sagatro.get_next_level(card, self)
        local n, d
        if level == 1 then
            n, d = SMODS.get_probability_vars(Sagatro, 1, 4, "l1_reflection")
        elseif level == 2 then
            n, d = SMODS.get_probability_vars(Sagatro, 1, 2, "l2_reflection")
        elseif level == 3 then
            n, d = SMODS.get_probability_vars(Sagatro, 1, 3, "l3_reflection")
        end
        if n and d then
            ret.vars[#ret.vars+1] = n
            ret.vars[#ret.vars+1] = d
        end
        return ret
    end,
}

local alchemy = {
    key = "alchemy",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        if not card.ability.from_tag then
            Sagatro.enh_group_info_queue(info_queue, Sagatro.metallic_enhancement_list)
        end
        return ret
    end,
}   

local binding = {
    key = "binding",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        if not card.ability.from_tag then
            Sagatro.enh_group_info_queue(info_queue, Sagatro.fragile_enhancement_list)
        end
        local level = Sagatro.get_next_level(card, self)
        local n, d
        if level == 1 then
            n, d = SMODS.get_probability_vars(Sagatro, 1, 4, "l1_binding")
        elseif level == 2 then
            n, d = SMODS.get_probability_vars(Sagatro, 1, 2, "l2_binding")
        elseif level == 3 then
            n, d = SMODS.get_probability_vars(Sagatro, 3, 4, "l3_binding")
        end
        if n and d then
            ret.vars[#ret.vars+1] = n
            ret.vars[#ret.vars+1] = d
        end
        return ret
    end,
}

local warding = {
    key = "warding",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
}

local blessing = {
    key = "blessing",
    artist_credits = {"huycorn"},
    max_level = 2,
    use_funcs = {
        function(self, card, area, copier)
            G.GAME.modifiers.sgt_enchantment_boost = self:loc_vars({}, card).vars[4]
        end,
        function(self, card, area, copier)
            G.GAME.modifiers.sgt_enchantment_boost = self:loc_vars({}, card).vars[4]
        end,
    },
    undo_funcs = {
        function()
            G.GAME.modifiers.sgt_enchantment_boost = nil
        end,
        function()
            G.GAME.modifiers.sgt_enchantment_boost = nil
        end,
    },
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        local level = Sagatro.get_next_level(card, self)
        if level == 1 then
            ret.vars[#ret.vars+1] = 2
        elseif level == 2 then
            ret.vars[#ret.vars+1] = 5
        end
        return ret
    end,
}

local awakening = {
    key = "awakening",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {},
    undo_funcs = {},
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local warehouse = {
    key = "warehouse",
    artist_credits = {"huycorn"},
    max_level = 4,
    use_funcs = {
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            G.consumeables:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.consumeables:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.consumeables:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.consumeables:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.consumeables:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.consumeables:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.consumeables:change_size(amount)
        end,
    },
    undo_funcs = {
        function()
            G.consumeables:change_size(-G.GAME.sgt_enchanted_table.sgt_warehouse)
        end,
        function()
            G.consumeables:change_size(-G.GAME.sgt_enchanted_table.sgt_warehouse)
        end,
        function()
            G.consumeables:change_size(-G.GAME.sgt_enchanted_table.sgt_warehouse)
        end,
        function()
            G.consumeables:change_size(-G.GAME.sgt_enchanted_table.sgt_warehouse)
        end,
    },
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local expansion = {
    key = "expansion",
    artist_credits = {"huycorn"},
    max_level = 3,
    use_funcs = {
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            G.jokers:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.jokers:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.jokers:change_size(amount)
        end,
        function(self, card, area, copier)
            local amount = Sagatro.get_next_level(card, self)
            if G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
            and G.GAME.sgt_enchanted_table[self.identifier] < amount then
                G.jokers:change_size(-G.GAME.sgt_enchanted_table[self.identifier])
            end
            G.jokers:change_size(amount)
        end,
    },
    undo_funcs = {
        function()
            G.jokers:change_size(-G.GAME.sgt_enchanted_table.sgt_expansion)
        end,
        function()
            G.jokers:change_size(-G.GAME.sgt_enchanted_table.sgt_expansion)
        end,
        function()
            G.jokers:change_size(-G.GAME.sgt_enchanted_table.sgt_expansion)
        end,
    },
    in_pool = function(self, args)
        return G.GAME.selected_back.effect.center.key ~= "b_sgt_saga" and G.GAME.selected_sleeve ~= "sleeve_sgt_saga"
    end,
    loc_vars = function(self, info_queue, card)
        local ret = Sagatro.Enchantment.loc_vars(self, info_queue, card)
        ret.vars[#ret.vars+1] = Sagatro.get_next_level(card, self)
        return ret
    end,
}

local enchantment_table = {
    fortification,
    empowerment,
    abundance,
    foresight,
    mercy,
    cruelty,
    echo,
    reflection,
    alchemy,
    binding,
    warding,
    blessing,
    awakening,
    warehouse,
    expansion,
}

for _, v in ipairs(enchantment_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    Sagatro.Enchantment(v)
end


local apprentice = {
    key = "apprentice",
    name = "Apprentice",
    artist_credits = {"huycorn"},
    atlas = "enchantments",
    pos = {x = 0, y = 1},
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local wizard = {
    key = "wizard",
    name = "Wizard",
    artist_credits = {"huycorn"},
    atlas = "enchantments",
    pos = {x = 1, y = 1},
    config = {extra = {rate = 1, slots = 4}},
    requires = {"v_sgt_apprentice"},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.sgt_max_enchantment = card.ability.extra.slots
                G.GAME.sgt_enchantment_rate = card.ability.extra.rate/(1e18^#SMODS.find_card("j_sgt_ozzy"))
                return true
            end
        }))
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.slots}}
    end,
}

local voucher_table = {
    apprentice,
    wizard,
}

for _, v in ipairs(voucher_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Voucher(v)
end