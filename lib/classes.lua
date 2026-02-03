---@param func_list function[] An array of functions.
---@param delay number Delay between each function.
---@param index? integer Internal counter to traverse the array, as well as controlling the recursion.
--- Recursive helper function to execute functions one by one, utilizing events.
--- Direct invocation is not recommended.
function Sagatro.recursive_chain(func_list, delay, index)
    index = index or 1
    if index == 1 then
        G.CONTROLLER.locks.executing_chain = true
        G.EVENT_CHAIN_INTERRUPT = G.STATE
        G.STATE = G.STATES.PLAY_TAROT
        G.GAME.sgt_no_saving = true
    elseif index > #func_list then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = delay*G.SETTINGS.GAMESPEED,
            func = function()
                G.CONTROLLER.locks.executing_chain = nil
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
        delay = delay*G.SETTINGS.GAMESPEED,
        func = function()
            func_list[index]()
            Sagatro.recursive_chain(func_list, delay, index+1)
            return true
        end
    }))
end

---@param key string
--- Execute a registered event chain.
--- Invoke directly to perform at an arbitrary time.
--- Otherwise, set `G.GAME.shelved_chain` to `key` to automatically
--- invoke at end of round, before all other calculations.
function Sagatro.execute_chain(key)
    local event_chain = Sagatro.EventChains[key]
    if not event_chain then
        sendWarnMessage(("Cannot execute %s: Does not exist."):format(key), Sagatro.EventChain.set)
        return
    end
    Sagatro.recursive_chain(event_chain.func_list, event_chain.delay)
end

---@type table<string, Sagatro.EventChain|table>
Sagatro.EventChains = {}

---@class Sagatro.EventChain: SMODS.GameObject 
---@field delay? number Delay between events in the chain.
Sagatro.EventChain = SMODS.GameObject:extend{
    obj_table = Sagatro.EventChains,
    obj_buffer = {},
    set = "EventChain",
    required_params = {
        "key",
        "func_list",
    },
    delay = 0.8,
    inject = function(self)
        assert(type(self.func_list) == "table", ("Field \"func_list\" must be a table."))
        for i, func in ipairs(self.func_list) do
            assert(type(func) == "function", ("Element No.%d of \"func_list\" is not a function."):format(i))
        end
    end,
    process_loc_text = function() end,
}

Sagatro.EventChain{
    key = "fleta_crashout",
    func_list = {
        function()
            local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
            if fleta then
                play_sound('sgt_fleta_tantrum', 1, 0.4)
                fleta:juice_up()
            end
        end,
        function()
            local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
            if fleta and table.size(fleta.ability.immutable.completed) >= 2 then
                play_sound('timpani')
                SMODS.add_card{key = "j_sgt_rose_bell"}
            end
        end,
        function()
            local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
            if fleta then
                fleta:shatter()
            end
            G.GAME.modifiers.sgt_no_tags = nil
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                goldia.ability.immutable.plot_armor = true
            end
            Sagatro.progress_storyline("entering_mirror_maze", "add", "pocket_mirror", G.GAME.inverwoven_storyline)
        end,
    },
}