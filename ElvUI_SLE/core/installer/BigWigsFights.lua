local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

local ace3   = false              -- whether or not this database is a Ace3 profile
local name   = 'BigWigs'          -- the name of the addon
local dbname = 'BigWigs3DB'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["namespaces"] = {
				["BigWigs_Bosses_Madness of Deathwing"] = {
					["profiles"] = {
						["Shadow and Light (Affinitii)"] = {
							["Elementium Bolt"] = 643,
						},
					},
				},
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						["Shadow and Light (Affinitii)"] = {
							["fontSize"] = 20.00000079528718,
							["posy"] = 265.5998002156482,
							["lock"] = true,
							["posx"] = 244.6221205041632,
							["sound"] = false,
							["font"] = "ElvUI Font",
						},
					},
				},
				["BigWigs_Plugins_Sounds"] = {
					["profiles"] = {
						["Shadow and Light (Affinitii)"] = {
							["Long"] = {
							},
							["Info"] = {
							},
							["Alarm"] = {
							},
							["Alert"] = {
							},
						},
					},
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						["Shadow and Light (Affinitii)"] = {
							["fontSize"] = 20.00000079528718,
							["monochrome"] = false,
							["font"] = "ElvUI Font",
							["BWEmphasizeMessageAnchor_y"] = 465.0667085654549,
							["BWMessageAnchor_y"] = 440.8888495721501,
							["BWEmphasizeMessageAnchor_x"] = 610.8445805698311,
							["BWMessageAnchor_x"] = 610.8445307717618,
						},
					},
				},
				["BigWigs_Plugins_Bars"] = {
					["profiles"] = {
						["Shadow and Light (Affinitii)"] = {
							["BigWigsEmphasizeAnchor_y"] = 303.2888646270365,
							["BigWigsAnchor_y"] = 116.8001243424387,
							["emphasizeGrowup"] = false,
							["BigWigsAnchor_x"] = 19.73342363118923,
							["fill"] = false,
							["BigWigsAnchor_width"] = 381.8331333576473,
							["BigWigsEmphasizeAnchor_width"] = 216.1665623191371,
							["BigWigsEmphasizeAnchor_x"] = 272.8889300172694,
							["font"] = "ElvUI Font",
							["emphasizeScale"] = 1,
						},
					},
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