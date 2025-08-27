-- Global colours
G.C.SGT_TRIVIAL = HEX("808080")
G.C.SGT_OBSCURE = HEX("8627D4")
G.C.SGT_ESOTERIC = HEX("131868")
G.C.SGT_WISH = HEX("9bbcfd")
G.C.SGT_DIVINATIO = HEX("3bc9cf")
G.C.SGT_ELDRITCH = HEX("3f0c57")
G.C.SUBMARINE_DEPTH = {
    HEX("3a86e1"),
    HEX("265792"),
    HEX("122d4c"),
    HEX("091829"),
    HEX("060f1a"),
}
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
                "j_sgt_alice",
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
    ret.fusion_table = Sagatro.config.DisableOtherJokers and SagaFusion.fusions or {}
    ret.red_queen_blind = false
    ret.red_queen_defeated = false
    ret.saved_by_gods_miracle = false
    ret.wish_card_spawns_genie = false -- Deck of Equilibrium compat
    ret.last_tarot_planet_divinatio = nil
    ret.orbis_fatum_odds = 4
    ret.perishable_already_active = false
	return ret
end

-- Pretty much stolen from Cryptid lmao
local gmm = Game.main_menu
function Game:main_menu(change_context)
    gmm(self, change_context)

    local selected_card = Ortalab and Ortalab.config.menu_toggle and "j_sgt_mabel" or "j_sgt_alice"
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
    newcard.sagatro_target = true

    if not Ortalab or (Ortalab and not Ortalab.config.menu_toggle) then
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
    end

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = change_context == 'game' and 1.5 or 0,
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
end

-- Mouse and Pufferfish's conditional debuff mechanic
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
                        SMODS.debuff_card(v, true, "j_sgt_mouse")
                    else
                        SMODS.debuff_card(v, false, "j_sgt_mouse")
                        v.ability.extra.mult = v.ability.extra.buffer_mult
                    end
                end
            end
            if v.ability.debuff_sources and v.ability.debuff_sources.j_sgt_pufferfish then
                local unpoisoned = {false, false}
                if not G.jokers.cards[i-1] or G.jokers.cards[i-1].config.center_key ~= "j_sgt_pufferfish" then
                    unpoisoned[1] = true
                end
                if not G.jokers.cards[i+1] or G.jokers.cards[i+1].config.center_key ~= "j_sgt_pufferfish" then
                    unpoisoned[2] = true
                end
                if (unpoisoned[1] and unpoisoned[2])
                or G.STATE == G.STATES.SHOP
                or G.STATE == G.STATES.SMODS_REDEEM_VOUCHER
                or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
                    SMODS.debuff_card(v, false, "j_sgt_pufferfish")
                end
            end
            if v.config.center_key == "j_sgt_pufferfish"
            and G.STATE ~= G.STATES.SHOP
            and G.STATE ~= G.STATES.SMODS_REDEEM_VOUCHER
            and G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then
                if G.jokers.cards[i-1] and G.jokers.cards[i-1].config.center_key ~= "j_sgt_pufferfish" then
                    SMODS.debuff_card(G.jokers.cards[i-1], true, "j_sgt_pufferfish")
                end
                if G.jokers.cards[i+1] and G.jokers.cards[i+1].config.center_key ~= "j_sgt_pufferfish" then
                    SMODS.debuff_card(G.jokers.cards[i+1], true, "j_sgt_pufferfish")
                end
            end
        end
    end
    -- Nope, Mouse in consumable slot won't work
    -- Not worth spending Anubis on it
    if self == G.consumeables and G.consumeables.cards[1] then
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center_key == "j_sgt_mouse" then
                SMODS.debuff_card(v, true, "j_sgt_mouse")
            end
        end
    end
end

-- Pseudo-animation and manual crash
cause_crash = false
nemo_dt = 0
alice_dt = 0
cosmic_dt = 0
miracle_dt = 0
miracle_animate = false
nameless_dt = 0
submarine_dt = 0
local upd = Game.update
function Game:update(dt)
	upd(self, dt)

    if G.STAGE == G.STAGES.RUN then
        if G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SHOP then
            -- Handle opening Mega Buffoon Pack spawned by Utima Vox (restricted to during shop and blind select)
            if G.GAME.pending_mega_buffoon then
                G.GAME.pending_mega_buffoon = nil
                G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                    G.CONTROLLER.locks.utima_vox = true
                    G.E_MANAGER:add_event(Event({func = function()
                        local key = "p_buffoon_mega_1"
                        local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                        G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                        _card.cost = 0
                        _card.from_tag = true
                        G.FUNCS.use_card({config = {ref_table = _card}})
                        _card:start_materialize()
                        G.CONTROLLER.locks.utima_vox = nil
                    return true end }))
                return true end }))
            end
        end
        -- Adam's ability to enable perishable in shop (take Orange Stake effect into account)
        if not (Ortalab or G.GAME.perishable_already_active) then
            G.GAME.modifiers.enable_perishables_in_shop = next(SMODS.find_card("j_sgt_adam")) and true or nil
        end
    end

    if G.your_collection and type(G.your_collection) == "table" then
        for _, collection_row in ipairs(G.your_collection) do
            if collection_row.cards and type(collection_row.cards) == "table" then
                for _, v in ipairs(collection_row.cards) do
                    if v.config.center_key == "j_sgt_submarine" and v.config.center.discovered then
                        v.ability.anim_dt = v.ability.anim_dt + dt
                        v.ability.anim_transition_path = v.ability.immutable.old_depth_level - v.ability.immutable.depth_level
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
                                v.ability.immutable.old_depth_level = v.ability.immutable.depth_level
                            else
                                v.ability.anim_pos.x = v.ability.anim_pos.x + 1
                            end
                            v.ability.anim_pos.y = (math.min(v.ability.immutable.old_depth_level, v.ability.immutable.depth_level) - 1)
                            + (v.ability.in_transition and 5 or 0)
                            v.children.center:set_sprite_pos(v.ability.anim_pos)
                        end
                    end
                end
            end
        end
    end

    nameless_dt = nameless_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_nameless and nameless_dt > 0.125 then
        nameless_dt = nameless_dt - 0.125
        local nameless = G.P_CENTERS.j_sgt_nameless
        if nameless.pos.x == 11 then
            nameless.pos.x = 0
            nameless.soul_pos.x = 0
            nameless.soul_pos.extra.x = 0
        else
            nameless.pos.x = nameless.pos.x + 1
            nameless.soul_pos.x = nameless.soul_pos.x + 1
            nameless.soul_pos.extra.x = nameless.soul_pos.extra.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == nameless then
                card.children.floating_sprite:set_sprite_pos(nameless.soul_pos)
                card.children.floating_sprite2:set_sprite_pos(nameless.soul_pos.extra)
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

    nemo_dt = nemo_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_nemo and nemo_dt > 0.125 then
        nemo_dt = nemo_dt - 0.125
        local nemo = G.P_CENTERS.j_sgt_nemo
        if nemo.soul_pos.x == 24 then
            nemo.soul_pos.x = 1
        else
            nemo.soul_pos.x = nemo.soul_pos.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == nemo then
                card.children.floating_sprite:set_sprite_pos(nemo.soul_pos)
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
    if _center and _center.name == "The Sinister" then
		self.children.floating_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 7, y = 4 }
		)
		self.children.floating_sprite.role.draw_major = self
		self.children.floating_sprite.states.hover.can = false
		self.children.floating_sprite.states.click.can = false
	end
    if _center and _center.name == "Anima" then
		self.children.floating_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 3, y = 2 }
		)
		self.children.floating_sprite.role.draw_major = self
		self.children.floating_sprite.states.hover.can = false
		self.children.floating_sprite.states.click.can = false
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
    local _pool, _starting_pool, _pool_key, check = nil, nil, '', false
    for _, group in pairs(SAGA_GROUP_POOL) do
        if _type == group then
            G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
            _pool, _starting_pool, _pool_key, check = G.ARGS.TEMP_POOL, G.P_CENTER_POOLS[_type], _type..(_append or ''), true
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

            if Sagatro.debug then print("From custom pool: ".._type) end
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
    if next(SMODS.find_card("j_sgt_yggdrasil")) and _type == "Joker" then
        if pseudorandom("yggdrasil") > 0.95 then
            _type = "Norse Gods"
        end
    end
    if G.GAME.saga_event and G.GAME.saga_event.alice_in_wonderland.final_showdown and G.GAME.story_mode and _type == "Joker" then
        _type = "Final Showdown"
        if pseudorandom("alice_in_final_showdown") > 0.997 then
            if not G.GAME.won and not next(SMODS.find_card("j_sgt_alice", true)) then
                forced_key = "j_sgt_alice"
            elseif G.GAME.won then
                local jokers = {"j_sgt_alice", "j_sgt_nemo"}
                forced_key = pseudorandom_element(jokers, pseudoseed("showdown_endless_roll"))
                if next(SMODS.find_card("j_sgt_alice", true)) then
                    forced_key = "j_sgt_nemo"
                elseif next(SMODS.find_card("j_sgt_nemo", true)) then
                    forced_key = nil
                end
            end
        end
    end
    local card = cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if card.config.center_key == "j_sgt_ugly_blobfish" then
		card:set_perishable(true)
	end
    for _, group in pairs(SAGA_GROUP_POOL) do
        if _type == group then
            if G.GAME.modifiers.all_eternal then
                card:set_eternal(true)
            end
            if G.GAME.modifiers.cry_all_perishable then
                card:set_perishable(true)
            end
            if G.GAME.modifiers.cry_all_rental then
                card:set_rental(true)
            end
            if G.GAME.modifiers.cry_all_pinned then
                card.pinned = true
            end
            if G.GAME.modifiers.cry_all_banana then
                card.ability.banana = true
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
    if next(SMODS.find_card("j_sgt_darkness")) and _type == "Joker" then
        if pseudorandom("darkness_negative_joker") > 0.5 then
            card:set_edition("e_negative")
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

-- Custom tooltip (modified from Ortalab)
function saga_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    localize{type = 'descriptions', set = _c.set, key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    desc_nodes['colour'] = _c.colour or Sagatro.badge_colour
    desc_nodes.saga_tooltip = true
    desc_nodes.title = _c.title or localize(_c.key) ~= "ERROR" and localize(_c.key) or localize('saga_tooltip')
    desc_nodes.default_colour = _c.default_colour
end

local itfr = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if desc_nodes.saga_tooltip then
        local t = {}
        for _, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = desc_nodes.default_colour and mix_colours(G.C.WHITE, G.C.GREY, 0.2) or darken(desc_nodes.colour, 0.15), r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = desc_nodes.default_colour and G.C.WHITE or lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
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

-- Ah yes, Nameless' secret ability is to slowly flood your shop voucher with Antimatter
local avts = SMODS.add_voucher_to_shop
function SMODS.add_voucher_to_shop(key)
    local found = false
    for _, v in ipairs(G.jokers.cards or {}) do
        if v.config.center_key == "j_sgt_nameless" then
            found = true
            break
        end
    end
    if found and pseudorandom("nameless_antimatter") < (G.GAME.antimatter_overload or 0.2) then
        key = "v_antimatter"
        G.GAME.antimatter_overload = (G.GAME.antimatter_overload or 0.2) + 0.1
        if G.GAME.antimatter_overload > 1 then
            G.GAME.antimatter_overload = 1
        end
    end
    return avts(key)
end

local smeared = SMODS.smeared_check
function SMODS.smeared_check(card, suit)
    if next(SMODS.find_card("j_sgt_sunfish")) then
        if ((card.base.suit == 'Hearts' or card.base.suit == 'Diamonds') and (suit == 'Hearts' or suit == 'Diamonds')) then
            return true
        end
    end
    if next(SMODS.find_card("j_sgt_moonfish")) then
        if (card.base.suit == 'Spades' or card.base.suit == 'Clubs') and (suit == 'Spades' or suit == 'Clubs') then
            return true
        end
    end
    return smeared(card, suit)
end

local shortcut = SMODS.shortcut
function SMODS.shortcut()
    if next(SMODS.find_card('j_sgt_frog_prince')) then
        return true
    end
    return shortcut()
end

-- Reset debuff positions of all Mouses outside their own code (because they can't do that if debuffed)\
-- Also replenish first-slot buffoon pack if said events are yet to progress
function Sagatro.reset_game_globals(run_start)
    for _, v in ipairs(G.jokers.cards) do
        if v.config.center_key == "j_sgt_mouse" then
            for i = #v.ability.extra.debuff_position, 1, -1 do
                table.remove(v.ability.extra.debuff_position, i)
            end
            SMODS.debuff_card(v, false, "j_sgt_mouse")
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

---@param t table
table.contains = table.contains or function(t, x)
    for _, v in pairs(t) do
		if v == x then
			return true
		end
	end
	return false
end

function Sagatro.get_submarine_depth_colour()
    local max_depth = 1
    for _, v in ipairs(SMODS.find_card("j_sgt_submarine", true)) do
        if max_depth < v.ability.immutable.depth_level then
            max_depth = v.ability.immutable.depth_level
        end
    end
    return max_depth
end

function Sagatro.conductive_enhancement(card)
    if not card then return end
    return Sagatro.omniscient(card, Sagatro.electric_eel_info_queue)
end

-- Append enhancement keys to `Sagatro.electric_eel_info_queue` to include your target enhancements
function Sagatro.electric_eel_info_queue_append(info_queue, center_table)
    if center_table and type(center_table) == 'table' then
        for _, center in ipairs(center_table) do
            if G.P_CENTERS[center] then
                info_queue[#info_queue+1] = G.P_CENTERS[center]
            end
        end
    end
end

-- Append key-pair to repsective table of `Sagatro.necronomicon` to include your own object weight\
-- All seals have the same weight for balancing purpose
function Sagatro.necronomicon_get_weight(card)
    local weight = 0
    if not card then return weight end
    for k, _ in pairs(SMODS.get_enhancements(card)) do
        weight = weight + (Sagatro.necronomicon.enhancement_weight[k] or 1)
    end
    weight = weight + (card.edition and (Sagatro.necronomicon.edition_weight[card.edition.key]
        or Sagatro.necronomicon.edition_weight.generic) or 0)
    weight = weight + (card.seal and Sagatro.necronomicon.seal_weight.generic or 0)
    return weight
end

---@param weight number
function Sagatro.necronomicon_get_rarity(weight)
    for _, v in ipairs(Sagatro.necronomicon.rarity_order) do
        if weight >= Sagatro.necronomicon.rarity_weight[v] then
            return v
        end
    end
    return "Common"
end

-- Darn, Ortalab has this whole function just to set up floating blind sprites for a voucher\
-- Moving mine into Sagatro table Ig
function Sagatro.get_new_showdown()
    G.GAME.perscribed_showdown = G.GAME.perscribed_showdown or {}
    if G.GAME.perscribed_showdown and G.GAME.perscribed_showdown[G.GAME.round_resets.ante] then
        local ret_boss = G.GAME.perscribed_showdown[G.GAME.round_resets.ante]
        G.GAME.perscribed_showdown[G.GAME.round_resets.ante] = nil
        G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
        return ret_boss
    end
    if G.FORCE_SHOWDOWN then return G.FORCE_SHOWDOWN end

    local eligible_bosses = {}
    for k, v in pairs(G.P_BLINDS) do
        if v.boss and v.boss.showdown then
            if v.in_pool and type(v.in_pool) == 'function' then
                local res = SMODS.add_to_pool(v)
                eligible_bosses[k] = res and true or nil
            else
                eligible_bosses[k] = true
            end
        end
    end
    for k, v in pairs(G.GAME.banned_keys) do
        if eligible_bosses[k] then eligible_bosses[k] = nil end
    end
    if G.GAME.modifiers.ortalab_only then
        for k, v in pairs(eligible_bosses) do
            if eligible_bosses[k] and not G.P_BLINDS[k].mod or G.P_BLINDS[k].mod.id ~= 'ortalab' then
                eligible_bosses[k] = nil
            end
        end
    end

    local min_use = 100
    for k, v in pairs(G.GAME.bosses_used) do
        if eligible_bosses[k] then
            eligible_bosses[k] = v
            if eligible_bosses[k] <= min_use then
                min_use = eligible_bosses[k]
            end
        end
    end
    for k, v in pairs(eligible_bosses) do
        if eligible_bosses[k] then
            if eligible_bosses[k] > min_use then
                eligible_bosses[k] = nil
            end
        end
    end
    local _, boss = pseudorandom_element(eligible_bosses, pseudoseed('showdown'))
    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1

    return boss
end

-- Omniscient acts as every other enhancement
function Sagatro.omniscient(card, key)
    if not key then return false end
    if not key[1] then key = {key} end
    local ret = false
    for _, enh in ipairs(key) do
        ret = ret or SMODS.has_enhancement(card, enh)
    end
    return ret or SMODS.has_enhancement(card, "m_sgt_omniscient")
end

function Sagatro.random_destroy(used_tarot)
    local destroyed_cards = {}
    destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
            for i = #destroyed_cards, 1, -1 do
                local card = destroyed_cards[i]
                if SMODS.shatters(card) then
                    card:shatter()
                else
                    card:start_dissolve(nil, i ~= #destroyed_cards)
                end
            end
            return true
        end
    }))
    return destroyed_cards
end

function Sagatro.set_debuff(card)
    if SMODS.has_enhancement(card, "m_sgt_strange") then
        return "prevent_debuff"
    end
end

function mabel_stall()
    if not G.jokers then return false end
    for i, v in ipairs(G.jokers.cards) do
        if v.config.center_key == "j_sgt_mabel" and i ~= 1 and i ~= #G.jokers.cards then
            return true
        end
    end
    return false
end

-- Borrowing these from Ortalab (nope, the +JokerSlot animation is not necessary)
function Sagatro.update_blind_amounts()
    if G.GAME.blind then
        G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.blind.mult*G.GAME.starting_params.ante_scaling
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if G.STATE == G.STATES.BLIND_SELECT and G.blind_select then
        G.blind_select:remove()
        G.blind_prompt_box:remove()
        G.blind_select = UIBox{
            definition = create_UIBox_blind_select(),
            config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29},major = G.hand, bond = 'Weak'}
        }
        G.blind_select.alignment.offset.y = 0.8-(G.hand.T.y - G.jokers.T.y) + G.blind_select.T.h
    end
end

local gba = get_blind_amount
function get_blind_amount(ante)
    local amount = gba(ante)
    for _, card in ipairs(SMODS.find_card('j_sgt_three_winters')) do
        amount = amount * card.ability.extra.xblind_amount
    end
    return amount
end

---@param args table|nil arguments for sound
---@param extra_func function|nil extra function to execute
---Self-destruct action like Gros Michel with customizable arguments
function Sagatro.self_destruct(card, args, extra_func)
    args = args or {}
    card.getting_sliced = true
    if not (card.ability.set == 'Default' or card.ability.set == 'Enhanced') then
        local flags = SMODS.calculate_context({joker_type_destroyed = true, card = card})
        if flags.no_destroy then card.getting_sliced = nil; return end
    end
    G.E_MANAGER:add_event(Event({
        func = function()
            if not args.no_sound then
                play_sound(args.sound or "tarot1", args.pitch, args.volume)
            end
            if extra_func then extra_func() end
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                    return true; end}))
            return true
        end
    }))
end

function Sagatro.quip_filter(quip, quip_type)
    if G.GAME.story_mode and (not quip.mod or (quip.mod and quip.mod.id ~= "Sagatro")) then
        return false
    end
    return true
end

-- global mod `calculate` is cool, but not yet needed for now
function Sagatro.calculate(self, context)
    if G.GAME.story_mode then end
end

-- from Cryptid's Tarot called Blessing
-- and I thought it could exclude cards from getting called in get_random_consumable and from Deck of Equilibrium
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

local tag_zodiac_align = {2, 2, 3, 4, 4, 5, 5, 6}

local at = add_tag
function add_tag(tag)
	at(tag)
    local max_tag_count = 13
    if Ortalab then
        local zodiac_count = G.HUD_zodiac and #G.HUD_zodiac or 0
        if zodiac_count > 0 then
            max_tag_count = 13 - (tag_zodiac_align[zodiac_count] or tag_zodiac_align[8])
        end
    end
    if #G.HUD_tags > max_tag_count then
        for i = 2, #G.HUD_tags do
            G.HUD_tags[i].config.offset.y = 0.9 - 0.9 * max_tag_count / #G.HUD_tags
        end
    end
end

local tr = Tag.remove
function Tag:remove()
	tr(self)
    local max_tag_count = 13
    if Ortalab then
        local zodiac_count = G.HUD_zodiac and #G.HUD_zodiac or 0
        if zodiac_count > 0 then
            max_tag_count = 13 - (tag_zodiac_align[zodiac_count] or tag_zodiac_align[8])
        end
    end
    if #G.HUD_tags > max_tag_count then
        for i = 2, #G.HUD_tags do
            G.HUD_tags[i].config.offset.y = 0.9 - 0.9 * max_tag_count / #G.HUD_tags
        end
    end
end

-- Implement exponential Mult without Talisman dependency
local cie = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    local ret = cie(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if (key == 'sgt_e_mult' or key == 'sgt_emult' or key == 'sgt_Emult_mod') and amount ~= 1 then
        if effect.card then juice_card(effect.card) end
        if SMODS.Scoring_Parameters then
            local _mult = SMODS.Scoring_Parameters.mult
            _mult:modify(_mult.current ^ amount - _mult.current)
        else
            mult = mod_mult(mult ^ amount)
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
        end
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_Emult_mod' then
                if effect.emult_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.emult_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_e_mult', amount, percent)
                end
            end
        end
        return true
    end
end

for _, v in ipairs{'sgt_e_mult','sgt_emult','sgt_Emult_mod'} do
    table.insert(SMODS.scoring_parameter_keys or SMODS.calculation_keys, v)
end

if Ortalab then
    local mr = menu_refresh
    if mr then
        function menu_refresh()
            if not G.title_top then return end
            mr()

            for _, v in ipairs(G.title_top.cards) do
                if v.sagatro_target then
                    v:set_ability(G.P_CENTERS[Ortalab.config.menu_toggle and "j_sgt_mabel" or "j_sgt_alice"], nil)
                    if v.edition and v.edition.negative then
                        v:set_edition(nil, true, true)
                    end
                elseif v.config.card_key then
                    v:set_edition(Ortalab.config.menu_toggle and "e_negative" or nil, true, true)
                end
            end

            local splash_args = {mid_flash = 0.}

            G.SPLASH_BACK:define_draw_steps({
            {
                shader = Ortalab.config.menu_toggle and 'ortalab_background' or 'splash',
                send = {
                    { name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
                    { name = "vort_speed", val = 0.4 },
                    { name = 'colour_1', ref_table = Ortalab.config.menu_toggle and G.ARGS.LOC_COLOURS or Sagatro, ref_value = Ortalab.config.menu_toggle and 'Ort_menu_colourA' or 'badge_colour' },
                    { name = 'colour_2', ref_table = Ortalab.config.menu_toggle and G.ARGS.LOC_COLOURS or G.C.RARITY, ref_value = Ortalab.config.menu_toggle and 'Ort_menu_colourB' or 4 },
                    { name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash' },
                    { name = 'vort_offset', val = 0 },
                },
            },
        })
        end
    end

    local az = add_zodiac
    function add_zodiac(_tag, silent, from_load, from_patch)
        az(_tag, silent, from_load, from_patch)
        local max_tag_count = 13
        if Ortalab then
            local zodiac_count = #G.HUD_zodiac or 0
            if zodiac_count > 0 then
                max_tag_count = 13 - (tag_zodiac_align[zodiac_count] or tag_zodiac_align[8])
            end
        end
        if G.HUD_tags and #G.HUD_tags > max_tag_count then
            for i = 2, #G.HUD_tags do
                G.HUD_tags[i].config.offset.y = 0.9 - 0.9 * max_tag_count / #G.HUD_tags
            end
        end
    end

    local rmz = Zodiac.remove_zodiac
    function Zodiac:remove_zodiac(message, _colour, func)
        rmz(self, message, _colour, func)
        local max_tag_count = 13
        if Ortalab then
            local zodiac_count = #G.HUD_zodiac or 0
            if zodiac_count > 0 then
                max_tag_count = 13 - (tag_zodiac_align[zodiac_count] or tag_zodiac_align[8])
            end
        end
        if G.HUD_tags and #G.HUD_tags > max_tag_count then
            for i = 2, #G.HUD_tags do
                G.HUD_tags[i].config.offset.y = 0.9 - 0.9 * max_tag_count / #G.HUD_tags
            end
        end
    end
end

SMODS.DrawStep {
    key = 'eldritch_shine',
    order = 10,
    func = function(self)
        if self.ability.set == "Eldritch" or self.config.center.group_key == "sgt_eldritch_pack" or self.ability.name == "Anima" then
            self.children.center:draw_shader("booster", nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = "front" },
}

SMODS.DrawStep {
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
            if self.debuff then
                self.children.extra_sprite:draw_shader('debuff', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end
    end,
    conditions = { vortex = false, facing = "front" },
}
SMODS.draw_ignore_keys.extra_sprite = true

SMODS.DrawStep {
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
        elseif (self.ability.name == "The Sinister" or self.ability.name == "Anima") and (self.config.center.discovered or self.bypass_discovery_center) then
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
}
SMODS.draw_ignore_keys.floating_sprite2 = true

G.FUNCS.delete_ace_in_menu = function(e)
    if G.title_top then
        for _, card in ipairs(G.title_top.cards) do
            if card.config.card_key then -- "Delete Ace" is cosmetic, this should delete any playing card
                card:remove()
                G.title_top.config.type = "title_2"
                break
            end
        end
    end
    G.FUNCS.exit_overlay_menu()
end

Sagatro.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 4}, nodes = {
        {n=G.UIT.C, config = {align = 'cm'}, nodes={
			create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', info = localize('SGT_disable_other_jokers_desc'), active_colour = Sagatro.badge_colour, right = true}),
			create_toggle({label = localize('SGT_disable_sagatro_items'), ref_table = Sagatro.config, ref_value = 'DisableSagatroItems', info = localize('SGT_disable_sagatro_items_desc'), active_colour = Sagatro.badge_colour, right = true}),
			create_toggle({label = localize('SGT_sagatro_music'), ref_table = Sagatro.config, ref_value = 'SagatroMusic', info = localize('SGT_sagatro_music_desc'), active_colour = Sagatro.badge_colour, right = true}),
			create_toggle({label = localize('SGT_ortagas'), ref_table = Sagatro.config, ref_value = 'Ortagas', info = localize('SGT_ortagas_desc'), active_colour = Sagatro.badge_colour, right = true, callback = function() if menu_refresh and G.title_top then menu_refresh() end end}),
		}},
    }}
end

if Overflow and Overflow.blacklist then
	Overflow.blacklist["c_sgt_iustitia_sacra"] = true
end

if JokerDisplay then
    local jd_def = JokerDisplay.Definitions

    jd_def.j_ticket.calc_function = function(card)
        local dollars = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if Sagatro.omniscient(scoring_card, {"m_gold", "m_sgt_platinum"}) then
                    dollars = dollars +
                        card.ability.extra *
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.dollars = dollars
        card.joker_display_values.localized_text = localize("k_gold")
    end

    local jdcct = JokerDisplay.calculate_card_triggers
    JokerDisplay.calculate_card_triggers = function(card, scoring_hand, held_in_hand)
        if card.debuff then
            return 0
        end
        local triggers = jdcct(card, scoring_hand, held_in_hand)
        triggers = triggers + (card:get_seal() == 'sgt_Blood' and 2 or 0)
        return triggers
    end

    local jdgda = JokerDisplay.get_display_areas
    function JokerDisplay.get_display_areas()
        local ret = jdgda()
        if not table.contains(ret, G.consumeables) then
            ret[#ret+1] = G.consumeables
        end
        return ret
    end
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