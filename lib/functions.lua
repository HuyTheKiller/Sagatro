-- local igo = Game.init_game_object
-- function Game:init_game_object()
-- 	local ret = igo(self)
-- 	ret.copied_joker = nil
-- 	return ret
-- end

local gmm = Game.main_menu
Game.main_menu = function(change_context)
    local ret = gmm(change_context)
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

    return ret
end

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
    for _, v in pairs(t) do
        if type(v) == "table" then
            tot = table.extract_total_value(v)
        elseif type(v) == "number" then
            tot = tot + v
        end
    end
    return tot
end