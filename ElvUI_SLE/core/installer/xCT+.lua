local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

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
		database = {
			["megaDamage"] = {
				["millionSymbol"] = "|cffFF0000м|r",
				["thousandSymbol"] = "|cffFF8000к|r",
			},
			["frames"] = {
				["general"] = {
					["fontSize"] = 14,
					["showBuffs"] = false,
					["fontOutline"] = "2OUTLINE",
					["showPartyKills"] = false,
					["enableCustomFade"] = true,
					["showDebuffs"] = false,
					["font"] = "ElvUI Font",
				},
				["power"] = {
					["fontOutline"] = "2OUTLINE",
					["Width"] = 165,
					["font"] = "ElvUI Font",
					["enabledFrame"] = false,
					["enableCustomFade"] = true,
					["fontSize"] = 16,
					["Y"] = 60,
					["X"] = 5,
					["Height"] = 155,
				},
				["healing"] = {
					["fontSize"] = 16,
					["megaDamage"] = true,
					["showFriendlyHealers"] = false,
					["fontOutline"] = "2OUTLINE",
					["insertText"] = "top",
					["enableCustomFade"] = true,
					["Width"] = 112,
					["Y"] = -306,
					["X"] = -356,
					["Height"] = 160,
					["font"] = "ElvUI Font",
				},
				["outgoing"] = {
					["fontSize"] = 16,
					["megaDamage"] = true,
					["fontOutline"] = "2OUTLINE",
					["insertText"] = "top",
					["enableCustomFade"] = true,
					["Width"] = 119,
					["Y"] = -317,
					["font"] = "ElvUI Font",
					["Height"] = 160,
					["iconsSize"] = 10,
					["X"] = 248,
				},
				["critical"] = {
					["fontSize"] = 20,
					["megaDamage"] = true,
					["iconsSize"] = 14,
					["fontOutline"] = "2OUTLINE",
					["insertText"] = "top",
					["enableCustomFade"] = true,
					["Width"] = 171,
					["Y"] = -306,
					["font"] = "ElvUI Font",
					["Height"] = 138,
					["X"] = 391,
				},
				["procs"] = {
					["enabledFrame"] = false,
					["enableCustomFade"] = true,
					["Width"] = 254,
					["Y"] = -63,
					["Height"] = 126,
				},
				["loot"] = {
					["fontSize"] = 12,
					["filterItemQuality"] = 2,
					["X"] = -2,
					["fontOutline"] = "2OUTLINE",
					["visibilityTime"] = 2,
					["enableCustomFade"] = true,
					["fadeTime"] = 0.2,
					["Width"] = 287,
					["Y"] = 9,
					["font"] = "ElvUI Font",
					["showItemTypes"] = false,
					["Height"] = 126,
				},
				["class"] = {
					["enabledFrame"] = false,
				},
				["damage"] = {
					["fontSize"] = 16,
					["megaDamage"] = true,
					["fontOutline"] = "2OUTLINE",
					["font"] = "ElvUI Font",
					["enableCustomFade"] = true,
					["Width"] = 110,
					["Y"] = -306,
					["X"] = -246,
					["Height"] = 160,
				},
			},
			["showStartupText"] = false,
			["frameSettings"] = {
				["clearLeavingCombat"] = true,
			},
			
		}
	end
	
	return database
end

-- register the profile with the engine
AI:RegisterAddonProfile(name, ace3, dbname, OnDemand)