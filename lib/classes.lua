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
