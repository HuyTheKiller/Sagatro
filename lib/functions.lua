-- local igo = Game.init_game_object
-- function Game:init_game_object()
-- 	local ret = igo(self)
-- 	ret.copied_joker = nil
-- 	return ret
-- end

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