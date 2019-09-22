local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Armory = SLE:GetModule("Armory_Core")
-- local CA = SLE:GetModule("Armory_Character")

local function configTable()
	if not SLE.initialized then return end
	
	E.Options.args.sle.args.modules.args.armory = {
		type = 'group',
		name = L["Armory Mode"],
		order = 1,
		childGroups = 'tab',
		args = {
			CA_enable = {
				type = 'toggle',
				name = L["Character Armory"],
				order = 2,
				desc = '',
				get = function() return E.db.sle.armory.character.enable end,
				set = function(_, value) E.db.sle.armory.character.enable = value; SLE:GetModule("Armory_Character"):LoadAndSetup(); end
			},
			IA_enable = {
				type = 'toggle',
				name = L["Inspect Armory"],
				order = 3,
				desc = '',
				get = function() return E.db.sle.armory.inspect.enable end,
				set = function(_, value) E.db.sle.armory.inspect.enable = value; SLE:GetModule("Armory_Inspect"):LoadAndSetup() end
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
