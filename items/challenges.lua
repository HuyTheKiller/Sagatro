local gambling_hansel = {
    key = "gambling_hansel",
    rules = {
        custom = {
            { id = "sgt_disable_sagatro_items" },
        },
        modifiers = {},
    },
    jokers = {
		{ id = "j_sgt_hansels_cheat_dice", eternal = true },
	},
    deck = {
		type = "Challenge Deck",
        cards = {
			{ s = "D", r = "2", e = "m_glass" },
			{ s = "D", r = "3", e = "m_lucky" },
			{ s = "D", r = "4", e = "m_glass" },
			{ s = "D", r = "5", e = "m_lucky" },
			{ s = "D", r = "6", e = "m_glass" },
			{ s = "D", r = "7", e = "m_lucky" },
			{ s = "D", r = "8", e = "m_glass" },
			{ s = "D", r = "9", e = "m_lucky" },
			{ s = "D", r = "T", e = "m_glass" },
			{ s = "D", r = "J", e = "m_lucky" },
			{ s = "D", r = "Q", e = "m_glass" },
			{ s = "D", r = "K", e = "m_lucky" },
			{ s = "D", r = "A", e = "m_glass" },
			{ s = "C", r = "2", e = "m_lucky" },
			{ s = "C", r = "3", e = "m_glass" },
			{ s = "C", r = "4", e = "m_lucky" },
			{ s = "C", r = "5", e = "m_glass" },
			{ s = "C", r = "6", e = "m_lucky" },
			{ s = "C", r = "7", e = "m_glass" },
			{ s = "C", r = "8", e = "m_lucky" },
			{ s = "C", r = "9", e = "m_glass" },
			{ s = "C", r = "T", e = "m_lucky" },
			{ s = "C", r = "J", e = "m_glass" },
			{ s = "C", r = "Q", e = "m_lucky" },
			{ s = "C", r = "K", e = "m_glass" },
			{ s = "C", r = "A", e = "m_lucky" },
			{ s = "H", r = "2", e = "m_glass" },
			{ s = "H", r = "3", e = "m_lucky" },
			{ s = "H", r = "4", e = "m_glass" },
			{ s = "H", r = "5", e = "m_lucky" },
			{ s = "H", r = "6", e = "m_glass" },
			{ s = "H", r = "7", e = "m_lucky" },
			{ s = "H", r = "8", e = "m_glass" },
			{ s = "H", r = "9", e = "m_lucky" },
			{ s = "H", r = "T", e = "m_glass" },
			{ s = "H", r = "J", e = "m_lucky" },
			{ s = "H", r = "Q", e = "m_glass" },
			{ s = "H", r = "K", e = "m_lucky" },
			{ s = "H", r = "A", e = "m_glass" },
			{ s = "S", r = "2", e = "m_lucky" },
			{ s = "S", r = "3", e = "m_glass" },
			{ s = "S", r = "4", e = "m_lucky" },
			{ s = "S", r = "5", e = "m_glass" },
			{ s = "S", r = "6", e = "m_lucky" },
			{ s = "S", r = "7", e = "m_glass" },
			{ s = "S", r = "8", e = "m_lucky" },
			{ s = "S", r = "9", e = "m_glass" },
			{ s = "S", r = "T", e = "m_lucky" },
			{ s = "S", r = "J", e = "m_glass" },
			{ s = "S", r = "Q", e = "m_lucky" },
			{ s = "S", r = "K", e = "m_glass" },
			{ s = "S", r = "A", e = "m_lucky" },
		},
	},
    restrictions = {
		banned_cards = {
            { id = 'c_empress' },
            { id = 'c_heirophant' },
            { id = 'c_chariot' },
            { id = 'c_devil' },
            { id = 'c_tower' },
            { id = 'c_lovers' },
            { id = 'c_incantation' },
            { id = 'c_grim' },
            { id = 'c_familiar' },
            { id = 'p_standard_normal_1',
                ids = {
                    'p_standard_normal_1',
                    'p_standard_normal_2',
                    'p_standard_normal_3',
                    'p_standard_normal_4',
                    'p_standard_jumbo_1',
                    'p_standard_jumbo_2',
                    'p_standard_mega_1',
                    'p_standard_mega_2',
                }
            },
            { id = 'j_marble' },
            { id = 'j_vampire' },
            { id = 'j_midas_mask' },
            { id = 'j_certificate' },
            { id = "j_oops" },
            { id = 'v_magic_trick' },
            { id = 'v_illusion' },
		},
        banned_tags = {
            { id = 'tag_standard' },
        },
		banned_other = {},
	},
    button_colour = G.C.SGT_SAGADITION,
}

local ragnarok = {
	key = "ragnarok",
    rules = {
        custom = {
            { id = "sgt_disable_sagatro_items" },
            { id = "sgt_no_tags" },
            { id = "sgt_ragnarok_challenge_text" },
            -- { id = "sgt_demo_challenge_text1" },
            -- { id = "sgt_demo_challenge_text2" },
            -- { id = "sgt_demo_challenge_text3" },
            -- { id = "sgt_demo_challenge_text4" },
            -- { id = "sgt_demo_challenge_text5" },
        },
        modifiers = {
			{ id = "joker_slots", value = 0 },
		},
    },
    jokers = {
		{ id = "j_sgt_ragnarok", eternal = true },
	},
	restrictions = {
		banned_cards = {
			{ id = 'c_ectoplasm' },
			{ id = 'v_antimatter' },
		},
        banned_tags = {},
		banned_other = {
			{ id = 'bl_final_heart', type = 'blind' },
			{ id = 'bl_final_leaf', type = 'blind' },
		},
	},
	button_colour = G.C.SGT_SAGADITION,
}

local inversion = {
	key = "inversion",
    rules = {
        custom = {
            { id = "sgt_inversion_text1" },
            { id = "sgt_inversion_text2" },
            { id = "sgt_inversion_text3" },
            { id = "sgt_inversion_text4" },
            { id = "sgt_inversion_text5" },
        },
    },
	button_colour = G.C.SGT_SAGADITION,
}

local challenge_table = {
    gambling_hansel,
	ragnarok,
	inversion,
}

for _, v in ipairs(challenge_table) do
    SMODS.Challenge(v)
end