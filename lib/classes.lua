---@param func_list (fun(): (number?, (fun(): boolean)?))[] An array of functions that may return the delay value and/or a function that returns boolean.
---@param delay number Delay between each function.
---@param use_delay boolean Set to `true` to allow `delay` to be used.
---@param index? integer Internal counter to traverse the array, as well as controlling the recursion.
--- Recursive helper function to execute functions one by one, utilizing events.
--- Direct invocation is not recommended.
function Sagatro.recursive_chain(func_list, delay, use_delay, index)
    index = index or 1
    Sagatro.EventChainUtils.new_chain_delay = nil
    Sagatro.EventChainUtils.chain_block = nil
    G.CONTROLLER.locks.executing_chain = true
    if index == 1 then
        G.EVENT_CHAIN_INTERRUPT = G.STATE
        G.STATE = G.STATES.PLAY_TAROT
        G.GAME.sgt_no_saving = true
    elseif index > #func_list then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = delay*G.SETTINGS.GAMESPEED,
            func = function()
                G.CONTROLLER.locks.executing_chain = nil
                Sagatro.EventChainUtils.chain_key = nil
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
        delay = use_delay and delay*G.SETTINGS.GAMESPEED or 0,
        func = function()
            local new_delay, check
            if not Sagatro.EventChainUtils.chain_block then
                new_delay, check = func_list[index]()
                if check then
                    Sagatro.EventChainUtils.new_chain_delay = new_delay
                    Sagatro.EventChainUtils.chain_block = check
                    G.CONTROLLER.locks.executing_chain = nil
                end
            end
            if not Sagatro.EventChainUtils.chain_block
            or (Sagatro.EventChainUtils.chain_block
            and Sagatro.EventChainUtils.chain_block()) then
                Sagatro.recursive_chain(func_list, Sagatro.EventChainUtils.new_chain_delay or new_delay or delay, true, index+1)
                return true
            end
        end
    }))
end

---@param key string
--- Execute a registered event chain.\
--- Invoke directly to perform at an arbitrary time.
--- Otherwise, set `G.GAME.shelved_chain` to `key` to automatically
--- invoke at end of round, before all other end-of-round calculations.
--- Or, set `G.GAME.shelved_chain_hdrawn` to `key` to automatically
--- invoke after hand is drawn during a blind.
function Sagatro.execute_chain(key)
    local event_chain = Sagatro.EventChains[key]
    if not event_chain then
        sendWarnMessage(("Cannot execute %s: Does not exist."):format(key), Sagatro.EventChain.set)
        return
    end
    if Sagatro.EventChainUtils.chain_key then
        sendWarnMessage(("Cannot execute %s: Another chain (%s) is ongoing."):format(key, Sagatro.EventChainUtils.chain_key), Sagatro.EventChain.set)
        return
    end
    Sagatro.EventChainUtils.chain_key = event_chain.key
    Sagatro.recursive_chain(event_chain.func_list, event_chain.delay, event_chain.first_delay)
end

Sagatro.EventChains = {}
Sagatro.EventChainUtils = {}
Sagatro.EventChain = SMODS.GameObject:extend{
    obj_table = Sagatro.EventChains,
    obj_buffer = {},
    set = "EventChain",
    required_params = {
        "key",
    },
    delay = 0.8,
    first_delay = false,
    func_list = {},
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
            Sagatro.temp_music_volume = G.SETTINGS.SOUND.music_volume
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = G.SETTINGS.SOUND,
                ref_value = 'music_volume',
                ease_to = 0,
                delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                func = (function(t) return t end)
            }))
            local fleta = SMODS.find_card("j_sgt_fleta", true)[1]
            if fleta then
                play_sound('sgt_fleta_tantrum', 1, 0.4)
                fleta:juice_up()
                return table.size(fleta.ability.immutable.completed) >= 2 and 1.6 or 0.8
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
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.SETTINGS.SOUND,
                    ref_value = 'music_volume',
                    ease_to = Sagatro.temp_music_volume,
                    delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                    func = (function(t) return t end)
                }))
                Sagatro.temp_music_volume = nil
            end
            G.GAME.modifiers.sgt_no_tags = nil
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                goldia.ability.immutable.plot_armor = true
            end
            Sagatro.progress_storyline("fleta_challenges", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("entering_mirror_maze", "add", "pocket_mirror", G.GAME.inverwoven_storyline)
            return 0
        end,
    },
}

Sagatro.EventChain{
    key = "harpae_ending",
    func_list = {
        function()
            Sagatro.temp_music_volume = G.SETTINGS.SOUND.music_volume
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = G.SETTINGS.SOUND,
                ref_value = 'music_volume',
                ease_to = 0,
                delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                func = (function(t) return t end)
            }))
            local harpae = SMODS.find_card("j_sgt_harpae", true)[1]
            if harpae then
                if not harpae.ability.immutable.blindness then
                    play_sound("sgt_harpae_crying", 1, 0.5)
                    harpae:juice_up()
                end
                return (harpae.ability.immutable.bad_end or harpae.ability.immutable.blindness) and 0.8 or 2.5
            end
        end,
        function()
            local harpae = SMODS.find_card("j_sgt_harpae", true)[1]
            if harpae and not (harpae.ability.immutable.bad_end or harpae.ability.immutable.blindness) then
                play_sound('timpani')
                SMODS.add_card{key = "j_sgt_moon_hairbrush"}
                return 0.8
            end
            if harpae and harpae.ability.immutable.blindness then
                local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
                if goldia then
                    local harpae_pos, goldia_pos = Sagatro.get_pos(harpae), Sagatro.get_pos(goldia)
                    if harpae_pos > goldia_pos then
                        for _ = harpae_pos, goldia_pos + 2, -1 do
                            Sagatro.swap(harpae, "left")
                        end
                    else
                        for _ = harpae_pos, goldia_pos - 2 do
                            Sagatro.swap(harpae)
                        end
                    end
                    ease_background_colour{new_colour = G.C.SUBMARINE_DEPTH[5], contrast = 1}
                end
            end
            return 1.7
        end,
        function()
            local harpae = SMODS.find_card("j_sgt_harpae", true)[1]
            if harpae then
                if harpae.ability.immutable.blindness then
                    G.SETTINGS.SOUND.music_volume = Sagatro.temp_music_volume or 50
                    Sagatro.temp_music_volume = nil
                    G:save_settings()
                    -- game over screen blocks the Notification box from appearing for some reason
                    -- this notify_alert call serves as a scapegoat, allowing the real one to be on a proper queue
                    notify_alert("ach_sgt_pm_bad_end_2")
                    check_for_unlock{type = "pm_bad_end_2"}
                    Sagatro.game_over("ph_eternal_blindness")
                    return 0
                end
                harpae:shatter()
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.SETTINGS.SOUND,
                    ref_value = 'music_volume',
                    ease_to = Sagatro.temp_music_volume,
                    delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                    func = (function(t) return t end)
                }))
                Sagatro.temp_music_volume = nil
            end
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                goldia.ability.immutable.plot_armor = nil
            end
            Sagatro.progress_storyline("harpae_patience", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
        end,
    },
}

Sagatro.EventChain{
    key = "lisette_ending",
    func_list = {
        function()
            Sagatro.temp_music_volume = G.SETTINGS.SOUND.music_volume
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = G.SETTINGS.SOUND,
                ref_value = 'music_volume',
                ease_to = 0,
                delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                func = (function(t) return t end)
            }))
            for i, lisette in ipairs(SMODS.find_card("j_sgt_lisette", true)) do
                if i ~= 1 then
                    lisette:remove()
                end
            end
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            local lisette = SMODS.find_card("j_sgt_lisette", true)[1]
            if lisette then
                play_sound("sgt_lisette_laughcrying", 1, 0.5)
                lisette.executing_ending = true
                lisette:juice_up()
                return goldia and goldia.ability.immutable.tolerance_index < 5 and 0.8 or 18.7
            end
        end,
        function()
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            local lisette = SMODS.find_card("j_sgt_lisette", true)[1]
            if lisette then
                if goldia and goldia.ability.immutable.tolerance_index >= 5 then
                    play_sound('timpani')
                    SMODS.add_card{key = "j_sgt_snow_scissors"}
                    return 0.8
                end
                return 18.7
            end
        end,
        function()
            local lisette = SMODS.find_card("j_sgt_lisette", true)[1]
            if lisette then
                lisette:shatter()
                Sagatro.progress_storyline("dull_glass", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
                Sagatro.progress_storyline("door_puzzle", "add", "pocket_mirror", G.GAME.interwoven_storyline)
                G.GAME.cleaning_up_mirror = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.SETTINGS.SOUND,
                    ref_value = 'music_volume',
                    ease_to = Sagatro.temp_music_volume,
                    delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                    func = (function(t) return t end)
                }))
                Sagatro.temp_music_volume = nil
                return 0
            end
        end,
    },
}

Sagatro.EventChain{
    key = "door_puzzle_prep",
    delay = 0,
    func_list = {
        function()
            G.FUNCS.draw_from_hand_to_discard()
            return 0
        end,
        function()
            G.FUNCS.draw_from_discard_to_deck()
            return 0
        end,
        function()
            Sagatro.temp_music_volume = G.SETTINGS.SOUND.music_volume
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = G.SETTINGS.SOUND,
                ref_value = 'music_volume',
                ease_to = 0,
                delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                func = (function(t) return t end)
            }))
            G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) - G.hand.config.card_limit
            G.hand:change_size(-G.hand.config.card_limit)
            ease_background_colour{new_colour = G.C.SUBMARINE_DEPTH[5], contrast = 1}
            return 1
        end,
        function()
            G.GAME.door_order = {"red", "blue", "green", "green", "yellow", "blue", "red"}
            G.GAME.door_completed = {}
            for _, colour in ipairs(G.GAME.door_order) do
                local card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('predoorpuz')),
                center = G.P_CENTERS.m_sgt_pm_door}, G.play, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                card:flip()
                card.ability.door_colour = colour
            end
            return 1
        end,
        function()
            local i = 1
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 2
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 3
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 4
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 5
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 6
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 0.5
        end,
        function()
            local i = 7
            local v = G.play.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.play.cards-0.998)*0.3
            if v.facing == "back" then
                v:flip()
                play_sound('tarot2', percent, 0.6)
            end
            return 5
        end,
        function()
            SMODS.destroy_cards(G.play.cards, nil, true)
            return 0.2
        end,
        function()
            local colours = {"yellow", "red", "green", "blue"}
            for i = 1, 4 do
                local card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('doorpuz')),
                center = G.P_CENTERS.m_sgt_pm_door}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                card.ability.door_colour = colours[i]
            end
            G.GAME.old_play_limit = G.hand.config.highlighted_limit
            SMODS.change_play_limit(1 - G.hand.config.highlighted_limit)
            ease_hands_played(7 - G.GAME.round_resets.hands, true)
            ease_discard(-G.GAME.round_resets.discards, true, true)
            G.GAME.delay_door_puzzle_colour = nil
            ease_background_colour_blind(G.STATE)
            G.SETTINGS.SOUND.music_volume = Sagatro.temp_music_volume or 50
            Sagatro.temp_music_volume = nil
            G.GAME.solving_door_puzzle = true
            return 0
        end,
    },
}

Sagatro.EventChain{
    key = "platinum_ending",
    func_list = {
        function()
            Sagatro.progress_storyline("goldia_transformation", "add", "pocket_mirror", G.GAME.interwoven_storyline)
            Sagatro.temp_music_volume = G.SETTINGS.SOUND.music_volume
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = G.SETTINGS.SOUND,
                ref_value = 'music_volume',
                ease_to = 0,
                delay = 1*(G.STAGE == G.STAGES.RUN and G.SETTINGS.GAMESPEED or 1),
                func = (function(t) return t end)
            }))
        end,
        function()
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                Sagatro.unhighlight_all()
                goldia.area:add_to_highlighted(goldia)
            end
            return 1, function()
                if G.GAME.goldia_transformation_complete then
                    G.GAME.goldia_transformation_complete = nil
                    return true
                end
            end
        end,
        function()
            local enjel = SMODS.find_card("j_sgt_enjel", true)[1]
            if enjel then
                local enjel_pos = Sagatro.get_pos(enjel)
                for _ = enjel_pos, #G.jokers.cards - 1 do
                    Sagatro.swap(enjel)
                end
            end
            return 1.5
        end,
        function()
            local platinum, enjel = SMODS.find_card("j_sgt_platinum", true)[1], SMODS.find_card("j_sgt_enjel", true)[1]
            if platinum and enjel then
                local platinum_pos, enjel_pos = Sagatro.get_pos(platinum), Sagatro.get_pos(enjel)
                if platinum_pos > enjel_pos then
                    for _ = platinum_pos, enjel_pos + 2, -1 do
                        Sagatro.swap(platinum, "left")
                    end
                else
                    for _ = platinum_pos, enjel_pos - 2 do
                        Sagatro.swap(platinum)
                    end
                end
            end
            return 2
        end,
        function()
            local enjel = SMODS.find_card("j_sgt_enjel", true)[1]
            if enjel then
                enjel.ability.platinum_reflection = true
                play_sound('timpani')
                enjel:juice_up()
            end
        end,
    }
}