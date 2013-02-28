local E, L, V, P, G, _ = unpack(ElvUI);
local AI = E:GetModule('AddonInstaller')

local ace3   = true               -- whether or not this database is a Ace3 profile
local name   = 'xCT+'             -- the name of the addon
local dbname = 'xCTSavedDB'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["blizzardFCT"] = {
				["font"] = "KGSmallTownSouthernGirl",
			},
			["spells"] = {
				["mergeCriticalsByThemselves"] = true,
				["mergeDontMergeCriticals"] = false,
			},
			["frames"] = {
				["general"] = {
					["showBuffs"] = false,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 510,
					["font"] = "KGSmallTownSouthernGirl",
					["enabledFrame"] = false,
					["Height"] = 127,
				},
				["power"] = {
					["enabledFrame"] = false,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 255,
					["font"] = "KGSmallTownSouthernGirl",
				},
				["healing"] = {
					["enabledFrame"] = false,
					["Width"] = 382,
					["Y"] = 89,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 143,
					["fontOutline"] = "2OUTLINE",
					["X"] = -319,
				},
				["outgoing"] = {
					["fontSize"] = 17,
					["fontOutline"] = "2OUTLINE",
					["enableScrollable"] = true,
					["Width"] = 149,
					["Y"] = -61,
					["X"] = 901,
					["iconsSize"] = 17,
					["font"] = "KGSmallTownSouthernGirl",
				},
				["critical"] = {
					["fontSize"] = 17,
					["iconsSize"] = 19,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 149,
					["Y"] = 102,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 126,
					["X"] = 901,
				},
				["procs"] = {
					["enabledFrame"] = false,
					["enableScrollable"] = true,
					["Y"] = 101,
					["X"] = 1,
					["Height"] = 127,
					["font"] = "KGSmallTownSouthernGirl",
					["fontOutline"] = "2OUTLINE",
				},
				["loot"] = {
					["fontOutline"] = "2OUTLINE",
					["Width"] = 510,
					["Y"] = -223,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 126,
				},
				["class"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "KGSmallTownSouthernGirl",
					["enabledFrame"] = false,
				},
				["damage"] = {
					["fontSize"] = 17,
					["X"] = 201,
					["Width"] = 133,
					["Y"] = -32,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 170,
					["fontOutline"] = "2OUTLINE",
				},
			},
		}
	end

	if profile == "Repooc" then
		-- No Settings
	end

	if profile == "Darth" then
		-- No Settings
	end

	return database
end

-- register the profile with the engine
AI:RegisterAddonProfile(name, ace3, dbname, OnDemand)