-- Global colours
G.C.SGT_TRIVIAL = HEX("808080")
G.C.SGT_OBSCURE = HEX("8627D4")
G.C.SGT_ESOTERIC = HEX("131868")
G.C.SGT_WISH = HEX("9bbcfd")
G.C.SGT_DIVINATIO = HEX("3bc9cf")
G.C.SGT_CELESTARA = HEX("717beb")
G.C.SGT_ELDRITCH = HEX("3f0c57")
G.C.SGT_SUPPLY = HEX("485267")
G.C.SGT_BADGE = HEX("6131ac")
G.C.GOLDIA_PINK = HEX("b4417b")
G.C.SUBMARINE_DEPTH = {
    HEX("3a86e1"),
    HEX("265792"),
    HEX("122d4c"),
    HEX("091829"),
    HEX("060f1a"),
}
G.C.SAGA_DIFFICULTY = {
    G.C.GREEN,
    G.C.GREEN,
    G.C.YELLOW,
    G.C.YELLOW,
    G.C.RED,
}
SMODS.Gradient{
    key = "sagadition",
    colours = {Sagatro.badge_colour, G.C.RARITY[4]},
    cycle = 2,
} -- Skull, not putting inside assets.lua for preventive measures
G.C.SGT_SAGADITION = SMODS.Gradients["sgt_sagadition"]
SMODS.Gradient{
    key = "sagattention",
    colours = {G.C.SUBMARINE_DEPTH[1], G.C.GREEN},
    cycle = 1,
}
G.C.SGT_SAGATTENTION = SMODS.Gradients["sgt_sagattention"]
SMODS.Gradient{
    key = "goldiattention",
    colours = {HEX("b4417b"), HEX("631e41")},
    cycle = 1,
}
G.C.SGT_GOLDIATTENTION = SMODS.Gradients["sgt_goldiattention"]
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
    for k, v in pairs(SMODS.Blinds) do
        if v.mod and v.mod.id == "Sagatro" then
            G.ARGS.LOC_COLOURS[k] = v.boss_colour
        end
    end
    G.ARGS.LOC_COLOURS.huycorn = G.C.SGT_DIVINATIO
    G.ARGS.LOC_COLOURS.huythekiller = G.C.GREEN
    G.ARGS.LOC_COLOURS.amy = G.C.YELLOW
    G.ARGS.LOC_COLOURS.temp = G.C.UI.BACKGROUND_WHITE
    G.ARGS.LOC_COLOURS.dj = G.C.BLUE
    return lc(_c, _default)
end

local badge_ref = get_badge_colour
function get_badge_colour(key)
    local ret = badge_ref(key)
    G.BADGE_COL.delayed_selling = G.C.RENTAL
    ret = G.BADGE_COL[key] or {1, 0, 0, 1}
    return ret
end

-- Talisman compat
to_big = to_big or function(x)
    return x
end

to_number = to_number or function(x)
	return x
end

Sagatro.story_mode_showdown = {
	"bl_sgt_red_queen",
    "bl_sgt_nyx_abyss",
    "bl_sgt_red_king",
}

Sagatro.story_mode_no_reroll = {
    "bl_sgt_red_queen",
    "bl_sgt_turquoise_jellyfish",
    "bl_sgt_aqua_eyeshard",
    "bl_sgt_black_oil",
    "bl_sgt_shadow_seamine",
    "bl_sgt_nyx_abyss",
    "bl_sgt_pawn",
    "bl_sgt_rook",
    "bl_sgt_knight",
    "bl_sgt_bishop",
    "bl_sgt_true_red_queen",
    "bl_sgt_red_king",
}

Sagatro.main_storyline_list = {
    "alice_in_wonderland",
    "20k_miles_under_the_sea",
    "alice_in_mirrorworld",
    "pocket_mirror",
}

Sagatro.storyline_locmap = {
    ["alice_in_wonderland"] = "ph_alice_in_wond",
    ["20k_miles_under_the_sea"] = "ph_20k",
    ["alice_in_mirrorworld"] = "ph_alice_in_mirr",
    ["pocket_mirror"] = "ph_pmirror",
    ["none"] = "saga_storyline_start",
}

Sagatro.forced_buffoon_events = {
    "white_rabbit_house",
    "goodbye_frog",
    "the_party",
    "red_queen",
    "gryphon",
    "finding_the_submarine",
    "the_sub_engineer",
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
    -- Add played_this_ante field to poker hands, only when necessary
    if Sagatro.played_this_ante_compat() then
        for _, v in pairs(ret.hands) do
            v.played_this_ante = 0
        end
    end
    -- Current storyline
    ret.current_storyline = "none"
    -- Event queue
    ret.saga_event_queue = {}
    -- Finished events
    ret.saga_finished_events = {}
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
        alice_in_mirrorworld = {
            mirrorworld = {
                "j_sgt_white_pawn",
                "j_sgt_white_rook",
                "j_sgt_white_knight",
                "j_sgt_white_bishop",
                "j_sgt_white_queen",
                "j_sgt_white_king",
                "j_sgt_live_flowers",
                "j_sgt_ticket_checker",
                "j_sgt_man_in_white",
                "j_sgt_goat",
                "j_sgt_beetle",
                "j_sgt_dinah",
                "j_sgt_tweedledum",
                "j_sgt_tweedledee",
                "j_sgt_sheep",
                "j_sgt_rocking_horse_fly",
                "j_sgt_bread_and_butter_fly",
                "j_sgt_snap_dragon_fly",
                "j_sgt_jabberwock",
                "j_sgt_bandersnatch",
                "j_sgt_jubjub_bird",
                "j_sgt_humpty_dumpty",
                "j_sgt_seal_and_carpenter",
                "j_sgt_lion",
                "j_sgt_unicorn",
                "j_sgt_true_red_queen",
                "j_sgt_red_king",
                "j_sgt_vorpal_sword",
                "j_sgt_ecila",
            },
        },
        pocket_mirror = {
            pm_mirrorworld = {
                "j_sgt_eat_me",
            },
        },
    }
    ret.fish_effect = {}
    ret.current_round.dinah_card = {suit = "Spades", rank = "Ace"}
    ret.current_round.humdum_card = {rank = "Ace"}
    ret.ante_cooldown = 0
    ret.alice_multiplier = 1
    ret.relief_factor = 1
    ret.orbis_fatum_odds = 4
    ret.switch_bonus = 0
    ret.celestara_tooltip = true
    ret.current_round.reroll_count = 0
	return ret
end

-- Pretty much stolen from Cryptid lmao
local gmm = Game.main_menu
function Game:main_menu(change_context)
    gmm(self, change_context)
    for _, v in ipairs(G.title_top.cards) do
        if v.config.card_key and Sagatro.mod_compat.talisman then
            v:set_seal("sgt_gods_miracle", true, true)
        end
    end
    Sagatro.delayed_func()

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
    if G.title_top.T.w < 2.1 then
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

    if newcard and (math.random() < 0.1 or Sagatro.debug) then
        local card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 4.04,
            func = (function()
                card = Card(G.title_top.T.x, G.title_top.T.y, G.CARD_W*1.1*1.2, G.CARD_H*1.1*1.2, G.P_CARDS.empty, G.P_CENTERS.j_sgt_ecila, { bypass_discovery_center = true })
                card.no_ui = true
                card.states.visible = false
                card.sticker_run = "NONE" 
                card.sagatro_target = true
                newcard.parent = nil
                newcard:start_dissolve({G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD})
                return true
        end)}))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.04,
            func = (function()
                card:start_materialize()
                G.title_top:emplace(card)
                return true
        end)}))
    end
    if not G.PROFILES[G.SETTINGS.profile].sgt_welcome or Sagatro.debug then
        G.PROFILES[G.SETTINGS.profile].sgt_welcome = true
        G.FUNCS.overlay_menu{
            definition = create_UIBox_Sagatro_welcome(),
        }
    end
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
                or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
                or (G.TAROT_INTERRUPT
                and G.TAROT_INTERRUPT ~= G.STATES.BLIND_SELECT
                and G.TAROT_INTERRUPT ~= G.STATES.SELECTING_HAND
                and G.TAROT_INTERRUPT ~= G.STATES.ROUND_EVAL) then
                    SMODS.debuff_card(v, false, "j_sgt_pufferfish")
                end
            end
            if v.config.center_key == "j_sgt_pufferfish"
            and G.STATE ~= G.STATES.SHOP
            and G.STATE ~= G.STATES.SMODS_REDEEM_VOUCHER
            and G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED
            and (not G.TAROT_INTERRUPT
            or G.TAROT_INTERRUPT == G.STATES.BLIND_SELECT
            or G.TAROT_INTERRUPT == G.STATES.SELECTING_HAND
            or G.TAROT_INTERRUPT == G.STATES.ROUND_EVAL) then
                if G.jokers.cards[i-1] and G.jokers.cards[i-1].config.center_key ~= "j_sgt_pufferfish"
                and G.jokers.cards[i-1].config.center_key ~= "j_sgt_dolphin" then
                    SMODS.debuff_card(G.jokers.cards[i-1], true, "j_sgt_pufferfish")
                end
                if G.jokers.cards[i+1] and G.jokers.cards[i+1].config.center_key ~= "j_sgt_pufferfish"
                and G.jokers.cards[i+1].config.center_key ~= "j_sgt_dolphin" then
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
                if G.GAME.modifiers.sgt_joker_selling_rounds then
                    v.ability.sgt_selling_tally = 4
                end
            end
        end
    end
    if self == G.jokers and #G.jokers.highlighted == 0 and G.GAME.story_mode then
        local check = false
        for _, v in ipairs(G.jokers.cards) do
            if v.states.hover.is or v.states.drag.is then
                check = true
                break
            end
        end
        if not check then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                G.jokers.cards[i]:remove_sticker("sgt_edible")
            end
        end
    end
end

local parse_highlighted_ref = CardArea.parse_highlighted
function CardArea:parse_highlighted()
    parse_highlighted_ref(self)
    G.fleta_throw_hand = nil
    local text,disp_text,poker_hands = G.FUNCS.get_poker_hand_info(self.highlighted)
    if text ~= "NULL" then
        local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
        if fleta and Sagatro.storyline_check("pocket_mirror") then
            if fleta.ability.immutable.hands[text] then
                G.fleta_throw_hand = true
            end
        end
    end
end

function CardArea:temp_load(cardAreaTable, joker_size)

    if self.cards then remove_all(self.cards) end
    self.cards = {}
    if self.children then remove_all(self.children) end
    self.children = {}

    self.config = setmetatable(cardAreaTable.config, {
        __index = function(t, key)
            if key == "card_limit" then
                return (t.card_limits.total_slots or 0) - (t.card_limits.extra_slots_used or 0)
            end
        end,
        __newindex = function(t, key, value)
            if key == 'card_limit' then
                if not t.card_limits.base then rawset(t.card_limits, 'base', value) end
                rawset(t.card_limits, 'mod', value - t.card_limits.base - (t.card_limits.extra_slots or 0))
            else
                rawset(t, key, value)
            end
        end
    })


    for i = 1, #cardAreaTable.cards do
        local card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CENTERS.j_joker, G.P_CENTERS.c_base)
        card:load(cardAreaTable.cards[i])
        card.T.h = card.T.h*joker_size
        card.T.w = card.T.w*joker_size
        card:set_sprites(card.config.center)
        card.displaying_save = true
        self.cards[#self.cards + 1] = card
        if card.highlighted then
            self.highlighted[#self.highlighted + 1] = card
        end
        card:set_card_area(self)
    end
    self:set_ranks()
    self:align_cards()
    self:hard_set_cards()
end

-- Handle edible state of target fish - courtesy of stickers
-- Also handle fusion buttons
local card_update_ref = Card.update
function Card:update(dt)
    card_update_ref(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self:get_saga_fusion() ~= nil then
            self.ability.saga_fusion = self.ability.saga_fusion or {}
            local my_fusion = self:get_saga_fusion()
            self.saga_fusion_cost = my_fusion and my_fusion.cost or 0
            if self:can_fuse_saga() and not self.ability.saga_fusion.jiggle then
                juice_card_until(self, function(card) return (card:can_fuse_saga()) end, true)

                self.ability.saga_fusion.jiggle = true
            end
            if not self:can_fuse_saga() and self.ability.saga_fusion.jiggle then
                self.ability.saga_fusion.jiggle = false
            end
        end
		if self.ability.gravistone_triggered and not SMODS.has_enhancement(self, "m_sgt_gravistone") then
			self.ability.gravistone_triggered = nil
			SMODS.change_play_limit(-1)
            SMODS.change_discard_limit(-1)
		end
        if self.states.hover.is or self.states.drag.is then
            if self.area == G.jokers and G.GAME.story_mode then
                if not self.debuff then
                    if self.ability.immutable and self.ability.immutable.weight_level then
                        if self.ability.immutable.eaten_weight then
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                        end
                        if self.ability.immutable.target_offset
                        and type(self.ability.immutable.target_offset) == "number" then
                            local target
                            for i, v in ipairs(G.jokers.cards) do
                                if v == self then
                                    target = G.jokers.cards[i+self.ability.immutable.target_offset]
                                    break
                                end
                            end
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            if target then
                                Sagatro.process_edible_state(self, target)
                            end
                        elseif self.ability.immutable.target == "leftmost" then
                            local target = G.jokers.cards[1]
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            if target ~= self then
                                Sagatro.process_edible_state(self, target)
                            end
                        elseif self.ability.immutable.target == "rightmost" then
                            local target = G.jokers.cards[#G.jokers.cards]
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            if target ~= self then
                                Sagatro.process_edible_state(self, target)
                            end
                        elseif self.ability.immutable.target_range == "leftward" then
                            local targets, pos = {}, 1
                            for i, v in ipairs(G.jokers.cards) do
                                if v == self then
                                    pos = i
                                    break
                                end
                            end
                            for i = pos-1, 1, -1 do
                                if not (SMODS.is_eternal(G.jokers.cards[i], card)
                                and self.ability.immutable.eternal_block) then
                                    targets[#targets+1] = G.jokers.cards[i]
                                else break end
                            end
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            for _, target in ipairs(targets) do
                                Sagatro.process_edible_state(self, target)
                            end
                        elseif self.ability.immutable.target_range == "rightward" then
                            local targets, pos = {}, 1
                            for i, v in ipairs(G.jokers.cards) do
                                if v == self then
                                    pos = i
                                    break
                                end
                            end
                            for i = pos+1, #G.jokers.cards do
                                if not (SMODS.is_eternal(G.jokers.cards[i], card)
                                and self.ability.immutable.eternal_block) then
                                    targets[#targets+1] = G.jokers.cards[i]
                                else break end
                            end
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            for _, target in ipairs(targets) do
                                Sagatro.process_edible_state(self, target)
                            end
                        elseif type(self.ability.immutable.target_range) == "table" then
                            local targets, pos = {}, 1
                            for i, v in ipairs(G.jokers.cards) do
                                if v == self then
                                    pos = i
                                    break
                                end
                            end
                            if pos then
                                local i_start, i_end = self.ability.immutable.target_range[1], self.ability.immutable.target_range[2]
                                for i = i_start, i_end do
                                    if i ~= 0 and G.jokers.cards[pos+i] then
                                        targets[#targets+1] = G.jokers.cards[pos+i]
                                    end
                                end
                            end
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                            for _, target in ipairs(targets) do
                                Sagatro.process_edible_state(self, target)
                            end
                        else
                            for i = 1, #G.jokers.cards do
                                G.jokers.cards[i]:remove_sticker("sgt_not_food")
                                G.jokers.cards[i]:remove_sticker("sgt_inedible")
                                G.jokers.cards[i]:remove_sticker("sgt_edible")
                            end
                        end
                    else
                        for i = 1, #G.jokers.cards do
                            G.jokers.cards[i]:remove_sticker("sgt_not_food")
                            G.jokers.cards[i]:remove_sticker("sgt_inedible")
                            G.jokers.cards[i]:remove_sticker("sgt_edible")
                        end
                    end
                end
            end
        end
        if (self.area == G.jokers or self.area == G.shop_jokers or self.area == G.pack_cards) and G.GAME.story_mode and not self.debuff then
            if self.ability.immutable and self.ability.immutable.weight_level then
                local i_start, i_end, is_within_range = self.ability.immutable.depth_range[1], self.ability.immutable.depth_range[2], false
                for i = i_start, i_end do
                    if i == Sagatro.get_submarine_depth_colour() then
                        is_within_range = true
                        break
                    end
                end
                if is_within_range then
                    self:remove_sticker("sgt_off_depth")
                elseif not self.ability.sgt_off_depth then
                    self:add_sticker("sgt_off_depth", true)
                    if self.area == G.jokers then
                        local eval = function(card) return not card.states.hover.is end
                        juice_card_until(self, eval, true)
                    end
                end
                if not self.ability.sgt_current_depth then
                    self:add_sticker("sgt_current_depth", true)
                end
            end
        end
        if self.ability.inactive == false then self.ability.inactive = nil end
    end
end

-- Pseudo-animation and manual crash
Sagatro.cause_crash = false
Sagatro.pseudo_animation = {
    nemo_dt = 0,
    alice_dt = 0,
    ecila_dt = 0,
    cosmic_dt = 0,
    miracle_dt = 0,
    miracle_animate = false,
    nameless_dt = 0,
    submarine_dt = 0,
    current_depth_dt = 0,
}
Sagatro.timer = {
    lisette_dt = 8,
}
local upd = Game.update
function Game:update(dt)
	upd(self, dt)
    if not Sagatro.STATE then
        Sagatro.STATE = G.STATE
        Sagatro.debug_info["Game state"] = "MENU"
    end
    if Sagatro.STATE ~= G.STATE then
        Sagatro.STATE = G.STATE
        for k, v in pairs(G.STATES) do
            if Sagatro.STATE == v then
                Sagatro.debug_info["Game state"] = k
                if Sagatro.debug then
                    print(k)
                end
                break
            end
        end
    end
    if G.OVERLAY_MENU then
        local back_button = G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button")
        if back_button then
            back_button.config.fromAlice = Sagatro.fromAlice
        end
    end
    if not G.SETTINGS.paused then
        Sagatro.allow_save = nil
        if Sagatro.temp_areas.jokers then
            Sagatro.remove_temp_areas()
        end
    end
    if G.STAGE == G.STAGES.RUN then
        Sagatro.debug_info["During a run"] = true
        Sagatro.debug_info["Story mode"] = G.GAME.story_mode
        if not next(SMODS.find_card("j_sgt_submarine", true)) then
            G.P_CENTERS.j_sgt_seawater.pos.x = 0
        end
        if Sagatro.event_check("lisette_chase") and G.STATE ~= G.STATES.ROUND_EVAL then
            Sagatro.timer.lisette_dt = Sagatro.timer.lisette_dt + dt
            if Sagatro.timer.lisette_dt > (5/6)*8 then
                Sagatro.timer.lisette_dt = Sagatro.timer.lisette_dt - (5/6)*8
                SMODS.add_card{key = "j_sgt_lisette"}
            end
        else
            Sagatro.timer.lisette_dt = (5/6)*8
        end
        if G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SHOP then
            -- Handle opening Mega Buffoon Pack spawned by Utima Vox (restricted to during shop and blind select)
            if G.GAME.pending_mega_buffoon then
                local paused_for_tags = false
                for i = 1, #G.GAME.tags do
                    if G.GAME.tags[i].config.type == "new_blind_choice" then
                        paused_for_tags = true
                        break
                    end
                end
                if not paused_for_tags then
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
        end
        if G.STATE == G.STATES.SELECTING_HAND then
            if G.fleta_throw_hand then
                if not G.fleta_warning_text then
                    G.fleta_warning_text = UIBox{
                        definition =
                        {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
                            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                                {n=G.UIT.O, config={object = DynaText({scale = 0.7, string = localize('ph_losing_hand'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
                            }},
                            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                                {n=G.UIT.O, config={object = DynaText({scale = 0.6, string = localize("ph_fleta_musical_chair"), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
                            }}
                        }},
                        config = {
                            align = 'cm',
                            offset ={x=0,y=-1.7},
                            major = G.play,
                        }
                    }
                    G.fleta_warning_text.attention_text = true
                    G.fleta_warning_text.states.collide.can = false
                    local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
                    if fleta then
                        fleta:juice_up(0.05, 0.1)
                    end
                    play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                end
            else
                G.fleta_throw_hand = nil
                if G.fleta_warning_text then
                    G.fleta_warning_text:remove()
                    G.fleta_warning_text = nil
                end
            end
        end
        -- Adam's ability to enable perishable in shop (take Orange Stake effect into account)
        if not (Ortalab or G.GAME.perishable_already_active) then
            G.GAME.modifiers.enable_perishables_in_shop = next(Sagatro.find_active_card("j_sgt_adam")) and true or nil
        end
        -- Jubjub Bird's ability to remove boss reward (take challenge modifier effect into account)
        if not G.GAME.no_boss_reward_already_active then
            G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
            local prev = G.GAME.modifiers.no_blind_reward.Boss
            G.GAME.modifiers.no_blind_reward.Boss = next(Sagatro.find_active_card("j_sgt_jubjub_bird")) and true or nil
            if prev ~= G.GAME.modifiers.no_blind_reward.Boss then
                prev = G.GAME.modifiers.no_blind_reward.Boss
                Sagatro.update_blind_amounts(true)
            end
        end
    elseif G.STAGE == G.STAGES.MAIN_MENU then
        Sagatro.debug_info["During a run"] = nil
        Sagatro.debug_info["Story mode"] = nil
        G.P_CENTERS.j_sgt_seawater.pos.x = 0
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
                                v.ability.anim_transition_path = v.ability.immutable.old_depth_level - v.ability.immutable.depth_level
                            else
                                v.ability.anim_pos.x = v.ability.anim_pos.x + 1
                            end
                            local pending_up = 0
                            if v.ability.anim_transition_path ~= 0 then
                                if v.ability.anim_transition_path > 0 and not v.ability.in_transition then
                                    pending_up = 1
                                end
                            end
                            v.ability.anim_pos.y = (math.min(v.ability.immutable.old_depth_level, v.ability.immutable.depth_level) - 1 + pending_up)
                            + (v.ability.in_transition and 5 or 0)
                            v.children.center:set_sprite_pos(v.ability.anim_pos)
                        end
                    elseif v.config.center_key == "j_sgt_goldia" and v.config.center.discovered then
                        v.ability.hide_name_tag = v.ability.immutable.stage ~= "name_recalled" and v.ability.immutable.stage ~= "dawn"
                        and (G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers))
                    end
                end
            end
        end
    end

    Sagatro.pseudo_animation.nameless_dt = Sagatro.pseudo_animation.nameless_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_nameless and Sagatro.pseudo_animation.nameless_dt > 0.125 then
        Sagatro.pseudo_animation.nameless_dt = Sagatro.pseudo_animation.nameless_dt - 0.125
        local nameless = G.P_CENTERS.j_sgt_nameless
        if nameless.pos.x == 11 then
            nameless.pos.x = 0
            nameless.soul_pos.x = 0
            nameless.soul_pos.sgt_extra.x = 0
        else
            nameless.pos.x = nameless.pos.x + 1
            nameless.soul_pos.x = nameless.soul_pos.x + 1
            nameless.soul_pos.sgt_extra.x = nameless.soul_pos.sgt_extra.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == nameless then
                card.children.floating_sprite:set_sprite_pos(nameless.soul_pos)
                card.children.floating_mid_sprite:set_sprite_pos(nameless.soul_pos.sgt_extra)
            end
        end
    end

    Sagatro.pseudo_animation.submarine_dt = Sagatro.pseudo_animation.submarine_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_submarine and Sagatro.pseudo_animation.submarine_dt > 0.125 then
        Sagatro.pseudo_animation.submarine_dt = Sagatro.pseudo_animation.submarine_dt - 0.125
        local submarine = G.P_CENTERS.j_sgt_submarine
        if submarine.extra_pos.x == 8 then
            submarine.extra_pos.x = 0
        else
            submarine.extra_pos.x = submarine.extra_pos.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == submarine then
                card.children.sgt_extra_sprite:set_sprite_pos(submarine.extra_pos)
            end
        end
    end

    Sagatro.pseudo_animation.nemo_dt = Sagatro.pseudo_animation.nemo_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_nemo and Sagatro.pseudo_animation.nemo_dt > 0.125 then
        Sagatro.pseudo_animation.nemo_dt = Sagatro.pseudo_animation.nemo_dt - 0.125
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

    Sagatro.pseudo_animation.alice_dt = Sagatro.pseudo_animation.alice_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_alice and Sagatro.pseudo_animation.alice_dt > 0.125 then
        Sagatro.pseudo_animation.alice_dt = Sagatro.pseudo_animation.alice_dt - 0.125
        local alice = G.P_CENTERS.j_sgt_alice
        if alice.soul_pos.x == 35 then
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

    Sagatro.pseudo_animation.ecila_dt = Sagatro.pseudo_animation.ecila_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_sgt_ecila and Sagatro.pseudo_animation.ecila_dt > 0.125 then
        Sagatro.pseudo_animation.ecila_dt = Sagatro.pseudo_animation.ecila_dt - 0.125
        local ecila = G.P_CENTERS.j_sgt_ecila
        if ecila.soul_pos.x == 39 then
            ecila.soul_pos.x = 1
        else
            ecila.soul_pos.x = ecila.soul_pos.x + 1
        end
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == ecila then
                card.children.floating_sprite:set_sprite_pos(ecila.soul_pos)
            end
        end
    end

    Sagatro.pseudo_animation.cosmic_dt = Sagatro.pseudo_animation.cosmic_dt + dt
    if G.shared_seals and G.shared_seals.sgt_cosmic_streak and Sagatro.pseudo_animation.cosmic_dt > 0.125 then
        Sagatro.pseudo_animation.cosmic_dt = Sagatro.pseudo_animation.cosmic_dt - 0.125
        local cosmic = G.shared_seals.sgt_cosmic_streak
        if cosmic.sprite_pos.x == 14 then
            cosmic.sprite_pos.x = 0
        else
            cosmic.sprite_pos.x = cosmic.sprite_pos.x + 1
        end
        cosmic:set_sprite_pos(cosmic.sprite_pos)
    end

    Sagatro.pseudo_animation.miracle_dt = Sagatro.pseudo_animation.miracle_dt + dt
    if G.shared_seals and G.shared_seals.sgt_gods_miracle and Sagatro.pseudo_animation.miracle_dt > 0.125 then
        Sagatro.pseudo_animation.miracle_dt = Sagatro.pseudo_animation.miracle_dt - 0.125
        local miracle = G.shared_seals.sgt_gods_miracle
        if miracle.sprite_pos.x == 19 then
            miracle.sprite_pos.x = 0
        else
            miracle.sprite_pos.x = miracle.sprite_pos.x + 1
        end
        miracle:set_sprite_pos(miracle.sprite_pos)
        for _, card in pairs(G.I.CARD) do
            if card and card.seal and card.seal == "sgt_gods_miracle"
            and card.sprite_facing == "front" then
                Sagatro.pseudo_animation.miracle_animate = true
                break
            end
        end
        -- if Sagatro.pseudo_animation.miracle_animate then
        --     if miracle.sprite_pos.x == 101 then
        --         miracle.sprite_pos.x = 87
        --     else
        --         miracle.sprite_pos.x = miracle.sprite_pos.x + 1
        --     end
        --     miracle:set_sprite_pos(miracle.sprite_pos)
        --     Sagatro.pseudo_animation.miracle_animate = false
        -- else
        --     miracle.sprite_pos.x = 0
        -- end
    end

    Sagatro.pseudo_animation.current_depth_dt = Sagatro.pseudo_animation.current_depth_dt + dt
    if G.shared_stickers and G.shared_stickers.sgt_current_depth and Sagatro.pseudo_animation.current_depth_dt > 0.125 then
        Sagatro.pseudo_animation.current_depth_dt = Sagatro.pseudo_animation.current_depth_dt - 0.125
        local current_depth = G.shared_stickers.sgt_current_depth
        if current_depth.sprite_pos.x == 7 then
            current_depth.sprite_pos.x = 0
        else
            current_depth.sprite_pos.x = current_depth.sprite_pos.x + 1
        end
        current_depth.sprite_pos.y = Sagatro.get_submarine_depth_colour() - 1
        current_depth:set_sprite_pos(current_depth.sprite_pos)
    end

    if Sagatro.cause_crash then error("A manual crash is called. Don't be grumpy, you did this on purpose.", 0) end
end

-- Esoteric jokers are Exotic equivalents in this mod
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
	set_spritesref(self, _center, _front)
    if _center and _center.name == "Submarine" then
		self.children.sgt_extra_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			_center.extra_pos
		)
		self.children.sgt_extra_sprite.role.draw_major = self
		self.children.sgt_extra_sprite.states.hover.can = false
		self.children.sgt_extra_sprite.states.click.can = false
        self.children.sgt_extra_sprite.custom_draw = true
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
		self.children.floating_mid_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 1, y = 1 }
		)
		self.children.floating_mid_sprite.role.draw_major = self
		self.children.floating_mid_sprite.states.hover.can = false
		self.children.floating_mid_sprite.states.click.can = false
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
    if _center and _center.name == "Soltera" then
		self.children.floating_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			{ x = 3, y = 7 }
		)
		self.children.floating_sprite.role.draw_major = self
		self.children.floating_sprite.states.hover.can = false
		self.children.floating_sprite.states.click.can = false
	end
	if _center and _center.soul_pos and _center.soul_pos.sgt_extra then
		self.children.floating_mid_sprite = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			_center.soul_pos.sgt_extra
		)
		self.children.floating_mid_sprite.role.draw_major = self
		self.children.floating_mid_sprite.states.hover.can = false
		self.children.floating_mid_sprite.states.click.can = false
	end
    if _center and _center.soul_pos and _center.soul_pos.name_tag then
		self.children.floating_name_tag = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[_center.atlas or _center.set],
			_center.soul_pos.name_tag
		)
		self.children.floating_name_tag.role.draw_major = self
		self.children.floating_name_tag.states.hover.can = false
		self.children.floating_name_tag.states.click.can = false
	end
end

local can_calc_ref = Card.can_calculate
function Card:can_calculate(ignore_debuff, ignore_sliced)
    local is_available = can_calc_ref(self, ignore_debuff, ignore_sliced)
    is_available = is_available and not self.ability.inactive
    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == "bl_sgt_knight" and not G.GAME.blind.disabled then
            if self.ability.set == "Default" or self.ability.set == "Enhanced" then
                if self.area == G.play then
                    is_available = is_available and (Sagatro.get_pos(self) == 1 or Sagatro.get_pos(self) == #G.play.cards)
                end
            end
        end
    end
    return is_available
end

local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    add_to_deck_ref(self, from_debuff)
    if not from_debuff and self.ability.set == "Joker"
    and G.GAME.modifiers.sgt_joker_selling_rounds then
        self.ability.sgt_selling_tally = self.ability.sgt_selling_tally or 0
    end
end

local can_sell_ref = Card.can_sell_card
function Card:can_sell_card(context)
    local can_sell = can_sell_ref(self, context)
    if self.ability.set == "Joker" and self.ability.sgt_selling_tally
    and G.GAME.modifiers.sgt_joker_selling_rounds then
        can_sell = can_sell and self.ability.sgt_selling_tally >= G.GAME.modifiers.sgt_joker_selling_rounds
    end
    return can_sell
end

local calc_rental = Card.calculate_rental
function Card:calculate_rental()
    calc_rental(self)
    if self.ability.rental then
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - G.GAME.rental_rate
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.dollar_buffer = 0
        return true end}))
    end
end

local can_use_consumeable_ref = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    if (Sagatro.event_check("mirror_maze") or Sagatro.event_check("lisette_chase"))
    and (self.ability.consumeable.mod_conv or self.ability.consumeable.suit_conv) then
        return false
    end
    return can_use_consumeable_ref(self, any_state, skip_check)
end

-- Gravistone jank
local copy_cardref = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition)
    if new_card and SMODS.has_enhancement(new_card, "m_sgt_gravistone") then
        return copy_cardref(other, new_card, card_scale, playing_card, strip_edition)
    end
    local card = copy_cardref(other, new_card, card_scale, playing_card, strip_edition)
    if SMODS.has_enhancement(card, "m_sgt_gravistone") then
        card.ability.gravistone_triggered = nil
    end
    return card
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

                if not (G.GAME.used_jokers[v.key] and not pool_opts.allow_duplicates and not SMODS.showman(v.key)) and
                (v.unlocked ~= false) then add = true end

                if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = nil end
                if v.yes_pool_flag and not G.GAME.pool_flags[v.yes_pool_flag] then add = nil end

                if add and not G.GAME.banned_keys[v.key] then
                    _pool[#_pool + 1] = v.key
                end
            end

            if Sagatro.debug then print("From custom pool: ".._type) end
            if #_pool == 0 then
                _pool[#_pool + 1] = "j_sgt_abducted_cow"
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
    if next(Sagatro.find_active_card("j_sgt_yggdrasil")) and _type == "Joker" then
        if pseudorandom("yggdrasil") > 0.95 then
            _type = "Norse Gods"
        end
    end
    if Sagatro.event_check("final_showdown") and _type == "Joker" then
        _type = "Final Showdown"
        if pseudorandom("alice_in_final_showdown") > 0.997 then
            if not G.GAME.won and not next(SMODS.find_card("j_sgt_alice", true)) then
                forced_key = "j_sgt_alice"
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
    if next(Sagatro.find_active_card("j_sgt_darkness")) and _type == "Joker" then
        if pseudorandom("darkness_negative_joker") > 0.5 then
            card:set_edition("e_negative")
        end
    end
    return card
end

-- Black Oil disable retriggers
local insert_rep_ref = SMODS.insert_repetitions
function SMODS.insert_repetitions(ret, eval, effect_card, _type)
    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == "bl_sgt_black_oil" and not G.GAME.blind.disabled then
            return
        end
    end
    insert_rep_ref(ret, eval, effect_card, _type)
end

-- If you own certain jokers, removes them when their respective Showdown Blind variants appear
-- Also general blind handling in story mode
local gnb = get_new_boss
function get_new_boss(...)
    local ret = gnb(...)
    local overridden = false
    local sgt_arg = select(1, ...)
    if G.GAME.story_mode and not G.GAME.won and sgt_arg ~= "not_forced" then
        if Sagatro.event_check("final_showdown") and not next(SMODS.find_card("j_sgt_mad_hatter")) then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_red_queen'
            overridden = true
        elseif Sagatro.event_check("turquoise_jellyfish") then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_turquoise_jellyfish'
            overridden = true
        elseif Sagatro.event_check("aqua_eyeshard") then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_aqua_eyeshard'
            overridden = true
        elseif Sagatro.event_check("black_oil") then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_black_oil'
            overridden = true
        elseif Sagatro.event_check("shadow_seamine") then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_shadow_seamine'
            overridden = true
        elseif Sagatro.event_check("nyx_abyss") then
            G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
            ret = 'bl_sgt_nyx_abyss'
            overridden = true
        elseif G.GAME.inversed_scaling then
            if Sagatro.event_check("the_pawn", nil, true)
            and not Sagatro.event_check("the_pawn", false) then
                G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                ret = 'bl_sgt_pawn'
                overridden = true
            elseif Sagatro.event_check("the_rook", nil, true)
            and not Sagatro.event_check("the_rook", false) then
                G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                ret = 'bl_sgt_rook'
                overridden = true
            elseif Sagatro.event_check("the_knight", nil, true)
            and not Sagatro.event_check("the_knight", false) then
                G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                ret = 'bl_sgt_knight'
                overridden = true
            elseif Sagatro.event_check("the_bishop", nil, true)
            and not Sagatro.event_check("the_bishop", false) then
                G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                ret = 'bl_sgt_bishop'
                overridden = true
            elseif G.GAME.mirrorworld_showdown then
                if Sagatro.event_check("true_red_queen", nil, true)
                and not Sagatro.event_check("true_red_queen", false) then
                    G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                    ret = 'bl_sgt_true_red_queen'
                    overridden = true
                elseif Sagatro.event_check("red_king", nil, true)
                and not Sagatro.event_check("red_king", false) then
                    G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] - 1
                    ret = 'bl_sgt_red_king'
                    overridden = true
                end
            end
        end
    end
    if ret == 'bl_sgt_red_queen' then
        G.GAME.red_queen_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_red_queen", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
        if Sagatro.storyline_check("alice_in_mirrorworld") then
            G.GAME.paused_showdown = true
        end
    elseif ret == 'bl_sgt_true_red_queen' then
        G.GAME.true_red_queen_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_true_red_queen", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
    elseif ret == 'bl_sgt_red_king' then
        G.GAME.red_king_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_red_king", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
    end
    if Cartomancer then
        G.GAME.cartomancer_bosses_list = G.GAME.cartomancer_bosses_list or {}
        if overridden then
            G.GAME.cartomancer_bosses_list[#G.GAME.cartomancer_bosses_list] = ret
        end
    end
    if overridden then
        G.GAME.saga_forced_boss = true
        G.GAME.bosses_used[ret] = G.GAME.bosses_used[ret] + 1
    end
    return ret
end

-- Disabling Queen Of Hearts via using Eat Me! won't cut the score down to 2X base
local disable_ref = Blind.disable
function Blind:disable(...)
    disable_ref(self)
    if self.config.blind.key == "bl_sgt_red_queen"
    and (select(1, ...)) and select(1, ...) == "do_not_cut_score" then
        self.chips = self.chips*3
		self.chip_text = number_format(self.chips)
    end
end

-- Track if Story mode Showdown Blind is defeated to enable endless-like experience before reaching win Ante
local dft = Blind.defeat
function Blind:defeat(silent)
    if G.GAME.story_mode then
        if self.config.blind.key and table.contains(Sagatro.story_mode_no_reroll, self.config.blind.key) then
            G.GAME.saga_forced_boss = nil
            G.GAME.mirror_ready = nil
        end
        if self.config.blind.key and table.contains(Sagatro.story_mode_showdown, self.config.blind.key) then
            G.GAME.story_ended = G.GAME.won
        end
        if G.GAME.entering_mirror_maze then
            G.GAME.entering_mirror_maze = nil
        end
        if G.GAME.leaving_mirror_maze then
            G.GAME.leaving_mirror_maze = nil
            G.GAME.sgt_no_saving = nil
            Sagatro.progress_storyline("lisette_chase", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
            for _, v in ipairs(G.playing_cards) do
                if v.ability.old_enh then
                    v:set_ability(v.ability.old_enh)
                    v.ability.old_enh = nil
                end
                if v.ability.old_edition then
                    v:set_edition(v.ability.old_edition, nil, true)
                    v.ability.old_edition = nil
                end
                if v.ability.old_seal then
                    v:set_seal(v.ability.old_seal, true)
                    v.ability.old_seal = nil
                end
            end
            for _, v in ipairs(SMODS.find_card("j_sgt_lisette", true)) do
                v:remove()
            end
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                goldia:remove_sticker("pinned")
            end
            SMODS.add_card{key = "j_sgt_harpae"}
        end
    end
	dft(self, silent)
end

-- Ah yes, Nameless' secret ability is to slowly flood your shop voucher with Antimatter
local avts = SMODS.add_voucher_to_shop
function SMODS.add_voucher_to_shop(key, dont_save)
    if next(Sagatro.find_active_card("j_sgt_nameless")) and pseudorandom("nameless_antimatter") < (G.GAME.antimatter_overload or 0.2) then
        key = "v_antimatter"
        G.GAME.antimatter_overload = (G.GAME.antimatter_overload or 0.2) + 0.1
        if G.GAME.antimatter_overload > 1 then
            G.GAME.antimatter_overload = 1
        end
    end
    local voucher = avts(key, dont_save)
    if G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.round_resets.ante == 1 then
        local vouchers = {}
        for k, _ in pairs(G.P_CENTERS) do
            if string.len(k) >= 5 and string.sub(k, 1, 5) == "v_sgt" then
                vouchers[#vouchers+1] = k
            end
        end
        if table.contains(vouchers, voucher.config.center_key) then
            voucher:set_ability("v_blank")
        end
    end
    return voucher
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
    if next(Sagatro.find_active_card('j_sgt_frog_prince')) or next(Sagatro.find_active_card('j_sgt_white_knight')) then
        return true
    end
    return shortcut()
end

local four_fingers = SMODS.four_fingers
function SMODS.four_fingers(hand_type)
    if G.hand and next(Sagatro.find_active_card('j_sgt_white_rook')) then
        for i = 1, #G.hand.cards do
            if SMODS.has_no_rank(G.hand.cards[i]) then
                return 4
            end
        end
    end
    return four_fingers(hand_type)
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

---@param table table
table.contains = table.contains or function(table, element)
    for _, v in pairs(table) do
		if v == element then
			return true
		end
	end
	return false
end

---@param t table
table.remove_duplicate = function(t, element)
    local times = 0
    for i, v in ipairs(t) do
		if v == element then
			times = times + 1
            if times > 1 then
                table.remove(t, i)
            end
		end
	end
end

---@param table table
---@return integer
table.size = table.size or function(table)
    local size = 0
    for _,_ in pairs(table) do
        size = size + 1
    end
    return size
end

---@param storyline_name string
---@param interwoven boolean|nil
---@param override boolean|nil
function Sagatro.init_storyline(storyline_name, interwoven, override)
    if not G.GAME.story_mode then return end
    if table.contains(Sagatro.main_storyline_list, storyline_name) then
        if interwoven then
            if not G.GAME.interwoven_storyline or override then
                G.GAME.interwoven_storyline = storyline_name
            end
        else
            if G.GAME.current_storyline == "none" or override then
                G.GAME.current_storyline = storyline_name
            end
        end
    end
end

---@param event_name string
---@param queue_mode "add"|"finish"|"force_add"|"force_finish"|"remove"
---@param storyline_name string
---@param interwoven string|nil
function Sagatro.progress_storyline(event_name, queue_mode, storyline_name, interwoven)
    if not G.GAME.story_mode then return end
    if storyline_name == G.GAME.current_storyline or storyline_name == interwoven then
        if queue_mode == "add" and not table.contains(G.GAME.saga_event_queue, event_name)
        and not table.contains(G.GAME.saga_finished_events, event_name) then
            table.insert(G.GAME.saga_event_queue, event_name)
        elseif queue_mode == "force_add" then
            table.insert(G.GAME.saga_event_queue, 1, event_name)
            if event_name == "game_over" and G.jokers.cards[1] then
                G.jokers.cards[1].ability.storyline_derailed = true
                G.jokers.cards[1]:add_sticker("sgt_imminent_doom", true)
                local eval = function(card) return not card.states.hover.is end
                juice_card_until(G.jokers.cards[1], eval, true)
            end
        elseif queue_mode == "finish" and G.GAME.saga_event_queue[1] == event_name then
            table.remove(G.GAME.saga_event_queue, 1)
            if not table.contains(G.GAME.saga_finished_events, event_name) then
                table.insert(G.GAME.saga_finished_events, event_name)
            end
        elseif queue_mode == "force_finish" or queue_mode == "remove" then
            local pos = 0
            for i, event in ipairs(G.GAME.saga_event_queue) do
                if event == event_name then
                    pos = i
                    break
                end
            end
            if pos > 0 then
                table.remove(G.GAME.saga_event_queue, pos)
            end
            if queue_mode == "force_finish"
            and not table.contains(G.GAME.saga_finished_events, event_name) then
                table.insert(G.GAME.saga_finished_events, event_name)
            end
        end
    end
end

---@param storyline_name string
function Sagatro.storyline_check(storyline_name)
    if not G.GAME.story_mode then return false end
    local table = {G.GAME.current_storyline, G.GAME.interwoven_storyline}
    for _, storyline in ipairs(table) do
        if storyline_name == storyline then return true end
    end
    return false
end

---@param event_table string|table string or table of strings
---@param flag boolean|nil if `true` or `nil` (left empty), check if first element in queue matches string
---if `false`, check if queue doesn't contain string
---@param only_finished boolean|{contain: boolean}|nil only check for finished events
function Sagatro.event_check(event_table, flag, only_finished)
    if not G.GAME.story_mode then return false end
    if flag == nil then flag = true end
    if type(event_table) == "string" then
        event_table = {event_table}
    end
    for _, event in ipairs(event_table) do
        local first_check, second_check = nil, not table.contains(G.GAME.saga_finished_events, event)
        if flag then
            first_check = G.GAME.saga_event_queue[1] == event
        else
            first_check = not table.contains(G.GAME.saga_event_queue, event)
        end
        if only_finished then
            first_check = true
            if type(only_finished) == "table" and only_finished.contain then
                second_check = table.contains(G.GAME.saga_finished_events, event)
            end
        end
        if first_check and second_check then
            return true
        end
    end
    return false
end

-- Force the first pack in shop to be buffoon in certain events
local gp = get_pack
function get_pack(_key, _type)
    if G.GAME.story_mode then
        if Sagatro.event_check(Sagatro.forced_buffoon_events, true)
        and not G.GAME.saga_event_forced_buffoon then
            G.GAME.saga_event_forced_buffoon = true
            G.GAME.juice_up_booster = true
            local buffoon_pool = {"p_buffoon_normal_1", "p_buffoon_normal_2", "p_buffoon_jumbo_1", "p_buffoon_mega_1"}
            local chosen_buffoon = pseudorandom_element(buffoon_pool, pseudoseed("saga_event_forced_buffoon"))
            return G.P_CENTERS[chosen_buffoon]
        elseif next(SMODS.find_card("j_sgt_sub_engineer")) and not G.GAME.supply_drop then
            G.GAME.supply_drop = true
            return G.P_CENTERS.p_sgt_supply
        end
    end
    return gp(_key, _type)
end

function Sagatro.resize(card)
    if card.ability.set == "Booster" and card.T.w ~= G.CARD_W*1.27 then
        card.T.w = G.CARD_W*1.27
        card.T.h = G.CARD_H*1.27
    end
end

-- Reset debuff positions of all Mouses outside their own code (because they can't do that if debuffed)\
-- Also replenish first-slot buffoon pack if said events are yet to progress
function Sagatro.reset_game_globals(run_start)
    G.GAME.current_round.reroll_count = 0
    G.GAME.current_round.rerolls_left = G.GAME.modifiers.sgt_reroll_limit
    for _, v in ipairs(G.jokers.cards) do
        if v.config.center_key == "j_sgt_mouse" then
            if G.GAME.modifiers.sgt_joker_selling_rounds and v.debuff then
                v.ability.sgt_selling_tally = (v.ability.sgt_selling_tally or 0) + 1
            end
            for i = #v.ability.extra.debuff_position, 1, -1 do
                table.remove(v.ability.extra.debuff_position, i)
            end
            SMODS.debuff_card(v, false, "j_sgt_mouse")
            v.ability.extra.mult = v.ability.extra.buffer_mult
        end
    end
    if G.GAME.story_mode and G.GAME.saga_event_forced_buffoon
    and Sagatro.event_check(Sagatro.forced_buffoon_events, true) then
        G.GAME.saga_event_forced_buffoon = nil
    end
    G.GAME.first_hand_played = nil
    G.GAME.submarine_movement_cooldown = nil
    G.GAME.mirror_switch_cooldown = nil
    G.GAME.ante_reduction_tooltip = nil
    G.GAME.free_reroll_tooltip = nil
    if G.GAME.saved_by_gods_miracle then
        G.GAME.saved_by_gods_miracle = nil
    end
    -- Make sure the highlighted limit is always 1 regardless of other mod's interference
    if G.GAME.story_mode and run_start then
        G.jokers.config.highlighted_limit = 1
        G.consumeables.config.highlighted_limit = 1
    end
    --#region reset_dinah_card()
    G.GAME.current_round.dinah_card.rank = 'Ace'
    G.GAME.current_round.dinah_card.suit = 'Spades'
    G.GAME.current_round.dinah_card.id = 14
    local valid_dinah_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(v) and not SMODS.has_no_rank(v) then
            valid_dinah_cards[#valid_dinah_cards+1] = v
        end
    end
    if valid_dinah_cards[1] then
        local dinah_card = pseudorandom_element(valid_dinah_cards, pseudoseed('dinah'..G.GAME.round_resets.ante))
        G.GAME.current_round.dinah_card.rank = dinah_card.base.value
        G.GAME.current_round.dinah_card.suit = dinah_card.base.suit
        G.GAME.current_round.dinah_card.id = dinah_card.base.id
    end
    --#endregion
    --#region reset_humdum_rank()
    G.GAME.current_round.humdum_card.rank = 'Ace'
    local valid_humdum_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(v) then
            valid_humdum_cards[#valid_humdum_cards+1] = v
        end
    end
    if valid_humdum_cards[1] then
        local humdum_card = pseudorandom_element(valid_humdum_cards, pseudoseed('humdum'..G.GAME.round_resets.ante))
        G.GAME.current_round.humdum_card.rank = humdum_card.base.value
        G.GAME.current_round.humdum_card.id = humdum_card.base.id
    end
    --#endregion
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

---@param weight number|nil weight number to generate rarity from
---@param override string|nil forced rarity
function Sagatro.necronomicon_get_rarity(weight, override)
    if not override then
        for _, v in ipairs(Sagatro.necronomicon.rarity_order) do
            if weight >= Sagatro.necronomicon.rarity_weight[v] then
                return v
            end
        end
    elseif table.contains(Sagatro.necronomicon.rarity_order, override) then
        return override
    end
    return "Common"
end

local scu = set_consumeable_usage
function set_consumeable_usage(card)
    scu(card)
    if card.config.center_key and card.ability.consumeable then
        G.GAME.consumeable_usage_total.tarot_planet_divinatio_celestara =
        G.GAME.consumeable_usage_total.tarot_planet_divinatio_celestara or 0
        local set, key = card.config.center.set, card.config.center_key
        if set == 'Tarot' or set == 'Planet' or set == 'Divinatio' or set == 'Celestara' then
            G.GAME.consumeable_usage_total.tarot_planet_divinatio_celestara =
            G.GAME.consumeable_usage_total.tarot_planet_divinatio_celestara + 1
        end
        if set == 'Tarot' or set == 'Planet'
        or (set == 'Divinatio' and key ~= 'c_sgt_anima')
        or (set == 'Celestara' and key ~= 'c_sgt_soltera') then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.GAME.last_tarot_planet_divinatio_celestara = key
                            return true
                        end
                    }))
                    return true
                end
            }))
        end
    end
    G:save_settings()
end

-- Darn, Ortalab has this whole function just to set up floating blind sprites for a voucher\
-- Moving mine into Sagatro table Ig
function Sagatro.get_new_showdown(...)
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

    if Cartomancer then
        G.GAME.cartomancer_bosses_list = G.GAME.cartomancer_bosses_list or {}
        G.GAME.cartomancer_bosses_list[#G.GAME.cartomancer_bosses_list+1] = boss
    end

    local overridden = false
    local sgt_arg = select(1, ...)
    if G.GAME.story_mode and not G.GAME.won and sgt_arg ~= "not_forced" then
        if Sagatro.event_check("final_showdown") and not next(Sagatro.find_active_card("j_sgt_mad_hatter")) then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_red_queen'
            overridden = true
        elseif Sagatro.event_check("turquoise_jellyfish") then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_turquoise_jellyfish'
            overridden = true
        elseif Sagatro.event_check("aqua_eyeshard") then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_aqua_eyeshard'
            overridden = true
        elseif Sagatro.event_check("black_oil") then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_black_oil'
            overridden = true
        elseif Sagatro.event_check("shadow_seamine") then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_shadow_seamine'
            overridden = true
        elseif Sagatro.event_check("nyx_abyss") then
            G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
            boss = 'bl_sgt_nyx_abyss'
            overridden = true
        elseif G.GAME.inversed_scaling then
            if Sagatro.event_check("the_pawn", nil, true)
            and not Sagatro.event_check("the_pawn", false) then
                G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                boss = 'bl_sgt_pawn'
                overridden = true
            elseif Sagatro.event_check("the_rook", nil, true)
            and not Sagatro.event_check("the_rook", false) then
                G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                boss = 'bl_sgt_rook'
                overridden = true
            elseif Sagatro.event_check("the_knight", nil, true)
            and not Sagatro.event_check("the_knight", false) then
                G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                boss = 'bl_sgt_knight'
                overridden = true
            elseif Sagatro.event_check("the_bishop", nil, true)
            and not Sagatro.event_check("the_bishop", false) then
                G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                boss = 'bl_sgt_bishop'
                overridden = true
            elseif G.GAME.mirrorworld_showdown then
                if Sagatro.event_check("true_red_queen", nil, true)
                and not Sagatro.event_check("true_red_queen", false) then
                    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                    boss = 'bl_sgt_true_red_queen'
                    overridden = true
                elseif Sagatro.event_check("red_king", nil, true)
                and not Sagatro.event_check("red_king", false) then
                    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
                    boss = 'bl_sgt_red_king'
                    overridden = true
                end
            end
        end
    end
    if boss == 'bl_sgt_red_queen' then
        G.GAME.red_queen_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_red_queen", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
        if Sagatro.storyline_check("alice_in_mirrorworld") then
            G.GAME.paused_showdown = true
        end
    elseif boss == 'bl_sgt_true_red_queen' then
        G.GAME.true_red_queen_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_true_red_queen", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
    elseif boss == 'bl_sgt_red_king' then
        G.GAME.red_king_blind = true
        for _, v in ipairs(SMODS.find_card("j_sgt_red_king", true)) do
            local guilty_text = function()
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_guilty_ex'), instant = true, sound = 'tarot1'})
            end
            Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, guilty_text)
        end
    end
    if Cartomancer then
        G.GAME.cartomancer_bosses_list = G.GAME.cartomancer_bosses_list or {}
        if overridden then
            G.GAME.cartomancer_bosses_list[#G.GAME.cartomancer_bosses_list] = boss
        end
    end
    if overridden then
        G.GAME.saga_forced_boss = true
        G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
    end
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

---@param seed string
---@param count integer
function Sagatro.random_select(seed, area, count)
    local temp_hand = {}
    local selected_cards = {}
    for k, v in ipairs(area.cards) do temp_hand[#temp_hand+1] = v end
    if #temp_hand > 0 then
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed(seed))
        for i = 1, count do selected_cards[#selected_cards+1] = temp_hand[i] end
    end
    if next(selected_cards) then
        table.sort(selected_cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end
    return selected_cards
end

---@param table table
---@param suit string
function Sagatro.suit_scan(table, suit)
    local empty_original_suit = false
    for k, v in pairs(table) do
        if k == suit and type(v) == "number" and v == 0 then
            v = v + 1
            empty_original_suit = true
            break
        end
    end
    if not empty_original_suit then
        for k, v in pairs(table) do
            if k ~= suit and type(v) == "number" and v == 0 then
                v = v + 1
                break
            end
        end
    end
end

---@param table table
---@param amount integer
---@return boolean
---@return integer
function Sagatro.check_suit_record(table, amount)
    local count = 0
    for _, v in pairs(table) do
        if type(v) == "number" and v > 0 then
            count = count + 1
        end
    end
    return count >= amount, count
end

function Sagatro.set_debuff(card)
    if SMODS.has_enhancement(card, "m_sgt_strange") then
        return "prevent_debuff"
    end
end

function Sagatro.mabel_stall()
    if not G.jokers then return false end
    for i, v in ipairs(G.jokers.cards) do
        if v.config.center_key == "j_sgt_mabel" and i ~= 1 and i ~= #G.jokers.cards then
            return true
        end
    end
    return false
end

-- Borrowing these from Ortalab (nope, the +JokerSlot animation is not necessary)
function Sagatro.update_blind_amounts(instant)
    if G.GAME.blind then
        if G.GAME.inversed_scaling then
            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)/math.max(G.GAME.blind.mult*((0.8+(0.05*math.log(G.GAME.blind.mult)))^G.GAME.blind.mult), 1)
        else
            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.blind.mult*G.GAME.starting_params.ante_scaling
        end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if G.STATE == G.STATES.BLIND_SELECT and G.blind_select then
        G.blind_select:remove()
        G.blind_prompt_box:remove()
        G.blind_select = UIBox{
            definition = create_UIBox_blind_select(),
            config = {align = "bmi",
            offset = {x = 0, y = instant and (0.8 - (G.hand.T.y - G.jokers.T.y) + G.blind_select.T.h) or (G.ROOM.T.y + 29)},
            major = G.hand, bond = 'Weak'}
        }
        if not instant then G.blind_select.alignment.offset.y = 0.8-(G.hand.T.y - G.jokers.T.y) + G.blind_select.T.h end
        if ColdBeans then
            if G.GAME.round_resets.blind_states['Forced'] == "Select" then
                G.blind_select.alignment.offset.x = 0
            elseif G.GAME.round_resets.blind_states['Teeny'] == "Select" then
                G.blind_select.alignment.offset.x = 5
            elseif G.GAME.round_resets.blind_states['Small'] == "Select" then
                G.blind_select.alignment.offset.x = 1
            else
                G.blind_select.alignment.offset.x = -4
            end
        end
    end
    local at_least_most = G.HUD_blind and G.HUD_blind:get_UIE_by_ID("HUD_blind_score_at_least_most")
    if at_least_most then
        at_least_most.config.text = G.GAME.inversed_scaling and localize('ph_blind_score_at_most') or localize('ph_blind_score_at_least')
    end
end

function Sagatro.ease_ante(mod)
    ease_ante(mod)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + mod
    Sagatro.update_blind_amounts(true)
end

local gba = get_blind_amount
function get_blind_amount(ante)
    local amount = gba(ante)
    if G.GAME.sgt_lenient_score then
        -- 110000, 560000/2=280000, 7.2e6/10=720000, 3e8/150=2e6, 4.7e10/1e4=4.7e6, 2.9e13/2e6=1.45e7
        -- 7.7e16/1e9=7.7e7, 8.6e20/2e12=4.3e8, 4.2e25/1e16=4.2e9, 9.2e30/1e20=9.2e10, 9.2e36/1e24=9.2e12
        -- 4.3e43/1e28=4.3e15, etc.
        local limiter = {1, 2, 10, 150, 1e4, 2e6, 1e9, 2e12, 1e16}
        if not limiter[math.max(ante-8, 1)] then
            for _ = #limiter+1, ante-8 do
                limiter[#limiter+1] = limiter[#limiter]*1e4
            end
        end
        amount = amount/(limiter[math.max(ante-8, 1)] or 1)
    end
    if G.GAME.inversed_scaling then
        -- local i, s = ante, G.GAME.modifiers.scaling or 1
        -- amount = amount/((1+0.2*(s-1))^math.max(i-1, 0))/(math.max((i-4)*(2^math.max(i-8, 0)), 4)^math.max(i, 0))
        amount = 1500*(amount^-0.5)
        return amount
    end
    for _, card in ipairs(Sagatro.find_active_card('j_sgt_three_winters')) do
        amount = amount * card.ability.extra.xblind_amount
    end
    return amount
end

-- quick debug func
function Sagatro.get_blind_amounts(ante_ceil, nerfed)
    local temp = G.GAME.sgt_lenient_score
    G.GAME.sgt_lenient_score = nerfed and true or nil
    local t = {}
    for i = 1, ante_ceil do
        t[#t+1] = get_blind_amount(i)
    end
    G.GAME.sgt_lenient_score = temp
    return t
end

function Sagatro.get_quotient_amounts(ante_ceil)
    local t = {}
    for i = 1, ante_ceil do
        t[#t+1] = to_big(10^math.max(i-13, 3))
    end
    return t
end

-- cool trick to check for nan: it never equals itself
function Sagatro.is_nan()
    return SMODS.calculate_round_score(true) ~= SMODS.calculate_round_score(true)
end

local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    set_blind_ref(self, blind, reset, silent)
    local obj = self.config.blind
    if obj and next(obj) then
        local final_mult = obj.mult or 0
        for k, v in pairs(G.GAME.modifiers.sgt_blind_mult_mod or {}) do
            if G.GAME.round_resets.blind_choices[k]
            and G.GAME.round_resets.blind_choices[k] == obj.key then
                final_mult = final_mult * v
                break
            end
        end
        self.chips = get_blind_amount(G.GAME.round_resets.blind_ante)*final_mult*G.GAME.starting_params.ante_scaling
        if G.GAME.inversed_scaling then
            self.chips = get_blind_amount(G.GAME.round_resets.ante)/math.max(final_mult*((0.8+(0.05*math.log(final_mult)))^final_mult), 1)
        end
        self.chip_text = number_format(self.chips)
    end
end

function Sagatro.inverse()
    G.GAME.inversed_scaling = not G.GAME.inversed_scaling
    if G.STAGE == G.STAGES.RUN then
        if G.GAME.inversed_scaling then
            G.GAME.prev_scoring_calculation_key = G.GAME.current_scoring_calculation.key
        end
        SMODS.set_scoring_calculation(G.GAME.inversed_scaling and "sgt_divide" or G.GAME.prev_scoring_calculation_key)
        if not G.GAME.inversed_scaling then
            G.GAME.prev_scoring_calculation_key = nil
        end
        Sagatro.update_blind_amounts(true)
    end
end

SMODS.Scoring_Calculation {
    key = "divide",
    func = function(self, chips, mult, flames) return chips*1.0 / mult*1.0 end,
    text = '/',
}

---@param card table|Card must be a card object
---@param args table|nil configurable arguments, supports `no_destruction_context`, `no_sound`, `sound`, `pitch` and `volume`
---@param extra_func function|nil extra function to execute
function Sagatro.self_destruct(card, args, extra_func)
    args = args or {}
    if not args.no_destruction_context then
        card.getting_sliced = true
        if not (card.ability.set == 'Default' or card.ability.set == 'Enhanced') then
            local flags = SMODS.calculate_context({joker_type_destroyed = true, card = card})
            if flags.no_destroy then card.getting_sliced = nil; return end
        end
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

function Sagatro.set_ability_reset_keys()
    return {
        "anim_dt",
        "anim_pos",
        "anim_transition_path",
        "in_transition",
        "buffed",
        "debuffed_by_turquoise_jellyfish",
        "inactive",
        "shatters_on_destroy",
        "hide_name_tag",
    }
end

function Sagatro.quip_filter(quip, quip_type)
    if G.GAME.story_mode and (not quip.mod or (quip.mod and quip.mod.id ~= "Sagatro")) then
        return false
    end
    return true
end

-- Fix a damn edge case where the mod object is passed as a joker card without ability to check for retriggers
Sagatro.ability = {switch_bonus = 10, ch_repetition_penalty = 1.1, mir_repetition_penalty = 1.05}
function Sagatro:calculate(context)
    if G.GAME.story_mode and not context.retrigger_joker then
        if context.end_of_round and context.main_eval then
            for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == "Joker" and v.ability.immutable then
                    if (v.ability.immutable.fish_round_tally or 0) > 0 then
                        if v.ability.immutable.fish_round_tally == 1 then
                            v.ability.immutable.fish_round_tally = nil
                            v.ability.immutable.eaten_weight = nil
                            v.ability.immutable.eaten_type = nil
                            if v.ability.dolphin_high then
                                v.ability.dolphin_high = nil
                                v.ability.extra.xmult = v.ability.extra.xmult / 2
                                v.ability.extra.xmult_mod = v.ability.extra.xmult_mod / 2
                            end
                            SMODS.calculate_effect({message = localize('k_depleted_ex'), colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, v)
                        else
                            v.ability.immutable.fish_round_tally = (v.ability.immutable.fish_round_tally or 0) - 1
                            SMODS.calculate_effect({message = localize{type='variable',key='a_remaining',vars={v.ability.immutable.fish_round_tally}}, colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, v)
                        end
                    end
                end
            end
            if Sagatro.storyline_check("alice_in_wonderland") then
                G.GAME.switch_bonus = G.GAME.switch_bonus + Sagatro.ability.switch_bonus
            end
            if G.GAME.delayed_joker_slot then
                G.GAME.rounds_per_joker_slot = G.GAME.rounds_per_joker_slot or (G.GAME.sgt_lenient_score and 18 or 15)
                for i = 3, 1, -1 do
                    if G.GAME.round >= i*G.GAME.rounds_per_joker_slot then
                        if G.GAME.delayed_joker_slot == 4 - i then
                            G.jokers:change_size(1)
                            G.GAME.delayed_joker_slot = G.GAME.delayed_joker_slot - 1
                            return {
                                message = localize{type='variable',key='sgt_plus_joker_slot',vars={1}},
                            }
                        end
                    end
                end
            end
        end
        if context.after then
            for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == "Joker" and v.ability.immutable then
                    if (v.ability.immutable.fish_hand_tally or 0) > 0 then
                        if v.ability.immutable.fish_hand_tally == 1 then
                            v.ability.immutable.fish_hand_tally = nil
                            v.ability.immutable.eaten_weight = nil
                            v.ability.immutable.eaten_type = nil
                            if v.ability.dolphin_high then
                                v.ability.dolphin_high = nil
                                v.ability.extra.xmult = v.ability.extra.xmult / 2
                                v.ability.extra.xmult_mod = v.ability.extra.xmult_mod / 2
                            end
                            SMODS.calculate_effect({message = localize('k_depleted_ex'), colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, v)
                        else
                            v.ability.immutable.fish_hand_tally = (v.ability.immutable.fish_hand_tally or 0) - 1
                            SMODS.calculate_effect({message = localize{type='variable',key='a_remaining',vars={v.ability.immutable.fish_hand_tally}}, colour = G.C.FILTER, delay = 0.45, no_retrigger = true}, v)
                        end
                    end
                end
            end
        end
        if context.ante_change and context.ante_end then
            G.GAME.fish_effect.no_reshuffle = nil
            G.GAME.supply_drop = nil
            G.GAME.submarine_hint_to_progress = nil
            G.GAME.mirror_hint_to_progress = nil
            G.GAME.ante_cooldown = math.max(G.GAME.ante_cooldown - 1, 0)
            if G.GAME.pending_fish_var_tooltip_removal == 1 then
                G.GAME.fish_vars = nil
                G.GAME.pending_fish_var_tooltip_removal = nil
            elseif type(G.GAME.pending_fish_var_tooltip_removal) == "number" then
                G.GAME.pending_fish_var_tooltip_removal = G.GAME.pending_fish_var_tooltip_removal - 1
            end
            if Sagatro.storyline_check("20k_miles_under_the_sea") and G.GAME.round_resets.ante >= 2
            and not next(SMODS.find_card("j_sgt_sub_engineer", true)) then
                Sagatro.progress_storyline("the_sub_engineer", "add", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
            end
            for _, v in pairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == "Joker" and v.ability.immutable then
                    v.ability.immutable.no_reshuffle = nil
                end
            end
        end
        if context.check_eternal then
            local card = context.other_card
            if card.config.center_key == "j_sgt_submarine"
            or card.config.center_key == "j_sgt_mirror"
            or card.config.center_key == "j_sgt_goldia"
            or card.config.center_key == "j_sgt_fleta"
            or card.config.center_key == "j_sgt_harpae"
            or card.config.center_key == "j_sgt_lisette"
            or card.config.center_key == "j_sgt_enjel" then
                return {no_destroy = true}
            end
            if card.ability.set == "Joker" and not card.config.center.mirrorworld and G.GAME.inversed_scaling then
                return {no_destroy = {override_compat = true}}
            end
            if card.config.center_key == "c_soul" then
                return {no_destroy = {override_compat = true}}
            end
        end
        if context.starting_shop and (G.GAME.juice_up_booster or G.GAME.round == 1) then
            G.GAME.juice_up_booster = nil
            for _, v in ipairs(G.shop_booster.cards) do
                if v.ability.booster_pos == 1 then
                    if G.GAME.round == 1 then
                        v:set_ability("p_buffoon_jumbo_1")
                        Sagatro.resize(v)
                        v.ability.couponed = true
                        v:set_cost()
                    end
                    local eval = function(card) return not card.states.hover.is end
                    juice_card_until(v, eval, true)
                end
                break
            end
        end
        if context.setting_ability then
            Sagatro.update_inactive_state()
        end
        if context.prevent_tag_trigger then
            if context.prevent_tag_trigger.name == 'Boss Tag' then
                return {prevent_trigger = G.GAME.saga_forced_boss or G.STATE ~= G.STATES.BLIND_SELECT}
            elseif Sagatro.storyline_check("alice_in_mirrorworld") and G.GAME.inversed_scaling
            and (context.prevent_tag_trigger.name == 'Meteor Tag'
            or context.prevent_tag_trigger.name == 'Alien Tag') then
                return {prevent_trigger = true}
            end
        end
    end
    if context.final_scoring_step and not context.retrigger_joker and G.GAME.inversed_scaling then
        if G.GAME.hands[context.scoring_name].played - 1 > 0 then
            local xchips_penalty = (Sagatro.storyline_check("alice_in_mirrorworld") and "mir" or "ch").."_repetition_penalty"
            return {
                Xchip_mod = Sagatro.ability[xchips_penalty]^(G.GAME.hands[context.scoring_name].played - 1),
                message = localize{type='variable', key='a_xchips', vars={Sagatro.ability[xchips_penalty]^(G.GAME.hands[context.scoring_name].played - 1)}}
            }
        end
    end
    if context.after and not context.retrigger_joker then
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.first_hand_played = true
        return true end}))
    end
    if context.ante_change and not context.retrigger_joker then
        if context.ante_end and Sagatro.played_this_ante_compat() then
            for _, v in pairs(G.GAME.hands) do
                v.played_this_ante = 0
            end
        end
        if context.ante_change < 0 then
            G.GAME.ante_reduced = (G.GAME.ante_reduced or 0) - context.ante_change
        end
    end
    if ((context.ante_change and context.ante_change < 0) or context.sgt_ante_interrupt)
    and G.GAME.modifiers.sgt_ante_increased_cost and not context.retrigger_joker then
        G.GAME.modifiers.sgt_ante_increased_cost = G.GAME.modifiers.sgt_ante_increased_cost + 1
        Sagatro.global_set_cost(true)
    end
    if G.GAME.sgt_lenient_score then
        if context.sgt_ante_interrupt then
            G.GAME.sgt_ante_interrupt_count = (G.GAME.sgt_ante_interrupt_count or 0) + 1
            if G.GAME.sgt_ante_interrupt_count > 2 then
                G.GAME.sgt_ante_interrupt_count = nil
                G.GAME.sgt_lenient_score = nil
                SMODS.calculate_effect({message = localize("SGT_lenient_score_disabled")}, G.deck.cards[1] or G.deck)
            end
        end
        if context.end_of_round and context.main_eval then
            local quotient = to_big(10^math.max(G.GAME.round_resets.ante-13, 3))
            if ((not G.GAME.inversed_scaling and to_big(G.GAME.chips/G.GAME.blind.chips) > quotient)
            or (G.GAME.inversed_scaling and to_big(G.GAME.blind.chips/G.GAME.chips) > quotient)) then
                G.GAME.sgt_lenient_score = nil
                SMODS.calculate_effect({message = localize("SGT_lenient_score_disabled")}, G.deck.cards[1] or G.deck)
            end
        end
    end
    if context.end_of_round and context.main_eval and not context.retrigger_joker then
        G.GAME.jjb_cash_out = G.GAME.blind_on_deck == "Boss"
        if G.GAME.modifiers.sgt_joker_selling_rounds then
            for _, area in ipairs(SMODS.get_card_areas('jokers')) do
                for _, v in ipairs(area.cards) do
                    v.ability.sgt_selling_tally = (v.ability.sgt_selling_tally or 0) + 1
                end
            end
        end
    end
end

-- Implement fish joker behavior into Card.calculate_joker
local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local o, t = calculate_joker_ref(self, context)
    if self.ability.immutable and (self.ability.immutable.weight_level or 0) > 1 then
        context.eaten_weight = self.ability.immutable.eaten_weight
        context.eaten_type = self.ability.immutable.eaten_type
        context.eaten_stack = self.ability.immutable.eaten_stack
        local fish_o, fish_t = Sagatro.calculate_fish_joker(self, context)
        context.eaten_weight = nil
        context.eaten_type = nil
        context.eaten_stack = nil
        if fish_o then
            o = SMODS.merge_effects{o or {}, fish_o}
        end
        if fish_t then
            t = t or fish_t
        end
    end
    return o, t
end

function Sagatro.calculate_fish_joker(card, context)
    if (not context.eaten_weight and not context.eaten_stack) or context.retrigger_joker then return end
    if context.eaten_weight == 1 and not context.blueprint then
        if context.eaten_type == 1 then
            if context.first_hand_drawn then
                local selected_cards = Sagatro.random_select("eaten_select11", G.hand, 3)
                delay(0.15)
                for i = 1, #selected_cards do
                    local percent = 1.15 - (i - 0.999) / (#selected_cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            selected_cards[i]:flip()
                            play_sound('card1', percent)
                            selected_cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                for i = 1, #selected_cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _card = selected_cards[i]
                            assert(SMODS.change_base(_card, nil, "2"))
                            return true
                        end
                    }))
                end
                delay(0.15)
                for i = 1, #selected_cards do
                    local percent = 0.85 + (i - 0.999) / (#selected_cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            selected_cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            selected_cards[i]:juice_up(0.3, 0.3)
                            save_run()
                            return true
                        end
                    }))
                end
                delay(0.5)
            end
        elseif context.eaten_type == 2 then
            if context.first_hand_drawn then
                local selected_cards = Sagatro.random_select("eaten_select12", G.hand, 3)
                delay(0.15)
                for i = 1, #selected_cards do
                    local percent = 1.15 - (i - 0.999) / (#selected_cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            selected_cards[i]:flip()
                            play_sound('card1', percent)
                            selected_cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                for i = 1, #selected_cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _card = selected_cards[i]
                            assert(SMODS.modify_rank(_card, -1))
                            return true
                        end
                    }))
                end
                delay(0.15)
                for i = 1, #selected_cards do
                    local percent = 0.85 + (i - 0.999) / (#selected_cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            selected_cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            selected_cards[i]:juice_up(0.3, 0.3)
                            save_run()
                            return true
                        end
                    }))
                end
                delay(0.5)
            end
        elseif context.eaten_type == 3 then
            if context.before and context.scoring_name == "Pair" then
                local ranks = {}
                for _, v in ipairs(context.scoring_hand) do
                    if not SMODS.has_no_rank(v) then
                        ranks[v.config.card.value] = (ranks[v.config.card.value] or 0) + 1
                    end
                end
                local max_count, rank = 0, nil
                for k, v in pairs(ranks) do
                    if max_count < v then max_count = v; rank = k end
                end
                local i = 1
                local _card = context.scoring_hand[i]
                while _card and SMODS.has_no_rank(_card)
                and _card.config.card.value ~= rank do
                    i = i + 1
                    _card = context.scoring_hand[i]
                end
                local orig_card = _card
                i = i + 1
                _card = context.scoring_hand[i]
                while _card and SMODS.has_no_rank(_card)
                and _card.config.card.value ~= rank do
                    i = i + 1
                    _card = context.scoring_hand[i]
                end
                if _card then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            _card:juice_up()
                            assert(SMODS.change_base(_card, orig_card.base.suit, nil))
                            return true
                        end
                    }))
                    return {
                        message = localize("k_smeared_ex"),
                        colour = G.C.SUBMARINE_DEPTH[Sagatro.get_submarine_depth_colour()],
                        no_retrigger = true,
                    }
                end
            end
        elseif context.eaten_type == 4 then
            card.ability.immutable.eaten_weight = nil
            card.ability.immutable.eaten_type = nil
            card.ability.immutable.eaten_stack = (card.ability.immutable.eaten_stack or 0) + 1
        elseif context.eaten_type == 5 then
            if context.before and context.scoring_name == "High Card" then
                local i = 1
                local _card = context.scoring_hand[i]
                while _card and SMODS.always_scores(_card) do
                    i = i + 1
                    _card = context.scoring_hand[i]
                end
                i = 1
                _card = context.full_hand[i]
                while _card and (SMODS.always_scores(_card) or table.contains(context.scoring_hand, _card)) do
                    i = i + 1
                    _card = context.full_hand[i]
                end
                if _card and _card.ability.set ~= "Enhanced" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            _card:juice_up()
                            _card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = 'eaten_enhancement15'})])
                            return true
                        end
                    }))
                    return {
                        message = localize("k_enhanced_ex"),
                        colour = G.C.SUBMARINE_DEPTH[Sagatro.get_submarine_depth_colour()],
                        no_retrigger = true,
                    }
                end
            end
        end
    elseif context.eaten_weight == 2 then
        if context.eaten_type == 1 and not context.blueprint then
            card.ability.immutable.eaten_weight = nil
            card.ability.immutable.eaten_type = nil
            card.ability.immutable.no_reshuffle = true
            G.GAME.fish_effect.no_reshuffle = true
        elseif context.eaten_type == 2 then
            if context.before and #context.scoring_hand == 1 then
                card.ability.triggered = true
            end
            if card.ability.triggered and context.repetition and context.cardarea == G.hand
            and (next(context.card_effects[1]) or #context.card_effects > 1) then
                if context.other_card == G.hand.cards[1] then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 2,
                        card = card,
                    }
                end
            end
            if context.after then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.triggered = nil
                return true end }))
            end
        elseif context.eaten_type == 3 and not context.blueprint then
            if context.before and #context.scoring_hand == 2 then
                card.ability.triggered = true
            end
            if card.ability.triggered and context.individual and context.cardarea == G.play then
                return {mult = 8}
            end
            if context.after then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.triggered = nil
                return true end }))
            end
        elseif context.eaten_type == 4 and not context.blueprint then
            if context.before and #context.scoring_hand == 3 then
                local money = 6
                ease_dollars(money)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                G.E_MANAGER:add_event(Event({
                func = (function()
                    G.GAME.dollar_buffer = 0
                    return true
                end)
                }))
                return {
                    message = localize('$')..money,
                    colour = G.C.MONEY,
                }
            end
        elseif context.eaten_type == 5 and not context.blueprint then
            if context.before and #context.scoring_hand == 4 then
                card.ability.triggered = true
            end
            if card.ability.triggered and context.individual and context.cardarea == G.play then
                return {xmult = 1.5}
            end
            if context.after then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.triggered = nil
                return true end }))
            end
        elseif context.eaten_type == 6 and not context.blueprint then
            if context.before and #context.scoring_hand == 5 then
                card.ability.triggered = true
            end
            if card.ability.triggered and context.individual and context.cardarea == G.play then
                return {xmult = 1.4}
            end
            if context.after then
                G.E_MANAGER:add_event(Event({func = function()
                    card.ability.triggered = nil
                return true end }))
            end
        end
    elseif context.eaten_weight == 3 then
        if context.eaten_type == 1 and not context.blueprint then
            if context.hand_drawn then
                G.hand:unhighlight_all()
                local forced_cards = Sagatro.random_select("eaten_select31", G.hand, 1)
                for _, _card in ipairs(forced_cards) do
                    if not _card.ability.forced_selection then
                        _card.ability.forced_selection = true
                        G.hand:add_to_highlighted(_card)
                    end
                end
                G.E_MANAGER:add_event(Event({func = function()
                    G.hand:parse_highlighted()
                return true end }))
            end
            if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
                return {xmult = 1.5}
            end
        elseif context.eaten_type == 2 then
            if context.hand_drawn then
                G.hand:unhighlight_all()
                local forced_cards = Sagatro.random_select("eaten_select32", G.hand, 2)
                for _, _card in ipairs(forced_cards) do
                    if not _card.ability.forced_selection then
                        _card.ability.forced_selection = true
                        G.hand:add_to_highlighted(_card)
                    end
                end
                G.E_MANAGER:add_event(Event({func = function()
                    G.hand:parse_highlighted()
                return true end }))
            end
            if context.retrigger_joker_check and context.other_card == card then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 1,
                    card = card,
                }
            end
        elseif context.eaten_type == 3 and not context.blueprint then
            if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook then
                local hand_type = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                if to_big(G.GAME.hands[hand_type].level) > to_big(1) then
                    SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, level_up_hand = hand_type, no_retrigger = true}, card)
                    local _hand, _tally = nil, 0
                    for k, v in ipairs(G.handlist) do
                        if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                            _hand = v
                            _tally = G.GAME.hands[v].played
                        end
                    end
                    if _hand then
                        SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                        SMODS.smart_level_up_hand(card, _hand)
                    end
                end
            end
        elseif context.eaten_type == 4 and not context.blueprint then
            if context.pre_discard and #context.full_hand == 1
            and G.GAME.current_round.discards_used <= 0 and not context.hook then
                delay(0.15)
                for i = 1, #context.full_hand do
                    local percent = 1.15 - (i - 0.999) / (#context.full_hand - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            context.full_hand[i]:flip()
                            play_sound('card1', percent)
                            context.full_hand[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                for i = 1, #context.full_hand do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _card = context.full_hand[i]
                            if _card.ability.set ~= 'Enhanced' then
                                _card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = 'eaten_enhancement41'})])
                            end
                            if not _card.edition then
                                _card:set_edition(poll_edition("eaten_edition41"))
                            end
                            if not _card.seal then
                                _card:set_seal(SMODS.poll_seal{type_key = 'eaten_seal41'})
                            end
                            return true
                        end
                    }))
                end
                delay(0.15)
                for i = 1, #context.full_hand do
                    local percent = 0.85 + (i - 0.999) / (#context.full_hand - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            context.full_hand[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            context.full_hand[i]:juice_up(0.3, 0.3)
                            save_run()
                            return true
                        end
                    }))
                end
                delay(0.5)
            end
        elseif context.eaten_type == 5 and not context.blueprint then
            if context.pre_discard and G.GAME.current_round.discards_left <= 1 and not context.hook then
                local selected_card = pseudorandom_element(context.full_hand, pseudoseed("eaten_select35"))
                delay(0.15)
                for i = 1, #context.full_hand do
                    local percent = 1.15 - (i - 0.999) / (#context.full_hand - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            context.full_hand[i]:flip()
                            play_sound('card1', percent)
                            context.full_hand[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                for i = 1, #context.full_hand do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if G.hand.highlighted[i] ~= selected_card then
                                copy_card(selected_card, G.hand.highlighted[i])
                            end
                            return true
                        end
                    }))
                end
                delay(0.15)
                for i = 1, #context.full_hand do
                    local percent = 0.85 + (i - 0.999) / (#context.full_hand - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            context.full_hand[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            context.full_hand[i]:juice_up(0.3, 0.3)
                            save_run()
                            return true
                        end
                    }))
                end
                delay(0.5)
            end
        end
    elseif context.eaten_weight == 4 then
        if context.eaten_type == 1 then
            if context.retrigger_joker_check and context.other_card == card then
                return {
                    message = localize("k_again_ex"),
                    repetitions = 2,
                    card = card,
                }
            end
        elseif context.eaten_type == 2 and not context.blueprint then
            if context.before then
                local selected_card = pseudorandom_element(G.play.cards, pseudoseed("eaten_select52"))
                delay(0.15)
                for i = 1, #G.hand.cards do
                    local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('card1', percent)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                for i = 1, #G.hand.cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            copy_card(selected_card, G.hand.cards[i])
                            return true
                        end
                    }))
                end
                delay(0.15)
                for i = 1, #G.hand.cards do
                    local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            save_run()
                            return true
                        end
                    }))
                end
                delay(0.5)
            end
        elseif context.eaten_type == 3 and not context.blueprint then
            if context.end_of_round and context.main_eval then
                local money = math.min(to_number(G.GAME.dollars), 1e300)
                ease_dollars(money)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                G.E_MANAGER:add_event(Event({
                func = (function()
                    G.GAME.dollar_buffer = 0
                    return true
                end)
                }))
                return {
                    message = "X2",
                    colour = G.C.MONEY,
                }
            end
        elseif context.eaten_type == 4 then
            if context.after then
                return {
                    sgt_e_score = 1.05,
                }
            end
        elseif context.eaten_type == 5 then
            if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.forcetrigger then
                return {
                    sgt_e_mult = 1.1,
                }
            end
        end
    end
    if context.joker_main and (context.eaten_stack or 0) > 0 then
        return {
            chips = 10*context.eaten_stack,
            mult = 5*context.eaten_stack,
        }
    end
end

function Sagatro.process_edible_fish(card, context)
    if context.setting_blind and not card.getting_sliced and not context.forcetrigger
    and not context.blueprint and not context.retrigger_joker then
        if card.area == G.consumeables then return end
        local pos = Sagatro.get_pos(card)
        local jokers = {}
        if pos then
            if card.ability.immutable.target_offset then
                jokers[#jokers+1] = G.jokers.cards[pos+card.ability.immutable.target_offset]
            elseif card.ability.immutable.target == "leftmost" then
                jokers[#jokers+1] = G.jokers.cards[1] ~= card and G.jokers.cards[1] or nil
            elseif card.ability.immutable.target == "rightmost" then
                jokers[#jokers+1] = G.jokers.cards[1] ~= card and G.jokers.cards[#G.jokers.cards] or nil
            elseif card.ability.immutable.target_range == "leftward" then
                for i = pos-1, 1, -1 do
                    if not (SMODS.is_eternal(G.jokers.cards[i], card)
                    and card.ability.immutable.eternal_block) then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    else break end
                end
            elseif card.ability.immutable.target_range == "rightward" then
                for i = pos+1, #G.jokers.cards do
                    if not (SMODS.is_eternal(G.jokers.cards[i], card)
                    and card.ability.immutable.eternal_block) then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    else break end
                end
            elseif type(card.ability.immutable.target_range) == "table" then
                local i_start, i_end = card.ability.immutable.target_range[1], card.ability.immutable.target_range[2]
                for i = i_start, i_end do
                    if i ~= 0 and G.jokers.cards[pos+i]
                    and not SMODS.is_eternal(G.jokers.cards[pos+i], card) then
                        jokers[#jokers+1] = G.jokers.cards[pos+i]
                    end
                end
            end
        end
        local edible_fish, weight_tally = {}, 1
        for _, joker in ipairs(jokers) do
            if not card.getting_sliced
            and not SMODS.is_eternal(joker, card) and not joker.getting_sliced
            and joker.ability.immutable and joker.ability.immutable.weight_level
            and joker.ability.immutable.weight_level < card.ability.immutable.weight_level then
                if weight_tally < joker.ability.immutable.weight_level then
                    weight_tally = joker.ability.immutable.weight_level
                end
                if card.config.center_key == "j_sgt_dolphin" or joker.config.center_key ~= "j_sgt_pufferfish" then
                    edible_fish[#edible_fish+1] = joker
                end
            end
        end
        local dolphin_high
        if #edible_fish > 0 then
            G.GAME.joker_buffer = G.GAME.joker_buffer - #edible_fish
            for _, fish in ipairs(edible_fish) do
                fish.getting_sliced = true
            end
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                card:juice_up(0.8, 0.8)
                for _, fish in ipairs(edible_fish) do
                    if card.config.center_key == "j_sgt_dolphin"
                    and fish.config.center_key == "j_sgt_pufferfish" then
                        dolphin_high = true
                    end
                    fish:start_dissolve({G.C.RED}, true, 1.6)
                end
                play_sound('sgt_swallow', 0.96+math.random()*0.08)
                Sagatro.process_edible_weight(card, weight_tally)
                if dolphin_high then
                    dolphin_high = nil
                    card.ability.dolphin_high = true
                    card.ability.extra.xmult = card.ability.extra.xmult * 2
                    card.ability.extra.xmult_mod = card.ability.extra.xmult_mod * 2
                end
            return true end }))
        end
    end
end

---@param weight_level 1|2|3|4
function Sagatro.process_edible_weight(card, weight_level)
    local roll = pseudorandom("fish_eating_weight")
    local chosen_weight, chosen_type, options = nil, nil, {}
    if weight_level == 1 then
        chosen_weight = (roll < 0.7  and 1) --70%
                     or 2                   --30%
    elseif weight_level == 2 then
        chosen_weight = (roll < 0.7  and 2) --70%
                     or (roll < 0.79 and 1) -- 9%
                     or 3                   --21%
    elseif weight_level == 3 then
        chosen_weight = (roll < 0.7  and 3) --70%
                     or (roll < 0.82 and 2) --12%
                     or (roll < 0.85 and 1) -- 3%
                     or 4                   --15%
    elseif weight_level == 4 then
        chosen_weight = (roll < 0.7  and 4) --70%
                     or (roll < 0.85 and 3) --15%
                     or (roll < 0.97 and 2) --12%
                     or 1                   -- 3%
    end
    if chosen_weight == 1 then
        chosen_type = pseudorandom("fish_eating_type", 1, 5)
        if chosen_type ~= 4 then
            options = {round = true, duration = 3}
        end
    elseif chosen_weight == 2 then
        chosen_type = pseudorandom("fish_eating_type", 1, 6)
        if chosen_type ~= 1 then
            options = {round = true, duration = 3}
        end
    elseif chosen_weight == 3 then
        chosen_type = pseudorandom("fish_eating_type", 1, 5)
        if chosen_type == 1 or chosen_type == 2 then
            options = {hand = true, duration = 5}
        elseif chosen_type == 3 or chosen_type == 4 then
            options = {round = true, duration = 3}
        elseif chosen_type == 5 then
            options = {round = true, duration = 1}
        end
    elseif chosen_weight == 4 then
        chosen_type = pseudorandom("fish_eating_type", 1, 5)
        if chosen_type == 2 then
            options = {hand = true, duration = 1}
        else
            options = {round = true, duration = 3}
        end
    end
    card.ability.immutable.eaten_weight = chosen_weight
    card.ability.immutable.eaten_type = chosen_type
    card.ability.immutable.fish_round_tally = options.round and options.duration
    card.ability.immutable.fish_hand_tally = options.hand and options.duration
end

function Sagatro.process_edible_state(card, eaten_object)
    if card.ability.immutable.eaten_weight then return end
    local source_weight = card.ability.immutable.weight_level
    local target_weight = (eaten_object.ability.immutable or {}).weight_level
    if not target_weight or (card.config.center_key ~= "j_sgt_dolphin"
    and eaten_object.config.center_key == "j_sgt_pufferfish") then
        eaten_object:add_sticker("sgt_not_food", true)
    elseif source_weight <= target_weight then
        eaten_object:add_sticker("sgt_inedible", true)
    elseif source_weight > target_weight then
        eaten_object:add_sticker("sgt_edible", true)
    end
end

function Sagatro.fish_loc_vars(info_queue, card)
    if G.GAME.story_mode and not card.fake_card then
        local _weight = card.ability.immutable.eaten_weight
        local _type = card.ability.immutable.eaten_type
        local _stack = card.ability.immutable.eaten_stack
        local no_reshuffle = card.ability.immutable.no_reshuffle
        local round_tally = card.ability.immutable.fish_round_tally
        local hand_tally = card.ability.immutable.fish_hand_tally
        if not _weight then
            info_queue[#info_queue+1] = {
                generate_ui = saga_tooltip,
                set = "fish_effect",
                key = "pending_swallow",
                colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.5),
            }
        elseif (_weight ~= 1 or _type ~= 4) and (_weight ~= 2 or _type ~= 1) then
            info_queue[#info_queue+1] = {
                generate_ui = saga_tooltip,
                set = "fish_effect",
                key = "weight".._weight.."_type".._type,
                title = localize("fish_effect_active"),
                specific_vars = {round_tally or hand_tally},
                colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.5),
            }
        end
        if (_stack or 0) > 0 then
            info_queue[#info_queue+1] = {
                generate_ui = saga_tooltip,
                set = "fish_effect",
                key = "weight1_type4",
                title = localize("fish_effect_stackable"),
                specific_vars = {_stack},
                colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.5),
            }
        end
        if no_reshuffle then
            info_queue[#info_queue+1] = {
                generate_ui = saga_tooltip,
                set = "fish_effect",
                key = "weight2_type1",
                title = localize("fish_effect_active"),
                colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.5),
            }
        end
    end
end

function Sagatro.resolve_fuel(mod)
    if not Sagatro.storyline_check("20k_miles_under_the_sea") then return end
    local card = SMODS.find_card("j_sgt_submarine", true)[1]
    if card then
        card.ability.immutable.states.fuel_left =
        math.min(card.ability.immutable.states.fuel_left + mod, card.ability.immutable.states.max_fuel)
        if card.ability.immutable.states.fuel_left <= 0 then
            card.ability.immutable.states.fuel_left = 0
            card:add_sticker("sgt_imminent_doom", true)
            G.GAME.imminent_doom = true
        else
            if card.ability.immutable.states.hunger_left > 0 then
                card:remove_sticker("sgt_imminent_doom")
                G.GAME.imminent_doom = nil
            end
            if card.ability.immutable.states.fuel_left <= 1.5 and not card.ability.immutable.states.low_fuel then
                card.ability.immutable.states.low_fuel = true
                G.GAME.submarine_low_fuel = true
            elseif card.ability.immutable.states.fuel_left > 1.5 and card.ability.immutable.states.low_fuel then
                card.ability.immutable.states.low_fuel = nil
                G.GAME.submarine_low_fuel = nil
            end
            if card.ability.immutable.states.fuel_left >= 8 and not card.ability.immutable.states.high_fuel then
                card.ability.immutable.states.high_fuel = true
                G.E_MANAGER:add_event(Event({func = function()
                    G.jokers:change_size(1)
                    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 1
                    calculate_reroll_cost(true)
                    G.GAME.submarine_high_fuel = true
                    Sagatro.global_set_cost()
                return true end}))
            elseif card.ability.immutable.states.fuel_left < 8 and card.ability.immutable.states.high_fuel then
                card.ability.immutable.states.high_fuel = nil
                G.E_MANAGER:add_event(Event({func = function()
                    G.jokers:change_size(-1)
                    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + 1
                    calculate_reroll_cost(true)
                    G.GAME.submarine_high_fuel = nil
                    Sagatro.global_set_cost()
                    -- For some dunk reason the first call adds $2 of buy value instead of 1
                    -- So I'm calling it again, damn
                    Sagatro.global_set_cost()
                return true end}))
            end
        end
    end
end

function Sagatro.resolve_hunger(mod)
    if not Sagatro.storyline_check("20k_miles_under_the_sea") then return end
    local card = SMODS.find_card("j_sgt_submarine", true)[1]
    if card then
        card.ability.immutable.states.hunger_left =
        math.min(card.ability.immutable.states.hunger_left + mod, card.ability.immutable.states.max_hunger)
        if card.ability.immutable.states.hunger_left <= 0 then
            card.ability.immutable.states.hunger_left = 0
            card:add_sticker("sgt_imminent_doom", true)
            G.GAME.imminent_doom = true
        else
            if card.ability.immutable.states.fuel_left > 0 then
                card:remove_sticker("sgt_imminent_doom")
                G.GAME.imminent_doom = nil
            end
            if card.ability.immutable.states.hunger_left <= 1.5 and not card.ability.immutable.states.starvation then
                card.ability.immutable.states.starvation = true
                G.E_MANAGER:add_event(Event({func = function()
                    G.hand:change_size(-1)
                return true end}))
            elseif card.ability.immutable.states.hunger_left > 1.5 and card.ability.immutable.states.starvation then
                card.ability.immutable.states.starvation = nil
                G.E_MANAGER:add_event(Event({func = function()
                    G.hand:change_size(1)
                return true end}))
            end
            if card.ability.immutable.states.hunger_left >= 7 and not card.ability.immutable.states.nourished then
                card.ability.immutable.states.nourished = true
            elseif card.ability.immutable.states.hunger_left < 7 and card.ability.immutable.states.nourished then
                card.ability.immutable.states.nourished = nil
            end
        end
    end
end

function Sagatro.instant_reroll()
    if G.STATE == G.STATES.SHOP then
        SMODS.change_free_rerolls(1)
        Sagatro.reroll_no_save = true
        G.FUNCS.reroll_shop()
        Sagatro.reroll_no_save = nil
        G.GAME.round_resets.free_rerolls = G.GAME.round_resets.free_rerolls - 1
        calculate_reroll_cost(true)
    end
end

function Sagatro.global_set_cost(from_event)
    local set_cost = function()
        for _, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
    end
    if from_event then
        G.E_MANAGER:add_event(Event({func = function()
            set_cost()
        return true end }))
    else
        set_cost()
    end
end

---@param card table|Card
function Sagatro.get_pos(card)
    if card.area then
        for i, v in ipairs(card.area.cards) do
            if v == card then
                return i
            end
        end
    end
end

function Sagatro.update_inactive_state(update_slots_used)
    if G.jokers and Sagatro.storyline_check("alice_in_mirrorworld") then
        for i = 1, #G.jokers.cards do
            local v = G.jokers.cards[i]
            if v.ability.set == "Joker" and v.config.center_key ~= "j_sgt_mirror" then
                if v.config.center.mirrorworld then
                    if update_slots_used then
                        v.ability.extra_slots_used = G.GAME.inversed_scaling and 0 or -1
                    end
                    v.ability.inactive = not G.GAME.inversed_scaling
                    if JokerDisplay then
                        if (v.ability.inactive and not (v.joker_display_values or {}).disabled)
                        or (not v.ability.inactive and (v.joker_display_values or {}).disabled) then
                            Sagatro.jd_toggle_override = true
                            v:joker_display_toggle()
                            Sagatro.jd_toggle_override = nil
                        end
                    end
                else
                    if update_slots_used then
                        v.ability.extra_slots_used = G.GAME.inversed_scaling and -1 or 0
                    end
                    v.ability.inactive = G.GAME.inversed_scaling and not v.ability.sgt_mirrored
                    if JokerDisplay then
                        if (v.ability.inactive and not (v.joker_display_values or {}).disabled)
                        or (not v.ability.inactive and (v.joker_display_values or {}).disabled) then
                            Sagatro.jd_toggle_override = true
                            v:joker_display_toggle()
                            Sagatro.jd_toggle_override = nil
                        end
                    end
                end
            end
        end
    end
end

function Sagatro.get_edition_chips(card)
    if not card.edition then return 0 end
    local ret = card:calculate_edition({main_scoring = true, cardarea = G.play})
    if not ret then return 0 end
    if ret.chips then return ret.chips end
    if ret.chip_mod then return ret.chip_mod end
    return 0
end

function Sagatro.get_seal_chips(card)
    if not card.seal then return 0 end
    local ret = card:calculate_seal({main_scoring = true, cardarea = G.play})
    if not ret then return 0 end
    if ret.chips then return ret.chips end
    if ret.chip_mod then return ret.chip_mod end
    return 0
end

function Sagatro.find_active_card(key, count_debuffed, count_inactive)
    local cards = {}
    for _, v in ipairs(SMODS.find_card(key, count_debuffed)) do
        if not v.ability.inactive or count_inactive then
            cards[#cards+1] = v
        end
    end
    return cards
end

function Sagatro.vorpal_jubjub()
    for _, v in ipairs(Sagatro.find_active_card("j_sgt_vorpal_sword")) do
        if v.ability.extra.sliced_beasts.jubjub_bird_sliced then
            return true
        end
    end
    return false
end

function Sagatro.stall_ante()
    return next(Sagatro.find_active_card("j_sgt_mad_hatter")) or next(Sagatro.find_active_card("j_sgt_jubjub_bird")) or Sagatro.mabel_stall() or Sagatro.vorpal_jubjub()
end

---@param beta_vercode string
function Sagatro.backward_compat(beta_vercode)
    local _, i = SMODS.version:find("1.0.0~BETA")
    if i then
        return SMODS.version:sub(i + 1) < beta_vercode
    end
    return false
end

function Sagatro.played_this_ante_compat()
    return Sagatro.backward_compat "1122a"
end

-- Wizard of Oz sneak peek (postponed)
function Sagatro.handle_dissolve(card, dissolve, dissolve_time)
    dissolve = dissolve or card.dissolve == 0
    dissolve_time = dissolve_time or 10
    card.dissolve = card.dissolve or not dissolve and 1 or 0
    card.dissolve_colours =
    dissolve and {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY} or
    (card.ability.set == 'Joker' and {G.C.RARITY[card.config.center.rarity]}) or
    (card.ability.set == 'Voucher' and {G.C.SECONDARY_SET.Voucher, G.C.CLEAR}) or
    (card.ability.set == 'Booster' and {G.C.BOOSTER}) or
    {G.C.SECONDARY_SET[card.ability.set] or G.C.GREEN}
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = card,
        ref_value = 'dissolve',
        ease_to = dissolve and 1 or 0,
        delay =  1*dissolve_time*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
        func = (function(t) return t end)
    }))
end

---@param card table|Card
---@param dir "left"|"right"|nil
function Sagatro.swap(card, dir)
    dir = dir or "right"
    if not card.area then return end
    if dir == "left" and card.rank > 1
    and card.area.cards[card.rank - 1] then
        card.rank = card.rank - 1
        card.area.cards[card.rank].rank = card.rank + 1
        table.sort(card.area.cards, function (a, b) return a.rank < b.rank end)
        card.area:align_cards()
    elseif dir == "right" and card.rank < #card.area.cards
    and card.area.cards[card.rank + 1] then
        card.rank = card.rank + 1
        card.area.cards[card.rank].rank = card.rank - 1
        table.sort(card.area.cards, function (a, b) return a.rank < b.rank end)
        card.area:align_cards()
    end
end

---@param cls SMODS.GameObject
---@param key string
---@param obj table
---@param silent boolean?
---@param from_mod Mod|table?
---@return string?
function Sagatro.runtime_ownership(cls, key, obj, silent, from_mod)
    assert(not obj.inject, 'Overriding "inject" field is not allowed.')
    SMODS.current_mod = from_mod or Sagatro
    local result = cls:take_ownership(key, obj, silent)
    local success = ("Successfully taken ownership of %s%s by mod with id %s."):format(cls.class_prefix and (cls.class_prefix.."_") or "", key, SMODS.current_mod.id)
    SMODS.current_mod = nil
    if result then return success end
end

-- Sagatro.runtime_ownership(SMODS.Joker, "splash", {name = "SagaSplash"}, true)

-- Overriding this since it gives -$-0 at value 0 and I hate it
function SMODS.signed_dollars(val)
    return val and (val >= 0 and '$'..val or '-$'..-val) or '0'
end

function Sagatro.delayed_func()
    if not Sagatro.init_delayed_func then
        Sagatro.init_delayed_func = true
        G.FUNCS.openModUI_Sagatro = function(e)
            if e and e.config then
                Sagatro.fromAlice = e.config.fromAlice
            end
            G.ACTIVE_MOD_UI = Sagatro
            if e and e.config and e.config.page then
                SMODS.LAST_SELECTED_MOD_TAB = e.config.page
            end
            G.FUNCS.overlay_menu({
                definition = create_UIBox_Sagatro(e)
            })
        end
        for _, rarity in ipairs(Sagatro.mad_hatter_whitelist) do
            if not rarity:find("_mod") then
                rarity = rarity.."_mod"
            end
        end
        local set_cost_ref = Card.set_cost
        function Card:set_cost()
            set_cost_ref(self)
            if self.ability.set == "Joker" then
                if G.GAME.modifiers.sgt_reduced_sell_cost and not self.ability.sgt_reduced_sell_cost then
                    self.ability.sgt_reduced_sell_cost = true
                    self.ability.extra_value = (self.ability.extra_value or 0) - G.GAME.modifiers.sgt_reduced_sell_cost
                    self.sell_cost = math.max(1, math.floor(self.cost/2)) + (self.ability.extra_value or 0)
                end
                if G.GAME.modifiers.sgt_ante_increased_cost then
                    self.ability.sgt_extra_cost = 0
                    if self.ability.sgt_extra_cost ~= G.GAME.modifiers.sgt_ante_increased_cost then
                        self.ability.sgt_extra_cost = G.GAME.modifiers.sgt_ante_increased_cost
                        self.cost = math.max(1, math.floor((self.base_cost + self.extra_cost + self.ability.sgt_extra_cost + 0.5)*(100-G.GAME.discount_percent)/100))
                        self.sell_cost = math.max(1, math.floor(self.cost/2)) + (self.ability.extra_value or 0)
                    end
                end
                if self.ability.immutable and self.ability.immutable.weight_level and not self.ability.couponed then
                    if G.GAME.submarine_high_fuel and not self.ability.immutable.cost_reduced then
                        self.ability.immutable.cost_reduced = true
                        self.cost = self.cost - 1
                    elseif not G.GAME.submarine_high_fuel and self.ability.immutable.cost_reduced then
                        self.ability.immutable.cost_reduced = nil
                        self.cost = self.cost + 1
                    end
                end
            end
        end
    end
end

function Sagatro.quick_restart()
    if G.STAGE == G.STAGES.RUN and not G.SETTINGS.paused then
        G.SETTINGS.paused = true
        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
        end
        G:save_settings()
        G.SETTINGS.current_setup = 'New Run'
        G.GAME.viewed_back = nil
        G.run_setup_seed = G.GAME.seeded
        G.challenge_tab = G.GAME and G.GAME.challenge and G.GAME.challenge_tab or nil
        G.forced_seed, G.setup_seed = nil, nil
        if G.GAME.seeded then G.forced_seed = G.GAME.pseudorandom.seed end
        G.forced_stake = G.GAME.stake
        local _seed = G.run_setup_seed and G.setup_seed or G.forced_seed or nil
        local _challenge = G.challenge_tab or nil
        local _stake = G.forced_stake or G.PROFILES[G.SETTINGS.profile].MEMORY.stake or 1
        G.E_MANAGER:clear_queue()
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            no_delete = true,
            func = function()
            G:delete_run()
            G:start_run{stake = _stake, seed = _seed, challenge = _challenge}
            return true
            end
        }))
        G.forced_stake = nil
        G.challenge_tab = nil
        G.forced_seed = nil
    end
end

SMODS.Keybind {
    key = "quick_restart",
    key_pressed = 'r',
    action = function(self)
        if Sagatro.config.QuickRestart then
            Sagatro.quick_restart()
        end
    end
}

local sr = save_run
function save_run()
    if G.GAME.story_mode and G.GAME.sgt_no_saving then
        return
    end
    return sr()
end

function Sagatro.can_save()
    return G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.SHOP
end

function Sagatro.save_exclusion()
    return G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE ==
        G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.SMODS_REDEEM_VOUCHER or
        G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.ROUND_EVAL
end

---@param action "save"|"load"|"delete"
---@param index integer
function Sagatro.handle_save(action, index)
    if action == "save" and G.GAME.story_mode then
        if G.STAGE == G.STAGES.RUN then
            if Sagatro.can_save() then
                save_run()
            end
            if G.ARGS.save_run then
                G.ARGS.save_run.GAME.story_save_date = os.date("%d/%m/%Y %H:%M:%S")
                compress_and_save(G.SETTINGS.profile.."/"..Sagatro.save_name..index..".jkr", G.ARGS.save_run)
            end
        end
    elseif action == "load" then
        if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end
        if Sagatro.config.QuickRestart or Sagatro.debug or (Handy and Handy.animation_skip.should_skip_everything()) then
            G:delete_run()
            G.SAVED_GAME = get_compressed(G.SETTINGS.profile.."/"..Sagatro.save_name..index..".jkr")
            if G.SAVED_GAME ~= nil then
                G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME)
            end
            G:start_run({
                savetext = G.SAVED_GAME
            })
        else
            G.E_MANAGER:clear_queue()
            G.FUNCS.wipe_on()
            G.E_MANAGER:add_event(Event({
                no_delete = true,
                func = function()
                G:delete_run()
                return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                no_delete = true,
                func = function()
                    G.SAVED_GAME = get_compressed(G.SETTINGS.profile.."/"..Sagatro.save_name..index..".jkr")
                    if G.SAVED_GAME ~= nil then
                        G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME)
                    end
                    G:start_run({
                        savetext = G.SAVED_GAME
                    })
                return true
                end
            }))
            G.FUNCS.wipe_off()
        end
    elseif action == "delete" then
        love.filesystem.remove(G.SETTINGS.profile.."/"..Sagatro.save_name..index..".jkr")
    end
end

---@param from integer|string
---@param to integer|string
function Sagatro.set_goldia_stage(from, to)
    for _, goldia in ipairs(SMODS.find_card("j_sgt_goldia", true)) do
        if goldia.ability.immutable.stage == from then
            goldia.ability.immutable.stage = to
        end
    end
end

function Sagatro.game_over()
    if G.STAGE == G.STAGES.RUN and not G.GAME.game_over then
        G.GAME.game_over = true
        G.RESET_BLIND_STATES = true
        G.RESET_JIGGLES = true
        G.STATE = G.STATES.GAME_OVER
        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
        end
        G:save_settings()
        G.FILE_HANDLER.force = true
        G.STATE_COMPLETE = false
    end
end

function Sagatro.remove_temp_areas()
    for area, _ in pairs(Sagatro.temp_areas) do
        Sagatro.temp_areas[area]:remove()
        Sagatro.temp_areas[area] = nil
    end
end

---@param mod number
---@param operator "+"|"X"|"^"|"^^"|"^^^"|{hyper: number}|nil
---@param arbitrary boolean|nil
function Sagatro.modify_score(mod, operator, arbitrary)
    if not G.GAME.facing_blind then return end
    operator = operator or "+"
    if operator == "+" then
        G.GAME.chips = to_big(G.GAME.chips + mod)
    elseif operator == "X" and mod ~= 1 then
        G.GAME.chips = to_big(G.GAME.chips * mod)
    elseif operator == "^" and mod ~= 1 then
        G.GAME.chips = to_big(G.GAME.chips ^ mod)
    elseif operator == "^^" and Sagatro.mod_compat.talisman then
        G.GAME.chips = to_big(G.GAME.chips):arrow(2, mod)
    elseif operator == "^^^" and Sagatro.mod_compat.talisman then
        G.GAME.chips = to_big(G.GAME.chips):arrow(3, mod)
    elseif type(operator) == "table" and Sagatro.mod_compat.talisman then
        G.GAME.chips = to_big(G.GAME.chips):arrow(operator.hyper, mod)
    end
    G.FUNCS.chip_UI_set(G.hand_text_area.game_chips)
    G.hand_text_area.game_chips:juice_up()
    if arbitrary and to_big(G.GAME.chips) > to_big(G.GAME.blind.chips) then
        G.STATE = G.STATES.HAND_PLAYED
        G.STATE_COMPLETE = true
        end_round()
    end
end

local mod_mult_ref = mod_mult
function mod_mult(_mult)
    if G.GAME.inversed_scaling then
        _mult = math.max(_mult, 1)
    end
    return mod_mult_ref(_mult)
end

local mod_chips_ref = mod_chips
function mod_chips(_chips)
    if G.GAME.inversed_scaling then
        _chips = math.max(_chips, 0)
    end
    return mod_chips_ref(_chips)
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
    if (key == 'sgt_a_score' or key == 'sgt_ascore' or key == 'sgt_Ascore_mod') then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount)
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "+"..amount.." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_Ascore_mod' then
                if effect.ascore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.ascore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_a_score', amount, percent)
                end
            end
        end
        return true
    end
    if (key == 'sgt_x_score' or key == 'sgt_xscore' or key == 'sgt_Xscore_mod') then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount, "X")
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "X"..amount.." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_Ascore_mod' then
                if effect.xscore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.xscore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_x_score', amount, percent)
                end
            end
        end
        return true
    end
    if (key == 'sgt_e_score' or key == 'sgt_escore' or key == 'sgt_Escore_mod') then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount, "^")
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_Escore_mod' then
                if effect.escore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.escore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_e_score', amount, percent)
                end
            end
        end
        return true
    end
    if (key == 'sgt_ee_score' or key == 'sgt_eescore' or key == 'sgt_EEscore_mod') and Sagatro.mod_compat.talisman then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount, "^^")
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^"..amount.." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_EEscore_mod' then
                if effect.eescore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eescore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_ee_score', amount, percent)
                end
            end
        end
        return true
    end
    if (key == 'sgt_eee_score' or key == 'sgt_eeescore' or key == 'sgt_EEEscore_mod') and Sagatro.mod_compat.talisman then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount, "^^^")
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^^^"..amount.." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_EEEscore_mod' then
                if effect.eeescore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eeescore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_eee_score', amount, percent)
                end
            end
        end
        return true
    end
    if (key == 'sgt_hyper_score' or key == 'sgt_hyperscore' or key == 'sgt_hyperscore_mod') and Sagatro.mod_compat.talisman and type(amount) == "table" then
        if effect.card then juice_card(effect.card) end
        G.E_MANAGER:add_event(Event({func = function()
            Sagatro.modify_score(amount[2], {hyper = amount[1]})
        return true end}))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = ((amount[1] > 5 and ('{' .. amount[1] .. '}') or string.rep('^', amount[1])) .. amount[2]).." "..localize("k_score"), colour =  G.C.EDITION, edition = true})
            elseif key ~= 'sgt_hyperscore_mod' then
                if effect.eeescore_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.eeescore_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, 'sgt_hyper_score', amount, percent)
                end
            end
        end
        return true
    end
end

for _, v in ipairs{'sgt_e_mult','sgt_emult','sgt_Emult_mod'} do
    table.insert(SMODS.scoring_parameter_keys or SMODS.calculation_keys, v)
end
for _, v in ipairs{'sgt_a_score', 'sgt_ascore', 'sgt_Ascore_mod',
                    'sgt_x_score', 'sgt_xscore', 'sgt_Xscore_mod',
                    'sgt_e_score', 'sgt_escore', 'sgt_Escore_mod',
                    'sgt_ee_score', 'sgt_eescore', 'sgt_EEscore_mod',
                    'sgt_eee_score', 'sgt_eeescore', 'sgt_EEEscore_mod',
                    'sgt_hyper_score', 'sgt_hyperscore', 'sgt_hyperscore_mod'} do
    table.insert(SMODS.other_calculation_keys, v)
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

Sagatro.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "tm", padding = 0.1, colour = Sagatro.secondary_colour, minw = 8, minh = 6}, nodes = {
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.T, config = {scale = 0.5, text = localize('SGT_story_related_settings'), colour = G.C.WHITE}}
        }},
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', info = localize('SGT_disable_other_jokers_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, left = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_view_fish_properties'), ref_table = Sagatro.config, ref_value = 'ViewFishProperties', info = localize('SGT_view_fish_properties_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_lenient_score'), ref_table = Sagatro.config, ref_value = 'LenientScore', info = localize('SGT_lenient_score_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true}),
            }},
		}},
        {n=G.UIT.R, config = {minh = 0.04, minw = 4, colour = Sagatro.badge_colour}},
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.T, config = {scale = 0.5, text = localize('SGT_misc_settings'), colour = G.C.WHITE}}
        }},
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_disable_sagatro_items'), ref_table = Sagatro.config, ref_value = 'DisableSagatroItems', info = localize('SGT_disable_sagatro_items_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_sagatro_music'), ref_table = Sagatro.config, ref_value = 'SagatroMusic', info = localize('SGT_sagatro_music_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true}),
            }},
        }},
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_quick_restart'), ref_table = Sagatro.config, ref_value = 'QuickRestart', info = localize('SGT_quick_restart_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                create_toggle({label = localize('SGT_ortagas'), ref_table = Sagatro.config, ref_value = 'Ortagas', info = localize('SGT_ortagas_desc'), active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, right = true, callback = function() if menu_refresh and G.title_top then menu_refresh() end end}),
            }},
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
        if G.GAME.blind then
            if G.GAME.blind.config.blind.key == "bl_sgt_black_oil" and not G.GAME.blind.disabled then
                return 1
            end
        end
        local triggers = jdcct(card, scoring_hand, held_in_hand)
        triggers = triggers + (card:get_seal() == 'sgt_Blood' and 2 or 0)
        return triggers
    end

    local jdcjt = JokerDisplay.calculate_joker_triggers
    JokerDisplay.calculate_joker_triggers = function(card)
        if card.debuff then
            return 0
        end
        if G.GAME.blind then
            if G.GAME.blind.config.blind.key == "bl_sgt_black_oil" and not G.GAME.blind.disabled then
                return 1
            end
        end
        return jdcjt(card)
    end

    local jdgda = JokerDisplay.get_display_areas
    function JokerDisplay.get_display_areas()
        local ret = jdgda()
        if not table.contains(ret, G.consumeables) then
            ret[#ret+1] = G.consumeables
        end
        return ret
    end

    local jdcjm = JokerDisplay.calculate_joker_modifiers
    JokerDisplay.calculate_joker_modifiers = function(card)
        local modifiers = jdcjm(card)
        if card.ability.immutable and (card.ability.immutable.eaten_stack or 0) > 0 then
            modifiers.chips = (modifiers.chips or 0) + 10*card.ability.immutable.eaten_stack
            modifiers.mult = (modifiers.mult or 0) + 5*card.ability.immutable.eaten_stack
        end
        return modifiers
    end

    local jd_toggle_ref = Card.joker_display_toggle
    function Card:joker_display_toggle()
        if not Sagatro.jd_toggle_override and Sagatro.storyline_check("alice_in_mirrorworld")
        and self.config.center_key ~= "j_sgt_mirror" then
            if (self.config.center.mirrorworld and not G.GAME.inversed_scaling)
            or (not self.config.center.mirrorworld and G.GAME.inversed_scaling and not self.ability.sgt_mirrored) then
                return
            end
        end
        jd_toggle_ref(self)
    end
end

local card_click = Card.click
function Card:click()
    card_click(self)
    if self.sagatro_target then
        G.FUNCS.openModUI_Sagatro{config = {page = "mod_desc", fromAlice = true}}
    end
end

local card_single_tap = Card.single_tap
function Card:single_tap()
    if card_single_tap then
        card_single_tap(self)
    end
    if self.sagatro_target then
        G.FUNCS.openModUI_Sagatro{config = {page = "mod_desc", fromAlice = true}}
    end
end

-- Debug territory
function Sagatro.help()
    if Sagatro.debug then
        print("Sagatro debug commands:")
        print("Sagatro.help() or help(): show this help screen.")
        print("Sagatro.DT_boss(blind_key): Reroll the boss to the specified one.")
        print("Sagatro.DT_isl(storyline_name, options): Instantly initialize storyline_name. Pass a table to options for finer control over storyline state.")
        print("Sagatro.DT_rarity(): print out modifications of each rarity pool.")
        print("Sagatro.DT_event(): show event queue and list of finished events.")
        print("Sagatro.DT_i(): Prints debug info Sagatro will give in crash screen.")
        print("Sagatro.DT_guaranteed(): Spawns Hansel's Cheat Dice at roll number six.")
        print("Sagatro.DT_1h(): set hand count to 1.")
        print("Sagatro.DT_0d(): set discard count to 0.")
        print("Sagatro.crash() or crash(): manually cause a crash.")
        return "Remember to always prepend 'eval' because that's how DebugPlus executes lua code directly. I don't really want to dwell with DebugPlus' built-in feature to execute commands."
    end
    return "Debug commands are unavailable."
end

help = help or Sagatro.help

function Sagatro.DT_boss(blind_key)
    if blind_key and G.P_BLINDS[blind_key]
    and G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts then
        G.FORCE_BOSS = blind_key
        G.from_boss_tag = true
        G.FUNCS.reroll_boss()
        G.FORCE_BOSS = nil
    end
end

function Sagatro.DT_isl(storyline_name, options)
    if Sagatro.debug then
        options = options or {}
        if Sagatro.storyline_check("none") then
            if storyline_name == "alice_in_wonderland" then
                SMODS.add_card{key = "j_sgt_white_rabbit"}
            elseif storyline_name == "20k_miles_under_the_sea" then
                SMODS.add_card{key = "j_sgt_lincoln_ship"}
            elseif storyline_name == "alice_in_mirrorworld" then
                SMODS.add_card{key = "j_sgt_white_rabbit"}
                SMODS.add_card{key = "j_sgt_mirror"}
            elseif storyline_name == "pocket_mirror" then
                SMODS.add_card{key = "j_sgt_goldia"}
                if options.transform then
                    Sagatro.progress_storyline("goldia_transformation", "add", "pocket_mirror", G.GAME.interwoven_storyline)
                    SMODS.add_card{key = "j_sgt_pocket_mirror"}
                    SMODS.add_card{key = "j_sgt_knife_fork"}
                    SMODS.add_card{key = "j_sgt_rose_bell"}
                    SMODS.add_card{key = "j_sgt_moon_hairbrush"}
                    SMODS.add_card{key = "j_sgt_snow_scissors"}
                    SMODS.add_card{key = "j_sgt_angel_scythe"}
                end
            end
            return "Initialized '"..storyline_name.."'"
        end
        return "Not in story mode or there's already an active storyline."
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT_rarity()
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

function Sagatro.DT_event()
    if Sagatro.debug then
        local queue = next(G.GAME.saga_event_queue) and table.concat(G.GAME.saga_event_queue, ", ") or "empty"
        local finished = next(G.GAME.saga_finished_events) and table.concat(G.GAME.saga_finished_events, ", ") or "empty"
        print("Current storyline:", G.GAME.current_storyline)
        print("Interwoven storyline:", G.GAME.interwoven_storyline or "none")
        print("Event queue:", queue)
        print("Finished events:", finished)
        return "First event in queue is usually the active one."
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT_i()
    if Sagatro.debug then
        return Sagatro.debug_info
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT_guaranteed()
    if Sagatro.debug then
        if G.STAGE == G.STAGES.RUN then
            if not next(Sagatro.find_active_card("j_sgt_hansels_cheat_dice")) then
                local dice = SMODS.add_card{key = "j_sgt_hansels_cheat_dice", edition = "e_negative"}
                dice.ability.immutable.current_roll = 6
                dice.ability.immutable.debug_guaranteed = true
            else
                for _, dice in ipairs(Sagatro.find_active_card("j_sgt_hansels_cheat_dice")) do
                    dice.ability.immutable.current_roll = 6
                    dice.ability.immutable.debug_guaranteed = true
                end
            end
            return "Enabled guaranteed probability."
        end
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT_1h()
    if Sagatro.debug then
        ease_hands_played(-G.GAME.current_round.hands_left + 1)
        return "Successfully set hand count to 1."
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT_0d()
    if Sagatro.debug then
        ease_discard(-G.GAME.current_round.discards_left)
        return "Successfully set discard count to 0."
    end
    return "Debug commands are unavailable."
end

function Sagatro.DT()
    Sagatro.debug = not Sagatro.debug
    return Sagatro.debug and "Sagatro debug mode enabled." or "Sagatro debug mode disabled."
end

function Sagatro.crash()
    if Sagatro.debug then
        Sagatro.cause_crash = true
    end
    return not Sagatro.debug and "Are you sure you want to do this? Thankfully Sagatro debug mode is off. Turn it on before executing this command." or "Crashing game..."
end

crash = crash or Sagatro.crash