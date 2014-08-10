local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('SLE_Media')

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
		},
	}
end

table.insert(E.SLEConfigs, configTable)