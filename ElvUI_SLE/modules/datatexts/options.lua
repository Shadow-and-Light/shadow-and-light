local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DTP = E:GetModule('DTPanels')
local DT = E:GetModule('DataTexts')

local datatexts = {}
local function configTable()
local drop = {
	--Group name = {short name, order, slot}
	["DP_1"] = {"dp1", 1, 3},
	["DP_2"] = {"dp2", 2, 3},
	["Top_Center"] = {"top", 3, 1},
	["DP_3"] = {"dp3", 4, 3},
	["DP_4"] = {"dp4", 5, 3},
	["DP_5"] = {"dp5", 6, 3},
	["Bottom_Panel"] = {"bottom", 7, 1},
	["DP_6"] = {"dp6", 8, 3},
}
local chatT = {
	--Group name = {short name, order, elv's varible, chat panel(used to call functions)}
	["Left Chat"] = {"chatleft", 9, "leftChatPanel", "LeftChat"},
	["Right Chat"] = {"chatright", 10, "rightChatPanel", "RightChat"},
}

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
		Reset = {
			order = 3,
			type = 'execute',
			name = L['Restore Defaults'],
			desc = L["Reset these options to defaults"],
			func = function() E:GetModule('SLE'):Reset(nil, nil, true) end,
		},
		spacer = {
			order = 4,
			type = 'description',
			name = "",
		},
		dashboard = {
			order = 5,
			type = "toggle",
			name = L["Dashboard"],
			desc = L["Show/Hide dashboard."],
			get = function(info) return E.db.sle.datatext.dashboard.enable end,
			set = function(info, value) E.db.sle.datatext.dashboard.enable = value; DTP:DashboardShow() end
		},
		width = {
			order = 6,
			type = "range",
			name = L["Dashboard Panels Width"],
			desc = L["Sets size of dashboard panels."],
			disabled = function() return not E.db.sle.datatext.dashboard.enable end,
			min = 75, max = 200, step = 1,
			get = function(info) return E.db.sle.datatext.dashboard.width end,
			set = function(info, value) E.db.sle.datatext.dashboard.width = value; DTP:DashWidth() end,
		},
	},
}

for k,v in pairs(drop) do
E.Options.args.sle.args.datatext.args[v[1]] = {
	order = v[2],
	type = "group",
	name = L[k],
	get = function(info) return E.db.sle.datatext[v[1]][ info[#info] ] end,
	args = {
		enabled = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Show/Hide this panel."],
			set = function(info, value) E.db.sle.datatext[v[1]].enabled = value; DTP:ExtraDataBarSetup() end
		},
		width = {
			order = 2,
			type = "range",
			name = L['Width'],
			desc = L["Sets size of this panel"],
			disabled = function() return not E.db.sle.datatext[v[1]].enabled end,
			min = 100 * v[3], max = E.screenwidth/2, step = 1,
			set = function(info, value) E.db.sle.datatext[v[1]].width = value; DTP:Resize() end,
		},
		hide = {
			order = 3,
			type = "toggle",
			name = L['Hide panel background'],
			desc = L["Don't show this panel, only datatexts assinged to it"],
			disabled = function() return not E.db.sle.datatext[v[1]].enabled end,
			get = function(info) return E.private.sle.datatext[v[1].."hide"] end,
			set = function(info, value) E.private.sle.datatext[v[1].."hide"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		},
		transparent = {
			order = 4,
			name = L['Panel Transparency'],
			type = 'toggle',
			disabled = function() return not E.db.sle.datatext[v[1]].enabled or E.private.sle.datatext[v[1].."hide"] end,
			--get = function(info) return E.db.sle.datatext[v[1]]."transparent"] end,
			set = function(info, value) E.db.sle.datatext[v[1]].transparent = value; DTP:ExtraDataBarSetup() end,				
		},
	},
}
end

for k,v in pairs(chatT) do
E.Options.args.sle.args.datatext.args[v[1]] = {
	order = v[2],
	type = "group",
	name = L[k],
	args = {
		enabled = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Show/Hide this panel."],
			get = function(info) return E.db.datatexts[v[3]] end,
			set = function(info, value) 
				E.db.datatexts[v[3]] = value;
				if E.db[v[4].."PanelFaded"] then
					E.db[v[4].."PanelFaded"] = true;
					Hide[v[4]]()
				end
				E:GetModule('Chat'):UpdateAnchors()
				E:GetModule('Layout'):ToggleChatPanels()
				E:GetModule('Bags'):PositionBagFrames()
			end
		},
		width = {
			order = 2,
			type = "range",
			name = L['Width'],
			desc = L["Sets size of this panel"],
			disabled = function() return not E.db.datatexts[v[3]] end,
			min = 150, max = E.screenwidth/2, step = 1,
			get = function(info) return E.db.sle.datatext[v[1]].width end,
			set = function(info, value) E.db.sle.datatext[v[1]].width = value; DTP:ChatResize() end,
		},
	},
	
}
end

--Time datatext
E.Options.args.sle.args.timedt = {
	type = "group",
	name = RAID_FINDER,
	order = 6,
	args = {
		lfrshow = {
			order = 1,
			type = "toggle",
			name = L["LFR Lockout"],
			desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
			get = function(info) return E.db.sle.lfrshow.enabled end,
			set = function(info, value) E.db.sle.lfrshow.enabled = value; end
		},
		instances = {
			order = 2,
			type = "group",
			name = L["Loot History"],
			guiInline = true,
			get = function(info) return E.db.sle.lfrshow[ info[#info] ] end,
			set = function(info, value) E.db.sle.lfrshow[ info[#info] ] = value; end,
			args = {
				ds = {
					order = 1,
					type = "toggle",
					name = GetMapNameByID(824),
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
				},
				mv = {
					order = 2,
					type = "toggle",
					name = GetMapNameByID(896),
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
				},
				hof = {
					order = 3,
					type = "toggle",
					name = GetMapNameByID(897),
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
				},
				toes = {
					order = 4,
					type = "toggle",
					name = GetMapNameByID(886),
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
				},
				tot = {
					order = 5,
					type = "toggle",
					name = GetMapNameByID(930),
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)