local E, L, V, P, G = unpack(ElvUI); 

local function configTable()
	E.Options.args.sle.args.options.args.general.args.vehicle = {
		type = "group",
		name = L["Enhanced Vehicle Bar"],
		order = 6,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Enhanced Vehicle Bar"],
			},
			info = {
				order = 2,
				type = "description",
				name = L["A different look/feel vehicle bar based on work by Azilroka"],
			},
			enable = {
				order = 3,
				type = "toggle",
				name = ENABLE,
				get = function(info) return E.private.sle.vehicle.enable end,
				set = function(info, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)