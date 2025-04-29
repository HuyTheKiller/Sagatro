return {
    descriptions = {
        Joker = {
            j_sgt_white_rabbit = {
                name = "White Rabbit",
                text = {
                    "This joker gains {C:chips}+#2#{} Chips",
                    "if hand is played {C:attention}without{}",
                    "any discards used this round",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_sgt_drink_me = {
                name = "Drink Me!",
                text = {
                    "If this is the {C:attention}leftmost{} joker,",
                    "{C:attention}convert{} all scoring cards to {C:attention}2s{}",
                    "for the next {C:attention}#1#{} hand(s)",
                    "{s:0.8,C:inactive}Does not trigger if",
                    "{s:0.8,C:attention}Eat Me!{s:0.8,C:inactive} is at rightmost",
                },
            },
            j_sgt_eat_me = {
                name = "Eat Me!",
                text = {
                    "If this is the {C:attention}rightmost{} joker,",
                    "{C:attention}convert{} all scoring cards to {C:attention}Aces{}",
                    "for the next {C:attention}#1#{} hand(s)",
                    "{s:0.8,C:inactive}Does not trigger if",
                    "{s:0.8,C:attention}Drink Me!{s:0.8,C:inactive} is at leftmost",
                },
            },
            j_sgt_chesire_cat = {
                name = "Chesire Cat",
                text = {
                    "Copies ability of a random {C:attention}Joker{}",
					"when {C:attention}Blind{} is selected",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of round",
					"{C:inactive,s:0.9}(Copying {C:attention,s:0.9}#1#"..(SMODS.Mods["Sagatro"].debug and "{C:inactive,s:0.9}with value ID {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
                },
            },
            j_sgt_mouse = {
                name = "Mouse",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Stay {C:attention}debuffed{} if this joker is at",
                    "a {C:attention}previously known{} location this round",
                },
            },
        },
        Mod = {
            Sagatro = {
                name = "Sagatro",
                text = {
                    "{s:1.3}Adds {s:1.3,C:dark_edition}fairy tale {s:1.3}elements to Balatro.",
                    " ",
                    "Credits:",
                    "{C:attention}Art{}: HuyCorn, Amy",
                    "{C:attention}Idea{}: HuyCorn",
                    " ",
                    "Currently in demo. This mod aims to remove",
                    "all vanilla jokers in full release.",
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_in_a_hurry_ex = "In a hurry!",
            k_too_late_ex = "Too late!",
            k_shrunk_ex = "Shrunk!",
            k_enlarged_ex = "Enlarged!",
            k_grin_ex = "Grin!",
            k_gone_ex = "Gone!",
            SGT_disable_other_jokers = "Sagatro Jokers Only",
            SGT_disable_other_jokers_desc = {"Disable all jokers but those from this mod"},
        },
    },
}