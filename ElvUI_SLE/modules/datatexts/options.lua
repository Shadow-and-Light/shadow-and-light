local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DTP = E:GetModule('DTPanels')
local DT = E:GetModule('DataTexts')

local datatexts = {}
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