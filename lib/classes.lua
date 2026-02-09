function Sagatro.recursive_chain(func_list, delay, use_delay, index)
    index = index or 1
    if index == 1 then
        G.CONTROLLER.locks.executing_chain = true
        G.EVENT_CHAIN_INTERRUPT = G.STATE
        G.STATE = G.STATES.PLAY_TAROT
        G.GAME.sgt_no_saving = true
    elseif index > #func_list then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = delay*G.SETTINGS.GAMESPEED,
            func = function()
                G.CONTROLLER.locks.executing_chain = nil
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
            local new_delay = func_list[index]()
            Sagatro.recursive_chain(func_list, new_delay or delay, true, index+1)
            return true
        end
    }))
end

function Sagatro.execute_chain(key)
    local event_chain = Sagatro.EventChains[key]
    if not event_chain then
        sendWarnMessage(("Cannot execute %s: Does not exist."):format(key), Sagatro.EventChain.set)
        return
    end
    Sagatro.recursive_chain(event_chain.func_list, event_chain.delay, event_chain.first_delay)
end

Sagatro.EventChains = {}
Sagatro.EventChain = SMODS.GameObject:extend{
    obj_table = Sagatro.EventChains,
    obj_buffer = {},
    set = "EventChain",
    required_params = {
        "key",
        "func_list",
    },
    delay = 0.8,
    first_delay = false,
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
                Sagatro.progress_storyline("colored_door_riddle", "add", "pocket_mirror", G.GAME.interwoven_storyline)
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