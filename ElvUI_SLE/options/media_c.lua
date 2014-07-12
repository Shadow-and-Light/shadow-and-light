local E, L, V, P, G, _ = unpack(ElvUI);
local function configTable()

E.Options.args.sle.args.media = {
	type = "group",
    name = L["Media"],
    order = 3,
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
		fonts = {
			type = "group",
			name = L["Fonts"],
			order = 3,
			guiInline = true,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "Enables replacement of some fonts. Please note that these options will take effect only after reload of your UI.",
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function(info) return E.global.sle.fonts.enable end,
					set = function(info, value) E.global.sle.fonts.enable = value; E:StaticPopup_Show("GLOBAL_RL") end
				},
				zone = {
					type = "group",
					name = "Zone Text",
					order = 3,
					guiInline = true,
					disabled = function() return not E.global.sle.fonts.enable end,
					args = {
						font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Default Font"],
							values = AceGUIWidgetLSMlists.font,	
							get = function(info) return E.global.sle.fonts.zone.font end,
							set = function(info, value) E.global.sle.fonts.zone.font = value; E:StaticPopup_Show("GLOBAL_RL") end,
						},
						size = {
							order = 2,
							name = L["Font Size"],
							type = "range",
							min = 6, max = 48, step = 1,
							get = function(info) return E.global.sle.fonts.zone.size end,
							set = function(info, value) E.global.sle.fonts.zone.size = value; E:StaticPopup_Show("GLOBAL_RL") end,
						},
						outline = {
							order = 3,
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							type = "select",
							get = function(info) return E.global.sle.fonts.zone.outline end,
							set = function(info, value) E.global.sle.fonts.zone.outline = value; E:StaticPopup_Show("GLOBAL_RL") end,
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = 'OUTLINE',
								
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
						},
					},
				},
				subzone = {
					type = "group",
					name = "Subzone Text",
					order = 4,
					guiInline = true,
					disabled = function() return not E.global.sle.fonts.enable end,
					args = {
						font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Default Font"],
							values = AceGUIWidgetLSMlists.font,	
							get = function(info) return E.global.sle.fonts.subzone.font end,
							set = function(info, value) E.global.sle.fonts.subzone.font = value; E:StaticPopup_Show("GLOBAL_RL") end,
						},
						size = {
							order = 2,
							name = L["Font Size"],
							type = "range",
							min = 6, max = 48, step = 1,
							get = function(info) return E.global.sle.fonts.subzone.size end,
							set = function(info, value) E.global.sle.fonts.subzone.size = value; E:StaticPopup_Show("GLOBAL_RL") end,
						},
						outline = {
							order = 3,
							name = L["Font Outline"],
							desc = L["Set the font outline."],
							type = "select",
							get = function(info) return E.global.sle.fonts.subzone.outline end,
							set = function(info, value) E.global.sle.fonts.subzone.outline = value; E:StaticPopup_Show("GLOBAL_RL") end,
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