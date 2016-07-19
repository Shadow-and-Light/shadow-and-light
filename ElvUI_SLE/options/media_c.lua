local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE:GetModule('Media')

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.media = {
		type = "group",
		name = L["Media"],
		order = 20,
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
				name = L["SLE_MEDIA"],
			},
			zonefonts = {
				type = "group",
				name = L["Zone Text"],
				order = 3,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = "",
					},
					test = {
						order = 2,
						type = 'execute',
						name = L["Test"],
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						func = function() M:TextShow() end,
					},
					zone = {
						type = "group",
						name = L["Zone Text"],
						order = 3,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.eyefinity or E.screenwidth, step = 1,
								set = function(info, value) E.db.sle.media.fonts.zone.width = value; M:TextWidth() end,
							},
						},
					},
					subzone = {
						type = "group",
						name = L["Subzone Text"],
						order = 4,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.eyefinity or E.screenwidth, step = 1,
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
						name = L["PvP Status Text"],
						order = 5,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
							width = {
								order = 4,
								name = L["Width"],
								type = "range",
								min = 512, max = E.eyefinity or E.screenwidth, step = 1,
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
						name = L["Mail Text"],
						order = 1,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						},
					},
					editbox = {
						type = "group",
						name = L["Chat Editbox Text"],
						order = 2,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						},
					},
					gossip = {
						type = "group",
						name = L["Gossip and Quest Frames Text"],
						order = 2,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.gossip[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.gossip[ info[#info] ] = value; E:UpdateMedia() end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						},
					},
					questHeader = {
						type = "group",
						name = L["Objective Tracker Header Text"],
						order = 3,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.objectiveHeader[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.objectiveHeader[ info[#info] ] = value; E:UpdateMedia() end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						},
					},
					questTracker = {
						type = "group",
						name = L["Objective Tracker Text"],
						order = 4,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.objective[ info[#info] ] end,
						set = function(info, value) E.db.sle.media.fonts.objective[ info[#info] ] = value; E:UpdateMedia() end,
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
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
								},
							},
						},
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)