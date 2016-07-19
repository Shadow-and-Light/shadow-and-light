local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Sk, QK = SLE:GetModules("Skins", "QuestKingSkinner")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.skins = {
		order = 30,
		type = "group",
		name = L["Skins"],
		childGroups = 'select',
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["SLE_SKINS_DESC"],
			},
			GoToSkins = {
				order = 2,
				type = "execute",
				name = L["ElvUI Skins"],
				func = function() SLE.ACD:SelectGroup("ElvUI", "skins") end,
			},
			objectiveTracker = {
				order = 10,
				type = "group",
				name = OBJECTIVES_TRACKER_LABEL,
				get = function(info) return E.private.sle.skins.objectiveTracker[ info[#info] ] end,
				set = function(info, value) E.private.sle.skins.objectiveTracker[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					space2 = {
						order = 3,
						type = "description",
						name = "",
					},
					texture = {
						order = 3,
						type = "select", dialogControl = "LSM30_Statusbar",
						name = L["Texture"],
						desc = L["Sets the texture for statusbars in quest tracker, e.g. bonus objectives/timers."],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					color = {
						type = 'color',
						order = 4,
						name = L["Statusbar Color"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or E.private.sle.skins.objectiveTracker.class or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
						get = function(info)
							local t = E.private.sle.skins.objectiveTracker[ info[#info] ]
							local d = V.sle.skins.objectiveTracker[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.private.sle.skins.objectiveTracker[ info[#info] ] = {}
							local t = E.private.sle.skins.objectiveTracker[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show("PRIVATE_RL")
						end,
					},
					class = {
						order = 5,
						type = "toggle",
						name = L["Class Colored Statusbars"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
					},
					space3 = {
						order = 6,
						type = "description",
						name = "",
					},
					underline = {
						order = 7,
						type = "toggle",
						name = L["Underline"],
						desc = L["Creates a cosmetic line under objective headers."],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or SLE._Compatibility["QuestKing"] end,
						get = function(info) return E.db.sle.skins.objectiveTracker[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.objectiveTracker[ info[#info] ] = value; Sk:Update_ObjectiveTrackerUnderlinesVisibility() end,
					},
					underlineColor = {
						type = 'color',
						order = 8,
						name = L["Underline Color"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline or E.db.sle.skins.objectiveTracker.underlineClass or SLE._Compatibility["QuestKing"] end,
						get = function(info)
							local t = E.db.sle.skins.objectiveTracker[ info[#info] ]
							local d = P.sle.skins.objectiveTracker[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.sle.skins.objectiveTracker[ info[#info] ] = {}
							local t = E.db.sle.skins.objectiveTracker[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							Sk:Update_ObjectiveTrackerUnderlinesColor()
						end,
					},
					underlineClass = {
						order = 9,
						type = "toggle",
						name = L["Class Colored Underline"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline or SLE._Compatibility["QuestKing"] end,
						get = function(info) return E.db.sle.skins.objectiveTracker[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.objectiveTracker[ info[#info] ] = value; Sk:Update_ObjectiveTrackerUnderlinesColor() end,
					},
					underlineHeight = {
						order = 10,
						type = 'range',
						name = L["Underline Height"],
						min = 1, max = 10, step = 1,
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker or SLE._Compatibility["QuestKing"] end,
					},
					space4 = {
						order = 11,
						type = "description",
						name = "",
					},
					space5 = {
						order = 12,
						type = "description",
						name = "",
					},
					colorHeader = {
						type = 'color',
						order = 13,
						name = L["Header Text Color"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or E.db.sle.skins.objectiveTracker.classHeader end,
						get = function(info)
							local t = E.db.sle.skins.objectiveTracker[ info[#info] ]
							local d = P.sle.skins.objectiveTracker[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.sle.skins.objectiveTracker[ info[#info] ] = {}
							local t = E.db.sle.skins.objectiveTracker[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							E:UpdateBlizzardFonts()
						end,
					},
					classHeader = {
						order = 14,
						type = "toggle",
						name = L["Class Colored Header Text"],
						get = function(info) return E.db.sle.skins.objectiveTracker[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.objectiveTracker[ info[#info] ] = value; E:UpdateBlizzardFonts() end,
					},
					-- QuestKing = {
						-- order = 50,
						-- type = "group",
						-- name = "QuestKing",
						-- guiInline = true,
						-- hidden = function() return not SLE._Compatibility["QuestKing"] end,
						-- disabled = function() return not E.private.sle.skins.QuestKing.enable end,
						-- get = function(info) return E.private.sle.skins.QuestKing[ info[#info] ] end,
						-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; _G["QuestKing"]:UpdateTrackerQuests() end,
						-- args = {
							-- info = {
								-- order = 1,
								-- type = "description",
								-- name = L["SLE_SKINS_QUESTKING_DESC"],
							-- },
							-- GoToOF = {
								-- order = 2,
								-- type = "execute",
								-- name = L["ElvUI Objective Tracker"],
								-- disabled = false,
								-- func = function() SLE.ACD:SelectGroup("ElvUI", "general", "objectiveFrame") end,
							-- },
							-- enable = {
								-- order = 2,
								-- type = "toggle",
								-- name = L["Enable"],
								-- disabled = false,
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							-- },
							-- tooltipAnchor = {
								-- order = 3,
								-- type = "select",
								-- name = L["Tooltip Anchor"],
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; end,
								-- values = {
									-- ["ANCHOR_BOTTOMLEFT"] = "ANCHOR_BOTTOMLEFT",
									-- ["ANCHOR_BOTTOMRIGHT"] = "ANCHOR_BOTTOMRIGHT",
									-- ["ANCHOR_CURSOR"] = "ANCHOR_CURSOR",
									-- ["ANCHOR_LEFT"] = "ANCHOR_LEFT",
									-- ["ANCHOR_NONE"] = "ANCHOR_NONE",
									-- ["ANCHOR_PRESERVE"] = "ANCHOR_PRESERVE",
									-- ["ANCHOR_RIGHT"] = "ANCHOR_RIGHT",
									-- ["ANCHOR_TOPLEFT"] = "ANCHOR_TOPLEFT",
									-- ["ANCHOR_TOPRIGHT"] = "ANCHOR_TOPRIGHT",
								-- },
							-- },
							-- tooltipScale = {
								-- order = 4,
								-- type = 'range',
								-- name = L["Tooltip Scale"],
								-- min = 0.3, max = 5, step = 0.01,
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; end,
							-- },
							-- trackerSize = {
								-- order = 5,
								-- type = 'range',
								-- name = L["Tracking Icon Size"],
								-- min = 8, max = 40, step = 1,
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value;  end,
							-- },
							-- trackerIcon = {
								-- order = 6, type = "select",
								-- name = L["Tracking Icon"],
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; end,
								-- values = {
									-- ["DEFAULT"] = DEFAULT..[[ |TInterface\Scenarios\ScenarioIcon-Combat:14:14:-1:0|t]],
									-- ["Skull"] = RAID_TARGET_8..[[ |TInterface\AddOns\ElvUI_SLE\media\textures\Skull:14:14:-1:0|t]],
									-- ["LFG"] = LFG_TITLE..[[ |TInterface\LFGFRAME\BattlenetWorking0:14:14:-1:0|t]],
									-- ["CUSTOM"] = L["Custom"],
								-- },
							-- },
							-- trackerIconCustom = {
								-- order = 7,
								-- type = 'input',
								-- width = 'full',
								-- name = L["Custom Texture"],
								-- set = function(info, value) E.private.sle.skins.QuestKing[ info[#info] ] = value; end,
							-- },
							-- QuestTypes = {
								-- order = 30,
								-- type = "group",
								-- name = L["Quest Type Indications"],
								-- guiInline = true,
								-- get = function(info, value) return E.private.sle.skins.QuestKing.questTypes[ info[#info] ] end,
								-- set = function(info, value) E.private.sle.skins.QuestKing.questTypes[ info[#info] ] = value; _G["QuestKing"]:UpdateTrackerQuests() end,
								-- args = {
									-- daily = {
										-- order = 1, type = "select",
										-- name = DAILY,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
											-- ["ICON"] = L["Icon"].." |T"..QK.Icons["Daily"]..":14|t",
										-- },
									-- },
									-- weekly = {
										-- order = 2, type = "select",
										-- name = WEEKLY,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
											-- ["ICON"] = L["Icon"].." |T"..QK.Icons["Weekly"]..":14|t",
										-- },
									-- },
									-- group = {
										-- order = 3, type = "select",
										-- name = GROUP,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
									-- raid = {
										-- order = 4, type = "select",
										-- name = RAID,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
									-- dungeon = {
										-- order = 5, type = "select",
										-- name = TRACKER_HEADER_DUNGEON,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
									-- heroic = {
										-- order = 6, type = "select",
										-- name = PLAYER_DIFFICULTY2,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
									-- legend = {
										-- order = 7, type = "select",
										-- name = ITEM_QUALITY5_DESC,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
									-- scenario = {
										-- order = 8, type = "select",
										-- name = TRACKER_HEADER_SCENARIO,
										-- values = {
											-- ["DEFAULT"] = DEFAULT,
											-- ["FULL"] = L["Full"],
										-- },
									-- },
								-- },
							-- },
							-- clickTemplate = {
								-- order = 50,
								-- type = "select",
								-- name = L["Clicks Registration"],
								-- desc = L["SLE_SKINS_QUESTKING_TEMPLATE_DESC"],
								-- set = function(info, value)
									-- E.private.sle.skins.QuestKing[ info[#info] ] = value;
								-- end,
								-- values = {
									-- ["QuestKing"] = "Quest King",
									-- ["Blizzlike"] = "Blizzlike",
								-- },
							-- },
						-- },
					-- },
				},
			},
			merchant = {
				order = 20,
				type = "group",
				name = L["Merchant Frame"],
				get = function(info) return E.private.sle.skins.merchant[ info[#info] ] end,
				set = function(info, value) E.private.sle.skins.merchant[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					subpages = {
						order = 2,
						type = 'range',
						name = L["Subpages"],
						desc = L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."],
						min = 2, max = 5, step = 1,
						disabled = function() return not E.private.sle.skins.merchant.enable end,
					},
				},
			},
			petbattles = {
				order = 30,
				type = "group",
				name = L["Pet Battles skinning"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Make some elements of pet battles movable via toggle anchors."],
						get = function(info) return E.private.sle.skins.petbattles.enable end,
						set = function(info, value) E.private.sle.skins.petbattles.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)