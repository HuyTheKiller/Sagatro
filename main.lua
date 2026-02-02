Sagatro = SMODS.current_mod
Sagatro.load_table = {
    jokers = true,
	decks_n_sleeves = true,
	blinds = true,
	streaks = true,
	ultra = true,
	quips = true,
	tags = true,
	misc = true,
	wishes = true,
	boosters = true,
	deckskin = true,
	challenges = true,
	achievements = true,
}

Sagatro.secondary_colour = darken(Sagatro.badge_colour, 0.4)

Sagatro.mod_compat = {
	talisman = next(SMODS.find_mod("Talisman")) or false,
}

Sagatro.electric_eel_info_queue = {
	"m_steel",
	"m_gold",
	"m_sgt_titanium",
	"m_sgt_platinum",
}

Sagatro.necronomicon = {
	rarity_weight = {Common = 0, Uncommon = 3, Rare = 10, sgt_obscure = 25},
	rarity_order = {"sgt_obscure", "Rare", "Uncommon", "Common"},
	enhancement_weight = {
		m_bonus = 1, m_mult = 1, m_wild = 1, m_glass = 1, m_steel = 1, m_stone = 1, m_gold = 1, m_lucky = 1,
		m_sgt_favor = 2, m_sgt_exponent = 2, m_sgt_strange = 2, m_sgt_nyx_glass = 2, m_sgt_titanium = 2,
		m_sgt_abyss_stone = 2, m_sgt_platinum = 2, m_sgt_ancient_lucky = 2, m_sgt_omniscient = 5
	},
	edition_weight = {e_foil = 2, e_holo = 3, e_polychrome = 5, e_negative = 10, generic = 4},
	seal_weight = {generic = 3},
}

Sagatro.mad_hatter_whitelist = {
	"legendary",
	"cry_exotic",
	"entr_entropic",
}

Sagatro.optional_features = {
	retrigger_joker = true,
}

Sagatro.temp_areas = {}

Sagatro.regalia_list = {
	"j_sgt_pocket_mirror",
	"j_sgt_knife_fork",
	"j_sgt_rose_bell",
	"j_sgt_moon_hairbrush",
	"j_sgt_snow_scissors",
	"j_sgt_angel_scythe",
}

Sagatro.save_slots = 20
Sagatro.save_name_list = {}
Sagatro.save_name = "storymodesave"
if Sagatro.mod_compat.talisman then
	Sagatro.save_name = Sagatro.save_name.."_talisman"
end

-- Danger zone
Sagatro.debug = false
Sagatro.init_JDdebug = false
Sagatro.debug_info = {}

-- Load library files
local mod_path = "" .. Sagatro.path
local files = NFS.getDirectoryItems(mod_path .. "lib")
for _, file in ipairs(files) do
	sendInfoMessage("Loading library file " .. file, "Sagatro")
	SMODS.load_file("lib/" .. file)()
end

-- Load items if enabled
for k, v in pairs(Sagatro.load_table) do
    if v then
		sendInfoMessage("Loading " .. k .. ".lua", "Sagatro")
		SMODS.load_file('items/'..k..'.lua')()
	end
end

SMODS.Atlas{
	key = "modicon",
	path = "icon.png",
	px = 34,
	py = 34
}

Sagatro.description_loc_vars = function()
	return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end

Sagatro.ui_config = {
    colour = Sagatro.badge_colour,
    outline_colour = Sagatro.secondary_colour,
    tab_button_colour = Sagatro.secondary_colour,
    back_colour = Sagatro.secondary_colour,
}