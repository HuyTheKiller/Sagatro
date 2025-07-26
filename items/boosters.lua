local wish_ipairs = {
    "c_sgt_prosperity",
    "c_sgt_fertility",
    "c_sgt_love",
    "c_sgt_peace",
    "c_sgt_ease",
    "c_sgt_aestheticism",
    "c_sgt_freedom",
}

local wish_primary = {
    key = "wish_primary",
    atlas = "booster",
    dependencies = {"Talisman"},
    pos = { x = 0, y = 0 },
    config = { choose = 3, extra = 6 },
    discovered = true,
    no_collection = true,
    group_key = "sgt_wish_pack",
    cost = 50,
    weight = 0,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_WISH)
        ease_background_colour{new_colour = G.C.SGT_WISH, special_colour = G.C.BLACK, contrast = 2}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.SGT_WISH, lighten(G.C.SGT_WISH, 0.4), lighten(G.C.SGT_WISH, 0.2), darken(G.C.SGT_WISH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        local _card = {set = "Wish", area = G.pack_cards, skip_materialize = true,
            soulable = true, key_append = "wis", key = i < 7 and wish_ipairs[i] or wish_ipairs[1]}
        return _card
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local wish_secondary = {
    key = "wish_secondary",
    atlas = "booster",
    dependencies = {"Talisman"},
    pos = { x = 0, y = 0 },
    config = { choose = 1, extra = 1 },
    discovered = true,
    no_collection = true,
    group_key = "sgt_wish_pack",
    cost = 50,
    weight = 0,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_WISH)
        ease_background_colour{new_colour = G.C.SGT_WISH, special_colour = G.C.BLACK, contrast = 2}
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.SGT_WISH, lighten(G.C.SGT_WISH, 0.4), lighten(G.C.SGT_WISH, 0.2), darken(G.C.SGT_WISH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        local _card = {set = "Wish", area = G.pack_cards, skip_materialize = true,
            soulable = true, key_append = "wis", key = i == 1 and wish_ipairs[7] or wish_ipairs[1]}
        return _card
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local booster_table = {
    wish_primary,
    wish_secondary,
}

for _, v in ipairs(booster_table) do
    if Sagatro.debug then
        v.no_collection = nil
    end
    SMODS.Booster(v)
end