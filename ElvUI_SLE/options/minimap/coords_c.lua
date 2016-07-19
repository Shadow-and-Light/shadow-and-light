local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local MM = SLE:GetModule("Minimap")
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.minimap.args.coords = {
		type = "group",
		name = L["Minimap Coordinates"],
		order = 5,
		get = function(info) return E.db.sle.minimap.coords[ info[#info] ] end,
		set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:UpdateSettings() end,
		args = {
			enable = {
				type = "toggle",
				name = L["Enable"],
				order = 1,
				desc = L["Enable/Disable Square Minimap Coords."],
				disabled = function() return not E.private.general.minimap.enable end,
			},
			display = {
				order = 2,
				type = 'select',
				name = L["Coords Display"],
				desc = L["Change settings for the display of the coordinates that are on the minimap."],
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable end,
				values = {
					["MOUSEOVER"] = L["Minimap Mouseover"],
					["SHOW"] = L["Always Display"],
				},
			},
			position = {
				order = 3,
				type = "select",
				name = L["Coords Location"],
				desc = L["This will determine where the coords are shown on the minimap."],
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable end,
				values = {
					["TOPLEFT"] = "TOPLEFT",
					["LEFT"] = "LEFT",
					["BOTTOMLEFT"] = "BOTTOMLEFT",
					["RIGHT"] = "RIGHT",
					["TOPRIGHT"] = "TOPRIGHT",
					["BOTTOMRIGHT"] = "BOTTOMRIGHT",
					["TOP"] = "TOP",
					["BOTTOM"] = "BOTTOM",
				}
			},
			format = {
				order = 4,
				name = L["Format"],
				type = "select",
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable end,
				values = {
					["%.0f"] = DEFAULT,
					["%.1f"] = "45.3",
					["%.2f"] = "45.34",
				},
			},
			throttle = {
				order = 5,
				type = 'range',
				name = L["Update Throttle"],
				min = 0.1, max = 2, step = 0.1,
				disabled = function() return not E.db.sle.minimap.locPanel.enable end,
				set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; end,
			},
			fontGroup = {
				order = 10,
				type = "group",
				name = L["Fonts"],
				guiInline = true,
				disabled = function() return not E.db.sle.minimap.locPanel.enable end,
				get = function(info) return E.db.sle.minimap.coords[ info[#info] ] end,
				set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:CoordFont() end,
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
						set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:CoordFont(); MM:CoordsSize() end,
					},
					fontOutline = {
						order = 3,
						name = L["Font Outline"],
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
	}
end

T.tinsert(SLE.Configs, configTable)