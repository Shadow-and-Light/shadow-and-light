local E, L, V, P, G = unpack(ElvUI);
local NP = E:GetModule('NamePlates')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.nameplate = {
		type = "group",
		name = L["NamePlates"],
		order = 8,
		get = function(info) return E.db.sle.nameplate[ info[#info] ] end,
		set = function(info, value) E.db.sle.nameplate[ info[#info] ] = value; NP:UpdateAllPlates() end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NamePlates"],
			},
			targetcount = {
				type = "toggle",
				order = 2,
				name = L["Target Count"],
				desc = L["Display the number of party / raid members targetting the nameplate unit."],
			},
			showthreat = {
				type = "toggle",
				order = 3,
				name = L["Threat Text"],
				desc = L["Display threat level as text on targeted, boss or mouseover nameplate."],
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)