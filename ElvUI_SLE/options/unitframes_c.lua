local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local UF = E:GetModule('UnitFrames');
local SUF = SLE:GetModule("UnitFrames")
local texPath = [[Interface\AddOns\ElvUI_SLE\media\textures\role\]]
local texPathE = [[Interface\AddOns\ElvUI\media\textures\]]

local function configTable()
	if not SLE.initialized then return end
	local positionValues = {
		TOPLEFT = 'TOPLEFT',
		LEFT = 'LEFT',
		BOTTOMLEFT = 'BOTTOMLEFT',
		RIGHT = 'RIGHT',
		TOPRIGHT = 'TOPRIGHT',
		BOTTOMRIGHT = 'BOTTOMRIGHT',
		CENTER = 'CENTER',
		TOP = 'TOP',
		BOTTOM = 'BOTTOM',
	};
	
	local function CreateOfflineConfig(group)
		local config = {
			order = 5,
			type = "group",
			guiInline = true,
			name = L["Offline Indicator"],
			get = function(info) return E.db.sle.unitframes.unit[group].offline[ info[#info] ] end,
			set = function(info, value) E.db.sle.unitframes.unit[group].offline[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup(group) end,
			args = {
				enable = { order = 1, type = "toggle", name = L["Enable"] },
				size = { order = 2, type = 'range', name = L["Size"], min = 10, max = 120, step = 1 },
				xOffset = { order = 3, type = 'range', name = L["X-Offset"], min = -600, max = 600, step = 1 },
				yOffset = { order = 4, type = 'range', name = L["Y-Offset"], min = -600, max = 600, step = 1 },
				texture = {
					order = 5,
					type = "select",
					name = L["Texture"],
					values = {
						["ALERT"] = [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:14|t]],
						["ARTHAS"] =[[|TInterface\LFGFRAME\UI-LFR-PORTRAIT:14|t]],
						["SKULL"] = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
						["PASS"] = [[|TInterface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent:14|t]],
						["NOTREADY"] = [[|TInterface\RAIDFRAME\ReadyCheck-NotReady:14|t]],
						["CUSTOM"] = L["Custom"],
					},
				},
				CustomTexture = {
					order = 6,
					type = 'input',
					width = 'full',
					name = L["Custom Texture"],
					disabled = function() return E.db.sle.unitframes.unit[group].offline.texture ~= "CUSTOM" end,
				},
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.unitframes = {
		type = "group",
		name = L["UnitFrames"],
		order = 22,
		childGroups = "select",
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."],
			},
			Reset = {
				order = 2,
				type = 'execute',
				name = L["Restore Defaults"],
				desc = L["Reset these options to defaults"],
				func = function() SLE:Reset("unitframes") end,
			},
			roleicons = {
				order = 3,
				type = "select",
				name = L["LFG Icons"],
				desc = L["Choose what icon set will unitframes and chat use."],
				get = function(info) return E.db.sle.unitframes.roleicons end,
				set = function(info, value) E.db.sle.unitframes.roleicons = value; E:GetModule('Chat'):CheckLFGRoles(); UF:UpdateAllHeaders() end,
				values = {
					["ElvUI"] = "ElvUI ".."|T"..texPathE.."tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."dps:15:15:0:0:64:64:2:56:2:56|t ",
					["SupervillainUI"] = "Supervillain UI ".."|T"..texPath.."svui-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-dps:15:15:0:0:64:64:2:56:2:56|t ",
					["Blizzard"] = "Blizzard ".."|T"..texPath.."blizz-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-dps:15:15:0:0:64:64:2:56:2:56|t ",
					["MiirGui"] = "MiirGui ".."|T"..texPath.."mg-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-dps:15:15:0:0:64:64:2:56:2:56|t ",
				},
			},
			player = {
				order = 10,
				type = "group",
				name = L["Player Frame"],
				args = {
					higherPortrait = {
						order = 1, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.player[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.player[ info[#info] ] = value; UF:CreateAndUpdateUF('player'); end,
					},
					portraitAlpha = {
						order = 2, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.player[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.player[ info[#info] ] = value; UF:CreateAndUpdateUF('player'); end,
					},
					combaticon = {
						order = 3,
						type = "group",
						name = L["Combat Icon"],
						guiInline = true,
						get = function(info) return E.db.sle.unitframes.unit.player.combatico[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.player.combatico[ info[#info] ] = value; ElvUF_Player.Combat:PostUpdate(); SUF:TestCombat() end,
						args = {
							xoffset = { order = 1, type = 'range', name = L["X-Offset"], min = -300, max = 300, step = 1 },
							yoffset = { order = 2, type = 'range', name = L["Y-Offset"], min = -150, max = 150, step = 1 },
							size = { order = 3, type = 'range', name = L["Size"], min = 10, max = 60, step = 1 },
							red = { order = 4, type = "toggle", name = L["Red Icon"] },
							texture = {
								order = 5,
								type = "select",
								name = L["Texture"],
								values = {
									["DEFAULT"] = DEFAULT,
									["PLATINUM"] = [[|TInterface\Challenges\ChallengeMode_Medal_Platinum:14|t]],
									["ATTACK"] = [[|TInterface\CURSOR\Attack:14|t]],
									["ALERT"] = [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:14|t]],
									["SKULL"] = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
									["ARTHAS"] =[[|TInterface\LFGFRAME\UI-LFR-PORTRAIT:14|t]],
									["SVUI"] = "Supervillian UI",
								},
							},
						},
					},
					rested = {
						order = 4,
						type = "group",
						name = L["Rest Icon"],
						guiInline = true,
						get = function(info) return E.db.sle.unitframes.unit.player.rested[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.player.rested[ info[#info] ] = value; UF:Configure_RestingIndicator(_G["ElvUF_Player"]) end,
						args = {
							xoffset = { order = 1, type = 'range', name = L["X-Offset"], min = -300, max = 300, step = 1 },
							yoffset = { order = 2, type = 'range', name = L["Y-Offset"], min = -150, max = 150, step = 1 },
							size = { order = 3, type = 'range', name = L["Size"], min = 10, max = 60, step = 1 },
							texture = {
								order = 5,
								type = "select",
								name = L["Texture"],
								values = {
									["DEFAULT"] = DEFAULT,
									["SVUI"] = "Supervillian UI",
									["CUSTOM"] = L["Custom"],
								},
							},
							customTexture = {
								order = 6,
								type = 'input',
								width = 'full',
								name = L["Custom Texture"],
								disabled = function() return E.db.sle.unitframes.unit.player.rested.texture ~= "CUSTOM" end,
							},
						},
					},
				},
			},
			target = {
				order = 11,
				type = "group",
				name = L["Target Frame"],
				args = {
					higherPortrait = {
						order = 1, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.target[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.target[ info[#info] ] = value; UF:CreateAndUpdateUF('target'); end,
					},
					portraitAlpha = {
						order = 2, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.target[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.target[ info[#info] ] = value; UF:CreateAndUpdateUF('target'); end,
					},
				},
			},
			focus = {
				order = 12,
				type = "group",
				name = L["Focus Frame"],
				args = {
					higherPortrait = {
						order = 1, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.focus[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.focus[ info[#info] ] = value; UF:CreateAndUpdateUF('focus'); end,
					},
					portraitAlpha = {
						order = 2, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.focus[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.focus[ info[#info] ] = value; UF:CreateAndUpdateUF('focus'); end,
					},
				},
			},
			party = {
				order = 20,
				type = "group",
				name = L["Party Frames"],
				args = {
					configureToggle = {
						order = 1,
						type = 'execute',
						name = L["Display Frames"],
						func = function()
							UF:HeaderConfig(ElvUF_Party, ElvUF_Party.forceShow ~= true or nil)
						end,
					},
					higherPortrait = {
						order = 2, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.party[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.party[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('party') end,
					},
					portraitAlpha = {
						order = 3, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.party[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.party[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('party') end,
					},
					offline = CreateOfflineConfig("party")
				},
			},
			raid = {
				order = 21,
				type = "group",
				name = L["Raid Frames"],
				args = {
					configureToggle = {
						order = 1,
						type = 'execute',
						name = L["Display Frames"],
						func = function()
							UF:HeaderConfig(_G['ElvUF_Raid'], _G['ElvUF_Raid'].forceShow ~= true or nil)
						end,
					},
					higherPortrait = {
						order = 2, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.raid[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.raid[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid') end,
					},
					portraitAlpha = {
						order = 3, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.raid[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.raid[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid') end,
					},
					offline = CreateOfflineConfig("raid")
				},
			},
			raid40 = {
				order = 22,
				type = "group",
				name = L["Raid-40 Frames"],
				args = {
					configureToggle = {
						order = 1,
						type = 'execute',
						name = L["Display Frames"],
						func = function()
							UF:HeaderConfig(_G['ElvUF_Raid40'], _G['ElvUF_Raid40'].forceShow ~= true or nil)
						end,
					},
					higherPortrait = {
						order = 2, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.raid40[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.raid40[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid40') end,
					},
					portraitAlpha = {
						order = 3, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.raid40[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.raid40[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid40') end,
					},
					offline = CreateOfflineConfig("raid40")
				},
			},
			boss = {
				order = 23,
				type = "group",
				name = L["Boss Frames"],
				args = {
					higherPortrait = {
						order = 1, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.boss[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.boss[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('boss') end,
					},
					portraitAlpha = {
						order = 2, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.boss[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.boss[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('boss') end,
					},
				},
			},
			arena = {
				order = 24,
				type = "group",
				name = L["Arena Frames"],
				args = {
					higherPortrait = {
						order = 1, type = "toggle",
						name = L["Higher Overlay Portrait"],
						desc = L["Makes frame portrait visible regardles of health level when overlay portrait is set."],
						get = function(info) return E.db.sle.unitframes.unit.arena[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.arena[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('arena') end,
					},
					portraitAlpha = {
						order = 2, type = 'range',
						name = L["Overlay Portrait Alpha"],
						isPercent = true,
						 min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.unitframes.unit.arena[ info[#info] ] end,
						set = function(info, value) E.db.sle.unitframes.unit.arena[ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('arena') end,
					},
				},
			},
			statusbars = {
				order = 50,
				type = "group",
				name = L["Statusbars"],
				get = function(info) return E.db.sle.unitframes.statusTextures[info[#info]] end,
				set = function(info, value) E.db.sle.unitframes.statusTextures[info[#info]] = value; SUF:BuildStatusTable(); SUF:UpdateStatusBars() end,
				args = {
					power = {
						order = 1,
						type = "toggle",
						name = L["Power"],
						disabled = function() return SLE._Compatibility["ElvUI_CustomTweaks"] end,
						get = function(info) return E.private.sle.unitframe.statusbarTextures.power end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures.power = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					powerTexture = {
						order = 2,
						type = "select", dialogControl = "LSM30_Statusbar",
						name = L["Power Texture"],
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.power or SLE._Compatibility["ElvUI_CustomTweaks"] end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					space = { order = 3, type = "description", name = "" },
					cast = {
						order = 4,
						type = "toggle",
						name = L["Castbar"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures.cast end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures.cast = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					castTexture = {
						order = 5,
						type = "select", dialogControl = "LSM30_Statusbar",
						name = L["Castbar Texture"],
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.cast end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					space2 = { order = 6, type = "description", name = "" },
					aura = {
						order = 7,
						type = "toggle",
						name = L["Aura Bars"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures.aura end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures.aura = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					auraTexture = {
						order = 8,
						type = "select", dialogControl = "LSM30_Statusbar",
						name = L["Aura Bars Texture"],
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.aura end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					space3 = { order = 9, type = "description", name = "" },
					class = {
						order = 10,
						type = "toggle",
						name = L["Classbar"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures.class end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures.class = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					classTexture = {
						order = 11,
						type = "select", dialogControl = "LSM30_Statusbar",
						name = L["Classbar Texture"],
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.class end,
						set = function(info, value) E.db.sle.unitframes.statusTextures[info[#info]] = value; UF:CreateAndUpdateUF('player') end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					space4 = { order = 12, type = "description", name = "" },
					resizePrediction = {
						order = 13,
						type = "toggle",
						name = L["Resize Health Prediction"],
						desc = L["Slightly chages size of health prediction bars."],
						get = function(info) return E.private.sle.unitframe.resizeHealthPrediction end,
						set = function(info, value) E.private.sle.unitframe.resizeHealthPrediction = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)