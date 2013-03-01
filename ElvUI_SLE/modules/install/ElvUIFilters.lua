local E, L, V, P, G, _ = unpack(ElvUI);
local AI = E:GetModule('AddonInstaller')

local ace3   = false              -- whether or not this database is a Ace3 profile
local name   = 'ElvUI'          -- the name of the addon
local dbname = 'ElvDB'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["global"] = {
				["unitframe"] = {
					["buffwatch"] = {
						["MONK"] = {
							nil,
							nil,
							nil,
							{
								["displayText"] = true,
								["style"] = "NONE",
							},
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