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

---@class Sagatro.Storyline: SMODS.Center
---@field obj_table? table<string, Sagatro.Storyline|table> Table of objects registered to this class. 
---@field super? SMODS.Center|table Parent class. 
---@field atlas? string Key to the center's atlas. 
---@field pos? table|{x: integer, y: integer} Position of the center's sprite. 
---@field soul_atlas? string Key to the center's soul atlas. 
---@field soul_pos? table|{x: integer, y: integer, draw?: fun(card: Card|table, scale_mod?: number, rotate_mod?: number)} Position of the "soul" sprite. Separate front layer sprite that hovers over the card. 
---@field unlocked? boolean Sets the unlock state of the center. 
---@field discovered? boolean Sets the discovery state of the center. 
---@field no_collection? boolean|fun(self: Sagatro.Storyline|table, args?:table):boolean Sets whether the card shows up in the collections menu. 
---@field loc_txt? table|{name: string|string[], text: string[]|string[][]} Contains strings used for displaying text related to this object. 
---@field pools? string[] Array of keys to ObjectTypes this center will be added to.
---@field cost? number Sell cost of this center. 
---@field no_pool_flag? string Key to a pool flag defined in `G.GAME.pool_flags`. This center is removed from pools as long as this flag is `true`. 
---@field yes_pool_flag? string Key to the pool flag defined in `G.GAME.pool_flags`. This center is removed from pools as long as this flag is `false`. 
---@field eternal_compat? boolean Sets whether the center can have "Eternal" sticker. 
---@field perishable_compat? boolean Sets whether the center can have "Perishable" sticker. 
---@field display_size? table|{w: integer, h: integer} Changes the display size of card. 
---@field pixel_size? table|{w: integer, h: integer} Change the size of the sprite drawn onto the card.
---@field badge_text_colour? table Colour of the label for the badge (supersedes Rarities and ConsumableTypes).
---@field badge_colour? table Colour of the badge (supersedes Rarities and ConsumableTypes).
---@field starting_jokers? string[] Jokers to add at run start to instantly initialize a certain storyline.
---@field joker_list? string[] The list of joker keys to add to `Sagatro.StorylinePools[storyline_key]`.
---@field __call? fun(self: Sagatro.Storyline|table, o: Sagatro.Storyline|table): nil|table|Sagatro.Storyline
---@field extend? fun(self: Sagatro.Storyline|table, o: Sagatro.Storyline|table): table Primary method of creating a class. 
---@field check_duplicate_register? fun(self: Sagatro.Storyline|table): boolean? Ensures objects already registered will not register. 
---@field check_duplicate_key? fun(self: Sagatro.Storyline|table): boolean? Ensures objects with duplicate keys will not register. Checked on `__call` but not `take_ownership`. For take_ownership, the key must exist. 
---@field register? fun(self: Sagatro.Storyline|table) Registers the object. 
---@field check_dependencies? fun(self: Sagatro.Storyline|table): boolean? Returns `true` if there's no failed dependencies. 
---@field process_loc_text? fun(self: Sagatro.Storyline|table) Called during `inject_class`. Handles injecting loc_text. 
---@field send_to_subclasses? fun(self: Sagatro.Storyline|table, func: string, ...: any) Starting from this class, recusively searches for functions with the given key on all subordinate classes and run all found functions with the given arguments. 
---@field pre_inject_class? fun(self: Sagatro.Storyline|table) Called before `inject_class`. Injects and manages class information before object injection. 
---@field post_inject_class? fun(self: Sagatro.Storyline|table) Called after `inject_class`. Injects and manages class information after object injection. 
---@field inject_class? fun(self: Sagatro.Storyline|table) Injects all direct instances of class objects by calling `obj:inject` and `obj:process_loc_text`. Also injects anything necessary for the class itself. Only called if class has defined both `obj_table` and `obj_buffer`. 
---@field inject? fun(self: Sagatro.Storyline|table, i?: number) Called during `inject_class`. Injects the object into the game. 
---@field take_ownership? fun(self: Sagatro.Storyline|table, key: string, obj: Sagatro.Storyline|table, silent?: boolean): nil|table|Sagatro.Storyline Takes control of vanilla objects. Child class must have get_obj for this to function
---@field get_obj? fun(self: Sagatro.Storyline|table, key: string): Sagatro.Storyline|table? Returns an object if one matches the `key`. 
---@field delete? fun(self: Sagatro.Storyline|table): boolean? Removes provided center. 
---@field generate_ui? fun(self: Sagatro.Storyline|table, info_queue: table, card: Card|table, desc_nodes: table, specific_vars: table, full_UI_table: table) Provides complex control over the UI display of the card. See [`generate_ui`](https://docs.smods.dev/API%20Documentation/Localization#generate_ui-advanced) documentation for details. 
---@field loc_vars? fun(self: Sagatro.Storyline|table, info_queue: table, card: Card|table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://docs.smods.dev/API%20Documentation/Localization#loc_vars) documentation for return value details. 
---@field locked_loc_vars? fun(self: Sagatro.Storyline|table, info_queue: table, card: Card|table): table Provides simple control over displaying descriptions and toolips of this center when not unlocked. 
---@field check_for_unlock? fun(self: Sagatro.Storyline|table, args: table): boolean? Configures unlock conditions. See vanilla implementation of `check_for_unlock` for details on `args` parameters. 
---@field set_badges? fun(self: Sagatro.Storyline|table, card: Card|table, badges: table) Append `badges` for additional badges on the UI display of the card. To override the rarity/card type badge, see `Sagatro.Storyline:set_card_type_badge()`. 
---@field set_card_type_badge? fun(self: Sagatro.Storyline|table, card: Card|table, badges: table) Overrides the rarity/card type badges, allowing you to Append `badges` to replace them. To add extra badges, see `Sagatro.Storyline:set_badges()`. 
---@field draw? fun(self: Sagatro.Storyline|table, card: Card|table, layer: string) Draws the sprite and shader of the card. 
---@field update? fun(self: Sagatro.Storyline|table, card: Card|table, dt: number) Allows logic for this card to be run per-frame. 
---@field set_sprites? fun(self: Sagatro.Storyline|table, card: Card|table, front?: Card|table) Used for setting and manipulating sprites of the card when created or loaded. 
---@field load? fun(self: Sagatro.Storyline|table, card: Card|table, card_table: table, other_card?: table) Used when the card itself is being reloaded. 
---@field set_ability? fun(self: Sagatro.Storyline|table, card: Card|table, initial?: boolean, delay_sprites?: boolean) Sets up initial ability and size parameters for the card. 
---@field add_to_deck? fun(self: Sagatro.Storyline|table, card: Card|table, from_debuff: boolean) Allows modifying the game state when the card is being added. 
---@field remove_from_deck? fun(self: Sagatro.Storyline|table, card: Card|table, from_debuff: boolean) Allows modifying the game state when the card is being removed. 
---@field in_pool? fun(self: Sagatro.Storyline|table, args: table): boolean? , table? Allows configuring if the card is allowed to spawn. 
---@field calculate? fun(self: Sagatro.Storyline|table, card: Card|table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://docs.smods.dev/API%20Documentation/Calculate-Functions) docs for details. 
---@field create_fake_card? fun(self: Sagatro.Storyline|table): table Creates a fake card representing this center. Used internally for `generate_ui` in cases where recieved `card` param is nil. 
---@field on_select? fun(self: Sagatro.Storyline|table, card: Card|table) Called when the card is selected from a booster pack. 
---@field select_card? string|{[string]: string}|(fun(self: Sagatro.Storyline|table, card: Card|table, pack: SMODS.Booster|table): string|{[string]: string}, boolean?) Key to the CardArea (e.x. `G[Sagatro.Storyline.select_card]`). As a table, each key-value pair is a card set as key and CardArea string as values. Or return either formers as a function. May also return a second value of boolean to indicate card can be selected and used at the same time. 
---@overload fun(self: Sagatro.Storyline): Sagatro.Storyline
Sagatro.Storyline = setmetatable({}, {
    __call = function(self)
        return self
    end
})

---@type table<string, Sagatro.Storyline|table>
Sagatro.Storylines = {}

---@type SMODS.Center[]
Sagatro.StorylinePools = {}