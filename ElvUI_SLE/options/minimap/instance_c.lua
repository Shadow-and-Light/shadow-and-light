local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local I= SLE:GetModule("InstDif")
local PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY4, PLAYER_DIFFICULTY5, PLAYER_DIFFICULTY6 = PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY4, PLAYER_DIFFICULTY5, PLAYER_DIFFICULTY6
local PLAYER_DIFFICULTY_TIMEWALKER = PLAYER_DIFFICULTY_TIMEWALKER
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.minimap.args.instance = {
		type = "group",
		name = L["Instance indication"],
		order = 7,
		get = function(info) return E.db.sle.minimap.instance[ info[#info] ] end,
		set = function(info, value) E.db.sle.minimap.instance[ info[#info] ] = value; I:UpdateFrame() end,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"],
				desc = L["Show instance difficulty info as text."],
				disabled = function() return not E.private.general.minimap.enable end,
			},
			flag = {
				order = 2,
				type = 'toggle',
				name = L["Show texture"],
				desc = L["Show instance difficulty info as default texture."],
				hidden = function() return not E.global.sle.advanced.general end,
				disabled = function() return not E.private.general.minimap.enable end,
			},
			xoffset = {
				order = 3, type = 'range', name = L["X-Offset"], min = -300, max = 300, step = 1,
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
			},
			yoffset = {
				order = 4, type = 'range', name = L["Y-Offset"], min = -300, max = 300, step = 1,
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
			},
			fontGroup = {
				order = 5,
				type = "group",
				name = L["Fonts"],
				guiInline = true,
				get = function(info) return E.db.sle.minimap.instance[ info[#info] ] end,
				set = function(info, value) E.db.sle.minimap.instance[ info[#info] ] = value; I:UpdateFrame() end,
				args = {
					font = {
						order = 1, type = "select", name = L["Font"], dialogControl = 'LSM30_Font', values = AceGUIWidgetLSMlists.font,
					},
					fontSize = {
						order = 2, type = "range", name = L["Font Size"], min = 6, max = 22, step = 1,
					},
					fontOutline = {
						order = 3, type = "select", name = L["Font Outline"], desc = L["Set the font outline."],
						values = {
							["NONE"] = L["None"],
							["OUTLINE"] = 'OUTLINE',
							["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
							["THICKOUTLINE"] = 'THICKOUTLINE',
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
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
				end,
				set = function(info, r, g, b, a)
					E.db.sle.minimap.instance.colors[ info[#info] ] = {}
					local t = E.db.sle.minimap.instance.colors[ info[#info] ]
					t.r, t.g, t.b, t.a = r, g, b, a
					I:GenerateText(nil, nil, true)
				end,
				disabled = function() return not E.private.general.minimap.enable or not E.db.sle.minimap.instance.enable end,
				args = {
					info = {
						order = 1, type = "description", name = L["Sets the colors for difficulty abbreviation"],
					},
					lfr = {
						type = "color", order = 2, name = PLAYER_DIFFICULTY3, hasAlpha = false,
					},
					normal = {
						type = "color", order = 3, name = PLAYER_DIFFICULTY1, hasAlpha = false,
					},
					heroic = {
						type = "color", order = 4, name = PLAYER_DIFFICULTY2, hasAlpha = false,
					},
					challenge = {
						type = "color", order = 5, name = PLAYER_DIFFICULTY5, hasAlpha = false,
					},
					mythic = {
						type = "color", order = 6, name = PLAYER_DIFFICULTY6, hasAlpha = false,
					},
					time = {
						type = "color", order = 6, name = PLAYER_DIFFICULTY_TIMEWALKER, hasAlpha = false,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)