return {
    descriptions = {
        Back = {
            b_sgt_saga = {
                name = "Saga Deck",
                text = {
                    "{C:attention}+#1#{} Joker slots",
                    "Beat {C:attention}Ante #2#{} to win",
                    "{s:0.8,C:inactive}A true story never ends.",
                    "{s:0.8,C:inactive}Carve your own path beyond.",
                },
            },
        },
        Sleeve = {
            sleeve_sgt_saga = {
                name = "Saga Sleeve",
                text = {
                    "{C:attention}+#1#{} Joker slots",
                    "{C:attention}+#2#{} winning Ante",
                    "{s:0.8,C:inactive}A true story never ends.",
                    "{s:0.8,C:inactive}Carve your own path beyond.",
                },
            },
            sleeve_sgt_saga_alt = {
                name = "Saga Sleeve",
                text = {
                    "{C:attention}+#1#{} shop slots",
                    "{C:attention}+#1#{} booster pack slots",
                    "{s:0.8,C:inactive}For the future you bond.",
                    "{s:0.8,C:inactive}Never forget who you are.",
                },
            },
        },
        Blind = {
            bl_sgt_red_queen = {
                name = "Red Queen",
                text = {
                    "All cards debuff until Eat Me!",
                    "used; Very large blind",
                },
            },
        },
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
					"{C:inactive,s:0.9}(Copying {C:attention,s:0.9}#1#"..(Sagatro.debug and "{C:inactive,s:0.9} with value ID {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
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
                name = "Huge Puppy",
                text = {
                    "{C:attention}Retrigger{} each played {C:attention}2{} or {C:attention}Ace{}",
                    "{C:attention}#1#{} additional time(s)",
                    "Retrigger {C:attention}#2#{} more time(s) if scoring hand",
                    "{C:attention}only{} contains {C:attention}2s{} or {C:attention}Aces{}",
                },
            },
            j_sgt_caterpillar = {
                name = "Caterpillar",
                text = {
                    "{C:attention}Randomize{} the {C:attention}rank{} and {C:attention}suit{}",
                    "of the next {C:attention}#1#{} scoring cards",
                    "{C:red}Self-destructs{} and create",
                    "{C:attention}#2#{} on expiry",
                },
            },
            j_sgt_mushroom = {
                name = "Mushroom",
                text = {
                    "If this is the {C:attention}leftmost/rightmost{} joker,",
                    "All scoring cards {C:attention}lose/gain{} #2# rank(s)",
                    "for the next {C:attention}#1#{} hand(s)",
                },
            },
            j_sgt_pigeon = {
                name = "Pigeon",
                text = {
                    "Buy this card to create #2# {C:attention}#1#s{}",
                    "Add {C:money}$#3#{} of {C:attention}sell value{} to",
                    "all {C:attention}#1#s{} at end of round",
                    "{C:attention}Debuffed{} if any {C:attention}#1#{} is sold",
                },
            },
            j_sgt_frog_footman = {
                name = "Frog-Footman",
                text = {
                    "{C:attention}+#1#{} consumable slot(s)",
                    "Opening the next #2# {C:attention}Booster Pack(s){}",
                    "{C:attention}fill up{} consumable slots",
                    "with {C:attention}random{} consumables",
                    "{C:red,s:0.8}Self-destructs{s:0.8} on expiry",
                },
            },
            j_sgt_the_cook = {
                name = "The Cook",
                text = {
                    "{C:green}#1# in #2#{} chance for",
                    "cards to be {C:attention}drawn{} face down",
                    "{C:attention}Face down{} cards give",
                    "{X:mult,C:white}X#3#{} Mult when scored",
                    "{s:0.8}Switch to a different",
                    "{s:0.8}pair at end of round",
                },
            },
            j_sgt_duchess = {
                name = "Duchess",
                text = {
                    "{C:green}#1# in #2#{} chance to destroy",
                    "each scoring {C:attention}face{} card",
                    "{X:dark_edition,C:white}^#3#{} Mult if any {C:attention}face{} card",
                    "is destroyed this way",
                },
            },
            j_sgt_the_baby = {
                name = "The Baby",
                text = {
                    "{C:attention}Retrigger{} all played cards",
                    "{C:attention}#1#{} additional time(s) on",
                    "{C:attention}final hand{} of round",
                    "{C:red}Self-destructs{} if {C:attention}#2#{}",
                    "is not around",
                },
            },
            j_sgt_pepper_caster = {
                name = "Pepper-caster",
                text = {
                    "{C:attention}Retrigger{} all jokers",
                    "{C:attention}#1#{} additional time(s)",
                    "{C:red,s:0.8}Self-destructs{s:0.8} after {C:attention,s:0.8}#2#{s:0.8} round(s)",
                },
            },
            j_sgt_mad_hatter = {
                name = "Mad Hatter",
                text = {
                    "Disable {C:attention}Up the Ante{}",
                    "Fill up the shop with",
                    "{C:sgt_trivial}Trivial{} jokers",
                },
            },
            j_sgt_tea = {
                name = "Tea",
                text = {
                    "{C:chips}+#1#{} Chips for",
                    "the next {C:attention}#2#{} hand(s)",
                },
            },
            j_sgt_bread = {
                name = "Bread",
                text = {
                    "{C:chips}+#1#{} Chips for",
                    "the next {C:attention}#2#{} hand(s)",
                },
            },
            j_sgt_butter = {
                name = "Butter",
                text = {
                    "{C:mult}+#1#{} Mult for",
                    "the next {C:attention}#2#{} hand(s)",
                },
            },
            j_sgt_march_hare = {
                name = "March Hare",
                text = {
                    "This joker gains {C:mult}+#2#{} Mult",
                    "if hand is played {C:attention}without{}",
                    "any discards used this round",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                },
            },
            j_sgt_dormouse = {
                name = "Dormouse",
                text = {
                    "{C:green}#1# in #2#{} chance",
                    "for {C:mult}+#3#{} Mult",
                },
            },
            j_sgt_red_queen = {
                name = "Red Queen",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "destroy each scoring card",
                    "All played cards give",
                    "{X:dark_edition,C:white}^#3#{} Mult when scored",
                },
            },
            j_sgt_king = {
                name = "The King",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Reduce {C:attention}#2#'s{}",
                    "chance by {C:attention}#3#{} times",
                },
            },
            j_sgt_flamingo = {
                name = "The Flamingo",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "Reduce {C:attention}#2#'s{}",
                    "chance by {C:attention}#3#{} times",
                },
            },
            j_sgt_gryphon = {
                name = "Gryphon",
                text = {
                    "Each {C:attention}Queen{}",
                    "held in hand",
                    "gives {X:dark_edition,C:white}^#1#{} Mult",
                },
            },
            j_sgt_mock_turtle = {
                name = "Mock Turtle",
                text = {
                    "{C:green}#1# in #2#{} chance for {X:dark_edition,C:white}^#3#{} Mult",
                    "{C:green}#1# in #4#{} chance to {C:red}self-destructs{}",
                    "after every hand played, reduce by {C:attention}1{}",
                    "every {X:dark_edition,C:white}^Mult{} trigger",
                },
            },
            j_sgt_alice = {
                name = "Alice",
                text = {
                    "{C:attention}Multiply{} the value of",
                    "all jokers belonging to {C:dark_edition}Alice",
                    "{C:dark_edition}in the Wonderland{} by {C:attention}X#1#{}",
                },
            },
            j_sgt_shepherd_boy = {
                name = "Sheperd Boy",
                text = {
                    "This joker gains {C:mult}+#2#{} Mult",
                    "every hand played",
                    "{C:green}#3# in #4#{} chance to destroy",
                    "a random joker and {C:attention}reset{} mult",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
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
        labels = {
            k_sgt_trivial = "Trivial",
            k_sgt_obscure = "Obscure",
            k_sgt_esoteric = "Esoteric",
        },
        dictionary = {
            k_sgt_trivial = "Trivial",
            k_sgt_obscure = "Obscure",
            k_sgt_esoteric = "Esoteric",
            b_join = "JOIN",
            k_in_a_hurry_ex = "In a hurry!",
            k_too_late_ex = "Too late!",
            k_shrunk_ex = "Shrunk!",
            k_enlarged_ex = "Enlarged!",
            k_grin_ex = "Grin!",
            k_gone_ex = "Gone!",
            k_poof_ex = "Poof!",
            k_yeet_ex = "YEET!",
            k_ouch_ex = "Ouch!",
            k_goodbye_ex = "Goodbye!",
            k_go_off_ex = "Leaved!",
            k_overflow_ex = "Overflow!",
            k_die_ex = "Die!",
            k_stirred_ex = "Stirred!",
            k_shared_ex = "Shared!",
            k_avoided_ex = "Avoided!",
            k_enraged_ex = "Enraged!",
            k_guilty_ex = "Guilty!",
            k_to = "to",
            k_self_destruct = "self-destruct",
            k_self_destruct_ex = "Self-destruct!",
            k_amused_ex = "Amused!",
            k_wolf_ex = "Wolf!",
            ph_per_face_down = " per face-down",
            ph_story_ended = "STORY ENDED!",
            SGT_disable_other_jokers = "Story Mode",
            SGT_disable_other_jokers_desc = {"Disable all other jokers and enable","linear storyline progression (Requires run restart)"},
        },
    },
}