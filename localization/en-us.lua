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
                name = "SauKhongHu",
                text = {
                    "{C:attention}Randomize{} the {C:attention}rank{} and {C:attention}suit{}",
                    "of the next {C:attention}#1#{} scoring cards",
                    "{C:red,E:2}self destructs{} and create",
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
                    "{C:red,s:0.8,E:2}self destructs{s:0.8} on expiry",
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
                    "{C:red,E:2}self destructs{} if {C:attention}#2#{}",
                    "is not around",
                },
            },
            j_sgt_pepper_caster = {
                name = "Pepper-caster",
                text = {
                    "{C:attention}Retrigger{} all jokers",
                    "{C:attention}#1#{} additional time(s)",
                    "{C:red,s:0.8,E:2}self destructs{s:0.8} after {C:attention,s:0.8}#2#{s:0.8} round(s)",
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
                    "{C:green}#1# in #4#{} chance to {C:red,E:2}self destruct{}",
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
                name = "Shepherd Boy",
                text = {
                    "This joker gains {C:mult}+#2#{} Mult",
                    "every hand played",
                    "{C:green}#3# in #4#{} chance to destroy",
                    "a random joker and {C:attention}reset{} mult",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                },
            },
        },
        ["Saga Tooltip"] = {
            fusion_hint = {
                text = {
                    "This card has fusion mechanic.",
                    "Find the other half and save enough",
                    "money to fuse them together.",
                },
            },
            white_rabbit = {
                text = {
                    "{s:0.8}Chasing the white rabbit in a hurry,",
                    "{s:0.8}jumping into the seemingly endless",
                    "{s:0.8}rabbit hole. Ahead is a dead-end with",
                    "{s:0.8}a locked door, and the {s:0.8,C:sgt_sagadition}key{s:0.8} is on the",
                    "{s:0.8}table, but it's too high to reach.",
                },
            },
            kid_gloves_and_fan = {
                text = {
                    "{s:0.8}It's really hot here, I've been waving the fan",
                    "{s:0.8}for a while, and I just put on those tiny gloves.",
                    "{s:0.8}The tears from earlier turned into a flood, and",
                    "{s:0.8}I got swept away. I need {s:0.8,C:sgt_sagadition}someone{s:0.8} to help me.",
                },
            },
            dodo_bird = {
                text = {
                    "{s:0.8}Those creatures are ridiculous. Oh, is that the",
                    "{s:0.8}White Rabbit? It seems like he's mistaking me for",
                    "{s:0.8}Mary Ann, his servant, and he's ordering me to",
                    "{s:0.8}go home and fetch the gloves and fan he dropped",
                    "{s:0.8}earlier. I guess we need to go to his {s:0.8,C:sgt_sagadition}\"House\"{s:0.8}.",
                },
            },
            unlabeled_bottle = {
                text = {
                    "{s:0.8}In this world, drinking something makes you shrink, and eating",
                    "{s:0.8}something makes you grow. If {s:0.8,C:sgt_sagadition}drinking this water{s:0.8} makes me bigger,",
                    "{s:0.8}then eating something should make me smaller. I need to shrink",
                    "{s:0.8}quickly because it's really uncomfortable. It seems like",
                    "{s:0.8}the White Rabbit is calling someone to pull me outside.",
                },
            },
            little_bill = {
                text = {
                    "{s:0.8}It hurts so much, it seems like the lizard was",
                    "{s:0.8}going to bury me with stones, but when the stones",
                    "{s:0.8}fell onto the floor, they turned into {s:0.8,C:sgt_sagadition}cakes{s:0.8}.",
                },
            },
            huge_dog = {
                text = {
                    "{s:0.8}Wow, a giant puppy! Oh no, actually it's because I'm only about",
                    "{s:0.8}3 inches tall. It seemed happy to see me, so I decided to steer",
                    "{s:0.8}clear before something happens. Until the puppy's figure {s:0.8,C:sgt_sagadition}\"FADED\"{s:0.8},",
                    "{s:0.8}it seemed like someone was humming right in front of me.",
                },
            },
            caterpillar = {
                text = {
                    "{s:0.8}\"W-who... are you?\" It was rude for asking without introducing",
                    "{s:0.8}himself first. Although I felt guilty for mentioning that I'm only",
                    "{s:0.8}3 inches tall in front of him, he called me over to say something.",
                    "{s:0.8}Well, I'll just listen to him to the {s:0.8,C:sgt_sagadition}END{s:0.8}.",
                },
            },
            mushroom = {
                text = {
                    "{s:0.8}This thing is really useful, I should probably save it",
                    "{s:0.8}for later. AAAH, I {s:0.8,C:sgt_sagadition}bit off{s:0.8} too big a piece, now my head is",
                    "{s:0.8}as long as a snake's. Wait, there's something on my head.",
                },
            },
            frog_footman = {
                text = {
                    "{s:0.8}\"The way all the creatures argue, it's enough to drive one",
                    "{s:0.8}crazy!\" I said angrily, but inside the {s:0.8,C:sgt_sagadition}house{s:0.8} seemed to be noisy",
                    "{s:0.8}and chaotic, and he seemed unwilling to enter because of that.",
                    "{s:0.8}Welp, I could just ignore him and enter it myself.",
                },
            },
            cheshire_cat = {
                text = {
                    "{s:0.8}\"We're all mad here. I'm mad. You're mad.\"",
                    "{s:0.8}I'm not mad, but stop that {s:0.8,C:sgt_sagadition}disappearing{s:0.8} and",
                    "{s:0.8}reappearing act, it's making my head spin.",
                },
            },
            mad_hatter = {
                text = {
                    "{s:0.8}A banquet table is long enough for just {s:0.8,C:sgt_sagadition}three{s:0.8} people to sit in one corner",
                    "{s:0.8}and still claim that there's no space. Also, the way they talk is really",
                    "{s:0.8}annoying; I need to avoid this place. In front is a long hall with a door",
                    "{s:0.8}about one foot high. I nibble on a bit of {s:0.8,C:sgt_sagadition}Mushroom{s:0.8} still kept in my pocket.",
                    "{s:0.8}I follow the path behind the door...",
                },
            },
            red_queen = {
                text = {
                    "{s:0.8}\"Off with his head!\" - A tyrant queen, it seems that if I don't behave and obey,",
                    "{s:0.8}I'll lose my head. She plays croquet with a {s:0.8,C:sgt_sagadition}Flamingo{s:0.8} instead of using a mallet,",
                    "{s:0.8}but they seem to cooperate to make her happy. {s:0.8,C:sgt_sagadition}The King{s:0.8} is always by her side,",
                    "{s:0.8}flattering her and soothing her anger, preventing her absurd death order. Right now,",
                    "{s:0.8}it seems I've done something wrong that upset her, but what if I join her in the game",
                    "{s:0.8}and have the king intervene on my behalf? Hey! {s:0.8,C:sgt_sagadition}Cheshire Cat{s:0.8}, stop bothering her!!",
                },
            },
            gryphon = {
                text = {
                    "{s:0.8}\"That tyrant queen is just deluding herself, she can't really kill anyone.",
                    "{s:0.8}She must have granted you amnesty and wants you to meet me to hear the song",
                    "{s:0.8}of the {s:0.8,C:sgt_sagadition}Mock Turtle{s:0.8} Soup. Get on my back and I'll take you to him.\"",
                    "{s:0.8}That's what the lion-headed bird said to me.",
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
                    "{C:attention}Art{}: HuyCorn, Amy, TNhie",
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
            saga_tooltip = "Hint to progress",
            saga_fusion_tooltip = "Joker fusion",
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
            k_self_destruct = "self destructs",
            k_self_destruct_ex = "Self destructs!",
            k_amused_ex = "Amused!",
            k_wolf_ex = "Wolf!",
            k_amnestied_ex = "Amnestied!",
            ph_per_face_down = " per face-down",
            ph_trial_begins = "Trial Begins!",
            ph_story_ended = "STORY ENDED!",
            SGT_disable_other_jokers = "Story Mode",
            SGT_disable_other_jokers_desc = {"Disable all other jokers and enable","linear storyline progression (Requires run restart)"},
        },
    },
}