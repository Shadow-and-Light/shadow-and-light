local SLE, T, E, L = unpack(select(2, ...))
local M = SLE:GetModule('Media')

local allFont = 'PT Sans Narrow'
local allSize = 12
local allOutline = 'OUTLINE'

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.media = {
		type = 'group',
		name = L["Media"],
		order = 20,
		childGroups = 'tab',
		args = {
			zonefonts = {
				type = 'group',
				name = L["Zone Text"],
				order = 3,
				args = {
					intro = ACH:Spacer(1),
					test = {
						order = 2,
						type = 'execute',
						name = L["Test"],
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						func = function() M:TextShow() end,
					},
					zone = {
						type = 'group',
						name = L["Zone Text"],
						order = 3,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.zone[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.zone[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
					subzone = {
						type = 'group',
						name = L["Subzone Text"],
						order = 4,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.subzone[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.subzone[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
							offset = {
								order = 5,
								name = L["Offset"],
								type = 'range',
								min = 0, max = 30, step = 1,
							},
						},
					},
					pvpstatus = {
						type = 'group',
						name = L["PvP Status Text"],
						order = 5,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.pvp[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.pvp[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
				},
			},
			miscfonts = {
				type = 'group',
				name = L["Misc Texts"],
				order = 4,
				args = {
					mail = {
						type = 'group',
						name = L["Mail Text"],
						order = 1,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.mail[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.mail[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 22, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
					gossip = {
						type = 'group',
						name = L["Gossip and Quest Frames Text"],
						order = 2,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.gossip[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.gossip[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 20, step = 1,
							},
						},
					},
					questHeader = {
						type = 'group',
						name = L["Objective Tracker Header Text"],
						order = 3,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.objectiveHeader[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.objectiveHeader[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 20, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
					questTracker = {
						type = 'group',
						name = L["Objective Tracker Text"],
						order = 4,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.objective[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.objective[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 20, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
					questFontSuperHuge = {
						type = 'group',
						name = L["Banner Big Text"],
						order = 5,
						guiInline = true,
						disabled = function() return not E.private.general.replaceBlizzFonts end,
						get = function(info) return E.db.sle.media.fonts.questFontSuperHuge[info[#info]] end,
						set = function(info, value) E.db.sle.media.fonts.questFontSuperHuge[info[#info]] = value; E:UpdateMedia() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							size = {
								order = 2,
								name = L["FONT_SIZE"],
								type = 'range',
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = T.Values.FontFlags,
							},
						},
					},
				},
			},
			applyAll = {
				type = 'group',
				name = L["Apply Font To All"],
				order = 60,
				args = {
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 1,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						get = function(_) return allFont end,
						set = function(_, value) allFont = value; end,
					},
					size = {
						order = 2,
						name = L["FONT_SIZE"],
						type = 'range',
						min = 6, max = 20, step = 1,
						get = function(_) return allSize end,
						set = function(_, value) allSize = value; end,
					},
					outline = {
						order = 3,
						name = L["Font Outline"],
						type = 'select',
						get = function(_) return allOutline end,
						set = function(_, value) allOutline = value; end,
						values = T.Values.FontFlags,
					},
					applyFontToAll = {
						order = 4,
						type = 'execute',
						name = L["Apply Font To All"],
						-- desc = L["Applies the font and font size settings throughout the entire user interface. Note: Some font size settings will be skipped due to them having a smaller font size by default."],
						func = function()
							E.PopupDialogs["SLE_APPLY_FONT_WARNING"].allFont = allFont
							E.PopupDialogs["SLE_APPLY_FONT_WARNING"].allSize = allSize
							E.PopupDialogs["SLE_APPLY_FONT_WARNING"].allOutline = allOutline
							E:StaticPopup_Show("SLE_APPLY_FONT_WARNING");
						end,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
