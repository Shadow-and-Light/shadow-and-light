local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.nameplate = {
		type = "group",
		name = L["NamePlates"],
		order = 1,
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
				get = function(info) return E.db.sle.nameplates.targetcount[ info[#info] ] end,
				set = function(info, value) E.db.sle.nameplates.targetcount[ info[#info] ] = value; NP:ConfigureAll() end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Display the number of party / raid members targeting the nameplate unit."],
					},
					font = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					size = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 4, max = 25, step = 1,
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
					},
					xoffset = {
						order = 7,
						name = L["xOffset"],
						type = "range",
						min = -200, max = 200, step = 1,
					},
					yoffset = {
						order = 8,
						name = L["yOffset"],
						type = "range",
						min = -50, max = 50, step = 1,
					},
				},
			},
			threat = {
				type = "group",
				order = 3,
				name = L["Threat Text"],
				guiInline = true,
				get = function(info) return E.db.sle.nameplates.threat[ info[#info] ] end,
				set = function(info, value) E.db.sle.nameplates.threat[ info[#info] ] = value; NP:ConfigureAll() end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Display threat level as text on targeted, boss or mouseover nameplate."],
					},
					font = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					size = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 4, max = 25, step = 1,
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
					},
					xoffset = {
						order = 7,
						name = L["xOffset"],
						type = "range",
						min = -200, max = 200, step = 1,
					},
					yoffset = {
						order = 8,
						name = L["yOffset"],
						type = "range",
						min = -50, max = 50, step = 1,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
