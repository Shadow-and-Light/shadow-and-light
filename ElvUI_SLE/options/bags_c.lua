local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.general.args.bags = {
		order = 6,
		type = "group",
		name = L["Bags"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Bags"],
			},
			lootshadow = {
				order = 5,
				type = "toggle",
				name = L["Loot Shadow"],
				desc = L["Use the Shadow & Light Loot Shadow"],
				get = function(info) return E.db.sle.bags.lootshadow end,
				set = function(info, value)	E.db.sle.bags.lootshadow = value end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)