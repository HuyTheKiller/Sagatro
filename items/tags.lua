local holy = {
    key = "holy",
    name = "Holy Tag",
    artist_credits = {"huythekiller"},
    atlas = "tags",
    pos = {x = 0, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SGT_DIVINATIO, function()
                local key = "p_sgt_divinatio_mega"
                local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                _card.cost = 0
                _card.from_tag = true
                G.FUNCS.use_card{config = {ref_table = _card}}
                _card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_omniscientis
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS.p_sgt_divinatio_mega
    end,
}

local ghostly = {
    key = "ghostly",
    name = "Ghostly Tag",
    artist_credits = {"huythekiller"},
    atlas = "tags",
    pos = {x = 1, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SGT_ELDRITCH, function()
                local key = "p_sgt_eldritch_normal_1"
                local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                _card.cost = 0
                _card.from_tag = true
                G.FUNCS.use_card{config = {ref_table = _card}}
                _card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_abyss_pact
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS.p_sgt_eldritch_normal_1
    end,
}

local alien = {
    key = "alien",
    name = "Alien Tag",
    artist_credits = {"huythekiller"},
    atlas = "tags",
    pos = {x = 2, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SGT_ELDRITCH, function()
                local key = "p_sgt_celestara_mega"
                local _card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                _card.cost = 0
                _card.from_tag = true
                G.FUNCS.use_card{config = {ref_table = _card}}
                _card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_civilization
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS.p_sgt_celestara_mega
    end,
}

local obscure = {
    key = "obscure",
    name = "Obscure Tag",
    artist_credits = {"huythekiller"},
    atlas = "tags",
    pos = {x = 3, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local card = nil
            local obscures_in_posession = {0}
            for k, v in ipairs(G.jokers.cards) do
                if v.config.center.rarity == "sgt_obscure" and not obscures_in_posession[v.config.center.key] then
                    obscures_in_posession[1] = obscures_in_posession[1] + 1
                    obscures_in_posession[v.config.center.key] = true
                end
            end

            if #G.P_JOKER_RARITY_POOLS["sgt_obscure"] > obscures_in_posession[1] then
                card = create_card('Joker', context.area, nil, "sgt_obscure", nil, nil, nil, 'ota')
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.SGT_OBSCURE,function()
                    card:start_materialize()
                    return true
                end)
            else
                tag:nope()
            end
            tag.triggered = true
            return card
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.modifiers.sgt_disable_sagatro_items
    end,
}

local tag_table = {
    holy,
    alien,
    ghostly,
    obscure,
}

for _, v in ipairs(tag_table) do
    if Sagatro.debug then
        v.discovered = true
    end
    SMODS.Tag(v)
end