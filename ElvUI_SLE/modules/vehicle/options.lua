local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local function configTable()
	E.Options.args.sle.args.vehicle = {
		type = "group",
		name = L["Enhanced Vehicle Bar"],
		desc = L["Use the enhanced vehicle bar based on work by Azilroka"],
		order = 84,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.private.sle.vehicle.enable end,
				set = function(info, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)