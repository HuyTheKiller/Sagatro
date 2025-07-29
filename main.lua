Sagatro = SMODS.current_mod
Sagatro.load_table = {
    jokers = true,
	decks_n_sleeves = true,
	blinds = true,
	streaks = true,
	ultra = true,
	tags = true,
	misc = true,
	wishes = true,
	boosters = true,
	challenges = true,
}

Sagatro.mod_compat = {
	talisman = (SMODS.Mods["Talisman"] or {}).can_load or false,
	ortalab = (SMODS.Mods["ortalab"] or {}).can_load or false,
}

Sagatro.electric_eel_info_queue = {
	"m_steel",
	"m_gold",
	"m_sgt_titanium",
	"m_sgt_platinum",
}

Sagatro.optional_features = {
	retrigger_joker = true,
}

-- Danger zone
Sagatro.debug = false
Sagatro.init_JDdebug = false

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