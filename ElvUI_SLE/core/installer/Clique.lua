local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

local ace3   = false              -- whether or not this database is a Ace3 profile
local name   = 'Clique'          -- the name of the addon
local dbname = 'CliqueDB3'       -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		-- No Settings
	end

	if profile == "Repooc" then
		--database = {
		--}
	end
  
	if profile == "Darth" then
		-- No Settings
	end

	return database
end

-- register the profile with the engine
AI:RegisterAddonProfile(name, ace3, dbname, OnDemand)