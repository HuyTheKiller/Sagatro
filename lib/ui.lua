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

-- Ortalab Mythos UI - modified to be interative with Void Hole
local gcu = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ui = gcu(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if (((_c.set == "Celestara" and _c.key ~= "c_sgt_soltera") or _c.key == "c_sgt_void_hole") and (card and card.area and not card.area.config.collection or _c.discovered)) then
        local key = (card and card.hand_type_trigger or _c.key).."_effect"
        local celestara_nodes = {background_colour = lighten(G.C.SGT_CELESTARA, 0.75)}
        local vars = G.P_CENTERS[card and card.hand_type_trigger or _c.key]:loc_vars({}).vars
        local consume = _c.key == "c_sgt_void_hole" and "void_hole_consume" or "celestara_consume"
        localize{type = "descriptions", set = "Celestara", key = "celestara_heading", nodes = celestara_nodes, vars = vars}
        localize{type = "descriptions", set = "Celestara", key = key, nodes = celestara_nodes, vars = vars}
        if _c.key ~= "c_sgt_void_hole" or (card and card.hand_type_trigger == "c_sgt_void_hole") then
            localize{type = "descriptions", set = "Celestara", key = consume, nodes = celestara_nodes, vars = {}}
        end
        ui[Ortalab and "mythos" or "celestara"] = celestara_nodes
    end
    if G.GAME.story_mode and card then
        if _c.key == "j_sgt_submarine" then
            local submarine_nodes = {background_colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.25)}
            local vars = card.config.center:loc_vars({}, card).vars
            localize{type = "descriptions", set = "Other", key = "sgt_submarine_states", nodes = submarine_nodes, vars = vars}
            ui[Ortalab and "mythos" or "celestara"] = submarine_nodes
        elseif _c.key == "j_sgt_sub_engineer" and Sagatro.storyline_check("20k_miles_under_the_sea") then
            local sub_engi_nodes = {background_colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_sub_engineer", nodes = sub_engi_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = sub_engi_nodes
        elseif _c.key == "j_sgt_mirror" and Sagatro.storyline_check("alice_in_wonderland") then
            local mirror_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_mirror", nodes = mirror_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = mirror_nodes
        elseif _c.mirrorworld and _c.discovered and not G.GAME.inversed_scaling and Sagatro.storyline_check("alice_in_mirrorworld") then
            local mirrorworld_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_mirrorworld", nodes = mirrorworld_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = mirrorworld_nodes
        elseif not _c.mirrorworld and _c.discovered and G.GAME.inversed_scaling and Sagatro.storyline_check("alice_in_mirrorworld") then
            local realworld_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_realworld", nodes = realworld_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = realworld_nodes
        elseif card.ability.immutable and Sagatro.config.ViewFishProperties then
            if card.ability.immutable.weight_level then
                local fish_nodes = {background_colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.25)}
                local vars = card.config.center:loc_vars({}, card).fish_vars
                vars[2] = type(vars[2]) == "number"
                and localize(({"k_common", "k_uncommon", "k_rare", "k_legendary"})[vars[2]])
                or localize("k_"..vars[2])
                if card.ability.immutable.depth_range[1] == card.ability.immutable.depth_range[2] then
                    localize{type = "descriptions", set = "Other", key = "sgt_fish_states_singular", nodes = fish_nodes, vars = vars}
                else
                    localize{type = "descriptions", set = "Other", key = "sgt_fish_states", nodes = fish_nodes, vars = vars}
                end
                ui[Ortalab and "mythos" or "celestara"] = fish_nodes
            end
        end
    end
    return ui
end

local chp = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = chp(card)
    local AUT = card.ability_UIBox_table
    local obj = card.config.center or (card.config.tag and G.P_TAGS[card.config.tag.key])
    if AUT.celestara then
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes,
        #ret_val.nodes[1].nodes[1].nodes[1].nodes+(card.config.center.discovered and 0 or 1),
        desc_from_rows(AUT.celestara))
    end
    if card.area and card.area.config.collection and not card.config.center.discovered then return ret_val end
    if not Ortalab and obj and obj.artist_credits then
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, Sagatro.artist_node(obj.artist_credits, localize('sgt_art_credit')))
    end
    return ret_val
end

function Sagatro.artist_node(artists, first_string)
    local artist_node = {n=G.UIT.R, config = {align = 'tm'}, nodes = {
        {n=G.UIT.T, config={
            text = first_string,
            shadow = true,
            colour = G.C.UI.BACKGROUND_WHITE,
            scale = 0.27}}
    }}
    local total_artists = #artists
    for i, artist in ipairs(artists) do
        if total_artists > 1 and i > 1 then
            if i == total_artists then
                table.insert(artist_node.nodes,
                    {n=G.UIT.T, config={
                    text = localize('sgt_and'),
                    shadow = true,
                    colour = G.C.WHITE,
                    scale = 0.27}}
                )
            else
                table.insert(artist_node.nodes,
                    {n=G.UIT.T, config={
                    text = ', ',
                    shadow = true,
                    colour = G.C.WHITE,
                    scale = 0.27}}
                )
            end
        end
        table.insert(artist_node.nodes,
            {n=G.UIT.O, config={
                object = DynaText({string = localize{type = 'raw_descriptions', set = 'sgt_artist', key = artist},
                colours = {G.ARGS.LOC_COLOURS[artist] or G.C.RARITY[4]},
                bump = true,
                silent = true,
                pop_in = 0,
                pop_in_rate = 4,
                shadow = true,
                y_offset = -0.6,
                scale =  0.27
                })
            }}
        )
    end
    return artist_node
end

local desctab_ref = buildModDescTab
function buildModDescTab(mod)
    local ret = desctab_ref(mod)
    local tab_def = ret.tab_definition_function
    function ret.tab_definition_function()
        local retret = tab_def()
        if mod.id == "Sagatro" then
            retret.config.colour = Sagatro.secondary_colour
        end
        return retret
    end
    return ret
end

-- Submarine's UP and DOWN movements
local highlight_ref = Card.highlight
function Card:highlight(is_higlighted)
    highlight_ref(self, is_higlighted)
    if Sagatro.storyline_check("20k_miles_under_the_sea") then
        if self.config.center_key == "j_sgt_submarine" and self.area == G.jokers then
            if self.highlighted then
                self.children.movement_buttons = UIBox{
                    definition = G.UIDEF.movement_buttons(self),
                    config = {
                        align= "cl",
                        offset = {x=0.4,y=0},
                        parent = self}
                }
            elseif self.children.movement_buttons then
                self.children.movement_buttons:remove()
                self.children.movement_buttons = nil
            end
        end
    end
    if Sagatro.storyline_check("alice_in_mirrorworld") then
        if self.config.center_key == "j_sgt_mirror" and self.area == G.jokers then
            if self.highlighted then
                self.children.switch_button = UIBox{
                    definition = G.UIDEF.switch_button(self),
                    config = {
                        align= "cl",
                        offset = {x=0.4,y=0},
                        parent = self}
                }
            elseif self.children.switch_button then
                self.children.switch_button:remove()
                self.children.switch_button = nil
            end
        end
    end
end

function G.UIDEF.movement_buttons(card)
    local up, down = nil, nil
    if Sagatro.storyline_check("20k_miles_under_the_sea") and card.config.center_key == "j_sgt_submarine" then
        local showdown = G.GAME.nyx_abyss_incoming
        local is_bottom_depth = card.ability.immutable.depth_level == 5
        up = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'submarine_up', func = 'submarine_can_go_up'}, nodes={
            {n=G.UIT.T, config={text = localize('b_sgt_up'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}},
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
        }}}}
        down = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'submarine_down', func = 'submarine_can_go_down'}, nodes={
            {n=G.UIT.T, config={text = showdown and is_bottom_depth and not G.GAME.won and localize('b_sgt_ready') or localize('b_sgt_down'),colour = G.C.UI.TEXT_LIGHT, scale = showdown and is_bottom_depth and not G.GAME.won and 0.35 or 0.45, shadow = true}},
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
        }}}}
    end
    local t = {
    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cr'}, nodes={
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            up
        }},
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            down
        }},
        }},
    }}
    return t
end

function G.UIDEF.switch_button(card)
    local switch = nil
    if Sagatro.storyline_check("alice_in_mirrorworld") and card.config.center_key == "j_sgt_mirror" then
        switch = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'mirror_switch', func = 'mirror_can_switch'}, nodes={
            {n=G.UIT.T, config={text = localize('b_sgt_switch'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}},
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
        }}}}
    end
    local t = {
    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cr'}, nodes={
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            switch
        }},
        }},
    }}
    return t
end

G.FUNCS.submarine_up = function(e)
    local submarine = e.config.ref_table
    play_sound('timpani')
    submarine.ability.immutable.depth_level = math.max(submarine.ability.immutable.depth_level - 1, 1)
    G.GAME.submarine_movement_cooldown = true
    G.GAME.first_submarine_up = true
    Sagatro.resolve_fuel(-1)
    submarine:juice_up()
    if G.GAME.ante_cooldown == 0 then
        G.GAME.ante_cooldown = G.GAME.ante_cooldown + 2
        if not G.GAME.ante_first_time then
            G.GAME.ante_first_time = true
            G.GAME.ante_reduction_tooltip = true
        end
        Sagatro.ease_ante(-1)
    end
    if submarine.ability.immutable.depth_level == 1 then
        G.E_MANAGER:add_event(Event({func = function()
            for _, v in ipairs(SMODS.find_card("j_sgt_blobfish")) do
                local poof_text = function()
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_poof_ex'), instant = true, sound = 'tarot1'})
                end
                Sagatro.self_destruct(v, {no_sound = true, no_destruction_context = true}, poof_text)
                SMODS.add_card{key = "j_sgt_ugly_blobfish"}
            end
        return true end }))
    end
end

G.FUNCS.submarine_can_go_up = function(e)
    local submarine = e.config.ref_table
    if submarine.ability.immutable.depth_level > 1 and not G.GAME.submarine_movement_cooldown
    and not submarine.ability.immutable.pending_go_down then
        e.config.colour = G.GAME.first_submarine_up and G.C.SUBMARINE_DEPTH[1] or G.C.SGT_SAGATTENTION
        e.config.button = 'submarine_up'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.submarine_down = function(e, force_go_down)
    local submarine = e.config.ref_table
    local bosses = {"turquoise_jellyfish", "aqua_eyeshard", "black_oil", "shadow_seamine", "nyx_abyss"}
    Sagatro.progress_storyline(bosses[submarine.ability.immutable.depth_level], "add", "20k_miles_under_the_sea", G.GAME.interwoven_storyline)
    if Sagatro.event_check(bosses) and not force_go_down then
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('timpani')
            submarine.ability.immutable.pending_go_down = true
            submarine:juice_up()
        return true end }))
        SMODS.calculate_effect({message = localize{type = 'name_text', set = 'Blind', key = 'bl_sgt_'..bosses[submarine.ability.immutable.depth_level]}}, submarine)
        SMODS.calculate_effect({message = localize("k_incoming_ex")}, submarine)
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts then
            G.from_boss_tag = true
            G.FUNCS.reroll_boss()
        end
    else
        play_sound('timpani')
        submarine.ability.immutable.depth_level = math.min(submarine.ability.immutable.depth_level + 1, 5)
        if not force_go_down then
            G.GAME.submarine_movement_cooldown = true
            Sagatro.resolve_fuel(-1)
        end
        submarine:juice_up()
    end
end

G.FUNCS.submarine_can_go_down = function(e)
    local submarine = e.config.ref_table
    if (submarine.ability.immutable.depth_level < submarine.ability.immutable.armor_level
    or G.GAME.nyx_abyss_incoming) and not submarine.ability.immutable.pending_go_down
    and not G.GAME.submarine_movement_cooldown then
        e.config.colour = G.C.SUBMARINE_DEPTH[1]
        e.config.button = 'submarine_down'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.mirror_switch = function(e)
    local mirror = e.config.ref_table
    G.GAME.mirror_switch_cooldown = true
    if G.STATE == G.STATES.SHOP and not G.GAME.free_reroll_first_time then
        G.GAME.free_reroll_first_time = true
        G.GAME.free_reroll_tooltip = true
    end
    G.E_MANAGER:add_event(Event({func = function()
        play_sound('timpani')
        mirror:juice_up()
        Sagatro.inverse()
        ease_background_colour_blind(G.STATE)
        if G.GAME.story_mode then
            if G.GAME.inversed_scaling then
                Sagatro.progress_storyline("mirrorworld", "force_add", "alice_in_wonderland", G.GAME.interwoven_storyline)
            else
                Sagatro.progress_storyline("mirrorworld", "remove", "alice_in_wonderland", G.GAME.interwoven_storyline)
            end
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center_key ~= "j_sgt_mirror" then
                    if v.config.center.mirrorworld then
                        v.ability.extra_slots_used = v.ability.extra_slots_used + (G.GAME.inversed_scaling and 1 or -1)
                        v.ability.inactive = not G.GAME.inversed_scaling
                        if JokerDisplay and v.ability.inactive then
                            Sagatro.jd_toggle_override = true
                            v:joker_display_toggle()
                            Sagatro.jd_toggle_override = nil
                        end
                    else
                        v.ability.extra_slots_used = v.ability.extra_slots_used + (G.GAME.inversed_scaling and -1 or 1)
                        v.ability.inactive = G.GAME.inversed_scaling
                        if JokerDisplay and v.ability.inactive then
                            Sagatro.jd_toggle_override = true
                            v:joker_display_toggle()
                            Sagatro.jd_toggle_override = nil
                        end
                    end
                end
            end
        end
        Sagatro.instant_reroll()
    return true end }))
end

G.FUNCS.mirror_can_switch = function(e)
    if not G.GAME.mirror_switch_cooldown
    and (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SHOP) then
        e.config.colour = mix_colours(G.C.GREY, G.C.WHITE, 0.5)
        e.config.button = 'mirror_switch'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

-- Block boss reroll if it's some certain boss blinds in story mode (you would waste $10 just to roll into the same boss anyway)
local rbb = G.FUNCS.reroll_boss_button
G.FUNCS.reroll_boss_button = function(e)
    rbb(e)
    if G.GAME.story_mode and table.contains(Sagatro.story_mode_no_reroll, G.GAME.round_resets.blind_choices.Boss) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        e.children[1].children[1].config.shadow = false
        if e.children[2] then e.children[2].children[1].config.shadow = false end
        e.children[1].children[1].config.text = localize("b_dont_even_try")
        e.UIBox:recalculate()
    end
end

-- Block skipping booster if it's Wish Pack and you haven't collected at least 2 wishes
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

-- Block shop reroll if Submarine is at low fuel
local can_reroll_ref = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    can_reroll_ref(e)
    if G.GAME.submarine_low_fuel then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

function Sagatro.update_HUD()
    if G.HUD and G.GAME.story_mode then
        local ante_box_children = G.HUD:get_UIE_by_ID("hud_ante").children[2].children
        for i = 4, 2, -1 do
            if ante_box_children[i] then
                ante_box_children[i]:remove()
                ante_box_children[i] = nil
            end
        end
        G.HUD:recalculate()
    end
end

SMODS.DrawStep {
    key = "extra_buttons",
    order = -31,
    func = function(self)
        if self.children.movement_buttons then
            self.children.movement_buttons.states.visible = self.ability.anim_transition_path == 0
            self.children.movement_buttons:draw()
        end
        if self.children.switch_button then
            self.children.switch_button:draw()
        end
    end,
}
SMODS.draw_ignore_keys.movement_buttons = true
SMODS.draw_ignore_keys.switch_button = true

SMODS.DrawStep {
    key = 'eldritch_shine',
    order = 10,
    func = function(self)
        if self.ability.set == "Eldritch" or self.config.center.group_key == "sgt_eldritch_pack" or self.ability.name == "Anima" or self.ability.name == "Soltera" then
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
        elseif (self.ability.name == "The Sinister" or self.ability.name == "Anima" or self.ability.name == "Soltera") and (self.config.center.discovered or self.bypass_discovery_center) then
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