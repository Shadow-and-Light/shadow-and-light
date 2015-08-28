local E, L, V, P, G = unpack(ElvUI);
local DTP = E:GetModule('SLE_DTPanels')
local DT = E:GetModule('DataTexts')
local datatexts = {}

local function configTable()
	local drop = {
		--Group name = {short name, order, slot}
		["DP_1"] = {"dp1", 1, 3},
		["DP_2"] = {"dp2", 2, 3},
		["DP_3"] = {"dp3", 3, 3},
		["DP_4"] = {"dp4", 4, 3},
		["DP_5"] = {"dp5", 5, 3},
		["DP_6"] = {"dp6", 6, 3},
		["Top_Center"] = {"top", 7, 1},
		["Bottom_Panel"] = {"bottom", 8, 1},
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
		order = 10,
		childGroups = "tab",
		args = {
			panels = {
				type = "group",
				name = L["Panels & Dashboard"],
				order = 1,
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
					chathandle = {
						order = 7,
						type = "toggle",
						name = L["Override Chat DT Panels"],
						desc = L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."],
						get = function(info) return E.db.sle.datatext.chathandle end,
						set = function(info, value) E.db.sle.datatext.chathandle = value; E:GetModule('Layout'):ToggleChatPanels(); E.Chat:PositionChat(true) end,
						disabled = function() return IsAddOnLoaded("ElvUI_TukUIStyle") end,
					},
				},
			},
		},
	}

	for k,v in pairs(drop) do
	E.Options.args.sle.args.datatext.args.panels.args[v[1]] = {
		order = v[2],
		type = "group",
		name = L[k],
		get = function(info) return E.db.sle.datatext[v[1]][ info[#info] ] end,
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = ENABLE,
				desc = L["Show/Hide this panel."],
				set = function(info, value) E.db.sle.datatext[v[1]].enabled = value; DTP:ExtraDataBarSetup() end
			},
			width = {
				order = 2,
				type = "range",
				name = L['Width'],
				desc = L["Sets size of this panel"],
				disabled = function() return not E.db.sle.datatext[v[1]].enabled end,
				min = 100 * v[3], max = (E.eyefinity or E.screenwidth)/2, step = 1,
				set = function(info, value) E.db.sle.datatext[v[1]].width = value; DTP:Update() end,
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
				set = function(info, value) E.db.sle.datatext[v[1]].transparent = value; DTP:ExtraDataBarSetup() end,				
			},
			pethide = {
				order = 5,
				name = L["Hide in Pet Batlle"],
				type = 'toggle',
				desc = L['Show/Hide this frame during Pet Battles.'],
				set = function(info, value) E.db.sle.datatext[v[1]].pethide = value; DTP:RegisterHide() end,
			},
			alpha = {
				order = 12,
				type = 'range',
				name = L['Alpha'],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				--get = function(info) return E.db.sle.backgrounds[v[1]].alpha end,
				set = function(info, value) E.db.sle.datatext[v[1]].alpha = value; DTP:Update() end,
			},
		},
	}
	end

	for k,v in pairs(chatT) do
	E.Options.args.sle.args.datatext.args.panels.args[v[1]] = {
		order = v[2],
		type = "group",
		name = L[k],
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = ENABLE,
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
				min = 150, max = (E.eyefinity or E.screenwidth)/2, step = 1,
				get = function(info) return E.db.sle.datatext[v[1]].width end,
				set = function(info, value) E.db.sle.datatext[v[1]].width = value; DTP:ChatResize() end,
			},
			alpha = {
				order = 12,
				type = 'range',
				name = L['Alpha'],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				get = function(info) return E.db.sle.datatext[v[1]].alpha end,
				set = function(info, value) E.db.sle.datatext[v[1]].alpha = value; DTP:ChatResize() end,
			},
		},
		
	}
	end

	E.Options.args.sle.args.datatext.args.sldatatext = {
		type = "group",
		name = L["S&L Datatexts"],
		order = 2,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Datatext Options"],
			},
			intro = {
				order = 2,
				type = "description",
				name = L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."]
			},
			spacer = {
				order = 3,
				type = 'description',
				name = "",
			},
			timedt = {
				type = "group",
				name = RAID_FINDER,
				order = 1,
				args = {
					lfrshow = {
						order = 1,
						type = "toggle",
						name = L["LFR Lockout"],
						desc = L["Show/Hide LFR lockout info in time datatext's tooltip."],
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
							},
							mv = {
								order = 2,
								type = "toggle",
								name = GetMapNameByID(896),
							},
							hof = {
								order = 3,
								type = "toggle",
								name = GetMapNameByID(897),
							},
							toes = {
								order = 4,
								type = "toggle",
								name = GetMapNameByID(886),
							},
							tot = {
								order = 5,
								type = "toggle",
								name = GetMapNameByID(930),
							},
							soo = {
								order = 6,
								type = "toggle",
								name = GetMapNameByID(953),
							},
							hm = {
								order = 7,
								type = "toggle",
								name = GetMapNameByID(994),
							},
							brf = {
								order = 8,
								type = "toggle",
								name = GetMapNameByID(988),
							},
							hfc = {
								order = 9,
								type = "toggle",
								name = GetMapNameByID(1026),
							},
							--[[hmNormal = {
								order = 8,
								type = "toggle",
								name = GetMapNameByID(994).." ("..PLAYER_DIFFICULTY1..")",
							},
							hmHeroic = {
								order = 9,
								type = "toggle",
								name = GetMapNameByID(994).." ("..PLAYER_DIFFICULTY2..")",
							},]]
						},
					},
				},
			},
			slcurrency = {
				type = "group",
				name = "S&L Currency",
				order = 2,
				args = {
					header = {
						order = 1,
						type = "description",
						name = L['ElvUI Improved Currency Options'],
					},
					arch = {
						order = 2,
						type = "toggle",
						name = L['Show Archaeology Fragments'],
						get = function(info) return E.private['ElvUI_Currency']['Archaeology'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Archaeology'] = value; end,
					},
					jewel = {
						order = 3,
						type = "toggle",
						name = L['Show Jewelcrafting Tokens'],
						get = function(info) return E.private['ElvUI_Currency']['Jewelcrafting'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Jewelcrafting'] = value; end,
					},
					pvp = {
						order = 4,
						type = "toggle",
						name = L['Show Player vs Player Currency'],
						get = function(info) return E.private['ElvUI_Currency']['PvP'] end,
						set = function(info, value) E.private['ElvUI_Currency']['PvP'] = value; end,
					},
					dungeon = {
						order = 5,
						type = "toggle",
						name = L['Show Dungeon and Raid Currency'],
						get = function(info) return E.private['ElvUI_Currency']['Raid'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Raid'] = value; end,
					},
					cook = {
						order = 6,
						type = "toggle",
						name = L['Show Cooking Awards'],
						get = function(info) return E.private['ElvUI_Currency']['Cooking'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Cooking'] = value; end,
					},
					misc = {
						order = 7,
						type = "toggle",
						name = L['Show Miscellaneous Currency'],
						get = function(info) return E.private['ElvUI_Currency']['Miscellaneous'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Miscellaneous'] = value; end,
					},
					zero = {
						order = 8,
						type = "toggle",
						name = L['Show Zero Currency'],
						get = function(info) return E.private['ElvUI_Currency']['Zero'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Zero'] = value; end,
					},
					icons = {
						order = 9,
						type = "toggle",
						name = L['Show Icons'],
						get = function(info) return E.private['ElvUI_Currency']['Icons'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Icons'] = value; end,
					},
					faction = {
						order = 10,
						type = "toggle",
						name = L['Show Faction Totals'],
						get = function(info) return E.private['ElvUI_Currency']['Faction'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Faction'] = value; end,
					},
					unused = {
						order = 11,
						type = "toggle",
						name = L['Show Unsed Currency'],
						get = function(info) return E.private['ElvUI_Currency']['Unused'] end,
						set = function(info, value) E.private['ElvUI_Currency']['Unused'] = value; end,
					},
				},
			},
			slfriends = {
				type = "group",
				name = L["S&L Friends"],
				order = 3,
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
				order = 4,
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
						desc = L["Hide the hints in the tooltip."],
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
			slmail = {
				type = "group",
				name = L["S&L Mail"],
				order = 5,
				args = {
					header = {
						order = 1,
						type = "description",
						name = L["These options are for modifing the Shadow & Light Mail datatext."],
					},
					icon = {
						order = 2,
						type = "toggle",
						name = L["Minimap icon"],
						desc = L["If enabled will show new mail icon on minimap."],
						get = function(info) return E.db.sle.dt.mail.icon end,
						set = function(info, value) E.db.sle.dt.mail.icon = value; DT:SLEmailUp() end,
					}
				},
			},
			sldurability = {
				type = "group",
				name = DURABILITY,
				order = 6,
				args = {
					header = {
						order = 1,
						type = "description",
						name = L["Any changes made will take effect only after:\n - Opening vendor\n - Item durability changes\n - Experiencing loading screen."],
					},
					gradient = {
						order = 2,
						type = "toggle",
						name = L["Gradient"],
						desc = L["If enabled will color durability text based on it's value."],
						get = function(info) return E.db.sle.dt.durability.gradient end,
						set = function(info, value) E.db.sle.dt.durability.gradient = value end,
					},
					threshold = {
						order = 3,
						type = "range",
						min = -1, max = 99, step = 1,
						name = L["Durability Threshold"],
						desc = L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"],
						get = function(info) return E.db.sle.dt.durability.threshold end,
						set = function(info, value) E.db.sle.dt.durability.threshold = value end,
					}
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)