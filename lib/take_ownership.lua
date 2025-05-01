SMODS.Booster:take_ownership_by_kind('Buffoon', {
    create_card = function(self, card, i)
        local _card = {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"}
        if Sagatro.config.DisableOtherJokers then
            if G.GAME.saga_event.alice_in_wonderland.little_bill and i == 1 then
                _card.key = "j_sgt_unlabeled_bottle"
            end
        end
        return _card
    end,
},
true
)