local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local MM = SLE.Minimap

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH
	E.Options.args.sle.args.modules.args.minimap.args.coords = {
		type = "group",
		name = L["Coordinates"],
		order = 5,
		disabled = function() return not E.private.general.minimap.enable end,
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
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				guiInline = true,
				disabled = function() return not E.db.sle.minimap.coords.enable or not E.private.general.minimap.enable end,
				get = function(info) return E.db.sle.minimap.coords[ info[#info] ] end,
				set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:UpdateSettings() end,
				args = {
					mouseover = {
						order = 1,
						type = "toggle",
						name = L["Mouseover"],
						desc = L["Show coordinates on minimap mouseover."],
						disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable end,
					},
					xOffset = {
						order = 2,
						type = 'range',
						name = L["X-Offset"],
						min = -200, max = 200, step = 1,
						disabled = function() return not E.db.sle.minimap.coords.enable or not E.private.general.minimap.enable end,
						set = function(info, value) E.db.sle.minimap.coords[info[#info]] = value; MM:UpdateCoordinatesPosition() end,
					},
					yOffset = {
						order = 3,
						type = 'range',
						name = L["Y-Offset"],
						min = -200, max = 200, step = 1,
						disabled = function() return not E.db.sle.minimap.coords.enable or not E.private.general.minimap.enable end,
						set = function(info, value) E.db.sle.minimap.coords[info[#info]] = value; MM:UpdateCoordinatesPosition() end,
					},
					format = {
						order = 4,
						name = L["Format"],
						type = "select",
						disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable end,
						set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:UpdateSettings(); MM:HandleEvent() end,
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
						disabled = function() return not E.db.sle.minimap.coords.enable or not E.private.general.minimap.enable end,
						set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value end,
					},
				},
			},
			fontGroup = {
				order = 10,
				type = "group",
				name = L["Fonts"],
				guiInline = true,
				disabled = function() return not E.db.sle.minimap.coords.enable or not E.private.general.minimap.enable end,
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
						set = function(info, value) E.db.sle.minimap.coords[ info[#info] ] = value; MM:CoordFont() end,
					},
					fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 3),
					color = {
						type = 'color',
						order = 4,
						name = L["Color"],
						get = function(info)
							local t = E.db.sle.minimap.coords[ info[#info] ]
							local d = P.sle.minimap.coords[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.db.sle.minimap.coords[ info[#info] ] = {}
							local t = E.db.sle.minimap.coords[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							MM:SetCoordsColor()
						end,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
