if SMODS.JimboQuip then
    for i = 1, 8 do
        SMODS.JimboQuip{
            key = "good_end"..tostring(i),
            type = "win",
            extra = {
                center = "j_sgt_alice",
                materialize_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]},
                particle_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]},
            },
            filter = function(self, quip_type)
                return G.GAME.story_mode
            end,
        }
    end
    for i = 1, 9 do
        SMODS.JimboQuip{
            key = "bad_end"..tostring(i),
            type = "loss",
            extra = {
                center = "j_sgt_alice",
                materialize_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]},
                particle_colours = {Sagatro.badge_colour, G.C.BLUE, G.C.RARITY[4]},
            },
            filter = function(self, quip_type)
                return G.GAME.story_mode
            end,
        }
    end
end