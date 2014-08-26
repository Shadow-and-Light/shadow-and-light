local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('SLE_Media')
local S = E:GetModule("SLE_ScreenSaver")

local function configTable()
	E.Options.args.sle.args.media = {
		type = "group",
	    name = L["Media"],
	    order = 3,
		childGroups = 'tab',
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Media"],
			},
			intro = {
				order = 2,
				type = "description",
				name = "Imma text!",
			},
			zonefonts = {
				type = "group",
				name = L["Zone Texts"],
				order = 3,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = "Placeholder text.",
					},
					test = {
						order = 2,
						type = 'execute',
						name = "Test",
						func = function() M:TextShow() end,
					},
					zone = {
						type = "group",
						name = "Zone Text",
						order = 3,
						guiInline = true,
						get = function(info) return E.db.sle.media.fonts.zone[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.zone[ info[#info] ] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,	
							},
							size = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.screenwidth, step = 1,
								set = function(info, value) E.db.sle.media.fonts.zone.width = value; M:TextWidth() end,
							},
						},
					},
					subzone = {
						type = "group",
						name = "Subzone Text",
						order = 4,
						guiInline = true,
						get = function(info) return E.db.sle.media.fonts.subzone[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.subzone[ info[#info] ] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,	
							},
							size = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.screenwidth, step = 1,
								set = function(info, value) E.db.sle.media.fonts.subzone.width = value; M:TextWidth() end,
							},
							offset = {
								order = 5,
								name = L["Offset"],
								type = "range",
								min = 0, max = 30, step = 1,
							},
						},
					},
					pvpstatus = {
						type = "group",
						name = "PvP Status Text",
						order = 5,
						guiInline = true,
						get = function(info) return E.db.sle.media.fonts.pvp[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.pvp[ info[#info] ] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,	
							},
							size = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.screenwidth, step = 1,
								set = function(info, value) E.db.sle.media.fonts.pvp.width = value; M:TextWidth() end,
							},
						},
					},
				},
			},
			miscfonts = {
				type = "group",
				name = L["Misc Texts"],
				order = 4,
				args = {
					mail = {
						type = "group",
						name = "Mail Text",
						order = 1,
						guiInline = true,
						get = function(info) return E.db.sle.media.fonts.mail[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.mail[ info[#info] ] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								desc = "The font used for letters' body",
								values = AceGUIWidgetLSMlists.font,	
							},
							size = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 22, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
						},
					},
					editbox = {
						type = "group",
						name = "Chat Editbox Text",
						order = 2,
						guiInline = true,
						get = function(info) return E.db.sle.media.fonts.editbox[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.editbox[ info[#info] ] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								desc = "The font used for chat editbox",
								values = AceGUIWidgetLSMlists.font,	
							},
							size = {
								order = 2,
								name = L["Font Size"],
								type = "range",
								min = 6, max = 20, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
						},
					},
				},
			},
			screensaver = {
				type = "group",
				name = L["Screensaver"],
				order = 5,
				childGroups = 'tab',
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.sle.media.screensaver.enable end,
						set = function(info, value) E.db.sle.media.screensaver.enable = value; S:Reg(true) end,
					},
					fonts = {
						type = "group",
						name = L["Fonts"],
						order = 1,
						args = {
							title = {
								type = "group",
								name = "Title font",
								order = 1,
								guiInline = true,
								get = function(info) return E.db.sle.media.screensaver.title[ info[#info] ] end,
								set = function(info, value) E.db.sle.media.screensaver.title[ info[#info] ] = value S:Media() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = "The font used for ScreenSaver's Title",
										values = AceGUIWidgetLSMlists.font,	
									},
									size = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 12, max = 32, step = 1,
									},
									outline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
									},
								},
							},
							subtitle = {
								type = "group",
								name = "Subitle font",
								order = 2,
								guiInline = true,
								get = function(info) return E.db.sle.media.screensaver.subtitle[ info[#info] ] end,
								set = function(info, value) E.db.sle.media.screensaver.subtitle[ info[#info] ] = value S:Media() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = "The font used for ScreenSaver's Subtitle",
										values = AceGUIWidgetLSMlists.font,	
									},
									size = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 12, max = 26, step = 1,
									},
									outline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
									},
								},
							},
							date = {
								type = "group",
								name = "Date font",
								order = 3,
								guiInline = true,
								get = function(info) return E.db.sle.media.screensaver.date[ info[#info] ] end,
								set = function(info, value) E.db.sle.media.screensaver.date[ info[#info] ] = value S:Media() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = "The font used for Screensaver's Date and Time",
										values = AceGUIWidgetLSMlists.font,	
									},
									size = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 12, max = 26, step = 1,
									},
									outline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
									},
								},
							},
							player = {
								type = "group",
								name = "Player info font",
								order = 4,
								guiInline = true,
								get = function(info) return E.db.sle.media.screensaver.player[ info[#info] ] end,
								set = function(info, value) E.db.sle.media.screensaver.player[ info[#info] ] = value S:Media() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = "The font used for Screensaver's Player info",
										values = AceGUIWidgetLSMlists.font,	
									},
									size = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 12, max = 26, step = 1,
									},
									outline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
									},
								},
							},
							tips = {
								type = "group",
								name = "Tips font",
								order = 4,
								guiInline = true,
								get = function(info) return E.db.sle.media.screensaver.tips[ info[#info] ] end,
								set = function(info, value) E.db.sle.media.screensaver.tips[ info[#info] ] = value S:Media() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = "The font used for Screensaver's Tips",
										values = AceGUIWidgetLSMlists.font,	
									},
									size = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 12, max = 32, step = 1,
									},
									outline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
									},
								},
							},
						},
					},
					model = {
						type = "group",
						name = L["Graphics"],
						order = 2,
						get = function(info) return E.db.sle.media.screensaver[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.screensaver[ info[#info] ] = value S:Media() end,
						args = {
							crest = {
								order = 1,
								name = L["Crest Size"],
								type = "range",
								min = 84, max = 256, step = 1,
							},
							model = {
								order = 2,
								name = L["Model Animation"],
								type = "select",
								values = {
									[47] = "Standing",
									[4] = "Walking",
									[5] = "Running",
									[13] = "Walking backwards",
									[25] = 'Unarmed Ready',
									[60] = "Talking",
									[64] = 'Exclmation',
									[66] = 'Bow',
									[67] = 'Wave',
									[68] = 'Ceers',
									[69] = 'Dance',
									[70] = 'Laugh',
									[76] = 'Kiss',
									[77] = 'Cry',
									[80] = 'Applaud',
									[82] = 'Flex',
									[83] = 'Shy',
									[113] = 'Salute',
								},
							},
							height = {
								order = 3,
								name = L["Panel Height"],
								type = "range",
								min = 130, max = E.screenheight/6, step = 1,
							},
						},
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)