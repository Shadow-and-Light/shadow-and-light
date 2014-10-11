local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

local ace3   = true               -- whether or not this database is a Ace3 profile
local name   = 'Skada'             -- the name of the addon
local dbname = 'SkadaDB'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["windows"] = {
				{
					["barheight"] = 17,
					["barslocked"] = true,
					["background"] = {
						["height"] = 133.6666717529297,
						["color"] = {
							["a"] = 0.2000000476837158,
							["b"] = 0,
						},
					},
					["hidden"] = true,
					["y"] = 39.89817468303028,
					["x"] = -7.334928625263729,
					["title"] = {
						["color"] = {
							["a"] = 1,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["font"] = "ElvUI Font",
						["fontsize"] = 15,
					},
					["point"] = "BOTTOMRIGHT",
					["barbgcolor"] = {
						["a"] = 1,
						["b"] = 0.3019607843137255,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["barcolor"] = {
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["name"] = "HPS",
					["spark"] = false,
					["bartexture"] = "Polished Wood",
					["barwidth"] = 199.0832316080729,
					["barfontsize"] = 12,
					["mode"] = "Damage",
					["barfont"] = "ElvUI Font",
				}, -- [1]
				{
					["barheight"] = 17,
					["classicons"] = true,
					["barslocked"] = true,
					["clickthrough"] = false,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = true,
					["y"] = 39.89824908834681,
					["barfont"] = "ElvUI Font",
					["name"] = "DPS",
					["display"] = "bar",
					["barfontflags"] = "",
					["classcolortext"] = false,
					["scale"] = 1,
					["reversegrowth"] = false,
					["barfontsize"] = 12,
					["barorientation"] = 1,
					["snapto"] = true,
					["point"] = "BOTTOMRIGHT",
					["x"] = -214.2783479639852,
					["spark"] = false,
					["bartexture"] = "Polished Wood",
					["barwidth"] = 199.0832316080729,
					["barspacing"] = 0,
					["barbgcolor"] = {
						["a"] = 1,
						["b"] = 0.3019607843137255,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["returnaftercombat"] = false,
					["barcolor"] = {
						["a"] = 1,
						["b"] = 0.8,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["mode"] = "Healing",
					["enabletitle"] = true,
					["classcolorbars"] = true,
					["modeincombat"] = "",
					["title"] = {
						["borderthickness"] = 2,
						["font"] = "ElvUI Font",
						["fontsize"] = 15,
						["fontflags"] = "",
						["color"] = {
							["a"] = 1,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Aluminium",
					},
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 133.6666717529297,
						["color"] = {
							["a"] = 0.2000000476837158,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
				}, -- [2]
			},
			["report"] = {
				["number"] = 12,
				["chantype"] = "whisper",
				["channel"] = "whisper",
				["target"] = "Affinitii",
				["mode"] = "Riggimon's Death",
			},
			["icon"] = {
				["minimapPos"] = 160.4361246854299,
				["hide"] = true,
			},
		}
	end

	if profile == "Repooc" then
		-- No Settings
	end

	if profile == "Darth" then

	end
	
	return database
end

-- register the profile with the engine
AI:RegisterAddonProfile(name, ace3, dbname, OnDemand)