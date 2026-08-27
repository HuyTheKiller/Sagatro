Sagatro.Storyline{
    key = "saga_default",
    atlas = "storylines",
    pos = { x = 0, y = 0 },
    starting_jokers = {},
    joker_list = {
        -- This is supposed to be a different storyline hosting jokers not in any main storylines,
        -- but it's omiited from the pool so I'm combining it into saga_default instead
        "j_sgt_shepherd_boy" , "j_sgt_puss_in_boots"   , "j_sgt_iron_john"    , "j_sgt_hansels_cheat_dice", "j_sgt_skoll_n_hati",
        "j_sgt_three_winters", "j_sgt_adam"            , "j_sgt_saint_germain", "j_sgt_necronomicon"      , "j_sgt_frog_prince" ,
        "j_sgt_little_prince", "j_sgt_pumpkin_carriage", "j_sgt_abducted_cow" , "j_sgt_flying_house"      , "j_sgt_aladdin"     ,

        "j_sgt_magic_lamp", "j_sgt_lamp_genie", "j_sgt_ragnarok"  , "j_sgt_yggdrasil", "j_sgt_thor"    ,
        "j_sgt_odin"      , "j_sgt_hermod"    , "j_sgt_three_body", "j_sgt_shub"     , "j_sgt_azathoth",
        "j_sgt_darkness"  , "j_sgt_nameless"  , "j_sgt_mabel"     ,
    },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if card.area and card.area.config.collection then
            ret.key = self.key.."_collection"
        elseif not Sagatro.config.DisableOtherJokers then
            ret.main_end = {}
            localize{type = "other", key = "sgt_story_mode_off", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

Sagatro.Storyline{
    key = "alice_in_wonderland",
    atlas = "storylines",
    pos = { x = 1, y = 0 },
    starting_jokers = { "j_sgt_white_rabbit" },
    joker_list = {
        "j_sgt_white_rabbit", "j_sgt_drink_me"        , "j_sgt_eat_me"      , "j_sgt_mouse"   , "j_sgt_kid_gloves_and_fan",
        "j_sgt_dodo_bird"   , "j_sgt_unlabeled_bottle", "j_sgt_little_bill" , "j_sgt_huge_dog", "j_sgt_caterpillar"       ,
        "j_sgt_mushroom"    , "j_sgt_pigeon"          , "j_sgt_frog_footman", "j_sgt_the_cook", "j_sgt_pepper_caster"     ,

        "j_sgt_cheshire_cat", "j_sgt_duchess" , "j_sgt_the_baby"  , "j_sgt_mad_hatter" , "j_sgt_tea"      ,
        "j_sgt_bread"       , "j_sgt_butter"  , "j_sgt_march_hare", "j_sgt_dormouse"   , "j_sgt_red_queen",
        "j_sgt_king"        , "j_sgt_flamingo", "j_sgt_gryphon"   , "j_sgt_mock_turtle", "j_sgt_alice"    ,
    },
    check_for_unlock = function(self, args)
        if args.type == "win_story_mode" and args.storylines[1] == "alice_in_wonderland" then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if card.area and card.area.config.collection then
            ret.key = self.key.."_collection"
        elseif not Sagatro.config.DisableOtherJokers then
            ret.main_end = {}
            localize{type = "other", key = "sgt_story_mode_off", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

Sagatro.Storyline{
    key = "20k_miles_under_the_sea",
    atlas = "storylines",
    pos = { x = 2, y = 0 },
    starting_jokers = { "j_sgt_lincoln_ship" },
    joker_list = {
        "j_sgt_lincoln_ship", "j_sgt_sub_engineer", "j_sgt_school"         , "j_sgt_coral_kingdom", "j_sgt_ugly_blobfish"  ,
        "j_sgt_turtle_egg"  , "j_sgt_baby_turtle" , "j_sgt_submarine"      , "j_sgt_seawater"     , "j_sgt_clownfish"      ,
        "j_sgt_blue_tang"   , "j_sgt_pufferfish"  , "j_sgt_white_jellyfish", "j_sgt_red_jellyfish", "j_sgt_queen_jellyfish",

        "j_sgt_mandarin_fish", "j_sgt_prawn"       , "j_sgt_starfish"  , "j_sgt_hermit_crab", "j_sgt_seahorse",
        "j_sgt_john_dory"    , "j_sgt_stonefish"   , "j_sgt_barracuda" , "j_sgt_mahimahi"   , "j_sgt_octopus" ,
        "j_sgt_squid"        , "j_sgt_green_turtle", "j_sgt_sea_urchin", "j_sgt_lobster"    , "j_sgt_penguin" ,

        "j_sgt_dolphin"  , "j_sgt_sunfish"          , "j_sgt_moonfish", "j_sgt_swordfish"   , "j_sgt_ray"      ,
        "j_sgt_orca"     , "j_sgt_shark"            , "j_sgt_seal"    , "j_sgt_narwhal"     , "j_sgt_sea_angel",
        "j_sgt_king_crab", "j_sgt_coelacanthiformes", "j_sgt_nautilus", "j_sgt_lantern_fish", "j_sgt_stomiidae",

        "j_sgt_electric_eel" , "j_sgt_big_red_jelly", "j_sgt_goblin_shark"   , "j_sgt_colossal_squid", "j_sgt_sperm_whale",
        "j_sgt_chimaera"     , "j_sgt_dumbo_octopus", "j_sgt_atolla_wyvillei", "j_sgt_comb_jellyfish", "j_sgt_blobfish"   ,
        "j_sgt_faceless_cusk", "j_sgt_brittle_star" , "j_sgt_fangtooth"      , "j_sgt_grenadier"     , "j_sgt_nemo"       ,
    },
    check_for_unlock = function(self, args)
        if args.type == "win_story_mode" and args.storylines[1] == "20k_miles_under_the_sea" then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if card.area and card.area.config.collection then
            ret.key = self.key.."_collection"
        elseif not Sagatro.config.DisableOtherJokers then
            ret.main_end = {}
            localize{type = "other", key = "sgt_story_mode_off", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

Sagatro.Storyline{
    key = "alice_in_mirrorworld",
    atlas = "storylines",
    pos = { x = 3, y = 0 },
    starting_jokers = { "j_sgt_white_rabbit", "j_sgt_mirror" },
    joker_list = {
        "j_sgt_mirror"     , "j_sgt_white_pawn", "j_sgt_white_rook"  , "j_sgt_white_knight"  , "j_sgt_white_bishop",
        "j_sgt_white_queen", "j_sgt_white_king", "j_sgt_live_flowers", "j_sgt_ticket_checker", "j_sgt_man_in_white",
        "j_sgt_goat"       , "j_sgt_beetle"    , "j_sgt_tweedledum"  , "j_sgt_tweedledee"    , "j_sgt_sheep"       ,

        "j_sgt_rocking_horse_fly", "j_sgt_bread_and_butter_fly", "j_sgt_snap_dragon_fly", "j_sgt_humpty_dumpty", "j_sgt_seal_and_carpenter",
        "j_sgt_lion"             , "j_sgt_unicorn"             , "j_sgt_dinah"          , "j_sgt_jabberwock"   , "j_sgt_bandersnatch"      ,
        "j_sgt_jubjub_bird"      , "j_sgt_vorpal_sword"        , "j_sgt_true_red_queen" , "j_sgt_red_king"     , "j_sgt_ecila"             ,
    },
    check_for_unlock = function(self, args)
        if args.type == "win_story_mode" and args.storylines[2] == "alice_in_mirrorworld" then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        local ret = {}
        if card.area and card.area.config.collection then
            ret.key = self.key.."_collection"
        elseif not Sagatro.config.DisableOtherJokers then
            ret.main_end = {}
            localize{type = "other", key = "sgt_story_mode_off", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}

Sagatro.Storyline{
    key = "pocket_mirror",
    atlas = "storylines",
    pos = { x = 4, y = 0 },
    starting_jokers = { "j_sgt_goldia" },
    joker_list = {
        "j_sgt_goldia"       , "j_sgt_fleta"     , "j_sgt_harpae"        , "j_sgt_lisette"      , "j_sgt_enjel"       ,
        "j_sgt_pocket_mirror", "j_sgt_rose_bell" , "j_sgt_moon_hairbrush", "j_sgt_snow_scissors", "j_sgt_angel_scythe",
        "j_sgt_egliette"     , "j_sgt_knife_fork", "j_sgt_rusty_scissors", "j_sgt_platinum"     , "j_sgt_ozzy"        ,
    },
    check_for_unlock = function(self, args)
        if args.type == "win_story_mode" and args.storylines[1] == "pocket_mirror" then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = "sgt_play_pocket_mirror"}
        local ret = {}
        if card.area and card.area.config.collection then
            ret.key = self.key.."_collection"
        elseif not Sagatro.config.DisableOtherJokers then
            ret.main_end = {}
            localize{type = "other", key = "sgt_story_mode_off", nodes = ret.main_end, vars = {}}
            ret.main_end = ret.main_end[1]
        end
        return ret
    end,
}