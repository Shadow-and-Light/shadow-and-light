local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local function configTable()
	E.Options.args.sle.args.options.args.general.args.vehicle = {
		type = "group",
		name = L["Enhanced Vehicle Bar"],
		order = 84,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Enhanced Vehicle Bar"],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
				desc = L["Use the enhanced vehicle bar based on work by Azilroka"],
				get = function(info) return E.private.sle.vehicle.enable end,
				set = function(info, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)