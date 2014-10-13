local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

-- Upvalue for performance
local pairs, string, table, unpack, _G = pairs, string, table, unpack, _G
local string_find, string_format, string_gsub, string_sub, table_insert, table_remove
  = string.find, string.format, string.gsub, string.sub, table.insert, table.remove

-- A local database of addons
AI.addons = { }
AI.MyProfileKey = string_format('%s - %s', UnitName('player'), GetRealmName() )
AI.MyProfileName = "Shadow and Light"

-- Let's put all the RegEx stuff here
local regex_trim  = '^%s*(.-)%s*$'
local regex_match = '([ A-Za-z0-9_+*\\-]+)%s?,'

--[==[
  AddonInstaller:RegisterAddonProfile(name, ace3, dbname, onDemand)
  
  input:  (*optional)
  
    name        [string]
        The name name of the addon to use in the Command Args when enabling.
  
    ace3        [boolean]
        Indicator whether to treat this entry as an Ace3 compatible profile,
      or just some random entries into an addon's database.
  
    dbname      [string]
        The name of the addon's database (e.g. 'ElvCharacterDB')
        
    onDemand    [function]
        The function that will generate the "load on demand" profile.
        
  description:
      This function allows addon modules to register themselves so that they can get
    loaded when the user installs this UI.
  
  returns:
    nil
]==]
function AI:RegisterAddonProfile(name, ace3, dbname, onDemand)
	if not self.addons[name] then self.addons[name] = { } end
	table_insert(self.addons[name], { OnDemand = onDemand, dbname = dbname, ace3 = ace3 })
end

-- A private function that loads a specific addon database entry
local function LoadAddon(entry, profileName)
	local ADDON_DB = _G[entry.dbname]
	local myDB = entry.OnDemand(profileName)

	if ADDON_DB and myDB then
		if entry.ace3 then
			-- Profile will be: "Shadow and Light (Affinitii)"
			local profile = string_format('%s (%s)', AI.MyProfileName, profileName)

			-- If the addon is loaded AND the profile is Ace3, lets load it
			ADDON_DB.profiles[profile] = myDB                    -- Insert our new profile

			-- Set the profile as the default for this toon
			ADDON_DB.profileKeys[AI.MyProfileKey] = profile
		else
			for key, value in pairs(myDB) do
				ADDON_DB[key] = value
			end
		end
	end
end

--[==[
  AddonInstaller:LoadAddons(args)
  
  input: (*optional)
    args  [string]
        This is a comma separated list, where the first value is the profile that you
      want to load. The second arg can be "All" for all addons or the second and
      following args can list the addons one at a time.
      
        examples:
        
        1.  args = "Repooc, All"
          
            Loads all addons with the profile name "Repooc"
            
        2.  args = "Darth, Hermes, xCT+,"
        
            Loads Hermes and xCT+ addons with the profile name "Darth"
        
  description:
      This function was create to allow the loading of external addons profiles when a
    UI is installed.
  
  returns:
    nil
]==]

function AI:LoadAddons(args)
	-- This section of code parses the args
	local ListArgs = { }

	-- Trim the text (remove spaces), placed a nil check inside
	args = string_gsub(args or '', regex_trim, '%1')

	-- Add a comma onto the end
	if string_sub(args, #args) ~= ',' then
		args = args .. ','
	end

	local i, j = 0, 0
	while i do
		i, j = string_find(args, regex_match, j)    -- find all patterns that match 'Arg_1 Test+,'
		if i then
			-- Get the current pattern [ sub(index, length-1 ], trim all the spaces, and add it to the list of args
			local arg = string_gsub(string_sub(args, i, j-1), regex_trim, '%1')
			table_insert(ListArgs, arg)
		end
	end
	-- Args parsing completed!
  
	--[==[
	-- DEBUG: See what args I have :)
	for i, v in pairs(ListArgs) do
		print(i,'=',v)
	end
	]==]

	-- Get the profile name and see if we are loading All addons
	local profileName, LOAD_ALL = ( ListArgs[1] or 'default' ), ( ListArgs[2] == 'All' )
	table_remove(ListArgs, 1)  -- Remove the profile name, all we have left in the list are addons to load :)

	if LOAD_ALL then -- Load all the addons 
		for name, entryList in pairs(self.addons) do      -- Just load all the addons for this profile
			for _, entry in pairs(entryList) do             -- Loop through all the entries (could be multiple, like bigwigs)
				LoadAddon(entry, profileName)
			end
		end
	else  -- Load a specific set of addons 
		for _, name in pairs(ListArgs) do                 -- we need to figure out which addons to load
			local entryList = self.addons[name]
			for _, entry in pairs(entryList) do
				-- Check for addon name
				if entry then
					for _, entry in pairs(entryList) do           -- Loop through all the entries
						LoadAddon(entry, profileName)
					end
				else
					E:Print("  |cffFF0000ERROR:|r No Addon named '"..name.."' was found in the SLE addon configs.")
				end
			end
		end
	end
end