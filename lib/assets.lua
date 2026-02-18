SMODS.Atlas{
    key = 'balatro',
    path = 'Sagatro.png',
    px = 333,
    py = 216,
    prefix_config = { key = false }
}

SMODS.Atlas{
    key = 'ortalab_alt_logo',
    path = 'Ortagas.png',
    px = 333,
    py = 216,
    prefix_config = { key = false }
}

SMODS.Atlas{
    key = "alice_in_wonderland",
    path = "Alice_in_wonderland2.0.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "alice_in_mirrorworld",
    path = "Alice_in_mirrorworld.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "alice_in_wonderland_ds_lc",
    path = "Alice_in_wonderland_DS_lc.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "alice_in_wonderland_ds_hc",
    path = "Alice_in_wonderland_DS_hc.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "alice",
    path = "Alice2.0.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "ecila",
    path = "Ecila.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "pocket_mirror",
    path = "Pocket_mirror.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "20k_miles_under_the_sea",
    path = "20k_miles_under_the_sea.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "submarine",
    path = "Submarine.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "clam",
    path = "Clam.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "seawater",
    path = "Seawater.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "misc_jokers",
    path = "Misc_jokers.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "nemo",
    path = "Nemo.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "esoteric",
    path = "Esoteric.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "nameless",
    path = "Nameless.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "decks",
    path = "Decks.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "sleeves",
    path = "Sleeves.png",
    px = 73,
    py = 95,
}

SMODS.Atlas{
    key = "colour_streaks",
    path = "Colour_streaks.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "cosmic_streak",
    path = "Cosmic_streak.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "gods_miracle",
    path = "God's_miracle2.0.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "booster",
    path = "Boosters.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "wish",
    path = "Wish.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "supply",
    path = "Supplies.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "misc",
    path = "Misc_atlas.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "current_depth",
    path = "Current_depth.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "ultra",
    path = "Ultra.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "mabel",
    path = "Mabel.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "tags",
    path = "Tags.png",
    px = 34,
    py = 34,
}

SMODS.Atlas{
    key = "blinds",
    path = "Blinds.png",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34,
}

SMODS.Sound{
    key = "run_away",
    path = "run_away.ogg",
}

SMODS.Sound{
    key = "page_flip",
    path = "page_flip.ogg",
}

SMODS.Sound{
    key = "page_scratch",
    path = "page_scratch.ogg",
}

SMODS.Sound{
    key = "painting",
    path = "painting.ogg",
}

SMODS.Sound{
    key = "swallow",
    path = "swallow.ogg",
}

SMODS.Sound{
    key = "narwhal_impale",
    path = "narwhal_impale.ogg",
}

SMODS.Sound{
    key = "resonance",
    path = "bell_resonance.ogg",
}

SMODS.Sound{
    key = "explosion",
    path = "explosion.ogg",
}
--#region Borrowed sfx from Pocket Mirror ~ GoldenerTraum

SMODS.Sound{
    key = "fleta_tantrum",
    path = "VA_Fleta_tantrum_noise_2_RM.ogg",
}

SMODS.Sound{
    key = "harpae_crying",
    path = "VA_Harpae_Cry_3_RM.ogg",
}

SMODS.Sound{
    key = "lisette_laughcrying",
    path = "VA_Lisette_Laughcrying_2_RM.ogg",
}

--#endregion

SMODS.Sound{
    key = "bell_score",
    path = "bell_score.wav",
}

SMODS.Sound{
    key = "emult",
    path = "talisman_emult.wav",
}

SMODS.Sound{
    key = "music_sagatro",
    path = "music_sagatro.ogg",
    select_music_track = function()
		if G.STATE == G.STATES.MENU then
            return 100
        end
        return false
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_boss",
    path = "music_sagatro_story_mode_boss.ogg",
    select_music_track = function()
        return G.GAME.blind and G.GAME.blind.boss and (Sagatro.config.SagatroMusicOption < 3) and 10
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_shop",
    path = "music_sagatro_story_mode_shop.ogg",
    select_music_track = function()
        return G.shop and not G.shop.REMOVED and (Sagatro.config.SagatroMusicOption < 3) and 10
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_meteor",
    path = "music_sagatro_story_mode_meteor.ogg",
    select_music_track = function()
        return G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED and (Sagatro.config.SagatroMusicOption < 3) and 100
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_sparkle",
    path = "music_sagatro_story_mode_sparkle.ogg",
    select_music_track = function()
        return G.booster_pack and not G.booster_pack.REMOVED and (Sagatro.config.SagatroMusicOption < 3) and 100
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode",
    path = "music_sagatro_story_mode.ogg",
    select_music_track = function()
        return G.STATE ~= G.STATES.MENU and (Sagatro.config.SagatroMusicOption < 3)
	end,
}

SMODS.Sound{
    key = "music_aladdin",
    path = "music_aladdin.ogg",
    select_music_track = function()
		return G.STATE and G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.label:find("wish")
	end,
}

-- Spare me from the copyright issue, Pocket Mirror Team
-- Pocket Mirror content in this mod is our show of gratitude towards the original game
SMODS.Sound{
    key = "music_promise",
    path = "music_promise_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return (G.GAME.story_mode and next(SMODS.find_card("j_sgt_goldia", true))) and (Sagatro.config.SagatroMusicOption < 2) and 250
	end,
}

SMODS.Sound{
    key = "music_the_queen_shall_be_saved",
    path = "music_the_queen_shall_be_saved.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return Sagatro.storyline_check("pocket_mirror") and (Sagatro.event_check("pm_mirrorworld") or Sagatro.event_check("conditional_game_over")) and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_kleine_beere",
    path = "music_kleine_beere_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return (Sagatro.event_check("fleta_challenges")) and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_embellishment_the_moon_as_seen_from_vienna",
    path = "music_embellishment_the_moon_as_seen_from_vienna_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return (Sagatro.event_check("harpae_patience")) and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_chimerical_presence",
    path = "music_chimerical_presence_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return (Sagatro.event_check("mirror_maze") or Sagatro.event_check("dull_glass")) and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_evening_stroll",
    path = "music_evening_stroll_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return Sagatro.event_check("lisette_chase") and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_minuten_sekundar",
    path = "music_minuten_sekundar_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return G.GAME.solving_door_puzzle and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}

SMODS.Sound{
    key = "music_platinum",
    path = "music_platinum_loopable.ogg",
    sync = false,
    pitch = 1,
    volume = 0.5,
    select_music_track = function()
		return Sagatro.event_check("platinum_ending") and (Sagatro.config.SagatroMusicOption < 2) and 1000
	end,
}