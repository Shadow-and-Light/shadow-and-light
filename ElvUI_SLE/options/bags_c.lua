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
			lootflash = {
				order = 5,
				type = "toggle",
				name = L["New Item Flash"],
				desc = L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"],
				get = function(info) return E.db.sle.bags.lootflash end,
				set = function(info, value)	E.db.sle.bags.lootflash = value end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)