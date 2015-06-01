local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.general.args.pvpautorelease = {
		type = "group",
		name = L["PvP Auto Release"],
		order = 9,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["PvP Auto Release"],
			},
			intro = {
				order = 2,
				type = "description",
				name = L["Automatically release body when killed inside a battleground."],
			},
			enable = {
				order = 3,
				type = "toggle",
				name = ENABLE,
				get = function(info) return E.db.sle.pvpautorelease end,
				set = function(info, value) E.db.sle.pvpautorelease = value; end
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)