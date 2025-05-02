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
                    "{s:0.8,C:attention}#2#{s:0.8,C:inactive} is at rightmost",
                },
            },
            j_sgt_eat_me = {
                name = "Eat Me!",
                text = {
                    "If this is the {C:attention}rightmost{} joker,",
                    "{C:attention}convert{} all scoring cards to {C:attention}Aces{}",
                    "for the next {C:attention}#1#{} hand(s)",
                    "{s:0.8,C:inactive}Does not trigger if",
                    "{s:0.8,C:attention}#2#{s:0.8,C:inactive} is at leftmost",
                },
            },
            j_sgt_cheshire_cat = {
                name = "Cheshire Cat",
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
                    "Stay {C:attention}debuffed{} if",
                    "this joker is at a {C:attention}previously",
                    "{C:attention}known{} location this round",
                },
            },
            j_sgt_kid_gloves_and_fan = {
                name = "Kid-gloves And The Fan",
                text = {
                    "If this is the {C:attention}leftmost{} joker:",
                    "Played cards {C:attention}lose{} #1# rank(s) when scored",
                    "Played 2s are {C:attention}destroyed{} after scoring",
                },
            },
            j_sgt_dodo_bird = {
                name = "Dodo Bird",
                text = {
                    "Each joker card gives {X:mult,C:white}X#1#{} Mult",
                    "on {C:attention}final hand{} of round with",
                    "{C:attention}0{} discards left",
                },
            },
            j_sgt_unlabeled_bottle = {
                name = "Unlabeled Bottle",
                text = {
                    "If this is the {C:attention}leftmost{} joker,",
                    "{C:attention}convert{} all scoring cards to {C:attention}Aces{}",
                    "for the next {C:attention}#1#{} hand(s)",
                },
            },
            j_sgt_unlabeled_bottle_collection = {
                name = "Unlabeled Bottle",
                text = {
                    "{C:inactive}No labels?",
                    "{C:inactive}What does it do?",
                },
            },
            j_sgt_little_bill = {
                name = "Little Bill",
                text = {
                    "{C:attention}#1#{} now {C:attention}convert{} all",
                    "scoring cards to {C:attention}2s{} instead",
                },
            },
            j_sgt_huge_dog = {
                name = "Huge Dog",
                text = {
                    "{C:attention}Retrigger{} each played {C:attention}2{} or {C:attention}Ace{}",
                    "{C:attention}#1#{} additional time(s)",
                    "Retrigger {C:attention}#2#{} more time(s) if played hand",
                    "{C:attention}only{} contains {C:attention}2s{} or {C:attention}Aces{}",
                },
            },
            j_sgt_alice = {
                name = "Alice",
                text = {
                    "{C:attention}Multiply{} the value of",
                    "all jokers belonging to {C:dark_edition}Alice in",
                    "{C:dark_edition}the Wonderland{} by {C:attention}X#1#{}",
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
                    "{C:attention}Balancing{}: HuyTheKiller, HuyCorn",
                    " ",
                    "Currently in demo.",
                },
            },
        },
    },
    misc = {
        dictionary = {
            b_join = "JOIN",
            k_in_a_hurry_ex = "In a hurry!",
            k_too_late_ex = "Too late!",
            k_shrunk_ex = "Shrunk!",
            k_enlarged_ex = "Enlarged!",
            k_grin_ex = "Grin!",
            k_gone_ex = "Gone!",
            k_poof_ex = "Poof!",
            k_yeet_ex = "YEET!",
            SGT_disable_other_jokers = "Sagatro Progression",
            SGT_disable_other_jokers_desc = {"Disable all other jokers and enable","linear storyline progression"},
        },
    },
}