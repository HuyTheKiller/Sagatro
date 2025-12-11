SMODS.Booster:take_ownership_by_kind('Buffoon', {
    create_card = function(self, card, i)
        local _card = {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"}
        if G.GAME.story_mode then
            if Sagatro.storyline_check("none") then
                _card.set = "Story Starter"
            elseif Sagatro.event_check("white_rabbit_house") and i == 1 then
                _card.key = "j_sgt_unlabeled_bottle"
            elseif Sagatro.event_check("goodbye_frog") then
                _card.set = "Goodbye Frog"
            elseif Sagatro.event_check("goodbye_frog", nil, {contain = true}) and i == 1
            and Sagatro.event_check("mad_hatter", false) then
                _card.key = "j_sgt_mad_hatter"
            elseif Sagatro.event_check("red_queen") and i == 1
            and not next(SMODS.find_card("j_sgt_red_queen", true)) then
                _card.key = "j_sgt_red_queen"
            elseif Sagatro.event_check("gryphon") and i == 1 then
                if not next(SMODS.find_card("j_sgt_gryphon", true)) then
                    _card.key = "j_sgt_gryphon"
                else
                    _card.key = "j_sgt_mock_turtle"
                end
            elseif Sagatro.event_check("finding_the_submarine") and i == 1 then
                _card.key = "j_sgt_submarine"
            elseif Sagatro.event_check("the_sub_engineer") and i == 1 then
                _card.key = "j_sgt_sub_engineer"
            end
        end
        return _card
    end,
},
true
)

SMODS.Booster:take_ownership_by_kind('Arcana', {
    create_card = function(self, card, i)
        local _card = {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
        if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
            _card.set = "Spectral"
            _card.key_append = "ar2"
        end
        if not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_oculus_divina and pseudorandom('oculus_divina') > 0.8 then
            _card.set = "Divinatio"
            _card.soulable = false
            _card.key_append = "ar3"
        end
        return _card
    end,
},
true
)

SMODS.Booster:take_ownership_by_kind('Celestial', {
    create_card = function(self, card, i)
        local _card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "pl1"}
        if G.GAME.used_vouchers.v_telescope and i == 1 then
            local _planet, _hand, _tally = nil, nil, 0
            for k, v in ipairs(G.handlist) do
                if SMODS.is_poker_hand_visible(v) and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            if _hand then
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == _hand then
                        _planet = v.key
                    end
                end
            end
            _card.key = _planet
        end
        if G.GAME.used_vouchers.v_sgt_alien_life and i == 2 then
            _card.set = "Celestara"
            _card.soulable = false
            _card.key_append = "pl2"
        end
        return _card
    end,
    select_card = {Celestara = "consumeables"},
},
true
)

SMODS.Booster:take_ownership_by_kind('Spectral', {
    create_card = function(self, card, i)
        local _card = {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "spe"}
        if not G.GAME.modifiers.sgt_disable_sagatro_items and G.GAME.used_vouchers.v_sgt_shadow_oath and pseudorandom('shadow_oath') > 0.8 then
            _card.set = "Eldritch"
            _card.soulable = false
            _card.key_append = "spe2"
        end
        return _card
    end,
},
true
)

local splash_add_to_deck = G.P_CENTERS.j_splash.add_to_deck
SMODS.Joker:take_ownership('splash',
	{
		add_to_deck = function(self, card, from_debuff)
            if splash_add_to_deck and type(splash_add_to_deck) == "function" then
                splash_add_to_deck(self, card, from_debuff)
            end
            if G.GAME.story_mode then
                if (#SMODS.find_card("j_splash", true) > 0 or (next(SMODS.find_card("j_sgt_dodo_bird", true))
                and Sagatro.event_check("white_rabbit_house", nil, true))) and not from_debuff then
                    local func = function()
                        card_eval_status_text(card, 'extra', nil, 1, nil, {message = localize('k_overflow_ex'), sound = "tarot1", volume = 1, instant = true})
                        ease_dollars(card.cost)
                    end
                    Sagatro.self_destruct(card, {no_destruction_context = true, no_sound = true}, func)
                end
            end
        end,
	},
	true
)

-- Make non-rerollable bosses not spawn Boss Tag (yea, this somehow isn't working but it's fine)
local boss_tag_in_pool = G.P_TAGS.tag_boss.in_pool
SMODS.Tag:take_ownership('boss',
    {
        in_pool = function(self, args)
            if G.GAME.story_mode and table.contains(Sagatro.story_mode_no_reroll, G.GAME.round_resets.blind_choices.Boss) then
                return false
            end
            if boss_tag_in_pool and type(boss_tag_in_pool) == "function" then
                return boss_tag_in_pool(self, args)
            end
            return true
        end,
    },
    true
)