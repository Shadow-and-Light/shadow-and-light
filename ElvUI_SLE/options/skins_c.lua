local SLE, T, E, L, V, P = unpack(select(2, ...))
local Sk = SLE:GetModule('Skins')
local B = SLE:GetModule('Blizzard')

local IsAddOnLoaded = IsAddOnLoaded

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.skins = {
		order = 30,
		type = 'group',
		name = L["Skins"],
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["Skins"], 1),
			desc = ACH:Description(L["SLE_SKINS_DESC"], 2),
			GoToSkins = {
				order = 2,
				type = 'execute',
				name = L["ElvUI Skins"],
				func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'skins') end,
			},
			objectiveTracker = {
				order = 10,
				type = 'group',
				name = OBJECTIVES_TRACKER_LABEL,
				get = function(info) return E.private.sle.skins.objectiveTracker[info[#info]] end,
				set = function(info, value) E.private.sle.skins.objectiveTracker[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
					},
					statusbars = {
						order = 2,
						type = 'group',
						name = L["Statusbars"],
						guiInline = true,
						args = {
							texture = {
								order = 1,
								type = 'select',
								name = L["Texture"],
								desc = L["Sets the texture for statusbars in quest tracker, e.g. bonus objectives/timers."],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
								dialogControl = 'LSM30_Statusbar',
								values = AceGUIWidgetLSMlists.statusbar,
							},
							color = {
								type = 'color',
								order = 2,
								name = L["Statusbar Color"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or E.private.sle.skins.objectiveTracker.class or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
								get = function(info)
									local t = E.private.sle.skins.objectiveTracker[info[#info]]
									local d = V.sle.skins.objectiveTracker[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
								end,
								set = function(info, r, g, b, a)
									E.private.sle.skins.objectiveTracker[info[#info]] = {}
									local t = E.private.sle.skins.objectiveTracker[info[#info]]
									t.r, t.g, t.b, t.a = r, g, b, a
									E:StaticPopup_Show('PRIVATE_RL')
								end,
							},
							class = {
								order = 3,
								type = 'toggle',
								name = L["Class Colored Statusbars"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
							},
						},
					},
					underline = {
						order = 3,
						type = 'group',
						guiInline = true,
						name = L["Underline"],
						args = {
							underline = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								desc = L["Creates a cosmetic line under objective headers."],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable end,
								get = function(info) return E.db.sle.skins.objectiveTracker[info[#info]] end,
								set = function(info, value) E.db.sle.skins.objectiveTracker[info[#info]] = value; Sk:Update_ObjectiveTrackerUnderlinesVisibility() end,
							},
							underlineColor = {
								order = 2,
								type = 'color',
								name = L["Underline Color"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline or E.db.sle.skins.objectiveTracker.underlineClass  end,
								get = function(info)
									local t = E.db.sle.skins.objectiveTracker[info[#info]]
									local d = P.sle.skins.objectiveTracker[info[#info]]
									return t.r, t.g, t.b, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									E.db.sle.skins.objectiveTracker[info[#info]] = {}
									local t = E.db.sle.skins.objectiveTracker[info[#info]]
									t.r, t.g, t.b = r, g, b
									Sk:Update_ObjectiveTrackerUnderlinesColor()
								end,
							},
							underlineClass = {
								order = 3,
								type = 'toggle',
								name = L["Class Colored Underline"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.db.sle.skins.objectiveTracker.underline end,
								get = function(info) return E.db.sle.skins.objectiveTracker[info[#info]] end,
								set = function(info, value) E.db.sle.skins.objectiveTracker[info[#info]] = value; Sk:Update_ObjectiveTrackerUnderlinesColor() end,
							},
							underlineHeight = {
								order = 4,
								type = 'range',
								name = L["Underline Height"],
								min = 1, max = 10, step = 1,
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
							},
						},
					},
					header = {
						order = 5,
						type = 'group',
						name = L["Headers"],
						guiInline = true,
						args = {
							colorHeader = {
								order = 1,
								type = 'color',
								name = L["Header Text Color"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or E.db.sle.skins.objectiveTracker.classHeader end,
								get = function(info)
									local t = E.db.sle.skins.objectiveTracker[info[#info]]
									local d = P.sle.skins.objectiveTracker[info[#info]]
									return t.r, t.g, t.b, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									E.db.sle.skins.objectiveTracker[info[#info]] = {}
									local t = E.db.sle.skins.objectiveTracker[info[#info]]
									t.r, t.g, t.b = r, g, b
									E:UpdateBlizzardFonts()
								end,
							},
							classHeader = {
								order = 1,
								type = 'toggle',
								name = L["Class Colored Header Text"],
								get = function(info) return E.db.sle.skins.objectiveTracker[info[#info]] end,
								set = function(info, value) E.db.sle.skins.objectiveTracker[info[#info]] = value; E:UpdateBlizzardFonts() end,
							},
							scenarioBG = {
								order = 3,
								type = 'toggle',
								name = L["Stage Background"],
							},
							BGbackdrop = {
								order = 4,
								type = 'toggle',
								name = L["Skinned Background"],
								disabled = function() return E.private.sle.skins.objectiveTracker.scenarioBG or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
							},
							skinnedTextureLogo = {
								order = 5,
								type = 'select',
								name = L["Texture"],
								desc = L["Sets the texture for statusbars in quest tracker, e.g. bonus objectives/timers."],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker or not E.private.sle.skins.objectiveTracker.BGbackdrop or E.private.sle.skins.objectiveTracker.scenarioBG end,
								set = function(info, value)
									E.private.sle.skins.objectiveTracker[info[#info]] = value;
									Sk:UpdateObjectiveFrameLogos()
								end,
								values = {
									["NONE"] = NONE,
									["SLE"] = [[|TInterface\AddOns\ElvUI_SLE\media\textures\chat\Logo:16:16|t S&L]],
									["CUSTOM"] = L["Custom"],
								},
							},
							customTextureLogo = {
								order = 6,
								type = 'input',
								name = L["Custom Texture"],
								desc = L["Set the texture to use in this frame. Requirements are the same as the chat textures."],
								width = 'full',
								hidden = function() return E.private.sle.skins.objectiveTracker.skinnedTextureLogo ~= 'CUSTOM' end,
								set = function(info, value)
									E.private.sle.skins.objectiveTracker[info[#info]] = value;
									Sk:UpdateObjectiveFrameLogos()
								end,
							},
						},
					},
					keyTimers = {
						order = 6,
						type = 'group',
						name = L["Key Timers"],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								desc = L["Enables timers for 2 & 3 chest times in M+"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable end,
								get = function(info) return E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] end,
								set = function(info, value) E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
							},
							showMarks = {
								order = 2,
								type = 'toggle',
								name = L["Show Marks"],
								desc = L["Show goal time markers on the timer bar"],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.sle.skins.objectiveTracker.keyTimers.enable end,
								get = function(info) return E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] end,
								set = function(info, value) E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] = value end,
							},
							showBothTimers = {
								order = 3,
								type = 'toggle',
								name = L["Show Both Timers"],
								desc = L["Show timers for both milestones at the same time if available."],
								disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.sle.skins.objectiveTracker.keyTimers.enable end,
								get = function(info) return E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] end,
								set = function(info, value) E.private.sle.skins.objectiveTracker.keyTimers[info[#info]] = value; end,
							},
						},
					},
				},
			},
			merchant = {
				order = 20,
				type = 'group',
				name = L["Merchant Frame"],
				get = function(info) return E.private.sle.skins.merchant[info[#info]] end,
				set = function(info, value) E.private.sle.skins.merchant[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
					},
					subpages = {
						order = 2,
						type = 'range',
						name = L["Subpages"],
						desc = L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."],
						min = 2, max = 5, step = 1,
						disabled = function() return not E.private.sle.skins.merchant.enable or E.private.sle.skins.merchant.style ~= 'Default' end,
					},
					style = {
						order = 3,
						type = 'select',
						name = L["Style"],
						values = {
							["Default"] = DEFAULT,
							["List"] = L["As List"],
						},
					},
					listFonts = {
						order = 4,
						type = 'group',
						name = L["List Style Fonts"],
						guiInline = true,
						disabled = function() return E.private.sle.skins.merchant.style ~= 'List' end,
						get = function(info) return E.db.sle.skins.merchant.list[info[#info]] end,
						set = function(info, value) E.db.sle.skins.merchant.list[info[#info]] = value; Sk:Media() end,
						args = {
							nameFont = {
								order = 1,
								type = 'select',
								name = L["Item Name Font"],
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
							},
							nameSize = {
								order = 2,
								type = 'range',
								name = L["Item Name Size"],
								min = 8, max = 32, step = 1,
							},
							nameOutline = {
								order = 3,
								type = 'select',
								name = L["Item Name Outline"],
								values = T.Values.FontFlags,
							},
							subFont = {
								order = 4,
								type = 'select',
								name = L["Item Info Font"],
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
							},
							subSize = {
								order = 5,
								type = 'range',
								name = L["Item Info Size"],
								min = 8, max = 32, step = 1,
							},
							subOutline = {
								order = 6,
								type = 'select',
								name = L["Item Info Outline"],
								values = T.Values.FontFlags,
							},
						}
					},
				},
			},
			petbattles = {
				order = 30,
				type = 'group',
				name = L["Pet Battles skinning"],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Make some elements of pet battles movable via toggle anchors."],
						get = function(info) return E.private.sle.skins.petbattles[info[#info]] end,
						set = function(info, value) E.private.sle.skins.petbattles[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
				},
			},
			blizzardframes = {
				order = 40,
				type = 'group',
				name = 'Blizzard',
				args = {
					talkinghead = {
						order = 1,
						type = 'group',
						name = L["Talking Head Frame"],
						args = {
							hide = {
								order = 1,
								type = 'toggle',
								name = HIDE,
								desc = L["Hide the talking head frame at the top center of the screen."],
								get = function(info) return E.db.sle.skins.talkinghead[info[#info]] end,
								set = function(info, value) E.db.sle.skins.talkinghead[info[#info]] = value; B:SLETalkingHead() end,
							},
						},
					},
				},
			},
		},
	}

	if IsAddOnLoaded('QuestGuru') then
		E.Options.args.sle.args.skins.args.QuestGuru = {
			order = 12,
			type = 'group',
			name = 'QuestGuru',
			get = function(info) return E.private.sle.skins.questguru[info[#info]] end,
			set = function(info, value) E.private.sle.skins.questguru[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
				},
				removeParchment = {
					order = 1,
					type = 'toggle',
					name = L["Remove Parchment"],
				},
			},
		}
	end
end

tinsert(SLE.Configs, configTable)
