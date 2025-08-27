local divinatio = {
    key = "Divinatio",
    primary_colour = HEX("f4ff00"),
	secondary_colour = G.C.SGT_DIVINATIO,
	collection_rows = { 5, 6 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_iustitia_sacra",
	can_stack = true,
	can_divide = true,
}

local eldritch = {
    key = "Eldritch",
    primary_colour = HEX("e264f9"),
	secondary_colour = G.C.SGT_ELDRITCH,
	collection_rows = { 4, 5 },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_sgt_chanting",
	can_stack = true,
	can_divide = true,
}

local consumabletype_table = {
    divinatio,
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

local un_uneldritch = {
    key = "Eldritch",
    atlas = "ultra",
    pos = {x = 6, y = 5},
}

local undiscovered_sprite_table = {
    un_divinatio,
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
        return (G.consumeables.config.card_limit > #G.consumeables.cards and G.GAME.last_tarot_planet_divinatio
        or (card.area == G.consumeables and G.consumeables.config.card_limit == #G.consumeables.cards))
        and G.GAME.last_tarot_planet_divinatio ~= 'c_fool' and G.GAME.last_tarot_planet_divinatio ~= 'c_sgt_exodium'
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card{ key = G.GAME.last_tarot_planet_divinatio }
                    card:juice_up(0.3, 0.5)
                end
                return true
            end
        }))
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        local fool_c = G.GAME.last_tarot_planet_divinatio and G.P_CENTERS[G.GAME.last_tarot_planet_divinatio] or nil
        local last_tarot_planet_divinatio = fool_c and localize { type = 'name_text', key = fool_c.key, set = fool_c.set }
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
                            { n = G.UIT.T, config = { text = ' ' .. last_tarot_planet_divinatio .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return { vars = { last_tarot_planet_divinatio }, main_end = main_end }
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
        return true
    end,
    use = function(self, card, area, copier)
        for _ = 1, card.ability.consumeable.planets do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card{ set = "Planet", edition = "e_negative", key_append = "sap" }
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
    dependencies = {"Talisman"},
    pos = {x = 2, y = 2},
    config = {},
    cost = 4,
    hidden = true,
    soul_set = "Eldritch",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
		local used_consumable = copier or card
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for _, v in ipairs(G.jokers.cards) do
                v:add_sticker("eternal", true)
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
        return not G.GAME.modifiers.sgt_disable_sagatro_items
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
        return #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.max_highlighted
        and #G.jokers.cards + #G.jokers.highlighted <= G.jokers.config.card_limit
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
    dependencies = {"Talisman"},
    pos = {x = 6, y = 4},
    config = {},
    cost = 4,
    hidden = true,
    soul_set = "Divinatio",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
		local used_consumable = copier or card
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for _, v in ipairs(G.jokers.cards) do
                v:add_sticker("perishable", true)
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
        return not G.GAME.modifiers.sgt_disable_sagatro_items
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
            card.ability.x_mult = card.ability.x_mult + card.ability.extra.x_mult_mod
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
    config = {h_x_mult = 1.5, extra = {h_x_mult_mod = 0.1, held_in_hand_ge = 7}, immutable = {base_h_x_mult = 1.5}},
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
        SMODS.localize_perma_bonuses(specific_vars, desc_nodes)
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
                card.ability.perma_mult = card.ability.perma_mult + card.ability.extra.perma_mult
                card.lucky_trigger = true
                mult_up = true
            end
            if SMODS.pseudorandom_probability(card, 'ancient_lucky_money', 1, card.ability.extra.dollar_odds) then
                card.ability.perma_p_dollars = card.ability.perma_p_dollars + card.ability.extra.perma_p_dollars
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

local enhancement_table = {
    favor,
    exponent,
    strange,
    nyx_glass,
    titanium,
    abyss_stone,
    platinum,
    ancient_lucky,
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
        if context.end_of_round and context.cardarea == G.hand and context.other_card == card then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                            end
                        end
                        if _planet then
                            SMODS.add_card{key = _planet, edition = "e_negative", key_append = "spasl"}
                        end
                    end
                    return true
                end
            }))
            return {
                message = localize('k_plus_planet'),
                colour = G.C.SECONDARY_SET.Planet,
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
                G.GAME.divinatio_rate = card.ability.extra.rate
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
                G.GAME.eldritch_rate = card.ability.extra.rate
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