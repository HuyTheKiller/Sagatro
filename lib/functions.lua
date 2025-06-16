-- Global colours
G.C.SGT_TRIVIAL = HEX("808080")
G.C.SGT_OBSCURE = HEX("8627D4")
G.C.SGT_ESOTERIC = HEX("131868")
G.C.SGT_WISH = HEX("9bbcfd")
SMODS.Gradient{
    key = "sagadition",
    colours = {Sagatro.badge_colour, G.C.RARITY[4]},
    cycle = 2,
} -- Skull, not putting inside assets.lua for preventive measures
G.C.SGT_SAGADITION = SMODS.Gradients["sgt_sagadition"]
SMODS.Gradient{
    key = "miracle",
    colours = {HEX('E7A73D'), HEX('FFEE00')},
    cycle = 2,
}
G.C.SGT_MIRACLE = SMODS.Gradients["sgt_miracle"]

-- Add them to loc_colour for text formatting
local lc = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    for k, v in pairs(G.C) do
		if string.len(k) > 4 and string.sub(k, 1, 4) == "SGT_" then
			G.ARGS.LOC_COLOURS[string.lower(k)] = v
		end
	end
    return lc(_c, _default)
end

-- Talisman compat
to_big = to_big or function(x)
    return x
end

to_number = to_number or function(x)
	return x
end

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	-- Events that update in real time
    ret.saga_event = {
        alice_in_wonderland = {
            cry_into_flood = false,
            white_rabbit_house = false,
            little_bill = false,
            huge_dog = false,
            caterpillar = false,
            pig_and_pepper = false,
            goodbye_frog = false,
            the_party = false,
            mad_hatter = false,
            red_queen = false,
            gryphon = false,
            final_showdown = false,
        },
    }
    -- Event checks to make sure each event only happens once per run
    ret.saga_event_check = {
        alice_in_wonderland = {
            cry_into_flood = false,
            white_rabbit_house = false,
            little_bill = false,
            huge_dog = false,
            caterpillar = false,
            pig_and_pepper = false,
            goodbye_frog = false,
            the_party = false,
            mad_hatter = false,
            red_queen = false,
            gryphon = false,
            final_showdown = false,
        },
    }
    -- A table to control joker pools during certain events
    ret.saga_spawn_table = {
        alice_in_wonderland = {
            cry_into_flood = {
                "j_splash",
                "j_sgt_mouse",
            },
            mad_hatter = {
                "j_sgt_tea",
                "j_sgt_bread",
                "j_sgt_butter",
                "j_sgt_march_hare",
                "j_sgt_dormouse",
                "j_sgt_alice",
            },
        },
    }
    ret.alice_multiplier = 1
    ret.relief_factor = 1
    ret.saga_event_forced_buffoon = false
    ret.story_mode = Sagatro.config.DisableOtherJokers
    ret.fusion_table = SagaFusion.fusions
    ret.red_queen_blind = false
    ret.red_queen_defeated = false
    ret.saved_by_gods_miracle = false
    ret.wish_card_spawns_genie = false -- Deck of Equilibrium compat
	return ret
end

-- Pretty much stolen from Cryptid lmao
local gmm = Game.main_menu
Game.main_menu = function(change_context)
    local ret = gmm(change_context)

    local selected_card = "j_sgt_alice"
    local newcard = Card(
        G.title_top.T.x,
        G.title_top.T.y,
        G.CARD_W*1.1*1.2,
        G.CARD_H*1.1*1.2, -- rescale to match Ace of Spades
        G.P_CARDS.empty,
        G.P_CENTERS[selected_card],
        { bypass_discovery_center = true }
    )
    if not Cryptid then
        G.title_top.T.w = G.title_top.T.w * 1.7675
        G.title_top.T.x = G.title_top.T.x - 0.8
    end
    G.title_top:emplace(newcard)

    newcard.no_ui = true
    newcard.states.visible = false
    newcard.sticker_run = "NONE" -- remove stake sticker

    G.SPLASH_BACK:define_draw_steps({
        {
            shader = "splash",
            send = {
                { name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
                { name = "vort_speed", val = 0.4 },
                { name = "colour_1", ref_table = Sagatro, ref_value = "badge_colour" },
                { name = "colour_2", ref_table = G.C.RARITY, ref_value = 4 },
            },
        },
    })

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            if change_context == "splash" then
                newcard.states.visible = true
                newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
            else
                newcard.states.visible = true
                newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
            end
            return true
        end,
    }))

    return ret
end

-- Mouse's conditional debuff mechanic
local cardarea_update_ref = CardArea.update
function CardArea:update(dt)
	cardarea_update_ref(self, dt)
    if self == G.jokers and G.jokers.cards[1] then
        for i, v in ipairs(G.jokers.cards) do
            if v.config.center_key == "j_sgt_mouse" then
                if #v.ability.extra.debuff_position > 0 then
                    if table.contains(v.ability.extra.debuff_position, i) then
                        v.ability.extra.mult = 0
                        if not v.debuff then
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                                play_sound('tarot2', 0.76, 0.4);return true end}))
                            play_sound('tarot2', 1, 0.4)
                            v:juice_up(0.5, 0.5)
                        end
                        v:set_debuff(true)
                    else
                        v:set_debuff(false)
                        v.ability.extra.mult = v.ability.extra.buffer_mult
                    end
                end
            end
        end
    end
end

-- Pseudo-animation and manual crash
cause_crash = false
alice_dt = 0
cosmic_dt = 0
miracle_dt = 0
miracle_animate = false
submarine_dt = 0
local upd = Game.update
function Game:update(dt)
	upd(self, dt)

    if G.your_collection and type(G.your_collection) == "table" then
        for _, collection_row in ipairs(G.your_collection) do
            if collection_row.cards and type(collection_row.cards) == "table" then
                for _, v in ipairs(collection_row.cards) do
                    if v.config.center_key == "j_sgt_submarine" then
                        v.ability.anim_dt = v.ability.anim_dt + dt
                        v.ability.anim_transition_path = v.ability.old_depth_level - v.ability.depth_level
                        if v.ability.anim_dt > 0.125 then
                            v.ability.anim_dt = v.ability.anim_dt - 0.125
                            if v.ability.anim_pos.x == 11 and v.ability.anim_transition_path ~= 0 and not v.ability.in_transition then
                                if v.ability.anim_transition_path > 0 then
                                    v.ability.anim_pos.x = 6
                                elseif v.ability.anim_transition_path < 0 then
                                    v.ability.anim_pos.x = 0
                                end
                                v.ability.in_transition = true
                            elseif (v.ability.anim_pos.x == 5 and v.ability.anim_transition_path < 0 and v.ability.in_transition)
                            or v.ability.anim_pos.x == 11 then
                                v.ability.anim_pos.x = 0
                                v.ability.in_transition = false
                                v.ability.old_depth_level = v.ability.depth_level
                            else
                                v.ability.anim_pos.x = v.ability.anim_pos.x + 1
                            end
                            v.ability.anim_pos.y = (math.min(v.ability.old_depth_level, v.ability.depth_level) - 1)
                            + (v.ability.in_transition and 5 or 0)
                            v.children.center:set_sprite_pos(v.ability.anim_pos)
                        end
                    end
                end
            end
        end
    end

    submarine_dt = submarine_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_submarine and submarine_dt > 0.125 then
        submarine_dt = submarine_dt - 0.125
        local submarine = G.P_CENTERS.j_sgt_submarine
        if submarine.extra_pos.x == 8 then
            submarine.extra_pos.x = 0
        else
            submarine.extra_pos.x = submarine.extra_pos.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == submarine then
                card.children.extra_sprite:set_sprite_pos(submarine.extra_pos)
            end
        end
    end

    alice_dt = alice_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_alice and alice_dt > 0.05 then
        alice_dt = alice_dt - 0.05
        local alice = G.P_CENTERS.j_sgt_alice
        if alice.soul_pos.x == 82 then
            alice.soul_pos.x = 1
        else
            alice.soul_pos.x = alice.soul_pos.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == alice then
                card.children.floating_sprite:set_sprite_pos(alice.soul_pos)
            end
        end
    end

    cosmic_dt = cosmic_dt + dt
    if G.shared_seals and G.shared_seals.sgt_cosmic_streak and cosmic_dt > 0.125 then
        cosmic_dt = cosmic_dt - 0.125
        local cosmic = G.shared_seals.sgt_cosmic_streak
        if cosmic.sprite_pos.x == 14 then
            cosmic.sprite_pos.x = 0
        else
            cosmic.sprite_pos.x = cosmic.sprite_pos.x + 1
        end
        cosmic:set_sprite_pos(cosmic.sprite_pos)
    end

    miracle_dt = miracle_dt + dt
    if G.shared_seals and G.shared_seals.sgt_gods_miracle and miracle_dt > 0.1 then
        miracle_dt = miracle_dt - 0.1
        local miracle = G.shared_seals.sgt_gods_miracle
        for _, card in pairs(G.I.CARD) do
            if card and card.seal and card.seal == "sgt_gods_miracle"
            and card.sprite_facing == "front" then
                miracle_animate = true
                break
            end
        end
        if miracle_animate then
            if miracle.sprite_pos.x == 101 then
                miracle.sprite_pos.x = 87
            else
                miracle.sprite_pos.x = miracle.sprite_pos.x + 1
            end
            miracle:set_sprite_pos(miracle.sprite_pos)
            miracle_animate = false
        else
            miracle.sprite_pos.x = 0
        end
    end

    if cause_crash then error("A manual crash is called. Don't be grumpy, you did this on purpose.", 0) end
end

-- Esoteric jokers are Exotic equivalents in this mod
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
	set_spritesref(self, _center, _front)
    if _center and _center.name == "Submarine" then
		self.children.extra_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			_center.extra_pos
		)
		self.children.extra_sprite.role.draw_major = self
		self.children.extra_sprite.states.hover.can = false
		self.children.extra_sprite.states.click.can = false
        self.children.extra_sprite.custom_draw = true
	end
    if _center and _center.name == "The Magic Lamp" then
		self.children.floating_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 2, y = 1 }
		)
		self.children.floating_sprite.role.draw_major = self
		self.children.floating_sprite.states.hover.can = false
		self.children.floating_sprite.states.click.can = false
		self.children.floating_sprite2 = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 1, y = 1 }
		)
		self.children.floating_sprite2.role.draw_major = self
		self.children.floating_sprite2.states.hover.can = false
		self.children.floating_sprite2.states.click.can = false
	end
	if _center and _center.soul_pos and _center.soul_pos.extra and not Cryptid then
		self.children.floating_sprite2 = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			_center.soul_pos.extra
		)
		self.children.floating_sprite2.role.draw_major = self
		self.children.floating_sprite2.states.hover.can = false
		self.children.floating_sprite2.states.click.can = false
	end
end

-- Allow using custom joker pools if prompted
local gcp = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    local _pool_key, check = '', false
    for _, group in pairs(SAGA_GROUP_POOL) do
        if _type == group then
            G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
            local _pool, _starting_pool = G.ARGS.TEMP_POOL, nil

            _rarity = (_legendary and 4) or (type(_rarity) == "number" and ((_rarity > 0.95 and 3) or (_rarity > 0.7 and 2) or 1)) or _rarity
            _rarity = ({Common = 1, Uncommon = 2, Rare = 3, Legendary = 4})[_rarity] or _rarity
            local rarity = _rarity or SMODS.poll_rarity("Joker", 'rarity'..G.GAME.round_resets.ante..(_append or ''))

            _starting_pool, _pool_key = G.P_CENTER_POOLS[_type], 'Joker'..rarity..((not _legendary and _append) or '')
            check = true
            for _, v in ipairs(_starting_pool) do
                local add = nil
                local in_pool, pool_opts
                if v.in_pool and type(v.in_pool) == 'function' then
                    in_pool, pool_opts = v:in_pool({ source = _append })
                end
                pool_opts = pool_opts or {}

                if not (G.GAME.used_jokers[v.key] and not pool_opts.allow_duplicates and not next(find_joker("Showman"))) and
                (v.unlocked ~= false) then add = true end

                if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = nil end
                if v.yes_pool_flag and not G.GAME.pool_flags[v.yes_pool_flag] then add = nil end

                if add and not G.GAME.banned_keys[v.key] then
                    _pool[#_pool + 1] = v.key
                end
            end

            if #_pool == 0 then
                _pool[#_pool + 1] = "j_sgt_white_rabbit"
            end
            break
        end
    end
    if check then return _pool, _pool_key..(not _legendary and G.GAME.round_resets.ante or '') end
    return gcp(_type, _rarity, _legendary, _append)
end

-- Sticker-compat for custom joker pools
local cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    -- Forcing joker pools also happens here
    if G.GAME.saga_event and G.GAME.saga_event.alice_in_wonderland.final_showdown and G.GAME.story_mode and _type == "Joker" then
        _type = "Final Showdown"
        if pseudorandom("alice_in_final_showdown") > 0.997 and not next(SMODS.find_card("j_sgt_alice", true)) then
            forced_key = "j_sgt_alice"
        end
    end
    local card = cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    for _, group in pairs(SAGA_GROUP_POOL) do
        if _type == group then
            if G.GAME.modifiers.all_eternal then
                card:set_eternal(true)
            end
            if (area == G.shop_jokers) or (area == G.pack_cards) then
                if not Cryptid then
                    local eternal_perishable_poll = pseudorandom((area == G.pack_cards and 'packetper' or 'etperpoll')..G.GAME.round_resets.ante)
                    if G.GAME.modifiers.enable_eternals_in_shop and eternal_perishable_poll > 0.7 and not SMODS.Stickers["eternal"].should_apply then
                        card:set_eternal(true)
                    elseif G.GAME.modifiers.enable_perishables_in_shop and ((eternal_perishable_poll > 0.4) and (eternal_perishable_poll <= 0.7)) and not SMODS.Stickers["perishable"].should_apply then
                        card:set_perishable(true)
                    end
                    if G.GAME.modifiers.enable_rentals_in_shop and pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr')..G.GAME.round_resets.ante) > 0.7 and not SMODS.Stickers["rental"].should_apply then
                        card:set_rental(true)
                    end
                else
                    local eternal_perishable_poll = pseudorandom("cry_et" .. (key_append or "") .. G.GAME.round_resets.ante)
                    if G.GAME.modifiers.enable_eternals_in_shop and eternal_perishable_poll > 0.7 then
                        card:set_eternal(true)
                    end
                    if G.GAME.modifiers.enable_perishables_in_shop then
                        if
                            not G.GAME.modifiers.cry_eternal_perishable_compat
                            and ((eternal_perishable_poll > 0.4) and (eternal_perishable_poll <= 0.7))
                        then
                            card:set_perishable(true)
                        end
                        if
                            G.GAME.modifiers.cry_eternal_perishable_compat
                            and pseudorandom("cry_per" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7
                        then
                            card:set_perishable(true)
                        end
                    end
                    if
                        G.GAME.modifiers.enable_rentals_in_shop
                        and pseudorandom("cry_ssjr" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7
                    then
                        card:set_rental(true)
                    end
                    if
                        G.GAME.modifiers.cry_enable_pinned_in_shop
                        and pseudorandom("cry_pin" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7
                    then
                        card.pinned = true
                    end
                    if
                        not G.GAME.modifiers.cry_eternal_perishable_compat
                        and G.GAME.modifiers.enable_banana
                        and (pseudorandom("cry_banana" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7)
                        and (eternal_perishable_poll <= 0.7)
                    then
                        card.ability.banana = true
                    end
                    if
                        G.GAME.modifiers.cry_eternal_perishable_compat
                        and G.GAME.modifiers.enable_banana
                        and (pseudorandom("cry_banana" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7)
                    then
                        card.ability.banana = true
                    end
                    if G.GAME.modifiers.cry_sticker_sheet then
                        for k, v in pairs(SMODS.Stickers) do
                            if v.apply and not v.no_sticker_sheet then
                                v:apply(card, true)
                            end
                        end
                    end
                    if
                        not card.ability.eternal
                        and G.GAME.modifiers.cry_enable_flipped_in_shop
                        and pseudorandom("cry_flip" .. (key_append or "") .. G.GAME.round_resets.ante) > 0.7
                    then
                        card.cry_flipped = true
                    end
                end
            end

            if not SMODS.bypass_create_card_edition and not card.edition then
                local edition = poll_edition('edi'..(key_append or '')..G.GAME.round_resets.ante)
            card:set_edition(edition)
            check_for_unlock({type = 'have_edition'})
            end
        end
    end
    return card
end

-- If you own Red Queen in story mode, triggering Final Showdown event "turns" her into Showdown Blind
local gnb = get_new_boss
function get_new_boss()
    if G.GAME.story_mode and G.GAME.saga_event.alice_in_wonderland.final_showdown and not next(SMODS.find_card("j_sgt_mad_hatter")) and not G.GAME.won then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center_key == "j_sgt_red_queen" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
                        v.T.r = -0.2
                        v:juice_up(0.3, 0.4)
                        v.states.drag.is = true
                        v.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(v)
                                    v:remove()
                                    v = nil
                                return true; end}))
                        return true
                    end
                }))
            end
        end
        return 'bl_sgt_red_queen'
    end
    local ret = gnb()
    if ret == 'bl_sgt_red_queen' then G.GAME.red_queen_blind = true end
    return ret
end

-- Disabling Red Queen via using Eat Me! won't cut the score down to 2X base
local disable_ref = Blind.disable
function Blind:disable(...)
    disable_ref(self)
    if self.config.blind.key == "bl_sgt_red_queen" and select(1, ...) then
        self.chips = self.chips*3
		self.chip_text = number_format(self.chips)
    end
end

-- Track if Red Queen is defeated to enable endless-like experience before reaching win Ante
local dft = Blind.defeat
function Blind:defeat(s)
	dft(self, s)
    if self.config.blind.key and self.config.blind.key == "bl_sgt_red_queen" then
        G.GAME.red_queen_defeated = true
    end
end

-- Custom tooltip as hints for story mode advancement (modified from Ortalab)
function saga_hint_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    localize{type = 'descriptions', set = 'Saga Tooltip', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    desc_nodes['colour'] = Sagatro.badge_colour
    desc_nodes.saga_tooltip = true
    desc_nodes.title = _c.title or localize('saga_tooltip')
end

local itfr = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if desc_nodes.saga_tooltip then
        local t = {}
        for _, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = darken(desc_nodes.colour, 0.15), r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    else
        return itfr(desc_nodes, name)
    end
end

-- Force the first pack in shop to be buffoon in certain events
local gp = get_pack
function get_pack(_key, _type)
    if G.GAME.story_mode and not G.GAME.saga_event_forced_buffoon
    and ((G.GAME.saga_event.alice_in_wonderland.white_rabbit_house
    and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house)
    or (G.GAME.saga_event.alice_in_wonderland.goodbye_frog
    and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog)
    or (G.GAME.saga_event.alice_in_wonderland.the_party
    and not G.GAME.saga_event_check.alice_in_wonderland.the_party)
    or (G.GAME.saga_event.alice_in_wonderland.red_queen
    and not G.GAME.saga_event_check.alice_in_wonderland.red_queen)
    or (G.GAME.saga_event.alice_in_wonderland.gryphon
    and not G.GAME.saga_event_check.alice_in_wonderland.gryphon)) then
        G.GAME.saga_event_forced_buffoon = true
        local buffoon_pool = {"p_buffoon_normal_1", "p_buffoon_normal_2", "p_buffoon_jumbo_1", "p_buffoon_mega_1"}
        local chosen_buffoon = pseudorandom_element(buffoon_pool, pseudoseed("saga_event_forced_buffoon"))
        return G.P_CENTERS[chosen_buffoon]
    end
    return gp(_key, _type)
end

local csb = G.FUNCS.can_skip_booster
G.FUNCS.can_skip_booster = function(e)
    csb(e)
    if G.pack_cards and (not (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) and
    (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.label:find("wish_primary")) then
        if next(SMODS.find_card("j_sgt_lamp_genie", true)) then
            local max_collected_wish = 0
            for _, card in ipairs(G.jokers.cards) do
                if card.config.center_key == "j_sgt_lamp_genie" and card.ability.collected_wish > max_collected_wish then
                    max_collected_wish = card.ability.collected_wish
                end
            end
            if max_collected_wish < 2 then
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
            end
        end
    end
end

-- Reset debuff positions of all Mouses outside their own code (because they can't do that if debuffed)
-- Also replenish first-slot buffoon pack if said events are yet to progress
function Sagatro.reset_game_globals(run_start)
    for _, v in ipairs(G.jokers.cards) do
        if v.config.center_key == "j_sgt_mouse" then
            for i = #v.ability.extra.debuff_position, 1, -1 do
                table.remove(v.ability.extra.debuff_position, i)
            end
            v.ability.extra.mult = v.ability.extra.buffer_mult
        end
    end
    if G.GAME.story_mode and G.GAME.saga_event_forced_buffoon
    and ((G.GAME.saga_event.alice_in_wonderland.white_rabbit_house
    and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house)
    or (G.GAME.saga_event.alice_in_wonderland.goodbye_frog
    and not G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog)
    or (G.GAME.saga_event.alice_in_wonderland.the_party
    and not G.GAME.saga_event_check.alice_in_wonderland.the_party)
    or (G.GAME.saga_event.alice_in_wonderland.red_queen
    and not G.GAME.saga_event_check.alice_in_wonderland.red_queen)
    or (G.GAME.saga_event.alice_in_wonderland.gryphon
    and not G.GAME.saga_event_check.alice_in_wonderland.gryphon)) then
        G.GAME.saga_event_forced_buffoon = false
    end
    if G.GAME.saved_by_gods_miracle then
        G.GAME.saved_by_gods_miracle = false
    end
end

-- Yet another get_rank_suffix()
function sgt_get_rank_suffix(card)
    local rank_suffix = (card.base.id - 2) % 13 + 2
    if rank_suffix < 11 then rank_suffix = tostring(rank_suffix)
    elseif rank_suffix == 11 then rank_suffix = 'Jack'
    elseif rank_suffix == 12 then rank_suffix = 'Queen'
    elseif rank_suffix == 13 then rank_suffix = 'King'
    elseif rank_suffix == 14 then rank_suffix = 'Ace'
    end
    return rank_suffix
end

function table.extract_total_value(t)
    local tot = 0
    if type(t) == "table" then
        for _, v in pairs(t) do
            if type(v) == "table" then
                tot = table.extract_total_value(v)
            elseif type(v) == "number" then
                tot = tot + v
            end
        end
    elseif type(t) == "number" then
        tot = tot + t
    end
    return tot
end

function table.contains(t, x)
    found = false
    for _, v in pairs(t) do
        if v == x then
            found = true
			break
        end
    end
    return found
end

-- from Cryptid's Tarot called Blessing, and Ig it works with Deck of Equilibrium as well
-- just have to add "no_doe = true" to exclude Deck of Equilibrium
-- or "no_grc = true" to exclude get_random_consumable, neat
-- wish cards are gonna use the latter, no way I'm letting Frog-Footman steal the show
function sgt_center_no(center, m, key, no_no)
	if no_no then
		return center[m] or (G.GAME and G.GAME[m] and G.GAME[m][key]) or false
	end
	return sgt_center_no(center, "no_" .. m, key, true)
end

function sgt_get_random_consumable(seed, excluded_flags, banned_card, pool, no_undiscovered)
	excluded_flags = excluded_flags or { "hidden", "no_doe", "no_grc" }
	local selection = "n/a"
	local passes = 0
	local tries = 500
	while true do
		tries = tries - 1
		passes = 0
		local key = pseudorandom_element(pool or G.P_CENTER_POOLS.Consumeables, pseudoseed(seed or "grc")).key
		selection = G.P_CENTERS[key]
		if selection.discovered or not no_undiscovered then
			for _, v in ipairs(excluded_flags) do
				if not sgt_center_no(selection, v, key, true) then
					if not banned_card or (banned_card and banned_card ~= key) then
						passes = passes + 1
					end
				end
			end
		end
		if passes >= #excluded_flags or tries <= 0 then
			if tries <= 0 and no_undiscovered then
				return G.P_CENTERS["c_strength"]
			else
				if Sagatro.debug then print(selection.key) end
                return selection
			end
		end
	end
end

-- Implement exponential Mult without Talisman dependency (some other mods also do this)
if not (SMODS.Mods["Talisman"] or {}).can_load
and not (SMODS.Mods["Buffoonery"] or {}).can_load
and not (SMODS.Mods["Prism"] or {}).can_load then
	if SMODS and SMODS.calculate_individual_effect then
		local originalCalcIndiv = SMODS.calculate_individual_effect
		function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = originalCalcIndiv(effect, scored_card, key, amount, from_edition)
		if ret then
			return ret
		end

		if (key == 'e_mult' or key == 'emult' or key == 'Emult_mod') and amount ~= 1 then
			if effect.card then juice_card(effect.card) end
			mult = mod_mult(mult ^ amount)
			update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
			if not effect.remove_default_message then
				if from_edition then
					card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
				elseif key ~= 'Emult_mod' then
					if effect.emult_message then
						card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.emult_message)
					else
						card_eval_status_text(scored_card or effect.card or effect.focus, 'e_mult', amount, percent)
					end
				end
			end
			return true
		end
		end
		for _, v in ipairs({'e_mult','emult','Emult_mod'}) do
		table.insert(SMODS.calculation_keys, v)
		end
	end
end

SMODS.DrawStep({
    key = "extra_sprite",
    order = 21,
    func = function(self, layer)
        if self.ability.name == "Submarine" and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.extra_sprite:draw_shader(
                "dissolve",
                nil,
                nil,
                nil,
                self.children.center,
                scale_mod,
                rotate_mod
            )
            if self.edition and not self.delay_edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if self.edition[v.key:sub(3)] and v.shader then
                        if type(v.draw) == 'function' then
                            v:draw(self, layer)
                        else
                            self.children.extra_sprite:draw_shader(v.shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
                        end
                    end
                end
            end
            if self.edition and self.edition.negative then
                self.children.extra_sprite:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end
    end,
    conditions = { vortex = false, facing = "front" },
})
SMODS.draw_ignore_keys.extra_sprite = true

SMODS.DrawStep({
    key = "floating_sprite2",
    order = 58,
    func = function(self)
        if self.ability.name == "The Magic Lamp" and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod2 = 0.07 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod2 = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.floating_sprite2:draw_shader(
                "dissolve",
                0,
                nil,
                nil,
                self.children.center,
                scale_mod2,
                rotate_mod2,
                nil,
                0.1 --[[ + 0.03*math.cos(1.8*G.TIMERS.REAL)--]],
                nil,
                0.6
            )
            self.children.floating_sprite2:draw_shader(
                "dissolve",
                nil,
                nil,
                nil,
                self.children.center,
                scale_mod2,
                rotate_mod2
            )

            local scale_mod = 0.05
                + 0.05 * math.sin(1.8 * G.TIMERS.REAL)
                + 0.07
                    * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14)
                    * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            local rotate_mod = 0.1 * math.sin(1.219 * G.TIMERS.REAL)
                + 0.07
                    * math.sin(G.TIMERS.REAL * math.pi * 5)
                    * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            self.children.floating_sprite.role.draw_major = self
            self.children.floating_sprite:draw_shader(
                "dissolve",
                0,
                nil,
                nil,
                self.children.center,
                scale_mod,
                rotate_mod,
                nil,
                0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL),
                nil,
                0.6
            )
            self.children.floating_sprite:draw_shader(
                "dissolve",
                nil,
                nil,
                nil,
                self.children.center,
                scale_mod,
                rotate_mod
            )
        elseif
            not Cryptid
            and self.config.center.soul_pos
            and self.config.center.soul_pos.extra
            and (self.config.center.discovered or self.bypass_discovery_center)
        then
            local scale_mod = 0.07 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.floating_sprite2:draw_shader(
                "dissolve",
                0,
                nil,
                nil,
                self.children.center,
                scale_mod,
                rotate_mod,
                nil,
                0.1 --[[ + 0.03*math.cos(1.8*G.TIMERS.REAL)--]],
                nil,
                0.6
            )
            self.children.floating_sprite2:draw_shader(
                "dissolve",
                nil,
                nil,
                nil,
                self.children.center,
                scale_mod,
                rotate_mod
            )
        end
    end,
    conditions = { vortex = false, facing = "front" },
})
SMODS.draw_ignore_keys.floating_sprite2 = true

Sagatro.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 4}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
			create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', info = localize('SGT_disable_other_jokers_desc'), active_colour = Sagatro.badge_colour, right = true}),
		}},
    }}
end

-- Debug territory
function sgt_help()
    if Sagatro.debug then
        print("Sagatro debug commands:")
        print("sgt_help() or help(): show this help screen.")
        print("sgt_print_rarity(): print out modifications of each rarity pool.")
        print("sgt_change_joker(index, x, ...): change the numerical values inside 'ability.extra' table (or ability.extra itself if it's a number) of the joker at 'index' slot to 'x' and the following arguments (if applicable).")
        print("sgt_event_list(): list all stories with their corresponding events.")
        print("sgt_story_mode(): check if a run has story mode enabled.")
        print("sgt_final_hand(): set hand count to 1.")
        print("sgt_no_discard(): set discard count to 0.")
        print("sgt_crash() or crash(): manually cause a crash.")
        return "Remember to always prepend 'eval' because that's how DebugPlus executes lua code directly."
    end
    return "Debug commands are unavailable."
end

help = help or sgt_help

function sgt_print_rarity()
    if Sagatro.debug then
        for k, v in pairs(G.GAME) do
            if string.len(k) > 4 and string.find(k, "_mod") and type(v) == "number" then
                print(k..": "..v)
            end
        end
        return "Default value is 1."
    end
    return "Debug commands are unavailable."
end

---@param index number
---@param x number
---@param ... number
function sgt_change_joker(index, x, ...)
    if not Sagatro.debug then return "Debug commands are unavailable." end
    if G and not G.jokers then return "Failed: not in a live run." end
    if G.jokers.cards[index] then
        if type(G.jokers.cards[index].ability.extra) == "number" then
            G.jokers.cards[1].ability.extra = x
        elseif type(G.jokers.cards[index].ability.extra) == "table" then
            local i = 0
            for k, v in pairs(G.jokers.cards[index].ability.extra) do
                if type(v) == "number" then
                    if i > 0 and select(i, ...) then
                        G.jokers.cards[index].ability.extra[k] = select(i, ...)
                        i = i + 1
                    else
                        G.jokers.cards[index].ability.extra[k] = x
                        i = i + 1
                    end
                end
            end
        end
        return string.format("Successfully changed the value(s) to %q and the following argument(s).", x)
    end
    return "Failed: index out of range."
end

function sgt_event_list()
    if Sagatro.debug then
        for story, events in pairs(G.GAME.saga_event) do
            print(story..":", events)
        end
        return "Currently active events yield true."
    end
    return "Debug commands are unavailable."
end

function sgt_story_mode()
    if Sagatro.debug then
        if G.STAGE == G.STAGES.RUN then
            if G.GAME.story_mode then
                return "This run is currently in story mode."
            else
                return "This run is currently not in story mode."
            end
        else
            return "You're not in a live run."
        end
    end
    return "Debug commands are unavailable."
end

function sgt_final_hand()
    if Sagatro.debug then
        ease_hands_played(-G.GAME.current_round.hands_left + 1)
        return "Successfully set hand count to 1."
    end
    return "Debug commands are unavailable."
end

function sgt_no_discard()
    if Sagatro.debug then
        ease_discards(-G.GAME.current_round.discards_left)
        return "Successfully set discard count to 0."
    end
    return "Debug commands are unavailable."
end

function sgt_debug()
    Sagatro.debug = not Sagatro.debug
    return Sagatro.debug and "Sagatro debug mode enabled." or "Sagatro debug mode disabled."
end

function sgt_crash()
    if Sagatro.debug then
        cause_crash = true
    end
    return not Sagatro.debug and "Are you sure you want to do this? Thankfully Sagatro debug mode is off. Turn it on before executing this command." or "Crashing game..."
end

crash = crash or sgt_crash