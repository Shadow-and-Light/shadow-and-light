local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_NihilistUI"] then return end
local ES = SLE:GetModule("EnhancedShadows")

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.shadows = {
		order = 1,
		type = "group",
		name = L["Enhanced Shadows"],
		get = function(info) return E.db.sle.shadows[info[#info]] end,
		set = function(info, value) E.db.sle.shadows[info[#info]] = value ES:UpdateShadows() end,
		args = {
			shadowcolor = {
				type = "color",
				order = 1,
				name = COLOR,
				hasAlpha = false,
				get = function(info)
					local t = E.db.sle.shadows[info[#info]]
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b)
					E.db.sle.shadows[info[#info]] = {}
					local t = E.db.sle.shadows[info[#info]]
					t.r, t.g, t.b = r, g, b
					ES:UpdateShadows()
				end,
			},
			classcolor = {
				type = 'toggle',
				order = 2,
				name = L["Use Class Color"],
			},
			size = {
				order = 2,
				type = 'range',
				name = L["Size"],
				min = 2, max = 10, step = 1,
			},
			frames = {
				order = 4,
				type = "group",
				name = L["Use shadows on..."],
				-- guiInline = true,
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					vehicle = {
						order = 1,
						type = "toggle",
						name = L["Enhanced Vehicle Bar"],
					},
					minimap = {
						order = 2,
						type = "toggle",
						name = L["Minimap"],
					},
					unitframes = {
						order = 10,
						type = "group",
						name = L["UnitFrames"],
						args = {
							player = {
								order = 1,
								type = "toggle",
								name = L["Player Frame"],
							},
							playerLegacy = {
								order = 2,
								type = "toggle",
								name = L["Player Frame Classic"],
							},
							target = {
								order = 5,
								type = "toggle",
								name = L["Target Frame"],
							},
							targetLegacy = {
								order = 6,
								type = "toggle",
								name = L["Target Frame Classic"],
							},
							targettarget = {
								order = 10,
								type = "toggle",
								name = L["TargetTarget Frame"],
							},
							targettargetLegacy = {
								order = 11,
								type = "toggle",
								name = L["TargetTarget Frame Classic"],
							},
							focus = {
								order = 15,
								type = "toggle",
								name = L["Focus Frame"],
							},
							focusLegacy = {
								order = 16,
								type = "toggle",
								name = L["Focus Frame Classic"],
							},
							focustarget = {
								order = 20,
								type = "toggle",
								name = L["FocusTarget Frame"],
							},
							focustargetLegacy = {
								order = 21,
								type = "toggle",
								name = L["FocusTarget Frame Classic"],
							},
							pet = {
								order = 25,
								type = "toggle",
								name = L["Pet Frame"],
							},
							petLegacy = {
								order = 26,
								type = "toggle",
								name = L["Pet Frame Classic"],
							},
							pettarget = {
								order = 30,
								type = "toggle",
								name = L["PetTarget Frame"],
							},
							pettargetLegacy = {
								order = 31,
								type = "toggle",
								name = L["PetTarget Frame Classic"],
							},
							boss = {
								order = 35,
								type = "toggle",
								name = L["Boss Frames"],
							},
							bossLegacy = {
								order = 36,
								type = "toggle",
								name = L["Boss Frames Classic"],
							},
							arena = {
								order = 40,
								type = "toggle",
								name = L["Arena Frames"],
							},
							arenaLegacy = {
								order = 41,
								type = "toggle",
								name = L["Arena Frames Classic"],
							},
						},
					},
					actionbars = {
						order = 11,
						type = "group",
						name = L["ActionBars"],
						get = function(info) return E.private.sle.module.shadows.actionbars[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.actionbars[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							microbar = {
								order = 1,
								type = "toggle",
								name = L["Micro Bar"],
							},
							microbarbuttons = {
								order = 2,
								type = "toggle",
								name = L["SLE_EnhShadows_MicroButtons_Option"],
							},
							stancebar = {
								order = 3,
								type = "toggle",
								name = L["Stance Bar"],
							},
							stancebarbuttons = {
								order = 4,
								type = "toggle",
								name = L["SLE_EnhShadows_StanceButtons_Option"],
							},
							petbar = {
								order = 5,
								type = "toggle",
								name = L["Pet Bar"],
							},
							petbarbuttons = {
								order = 6,
								type = "toggle",
								name = L["SLE_EnhShadows_PetButtons_Option"],
							},
						},
					},
					chat = {
						order = 12,
						type = "group",
						name = L["Chat"],
						get = function(info) return E.private.sle.module.shadows.chat[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.chat[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							left = {
								order = 1,
								type = "toggle",
								name = L["Left Chat"],
							},
							right = {
								order = 2,
								type = "toggle",
								name = L["Right Chat"],
							},
						},
					},
					datatexts = {
						order = 13,
						type = "group",
						name = L["DataTexts"],
						get = function(info) return E.private.sle.module.shadows.datatexts[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.datatexts[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							leftchat = {
								order = 1,
								type = "toggle",
								name = L["Left Chat"],
							},
							rightchat = {
								order = 2,
								type = "toggle",
								name = L["Right Chat"],
							},
							-- leftminipanel = {
								-- order = 3,
								-- type = "toggle",
								-- name = L["LeftMiniPanel"],
							-- },
							-- rightminipanel = {
								-- order = 4,
								-- type = "toggle",
								-- name = L["RightMiniPanel"],
							-- },
							panel1 = {
								order = 11,
								type = "toggle",
								name = L["SLE_DataPanel_1"],
							},
							panel2 = {
								order = 12,
								type = "toggle",
								name = L["SLE_DataPanel_2"],
							},
							panel3 = {
								order = 13,
								type = "toggle",
								name = L["SLE_DataPanel_3"],
							},
							panel4 = {
								order = 14,
								type = "toggle",
								name = L["SLE_DataPanel_4"],
							},
							panel5 = {
								order = 15,
								type = "toggle",
								name = L["SLE_DataPanel_5"],
							},
							panel6 = {
								order = 16,
								type = "toggle",
								name = L["SLE_DataPanel_6"],
							},
							panel7 = {
								order = 17,
								type = "toggle",
								name = L["SLE_DataPanel_7"],
							},
							panel8 = {
								order = 18,
								type = "toggle",
								name = L["SLE_DataPanel_8"],
							},
						},
					},
				},
			},
		},
	}

	for i = 1, 10 do
		E.Options.args.sle.args.modules.args.shadows.args.frames.args.actionbars.args["bar"..i] = {
			order = i + 6,
			type = "toggle",
			name = L["Bar "]..i,
		}
		E.Options.args.sle.args.modules.args.shadows.args.frames.args.actionbars.args["bar"..i.."buttons"] = {
			order = i + 6,
			type = "toggle",
			name = T.format(L["SLE_EnhShadows_BarButtons_Option"], i),
		}
	end
end

T.tinsert(SLE.Configs, configTable)
