local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Sk = SLE:GetModule("Skins")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.skins = {
		order = 30,
		type = "group",
		name = L["Skins"],
		childGroups = 'tab',
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
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable end,
						get = function(info) return E.db.sle.skins.objectiveTracker[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.objectiveTracker[ info[#info] ] = value; Sk:Update_ObjectiveTrackerUnderlinesVisibility() end,
					},
					underlineColor = {
						type = 'color',
						order = 8,
						name = L["Underline Color"],
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline or E.db.sle.skins.objectiveTracker.underlineClass  end,
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
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline end,
						get = function(info) return E.db.sle.skins.objectiveTracker[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.objectiveTracker[ info[#info] ] = value; Sk:Update_ObjectiveTrackerUnderlinesColor() end,
					},
					underlineHeight = {
						order = 10,
						type = 'range',
						name = L["Underline Height"],
						min = 1, max = 10, step = 1,
						disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
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
					scenarioBG = {
						order = 15,
						type = "toggle",
						name = L["Stage Background"],
					},
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
						disabled = function() return not E.private.sle.skins.merchant.enable or E.private.sle.skins.merchant.style ~= "Default" end,
					},
					style = {
						order = 3, type = "select",
						name = L["Style"],
						values = {
							["Default"] = DEFAULT,
							["List"] = L["As List"],
						},
					},
					listFonts = {
						order = 4,
						name = L["List Style Fonts"],
						type = "group",
						guiInline = true,
						disabled = function() return E.private.sle.skins.merchant.style ~= "List" end,
						get = function(info) return E.db.sle.skins.merchant.list[ info[#info] ] end,
						set = function(info, value) E.db.sle.skins.merchant.list[ info[#info] ] = value; Sk:Media() end,
						args = {
							nameFont = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Item Name Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							nameSize = {
								order = 2,
								name = L["Item Name Size"],
								type = "range",
								min = 8, max = 32, step = 1,
							},
							nameOutline = {
								order = 3,
								name = L["Item Name Outline"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
							subFont = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 4,
								name = L["Item Info Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							subSize = {
								order = 5,
								name = L["Item Info Size"],
								type = "range",
								min = 8, max = 32, step = 1,
							},
							subOutline = {
								order = 6,
								name = L["Item Info Outline"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						}
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
			blizzardframes = {
				order = 40,
				type = "group",
				name = "Blizzard",
				args = {
					talkinghead = {
						order = 1,
						name = L["Talking Head Frame"],
						type = "group",
						args = {
							hide = {
								order = 1,
								type = "toggle",
								name = HIDE,
								desc = L["Hide the talking head frame at the top center of the screen."],
								get = function(info) return E.db.sle.skins.talkinghead.hide end,
								set = function(info, value) E.db.sle.skins.talkinghead.hide = value; E:StaticPopup_Show("CONFIG_RL") end,
							},
						},
					},
				},
			},
		},
	}

	if T.IsAddOnLoaded("QuestGuru") then
		E.Options.args.sle.args.skins.args.QuestGuru = {
			order = 12,
			type = "group",
			name = "QuestGuru",
			get = function(info) return E.private.sle.skins.questguru[ info[#info] ] end,
			set = function(info, value) E.private.sle.skins.questguru[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				enable = {
					name = L["Enable"],
					order = 1,
					type = "toggle",
				},
				removeParchment = {
					order = 1,
					type = "toggle",
					name = L["Remove Parchment"],
				},
			},
		}
	end
end

T.tinsert(SLE.Configs, configTable)
