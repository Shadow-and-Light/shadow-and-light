local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')
local function configTable()

--UI Buttons
E.Options.args.sle.args.characterframeoptions = {
	type = "group",
	name = L["Character Frame"],
	order = 12,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Character Frame Options"],
		},
		intro = {
			order = 2,
			type = 'description',
			name = L['CFO_DESC'],
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable/Disable Character Frame Options"],
			get = function(info) return E.private.sle.characterframeoptions.enable end,
			set = function(info, value) E.private.sle.characterframeoptions.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		itemlevel = {
			type = "group",
			--name = L["Item Level"],
			name = STAT_AVERAGE_ITEM_LEVEL,
			order = 4,
			guiInline = true,
			disabled = function() return not E.private.sle.characterframeoptions.enable end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					--desc = L["Show/Hide Item Levels"],
					get = function(info) return E.db.sle.characterframeoptions.itemlevel.enable end,
					set = function(info, value) E.db.sle.characterframeoptions.itemlevel.enable = value; CFO:ToggleCFO() end
				},
				fontGroup = {
					order = 2,
					type = 'group',
					guiInline = true,
					disabled = function() return not E.db.sle.characterframeoptions.itemlevel.enable end,
					name = L['Font'],
					args = {
						font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							--name = L["Fonts"],
							name = L["Font"],
							desc = L["The font that the item level will use."],
							values = AceGUIWidgetLSMlists.font,	
							get = function(info) return E.db.sle.characterframeoptions.itemlevel.font end,
							set = function(info, value) E.db.sle.characterframeoptions.itemlevel.font = value; CFO:UpdateItemLevelFont(); end,
						},
						fontSize = {
							order = 2,
							name = L["Font Size"],
							desc = L["Set the font size that the item level will use."],
							type = "range",
							min = 6, max = 22, step = 1,
							get = function(info) return E.db.sle.characterframeoptions.itemlevel.fontSize end,
							set = function(info, value) E.db.sle.characterframeoptions.itemlevel.fontSize = value; CFO:UpdateItemLevelFont(); end,
						},
						fontOutline = {
							order = 3,
							name = L["Font Outline"],
							desc = L["Set the font outline that the item level will use."],
							type = "select",
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROME'] = 'MONOCHROME',
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
							get = function(info) return E.db.sle.characterframeoptions.itemlevel.fontOutline end,
							set = function(info, value) E.db.sle.characterframeoptions.itemlevel.fontOutline = value; CFO:UpdateItemLevelFont(); end,
						},
					},
				},
			},
		},
		itemdurabilty = {
			type = "group",
			--name = L["Item Durability"],
			name = DURABILITY,
			order = 5,
			guiInline = true,
			disabled = function() return not E.private.sle.characterframeoptions.enable end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					--desc = L["Show/Hide Item Durability"],
					get = function(info) return E.db.sle.characterframeoptions.itemdurability.enable end,
					set = function(info, value) E.db.sle.characterframeoptions.itemdurability.enable = value; CFO:ToggleCFO() end,
				},
				fontGroup = {
					order = 2,
					type = 'group',
					guiInline = true,
					disabled = function() return not E.db.sle.characterframeoptions.itemdurability.enable end,
					name = L['Font'],
					args = {
						font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Font"],
							desc = L["The font that the item durability will use."],
							values = AceGUIWidgetLSMlists.font,	
							get = function(info) return E.db.sle.characterframeoptions.itemdurability.font end,
							set = function(info, value) E.db.sle.characterframeoptions.itemdurability.font = value; CFO:UpdateItemDurabilityFont(); end,
						},
						fontSize = {
							order = 2,
							name = L["Font Size"],
							desc = L["Set the font size that the item durability will use."],
							type = "range",
							min = 6, max = 22, step = 1,
							get = function(info) return E.db.sle.characterframeoptions.itemdurability.fontSize end,
							set = function(info, value) E.db.sle.characterframeoptions.itemdurability.fontSize = value; CFO:UpdateItemDurabilityFont(); end,
						},
						fontOutline = {
							order = 3,
							name = L["Font Outline"],
							desc = L["Set the font outline that the item durability will use."],
							type = "select",
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = 'OUTLINE',
								['MONOCHROME'] = 'MONOCHROME',
								['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
								['THICKOUTLINE'] = 'THICKOUTLINE',
							},
							get = function(info) return E.db.sle.characterframeoptions.itemdurability.fontOutline end,
							set = function(info, value) E.db.sle.characterframeoptions.itemdurability.fontOutline = value; CFO:UpdateItemDurabilityFont(); end,
						},
					},
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)