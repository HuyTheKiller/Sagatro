Sagatro = SMODS.current_mod
Sagatro.load_table = {
    alice_in_wonderland = true,
}

-- Danger zone
Sagatro.debug = false

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

-- SMODS.Atlas{
-- 	key = "modicon",
-- 	path = "icon.png",
-- 	px = 32,
-- 	py = 32
-- }

Sagatro.description_loc_vars = function()
	return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end