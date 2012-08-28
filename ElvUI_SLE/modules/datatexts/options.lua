local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DTP = E:GetModule('DTPanels')
local DT = E:GetModule('DataTexts')

local datatexts = {}

function DT:PanelLayoutOptions()	
	for name, _ in pairs(DT.RegisteredDataTexts) do
		if name ~= 'Version' then
			datatexts[name] = name
		end
	end
	datatexts[''] = ''
	
	local table = E.Options.args.datatexts.args.panels.args
	local i = 0
	for pointLoc, tab in pairs(P.datatexts.panels) do
		i = i + 1
		if not _G[pointLoc] then table[pointLoc] = nil; return; end
		if type(tab) == 'table' then
			table[pointLoc] = {
				type = 'group',
				args = {},
				name = L[pointLoc] or pointLoc,
				guiInline = true,
				order = i + -10,
			}			
			for option, value in pairs(tab) do
				table[pointLoc].args[option] = {
					type = 'select',
					name = L[option] or option:upper(),
					values = datatexts,
					get = function(info) return E.db.datatexts.panels[pointLoc][ info[#info] ] end,
					set = function(info, value) E.db.datatexts.panels[pointLoc][ info[#info] ] = value; DT:LoadDataTexts() end,									
				}
			end
		elseif type(tab) == 'string' then
			table[pointLoc] = {
				type = 'select',
				name = L[pointLoc] or pointLoc,
				values = datatexts,
				get = function(info) return E.db.datatexts.panels[pointLoc] end,
				set = function(info, value) E.db.datatexts.panels[pointLoc] = value; DT:LoadDataTexts() end,	
			}						
		end
	end
end

--Datatext panels
E.Options.args.sle.args.datatext = {
	type = "group",
	name = L["Datatext Panels"],
	order = 6,
	childGroups = "select",
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Additional Datatext Panels"],
		},
		intro = {
			order = 2,
			type = "description",
			name = L["DP_DESC"]
		},
		dashboard = {
			order = 3,
			type = "toggle",
			name = L["Dashboard"],
			desc = L["Show/Hide dashboard."],
			get = function(info) return E.db.sle.datatext.dashboard.enable end,
			set = function(info, value) E.db.sle.datatext.dashboard.enable = value; DTP:DashboardShow() end
		},
		width = {
			order = 4,
			type = "range",
			name = L["Dashboard Panels Width"],
			desc = L["Sets size of dashboard panels."],
			disabled = function() return not E.db.sle.datatext.dashboard.enable end,
			min = 75, max = 200, step = 1,
			get = function(info) return E.db.sle.datatext.dashboard.width end,
			set = function(info, value) E.db.sle.datatext.dashboard.width = value; DTP:DashWidth() end,
		},
		top_left = {
			order = 1,
			type = "group",
			name = L["DP_1"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp1.enabled end,
					set = function(info, value) E.db.sle.datatext.dp1.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp1.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp1.width end,
					set = function(info, value) E.db.sle.datatext.dp1.width = value; DTP:Resize() end,
				},
			},
		},
		top_center_left = {
			order = 2,
			type = "group",
			name = L["DP_2"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp2.enabled end,
					set = function(info, value) E.db.sle.datatext.dp2.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp2.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp2.width end,
					set = function(info, value) E.db.sle.datatext.dp2.width = value; DTP:Resize() end,
				},
			},
		},
		top = {
			order = 3,
			type = "group",
			name = L["Top_Center"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.top.enabled end,
					set = function(info, value) E.db.sle.datatext.top.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.top.width end,
					set = function(info, value) E.db.sle.datatext.top.width = value; DTP:Resize() end,
				},
			},
		},
		top_center_right = {
			order = 4,
			type = "group",
			name = L["DP_3"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp3.enabled end,
					set = function(info, value) E.db.sle.datatext.dp3.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp3.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp3.width end,
					set = function(info, value) E.db.sle.datatext.dp3.width = value; DTP:Resize() end,
				},
			},
		},
		top_right = {
			order = 5,
			type = "group",
			name = L["DP_4"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp4.enabled end,
					set = function(info, value) E.db.sle.datatext.dp4.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp4.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp4.width end,
					set = function(info, value) E.db.sle.datatext.dp4.width = value; DTP:Resize() end,
				},
			},
		},
		bottom_left = {
			order = 6,
			type = "group",
			name = L["DP_5"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp5.enabled end,
					set = function(info, value) E.db.sle.datatext.dp5.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp5.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp5.width end,
					set = function(info, value) E.db.sle.datatext.dp5.width = value; DTP:Resize() end,
				},
			},
		},
		bottom = {
			order = 7,
			type = "group",
			name = L["Bottom_Panel"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.bottom.enabled end,
					set = function(info, value) E.db.sle.datatext.bottom.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.bottom.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.bottom.width end,
					set = function(info, value) E.db.sle.datatext.bottom.width = value; DTP:Resize() end,
				},
			},
		},
		bottom_right = {
			order = 8,
			type = "group",
			name = L["DP_6"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					get = function(info) return E.db.sle.datatext.dp6.enabled end,
					set = function(info, value) E.db.sle.datatext.dp6.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.dp6.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.dp6.width end,
					set = function(info, value) E.db.sle.datatext.dp6.width = value; DTP:Resize() end,
				},
			},
		},
		chat_left = {
			order = 9,
			type = "group",
			name = L["Left Chat"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					disabled = true,
					get = function(info) return E.db.sle.datatext.chatleft.enabled end,
					set = function(info, value) E.db.sle.datatext.chatleft.enabled = value; end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.chatleft.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.chatleft.width end,
					set = function(info, value) E.db.sle.datatext.chatleft.width = value; DTP:ChatResize() end,
				},
			},
		},
		chat_right = {
			order = 10,
			type = "group",
			name = L["Right Chat"],
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide this panel."],
					disabled = true,
					get = function(info) return E.db.sle.datatext.chatright.enabled end,
					set = function(info, value) E.db.sle.datatext.chatright.enabled = value; end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatext.chatright.enabled end,
					min = 300, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.sle.datatext.chatright.width end,
					set = function(info, value) E.db.sle.datatext.chatright.width = value; DTP:ChatResize() end,
				},
			},
		},
	},
}