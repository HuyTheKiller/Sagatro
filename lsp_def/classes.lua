---@meta

---@class Sagatro.EventChain: SMODS.GameObject
---@field delay? number Delay between events in the chain.
---@field first_delay? boolean Boolean flag to decide if the first function in chain has a delay.
---@field func_list (fun(): number?)[] An array of functions that may return the delay value.
---@overload fun(self: Sagatro.EventChain): Sagatro.EventChain
Sagatro.EventChain = setmetatable({}, {
    __call = function(self)
        return self
    end
})

---@type table<string, Sagatro.EventChain|table>
Sagatro.EventChains = {}

---@param key string
--- Execute a registered event chain.
--- Invoke directly to perform at an arbitrary time.
--- Otherwise, set `G.GAME.shelved_chain` to `key` to automatically
--- invoke at end of round, before all other end-of-round calculations.
function Sagatro.execute_chain(key) end

---@param func_list (fun(): number?)[] An array of functions that may return the delay value.
---@param delay number Delay between each function.
---@param first_delay boolean Boolean flag to decide if the first function in chain has a delay.
---@param index? integer Internal counter to traverse the array, as well as controlling the recursion.
--- Recursive helper function to execute functions one by one, utilizing events.
--- Direct invocation is not recommended.
function Sagatro.recursive_chain(func_list, delay, first_delay, index) end
