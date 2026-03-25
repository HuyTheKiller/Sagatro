if SilkTouch then
    SilkTouch.DragTarget{
        key = "join",
        moveable_t = {
            x = {ref_table = "G.consumeables.T", ref_value = "x", mod_value = 0.3},
            y = {
                ref_table = {"G.consumeables.T", "G.consumeables.T"  },
                ref_value = {                 "y",                "h"},
                operation_table = {             "+"                  },
                mod_value = 0.5,
            },
            w = {ref_table = "G.consumeables.T", ref_value = "w", mod_value = -0.3},
            h = {ref_table = "G.consumeables.T", ref_value = "h", mod_value = 0.6},
        },
        text = function(card)
            local join_loc = copy_table(localize("ml_sgt_join"))
            join_loc[#join_loc+1] = localize("$")..card.saga_fusion_cost
            return join_loc
        end,
        colour = G.C.RARITY[4],
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.ability.saga_fusion and G.GAME.story_mode
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            G.FUNCS.can_fuse_saga(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            G.FUNCS.fuse_saga{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "submarine_up",
        moveable_t = {
            x = {ref_table = "G.consumeables.T", ref_value = "x", mod_value = 0.3},
            y = {
                ref_table = {"G.consumeables.T", "G.consumeables.T"  },
                ref_value = {                 "y",                "h"},
                operation_table = {             "+"                  },
                mod_value = 0.5,
            },
            w = {ref_table = "G.consumeables.T", ref_value = "w", mod_value = -0.3},
            h = {ref_table = "G.consumeables.T", ref_value = "h", mod_value = -0.6},
        },
        text = function(card) return copy_table(localize("ml_sgt_up")) end,
        colour = G.C.SUBMARINE_DEPTH[1],
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_submarine" and G.GAME.story_mode
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            Sagatro.FUNCS.submarine_can_go_up(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            Sagatro.FUNCS.submarine_up{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "submarine_down",
        moveable_t = {
            x = {ref_table = "G.consumeables.T", ref_value = "x", mod_value = 0.3},
            y = {
                ref_table = {"G.consumeables.T", "G.consumeables.T", "G.consumeables.T"  },
                ref_value = {                 "y",                "h",                "h"},
                operation_table = {             "+",                "+"                  },
            },
            w = {ref_table = "G.consumeables.T", ref_value = "w", mod_value = -0.3},
            h = {ref_table = "G.consumeables.T", ref_value = "h", mod_value = -0.6},
        },
        text = function(card)
            local showdown = G.GAME.nyx_abyss_incoming
            local is_bottom_depth = card.ability.immutable.depth_level == 5
            if showdown and is_bottom_depth and not G.GAME.won then
                return copy_table(localize("ml_sgt_ready"))
            end
            return copy_table(localize("ml_sgt_down"))
        end,
        colour = G.C.SUBMARINE_DEPTH[1],
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_submarine" and G.GAME.story_mode
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            Sagatro.FUNCS.submarine_can_go_down(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            Sagatro.FUNCS.submarine_down{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "mirror_switch",
        moveable_t = "sgt_submarine_up",
        text = function(card) return copy_table(localize("ml_sgt_switch")) end,
        colour = mix_colours(G.C.GREY, G.C.WHITE, 0.5),
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_mirror" and G.GAME.story_mode
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            Sagatro.FUNCS.mirror_can_switch(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            Sagatro.FUNCS.mirror_switch{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "mirror_ready",
        moveable_t = "sgt_submarine_down",
        text = function(card) return copy_table(localize("ml_sgt_ready")) end,
        colour = mix_colours(G.C.GREY, G.C.WHITE, 0.5),
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_mirror" and G.GAME.story_mode and not Sagatro.storyline_check("pocket_mirror")
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            Sagatro.FUNCS.mirror_can_ready(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            Sagatro.FUNCS.mirror_ready{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "transform",
        moveable_t = "sgt_join",
        text = function(card)
            return copy_table(localize("ml_sgt_transform"))
        end,
        colour = HEX("b4417b"),
        drag_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_goldia" and G.GAME.story_mode
        end,
        active_check = function(card)
            local e = {config = {ref_table = card}}
            Sagatro.FUNCS.goldia_can_transform(e)
            return e.config.button ~= nil
        end,
        release_func = function(card)
            Sagatro.FUNCS.goldia_transform{}
        end,
    }
end