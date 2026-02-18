---@meta

---@class Sagatro.EventChain: SMODS.GameObject
---@field delay? number Delay between events in the chain.
---@field first_delay? boolean `true` if the first function in chain has a delay.
---@field func_list (fun(): number?)[] An array of functions that may return the delay value.
---@overload fun(self: Sagatro.EventChain): Sagatro.EventChain
Sagatro.EventChain = setmetatable({}, {
    __call = function(self)
        return self
    end
})

---@type table<string, Sagatro.EventChain|table>
Sagatro.EventChains = {}
