local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('Misc')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.ru = {
		type = "group",
		name = L['Raid Utility'],
		order = 10,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L['Raid Utility'],
			},
			info = {
				order = 2,
				type = "description",
				name = "",
			},
			mouseover = {
				order = 3,
				type = "toggle",
				name = L["Mouse Over"],
				desc = L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."],
				get = function(info) return E.db.sle.rumouseover end,
				set = function(info, value) E.db.sle.rumouseover = value; M:RUReset() end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)