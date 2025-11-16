SMODS.DeckSkin{
    key = "alice_in_wonderland_ds",
    suit = "Hearts",
    loc_txt = {
        -- For some dunk reason SMODS does shit at handling loc entries for deck skins
        -- defining loc_txt is inevitable because of it
        ["en-us"] = "Alice in the Wonderland",
        ["vi"] = "Alice ở Xứ Sở Diệu Kì",
    },
    palettes = {
        {
            key = 'lc',
            ranks = {'King', 'Queen', 'Jack'},
            atlas = 'sgt_alice_in_wonderland_ds_lc',
            pos_style = 'collab'
        },
        {
            key = 'hc',
            ranks = {'King', 'Queen', 'Jack'},
            atlas = 'sgt_alice_in_wonderland_ds_hc',
            pos_style = 'collab',
            hc_default = true,
        },
    },
    generate_ds_card_ui = function(card, deckskin, palette, info_queue, desc_nodes, specific_vars, full_UI_table)
        if card.base.value == "Jack" then
            localize{type = 'other', key = 'artist', nodes = desc_nodes, vars = {}}
            localize{type = 'other', key = 'artist_credit', nodes = desc_nodes, vars = { "Amy" }}
        elseif card.base.value == "Queen" or card.base.value == "King" then
            localize{type = 'other', key = 'artist', nodes = desc_nodes, vars = {}}
            localize{type = 'other', key = 'artist_credit', nodes = desc_nodes, vars = { "HuyCorn" }}
        end
    end,
    has_ds_card_ui = function(card, deckskin, palette)
        return true
    end
}