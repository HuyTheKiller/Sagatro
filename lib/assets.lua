SMODS.Atlas{
    key = 'balatro',
    path = 'Sagatro.png',
    px = 333,
    py = 216,
    prefix_config = { key = false }
}

SMODS.Atlas{
    key = "alice_in_wonderland",
    path = "Alice_in_wonderland.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "alice",
    path = "Alice.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "the_boy_who_cried_wolf",
    path = "The_boy_who_cried_wolf.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "puss_in_boots",
    path = "Puss_in_boots.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "aladdin_and_the_magic_lamp",
    path = "Aladdin_and_the_magic_lamp.png",
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
    key = "gambling_hansel",
    path = "Gambling_hansel.png",
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
    path = "God's_miracle.png",
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
    key = "misc",
    path = "Misc_atlas.png",
    px = 71,
    py = 95,
}

SMODS.Atlas{
    key = "red_queen",
    path = "Red_queen.png",
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
        return G.GAME.blind and G.GAME.blind.boss and (G.GAME.story_mode or Sagatro.config.SagatroMusic) and 10
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_shop",
    path = "music_sagatro_story_mode_shop.ogg",
    select_music_track = function()
        return G.shop and not G.shop.REMOVED and (G.GAME.story_mode or Sagatro.config.SagatroMusic) and 10
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_meteor",
    path = "music_sagatro_story_mode_meteor.ogg",
    select_music_track = function()
        return G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED and (G.GAME.story_mode or Sagatro.config.SagatroMusic) and 100
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode_sparkle",
    path = "music_sagatro_story_mode_sparkle.ogg",
    select_music_track = function()
        return G.booster_pack and not G.booster_pack.REMOVED and (G.GAME.story_mode or Sagatro.config.SagatroMusic) and 100
	end,
}

SMODS.Sound{
    key = "music_sagatro_story_mode",
    path = "music_sagatro_story_mode.ogg",
    select_music_track = function()
        return G.STATE ~= G.STATES.MENU and (G.GAME.story_mode or Sagatro.config.SagatroMusic)
	end,
}

SMODS.Sound{
    key = "music_aladdin",
    path = "music_aladdin.ogg",
    select_music_track = function()
		return G.STATE and G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.label:find("wish")
	end,
}