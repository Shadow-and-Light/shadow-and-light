local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 3,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Minimap Options"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L['MINIMAP_DESC'],
			},
			combat = {
				type = "toggle",
				name = L["Hide In Combat"],
				order = 3,
				desc = L['Hide minimap in combat.'],
				disabled = false,
				get = function(info) return E.db.sle.minimap.combat end,
				set = function(info, value) E.db.sle.minimap.combat = value; E:GetModule('Minimap'):SLEHideMinimap() end,
			},
			alpha = {
				order = 4,
				type = 'range',
				name = L['Minimap Alpha'],
				isPercent = true,
				min = 0.3, max = 1, step = 0.01,
				get = function(info) return E.db.sle.minimap.alpha end,
				set = function(info, value) E.db.sle.minimap.alpha = value; E:GetModule('Minimap'):Transparency() end,
			},
			coords = {
				type = "group",
				name = L["Minimap Coordinates"],
				order = 5,
				guiInline = true,
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.enable end,
				args = {
					coordsenable = {
						type = "toggle",
						name = L['Enable'],
						order = 1,
						desc = L['Enable/Disable Square Minimap Coords.'],
						get = function(info) return E.db.sle.minimap.enable end,
						set = function(info, value) E.db.sle.minimap.enable = value; E:GetModule('Minimap'):UpdateSettings() end,
						disabled = function() return not E.private.general.minimap.enable end,
					},
					display = {
						order = 2,
						type = 'select',
						name = L['Coords Display'],
						desc = L['Change settings for the display of the coordinates that are on the minimap.'],
						get = function(info) return E.db.sle.minimap.coords.display end,
						set = function(info, value) E.db.sle.minimap.coords.display = value; E:GetModule('Minimap'):UpdateSettings() end,
						values = {
							['MOUSEOVER'] = L['Minimap Mouseover'],
							['SHOW'] = L['Always Display'],
						},
					},
					middle = {
						order = 3,
						type = "select",
						name = L["Coords Location"],
						desc = L['This will determine where the coords are shown on the minimap.'],
						get = function(info) return E.db.sle.minimap.coords.middle end,
						set = function(info, value) E.db.sle.minimap.coords.middle = value; E:GetModule('Minimap'):UpdateSettings() end,
						values = {
							['CORNERS'] = L['Bottom Corners'],
							['CENTER'] = L['Bottom Center'],
						},
					},
					decimals = {
						type = "toggle",
						name = L['Decimals'],
						order = 4,
						--desc = L['Enable/Disable Square Minimap Coords.'],
						get = function(info) return E.db.sle.minimap.coords.decimals end,
						set = function(info, value) E.db.sle.minimap.coords.decimals = value; E:GetModule('Minimap'):UpdateSettings() end,
						disabled = function() return not E.private.general.minimap.enable end,
					},
				},
			},
			mapicons = {
				type = "group",
				name = L["Minimap Buttons"],
				order = 6,
				guiInline = true,
				disabled = function() return not E.private.sle.minimap.mapicons.enable end,
				args = {
					mapiconsenable = {
						type = "toggle",
						name = L['Enable'],
						order = 1,
						desc = L['Enable/Disable Square Minimap Buttons.'],
						disabled = false,
						get = function(info) return E.private.sle.minimap.mapicons.enable end,
						set = function(info, value) E.private.sle.minimap.mapicons.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					barenable = {
						order = 2,
						type = "toggle",
						name = L["Bar Enable"],
						desc = L['Enable/Disable Square Minimap Bar.'],
						get = function(info) return E.private.sle.minimap.mapicons.barenable end,
						set = function(info, value) E.private.sle.minimap.mapicons.barenable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					skindungeon = {
						order = 3,
						type = 'toggle',
						name = L['Skin Dungeon'],
						desc = L['Skin dungeon icon.'],
						get = function(info) return E.db.sle.minimap.mapicons.skindungeon end,
						set = function(info, value) E.db.sle.minimap.mapicons.skindungeon = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					skinmail = {
						order = 4,
						type = 'toggle',
						name = L['Skin Mail'],
						desc = L['Skin mail icon.'],
						get = function(info) return E.db.sle.minimap.mapicons.skinmail end,
						set = function(info, value) E.db.sle.minimap.mapicons.skinmail = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconsize = {
						order = 5,
						type = 'range',
						name = L['Button Size'],
						desc = L['The size of the minimap buttons when not anchored to the minimap.'],
						min = 16, max = 40, step = 1,
						get = function(info) return E.db.sle.minimap.mapicons.iconsize end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconsize = value; E:GetModule('SLE_SquareMinimapButtons'):Update(SquareMinimapButtonBar) end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconperrow = {
						order = 6,
						type = 'range',
						name = L['Icons Per Row'],
						desc = L['Anchor mode for displaying the minimap buttons are skinned.'],
						min = 1, max = 12, step = 1,
						get = function(info) return E.db.sle.minimap.mapicons.iconperrow end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconperrow = value; E:GetModule('SLE_SquareMinimapButtons'):Update(SquareMinimapButtonBar) end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconmouseover = {
						order = 7,
						name = L['Mouse Over'],
						desc = L['Show minimap buttons on mouseover.'],
						type = "toggle",
						get = function(info) return E.db.sle.minimap.mapicons.iconmouseover end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconmouseover = value; E:GetModule('SLE_SquareMinimapButtons'):ChangeMouseOverSetting() end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
				},
			},
			instance = {
				type = "group",
				name = L["Instance indication"],
				order = 7,
				guiInline = true,
				get = function(info) return E.db.sle.minimap.instance[ info[#info] ] end,
				set = function(info, value) E.db.sle.minimap.instance[ info[#info] ] = value; E:GetModule('SLE_InstDif'):UpdateFrame() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Show instance difficulty info as text.'],
						disabled = function() return not E.private.general.minimap.enable end,
					},
					flag = {
						order = 2,
						type = 'toggle',
						name = L['Show texture'],
						desc = L['Show instance difficulty info as default texture.'],
						disabled = function() return not E.private.general.minimap.enable end,
					},
					xoffset = {
						order = 3,
						type = 'range',
						name = L['X-Offset'],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
					},
					yoffset = {
						order = 4,
						type = 'range',
						name = L['Y-Offset'],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
					},
					fontGroup = {
						order = 5,
						type = "group",
						name = L["Fonts"],
						guiInline = true,
						get = function(info) return E.db.sle.minimap.instance[ info[#info] ] end,
						set = function(info, value) E.db.sle.minimap.instance[ info[#info] ] = value; E:GetModule('SLE_InstDif'):UpdateFrame() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							fontSize = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 22, step = 1,
							},
							fontOutline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L["None"],
									['OUTLINE'] = 'OUTLINE',
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
						},
					},
					colors = {
						order = 8,
						type = 'group',
						name = L["Colors"],
						guiInline = true,
						get = function(info)
							local t = E.db.sle.minimap.instance.colors[ info[#info] ]
							local d = P.sle.minimap.instance.colors[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.sle.minimap.instance.colors[ info[#info] ] = {}
							local t = E.db.sle.minimap.instance.colors[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							E:GetModule('SLE_InstDif'):GenerateText(nil, nil, true)
						end,
						disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
						args = {
							info = {
								order = 1,
								type = "description",
								name = L['Sets the colors for difficulty abbreviation'],
							},
							lfr = {
								type = "color",
								order = 2,
								name = PLAYER_DIFFICULTY3,
								hasAlpha = false,
							},
							normal = {
								type = "color",
								order = 3,
								name = PLAYER_DIFFICULTY1,
								hasAlpha = false,
							},
							heroic = {
								type = "color",
								order = 4,
								name = PLAYER_DIFFICULTY2,
								hasAlpha = false,
							},
							challenge = {
								type = "color",
								order = 5,
								name = PLAYER_DIFFICULTY5,
								hasAlpha = false,
							},
							mythic = {
								type = "color",
								order = 6,
								name = PLAYER_DIFFICULTY6,
								hasAlpha = false,
							},
						},
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)