---@meta

---@class Sagatro.EventChain: SMODS.GameObject
---@field delay? number Delay between events in the chain.
---@field first_delay? boolean `true` if the first function in chain has a delay.
---@field func_list? (fun(): (number?, (fun(): boolean)?))[] An array of functions that may return the delay value and/or a function that returns boolean.
---@field super? SMODS.GameObject|table Parent class.
---@field obj_table? table<string, Sagatro.EventChain|table> Table of objects registered to this class.
---@field obj_buffer? string[] Array of keys to all objects registered to this class.
---@field __call? fun(self: Sagatro.EventChain|table, o: Sagatro.EventChain|table): nil|table|Sagatro.EventChain
---@field extend? fun(self: Sagatro.EventChain|table, o: Sagatro.EventChain|table): table Primary method of creating a class.
---@field check_duplicate_register? fun(self: Sagatro.EventChain|table): boolean? Ensures objects already registered will not register.
---@field check_duplicate_key? fun(self: Sagatro.EventChain|table): boolean? Ensures objects with duplicate keys will not register. Checked on `__call` but not `take_ownership`. For take_ownership, the key must exist.
---@field register? fun(self: Sagatro.EventChain|table) Registers the object.
---@field check_dependencies? fun(self: Sagatro.EventChain|table): boolean? Returns `true` if there's no failed dependencies.
---@field process_loc_text? fun(self: Sagatro.EventChain|table) Called during `inject_class`. Handles injecting loc_text.
---@field send_to_subclasses? fun(self: Sagatro.EventChain|table, func: string, ...: any) Starting from this class, recusively searches for functions with the given key on all subordinate classes and run all found functions with the given arguments.
---@field pre_inject_class? fun(self: Sagatro.EventChain|table) Called before `inject_class`. Injects and manages class information before object injection.
---@field post_inject_class? fun(self: Sagatro.EventChain|table) Called after `inject_class`. Injects and manages class information after object injection.
---@field inject_class? fun(self: Sagatro.EventChain|table) Injects all direct instances of class objects by calling `obj:inject` and `obj:process_loc_text`. Also injects anything necessary for the class itself. Only called if class has defined both `obj_table` and `obj_buffer`.
---@field inject? fun(self: Sagatro.EventChain|table, i?: number) Called during `inject_class`. Injects the object into the game.
---@field take_ownership? fun(self: Sagatro.EventChain|table, key: string, obj: Sagatro.EventChain|table, silent?: boolean): nil|table|Sagatro.EventChain Takes control of vanilla objects. Child class must have get_obj for this to function.
---@field get_obj? fun(self: Sagatro.EventChain|table, key: string): Sagatro.EventChain|table? Returns an object if one matches the `key`.
---@overload fun(self: Sagatro.EventChain): Sagatro.EventChain
Sagatro.EventChain = setmetatable({}, {
    __call = function(self)
        return self
    end
})

---@type table<string, Sagatro.EventChain|table>
Sagatro.EventChains = {}

---@type {chain_key?: string, new_chain_delay?: number, chain_block?: fun():boolean}
Sagatro.EventChainUtils = {}
