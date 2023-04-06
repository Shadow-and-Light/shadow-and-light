local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local ENH = SLE.EnhancedShadows
local SUF = SLE.UnitFrames
local DT = E.DataTexts
local UF = E.UnitFrames

-- GLOBALS: MICRO_BUTTONS

local _G = _G
local unpack = unpack
local format, gsub, strlower = format, gsub, strlower
local tinsert, pairs = tinsert, pairs
local COLOR = COLOR

function ENH:UpdateDatatextOptions()
	ENH:UpdateDefaults()
	-- for name, frame in next, DT.db.panels do
	for name, frame in next, DT.RegisteredPanels do
		E.Options.args.sle.args.modules.args.shadows.args.datatexts.args[name] = {
			order = 1,
			type = 'group',
			name = function() return format(E.db.datatexts.panels[name].enable and '%s' or '|cffFF3333%s|r', name) end,
			get = function(info) return E.db.sle.shadows.datatexts.panels[name][info[#info]] end,
			set = function(info, value) E.db.sle.shadows.datatexts.panels[name][info[#info]] = value; ENH:ToggleDTShadows() end,
			args = {
				backdrop = {
					order = 2,
					type = 'toggle',
					name = L["Panel"],
					desc = L["Enables a shadow for the panel or backdrop of this frame."],
					disabled = function() return not E.db.datatexts.panels[name].enable end,
				},
				size = {
					order = 3,
					type = 'range',
					name = L["Size"],
					min = 2, max = 10, step = 1,
					disabled = function() return not E.db.datatexts.panels[name].enable end,
					set = function(info, value)
						E.db.sle.shadows.datatexts.panels[name][info[#info]] = value
						if ENH.DummyPanels[name] and ENH.DummyPanels[name].enhshadow then
							frame = ENH.DummyPanels[name]
						end
						frame.enhshadow.size = value
						ENH:UpdateShadow(frame.enhshadow)
					end,
				},
			},
		}
		if name == 'LeftChatDataPanel' or name == 'RightChatDataPanel' then
			E.Options.args.sle.args.modules.args.shadows.args.datatexts.args[name].args.backdrop.set = function(info, value)
				E.db.sle.shadows.datatexts.panels[name][info[#info]] = value
				if ENH.DummyPanels[name] and ENH.DummyPanels[name].enhshadow then
					frame = ENH.DummyPanels[name]
				end
				frame.enhshadow.backdrop = value
				ENH:UpdateShadow(frame.enhshadow)
				ENH:UpdateShadow(_G.LeftChatPanel.enhshadow)
				ENH:UpdateShadow(_G.RightChatPanel.enhshadow)
				ENH:ToggleDTShadows()
			end
		end
	end
end

local function updateFrame(frame, size, backdrop)
	if not frame or not frame.enhshadow then return end
	if size then frame.enhshadow.size = size end
	if backdrop then frame.enhshadow.backdrop = backdrop end
	ENH:UpdateShadow(frame.enhshadow)
end

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.shadows = {
		order = 1,
		type = 'group',
		name = L["Enhanced Shadows"],
		childGroups = 'tab',
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"],
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
			},
			shadowcolor = {
				order = 2,
				type = 'color',
				hasAlpha = false,
				name = COLOR,
				disabled = function() return not E.private.sle.module.shadows.enable end,
				get = function(info)
					local t = E.db.sle.shadows[info[#info]]
					local d = P.sle.shadows[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = E.db.sle.shadows[info[#info]]
					t.r, t.g, t.b = r, g, b
					SLE:UpdateMedia()
					ENH:UpdateShadows()
					SUF:UpdateShadows()
				end,
			},
			general = {
				order = 1,
				type = 'group',
				name = L["General"],
				disabled = function() return not E.private.sle.module.shadows.enable end,
				args = {
					chat = {
						order = 1,
						type = 'group',
						-- name = L["Chat"],
						name = function() return format(E.db.chat.panelBackdrop ~= 'HIDEBOTH' and '%s' or '|cffFF3333%s|r', L["Chat"]) end,
						-- disabled = function() return not (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') end,
						get = function(info) return E.db.sle.shadows.chat[info[#info-1]][info[#info]] end,
						args = {
							elvconfig = {
								order = 0,
								type = 'execute',
								name = 'ElvUI: '..L["Chat"],
								width = 'full',
								func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'chat', 'panels') end,
							},
							LeftChatPanel = {
								order = 1,
								type = 'group',
								name = '',
								guiInline = true,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Left Chat"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										disabled = function() return not (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') end,
										-- disabled = function() return not (E.db.chat.panelBackdrop ~= 'HIDEBOTH') end,
										set = function(info, value)
											E.db.sle.shadows.chat.LeftChatPanel[info[#info]] = value
											updateFrame(_G.LeftChatPanel, nil, value)
											ENH:UpdateShadow(ENH.DummyPanels.LeftChatDataPanel.enhshadow)
											ENH:ToggleCHShadows()
										end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.sle.shadows.chat.LeftChatPanel.backdrop or not (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') end,
										set = function(info, value) E.db.sle.shadows.chat.LeftChatPanel[info[#info]] = value; updateFrame(_G.LeftChatPanel, value) end,
									},
								},
							},
							RightChatPanel = {
								order = 2,
								type = 'group',
								name = '',
								guiInline = true,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Right Chat"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										disabled = function() return not (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') end,
										set = function(info, value)
											E.db.sle.shadows.chat.RightChatPanel[info[#info]] = value
											updateFrame(_G.RightChatPanel, nil, value)
											ENH:UpdateShadow(ENH.DummyPanels.RightChatDataPanel.enhshadow)
											ENH:ToggleCHShadows()
										end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.sle.shadows.chat.RightChatPanel.backdrop end,
										set = function(info, value) E.db.sle.shadows.chat.RightChatPanel[info[#info]] = value; updateFrame(_G.RightChatPanel, value) end,
									},
								},
							},
						},
					},
					minimap = { --* Minimap config looks good
						order = 1,
						type = 'group',
						name = function() return format(E.private.general.minimap.enable and '%s' or '|cffFF3333%s|r', L["Minimap"]) end,
						args = {
							elvconfig = {
								order = 0,
								type = 'execute',
								name = 'ElvUI: '..L["Minimap"],
								width = 'full',
								func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'maps', 'minimap') end,
							},
							minimap = {
								order = 1,
								type = 'group',
								name = '',
								guiInline = true,
								get = function(info) return E.db.sle.shadows.minimap[info[#info]] end,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Minimap"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										disabled = function() return not E.private.general.minimap.enable end,
										set = function(info, value) E.db.sle.shadows.minimap[info[#info]] = value; ENH:HandleMinimap() end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.private.general.minimap.enable or not E.db.sle.shadows.minimap.backdrop end,
										set = function(info, value)
											E.db.sle.shadows.minimap[info[#info]] = value
											updateFrame(_G.ElvUI_MinimapHolder, value)
											updateFrame(ENH.DummyPanels.Minimap, value)
										end,
									},
								},
							},
						},
					},
					objectiveframe = {
						order = 1,
						type = 'group',
						name = L["Objective Frame"],
						args = {
							elvconfig = {
								order = 0,
								type = 'execute',
								name = 'ElvUI: '..L["Objective Frame"],
								width = 'full',
								func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'general', 'blizzUIImprovements') end,
							},
							objectiveframe = {
								order = 2,
								type = 'group',
								name = L["Objective Frame"],
								guiInline = true,
								get = function(info) return E.db.sle.shadows.objectiveframe[info[#info]] end,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Backdrop"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										set = function(info, value) E.db.sle.shadows.objectiveframe[info[#info]] = value; ENH:HandleObjectiveFrame() end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.sle.shadows.objectiveframe.backdrop end,
										set = function(info, value)
											E.db.sle.shadows.objectiveframe[info[#info]] = value
											if _G.ScenarioStageBlock_SLE_Block then
												updateFrame(_G.ScenarioStageBlock_SLE_Block, value)
											end
										end,
									},
								},
							},
							torghastPowers = {
								order = 2,
								type = 'group',
								name = L["Torghast Powers Bar"],
								guiInline = true,
								get = function(info) return E.db.sle.shadows.torghastPowers[info[#info]] end,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Backdrop"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										set = function(info, value) E.db.sle.shadows.torghastPowers[info[#info]] = value; ENH:HandleObjectiveFrame() end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.sle.shadows.torghastPowers.backdrop end,
										set = function(info, value)
											E.db.sle.shadows.torghastPowers[info[#info]] = value
											if _G.ScenarioBlocksFrame.MawBuffsBlock.SLE_Block then
												updateFrame(_G.ScenarioBlocksFrame.MawBuffsBlock.SLE_Block, value)
											end
											if _G.ScenarioBlocksFrame.MawBuffsBlock.Container.List then
												updateFrame(_G.ScenarioBlocksFrame.MawBuffsBlock.Container.List, value)
											end
										end,
									},
								},
							},
						},
					},
					panels = {
						order = 1,
						type = 'group',
						name = function() return format((E.db.general.bottomPanel or E.db.general.topPanel) and '%s' or '|cffFF3333%s|r', L["Panels"]) end,
						args = {
							elvconfig = {
								order = 0,
								type = 'execute',
								name = 'ElvUI: '..L["Panels"],
								width = 'full',
								func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'general', 'general') end,
							},
							bottomPanel = {
								order = 1,
								type = 'group',
								name = '',
								guiInline = true,
								get = function(info) return E.db.sle.shadows.general.bottomPanel[info[#info]] end,
								set = function(info, value) E.db.sle.shadows.general.bottomPanel[info[#info]] = value; ENH:HandleElvUIPanels() end,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Bottom Panel"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										disabled = function() return not E.db.general.bottomPanel end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.general.bottomPanel or not E.db.sle.shadows.general.bottomPanel.backdrop end,
										set = function(info, value)
											E.db.sle.shadows.general.bottomPanel[info[#info]] = value
											updateFrame(_G.ElvUI_BottomPanel, value)
											-- local frame = _G.ElvUI_BottomPanel
											-- if frame and frame.enhshadow then
											-- 	frame.enhshadow.size = value
											-- 	ENH:UpdateShadow(frame.enhshadow)
											-- end
										end,
										-- get = function(info) return E.db.sle.shadows.minimap[info[#info]] end,
										-- set = function(info, value)
										-- 	E.db.sle.shadows.minimap[info[#info]] = value

										-- 	_G.ElvUI_MinimapHolder.enhshadow.size = value
										-- 	ENH:UpdateShadow(_G.ElvUI_MinimapHolder.enhshadow)
										-- 	ENH.DummyPanels.Minimap.enhshadow.size = value
										-- 	ENH:UpdateShadow(ENH.DummyPanels.Minimap.enhshadow)
										-- end,
									},
								},
							},
							topPanel = {
								order = 1,
								type = 'group',
								name = '',
								guiInline = true,
								get = function(info) return E.db.sle.shadows.general.topPanel[info[#info]] end,
								set = function(info, value) E.db.sle.shadows.general.topPanel[info[#info]] = value; ENH:HandleElvUIPanels() end,
								-- disabled = function() return not E.private.general.minimap.enable end,
								args = {
									backdrop = {
										order = 1,
										type = 'toggle',
										name = L["Top Panel"],
										desc = L["Enables a shadow for the panel or backdrop of this frame."],
										disabled = function() return not E.db.general.topPanel end,
									},
									size = {
										order = 2,
										type = 'range',
										name = L["Size"],
										min = 2, max = 10, step = 1,
										disabled = function() return not E.db.general.topPanel or not E.db.sle.shadows.general.topPanel.backdrop end,
										-- get = function(info) return E.db.sle.shadows.minimap[info[#info]] end,
										-- set = function(info, value)
										-- 	E.db.sle.shadows.minimap[info[#info]] = value

										-- 	_G.ElvUI_MinimapHolder.enhshadow.size = value
										-- 	ENH:UpdateShadow(_G.ElvUI_MinimapHolder.enhshadow)
										-- 	ENH.DummyPanels.Minimap.enhshadow.size = value
										-- 	ENH:UpdateShadow(ENH.DummyPanels.Minimap.enhshadow)
										-- end,
									},
								},
							},
						},
					},
				},
			},
			actionbars = {
				order = 10,
				type = 'group',
				name = L["ActionBars"],
				disabled = function() return not E.private.sle.module.shadows.enable or not E.private.actionbar.enable end,
				args = {
					barPet = {
						order = 11,
						type = 'group',
						name = function() return format(E.db.actionbar.barPet.enabled and '%s' or '|cffFF3333%s|r', L["Pet Bar"]) end,
						disabled = function() return not E.ActionBars.Initialized end,
						get = function(info) return E.db.sle.shadows.actionbars.petbar[info[#info]] end,
						set = function(info, value) E.db.sle.shadows.actionbars.petbar[info[#info]] = value; ENH:ToggleABShadows() end,
						args = {
							buttons = {
								order = 1,
								type = 'toggle',
								name = L["Buttons"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Buttons"])),
							},
							backdrop = {
								order = 2,
								type = 'toggle',
								name = L["Backdrop"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Backdrop"])),
							},
							size = {
								order = 3,
								type = 'range',
								name = L["Size"],
								min = 2, max = 10, step = 1,
								set = function(info, value)
									E.db.sle.shadows.actionbars.petbar[info[#info]] = value
									_G.ElvUI_BarPet.enhshadow.size = value
									ENH:UpdateShadow(_G.ElvUI_BarPet.enhshadow)
									for i = 1, 12 do
										local button = _G['PetActionButton'..i]
										if not button then break end
										button.enhshadow.size = value
										ENH:UpdateShadow(button.enhshadow)
									end
								end,
							},
						},
					},
					microbar = {
						order = 11,
						type = 'group',
						name = function() return format(E.db.actionbar.microbar.enabled and '%s' or '|cffFF3333%s|r', L["Micro Bar"]) end,
						disabled = function() return not E.ActionBars.Initialized end,
						get = function(info) return E.db.sle.shadows.actionbars.microbar[info[#info]] end,
						set = function(info, value) E.db.sle.shadows.actionbars.microbar[info[#info]] = value; ENH:ToggleABShadows() end,
						args = {
							buttons = {
								order = 1,
								type = 'toggle',
								name = L["Buttons"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Buttons"])),
							},
							backdrop = {
								order = 2,
								type = 'toggle',
								name = L["Backdrop"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Backdrop"])),
							},
							size = {
								order = 3,
								type = 'range',
								name = L["Size"],
								min = 2, max = 10, step = 1,
								set = function(info, value)
									E.db.sle.shadows.actionbars.microbar[info[#info]] = value
									_G.ElvUI_MicroBar.enhshadow.size = value
									ENH:UpdateShadow(_G.ElvUI_MicroBar.enhshadow)

									for i=1, (#MICRO_BUTTONS) do
										local button = _G[MICRO_BUTTONS[i]]
										if not button then break end
										button.enhshadow.size = value
										ENH:UpdateShadow(button.enhshadow)
									end
								end,
							},
						},
					},
					stancebar = {
						order = 11,
						type = 'group',
						name = function() return format(E.db.actionbar.stanceBar.enabled and '%s' or '|cffFF3333%s|r', L["Stance Bar"]) end,
						disabled = function() return not E.ActionBars.Initialized end,
						get = function(info) return E.db.sle.shadows.actionbars.stancebar[info[#info]] end,
						set = function(info, value) E.db.sle.shadows.actionbars.stancebar[info[#info]] = value; ENH:ToggleABShadows() end,
						args = {
							buttons = {
								order = 1,
								type = 'toggle',
								name = L["Buttons"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Buttons"])),
							},
							backdrop = {
								order = 2,
								type = 'toggle',
								name = L["Backdrop"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Backdrop"])),
							},
							size = {
								order = 3,
								type = 'range',
								name = L["Size"],
								min = 2, max = 10, step = 1,
								set = function(info, value)
									E.db.sle.shadows.actionbars.stancebar[info[#info]] = value
									_G.ElvUI_StanceBar.enhshadow.size = value
									ENH:UpdateShadow(_G.ElvUI_StanceBar.enhshadow)
									for i = 1, 12 do
										local button = _G['ElvUI_StanceBarButton'..i]
										if not button then break end
										button.enhshadow.size = value
										ENH:UpdateShadow(button.enhshadow)
									end
								end,
							},
						},
					},
					vehicle = {
						order = i,
						type = 'group',
						name = function() return format(E.db.sle.actionbar.vehicle.enabled and '%s' or '|cffFF3333%s|r', L["Dedicated Vehicle Bar"]) end,
						disabled = function() return not E.ActionBars.Initialized end,
						get = function(info) return E.db.sle.shadows.actionbars.vehicle[info[#info]] end,
						set = function(info, value) E.db.sle.shadows.actionbars.vehicle[info[#info]] = value; ENH:ToggleABShadows() end,
						args = {
							buttons = {
								order = 1,
								type = 'toggle',
								name = L["Buttons"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Buttons"])),
							},
							backdrop = {
								order = 2,
								type = 'toggle',
								name = L["Backdrop"],
								desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Backdrop"])),
							},
							size = {
								order = 3,
								type = 'range',
								name = L["Size"],
								min = 2, max = 10, step = 1,
								set = function(info, value)
									E.db.sle.shadows.actionbars.vehicle[info[#info]] = value
									_G['SL_DedicatedVehicleBar'].enhshadow.size = value
									ENH:UpdateShadow(_G['SL_DedicatedVehicleBar'].enhshadow)

									for k = 1, 7 do
										local buttonBars = {_G['SL_DedicatedVehicleBarButton'..k]}
										for _, button in pairs(buttonBars) do
											button.enhshadow.size = value
											ENH:UpdateShadow(button.enhshadow)
										end
									end
								end,
							},
						},
					}
				},
			},
			databars = {
				order = 10,
				type = 'group',
				name = L["DataBars"],
				disabled = function() return not E.private.sle.module.shadows.enable end,
				args = {},
			},
			datatexts = {
				order = 10,
				type = 'group',
				name = L["DataTexts"],
				disabled = function() return not E.private.sle.module.shadows.enable end,
				args = {},
			},
			unitframes = {
				order = 10,
				type = 'group',
				name = L["UnitFrames"],
				disabled = function() return not E.private.sle.module.shadows.enable or not E.UnitFrames.Initialized end,
				args = {
					size = {
						order = 0,
						type = 'range',
						name = L["Size"],
						min = 2, max = 10, step = 1,
						get = function(info) return E.db.sle.shadows.unitframes[info[#info]] end,
						set = function(info, value)
							E.db.sle.shadows.unitframes[info[#info]] = value
							UF:Update_AllFrames()
						end,
						disabled = function() return not E.UnitFrames.Initialized end,
					},
				},
			},
		},
	}

	-- Inserts Azerite, Experience, Honor, Reputation, & Threat Databars shadow options into the config
	for bar, tbl in next, ENH.frames.databars do
		local frame, name = unpack(tbl)
		frame = _G[frame]

		E.Options.args.sle.args.modules.args.shadows.args.databars.args[bar] = {
			order = 50,
			type = 'group',
			name = function() return format(E.db.databars[bar].enable and '%s' or '|cffFF3333%s|r', name) end,
			get = function(info) return E.db.sle.shadows.databars[bar][info[#info]] end,
			set = function(info, value) E.db.sle.shadows.databars[bar][info[#info]] = value; ENH:ToggleDBShadows() end,
			args = {
				elvconfig = {
					order = 0,
					type = 'execute',
					name = 'ElvUI: '..name,
					width = 'full',
					func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'databars', bar) end,
				},
				backdrop = {
					order = 2,
					type = 'toggle',
					name = L["Panel"],
					desc = L["Enables a shadow for the panel or backdrop of this frame."],
					disabled = function() return not E.db.databars[bar].enable end,
				},
				size = {
					order = 3,
					type = 'range',
					name = L["Size"],
					min = 2, max = 10, step = 1,
					disabled = function() return not E.db.databars[bar].enable end,
					set = function(info, value)
						E.db.sle.shadows.databars[bar][info[#info]] = value
						frame.enhshadow.size = value
						ENH:UpdateShadow(frame.enhshadow)
					end,
				},
			},
		}
	end
	ENH:UpdateDatatextOptions()
	-- -- for name, frame in next, DT.db.panels do
	-- for name, frame in next, DT.RegisteredPanels do
	-- 	E.Options.args.sle.args.modules.args.shadows.args.datatexts.args[name] = {
	-- 		order = 1,
	-- 		type = 'group',
	-- 		name = function() return format(E.db.datatexts.panels[name].enable and '%s' or '|cffFF3333%s|r', name) end,
	-- 		get = function(info) return E.db.sle.shadows.datatexts.panels[name][info[#info]] end,
	-- 		set = function(info, value) E.db.sle.shadows.datatexts.panels[name][info[#info]] = value; ENH:ToggleDTShadows() end,
	-- 		args = {
	-- 			backdrop = {
	-- 				order = 2,
	-- 				type = 'toggle',
	-- 				name = L["Panel"],
	-- 				disabled = function() return not E.db.datatexts.panels[name].enable end,
	-- 			},
	-- 			size = {
	-- 				order = 3,
	-- 				type = 'range',
	-- 				name = L["Size"],
	-- 				min = 2, max = 10, step = 1,
	-- 				disabled = function() return not E.db.datatexts.panels[name].enable end,
	-- 				set = function(info, value)
	-- 					E.db.sle.shadows.datatexts.panels[name][info[#info]] = value
	-- 					if ENH.DummyPanels[name] and ENH.DummyPanels[name].enhshadow then
	-- 						frame = ENH.DummyPanels[name]
	-- 					end
	-- 					frame.enhshadow.size = value
	-- 					ENH:UpdateShadow(frame.enhshadow)
	-- 				end,
	-- 			},
	-- 		},
	-- 	}
	-- 	if name == 'LeftChatDataPanel' or name == 'RightChatDataPanel' then
	-- 		E.Options.args.sle.args.modules.args.shadows.args.datatexts.args[name].args.backdrop.set = function(info, value)
	-- 			E.db.sle.shadows.datatexts.panels[name][info[#info]] = value
	-- 			if ENH.DummyPanels[name] and ENH.DummyPanels[name].enhshadow then
	-- 				frame = ENH.DummyPanels[name]
	-- 			end
	-- 			frame.enhshadow.backdrop = value
	-- 			ENH:UpdateShadow(frame.enhshadow)
	-- 			ENH:UpdateShadow(_G.LeftChatPanel.enhshadow)
	-- 			ENH:UpdateShadow(_G.RightChatPanel.enhshadow)
	-- 			ENH:ToggleDTShadows()
	-- 		end
	-- 	end
	-- end

	for unit, config in pairs(ENH.frames.unitframes) do
		E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit] = {
			order = config.order,
			type = 'group',
			name = function() return format(E.db.unitframe.units[unit].enable and '%s' or '|cffFF3333%s|r', gsub(E:StringTitle(unit), 't(arget)', 'T%1')) end,
			disabled = function() return not E.private.unitframe.enable end,
			get = function(info) return E.db.sle.shadows.unitframes[unit][info[#info]] end,
			set = function(info, value)
				E.db.sle.shadows.unitframes[unit][info[#info]] = value
				-- local ufname = E:StringTitle(unit):gsub('t(arget)', 'T%1')
				UF:Update_AllFrames()
			end,
			args = {
				elvuiconfig = {
					order = 0,
					type = 'execute',
					name = gsub('ElvUI: '..E:StringTitle(unit)..' '..L["Frame"], 't(arget)', 'T%1'),
					width = 'full',
					func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'unitframe', config.group, unit, 'generalGroup') end,
					disabled = function() return false end,
				},
				legacy = {
					order = 1,
					type = 'toggle',
					name = L["Legacy Shadows"],
					desc = L["Tries to place a shadow around the health, power, and classbars as one frame instead of individual frames."],
					disabled = function() return not E.db.unitframe.units[unit].enable end,
				},
				health = {
					order = 2,
					type = 'toggle',
					name = L["Health"],
					disabled = function() return not E.db.unitframe.units[unit].enable end,
				},
				power = {
					order = 3,
					type = 'toggle',
					name = L["Power"],
					disabled = function() return not E.db.unitframe.units[unit].enable end,
				},
			},
		}

		if unit == 'player' then
			E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.classbar = {
				order = 4,
				type = 'toggle',
				name = L["Classbar"],
				disabled = function() return not E.db.unitframe.units[unit].enable or not (E.db.unitframe.units[unit].classbar.detachFromFrame or E.db.unitframe.units[unit].classbar.fill ~= 'fill') end,
			}
		end
	end

	-- TODO: Adds a section for a button (to return to S&L enhshadows) or to mirror shadow options
	-- * The idea is to make options we have more known
	-- E.Options.args.unitframe.args.groupUnits.args[unit].args.generalGroup.args.slshadow = {
	-- 	order = -1,
	-- 	name = 'S&L Shadows',
	-- 	type = 'group',
	-- 	inline = true,
	-- 	args = {
	-- 		configplayer = {
	-- 			order = 0,
	-- 			type = 'execute',
	-- 			name = 'S&L: '..E:StringTitle(unit)..' Shadows',
	-- 			width = 'full',
	-- 			func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle", 'modules', "shadows", "unitframes", unit) end,
	-- 			hidden = function()
	-- 				if not E.private.skins.blizzard.enable then return true end
	-- 				return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
	-- 			end,
	-- 		}
	-- 	}
	-- }

	-- Inserts Actionbars 1-10 shadow options into the config
	for i = 1, 10 do
		E.Options.args.sle.args.modules.args.shadows.args.actionbars.args['bar'..i] = {
			order = i,
			type = 'group',
			name = function() return format(E.db.actionbar['bar'..i].enabled and '%s' or '|cffFF3333%s|r', L["Bar "]..i) end,
			disabled = function() return not E.ActionBars.Initialized end,
			get = function(info) return E.db.sle.shadows.actionbars['bar'..i][info[#info]] end,
			set = function(info, value) E.db.sle.shadows.actionbars['bar'..i][info[#info]] = value; ENH:ToggleABShadows() end,
			args = {
				buttons = {
					order = 1,
					type = 'toggle',
					name = L["Buttons"],
					desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Buttons"])),
				},
				backdrop = {
					order = 2,
					type = 'toggle',
					name = L["Backdrop"],
					desc = format(L["Enables a shadow on the %s when it's enabled."], strlower(L["Backdrop"])),
				},
				size = {
					order = 3,
					type = 'range',
					name = L["Size"],
					min = 2, max = 10, step = 1,
					set = function(info, value)
						E.db.sle.shadows.actionbars['bar'..i][info[#info]] = value
						_G['ElvUI_Bar'..i].enhshadow.size = value
						ENH:UpdateShadow(_G['ElvUI_Bar'..i].enhshadow)

						for k = 1, 12 do
							local buttonBars = {_G['ElvUI_Bar'..i..'Button'..k]}
							for _, button in pairs(buttonBars) do
								button.enhshadow.size = value
								ENH:UpdateShadow(button.enhshadow)
							end
						end
					end,
				},
			},
		}
	end
end

tinsert(SLE.Configs, configTable)
