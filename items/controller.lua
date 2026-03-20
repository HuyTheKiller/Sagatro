if SilkTouch and SilkTouch.ControllerButton then
    SilkTouch.ControllerButton{
        key = "join",
        side = "right",
        button_key = "rightshoulder",
        button_order = 2,
        text = function(card)
            return {
                localize('b_join'),
                {
                    localize('$'),
                    {ref_table = card, ref_value = "saga_fusion_cost"},
                },
            }
        end,
        text_scale = function()
            return {
                0.4,
                {0.4, 0.55},
            }
        end,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.ability.saga_fusion and G.GAME.story_mode
        end,
        active_check_cb = "can_fuse_saga",
        press_func_cb = "fuse_saga",
    }
    SilkTouch.ControllerButton{
        key = "submarine_up",
        side = "right",
        button_key = "leftstick",
        button_order = 2,
        text = function(card)
            return {
                localize('b_sgt_up'),
                single_text = true,
            }
        end,
        text_scale = function() return {0.5} end,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_submarine" and G.GAME.story_mode
        end,
        active_check_cb = "submarine_can_go_up",
        press_func_cb = "submarine_up",
    }
    SilkTouch.ControllerButton{
        key = "submarine_down",
        side = "right",
        button_key = "rightstick",
        button_order = 3,
        text = function(card)
            local ret = {
                localize('b_sgt_down'),
                single_text = true,
            }
            local showdown = G.GAME.nyx_abyss_incoming
            local is_bottom_depth = card.ability.immutable.depth_level == 5
            if showdown and is_bottom_depth and not G.GAME.won then
                ret[1] = localize('b_sgt_ready')
            end
            return ret
        end,
        text_scale = function() return {0.4} end,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_submarine" and G.GAME.story_mode
        end,
        active_check_cb = "submarine_can_go_down",
        press_func_cb = "submarine_down",
    }
    SilkTouch.ControllerButton{
        key = "mirror_switch",
        side = "right",
        button_key = "leftstick",
        button_order = 2,
        text = function(card)
            return {
                localize('b_sgt_switch'),
                single_text = true,
            }
        end,
        text_scale = function() return {0.4} end,
        minw = 1.1,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_mirror" and G.GAME.story_mode
        end,
        active_check_cb = "mirror_can_switch",
        press_func_cb = "mirror_switch",
    }
    SilkTouch.ControllerButton{
        key = "mirror_ready",
        side = "right",
        button_key = "rightstick",
        button_order = 3,
        text = function(card)
            return {
                localize('b_sgt_ready'),
                single_text = true,
            }
        end,
        text_scale = function() return {0.4} end,
        minw = 1.2,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_mirror" and G.GAME.story_mode
        end,
        active_check_cb = "mirror_can_ready",
        press_func_cb = "mirror_ready",
    }
    SilkTouch.ControllerButton{
        key = "transform",
        side = "right",
        button_key = "rightshoulder",
        button_order = 2,
        text = function(card)
            return {
                localize('b_sgt_transform'),
                single_text = true,
            }
        end,
        text_scale = function() return {0.35} end,
        minw = 1.3,
        focus_condition = function(card)
            return card.area and card.area == G.jokers and card.config.center_key == "j_sgt_goldia" and G.GAME.story_mode
        end,
        active_check_cb = "goldia_can_transform",
        press_func_cb = "goldia_transform",
    }
end