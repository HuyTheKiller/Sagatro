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

-- to_big = to_big or function(x)
--     return x
-- end

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
        },
    }
    -- A table to control joker pools during certain events
    ret.saga_spawn_table = {
        alice_in_wonderland = {
            cry_into_flood = {
                "j_splash",
                "j_sgt_mouse",
            },
            white_rabbit_house = nil,
            little_bill = nil,
            huge_dog = nil,
            caterpillar = nil,
            pig_and_pepper = nil,
            goodbye_frog = nil,
        },
    }
    ret.alice_multiplier = 1
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

local cardarea_update_ref = CardArea.update
function CardArea:update(dt)
	cardarea_update_ref(self, dt)
    if self == G.jokers and G.jokers.cards[1] then
        for i, v in ipairs(G.jokers.cards) do
            if v.ability.name == "Mouse" then
                if table.contains(v.ability.extra.debuff_position, i) then
                    v:set_debuff(true)
                else
                    v:set_debuff(false)
                end
            end
        end
    end
end

alice_dt = 0
local upd = Game.update
function Game:update(dt)
	upd(self, dt)

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

	if G.GAME and G.GAME.saga_event then
        if G.GAME.saga_event.alice_in_wonderland then
            if next(SMODS.find_card("j_sgt_kid_gloves_and_fan"))
            and not G.GAME.saga_event_check.alice_in_wonderland.cry_into_flood then
                G.GAME.saga_event.alice_in_wonderland.cry_into_flood = true
            else
                G.GAME.saga_event.alice_in_wonderland.cry_into_flood = false
            end
            if next(SMODS.find_card("j_sgt_dodo_bird")) and next(SMODS.find_card("j_sgt_white_rabbit"))
            and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house then
                G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = true
            else
                G.GAME.saga_event.alice_in_wonderland.white_rabbit_house = false
            end
        end
    end
end

local gcp = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, check = G.ARGS.TEMP_POOL, nil, '', false

    _rarity = (_legendary and 4) or (type(_rarity) == "number" and ((_rarity > 0.95 and 3) or (_rarity > 0.7 and 2) or 1)) or _rarity
    _rarity = ({Common = 1, Uncommon = 2, Rare = 3, Legendary = 4})[_rarity] or _rarity
    local rarity = _rarity or SMODS.poll_rarity("Joker", 'rarity'..G.GAME.round_resets.ante..(_append or ''))

    _starting_pool, _pool_key = G.P_CENTER_POOLS[_type], 'Joker'..rarity..((not _legendary and _append) or '')
    for _, group in pairs(SAGA_GROUP_POOL) do
        if _type == group then
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
        end
    end
    if check then return _pool, _pool_key..(not _legendary and G.GAME.round_resets.ante or '') end
    return gcp(_type, _rarity, _legendary, _append)
end

local cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
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

function Sagatro.reset_game_globals(run_start)
    for _, v in ipairs(G.jokers.cards) do
        if v.ability.name == "Mouse" then
            for i = #v.ability.extra.debuff_position, 1, -1 do
                table.remove(v.ability.extra.debuff_position, i)
            end
        end
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

function sgt_center_no(center, m, key, no_no)
	if no_no then
		return center[m] or (G.GAME and G.GAME[m] and G.GAME[m][key]) or false
	end
	return center_no(center, "no_" .. m, key, true)
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
			for k, v in pairs(excluded_flags) do
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
				return selection
			end
		end
	end
end

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

Sagatro.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 4}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
			create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', info = localize('SGT_disable_other_jokers_desc'), active_colour = Sagatro.badge_colour, right = true}),
		}},
    }}
end

