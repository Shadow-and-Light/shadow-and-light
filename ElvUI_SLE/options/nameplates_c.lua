local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.nameplate = {
		type = "group",
		name = L["NamePlates"],
		order = 14,
		disabled = function() return not E.private.nameplates.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NamePlates"],
			},
			targetcount = {
				type = "group",
				order = 2,
				name = L["Target Count"],
				guiInline = true,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Display the number of party / raid members targeting the nameplate unit."],
						get = function(info) return E.db.sle.nameplates.targetcount[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.targetcount[ info[#info] ] = value; NP:ConfigureAll() end,
					},
					font = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						get = function(info) return E.db.sle.nameplates.targetcount[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.targetcount[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
					size = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 4, max = 25, step = 1,
						get = function(info) return E.db.sle.nameplates.targetcount[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.targetcount[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
					fontOutline = {
						order = 6,
						name = L["Font Outline"],
						desc = L["Set the font outline."],
						type = "select",
						values = {
							['NONE'] = NONE,
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						get = function(info) return E.db.sle.nameplates.targetcount[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.targetcount[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
				},
			},
			threat = {
				type = "group",
				order = 3,
				name = L["Threat Text"],
				guiInline = true,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Display threat level as text on targeted, boss or mouseover nameplate."],
						get = function(info) return E.db.sle.nameplates.threat[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.threat[ info[#info] ] = value; NP:ConfigureAll() end,
					},
					font = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						get = function(info) return E.db.sle.nameplates.threat[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.threat[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
					size = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 4, max = 25, step = 1,
						get = function(info) return E.db.sle.nameplates.threat[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.threat[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
					fontOutline = {
						order = 6,
						name = L["Font Outline"],
						desc = L["Set the font outline."],
						type = "select",
						values = {
							['NONE'] = NONE,
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						get = function(info) return E.db.sle.nameplates.threat[ info[#info] ] end,
						set = function(info, value) E.db.sle.nameplates.threat[ info[#info] ] = value; NP:UpdatePlateFonts() end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)