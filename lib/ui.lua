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
    if (G.GAME.story_mode or (G.STATE == G.STATES.MENU and Sagatro.config.DisableOtherJokers) or ((card or {}).displaying_save)) and card then
        if _c.key == "j_sgt_submarine" then
            local submarine_nodes = {background_colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.25)}
            local vars = card.config.center:loc_vars({}, card).vars
            localize{type = "descriptions", set = "Other", key = "sgt_submarine_states", nodes = submarine_nodes, vars = vars}
            ui[Ortalab and "mythos" or "celestara"] = submarine_nodes
        elseif _c.key == "j_sgt_sub_engineer" and (_c.discovered or card.bypass_discovery_ui) then
            local sub_engi_nodes = {background_colour = mix_colours(G.C.SUBMARINE_DEPTH[1], G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_sub_engineer", nodes = sub_engi_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = sub_engi_nodes
        elseif _c.key == "j_sgt_mirror" and (_c.discovered or card.bypass_discovery_ui) then
            local mirror_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_mirror", nodes = mirror_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = mirror_nodes
        elseif _c.mirrorworld and (_c.discovered or card.bypass_discovery_ui) and not G.GAME.inversed_scaling and Sagatro.storyline_check("alice_in_mirrorworld") then
            local mirrorworld_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_mirrorworld", nodes = mirrorworld_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = mirrorworld_nodes
        elseif _c.set == "Joker" and not _c.mirrorworld and (_c.discovered or card.bypass_discovery_ui) and G.GAME.inversed_scaling and Sagatro.storyline_check("alice_in_mirrorworld") then
            local realworld_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_realworld", nodes = realworld_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = realworld_nodes
        elseif _c.key == "c_soul" and (_c.discovered or card.bypass_discovery_ui) and Sagatro.storyline_check("none") then
            local soul_nodes = {background_colour = mix_colours(G.C.RARITY[4], G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_soul_storyline", nodes = soul_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = soul_nodes
        elseif _c.key == "j_sgt_humpty_dumpty" and (_c.discovered or card.bypass_discovery_ui) then
            local humdum_nodes = {background_colour = mix_colours(G.C.GREY, G.C.WHITE, 0.25)}
            localize{type = "descriptions", set = "Other", key = "sgt_humdum", nodes = humdum_nodes, vars = {}}
            ui[Ortalab and "mythos" or "celestara"] = humdum_nodes
        elseif card.ability.immutable and Sagatro.config.ViewFishProperties then
            if card.ability.immutable.weight_level and (_c.discovered or card.bypass_discovery_ui) then
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
    if not Ortalab and obj and obj.artist_credits and obj.discovered then
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

local round_scores_row_ref = create_UIBox_round_scores_row
function create_UIBox_round_scores_row(score, text_colour)
    local ret = round_scores_row_ref(score, text_colour)
    if score == "defeated_by" then
        local obj_node = ret.nodes[2].nodes[1].nodes[1].nodes
        if G.GAME.defeating_agent then
            local texts = localize(G.GAME.defeating_agent)
            if texts ~= "ERROR" or type(texts) == "table" then
                if type(texts) == "table" then
                    obj_node = EMPTY(obj_node)
                    ret.nodes[2].nodes[1].config.minh = 2.35
                    for _, text in ipairs(texts) do
                        table.insert(obj_node,
                        {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = text,
                            colours = {G.C.WHITE}, shadow = true, float = true, maxw = 2.2, scale = 0.45})}}
                        }})
                    end
                elseif type(texts) == "string" then
                    obj_node[1] = {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                        {n=G.UIT.O, config={object = DynaText({string = texts,
                        colours = {G.C.WHITE}, shadow = true, float = true, maxw = 2.2, scale = 0.45})}}
                    }}
                    obj_node[2] = nil
                end
            else
                if G.P_CENTERS[G.GAME.defeating_agent] then
                    local card = Card(0,0, 0.7*G.CARD_W, 0.7*G.CARD_H, nil, G.P_CENTERS[G.GAME.defeating_agent])
                    card.ambient_tilt = 0.8
                    card.sticker_run = "NONE"
                    local cardarea = CardArea(0,0,
                        G.CARD_W*0.7,
                        G.CARD_H*0.7,
                        {card_limit = 1, type = 'title_2', highlight_limit = 0})
                    cardarea:emplace(card)
                    card.states.drag.can = false
                    obj_node[1] = {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                        {n=G.UIT.O, config={object = DynaText({string = localize{type ='name_text', key = G.GAME.defeating_agent, set = G.P_CENTERS[G.GAME.defeating_agent].set}, colours = {G.C.WHITE},shadow = true, float = true,maxw = 2.2, scale = 0.45})}}
                    }}
                    obj_node[2] = {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.O, config={object = cardarea}}
                    }}
                end
            end
        end
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
    if Sagatro.storyline_check("pocket_mirror") then
        if (self.config.center_key == "j_sgt_goldia" or self.config.center_key == "j_sgt_platinum") and self.area == G.jokers then
            if self.highlighted then
                self.children.transform_button = UIBox{
                    definition = G.UIDEF.transform_button(self),
                    config = {
                        align= "cl",
                        offset = {x=0.4,y=0},
                        parent = self}
                }
            elseif self.children.transform_button then
                self.children.transform_button:remove()
                self.children.transform_button = nil
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
    local switch, ready = nil, nil
    if Sagatro.storyline_check("alice_in_mirrorworld") and card.config.center_key == "j_sgt_mirror" then
        switch = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'mirror_switch', func = 'mirror_can_switch'}, nodes={
            {n=G.UIT.T, config={text = localize('b_sgt_switch'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}},
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
        }}}}
        if not Sagatro.storyline_check("pocket_mirror") then
            ready = {n=G.UIT.C, config={align = "cl"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'mirror_ready', func = 'mirror_can_ready'}, nodes={
                {n=G.UIT.T, config={text = localize('b_sgt_ready'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}},
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
            }}}}
        end
    end
    local t = {
    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cr'}, nodes={
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            switch
        }},
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            ready
        }},
        }},
    }}
    return t
end

function G.UIDEF.transform_button(card)
    local transform = nil
    if Sagatro.storyline_check("pocket_mirror") and card.config.center_key == "j_sgt_goldia" then
        transform = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'goldia_transform', func = 'goldia_can_transform'}, nodes={
            {n=G.UIT.T, config={text = localize('b_sgt_transform'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}},
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
        }}}}
    end
    local t = {
    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cr'}, nodes={
        {n=G.UIT.R, config={align = 'cr'}, nodes={
            transform
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
        G.GAME.ante_cooldown = G.GAME.ante_cooldown + (G.GAME.sgt_lenient_score and 8 or 4)
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
    and not submarine.ability.immutable.pending_go_down and not G.CONTROLLER.locked then
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
        elseif G.GAME.blind_on_deck ~= "Boss" then
            add_tag(Tag("tag_boss"))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
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
    and not G.GAME.submarine_movement_cooldown and not G.CONTROLLER.locked then
        e.config.colour = G.C.SUBMARINE_DEPTH[1]
        e.config.button = 'submarine_down'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.mirror_switch = function(e)
    local mirror = e.config.ref_table
    G.E_MANAGER:add_event(Event({func = function()
        play_sound('timpani')
        mirror:juice_up()
        G.GAME.mirror_switch_cooldown = true
        if not Sagatro.storyline_check("pocket_mirror") then
            if G.STATE == G.STATES.SHOP and not G.GAME.free_reroll_first_time then
                G.GAME.free_reroll_first_time = true
                G.GAME.free_reroll_tooltip = true
            end
            Sagatro.inverse()
            ease_dollars(G.GAME.switch_bonus)
            G.GAME.switch_bonus = 0
        else
            G.GAME.pm_mirrorworld = not G.GAME.pm_mirrorworld
        end
        ease_background_colour_blind(G.STATE)
        if G.GAME.story_mode then
            if Sagatro.storyline_check("pocket_mirror") then
                if G.GAME.pm_mirrorworld then
                    Sagatro.progress_storyline("pm_mirrorworld", "force_add", "pocket_mirror", G.GAME.interwoven_storyline)
                    SMODS.add_card{key = "j_sgt_egliette"}
                else
                    Sagatro.progress_storyline("facing_egliette", "force_finish", "pocket_mirror", G.GAME.interwoven_storyline)
                    Sagatro.progress_storyline("fleta_challenges", "add", "pocket_mirror", G.GAME.interwoven_storyline)
                    local cards = {}
                    for _, v in ipairs(G.jokers.cards) do
                        if v.config.center.saga_group == "alice_in_wonderland"
                        or v.config.center.saga_group == "alice_in_mirrorworld" then
                            table.insert(cards, v)
                        end
                    end
                    SMODS.destroy_cards(cards, true, true)
                    SMODS.add_card{key = "j_sgt_fleta"}
                    G.GAME.interwoven_storyline = nil
                    if G.GAME.progress_tag_iw then
                        G.GAME.progress_tag_iw:yep('-', G.C.RED, function() return true end)
                        G.GAME.progress_tag_iw.triggered = true
                        G.GAME.storyline_progress_iw = nil
                    end
                end
            else
                if G.GAME.inversed_scaling then
                    Sagatro.progress_storyline("mirrorworld", "force_add", "alice_in_wonderland", G.GAME.interwoven_storyline)
                    for _, alice in ipairs(SMODS.find_card("j_sgt_alice", true)) do
                        alice:set_ability("j_sgt_ecila")
                    end
                    if G.shop_booster then
                        for _, booster in ipairs(G.shop_booster.cards or {}) do
                            if booster.config.center.kind == "Celestial" or booster.config.center.kind == "Celestara" then
                                booster:set_ability(get_pack("mirrorworld"))
                                Sagatro.resize(booster)
                                booster:set_cost()
                            end
                        end
                    end
                    G.GAME.planet_rate = G.GAME.planet_rate/1e18
                    if G.GAME.used_vouchers.v_sgt_civilization then
                        G.GAME.celestara_rate = G.GAME.celestara_rate/1e18
                    end
                else
                    Sagatro.progress_storyline("mirrorworld", "remove", "alice_in_wonderland", G.GAME.interwoven_storyline)
                    for _, ecila in ipairs(SMODS.find_card("j_sgt_ecila", true)) do
                        ecila:set_ability("j_sgt_alice")
                    end
                    G.GAME.planet_rate = G.GAME.planet_rate*1e18
                    if G.GAME.used_vouchers.v_sgt_civilization then
                        G.GAME.celestara_rate = G.GAME.celestara_rate*1e18
                    end
                end
                Sagatro.update_inactive_state(true)
            end
        end
        Sagatro.instant_reroll()
    return true end }))
end

G.FUNCS.mirror_can_switch = function(e)
    if not G.GAME.mirror_switch_cooldown and not G.GAME.saga_forced_boss
    and (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SHOP) and not G.CONTROLLER.locked then
        e.config.colour = mix_colours(G.C.GREY, G.C.WHITE, 0.5)
        e.config.button = 'mirror_switch'
        if Sagatro.storyline_check("pocket_mirror") then
            if not (next(SMODS.find_card("j_sgt_eat_me")) or G.GAME.pm_mirrorworld) then
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
            end
        end
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.mirror_ready = function(e)
    local mirror = e.config.ref_table
    G.E_MANAGER:add_event(Event({func = function()
        play_sound('timpani')
        mirror:juice_up()
        if G.GAME.story_mode then
            for _, v in ipairs{"the_pawn", "the_rook", "the_knight", "the_bishop", "true_red_queen", "red_king"} do
                if Sagatro.event_check(v, nil, true) then
                    Sagatro.progress_storyline(v, "add", "alice_in_wonderland", G.GAME.interwoven_storyline)
                    if G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts then
                        G.from_boss_tag = true
                        G.FUNCS.reroll_boss()
                    elseif G.GAME.blind_on_deck ~= "Boss" then
                        add_tag(Tag("tag_boss"))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    end
                    G.GAME.mirror_ready = true
                    break
                end
            end
        end
    return true end }))
end

G.FUNCS.mirror_can_ready = function(e)
    if G.GAME.inversed_scaling and not (G.GAME.saga_forced_boss or G.GAME.mirror_ready) and not G.GAME.won
    and (Sagatro.event_check("the_bishop", nil, true) or G.GAME.mirrorworld_showdown) and not G.CONTROLLER.locked then
        e.config.colour = mix_colours(G.C.GREY, G.C.WHITE, 0.5)
        e.config.button = 'mirror_ready'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.goldia_transform = function(e)
    local regalia_list = {}
    local regalia_checklist = {
        j_sgt_pocket_mirror = false,
        j_sgt_knife_fork = false,
    }
    for i = #G.jokers.cards, 1, -1 do
        local regalia = G.jokers.cards[i]
        if table.contains(Sagatro.regalia_list, regalia.config.center_key) then
            if regalia.config.center_key == "j_sgt_pocket_mirror"
            or regalia.config.center_key == "j_sgt_knife_fork" then
                regalia_checklist[regalia.config.center_key] = true
            end
            table.insert(regalia_list, regalia)
        end
    end
    if #regalia_list >= 4
    and regalia_checklist.j_sgt_pocket_mirror
    and regalia_checklist.j_sgt_knife_fork then
        for i = 1, #regalia_list do
            regalia_list[i]:remove()
        end
        G.GAME.regalia_list = {}
        if #regalia_list == 4 then
            local goldia = SMODS.find_card("j_sgt_goldia", true)[1]
            if goldia then
                goldia:set_ability("j_sgt_platinum")
            end
            Sagatro.progress_storyline("goldia_transformation", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("platinum_ending", "add", "pocket_mirror", G.GAME.interwoven_storyline)
            check_for_unlock{type = "pm_normal_end_1"}
        elseif #regalia_list == 5 then
            Sagatro.set_goldia_stage(0, "dawn")
            Sagatro.progress_storyline("goldia_transformation", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("dawn_ending", "add", "pocket_mirror", G.GAME.interwoven_storyline)
            check_for_unlock{type = "pm_normal_end_2"}
        elseif #regalia_list == 6 then
            Sagatro.set_goldia_stage(0, "name_recalled")
            Sagatro.progress_storyline("goldia_transformation", "finish", "pocket_mirror", G.GAME.interwoven_storyline)
            Sagatro.progress_storyline("little_goody_2_shoes_ending", "add", "pocket_mirror", G.GAME.interwoven_storyline)
            check_for_unlock{type = "pm_normal_end_3"}
        else
            print("Wtf, how did you even get more than 6 regalias?")
        end
        play_sound('timpani')
        G.jokers:unhighlight_all()
        ease_background_colour_blind(G.STATE)
        G.GAME.goldia_transformation_complete = true
        G.SETTINGS.SOUND.music_volume = Sagatro.temp_music_volume or 50
        Sagatro.temp_music_volume = nil
        Sagatro.progress_storyline("ending_reached", "force_add", "pocket_mirror", G.GAME.interwoven_storyline)
        Sagatro.progress_storyline("ending_reached", "force_finish", "pocket_mirror", G.GAME.interwoven_storyline)
    else
        print("Missing required regalias (Pocket Mirror, Messer And Gabel).")
    end
end

G.FUNCS.goldia_can_transform = function(e)
    if #G.GAME.regalia_list >= 4 and Sagatro.event_check("goldia_transformation") and not G.CONTROLLER.locked then
        e.config.colour = G.C.SGT_GOLDIATTENTION
        e.config.button = 'goldia_transform'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.cash_out_into_boss_blind = function()
    G.GAME.facing_blind = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            ease_round(1)
            inc_career_stat('c_rounds', 1)
            G.GAME.round_resets.blind = G.P_BLINDS[G.GAME.round_resets.blind_choices["Boss"]]
            G.GAME.round_resets.blind_states.Boss = 'Current'
            delay(0.2)
        return true
    end}))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            new_round()
            return true
        end
    }))
end

G.FUNCS.lenient_score_tooltip = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = create_UIBox_lenient_score(),
  }
end

function create_UIBox_lenient_score(args)
    local t = {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.T, config = {scale = 0.6, text = localize('SGT_lenient_score_enabled'), colour = G.C.WHITE}}
        }},
        {n=G.UIT.R, config = {align = 'cm'}, nodes={}}
    }}
    for _, v in ipairs(localize("SGT_lenient_score_full_desc")) do
      t.nodes[2].nodes[#t.nodes[2].nodes+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.T, config={text = v,colour = G.C.UI.TEXT_LIGHT, scale = 0.35, juice = true, shadow = true}}
      }}
    end
    return create_UIBox_generic_options({contents = {t}})
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
    (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
        if SMODS.OPENED_BOOSTER.label:find("wish_primary") then
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
        elseif SMODS.OPENED_BOOSTER.contains_pocket_mirror
        or (SMODS.OPENED_BOOSTER.story_starter and G.SETTINGS.saga_tutorial_progress
        and G.SETTINGS.saga_tutorial_progress.section == "booster") then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        end
    end
end

local can_select_from_booster_ref = G.FUNCS.can_select_from_booster
G.FUNCS.can_select_from_booster = function(e)
    can_select_from_booster_ref(e)
    if SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.story_starter and G.SETTINGS.saga_tutorial_progress
    and G.SETTINGS.saga_tutorial_progress.section == "booster" then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local ccfs = create_card_for_shop
function create_card_for_shop(area)
    if area == G.shop_jokers and G.SETTINGS.saga_tutorial_progress and G.SETTINGS.saga_tutorial_progress.forced_shop and G.SETTINGS.saga_tutorial_progress.forced_shop[#G.SETTINGS.saga_tutorial_progress.forced_shop] then
        local t = G.SETTINGS.saga_tutorial_progress.forced_shop
        local _center = G.P_CENTERS[t[#t]] or G.P_CENTERS.c_empress
        local card = Card(area.T.x + area.T.w/2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, _center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        t[#t] = nil
        if not t[1] then G.SETTINGS.saga_tutorial_progress.forced_shop = nil end
        create_shop_card_ui(card)
        return card
    end
    return ccfs(area)
end

-- Block shop reroll if Submarine is at low fuel
-- Also Story Mode Purple Stake
local can_reroll_ref = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    can_reroll_ref(e)
    if G.GAME.submarine_low_fuel then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
    if G.GAME.modifiers.sgt_reroll_limit
    and G.GAME.current_round.reroll_count >= G.GAME.modifiers.sgt_reroll_limit then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local shop_ui = G.UIDEF.shop
function G.UIDEF.shop()
    local ret = shop_ui()
    local next_round_button = ret.nodes[1].nodes[1].nodes[1].nodes[1].nodes[1].nodes[1].nodes[1]
    next_round_button.config.func = "can_toggle_shop"
    return ret
end

G.FUNCS.can_toggle_shop = function(e)
    if not G.SETTINGS.saga_tutorial_complete and G.SETTINGS.saga_tutorial_progress
    and not G.SETTINGS.saga_tutorial_progress.completed_parts['shop_2'] then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'toggle_shop'
    end
end

function create_UIBox_Sagatro(args)
    local mod = G.ACTIVE_MOD_UI
    if not SMODS.LAST_SELECTED_MOD_TAB then SMODS.LAST_SELECTED_MOD_TAB = "mod_desc" end

    local mod_tabs = {}
    table.insert(mod_tabs, buildModDescTab(mod))
    local additions_tab = buildAdditionsTab(mod)
    if additions_tab then table.insert(mod_tabs, additions_tab) end
    local credits_func = mod.credits_tab
    if credits_func and type(credits_func) == 'function' then
        table.insert(mod_tabs, {
            label = localize("b_credits"),
            chosen = SMODS.LAST_SELECTED_MOD_TAB == "credits" or false,
            tab_definition_function = function(...)
                SMODS.LAST_SELECTED_MOD_TAB = "credits"
                return credits_func(...)
            end
        })
    end
    local config_func = mod.config_tab
    if config_func and type(config_func) == 'function' then 
        table.insert(mod_tabs, {
            label = localize("b_config"),
            chosen = SMODS.LAST_SELECTED_MOD_TAB == "config" or false,
            tab_definition_function = function()
                SMODS.LAST_SELECTED_MOD_TAB = "config"
                return config_func()
            end
        })
    end

    local mod_has_achievement
    for _, v in pairs(SMODS.Achievements) do
        if v.mod.id == mod.id then mod_has_achievement = true end
    end
    if mod_has_achievement then table.insert(mod_tabs, 
        {
            label = localize("b_achievements"),
            chosen = SMODS.LAST_SELECTED_MOD_TAB == "achievements" or false,
            tab_definition_function = function()
                SMODS.LAST_SELECTED_MOD_TAB = "achievements"
                return buildAchievementsTab(mod)
            end
        })
    end

    local custom_ui_func = mod.extra_tabs
    if custom_ui_func and type(custom_ui_func) == 'function' then
        local custom_tabs = custom_ui_func()
        if next(custom_tabs) and #custom_tabs == 0 then custom_tabs = { custom_tabs } end
        for i, v in ipairs(custom_tabs) do
            local id = mod.id..'_'..i
            v.chosen = (SMODS.LAST_SELECTED_MOD_TAB == id) or false
            v.label = v.label or ''
            local def = v.tab_definition_function
            assert(def, ('Custom defined mod tab with label "%s" from mod with id %s is missing definition function'):format(v.label, mod.id))
            v.tab_definition_function = function(...)
                SMODS.LAST_SELECTED_MOD_TAB = id
                return def(...)
            end
            table.insert(mod_tabs, v)
        end
    end

    return (create_UIBox_generic_options({
        colour = (mod.ui_config or {}).colour,
        bg_colour = (mod.ui_config or {}).bg_colour,
        back_colour = (mod.ui_config or {}).back_colour,
        outline_colour = (mod.ui_config or {}).outline_colour,
        back_func = Sagatro.fromAlice and "exit_overlay_menu_Sagatro" or "mods_button",
        contents = {
            {
                n = G.UIT.R,
                config = {
                    padding = 0,
                    align = "tm"
                },
                nodes = {
                    create_tabs({
                        snap_to_nav = true,
                        colour = (mod.ui_config or {}).tab_button_colour or G.C.BOOSTER,
                        tabs = mod_tabs
                    })
                }
            }
        }
    }))
end

G.FUNCS.exit_overlay_menu_Sagatro = function()
  if not G.OVERLAY_MENU then return end
  G.CONTROLLER.locks.frame_set = true
  G.CONTROLLER.locks.frame = true
  G.CONTROLLER:mod_cursor_context_layer(-1000)
  G.OVERLAY_MENU:remove()
  G.OVERLAY_MENU = nil
  G.VIEWING_DECK = nil
  G.SETTINGS.paused = false
  if G.CONTROLLER.touch_control then
    G.CONTROLLER.touch_control.clear_touch = true
  end
  G.ACTIVE_MOD_UI = nil
  SMODS.LAST_SELECTED_MOD_TAB = nil
  Sagatro.fromAlice = nil
  G:save_settings()
end

-- template node: `{n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {}}`
function create_UIBox_Sagatro_welcome()
    local args = {
        colour = (Sagatro.ui_config or {}).colour,
        bg_colour = (Sagatro.ui_config or {}).bg_colour,
        back_colour = (Sagatro.ui_config or {}).back_colour,
        outline_colour = (Sagatro.ui_config or {}).outline_colour,
        back_label = localize("b_sgt_understood"),
        contents = {
            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                {n = G.UIT.R, config = {padding = 0.1, align = "cm"}, nodes = {
                    {n = G.UIT.R, config = {padding = 0.1, align = "cm"}, nodes = {
                        {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                            {n = G.UIT.O, config = {object = DynaText({
                                string = {localize("sgt_welcome")}, colours = { G.C.RARITY[4] },
                                shadow = true, rotate = true, bump = true, pop_in = 0.3, pop_in_rate = 2, scale = 1.2,
                            })}}
                        }}
                    }},
                    {n = G.UIT.R, config = {padding = 0.2, align = "cm"}, nodes = {
                        {n = G.UIT.C, config = {padding = 0.2, emboss = 0.05, align = "cm", colour = Sagatro.secondary_colour, r = 0.1}, nodes = {
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text1"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text2"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = "", scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text3"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text4"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text5"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = "", scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text6"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = "", scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n = G.UIT.R, config = {padding = 0, align = "cm"}, nodes = {
                                {n = G.UIT.T, config = {text = localize("sgt_welcome_text7"), scale = 0.5, colour = G.C.WHITE}}
                            }},
                            {n=G.UIT.R, config = {padding = 0.2, align = 'cm'}, nodes = {
                                create_toggle({label = localize('SGT_disable_other_jokers'), ref_table = Sagatro.config, ref_value = 'DisableOtherJokers', active_colour = Sagatro.badge_colour, inactive_colour = Sagatro.secondary_colour, left = true}),
                            }},
                        }}
                    }}
                }}
            }}
        }
    }
    return create_UIBox_generic_options(args)
end

function Sagatro_welcome_text()
    local t = {
        {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR, r = 0.1, padding = 0.04, minw = 2, minh = 0.8, filler = true}, nodes = {
            {n = G.UIT.R, config = {padding = 0.03, align = "cm"}, nodes = {}}
        }}
    }

    return t
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

function Sagatro.get_save_count()
    local _slots_used = 0
    for i = 1, Sagatro.save_slots do
        local save_slot = love.filesystem.getInfo(G.SETTINGS.profile.."/"..Sagatro.save_name..i..".jkr")
        if save_slot ~= nil then
            _slots_used = _slots_used + 1
        end
    end
    return _slots_used, Sagatro.save_slots
end

function G.UIDEF.saveload_list(from_game_over, from_options)
  G.SAVELOAD_PAGE_SIZE = 10
  local saveload_pages = {}
  for i = 1, math.ceil(Sagatro.save_slots/G.SAVELOAD_PAGE_SIZE) do
    table.insert(saveload_pages, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(Sagatro.save_slots/G.SAVELOAD_PAGE_SIZE)))
  end
  G.E_MANAGER:add_event(Event({func = (function()
    G.FUNCS.change_saveload_page{cycle_config = {current_option = 1}}
  return true end)}))

  Sagatro.save_count = localize{type = 'variable', key = 'sgt_save_slots_used', vars = {Sagatro.get_save_count()}}
  Sagatro.allow_save = G.GAME.story_mode and from_options
  local t = create_UIBox_generic_options({ back_id = from_game_over and 'from_game_over' or 'saveload_list', back_func = from_options and 'options' or 'setup_run', contents = {
    {n=G.UIT.C, config={align = "cm", padding = 0.0}, nodes={
      {n=G.UIT.R, config={align = "cm", padding = 0.1, minh = 7, minw = 4.2}, nodes={
        {n=G.UIT.O, config={id = 'saveload_list', object = Moveable()}},
      }},
      {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        create_option_cycle({id = 'saveload_page',scale = 0.9, h = 0.3, w = 3.5, options = saveload_pages, cycle_shoulders = true, opt_callback = 'change_saveload_page', current_option = 1, colour = Sagatro.badge_colour, no_pips = true, focus_args = {snap_to = true}})
      }},
      {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.T, config={ref_table = Sagatro, ref_value = "save_count", scale = 0.4, colour = G.C.WHITE}},
      }},

    }},
    {n=G.UIT.C, config={align = "cm", minh = 9, minw = 11.5}, nodes={
      {n=G.UIT.O, config={id = 'saveload_area', object = Moveable()}},
    }},
  }})
  return t
end

function G.UIDEF.saveload_list_page(_page)
  local snapped = false
  local saveload_list = {}
  for i = 1, Sagatro.save_slots do
    if i > G.SAVELOAD_PAGE_SIZE*(_page or 0) and i <= G.SAVELOAD_PAGE_SIZE*((_page or 0) + 1) then
      if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.config.id == 'saveload_page' then snapped = true end
      local saved_snapshot = get_compressed(G.SETTINGS.profile.."/"..Sagatro.save_name..i..".jkr")
      local storyline_name
      if saved_snapshot ~= nil then
        saved_snapshot = STR_UNPACK(saved_snapshot)
        storyline_name = saved_snapshot.GAME.interwoven_storyline or saved_snapshot.GAME.current_storyline
        if saved_snapshot.GAME.show_main_storyline then
            storyline_name = saved_snapshot.GAME.current_storyline
        end
      end
      storyline_name = localize(Sagatro.storyline_locmap[storyline_name or "EMPTY"] or "k_empty")
      Sagatro.save_name_list[i] = storyline_name
      local is_empty = storyline_name == localize("k_empty")

      saveload_list[#saveload_list+1] =
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = 'cl', minw = 0.8}, nodes = {
          {n=G.UIT.T, config={text = i..'', scale = 0.4, colour = G.C.WHITE}},
        }},
        UIBox_button({id = i, col = true, dynamic_label = {text = Sagatro.save_name_list[i]}, label = {}, button = 'change_save_description', colour = Sagatro.badge_colour, text_colour = is_empty and G.C.GREY or G.C.UI.TEXT_LIGHT, minw = 4, scale = 0.4, minh = 0.6, focus_args = {snap_to = not snapped}}),
      }}
      snapped = true
    end
  end

  return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR}, nodes=saveload_list}
end

function G.UIDEF.save_description(_id)
  local joker_size = 0.6
  if _id == "nil" then
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, minh = 8.82, minw = 11.5, r = 0.1}, nodes={
      {n=G.UIT.T, config={text = localize('ph_select_save'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
    }}
  end
  local saved_snapshot = get_compressed(G.SETTINGS.profile.."/"..Sagatro.save_name.._id..".jkr")
  if saved_snapshot == nil then
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, minh = 8.82, minw = 11.5, r = 0.1}, nodes={
      {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
          {n=G.UIT.T, config={text = localize('k_jokers_cap'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
          {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, minw = 10*0.6, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
            {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
          }}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
          {n=G.UIT.T, config={text = localize('k_cap_consumables'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
          {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, minw = 3*0.6, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
            {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
          }}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
          {n=G.UIT.T, config={text = localize('k_most_recent_voucher_cap1'), scale = 0.33, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
          {n=G.UIT.T, config={text = localize('k_most_recent_voucher_cap2'), scale = 0.33, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
          {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, minw = 3*0.6, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
            {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
          }}
        }},
      }},
      {n=G.UIT.R, config={align = "cm", minh = 6}, nodes={
        {n=G.UIT.T, config={text = localize('ph_no_data'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
      }},
      {n=G.UIT.R, config={align = "cm", minh = 0.9}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "save_snapshot", func = "can_save_snapshot", shadow = true, id = _id}, nodes={
          {n=G.UIT.T, config={text = localize('b_save'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "load_snapshot", func = "can_load_snapshot", shadow = true, id = _id}, nodes={
          {n=G.UIT.T, config={text = localize('b_load'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "delete_snapshot", func = "can_delete_snapshot", shadow = true, id = _id}, nodes={
          {n=G.UIT.T, config={text = localize('b_delete'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
        }},
      }},
  }}
  end
  saved_snapshot = STR_UNPACK(saved_snapshot)
  local cardAreas = saved_snapshot.cardAreas

  Sagatro.temp_areas.jokers = CardArea(0,0,
    10*joker_size,
    0.6*G.CARD_H,
    {card_limit = cardAreas.jokers.config.card_limit or 5,
    negative_info = 'joker',
    card_w = joker_size*G.CARD_W, type = 'title_2', highlight_limit = 0})

  Sagatro.temp_areas.jokers:temp_load(cardAreas.jokers, joker_size)
  Sagatro.temp_areas.jokers.config.type = 'title_2'

  local joker_col = {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
    {n=G.UIT.T, config={text = localize('k_jokers_cap'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
    {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, minw = 5, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      Sagatro.temp_areas.jokers and {n=G.UIT.O, config={object = Sagatro.temp_areas.jokers}} or {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
    }}
  }}

  Sagatro.temp_areas.consumeables = CardArea(0,0,
    3*joker_size,
    0.6*G.CARD_H,
    {card_limit = cardAreas.consumeables.config.card_limit or 2,
    negative_info = 'consumable',
    card_w = joker_size*G.CARD_W, type = 'title_2', spread = true, highlight_limit = 0})

  Sagatro.temp_areas.consumeables:temp_load(cardAreas.consumeables, joker_size)
  Sagatro.temp_areas.consumeables.config.type = 'title_2'

  local consumable_col = {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
    {n=G.UIT.T, config={text = localize('k_cap_consumables'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
    {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      Sagatro.temp_areas.consumeables and {n=G.UIT.O, config={object = Sagatro.temp_areas.consumeables}} or {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
    }}
  }}

  Sagatro.temp_areas.vouchers = CardArea(0,0,
    3*joker_size,
    0.6*G.CARD_H,
    {card_limit = nil,
    negative_info = 'consumable',
    card_w = joker_size*G.CARD_W, type = 'title_2', spread = true, highlight_limit = 0})

  if cardAreas.vouchers.cards and next(cardAreas.vouchers.cards) then
    local card = Card(0, 0, G.CARD_W*joker_size, G.CARD_H*joker_size, G.P_CENTERS.j_joker, G.P_CENTERS.c_base)
    card:load(cardAreas.vouchers.cards[#cardAreas.vouchers.cards])
    card.T.h = card.T.h*joker_size
    card.T.w = card.T.w*joker_size
    card:set_sprites(card.config.center)
    card.displaying_save = true
    Sagatro.temp_areas.vouchers:emplace(card)
  end

  local voucher_col = {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK, r = 0.1, maxh = 5}, nodes={
    {n=G.UIT.T, config={text = localize('k_most_recent_voucher_cap1'), scale = 0.33, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
    {n=G.UIT.T, config={text = localize('k_most_recent_voucher_cap2'), scale = 0.33, colour = G.C.UI.TEXT_LIGHT, vert = true, shadow = true}},
    {n=G.UIT.C, config={align = "cm", minh = 0.6*G.CARD_H, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      Sagatro.temp_areas.vouchers and {n=G.UIT.O, config={object = Sagatro.temp_areas.vouchers}} or {n=G.UIT.T, config={text = localize('k_none'), scale = 0.4, colour = G.C.GREY}},
    }}
  }}



  return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, minh = 8.82, minw = 11.5, r = 0.1}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
      joker_col, consumable_col, voucher_col
    }},
    {n=G.UIT.R, config={align = "cm", minh = 6}, nodes={
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n = G.UIT.O, config = {object = DynaText({
          string = {localize{type = "name_text", set = "Back", key = saved_snapshot.BACK.key}}, colours = { G.C.UI.TEXT_LIGHT },
          shadow = true, rotate = true, bump = true, scale = 0.8,
        })}}
      }},
      {n = G.UIT.R, config = {minh = 0.6}, nodes = {}},
      {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE,padding = 0.03, minh = 1.75, r = 0.1}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_round'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = tostring(saved_snapshot.GAME.round),colour = G.C.RED, scale = 0.6}}}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_ante'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = tostring(saved_snapshot.GAME.round_resets.ante),colour = G.C.BLUE, scale = 0.6}}}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_money'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('$')..format_ui_value(saved_snapshot.GAME.dollars),colour = G.C.ORANGE, scale = 0.6}}}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_best_hand'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = number_format(saved_snapshot.GAME.round_scores.hand.amt),colour = G.C.RED, scale = scale_number(saved_snapshot.GAME.round_scores.hand.amt, 0.6, 100000000000)}}}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_save_date'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = saved_snapshot.GAME.story_save_date or localize("b_unknown"),colour = G.C.RED, scale = 0.6}}}}
        }},
        CardSleeves and saved_snapshot.GAME.selected_sleeve and {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 4, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize('k_sleeve'),colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
          {n=G.UIT.C, config={align = "cl", minw = 5, maxw = 4}, nodes={{n=G.UIT.T, config={text = localize{type = "name_text", set = "Sleeve", key = saved_snapshot.GAME.selected_sleeve},colour = G.C.UI.TEXT_DARK, scale = 0.6}}}},
        }} or nil,
      }},
    }},
    {n=G.UIT.R, config={align = "cm", minh = 0.9}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "save_snapshot", func = "can_save_snapshot", shadow = true, id = _id}, nodes={
        {n=G.UIT.T, config={text = localize('b_save'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
      }},
      {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "load_snapshot", func = "can_load_snapshot", shadow = true, id = _id}, nodes={
        {n=G.UIT.T, config={text = localize('b_load'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
      }},
      {n=G.UIT.C, config={align = "cm", padding = 0.1, minh = 0.7, minw = 2.5, r = 0.1, hover = true, colour = Sagatro.badge_colour, button = "delete_snapshot", func = "can_delete_snapshot", shadow = true, id = _id}, nodes={
        {n=G.UIT.T, config={text = localize('b_delete'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT,func = 'set_button_pip', focus_args = {button = 'x',set_button_pip = true}}}
      }},
    }},
  }}
end

function G.UIDEF.saveload_tab(from_game_over)
  return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 7}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1 ,colour = G.C.BLACK}, nodes={
      {n = G.UIT.C, config = {padding = 0.1, emboss = 0.05, align = "cm",r = 0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = localize('k_saveload_runs'), scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = "", scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = localize("sgt_savebox_text1"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = localize("sgt_savebox_text2"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = localize("sgt_savebox_text3"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = localize("sgt_savebox_text4"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.T, config={text = "", scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minw = 8.5, minh = 0.5, padding = 0.2}, nodes={
          UIBox_button({id = from_game_over and 'from_game_over' or nil, label = {localize('b_saveload_list')}, button = 'saveload_list', minw = 4, scale = 0.4, minh = 0.6}),
        }},
        {n=G.UIT.R, config={align = "cm", minw = 8.5, minh = 0.5, padding = 0.2}, nodes={
          UIBox_button({label = {localize('b_wipe_all_saves')}, button = 'delete_all_snapshots', minw = 4, scale = 0.4, minh = 0.6}),
        }},
      }},
    }},
  }}
end

G.FUNCS.saveload_list = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = G.UIDEF.saveload_list(e.config.id == 'from_game_over', e.config.id == "savebox_button"),
  }
  if (e.config.id == 'from_game_over') then G.OVERLAY_MENU.config.no_esc =true end
end

G.FUNCS.change_save_description = function(e)
  if G.OVERLAY_MENU then
    local desc_area = G.OVERLAY_MENU:get_UIE_by_ID('saveload_area')
    if desc_area and (desc_area.config.oid ~= e.config.id or Sagatro.from_save_button) then
      Sagatro.from_save_button = nil
      if desc_area.config.old_chosen then desc_area.config.old_chosen.config.chosen = nil end
      e.config.chosen = 'vert'
      if desc_area.config.object then
        desc_area.config.object:remove()
      end
      desc_area.config.object = UIBox{
        definition =  G.UIDEF.save_description(e.config.id),
        config = {offset = {x=0,y=0}, align = 'cm', parent = desc_area}
      }
      desc_area.config.oid = e.config.id
      desc_area.config.old_chosen = e
    end
  end
end

G.FUNCS.change_saveload_page = function(args)
  if not args or not args.cycle_config then return end
  if G.OVERLAY_MENU then
    local sl_list = G.OVERLAY_MENU:get_UIE_by_ID('saveload_list')
    if sl_list then
      Sagatro.save_list_cycle_option = args.cycle_config.current_option
      if sl_list.config.object then
        sl_list.config.object:remove()
      end
      sl_list.config.object = UIBox{
        definition = G.UIDEF.saveload_list_page(args.cycle_config.current_option-1),
        config = {offset = {x=0,y=0}, align = 'cm', parent = sl_list}
      }
      G.FUNCS.change_save_description{config = {id = 'nil'}}
    end
  end
end

G.FUNCS.save_snapshot = function(e)
    local storyline_name = G.GAME.interwoven_storyline or G.GAME.current_storyline
    storyline_name = localize(Sagatro.storyline_locmap[storyline_name or "EMPTY"] or "k_empty")
    Sagatro.save_name_list[e.config.id] = storyline_name
    Sagatro.handle_save("save", e.config.id)
    Sagatro.save_count = localize{type = 'variable', key = 'sgt_save_slots_used', vars = {Sagatro.get_save_count()}}
    play_sound("sgt_page_scratch", 1, 1.25)
    Sagatro.from_save_button = true
    G.FUNCS.change_saveload_page{cycle_config = {current_option = Sagatro.save_list_cycle_option}}
    G.FUNCS.change_save_description{config = {id = e.config.id}}
end

G.FUNCS.can_save_snapshot = function(e)
    if Sagatro.allow_save and G.ARGS.save_run then
        e.config.colour = Sagatro.badge_colour
        e.config.button = "save_snapshot"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.load_snapshot = function(e)
    Sagatro.handle_save("load", e.config.id)
end

G.FUNCS.can_load_snapshot = function(e)
    local save_slot = love.filesystem.getInfo(G.SETTINGS.profile.."/"..Sagatro.save_name..(e.config.id or 1)..".jkr")
    if save_slot ~= nil then
        e.config.colour = Sagatro.badge_colour
        e.config.button = "load_snapshot"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.delete_snapshot = function(e)
    Sagatro.save_name_list[e.config.id] = localize("k_empty")
    Sagatro.handle_save("delete", e.config.id)
    Sagatro.save_count = localize{type = 'variable', key = 'sgt_save_slots_used', vars = {Sagatro.get_save_count()}}
    play_sound("sgt_page_flip", 1, 1.25)
    Sagatro.from_save_button = true
    G.FUNCS.change_saveload_page{cycle_config = {current_option = Sagatro.save_list_cycle_option}}
    G.FUNCS.change_save_description{config = {id = e.config.id}}
end

G.FUNCS.can_delete_snapshot = function(e)
    local save_slot = love.filesystem.getInfo(G.SETTINGS.profile.."/"..Sagatro.save_name..(e.config.id or 1)..".jkr")
    if save_slot ~= nil then
        e.config.colour = Sagatro.badge_colour
        e.config.button = "delete_snapshot"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.delete_all_snapshots = function(e)
    for i = 1, Sagatro.save_slots do
        love.filesystem.remove(G.SETTINGS.profile.."/".."storymodesave"..i..".jkr")
        love.filesystem.remove(G.SETTINGS.profile.."/".."storymodesave_talisman"..i..".jkr")
    end
end

local sn = scale_number
function scale_number(number, scale, max, e_switch_point)
    local ret = sn(number, scale, max, e_switch_point)
    if G.GAME.blind and number == G.GAME.blind.chips and G.GAME.door_puzzle_active then
        return 0.45 -- I can't bother to handle unicode characters so have fun with a fixed scale
    end
    return ret
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
        if self.children.transform_button then
            self.children.transform_button:draw()
        end
    end,
}
SMODS.draw_ignore_keys.movement_buttons = true
SMODS.draw_ignore_keys.switch_button = true
SMODS.draw_ignore_keys.transform_button = true

SMODS.DrawStep {
    key = 'eldritch_shine',
    order = 10,
    func = function(self)
        if self.ability.set == "Eldritch" or self.config.center.group_key == "sgt_eldritch_pack" then
            self.children.center:draw_shader("booster", nil, self.ARGS.send_to_shader)
        end
        if self.ability.name == "Anima" or self.ability.name == "Soltera" and self.config.center.discovered then
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
            self.children.sgt_extra_sprite:draw_shader(
                "dissolve",
                nil,
                nil,
                nil,
                self.children.center,
                0,
                0
            )
            if self.edition and not self.delay_edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if self.edition[v.key:sub(3)] and v.shader then
                        if type(v.draw) == 'function' then
                            v:draw(self, layer)
                        else
                            self.children.sgt_extra_sprite:draw_shader(v.shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
                        end
                    end
                end
            end
            if self.edition and self.edition.negative then
                self.children.sgt_extra_sprite:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
            if self.debuff then
                self.children.sgt_extra_sprite:draw_shader('debuff', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end
    end,
    conditions = { vortex = false, facing = "front" },
}
SMODS.draw_ignore_keys.sgt_extra_sprite = true

SMODS.DrawStep {
    key = "floating_mid_sprite",
    order = 58,
    func = function(self)
        if self.ability.name == "The Magic Lamp" and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod2 = 0.07 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod2 = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.floating_mid_sprite:draw_shader(
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
            self.children.floating_mid_sprite:draw_shader(
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
            self.config.center.soul_pos
            and self.config.center.soul_pos.sgt_extra
            and (self.config.center.discovered or self.bypass_discovery_center)
        then
            local scale_mod = self.config.center.soul_pos.sgt_extra.no_scale and 0 or 0.07 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.floating_mid_sprite:draw_shader(
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
            self.children.floating_mid_sprite:draw_shader(
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
SMODS.draw_ignore_keys.floating_mid_sprite = true

SMODS.DrawStep {
    key = "floating_name_tag",
    order = 62,
    func = function(self)
        if
            self.config.center.soul_pos
            and self.config.center.soul_pos.name_tag
            and not self.ability.hide_name_tag
            and (self.config.center.discovered or self.bypass_discovery_center)
        then
            local scale_mod = 0 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
            self.children.floating_name_tag:draw_shader(
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
            self.children.floating_name_tag:draw_shader(
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
SMODS.draw_ignore_keys.floating_name_tag = true

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