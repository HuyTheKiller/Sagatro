G.FUNCS.saga_tutorial_controller = function(reset)
    if reset then --yay, better debug reenabling
        G.SETTINGS.saga_tutorial_complete = nil
        G.SETTINGS.saga_tutorial_progress =
        {
            forced_shop = {'j_sgt_shepherd_boy', 'j_sgt_little_prince'},
            hold_parts = {},
            completed_parts = {},
        }
        return "Reenabled Saga tutorial."
    end
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.saga_tutorial_complete = true
        G.SETTINGS.saga_tutorial_progress = nil
        G.GAME.modifiers.sgt_no_tags = nil
        return
    end
    G.SETTINGS.saga_tutorial_progress = G.SETTINGS.saga_tutorial_progress or
    {
        forced_shop = {'j_sgt_shepherd_boy', 'j_sgt_little_prince'},
        hold_parts = {},
        completed_parts = {},
    }
    G.GAME.modifiers.sgt_no_tags = true
    if not G.SETTINGS.paused and not G.SETTINGS.saga_tutorial_complete then
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.saga_tutorial_progress.completed_parts['small_blind'] then
            G.SETTINGS.saga_tutorial_progress.section = 'small_blind'
            G.FUNCS.saga_tutorial_part('small_blind')
            G.SETTINGS.saga_tutorial_progress.completed_parts['small_blind']  = true
            G:save_progress()
        end
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.saga_tutorial_progress.completed_parts['big_blind'] and G.GAME.round > 0 then
            G.SETTINGS.saga_tutorial_progress.section = 'big_blind'
            G.FUNCS.saga_tutorial_part('big_blind')
            G.SETTINGS.saga_tutorial_progress.completed_parts['big_blind']  = true
            G:save_progress()
        end
        if G.SETTINGS.saga_tutorial_progress.hold_parts['big_blind'] then
            G.SETTINGS.saga_tutorial_complete = true
            G.GAME.modifiers.sgt_no_tags = nil
        end
        if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.saga_tutorial_progress.completed_parts['first_hand'] then
            G.SETTINGS.saga_tutorial_progress.section = 'first_hand'
            G.FUNCS.saga_tutorial_part('first_hand')
            G.SETTINGS.saga_tutorial_progress.completed_parts['first_hand']  = true
            G:save_progress()
        end
        if G.STATE == G.STATES.SHOP and G.shop and G.shop.VT.y < 5 then
            if not G.SETTINGS.saga_tutorial_progress.completed_parts['shop_1'] then
                G.SETTINGS.saga_tutorial_progress.section = 'shop_1'
                G.FUNCS.saga_tutorial_part('shop_1')
                G.SETTINGS.saga_tutorial_progress.completed_parts['shop_1']  = true
                G:save_progress()
            elseif G.SETTINGS.saga_tutorial_progress.completed_parts['booster'] and not G.SETTINGS.saga_tutorial_progress.completed_parts['shop_2'] then
                G.SETTINGS.saga_tutorial_progress.section = 'shop_2'
                G.FUNCS.saga_tutorial_part('shop_2')
                G.SETTINGS.saga_tutorial_progress.completed_parts['shop_2']  = true
                G:save_progress()
            end
        end
        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.story_starter and G.pack_cards and G.pack_cards.cards[1]
        and G.pack_cards.cards[1].dissolve == 0 and not G.SETTINGS.saga_tutorial_progress.completed_parts['booster'] then
            G.SETTINGS.saga_tutorial_progress.section = 'booster'
            G.FUNCS.saga_tutorial_part('booster')
            G.SETTINGS.saga_tutorial_progress.completed_parts['booster']  = true
            G:save_progress()
        end
    end
end

G.FUNCS.saga_tutorial_part = function(_part)
    local step = 1
    G.SETTINGS.paused = true
    if _part == 'small_blind' then
        step = saga_tutorial_info({
            text_key = 'sgt_sb_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_sb_2',
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            highlight = {
                G.blind_select.UIRoot.children[1].children[1]
            },
            snap_to = function()
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1]
                and G.blind_select.UIRoot.children[1].children[1] and G.blind_select.UIRoot.children[1].children[1].config.object then
                    return G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            step = step,
            no_button = true,
            button_listen = 'select_blind',
        })
    elseif _part == 'big_blind' then
        step = saga_tutorial_info({
            text_key = 'sgt_bb_1',
            hard_set = true,
            attach = {major =  G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'first_hand' then
        step = saga_tutorial_info({
            text_key = 'sgt_fh_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_fh_2',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_fh_3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'shop_1' then
        step = saga_tutorial_info({
            hard_set = true,
            text_key = 'sgt_s_1',
            highlight = {
                G.shop_booster.cards[1],
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 1}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_s_2',
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 1}},
            step = step,
        })
    elseif _part == 'shop_2' then
        step = saga_tutorial_info({
            hard_set = true,
            text_key = 'sgt_s_3',
            loc_vars = {localize(Sagatro.storyline_locmap[G.GAME.current_storyline])},
            highlight = {
                G.jokers.cards[1],
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 4, y = 4}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_s_4',
            highlight = {
                G.jokers.cards[1],
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 4, y = 4}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_s_5',
            highlight = {
                G.shop_jokers.cards[1],
                G.shop_jokers.cards[2],
            },
            attach = {major = G.deck, type = 'tm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_s_6',
            highlight = {
                G.HUD:get_UIE_by_ID("options_button")
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 1}},
            snap_to = function()
                return G.HUD:get_UIE_by_ID("options_button")
            end,
            step = step,
            no_button = true,
            button_listen = 'options',
        })
    elseif _part == 'booster' then
        step = saga_tutorial_info({
            text_key = 'sgt_bp_1',
            highlight = function() return {
                G.pack_cards.cards[1],
                G.pack_cards.cards[2],
            } end,
            attach = {major = G.pack_cards, type = 'tm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_bp_2',
            highlight = function() return {
                G.pack_cards.cards[1],
                G.pack_cards.cards[2],
            } end,
            attach = {major = G.pack_cards, type = 'tm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = saga_tutorial_info({
            text_key = 'sgt_bp_3',
            attach = {major = G.pack_cards, type = 'tm', offset = {x = 0, y = -2}},
            step = step,
        })
    end

    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = 'REAL',
        func = function()
            if (G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete) or G.OVERLAY_TUTORIAL.skip_steps then
                if G.OVERLAY_TUTORIAL.Alice then G.OVERLAY_TUTORIAL.Alice:remove() end
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                G.OVERLAY_TUTORIAL:remove()
                G.OVERLAY_TUTORIAL = nil
                G.SETTINGS.saga_tutorial_progress.hold_parts[_part]=true
                return true
            end
            return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial')
    G.SETTINGS.paused = false
end

G.FUNCS.saga_tut_next = function(e)
    if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.Alice then
        G.OVERLAY_TUTORIAL.Alice:remove_button()
        G.OVERLAY_TUTORIAL.Alice:remove_speech_bubble()
        G.OVERLAY_TUTORIAL.step_complete = false
        G.OVERLAY_TUTORIAL.step = G.OVERLAY_TUTORIAL.step+1
    end
end

G.FUNCS.skip_saga_tutorial_section = function(e)
    G.OVERLAY_TUTORIAL.skip_steps = true
    if G.OVERLAY_TUTORIAL.Alice then G.OVERLAY_TUTORIAL.Alice:remove() end
    if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
    G.OVERLAY_TUTORIAL:remove()
    G.OVERLAY_TUTORIAL = nil
    G.E_MANAGER:clear_queue('tutorial')
    if G.SETTINGS.saga_tutorial_progress.section == 'small_blind' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['small_blind']  = true
        G.GAME.modifiers.sgt_no_tags = nil
    elseif G.SETTINGS.saga_tutorial_progress.section == 'big_blind' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['big_blind']  = true
    elseif G.SETTINGS.saga_tutorial_progress.section == 'first_hand' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['first_hand']  = true
    elseif G.SETTINGS.saga_tutorial_progress.section == 'shop_1' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['shop_1']  = true
    elseif G.SETTINGS.saga_tutorial_progress.section == 'shop_2' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['shop_2']  = true
    elseif G.SETTINGS.saga_tutorial_progress.section == 'booster' then
        G.SETTINGS.saga_tutorial_progress.completed_parts['booster']  = true
    end
end

function saga_tutorial_info(args)
    local overlay_colour = {0.32,0.36,0.41,0}
    ease_value(overlay_colour, 4, 0.6, nil, 'REAL', true,0.4)
    G.OVERLAY_TUTORIAL = G.OVERLAY_TUTORIAL or UIBox{
        definition = {n=G.UIT.ROOT, config = {align = "cm", padding = 32.05, r=0.1, colour = overlay_colour, emboss = 0.05}, nodes={
            {n=G.UIT.R, config={align = "tr", minh = G.ROOM.T.h, minw = G.ROOM.T.w}, nodes={
                UIBox_button{label = {localize('b_skip').." >"}, button = "skip_saga_tutorial_section", minw = 1.3, scale = 0.45, colour = G.C.JOKER_GREY}
            }}
        }},
        config = {
            align = "cm",
            offset = {x=0,y=3.2},
            major = G.ROOM_ATTACH,
            bond = 'Weak'
          }
      }
    G.OVERLAY_TUTORIAL.step = G.OVERLAY_TUTORIAL.step or 1
    G.OVERLAY_TUTORIAL.step_complete = false
    local row_dollars_chips = G.HUD:get_UIE_by_ID('row_dollars_chips')
    local align = args.align or "tm"
    local step = args.step or 1
    local attach = args.attach or {major = row_dollars_chips, type = 'tm', offset = {x=0, y=-0.5}}
    local pos = args.pos or {x=attach.major.T.x + attach.major.T.w/2, y=attach.major.T.y + attach.major.T.h/2}
    pos.center = "j_sgt_alice"
    pos.materialize_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]}
    pos.particle_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]}
    local button = args.button or {button = localize('b_next'), func = 'saga_tut_next'}
    args.highlight = args.highlight or {}
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete then
                G.CONTROLLER.interrupt.focus = true
                G.OVERLAY_TUTORIAL.Alice = G.OVERLAY_TUTORIAL.Alice or Card_Character(pos)
                if type(args.highlight) == 'function' then args.highlight = args.highlight() end
                args.highlight[#args.highlight+1] = G.OVERLAY_TUTORIAL.Alice
                G.OVERLAY_TUTORIAL.Alice:add_speech_bubble(args.text_key, align, args.loc_vars)
                G.OVERLAY_TUTORIAL.Alice:set_alignment(attach)
                if args.hard_set then G.OVERLAY_TUTORIAL.Alice:hard_set_VT() end
                G.OVERLAY_TUTORIAL.button_listen = nil
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                if args.content then
                    G.OVERLAY_TUTORIAL.content = UIBox{
                        definition = args.content(),
                        config = {
                            align = args.content_config and args.content_config.align or "cm",
                            offset = args.content_config and args.content_config.offset or {x=0,y=0},
                            major = args.content_config and args.content_config.major or G.OVERLAY_TUTORIAL.Alice,
                            bond = 'Weak'
                          }
                      }
                    args.highlight[#args.highlight+1] = G.OVERLAY_TUTORIAL.content
                end
                if args.button_listen then G.OVERLAY_TUTORIAL.button_listen = args.button_listen end
                if not args.no_button then G.OVERLAY_TUTORIAL.Alice:add_button(button.button, button.func, button.colour, button.update_func, true) end
                G.OVERLAY_TUTORIAL.Alice:say_stuff(2*(#(G.localization.misc.tutorial[args.text_key] or {}))+1)
                if args.snap_to then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false, blockable = false,
                        func = function()
                            if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.Alice and not G.OVERLAY_TUTORIAL.Alice.talking then
                            local _snap_to = args.snap_to()
                            if _snap_to then
                                G.CONTROLLER.interrupt.focus = false
                                G.CONTROLLER:snap_to({node = args.snap_to()})
                            end
                            return true
                            end
                        end
                    }), 'tutorial')
                end
                if args.highlight then G.OVERLAY_TUTORIAL.highlights = args.highlight end
                G.OVERLAY_TUTORIAL.step_complete = true
            end
            return not G.OVERLAY_TUTORIAL or G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial')
    return step+1
end