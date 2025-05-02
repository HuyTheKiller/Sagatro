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
        },
    }
    -- Event checks to make sure each event only happens once per run
    ret.saga_event_check = {
        alice_in_wonderland = {
            cry_into_flood = false,
            white_rabbit_house = false,
            little_bill = false,
            huge_dog = false,
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
                { name = "colour_1", ref_table = G.C.RARITY, ref_value = 4 },
                { name = "colour_2", ref_table = G.C, ref_value = "DARK_EDITION" },
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

Sagatro.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 4}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
			create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', info = localize('SGT_disable_other_jokers_desc'), active_colour = G.C.RARITY[4], right = true}),
		}},
    }}
end

