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
	name = L["Panels & Dashboard"],
	order = 1,
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
		pethide = {
			order = 5,
			name = L['Hide in Pet Battle'],
			type = 'toggle',
			desc = L['Show/Hide this frame during Pet Battles.'],
			set = function(info, value) E.db.sle.datatext[v[1]].pethide = value; DTP:RegisterHide() end,
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

E.Options.args.sle.args.sldatatext = {
	type = "group",
	name = L["S&L Datatexts"],
	order = 2,
	childGroups = "select",
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Datatext Options"],
		},
		intro = {
			order = 2,
			type = "description",
			name = L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information. Please use the dropdown box to select which datatext you would like to configure."]
		},
		spacer = {
			order = 3,
			type = 'description',
			name = "",
		},
		slfriends = {
			type = "group",
			name = L["S&L Friends"],
			order = 1,
			args = {
				header = {
					order = 1,
					type = "description",
					name = L["These options are for modifing the Shadow & Light Friends datatext."],
				},
				combat = {
					order = 2,
					type = "toggle",
					name = L["Hide In Combat"],
					desc = L["Will not show the tooltip while in combat."],
					get = function(info) return E.db.sle.dt.friends.combat end,
					set = function(info, value) E.db.sle.dt.friends.combat = value; end,
				},
				hidetotals = {
					order = 3,
					type = "toggle",
					name = L["Show Totals"],
					desc = L["Show total friends in the datatext."],
					get = function(info) return E.db.sle.dt.friends.totals end,
					set = function(info, value) E.db.sle.dt.friends.totals = value; DT:update_Friends() end,
				},
				hidehintline = {
					order = 4,
					type = "toggle",
					name = L["Hide Hints"],
					desc = L["Hide the hints in the tooltip."],
					get = function(info) return E.db.sle.dt.friends.hide_hintline end,
					set = function(info, value) E.db.sle.dt.friends.hide_hintline = value; end,
				},
				bnbroadcast = {
					order = 5,
					type = "toggle",
					name = L["Expand RealID"],
					desc = L["Display realid with two lines to view broadcasts."],
					get = function(info) return E.db.sle.dt.friends.expandBNBroadcast end,
					set = function(info, value) E.db.sle.dt.friends.expandBNBroadcast = value; end,
				},
				spacer = {
					order = 6,
					type = 'description',
					name = "",
				},
				tooltipautohide = {
					order = 7,
					type = "range",
					name = L["Autohide Delay:"],
					desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
					min = 0.1, max = 1, step = 0.1,
					get = function(info) return E.db.sle.dt.friends.tooltipAutohide end,
					set = function(info, value) E.db.sle.dt.friends.tooltipAutohide = value; end,
				},
			},
		},
		slguild = {
			type = "group",
			name = L["S&L Guild"],
			order = 2,
			args = {
				header = {
					order = 1,
					type = "description",
					name = L["These options are for modifing the Shadow & Light Guild datatext."],
				},
				combat = {
					order = 2,
					type = "toggle",
					name = L["Hide In Combat"],
					desc = L["Will not show the tooltip while in combat."],
					get = function(info) return E.db.sle.dt.guild.combat end,
					set = function(info, value) E.db.sle.dt.guild.combat = value; end,
				},
				hidetotals = {
					order = 3,
					type = "toggle",
					name = L["Show Totals"],
					desc = L["Show total guild members in the datatext."],
					get = function(info) return E.db.sle.dt.guild.totals end,
					set = function(info, value) E.db.sle.dt.guild.totals = value; DT:update_Guild() end,
				},
				hidehintline = {
					order = 4,
					type = "toggle",
					name = L["Hide Hints"],
					desc = L["Display the hints in the tooltip."],
					get = function(info) return E.db.sle.dt.guild.hide_hintline end,
					set = function(info, value) E.db.sle.dt.guild.hide_hintline = value; end,
				},
				hidemotd = {
					order = 5,
					type = "toggle",
					name = L["Hide MOTD"],
					desc = L["Hide the guild's Message of the Day in the tooltip."],
					get = function(info) return E.db.sle.dt.guild.hide_gmotd end,
					set = function(info, value) E.db.sle.dt.guild.hide_gmotd = value; end,
				},
				hideguildname = {
					order = 6,
					type = "toggle",
					name = L["Hide Guild Name"],
					desc = L["Hide the guild's name in the tooltip."],
					get = function(info) return E.db.sle.dt.guild.hide_guildname end,
					set = function(info, value) E.db.sle.dt.guild.hide_guildname = value; end,
				},
				spacer = {
					order = 7,
					type = 'description',
					name = "",
				},
				tooltipautohide = {
					order = 8,
					type = "range",
					name = L["Autohide Delay:"],
					desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
					min = 0.1, max = 1, step = 0.1,
					get = function(info) return E.db.sle.dt.guild.tooltipAutohide end,
					set = function(info, value) E.db.sle.dt.guild.tooltipAutohide = value; end,
				},
			},
		},
		timedt = {
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
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)