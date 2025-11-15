local divinatio = {
    key = "Divinatio",
    primary_colour = HEX("f4ff00"),
	secondary_colour = G.C.SGT_DIVINATIO,
	collection_rows = { 5, 6 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_iustitia_sacra",
}

local celestara = {
    key = "Celestara",
    primary_colour = HEX("0a126b"),
    secondary_colour = G.C.SGT_CELESTARA,
    collection_rows = { 6, 6 },
	shop_rate = 0.0,
	loc_txt = {},
    default = "c_sgt_argyra",
}

local eldritch = {
    key = "Eldritch",
    primary_colour = HEX("e264f9"),
	secondary_colour = G.C.SGT_ELDRITCH,
	collection_rows = { 4, 5 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_chanting",
}

local consumabletype_table = {
    divinatio,
    celestara,
    eldritch,
}

for _, v in ipairs(consumabletype_table) do
    SMODS.ConsumableType(v)
end

local un_divinatio = {
    key = "Divinatio",
    atlas = "ultra",
    pos = {x = 7, y = 5},
}

local un_celestara = {
    key = "Celestara",
    atlas = "ultra",
    pos = {x = 7, y = 7},
}

local un_uneldritch = {
    key = "Eldritch",
    atlas = "ultra",
    pos = {x = 6, y = 5},
}

local undiscovered_sprite_table = {
    un_divinatio,
    un_celestara,
    un_uneldritch,
}

for _, v in ipairs(undiscovered_sprite_table) do
    SMODS.UndiscoveredSprite(v)
end

local exodium = {
    key = 'exodium',
    name = "Exodium",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 0, y = 0 },
    cost = 4,
    can_use = function(self, card)
        return (G.consumeables.config.card_limit > #G.consumeables.cards and G.GAME.last_tarot_planet_divinatio_celestara
        or (card.area == G.consumeables and G.consumeables.config.card_limit == #G.consumeables.cards))
        and G.GAME.last_tarot_planet_divinatio_celestara ~= 'c_fool' and G.GAME.last_tarot_planet_divinatio_celestara ~= 'c_sgt_exodium'
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card{ key = G.GAME.last_tarot_planet_divinatio_celestara }
                    card:juice_up(0.3, 0.5)
                end
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        local fool_c = G.GAME.last_tarot_planet_divinatio_celestara and G.P_CENTERS[G.GAME.last_tarot_planet_divinatio_celestara] or nil
        local last_tarot_planet_divinatio_celestara = fool_c and localize { type = 'name_text', key = fool_c.key, set = fool_c.set }
        or localize('k_none')
        local colour = (not fool_c or fool_c.name == 'The Fool' or fool_c.name == 'Exodium') and G.C.RED or G.C.GREEN

        if not (not fool_c or fool_c.name == 'The Fool' or fool_c.name == 'Exodium') then
            info_queue[#info_queue + 1] = fool_c
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. last_tarot_planet_divinatio_celestara .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return { vars = { last_tarot_planet_divinatio_celestara }, main_end = main_end }
    end,
}

local dominus_ars = {
    key = 'dominus_ars',
    name = "Dominus Ars",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 1, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_ancient_lucky', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local sacra_sapientia = {
    key = 'sacra_sapientia',
    name = "Sacra Sapientia",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 2, y = 0 },
    cost = 4,
    config = { planets = 2 },
    can_use = function(self, card)
        return G.consumeables.config.card_limit > #G.consumeables.cards
        or (card.area == G.consumeables and G.consumeables.config.card_limit == #G.consumeables.cards)
    end,
    use = function(self, card, area, copier)
        for _ = 1, math.min(card.ability.consumeable.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card{ set = "Celestara", key_append = "sap" }
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.planets}}
    end,
}

local regina_caeli = {
    key = 'regina_caeli',
    name = "Regina Caeli",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 3, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_exponent', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local rex_divinus = {
    key = 'rex_divinus',
    name = "Rex Divinus",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 4, y = 0 },
    cost = 4,
    config = { divinatio = 2 },
    can_use = function(self, card)
        return G.consumeables.config.card_limit > #G.consumeables.cards
        or (card.area == G.consumeables and G.consumeables.config.card_limit == #G.consumeables.cards)
    end,
    use = function(self, card, area, copier)
        for _ = 1, math.min(card.ability.consumeable.divinatio, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card{ set = "Divinatio", key_append = "rex" }
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.divinatio}}
    end,
}

local sacerdos = {
    key = 'sacerdos',
    name = "Sacerdos",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 5, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_favor', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local sacra_nexus = {
    key = 'sacra_nexus',
    name = "Sacra Nexus",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 6, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_strange', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local triumpus = {
    key = 'triumpus',
    name = "Triumpus",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 7, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_titanium', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local vitus_aeterna = {
    key = 'vitus_aeterna',
    name = "Vitus Aeterna",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 8, y = 0 },
    cost = 4,
    config = {mod_conv = 'm_sgt_nyx_glass', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local lux_veritatix = {
    key = 'lux_veritatix',
    name = "Lux Veritatix",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 9, y = 0 },
    cost = 4,
    config = { dollars = 25 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(card.ability.consumeable.dollars, true)
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.dollars}}
    end,
}

local orbis_fatum = {
    key = 'orbis_fatum',
    name = "Orbis Fatum",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 0, y = 1 },
    cost = 4,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.eligible_strength_jokers = EMPTY(card.eligible_strength_jokers)
            for _, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and not v.edition then
                    table.insert(card.eligible_strength_jokers, v)
                end
            end
        end
    end,
    can_use = function(self, card)
        if next(card.eligible_strength_jokers) then return true end
        return false
    end,
    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'orbis_fatum', 1, G.GAME.orbis_fatum_odds) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local eligible_card = pseudorandom_element(card.eligible_strength_jokers, pseudoseed('orbis_fatum'))
                    eligible_card:set_edition("e_negative", true)
                    card:juice_up(0.3, 0.5)
                    G.GAME.orbis_fatum_odds = G.GAME.orbis_fatum_odds*2
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SGT_DIVINATIO,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
        end
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {SMODS.get_probability_vars(card, 1, G.GAME.orbis_fatum_odds, "orbis_fatum")}}
    end,
}

local iustitia_sacra = {
    key = 'iustitia_sacra',
    name = "Iustitia Sacra",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 1, y = 1 },
    cost = 4,
    config = {uses = 5, max_highlighted = 2},
    keep_on_use = function(self, card)
        return card.ability.uses > 1
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3); return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local mod = 1
                    for _, v in ipairs(G.consumeables.cards) do
                        if v.config.center_key == "c_strength" then
                            mod = -1
                            break
                        end
                    end
                    assert(SMODS.modify_rank(G.hand.highlighted[i], mod))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                card.ability.uses = card.ability.uses - 1
                return true
            end
        }))
        delay(0.5)
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_strength
        return {vars = {card.ability.max_highlighted,
        card and card.ability.uses or self.config.uses,
        localize{type = 'name_text', set = 'Tarot', key = "c_strength"}}}
    end,
}

local sacrificium = {
    key = "sacrificium",
    name = "Sacrificium",
    set = 'Divinatio',
    atlas = "ultra",
    pos = {x = 2, y = 1},
    cost = 4,
    config = {max_highlighted = 5},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.destroy_cards(G.hand.highlighted, nil, true)
                return true
            end
        }))
        delay(0.3)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,
}

local trasitus = {
    key = "trasitus",
    name = "Trasitus",
    set = 'Divinatio',
    atlas = "ultra",
    pos = {x = 3, y = 1},
    cost = 4,
    config = {max_highlighted = 3, min_highlighted = 2},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
                        copy_card(rightmost, G.hand.highlighted[i])
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.min_highlighted, card.ability.max_highlighted}}
    end,
}

local concordia = {
    key = "concordia",
    name = "Concordia",
    set = 'Divinatio',
    atlas = "ultra",
    pos = {x = 4, y = 1},
    cost = 4,
    config = {money = 0, max_money = 40},
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.money = 0
            for i = 1, #G.jokers.cards do
                card.ability.money = card.ability.money + G.jokers.cards[i].cost
            end
            card.ability.money = math.min(card.ability.money, card.ability.max_money)
        else
            card.ability.money = 0
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(card.ability.money, true)
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        if G.STAGE == G.STAGES.RUN then
            card.ability.money = 0
            for i = 1, #G.jokers.cards do
                card.ability.money = card.ability.money + G.jokers.cards[i].cost
            end
            card.ability.money = math.min(card.ability.money, card.ability.max_money)
        else
            card.ability.money = 0
        end
        return {vars = {card.ability.money, card.ability.max_money}}
    end,
}

local umba_aeterna = {
    key = 'umba_aeterna',
    name = "Umba Aeterna",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 5, y = 1 },
    cost = 4,
    config = {mod_conv = 'm_sgt_platinum', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local runis_sacris = {
    key = 'runis_sacris',
    name = "Runis Sacris",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 6, y = 1 },
    cost = 4,
    config = {mod_conv = 'm_sgt_abyss_stone', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

local stella_divina = {
    key = 'stella_divina',
    name = "Stell Divina",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 7, y = 1 },
    cost = 4,
    config = {suit_conv = 'Diamonds', max_highlighted = 5},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted, localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
}

local luna_mystica = {
    key = 'luna_mystica',
    name = "Luna Mystica",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 8, y = 1 },
    cost = 4,
    config = {suit_conv = 'Clubs', max_highlighted = 5},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted, localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
}

local sol_invictus = {
    key = 'sol_invictus',
    name = "Sol Invictus",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 9, y = 1 },
    cost = 4,
    config = {suit_conv = 'Hearts', max_highlighted = 5},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted, localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
}

local utima_vox = {
    key = 'utima_vox',
    name = "Utima Vox",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 0, y = 2 },
    cost = 4,
    can_use = function(self, card)
        return not G.GAME.pending_mega_buffoon
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                G.GAME.pending_mega_buffoon = true
                return true
            end
        }))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_buffoon_mega_1
    end,
}

local aeternum = {
    key = 'aeternum',
    name = "Aeternum",
    set = 'Divinatio',
    atlas = "ultra",
    pos = { x = 1, y = 2 },
    cost = 4,
    config = {suit_conv = 'Spades', max_highlighted = 5},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted, localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
}

local anima = {
    key = "anima",
    name = "Anima",
    set = "Divinatio",
    atlas = "ultra",
    pos = {x = 2, y = 2},
    config = {},
    cost = 4,
    hidden = true,
    -- discovered = not Sagatro.mod_compat.talisman,
    soul_set = "Eldritch",
    can_use = function(self, card)
        for _, v in ipairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
            if v.ability.set == "Joker" then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for _, v in ipairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == "Joker" then
                    v:add_sticker("eternal", true)
                end
            end
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            assert(SMODS.add_card({
                set = "Norse Mythology",
                skip_materialize = true,
            }))
            return true end }))
        delay(0.6)
	end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and Sagatro.mod_compat.talisman
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if not Sagatro.mod_compat.talisman then
            ret.main_end = {}
            localize{type = "other", key = "sgt_require_talisman_generic", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local argyra = {
    key = "argyra",
    name = "Argyra",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 1, y = 6},
    config = {hand_type = "Pair", resonance = {"Three of a Kind", "Full House"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                local selected_cards = Sagatro.random_select("argyra_steel", G.hand, 2)
                for _, v in ipairs(selected_cards) do
                    v:set_ability(G.P_CENTERS.m_steel, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local sulvatera = {
    key = "sulvatera",
    name = "Sulvatera",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 2, y = 6},
    config = {hand_type = "Three of a Kind", dissonance = {"Pair"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                context.scoring_hand[1]:set_ability(G.P_CENTERS.m_lucky, nil, true)
                context.scoring_hand[2]:set_ability(G.P_CENTERS.m_wild, nil, true)
                for i = 1, 2 do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.scoring_hand[i]:juice_up()
                            return true
                        end
                    }))
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local terranora = {
    key = "terranora",
    name = "Terranora",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 3, y = 6},
    config = {hand_type = "Full House", dissonance = {"Pair", "Four of a Kind"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                for _, _card in ipairs(G.hand.cards) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.modify_rank(_card, 1))
                            _card:juice_up()
                            return true
                        end
                    }))
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local valora = {
    key = "valora",
    name = "Valora",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 4, y = 6},
    config = {hand_type = "Four of a Kind", resonance = {"Full House"}, dissonance = {"Flush"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                G.E_MANAGER:add_event(Event({func = function()
                    local selected_cards = Sagatro.random_select("valora_destroy", G.deck, 2)
                    local count = #selected_cards
                    if count > 0 then
                        SMODS.destroy_cards(selected_cards, nil, true)
                        G.deck.config.card_limit = G.deck.config.card_limit - count
                    end
                return true end}))
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local zephyria = {
    key = "zephyria",
    name = "Zephyria",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 5, y = 6},
    config = {hand_type = "Flush", resonance = {"Straight"}, dissonance = {"Four of a Kind"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_cards = {}
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local new_card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                        table.insert(new_cards, new_card)
                        new_card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, new_card)
                        G.deck:emplace(new_card)
                        context.full_hand[1]:juice_up()
                        new_card:juice_up()
                        playing_card_joker_effects(new_cards)
                        G.deck:shuffle('zephyria_shuffle')
                        return true
                    end
                }))
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local chronara = {
    key = "chronara",
    name = "Chronara",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 6, y = 6},
    config = {hand_type = "Straight", resonance = {"Flush", "Four of a Kind"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                for _, v in ipairs(context.full_hand) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if not SMODS.has_no_rank(v) then
                            local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('chronara_random_rank'))
                            assert(SMODS.change_base(v, nil, _rank.key))
                            v:juice_up()
                        end
                        return true
                    end
                }))
                end
                G.E_MANAGER:add_event(Event({trigger = "immediate", func = (function()
                    assert(SMODS.add_card({
                        set = "Spectral",
                        key_append = "chronara",
                    }))
                    return true end)}))
                SMODS.calculate_effect({message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral}, card)
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local aetheron = {
    key = "aetheron",
    name = "Aetheron",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 7, y = 6},
    config = {hand_type = "Two Pair", resonance = {"Straight Flush"}, dissonance = {"Five of a Kind"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                if G.hand.cards[1] then
                    G.hand.cards[1]:set_ability(G.P_CENTERS.m_sgt_crystal, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand.cards[1]:juice_up()
                            return true
                        end
                    }))
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_crystal
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local oceanis = {
    key = "oceanis",
    name = "Oceanis",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 8, y = 6},
    config = {hand_type = "Straight Flush", resonance = {"Straight", "Flush"}, dissonance = {"Two Pair"}},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                if G.hand.cards[1] then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            copy_card(context.scoring_hand[1], G.hand.cards[1])
                            G.hand.cards[1]:juice_up()
                            return true
                        end
                    }))
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local lonestra = {
    key = "lonestra",
    name = "Lonestra",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 9, y = 6},
    config = {hand_type = "High Card"},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.repetition and context.cardarea == G.hand and not context.blueprint and not context.retrigger_joker
        and (next(context.card_effects[1]) or #context.card_effects > 1) and card.triggered then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.hand_type] and next(poker_hands[card.ability.hand_type]) then
                    card.joker_display_values.is_high_card = true
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                return held_in_hand and joker_card.joker_display_values.is_high_card
                and 1 or 0 -- consumables cannot be retriggered by another joker
            end
        }
    end,
}

local mystara = {
    key = "mystara",
    name = "Mystara",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 9, y = 7},
    config = {hand_type = "Five of a Kind", resonance = {"Two Pair", "Flush Five"}, perma_x_mult_mod = 0.1, softlock = true},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                for _, v in ipairs(context.scoring_hand) do
                    v.ability.perma_x_mult = v.ability.perma_x_mult + card.ability.perma_x_mult_mod
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, v)
                end
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                card.ability.perma_x_mult_mod,
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local ceratek = {
    key = "ceratek",
    name = "Ceratek",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 8, y = 7},
    config = {hand_type = "Flush House", dissonance = {"Four of a Kind", "Flush"}, softlock = true},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                context.scoring_hand[1]:set_edition(poll_edition('ceratek_edition', nil, nil, true), nil, nil, true)
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local discordia = {
    key = "discordia",
    name = "Discordia",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 6, y = 7},
    config = {hand_type = "Flush Five", dissonance = {"Five of a Kind"}, softlock = true},
    cost = 4,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker
        and context.scoring_name == card.ability.hand_type then
            if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
				SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                for _, hand_type in ipairs(card.ability.dissonance or {}) do
                    SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                    SMODS.smart_level_up_hand(card, hand_type)
                end
                context.scoring_hand[1]:set_ability(G.P_CENTERS.m_sgt_gravistone, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.scoring_hand[1]:juice_up()
                        return true
                    end
                }))
                card.triggered = true
                delay(0.25*G.SETTINGS.GAMESPEED)
			end
        end
        if context.after and not context.blueprint and not context.retrigger_joker and card.triggered then
            Sagatro.self_destruct(card, {no_destruction_context = true})
            return {
                message = localize('k_consumed_ex'),
                colour = G.C.FILTER,
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2)
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type)
        end
    end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        local resonant = {}
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            if SMODS.Scoring_Parameters then
                local passed_parameters = 0
                for name, _ in pairs(SMODS.Scoring_Parameters) do
                    if to_big(G.GAME.hands[card.ability.hand_type][name]) > to_big(G.GAME.hands[hand_type][name]) then
                        passed_parameters = passed_parameters + 1
                    end
                end
                if passed_parameters >= table.size(SMODS.Scoring_Parameters) then
                    resonant[#resonant+1] = hand_type
                end
            else
                if to_big(G.GAME.hands[card.ability.hand_type].chips) > to_big(G.GAME.hands[hand_type].chips)
                and to_big(G.GAME.hands[card.ability.hand_type].mult) > to_big(G.GAME.hands[hand_type].mult) then
                    resonant[#resonant+1] = hand_type
                end
            end
        end
        SMODS.smart_level_up_hand(card, card.ability.hand_type, nil, 2 * (amount or 1))
        for _, hand_type in ipairs(resonant) do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                play_sound("sgt_resonance", 1, 1)
            return true end}))
            SMODS.smart_level_up_hand(card, hand_type, nil, (amount or 1))
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.ability.resonance and not card.fake_card then info_queue[#info_queue+1] = {set = "Other", key = "sgt_resonance"} end
        info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_gravistone
        local ret = {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, "poker_hands"),
                colours = {
                    to_big(G.GAME.hands[card.ability.hand_type].level) == to_big(1)
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.hands[card.ability.hand_type].level)))]
                }
            },
        }
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        for _, hand_type in ipairs(card.ability.resonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        for _, hand_type in ipairs(card.ability.dissonance or {}) do
            ret.vars[#ret.vars+1] = localize(hand_type, "poker_hands")
        end
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local soltera = {
    key = "soltera",
    name = "Soltera",
    set = "Celestara",
    atlas = "ultra",
    pos = {x = 2, y = 7},
    config = {},
    cost = 4,
    hidden = true,
    soul_set = "Celestara",
    soul_rate = 0.005,
    can_use = function(self, card)
        for k, v in pairs(G.GAME.hands) do
            if to_big(v.level) > to_big(1) then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for k, v in pairs(G.GAME.hands) do
                if to_big(v.level) > to_big(1) then
                    level_up_hand(card, k, true, -v.level + 1)
                end
            end
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            assert(SMODS.add_card({
                set = "Celestaverse",
                skip_materialize = true,
            }))
            return true end }))
        delay(0.6)
	end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and Sagatro.mod_compat.talisman
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if not Sagatro.mod_compat.talisman then
            ret.main_end = {}
            localize{type = "other", key = "sgt_require_talisman_generic", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local demon = {
    key = 'demon',
    name = "Demon",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 0, y = 3 },
    cost = 6,
    config = {extra = 3},
    can_use = function(self, card)
        return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = Sagatro.random_destroy(card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra do
                    local faces = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if r.face then table.insert(faces, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('demon_create')).card_key,
                        pseudorandom_element(faces, pseudoseed('demon_create')).card_key
                    cards[i] = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank]},
                    G.hand, nil, i ~= 1, { G.C.SGT_ELDRITCH })
                    cards[i]:set_edition(poll_edition('demon_edition', nil, true, true))
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))
        delay(0.3)
        SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
}

local merciless = {
    key = 'merciless',
    name = "Merciless",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 1, y = 3 },
    cost = 6,
    config = {extra = 2},
    can_use = function(self, card)
        return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = Sagatro.random_destroy(card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra do
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('demon_create')).card_key, 'A'
                    cards[i] = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank]},
                    G.hand, nil, i ~= 1, { G.C.SGT_ELDRITCH })
                    cards[i]:set_edition(poll_edition('demon_edition', nil, true, true))
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))
        delay(0.3)
        SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
}

local chanting = {
    key = 'chanting',
    name = "Chanting",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 2, y = 3 },
    cost = 6,
    config = {extra = 4},
    can_use = function(self, card)
        return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = Sagatro.random_destroy(card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra do
                    local numbers = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('demon_create')).card_key,
                        pseudorandom_element(numbers, pseudoseed('demon_create')).card_key
                    cards[i] = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank]},
                    G.hand, nil, i ~= 1, { G.C.SGT_ELDRITCH })
                    cards[i]:set_edition(poll_edition('demon_edition', nil, true, true))
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))
        delay(0.3)
        SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
}

local amulet = {
    key = 'amulet',
    name = "Amulet",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 3, y = 3 },
    cost = 6,
    config = {extra = {seal = 'sgt_Platinum'}, max_highlighted = 1},
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra.seal, nil, true)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seal]
        return {vars = {card.ability.max_highlighted}}
    end,
}

local emanate = {
    key = 'emanate',
    name = "Emanate",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 4, y = 3 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        for i = 1, #G.hand.highlighted do
            local highlighted = G.hand.highlighted[i]
            if highlighted.edition then return false end
        end
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
            if pseudorandom('emanate') > 0.5 then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    highlighted:set_edition('e_negative', true)
                    card:juice_up(0.3, 0.5)
                return true end }))
            else
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    SMODS.destroy_cards(highlighted, nil, true)
                    card:juice_up(0.3, 0.5)
                return true end }))
            end
		end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { key = 'e_negative_playing_card', set = 'Edition', config = {extra = 1}}
        return {vars = {card.ability.max_highlighted}}
    end,
}

local spectre = {
    key = 'spectre',
    name = "Spectre",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 5, y = 3 },
    cost = 6,
    can_use = function(self, card)
        return G.jokers.config.card_limit > #G.jokers.cards
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card{set = 'Joker', rarity = 'Rare'}
                card:juice_up(0.3, 0.5)
                if G.GAME.dollars > to_big(0) then
                    ease_dollars(-math.floor(to_number(G.GAME.dollars)/2), true)
                end
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,
}

local magiseal = {
    key = 'magiseal',
    name = "Magiseal",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 6, y = 3 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        for i = 1, #G.hand.highlighted do
            local highlighted = G.hand.highlighted[i]
            if SMODS.has_no_suit(highlighted) then return false end
        end
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        local suit = G.hand.highlighted[1].base.suit
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, suit))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
    end,
}

local lexicon = {
    key = 'lexicon',
    name = "Lexicon",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 7, y = 3 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        for i = 1, #G.hand.highlighted do
            local highlighted = G.hand.highlighted[i]
            if SMODS.has_no_rank(highlighted) then return false end
        end
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        local rank = G.hand.highlighted[1].config.card.value
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, nil, rank))
                    return true
                end
            }))
        end
        G.hand:change_size(-1)
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
    end,
}

local substance = {
    key = 'substance',
    name = "Substance",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 8, y = 3 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        for i = 1, #G.jokers.highlighted do
            local highlighted = G.jokers.highlighted[i]
            if highlighted.edition then return false end
        end
        return #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        for i = 1, #G.jokers.highlighted do
            local highlighted = G.jokers.highlighted[i]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    highlighted:set_edition('e_negative', true)

                    G.GAME.ecto_minus = G.GAME.ecto_minus or 1
                    G.hand:change_size(-G.GAME.ecto_minus)
                    G.GAME.ecto_minus = G.GAME.ecto_minus + 1

                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {card.ability.max_highlighted, G.GAME.ecto_minus or 1}}
    end,
}

local slaughter = {
    key = 'slaughter',
    name = "Slaughter",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 9, y = 3 },
    cost = 6,
    config = {dollars = 4},
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        local count = #G.hand.cards
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                SMODS.destroy_cards(G.hand.cards, nil, true)
                return true
            end
        }))

        delay(0.5)
        ease_dollars(card.ability.dollars*count)
        delay(0.3)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.dollars}}
    end,
}

local crux_ansata = {
    key = 'crux_ansata',
    name = "Crux Ansata",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 0, y = 4 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        local check = #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.max_highlighted
        and #G.jokers.cards + #G.jokers.highlighted <= G.jokers.config.card_limit
        if Sagatro.storyline_check("20k_miles_under_the_sea") then
            for _, v in ipairs(G.jokers.highlighted) do
                check = check and v.config.center_key ~= "j_sgt_submarine"
            end
        end
        return check
    end,
    use = function(self, card, area, copier)
        local deletable_jokers = {}
        for _, joker in pairs(G.jokers.cards) do
            if not SMODS.is_eternal(joker, card) and not table.contains(G.jokers.highlighted, joker) then
                deletable_jokers[#deletable_jokers+1] = joker
            end
        end
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                for _, joker in pairs(deletable_jokers) do
                    joker:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.4,
            func = function()
                for i = 1, #G.jokers.highlighted do
                    local highlighted = G.jokers.highlighted[i]
                    local copied_joker = copy_card(highlighted, nil, nil, nil,
                        highlighted.edition and highlighted.edition.negative)
                    copied_joker:start_materialize()
                    copied_joker:add_to_deck()
                    if copied_joker.edition and copied_joker.edition.negative then
                        copied_joker:set_edition(nil, true)
                    end
                    G.jokers:emplace(copied_joker)
                end
                return true
            end
        }))
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {vars = {card.ability.max_highlighted}}
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.edition and v.edition.negative then
                    info_queue[#info_queue+1] = G.P_CENTERS.e_negative
                    ret.main_end = {}
                    localize{type = 'other', key = 'remove_negative', nodes = ret.main_end, vars = {}}
                    ret.main_end = ret.main_end[1]
                    break
                end
            end
        end
        return ret
    end,
}

local repetite = {
    key = 'repetite',
    name = "Repetite",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 1, y = 4 },
    cost = 6,
    config = {extra = {seal = 'sgt_Blood'}, max_highlighted = 1},
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra.seal, nil, true)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seal]
        return {vars = {card.ability.max_highlighted}}
    end,
}

local megahex = {
    key = 'megahex',
    name = "Megahex",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 2, y = 4 },
    cost = 6,
    config = {max_highlighted = 1},
    can_use = function(self, card)
        for i = 1, #G.jokers.highlighted do
            local highlighted = G.jokers.highlighted[i]
            if highlighted.edition then return false end
        end
        return #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        local deletable_jokers = {}
        for _, joker in pairs(G.jokers.cards) do
            if not SMODS.is_eternal(joker, card) and not table.contains(G.jokers.highlighted, joker) then
                deletable_jokers[#deletable_jokers+1] = joker
            end
        end
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                for _, joker in pairs(deletable_jokers) do
                    joker:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.4,
            func = function()
                for i = 1, #G.jokers.highlighted do
                    G.jokers.highlighted[i]:set_edition('e_polychrome', true)
                end
                return true
            end
        }))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {vars = {card.ability.max_highlighted}}
    end,
}

local haze = {
    key = 'haze',
    name = "Haze",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 3, y = 4 },
    cost = 6,
    config = {extra = {seal = 'sgt_Space'}, max_highlighted = 1},
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra.seal, nil, true)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seal]
        return {vars = {card.ability.max_highlighted}}
    end,
}

local cartomancy = {
    key = 'cartomancy',
    name = "Cartomancy",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 4, y = 4 },
    cost = 6,
    config = {extra = {seal = 'sgt_Cyan'}, max_highlighted = 1},
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra.seal, nil, true)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seal]
        return {vars = {card.ability.max_highlighted}}
    end,
}

local exotic = {
    key = 'exotic',
    name = "Exotic",
    set = 'Eldritch',
    atlas = "ultra",
    pos = { x = 5, y = 4 },
    cost = 6,
    config = {max_highlighted = 1, extra = {cards = 1}},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                local _first_dissolve = nil
                local new_cards = {}
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:add_sticker("sgt_protected", true)
                    for _ = 1, card.ability.extra.cards do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card:start_materialize(nil, _first_dissolve)
                        _first_dissolve = true
                        new_cards[#new_cards+1] = _card
                    end
                end
                SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                return true
            end
        }))
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards, card.ability.max_highlighted}}
    end,
}

local sinister = {
    key = "sinister",
    name = "The Sinister",
    set = "Eldritch",
    atlas = "ultra",
    pos = {x = 6, y = 4},
    config = {},
    cost = 4,
    hidden = true,
    soul_set = "Divinatio",
    can_use = function(self, card)
        for _, v in ipairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
            if v.ability.set == "Joker" then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for _, v in ipairs(SMODS.merge_lists{G.jokers.cards, G.consumeables.cards}) do
                if v.ability.set == "Joker" then
                    v:add_sticker("perishable", true)
                end
            end
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            assert(SMODS.add_card({
                set = "Lovecraft",
                skip_materialize = true,
            }))
            return true end }))
        delay(0.6)
	end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and Sagatro.mod_compat.talisman
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if not Sagatro.mod_compat.talisman then
            ret.main_end = {}
            localize{type = "other", key = "sgt_require_talisman_generic", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

local void_hole = {
    key = "void_hole",
    name = "Void Hole",
    set = "Eldritch",
    atlas = "ultra",
    pos = {x = 0, y = 6},
    config = {amount = 3},
    cost = 4,
    hidden = true,
    soul_set = "Celestara",
    select_card = "consumeables",
    can_use = function(self, card)
        return true
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.selected_buffer = card.selected_buffer or 0
            if G.STATE == G.STATES.SELECTING_HAND then
                if #G.hand.highlighted ~= card.selected_buffer then
                    card.selected_buffer = #G.hand.highlighted
                    local text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                    for _, celestara_card in pairs(G.P_CENTER_POOLS.Celestara) do
                        if text == celestara_card.config.hand_type then
                            card.hand_type_trigger = celestara_card.key
                            break
                        end
                    end
                end
                if #G.hand.highlighted == 0 then
                    card.hand_type_trigger = "c_sgt_void_hole"
                end
            else
                card.hand_type_trigger = "c_sgt_void_hole"
            end
        else
            card.hand_type_trigger = "c_sgt_void_hole"
        end
    end,
    calculate = function(self, card, context)
        for _, celestara_card in pairs(G.P_CENTER_POOLS.Celestara) do
            if context.before and not context.blueprint and not context.retrigger_joker
            and context.scoring_name == celestara_card.config.hand_type then
                if to_big(G.GAME.hands[context.scoring_name].level) > to_big(1) then
                    local t = copy_table(celestara_card.config)
                    for k, v in pairs(t) do
                        card.ability[k] = v
                    end
                    SMODS.calculate_effect({message = localize("k_downgrade_ex"), level_up = -1, no_retrigger = true}, card)
                    for _, hand_type in ipairs(card.ability.dissonance or {}) do
                        SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, card)
                        SMODS.smart_level_up_hand(card, hand_type)
                    end
                    if context.scoring_name == "Pair" then
                        local selected_cards = Sagatro.random_select("argyra_steel", G.hand, 2)
                        for _, v in ipairs(selected_cards) do
                            v:set_ability(G.P_CENTERS.m_steel, nil, true)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    v:juice_up()
                                    return true
                                end
                            }))
                        end
                    elseif context.scoring_name == "Three of a Kind" then
                        context.scoring_hand[1]:set_ability(G.P_CENTERS.m_lucky, nil, true)
                        context.scoring_hand[2]:set_ability(G.P_CENTERS.m_wild, nil, true)
                        for i = 1, 2 do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    context.scoring_hand[i]:juice_up()
                                    return true
                                end
                            }))
                        end
                    elseif context.scoring_name == "Full House" then
                        for _, _card in ipairs(G.hand.cards) do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    assert(SMODS.modify_rank(_card, 1))
                                    _card:juice_up()
                                    return true
                                end
                            }))
                        end
                    elseif context.scoring_name == "Four of a Kind" then
                        G.E_MANAGER:add_event(Event({func = function()
                            local selected_cards = Sagatro.random_select("valora_destroy", G.deck, 2)
                            local count = #selected_cards
                            if count > 0 then
                                SMODS.destroy_cards(selected_cards, nil, true)
                                G.deck.config.card_limit = G.deck.config.card_limit - count
                            end
                        return true end}))
                    elseif context.scoring_name == "Flush" then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local new_cards = {}
                                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                                local new_card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                                table.insert(new_cards, new_card)
                                new_card:add_to_deck()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, new_card)
                                G.deck:emplace(new_card)
                                context.full_hand[1]:juice_up()
                                new_card:juice_up()
                                playing_card_joker_effects(new_cards)
                                G.deck:shuffle('zephyria_shuffle')
                                return true
                            end
                        }))
                    elseif context.scoring_name == "Straight" then
                        for _, v in ipairs(context.full_hand) do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    if not SMODS.has_no_rank(v) then
                                    local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('chronara_random_rank'))
                                    assert(SMODS.change_base(v, nil, _rank.key))
                                    v:juice_up()
                                end
                                return true
                            end
                        }))
                        end
                        G.E_MANAGER:add_event(Event({trigger = "immediate", func = (function()
                            assert(SMODS.add_card({
                                set = "Spectral",
                                key_append = "chronara",
                            }))
                            return true end)}))
                        SMODS.calculate_effect({message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral}, card)
                    elseif context.scoring_name == "Two Pair" then
                        if G.hand.cards[1] then
                            G.hand.cards[1]:set_ability(G.P_CENTERS.m_sgt_crystal, nil, true)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.hand.cards[1]:juice_up()
                                    return true
                                end
                            }))
                        end
                    elseif context.scoring_name == "Straight Flush" then
                        if G.hand.cards[1] then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    copy_card(context.scoring_hand[1], G.hand.cards[1])
                                    G.hand.cards[1]:juice_up()
                                    return true
                                end
                            }))
                        end
                    elseif context.scoring_name == "Five of a Kind" then
                        for _, v in ipairs(context.scoring_hand) do
                            v.ability.perma_x_mult = v.ability.perma_x_mult + card.ability.perma_x_mult_mod
                            SMODS.calculate_effect({message = localize("k_upgrade_ex"), no_retrigger = true}, v)
                        end
                    elseif context.scoring_name == "Flush House" then
                        context.scoring_hand[1]:set_edition(poll_edition('ceratek_edition', nil, nil, true), nil, nil, true)
                    elseif context.scoring_name == "Flush Five" then
                        context.scoring_hand[1]:set_ability(G.P_CENTERS.m_sgt_gravistone, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                context.scoring_hand[1]:juice_up()
                                return true
                            end
                        }))
                    end
                    card.ability.amount = card.ability.amount - 1
                    card.reduced = true
                    if card.ability.amount <= 0 then
                        card.triggered = true
                    end
                    delay(0.25*G.SETTINGS.GAMESPEED)
                end
            end
            if context.repetition and context.cardarea == G.hand and not context.blueprint and not context.retrigger_joker
            and (next(context.card_effects[1]) or #context.card_effects > 1)
            and context.scoring_name == "High Card" then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                }
            end
            if context.after and not context.blueprint and not context.retrigger_joker then
                if card.triggered then
                    Sagatro.self_destruct(card, {no_destruction_context = true})
                    return {
                        message = localize('k_consumed_ex'),
                        colour = G.C.FILTER,
                    }
                elseif card.reduced then
                    card.reduced = nil
                    return {
                        message = card.ability.amount..'',
                        colour = G.C.FILTER,
                        no_retrigger = true
                    }
                end
            end
        end
    end,
    use = function(self, card, area, copier)
        G.GAME.celestara_tooltip = nil
        if (G.SETTINGS.FASTFORWARD or 0) == 0 then
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true end }))
            update_hand_text({delay = 0}, {mult = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true end }))
            update_hand_text({delay = 0}, {chips = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+'..card.ability.amount})
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(card, k, true, card.ability.amount)
            end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        else
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
            return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0.3}, {chips = '+', mult = '+', level='+'..card.ability.amount, StatusText = true})
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(card, k, true, card.ability.amount)
            end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
	end,
    bulk_use = function(self, card, area, copier, amount)
        G.GAME.celestara_tooltip = nil
        if (G.SETTINGS.FASTFORWARD or 0) == 0 then
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true end }))
            update_hand_text({delay = 0}, {mult = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true end }))
            update_hand_text({delay = 0}, {chips = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+'..card.ability.amount * (amount or 1)})
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(card, k, true, card.ability.amount * (amount or 1))
            end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        else
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
            return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0.3}, {chips = '+', mult = '+', level='+'..card.ability.amount * (amount or 1), StatusText = true})
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(card, k, true, card.ability.amount * (amount or 1))
            end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
    loc_vars = function(self, info_queue, card)
        card = card or SMODS.Center.create_fake_card(self)
        if card.hand_type_trigger == "c_sgt_void_hole" then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_void_hole_guide"}
        elseif card.hand_type_trigger == "c_sgt_argyra" then
            info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        elseif card.hand_type_trigger == "c_sgt_sulvatera" then
            info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
            info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        elseif card.hand_type_trigger == "c_sgt_aetheron" then
            info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_crystal
        elseif card.hand_type_trigger == "c_sgt_discordia" then
            info_queue[#info_queue+1] = G.P_CENTERS.m_sgt_gravistone
        end
        if G.GAME.celestara_tooltip then
            info_queue[#info_queue+1] = {set = "Other", key = "sgt_celestara_help"}
        end
        local ret = {vars = {card.ability.amount, localize("sgt_Any", "poker_hands")}}
        if Overflow and not card.fake_card then
            ret.main_end = {}
            localize{type = "other", key = "sgt_overflow_text", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
    joker_display_def = function(JokerDisplay)
        return {
            calc_function = function(card)
                card.joker_display_values.is_high_card = false
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands[card.ability.hand_type] and next(poker_hands[card.ability.hand_type]) then
                    card.joker_display_values.is_high_card = true
                end
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                return held_in_hand and joker_card.joker_display_values.is_high_card
                and 1 or 0 -- consumables cannot be retriggered by another joker
            end
        }
    end,
}

local consumable_table = {
    exodium,
    dominus_ars,
    sacra_sapientia,
    regina_caeli,
    rex_divinus,
    sacerdos,
    sacra_nexus,
    triumpus,
    vitus_aeterna,
    lux_veritatix,
    orbis_fatum,
    iustitia_sacra,
    sacrificium,
    trasitus,
    concordia,
    umba_aeterna,
    runis_sacris,
    stella_divina,
    luna_mystica,
    sol_invictus,
    utima_vox,
    aeternum,
    anima,
    argyra,
    sulvatera,
    terranora,
    valora,
    zephyria,
    chronara,
    aetheron,
    oceanis,
    lonestra,
    mystara,
    ceratek,
    discordia,
    soltera,
    demon,
    merciless,
    chanting,
    amulet,
    emanate,
    spectre,
    magiseal,
    lexicon,
    substance,
    slaughter,
    crux_ansata,
    repetite,
    megahex,
    haze,
    cartomancy,
    exotic,
    sinister,
    void_hole,
}

for _, v in ipairs(consumable_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Consumable(v)
end

local favor = {
    key = "favor",
    name = "Favor Card",
    effect = "Favor",
    atlas = "ultra",
    pos = {x = 4, y = 2},
    config = {extra = {perma_bonus = 10}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            for _, v in ipairs(context.full_hand) do
                v.ability.perma_bonus = v.ability.perma_bonus + card.ability.extra.perma_bonus
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.perma_bonus}}
    end,
}

local exponent = {
    key = "exponent",
    name = "Exponent Card",
    effect = "Exponent",
    atlas = "ultra",
    pos = {x = 5, y = 2},
    config = {extra = {e_mult = 1.04}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                sgt_e_mult = card.ability.extra.e_mult,
                card = card,
            }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.e_mult}}
    end,
}

local strange = {
    key = "strange",
    name = "Strange Card",
    effect = "Strange",
    atlas = "ultra",
    pos = {x = 6, y = 2},
    config = {extra = {odds = 6}},
    any_suit = true,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, 'strange_infection', 1, card.ability.extra.odds) then
                local targets = {}
                for i, v in ipairs(context.full_hand) do
                    if v == card then
                        if context.full_hand[i-1] then
                            targets[#targets+1] = context.full_hand[i-1]
                        end
                        if context.full_hand[i+1] then
                            targets[#targets+1] = context.full_hand[i+1]
                        end
                    end
                end
                if #targets > 0 then
                    local target = pseudorandom_element(targets, pseudoseed("strange_target"))
                    target:set_ability(G.P_CENTERS.m_sgt_strange, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "strange_infection")}}
    end,
}

local nyx_glass = {
    key = "nyx_glass",
    name = "Nyx Glass Card",
    effect = "Nyx Glass",
    atlas = "ultra",
    pos = {x = 8, y = 2},
    config = {x_mult = 1.5, extra = {x_mult_mod = 0.1, odds = 50}},
    shatters = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.no_shadow = true
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if SMODS.scale_card then
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "x_mult",
                    scalar_table = card.ability.extra,
                    scalar_value = "x_mult_mod",
                    no_message = true
                })
            else
                card.ability.x_mult = card.ability.x_mult + card.ability.extra.x_mult_mod
            end
            card.ability.extra.odds = card.ability.extra.odds - 1
            if card.ability.extra.odds < (Cryptid and 0.001 or 1) then
                card.ability.extra.odds = Cryptid and 0.001 or 1
            end
        end
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card
        and SMODS.pseudorandom_probability(card, 'nyx_glass', 1, card.ability.extra.odds) then
            card.glass_trigger = true
            return { remove = true }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.x_mult, card.ability.extra.x_mult_mod, SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "nyx_glass")}}
    end,
}

local titanium = {
    key = "titanium",
    name = "Titanium Card",
    effect = "Titanium",
    atlas = "ultra",
    pos = {x = 9, y = 2},
    config = {h_x_mult = 1.5, extra = {h_x_mult_mod = 0.25, held_in_hand_ge = 7}, immutable = {base_h_x_mult = 1.5}},
    update = function(self, card, dt)
        card.ability.h_x_mult = card.ability.immutable.base_h_x_mult
        + (G and G.hand and G.hand.cards and #G.hand.cards > card.ability.extra.held_in_hand_ge
        and #G.hand.cards - card.ability.extra.held_in_hand_ge or 0)*card.ability.extra.h_x_mult_mod
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.h_x_mult, card.ability.extra.h_x_mult_mod, card.ability.extra.held_in_hand_ge}}
    end,
}

local abyss_stone = {
    key = "abyss_stone",
    name = "Abyss Stone Card",
    effect = "Abyss Stone",
    atlas = "ultra",
    pos = {x = 4, y = 5},
    config = {abyss_stone_tally = 0, bonus = 50, extra = {bonus_mod = 25}, immutable = {base_bonus = 50}},
    replace_base_card = true,
    override_base_rank = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    update = function(self, card, dt)
        card.ability.abyss_stone_tally = 0
        for _, v in pairs(G.playing_cards or {}) do
            if v ~= card and SMODS.has_no_rank(v) then
                card.ability.abyss_stone_tally = card.ability.abyss_stone_tally + 1
            end
        end
        card.ability.bonus = card.ability.immutable.base_bonus + card.ability.abyss_stone_tally*card.ability.extra.bonus_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        card.ability.bonus = card.ability.immutable.base_bonus
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.bonus, card.ability.extra.bonus_mod}}
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local always_show = self.config and self.config.always_show or {}
        if specific_vars and specific_vars.nominal_chips and not self.replace_base_card then
            localize { type = 'other', key = 'card_chips', nodes = desc_nodes, vars = { specific_vars.nominal_chips } }
        end
        SMODS.Enhancement.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if specific_vars and specific_vars.bonus_chips then
            local remaining_bonus_chips = specific_vars.bonus_chips - (card.ability.bonus or self.config.bonus or 0)
            if remaining_bonus_chips ~= 0 then
                localize { type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = { SMODS.signed(remaining_bonus_chips) } }
            end
        end
        if SMODS.localize_perma_bonuses then
            SMODS.localize_perma_bonuses(specific_vars, desc_nodes)
        else
            if specific_vars and specific_vars.bonus_x_chips then
                localize{type = 'other', key = 'card_x_chips', nodes = desc_nodes, vars = {specific_vars.bonus_x_chips}}
            end
            if specific_vars and specific_vars.bonus_mult then
                localize{type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_mult)}}
            end
            if specific_vars and specific_vars.bonus_x_mult then
                localize{type = 'other', key = 'card_x_mult', nodes = desc_nodes, vars = {specific_vars.bonus_x_mult}}
            end
            if specific_vars and specific_vars.bonus_h_chips then
                localize{type = 'other', key = 'card_extra_h_chips', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_h_chips)}}
            end
            if specific_vars and specific_vars.bonus_x_chips then
                localize{type = 'other', key = 'card_h_x_chips', nodes = desc_nodes, vars = {specific_vars.bonus_h_x_chips}}
            end
            if specific_vars and specific_vars.bonus_h_mult then
                localize{type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = {SMODS.signed(specific_vars.bonus_h_mult)}}
            end
            if specific_vars and specific_vars.bonus_h_x_mult then
                localize{type = 'other', key = 'card_h_x_mult', nodes = desc_nodes, vars = {specific_vars.bonus_h_x_mult}}
            end
            if specific_vars and specific_vars.bonus_p_dollars then
                localize{type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = {SMODS.signed_dollars(specific_vars.bonus_p_dollars)}}
            end
            if specific_vars and specific_vars.bonus_h_dollars then
                localize{type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = {SMODS.signed_dollars(specific_vars.bonus_h_dollars)}}
            end
            if specific_vars and specific_vars.bonus_repetitions then
                localize{type = 'other', key = 'card_extra_repetitions', nodes = desc_nodes, vars = {specific_vars.bonus_repetitions, localize(specific_vars.bonus_repetitions > 1 and 'b_retrigger_plural' or 'b_retrigger_single')}}
            end
        end
    end,
}

local platinum = {
    key = "platinum",
    name = "Platinum Card",
    effect = "Platinum",
    atlas = "ultra",
    pos = {x = 5, y = 5},
    config = {d_dollars = 3},
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and context.other_card == card then
            ease_dollars(card.ability.d_dollars)
            return {
                message = localize('$')..card.ability.d_dollars,
                colour = G.C.MONEY,
            }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.d_dollars}}
    end,
}

local ancient_lucky = {
    key = "ancient_lucky",
    name = "Ancient Lucky Card",
    effect = "Ancient Lucky",
    atlas = "ultra",
    pos = {x = 7, y = 2},
    config = {extra = {perma_mult = 5, perma_p_dollars = 5, mult_odds = 5, dollar_odds = 15}},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local mult_up = nil
            if SMODS.pseudorandom_probability(card, 'ancient_lucky_mult', 1, card.ability.extra.mult_odds) then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability,
                        ref_value = "perma_mult",
                        scalar_table = card.ability.extra,
                        scalar_value = "perma_mult",
                        no_message = true
                    })
                else
                    card.ability.perma_mult = card.ability.perma_mult + card.ability.extra.perma_mult
                end
                card.lucky_trigger = true
                mult_up = true
            end
            if SMODS.pseudorandom_probability(card, 'ancient_lucky_money', 1, card.ability.extra.dollar_odds) then
                if SMODS.scale_card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability,
                        ref_value = "perma_p_dollars",
                        scalar_table = card.ability.extra,
                        scalar_value = "perma_p_dollars",
                        no_message = true
                    })
                else
                    card.ability.perma_p_dollars = card.ability.perma_p_dollars + card.ability.extra.perma_p_dollars
                end
                card.lucky_trigger = true
            end
            if card.lucky_trigger then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = mult_up and G.C.MULT or G.C.MONEY,
                    card = card,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, card)
        local nm, dm = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds, "ancient_lucky_mult")
        local nd, dd = SMODS.get_probability_vars(card, 1, card.ability.extra.dollar_odds, "ancient_lucky_money")
        return {vars = {nm, dm, card.ability.extra.perma_mult, nd, dd, card.ability.extra.perma_p_dollars}}
    end,
}

local crystal = {
    key = "crystal",
    name = "Crystal Card",
    effect = "Crystal",
    atlas = "ultra",
    pos = {x = 4, y = 7},
    config = {x_chips = 1.25, extra = {x_chip_mod = 0.25}, immutable = {base_x_chips = 1.25}},
    shatters = true,
    set_ability = function(self, card, initial, delay_sprites)
        card.no_shadow = true
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            if card.area == G.play then
                local other_crystal_count = 0
                for _, v in ipairs(G.play.cards) do
                    if v ~= card and SMODS.has_enhancement(v, "m_sgt_crystal") then
                        other_crystal_count = other_crystal_count + 1
                    end
                end
                card.ability.x_chips = card.ability.immutable.base_x_chips
                + card.ability.extra.x_chip_mod*other_crystal_count
            else
                card.ability.x_chips = card.ability.immutable.base_x_chips
            end
        else
            card.ability.x_chips = card.ability.immutable.base_x_chips
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.x_chips, card.ability.extra.x_chip_mod}}
    end,
}

local gravistone = {
    key = "gravistone",
    name = "Gravistone Card",
    effect = "Gravistone",
    atlas = "ultra",
    pos = {x = 5, y = 7},
    config = {bonus = 20},
    replace_base_card = true,
    override_base_rank = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and not card.debuff then
            if card.area == G.hand and not card.ability.gravistone_triggered then
                card.ability.gravistone_triggered = true
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
            elseif card.area ~= G.hand and card.ability.gravistone_triggered then
                card.ability.gravistone_triggered = nil
                SMODS.change_play_limit(-1)
                SMODS.change_discard_limit(-1)
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.gravistone_triggered then
            card.ability.gravistone_triggered = nil
            SMODS.change_play_limit(-1)
            SMODS.change_discard_limit(-1)
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.bonus}}
    end,
}

local enhancement_table = {
    favor,
    exponent,
    strange,
    nyx_glass,
    titanium,
    abyss_stone,
    platinum,
    ancient_lucky,
    crystal,
    gravistone,
}

for _, v in ipairs(enhancement_table) do
    SMODS.Enhancement(v)
end

local blood = {
    key = "Blood",
    name = "Blood Seal",
    atlas = "ultra",
    pos = {x = 1, y = 5},
    badge_colour = HEX('D32720'),
    config = {extra = {retriggers = 2}},
    calculate = function(self, card, context)
        if context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.extra.retriggers or self.config.extra.retriggers}}
    end,
}

local cyan = {
    key = "Cyan",
    name = "Holy Seal",
    atlas = "ultra",
    pos = {x = 0, y = 5},
    badge_colour = HEX('62D7DC'),
    calculate = function(self, card, context)
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card{set = 'Divinatio', key_append = "cya"}
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return {
                message = localize('k_plus_divinatio'),
                colour = G.C.SGT_DIVINATIO,
            }
        end
    end,
    draw = function(self, card, layer)
        if card.seal and card.seal == self.key then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
}

local space = {
    key = "Space",
    name = "Space Seal",
    atlas = "ultra",
    pos = {x = 2, y = 5},
    badge_colour = HEX('092332'),
    calculate = function(self, card, context)
        if context.playing_card_end_of_round and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if G.GAME.last_hand_played then
                        local _celestara = nil
                        for _, v in pairs(G.P_CENTER_POOLS.Celestara) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _celestara = v.key
                            end
                        end
                        if _celestara then
                            SMODS.add_card{key = _celestara, key_append = "spasl"}
                        end
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return {
                message = localize('k_plus_celestara'),
                colour = G.C.SGT_CELESTARA
            }
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
}

local platinum = {
    key = "Platinum",
    name = "Platinum Seal",
    atlas = "ultra",
    pos = {x = 3, y = 5},
    badge_colour = HEX('B4B4B4'),
    config = {dollars = 6},
    get_p_dollars = function(self, card)
        return card.ability.seal.dollars
    end,
    draw = function(self, card, layer)
        if card.seal and card.seal == self.key then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.seal.dollars or self.config.dollars}}
    end,
}

local seal_table = {
    blood,
    cyan,
    space,
    platinum,
}

for _, v in ipairs(seal_table) do
    SMODS.Seal(v)
end

local oculus_divina = {
    key = "oculus_divina",
    name = "Oculus Divina",
    atlas = "ultra",
    pos = {x = 8, y = 5},
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local oculus_omniscientis = {
    key = "oculus_omniscientis",
    name = "Oculus Omniscientis",
    atlas = "ultra",
    pos = {x = 9, y = 5},
    config = {extra = {rate = 2}},
    requires = {"v_sgt_oculus_divina"},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.divinatio_rate == 0 then
                    G.GAME.divinatio_rate = card.ability.extra.rate
                end
                return true
            end
        }))
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local alien_life = {
    key = "alien_life",
    name = "Alien Life",
    atlas = "ultra",
    pos = {x = 0, y = 7},
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local civilization = {
    key = "civilization",
    name = "Civilization",
    atlas = "ultra",
    pos = {x = 1, y = 7},
    config = {extra = {rate = 2}},
    requires = {"v_sgt_alien_life"},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.celestara_rate == 0 then
                    G.GAME.celestara_rate = card.ability.extra.rate
                end
                return true
            end
        }))
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local shadow_oath = {
    key = "shadow_oath",
    name = "Shadow Oath",
    atlas = "ultra",
    pos = {x = 8, y = 4},
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local abyss_pact = {
    key = "abyss_pact",
    name = "Abyss Pact",
    atlas = "ultra",
    pos = {x = 9, y = 4},
    config = {extra = {rate = 1}},
    requires = {"v_sgt_shadow_oath"},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.eldritch_rate == 0 then
                    G.GAME.eldritch_rate = card.ability.extra.rate
                end
                return true
            end
        }))
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local voucher_table = {
    oculus_divina,
    oculus_omniscientis,
    alien_life,
    civilization,
    shadow_oath,
    abyss_pact,
}

for _, v in ipairs(voucher_table) do
    if Sagatro.debug then
        v.unlocked = true
        v.discovered = true
    end
    SMODS.Voucher(v)
end