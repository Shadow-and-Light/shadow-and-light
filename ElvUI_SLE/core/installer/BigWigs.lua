local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

local ace3   = true               -- whether or not this database is a Ace3 profile
local name   = 'BigWigs'          -- the name of the addon
local dbname = 'BigWigs3DB'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["showBlizzardWarnings"] = true,
			["showBossmodChat"] = true,
			["seenmovies"] = {
				[73] = true,
				[74] = true,
				[75] = true,
				[76] = true,
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