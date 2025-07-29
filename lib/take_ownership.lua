SMODS.Booster:take_ownership_by_kind('Buffoon', {
    create_card = function(self, card, i)
        local _card = {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"}
        if G.GAME.story_mode then
            if G.GAME.saga_event.alice_in_wonderland.white_rabbit_house and i == 1 then
                _card.key = "j_sgt_unlabeled_bottle"
            elseif G.GAME.saga_event.alice_in_wonderland.goodbye_frog then
                _card.set = "Goodbye Frog"
            elseif G.GAME.saga_event_check.alice_in_wonderland.goodbye_frog and i == 1
            and not G.GAME.saga_event.alice_in_wonderland.mad_hatter
            and not G.GAME.saga_event_check.alice_in_wonderland.mad_hatter then
                _card.key = "j_sgt_mad_hatter"
            elseif G.GAME.saga_event.alice_in_wonderland.red_queen and i == 1
            and not next(SMODS.find_card("j_sgt_red_queen", true)) then
                _card.key = "j_sgt_red_queen"
            elseif G.GAME.saga_event.alice_in_wonderland.gryphon and i == 1
            and not next(SMODS.find_card("j_sgt_gryphon", true)) then
                _card.key = "j_sgt_gryphon"
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
        if G.GAME.used_vouchers.v_sgt_oculus_divina and pseudorandom('oculus_divina') > 0.8 then
            _card.set = "Divinatio"
            _card.soulable = false
            _card.key_append = "ar3"
        end
        return _card
    end,
},
true
)

SMODS.Booster:take_ownership_by_kind('Spectral', {
    create_card = function(self, card, i)
        local _card = {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "spe"}
        if G.GAME.used_vouchers.v_sgt_shadow_oath and pseudorandom('shadow_oath') > 0.8 then
            _card.set = "Eldritch"
            _card.soulable = false
            _card.key_append = "spe2"
        end
        return _card
    end,
},
true
)

SMODS.Joker:take_ownership('splash',
	{
		add_to_deck = function(self, card, from_debuff)
            if G.GAME.story_mode then
                if (#SMODS.find_card("j_splash", true) > 0 or (next(SMODS.find_card("j_sgt_dodo_bird", true))
                and not G.GAME.saga_event_check.alice_in_wonderland.white_rabbit_house)) and not from_debuff then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, 1, nil, {message = localize('k_overflow_ex'), sound = "tarot1", volume = 1 , instant = true})
                            ease_dollars(card.cost)
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                    return true;
                                end
                            }))
                            return true
                        end
                    }))
                end
            end
        end,
	},
	true
)