local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('Misc')

local function configTable()
	E.Options.args.sle.args.options.args.ru = {
		order = 9,
		type = "group",
		name = L['Raid Utility'],
		args = {
			ru = {
				order = 1,
				type = "group",
				name = L['Raid Utility'],
				args = {
					info = {
						order = 1,
						type = "description",
						name = "Options for the raid control button",
					},
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.sle.rumouseover end,
						set = function(info, value) E.db.sle.rumouseover = value; M:RUReset() end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)