local E, L, V, P, G = unpack(ElvUI);
local SLT = E:GetModule('SLE_Threat');

local function configTable()
	E.Options.args.sle.args.options.args.general.args.threat = {
		type = "group",
		name = L['Threat'],
		order = 55,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L['Threat'],
			},
			--[[intro = {
				order = 2,
				type = "description",
				name = "Some threat changes",
			},]]
			enabled = {
				order = 3,
				type = "toggle",
				name = ENABLE,
				--desc = L["Show/Hide UI buttons."],
				get = function(info) return E.db.sle.threat.enable end,
				set = function(info, value) E.db.sle.threat.enable = value; SLT:Update(); SLT:UpdatePosition() end,
			},
			space1 = {
				order = 4,
				type = 'description',
				name = "",
			},
			space2 = {
				order = 5,
				type = 'description',
				name = "",
			},
			position = {
				order = 6,
				type = 'select',
				name = L['Position'],
				desc = L['Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L.'],
				values = {
					['Top_Center'] = "Top Panel",
					['Bottom_Panel'] = "Bottom Panel",
					['DP_1'] = "Data Panel 1",
					['DP_2'] = "Data Panel 2",
					['DP_3'] = "Data Panel 3",
					['DP_4'] = "Data Panel 4",
					['DP_5'] = "Data Panel 5",
					['DP_6'] = "Data Panel 6",
					['LeftChatDataPanel'] = L['Left Chat'],
					['RightChatDataPanel'] = L['Right Chat'],
				},
				get = function(info) return E.db.sle.threat.position end,
				set = function(info, value) E.db.sle.threat.position = value; SLT:UpdatePosition() end,	
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)