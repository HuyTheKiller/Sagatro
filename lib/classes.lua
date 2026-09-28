--#region Sagatro.EventChain

---@param func_list (fun(): (number?, (fun(): boolean)?))[] An array of functions that may return the delay value and/or a function that returns boolean.
---@param delay number Delay between each function.
---@param use_delay boolean Set to `true` to allow `delay` to be used.
---@param index? integer Internal counter to traverse the array, as well as controlling the recursion.
--- Recursive helper function to execute functions one by one, utilizing events.
--- Direct invocation is not recommended.
function Sagatro.recursive_chain(func_list, delay, use_delay, index)
    index = index or 1
    Sagatro.EventChainUtils.new_chain_delay = nil
    Sagatro.EventChainUtils.chain_block = nil
    G.CONTROLLER.locks.executing_chain = true
    if index == 1 then
        G.EVENT_CHAIN_INTERRUPT = G.STATE
        if G.STATE == G.STATES.PLAY_TAROT then
            G.EVENT_CHAIN_INTERRUPT = G.TAROT_INTERRUPT or G.STATE
        end
        G.STATE = G.STATES.PLAY_TAROT
        G.GAME.sgt_no_saving = true
    elseif index > #func_list then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = delay*G.SETTINGS.GAMESPEED,
            func = function()
                G.CONTROLLER.locks.executing_chain = nil
                Sagatro.EventChainUtils.chain_key = nil
                G.STATE = G.EVENT_CHAIN_INTERRUPT
                G.EVENT_CHAIN_INTERRUPT = nil
                G.GAME.sgt_no_saving = nil
                return true
            end
        }))
        return
    end
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = use_delay and delay*G.SETTINGS.GAMESPEED or 0,
        func = function()
            local new_delay, check
            if not Sagatro.EventChainUtils.chain_block then
                new_delay, check = func_list[index]()
                if check then
                    Sagatro.EventChainUtils.new_chain_delay = new_delay
                    Sagatro.EventChainUtils.chain_block = check
                    G.CONTROLLER.locks.executing_chain = nil
                end
            end
            if not Sagatro.EventChainUtils.chain_block
            or (Sagatro.EventChainUtils.chain_block
            and Sagatro.EventChainUtils.chain_block()) then
                Sagatro.recursive_chain(func_list, Sagatro.EventChainUtils.new_chain_delay or new_delay or delay, true, index+1)
                return true
            end
        end
    }))
end

---@param key string
--- Execute a registered event chain.\
--- Invoke directly to perform at an arbitrary time.\
--- Otherwise, Set the following keys in `G.GAME.shelved_chains` to `key`:
--- * `end_of_round` to automatically invoke at end of round, before all other end-of-round calculations.
--- * `hand_drawn` automatically invoke after hand is drawn during a blind.
function Sagatro.execute_chain(key)
    local event_chain = Sagatro.EventChains[key]
    if not event_chain then
        sendWarnMessage(("Cannot execute %s: Does not exist."):format(key), Sagatro.EventChain.set)
        return
    end
    if Sagatro.EventChainUtils.chain_key then
        sendWarnMessage(("Cannot execute %s: Another chain (%s) is ongoing."):format(key, Sagatro.EventChainUtils.chain_key), Sagatro.EventChain.set)
        return
    end
    Sagatro.EventChainUtils.chain_key = event_chain.key
    G.CONTROLLER:L_cursor_release()
    Sagatro.recursive_chain(event_chain.func_list, event_chain.delay, event_chain.first_delay)
end

Sagatro.EventChains = {}
Sagatro.EventChainUtils = {}
Sagatro.EventChain = SMODS.GameObject:extend{
    obj_table = Sagatro.EventChains,
    obj_buffer = {},
    set = "EventChain",
    required_params = {
        "key",
    },
    delay = 0.8,
    first_delay = false,
    func_list = {},
    inject = function(self)
        assert(type(self.func_list) == "table", ("Field \"func_list\" must be a table."))
        for i, func in ipairs(self.func_list) do
            assert(type(func) == "function", ("Element No.%d of \"func_list\" is not a function."):format(i))
        end
    end,
    process_loc_text = function() end,
}
--#endregion

--#region Sagatro.Storyline

Sagatro.Storylines = {}
Sagatro.StorylinePools = {}
Sagatro.Storyline = SMODS.Center:extend{
    obj_table = Sagatro.Storylines,
    obj_buffer = {},
    set = "Storyline",
    class_prefix = 'strl',
    required_params = {
        "key",
        "atlas",
        "pos",
        "starting_jokers",
        "joker_list",
    },
    config = {},
    unlocked = false,
    discovered = false,
    starting_jokers = {},
    joker_list = {},
    inject = function(self)
        G.P_CENTER_POOLS[self.set] = G.P_CENTER_POOLS[self.set] or {}
        SMODS.Center.inject(self)
        Sagatro.StorylinePools[self.key] = Sagatro.StorylinePools[self.key] or {}
        ---@param table table
        local function table_contains(table, element)
            for _, v in pairs(table) do
                if v == element then
                    return true
                end
            end
            return false
        end
        for _, v in ipairs(self.joker_list) do
            if G.P_CENTERS[v] and not table_contains(Sagatro.StorylinePools[self.key], G.P_CENTERS[v]) then
                self:inject_card(G.P_CENTERS[v])
            end
        end
    end,
    inject_card = function(self, center)
        if center.set ~= self.key then SMODS.insert_pool(Sagatro.StorylinePools[self.key], center) end
    end,
    delete_card = function(self, center)
        if center.set ~= self.key then SMODS.remove_pool(Sagatro.StorylinePools[self.key], center.key) end
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge(localize("k_storyline"), G.C.SGT_SAGADITION, G.C.WHITE, 1.2)
    end,
    update = function(self, card, dt)
        if card.area and card.area.config.collection and not card.bypass_lock then
            card.params.bypass_lock = true
            card.bypass_lock = true
            card.params.bypass_discovery_center = true
            card.bypass_discovery_center = true
            card.params.bypass_discovery_ui = true
            card.bypass_discovery_ui = true
            card:set_sprites(card.config.center)
        end
    end,
}
--#endregion

--#region Sagatro.Enchantment

Sagatro.Enchantments = {}
Sagatro.Enchantment = SMODS.Consumable:extend{
    obj_table = Sagatro.Enchantments,
    obj_buffer = {},
    set = "sgt_Enchantment",
    atlas = "sgt_enchantments",
    pos = { x = 0, y = 0 },
    cost = 1,
    required_params = {
        "key",
        "max_level",
        "use_funcs",
        "undo_funcs",
    },
    inject = function(self)
        SMODS.Consumable.inject(self)
        self.identifier = self.key:sub(3, -1)
    end,
    select_card = function(self, card, pack)
        return "consumeables", true
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra = type(card.ability.extra) == "table" and card.ability.extra or {}
        card.ability.extra.level = 1
        Sagatro.get_enchantment_cost(card, self)
        card.awaiting_level = true
    end,
    update = function(self, card, dt)
        if card.ability and self.discovered then
            Sagatro.get_enchantment_cost(card, self)
            if card.awaiting_level and card.area then
                card.awaiting_level = nil
                if not card.area.config.collection then
                    local roll = pseudorandom(self.identifier.."_enchantment")
                    if self.max_level >= 4 and roll < (G.GAME.modifiers.sgt_enchantment_boost or 1)/16 then
                        card.ability.extra.level = 4
                    elseif self.max_level >= 3 and roll < (G.GAME.modifiers.sgt_enchantment_boost or 1)/8 then
                        card.ability.extra.level = 3
                    elseif self.max_level >= 2 and roll < (G.GAME.modifiers.sgt_enchantment_boost or 1)/4 then
                        card.ability.extra.level = 2
                    end
                end
            end
            if card.area and card.area.config.collection then
                card.ability.showcase_dt = (card.ability.showcase_dt or 0) + G.real_dt
                if card.ability.showcase_dt > 1 and not card.states.hover.is then
                    while card.ability.showcase_dt > 1 do
                        card.ability.showcase_dt = card.ability.showcase_dt - 1
                    end
                    if card.ability.extra.level == self.max_level then
                        card.ability.extra.level = 1
                    else
                        card.ability.extra.level = card.ability.extra.level + 1
                    end
                end
            end
            card.children.center:set_sprite_pos{x = card.ability.extra.level - 1, y = 0}
        end
    end,
    can_use = function(self, card)
        local overleveled = G.GAME.sgt_enchanted_table and G.GAME.sgt_enchanted_table[self.identifier]
        and G.GAME.sgt_enchanted_table[self.identifier] > card.ability.extra.level
        return to_big(card.ability.extra.required_cost) > to_big(0)
        and to_big(card.ability.extra.required_cost) <= to_big(G.GAME.dollars + G.GAME.bankrupt_at)
        and not overleveled
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local level = Sagatro.get_next_level(card, self)
                if level <= self.max_level then
                    play_sound('sgt_enchant', 1, 1)
                    card:juice_up(0.3, 0.5)
                    if G.deck then
                        (G.deck.cards[1] or G.deck):juice_up(0.3, 0.5)
                    end
                    ease_dollars(-card.ability.extra.required_cost, true)
                    Sagatro.add_enchantment(level, self, card, area, copier)
                    G.GAME.enchanting_inflation = (G.GAME.enchanting_inflation or 0) + 1
                end
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if not card.ability.from_tag then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_max_enchantment", specific_vars = {G.GAME.sgt_max_enchantment or 3}}
        end
        card.ability.extra = type(card.ability.extra) == "table" and card.ability.extra or {}
        card.ability.extra.level = card.ability.extra.level or 1
        Sagatro.get_enchantment_cost(card, self)
        return {vars = {localize{type = 'name_text', set = "sgt_Enchantment", key = self.key, nodes = {}}, Sagatro.get_roman_level(Sagatro.get_next_level(card, self)), card.ability.extra.required_cost}}
    end,
}
--#endregion