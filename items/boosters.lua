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

local divinatio_normal_1 = {
    key = "divinatio_normal_1",
    atlas = "booster",
    pos = { x = 2, y = 0 },
    config = { choose = 1, extra = 3 },
    group_key = "sgt_divinatio_pack",
    cost = 4,
    weight = 1,
    kind = "Divinatio",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_DIVINATIO)
        ease_background_colour{new_colour = G.C.SGT_DIVINATIO, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_DIVINATIO, lighten(G.C.SGT_DIVINATIO, 0.4), lighten(G.C.SGT_DIVINATIO, 0.2), darken(G.C.SGT_DIVINATIO, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Divinatio", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "di1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_divinatio_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local divinatio_normal_2 = {
    key = "divinatio_normal_2",
    atlas = "booster",
    pos = { x = 3, y = 0 },
    config = { choose = 1, extra = 3 },
    group_key = "sgt_divinatio_pack",
    cost = 4,
    weight = 1,
    kind = "Divinatio",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_DIVINATIO)
        ease_background_colour{new_colour = G.C.SGT_DIVINATIO, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_DIVINATIO, lighten(G.C.SGT_DIVINATIO, 0.4), lighten(G.C.SGT_DIVINATIO, 0.2), darken(G.C.SGT_DIVINATIO, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Divinatio", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "di1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_divinatio_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local divinatio_jumbo = {
    key = "divinatio_jumbo",
    atlas = "booster",
    pos = { x = 4, y = 0 },
    config = { choose = 1, extra = 5 },
    group_key = "sgt_divinatio_pack",
    cost = 6,
    weight = 1,
    kind = "Divinatio",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_DIVINATIO)
        ease_background_colour{new_colour = G.C.SGT_DIVINATIO, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_DIVINATIO, lighten(G.C.SGT_DIVINATIO, 0.4), lighten(G.C.SGT_DIVINATIO, 0.2), darken(G.C.SGT_DIVINATIO, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Divinatio", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "di1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local divinatio_mega = {
    key = "divinatio_mega",
    atlas = "booster",
    pos = { x = 5, y = 0 },
    config = { choose = 2, extra = 5 },
    group_key = "sgt_divinatio_pack",
    cost = 8,
    weight = 0.25,
    kind = "Divinatio",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_DIVINATIO)
        ease_background_colour{new_colour = G.C.SGT_DIVINATIO, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_DIVINATIO, lighten(G.C.SGT_DIVINATIO, 0.4), lighten(G.C.SGT_DIVINATIO, 0.2), darken(G.C.SGT_DIVINATIO, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Divinatio", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "di1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local celestara_normal_1 = {
    key = "celestara_normal_1",
    atlas = "booster",
    pos = { x = 2, y = 2 },
    config = { choose = 1, extra = 2 },
    group_key = "sgt_celestara_pack",
    cost = 4,
    weight = 1,
    kind = "Celestara",
    select_card = "consumeables",
    select_exclusions = {"c_sgt_soltera"},
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SGT_CELESTARA, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.BLACK, contrast = 3}
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0,0, {
            timer = 0.07,
            scale = 0.1,
            initialize = true,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
            fill = true
        })
        G.booster_pack_meteors = Particles(1, 1, 0,0, {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE},
            fill = true
        })
    end,
    create_card = function(self, card, i)
        return {set = "Celestara", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ce1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_civilization
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_celestara_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local celestara_normal_2 = {
    key = "celestara_normal_2",
    atlas = "booster",
    pos = { x = 3, y = 2 },
    config = { choose = 1, extra = 2 },
    group_key = "sgt_celestara_pack",
    cost = 4,
    weight = 1,
    kind = "Celestara",
    select_card = "consumeables",
    select_exclusions = {"c_sgt_soltera"},
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SGT_CELESTARA, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.BLACK, contrast = 3}
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0,0, {
            timer = 0.07,
            scale = 0.1,
            initialize = true,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
            fill = true
        })
        G.booster_pack_meteors = Particles(1, 1, 0,0, {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE},
            fill = true
        })
    end,
    create_card = function(self, card, i)
        return {set = "Celestara", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ce1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_civilization
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_celestara_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local celestara_jumbo = {
    key = "celestara_jumbo",
    atlas = "booster",
    pos = { x = 4, y = 2 },
    config = { choose = 1, extra = 4 },
    group_key = "sgt_celestara_pack",
    cost = 6,
    weight = 1,
    kind = "Celestara",
    select_card = "consumeables",
    select_exclusions = {"c_sgt_soltera"},
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SGT_CELESTARA, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.BLACK, contrast = 3}
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0,0, {
            timer = 0.07,
            scale = 0.1,
            initialize = true,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
            fill = true
        })
        G.booster_pack_meteors = Particles(1, 1, 0,0, {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE},
            fill = true
        })
    end,
    create_card = function(self, card, i)
        return {set = "Celestara", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ce1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_civilization
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local celestara_mega = {
    key = "celestara_mega",
    atlas = "booster",
    pos = { x = 5, y = 2 },
    config = { choose = 2, extra = 4 },
    group_key = "sgt_celestara_pack",
    cost = 8,
    weight = 0.25,
    kind = "Celestara",
    select_card = "consumeables",
    select_exclusions = {"c_sgt_soltera"},
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SGT_CELESTARA, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.BLACK, contrast = 3}
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0,0, {
            timer = 0.07,
            scale = 0.1,
            initialize = true,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
            fill = true
        })
        G.booster_pack_meteors = Particles(1, 1, 0,0, {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE},
            fill = true
        })
    end,
    create_card = function(self, card, i)
        return {set = "Celestara", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ce1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_civilization
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local eldritch_normal_1 = {
    key = "eldritch_normal_1",
    atlas = "booster",
    pos = { x = 2, y = 1 },
    config = { choose = 1, extra = 2 },
    group_key = "sgt_eldritch_pack",
    cost = 6,
    weight = 0.3,
    kind = "Eldritch",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_ELDRITCH)
        ease_background_colour{new_colour = G.C.SGT_ELDRITCH, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_ELDRITCH, lighten(G.C.SGT_ELDRITCH, 0.4), lighten(G.C.SGT_ELDRITCH, 0.2), darken(G.C.SGT_ELDRITCH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Eldritch", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "el1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_eldritch_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local eldritch_normal_2 = {
    key = "eldritch_normal_2",
    atlas = "booster",
    pos = { x = 3, y = 1 },
    config = { choose = 1, extra = 2 },
    group_key = "sgt_eldritch_pack",
    cost = 6,
    weight = 0.3,
    kind = "Eldritch",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_ELDRITCH)
        ease_background_colour{new_colour = G.C.SGT_ELDRITCH, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_ELDRITCH, lighten(G.C.SGT_ELDRITCH, 0.4), lighten(G.C.SGT_ELDRITCH, 0.2), darken(G.C.SGT_ELDRITCH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Eldritch", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "el1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {key = "p_sgt_eldritch_normal", vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}
local eldritch_jumbo = {
    key = "eldritch_jumbo",
    atlas = "booster",
    pos = { x = 4, y = 1 },
    config = { choose = 1, extra = 4 },
    group_key = "sgt_eldritch_pack",
    cost = 9,
    weight = 0.3,
    kind = "Eldritch",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_ELDRITCH)
        ease_background_colour{new_colour = G.C.SGT_ELDRITCH, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_ELDRITCH, lighten(G.C.SGT_ELDRITCH, 0.4), lighten(G.C.SGT_ELDRITCH, 0.2), darken(G.C.SGT_ELDRITCH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Eldritch", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "el1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local eldritch_mega = {
    key = "eldritch_mega",
    atlas = "booster",
    pos = { x = 5, y = 1 },
    config = { choose = 2, extra = 4 },
    group_key = "sgt_eldritch_pack",
    cost = 12,
    weight = 0.07,
    kind = "Eldritch",
    draw_hand = true,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SGT_ELDRITCH)
        ease_background_colour{new_colour = G.C.SGT_ELDRITCH, special_colour = G.C.BLACK, contrast = 2}
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
            colours = {G.C.SGT_ELDRITCH, lighten(G.C.SGT_ELDRITCH, 0.4), lighten(G.C.SGT_ELDRITCH, 0.2), darken(G.C.SGT_ELDRITCH, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        return {set = "Eldritch", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "el1"}
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.choose or self.config.choose, card and card.ability.extra or self.config.extra}}
    end,
}

local booster_table = {
    divinatio_normal_1,
    divinatio_normal_2,
    divinatio_jumbo,
    divinatio_mega,
    celestara_normal_1,
    celestara_normal_2,
    celestara_jumbo,
    celestara_mega,
    eldritch_normal_1,
    eldritch_normal_2,
    eldritch_jumbo,
    eldritch_mega,
    wish_primary,
    wish_secondary,
}

for _, v in ipairs(booster_table) do
    if Sagatro.debug then
        v.no_collection = nil
        v.discovered = true
    end
    SMODS.Booster(v)
end