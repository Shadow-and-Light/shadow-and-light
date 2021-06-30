local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SA = SLE.Armory_Stats
local M = E.Misc

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.armory.args.stats = {
		type = 'group',
		name = STAT_CATEGORY_ATTRIBUTES,
		order = 30,
		disabled = function() return SLE._Compatibility['DejaCharacterStats'] or not E.db.sle.armory.stats.enable end,
		hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
		get = function(info) return E.db.sle.armory.stats[info[#info]] end,
		set = function(info, value) E.db.sle.armory.stats[info[#info]] = value; PaperDollFrame_UpdateStats(); M:UpdateCharacterItemLevel() end,
		args = {
			OnlyPrimary = {
				order = 1,
				type = 'toggle',
				name = L["Only Relevant Stats"],
				desc = L["Show only those primary stats relevant to your spec."],
			},
			decimals = {
				order = 2,
				type = 'toggle',
				name = L["Decimals"],
				desc = L["Show stats with decimals."],
			},
			ItemLevel = {
				order = 10,
				type = 'group',
				name = STAT_AVERAGE_ITEM_LEVEL,
				guiInline = true,
				args = {
					IlvlFull = {
						order = 1,
						type = 'toggle',
						name = L["Full Item Level"],
						desc = L["Show both equipped and average item levels."],
					},
					IlvlColor = {
						order = 2,
						type = 'toggle',
						name = L["Item Level Coloring"],
						desc = L["Color code item levels values. Equipped will be gradient, average - selected color."],
						disabled = function() return SLE._Compatibility['DejaCharacterStats'] or not E.db.sle.armory.stats.IlvlFull or not E.db.sle.armory.stats.enable end,
					},
					AverageColor = {
						type = 'color',
						order = 3,
						name = L["Color of Average"],
						desc = L["Sets the color of average item level."],
						hasAlpha = false,
						disabled = function() return SLE._Compatibility['DejaCharacterStats'] or not E.db.sle.armory.stats.IlvlFull or not E.db.sle.armory.stats.enable end,
						get = function(info)
							local t = E.db.sle.armory.stats[info[#info]]
							local d = P.sle.armory.stats[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.db.sle.armory.stats[info[#info]] = {}
							local t = E.db.sle.armory.stats[info[#info]]
							t.r, t.g, t.b, t.a = r, g, b, a
							M:UpdateCharacterItemLevel()
							PaperDollFrame_UpdateStats()
						end,
					},
				},
			},
			Fonts = {
				type = 'group',
				name = STAT_CATEGORY_ATTRIBUTES..': '..L["Fonts"],
				guiInline = true,
				order = 20,
				args = {
					IlvlFont = {
						type = 'group',
						name = STAT_AVERAGE_ITEM_LEVEL,
						order = 1,
						-- guiInline = true,
						get = function(info) return E.db.sle.armory.stats.itemLevel[info[#info]] end,
						set = function(info, value) E.db.sle.armory.stats.itemLevel[info[#info]] = value; SA:UpdateIlvlFont() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["FONT_SIZE"],
								order = 2,
								min = 10, max = 22, step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = T.Values.FontFlags,
							},
						},
					},
					statFonts = {
						type = 'group',
						name = STAT_CATEGORY_ATTRIBUTES,
						order = 2,
						-- guiInline = true,
						get = function(info) return E.db.sle.armory.stats.statFonts[info[#info]] end,
						set = function(info, value) E.db.sle.armory.stats.statFonts[info[#info]] = value; SA:PaperDollFrame_UpdateStats() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["FONT_SIZE"],
								order = 2,
								min = 10, max = 22, step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = T.Values.FontFlags,
							},
						},
					},
					catFonts = {
						type = 'group',
						name = L["Categories"],
						order = 3,
						-- guiInline = true,
						get = function(info) return E.db.sle.armory.stats.catFonts[info[#info]] end,
						set = function(info, value) E.db.sle.armory.stats.catFonts[info[#info]] = value; SA:PaperDollFrame_UpdateStats() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["FONT_SIZE"],
								order = 2,
								min = 10, max = 22, step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = T.Values.FontFlags,
							},
						},
					},
				},
			},
			Lists = {
				order = 50,
				type = 'group',
				name = STAT_CATEGORY_ATTRIBUTES,
				childGroups = 'tab',
				guiInline = true,
				get = function(info) return E.db.sle.armory.stats.List[info[#info]] end,
				set = function(info, value) E.db.sle.armory.stats.List[info[#info]] = value; PaperDollFrame_UpdateStats() end,
				args = {
					Attributes = {
						order = 10,
						type = 'group',
						name = STAT_CATEGORY_ATTRIBUTES,
						args = {
							HEALTH = {
								order = 1,
								type = 'toggle',
								name = HEALTH,
							},
							POWER = {
								order = 2,
								type = 'toggle',
								name = function()
									local power = _G[select(2, UnitPowerType('player'))] or L["Power"]
									return power
								end,

							},
							ALTERNATEMANA = { order = 3,type = 'toggle',name = ALTERNATE_RESOURCE_TEXT,},
							MOVESPEED = { order = 4,type = 'toggle',name = STAT_SPEED,},
						},
					},
					Attack = {
						order = 11,
						type = 'group',
						name = STAT_CATEGORY_ATTACK,
						args = {
							ATTACK_DAMAGE = { order = 1,type = 'toggle',name = DAMAGE,},
							ATTACK_AP = { order = 2,type = 'toggle',name = ATTACK_POWER,},
							ATTACK_ATTACKSPEED = { order = 3,type = 'toggle',name = ATTACK_SPEED,},
							SPELLPOWER = { order = 4,type = 'toggle',name = STAT_SPELLPOWER,},
							MANAREGEN = { order = 5,type = 'toggle',name = MANA_REGEN,},
							ENERGY_REGEN = { order = 6,type = 'toggle',name = STAT_ENERGY_REGEN,},
							RUNE_REGEN = { order = 7,type = 'toggle',name = STAT_RUNE_REGEN,},
							FOCUS_REGEN = { order = 8,type = 'toggle',name = STAT_FOCUS_REGEN,},
						},
					},
					Enhancements = {
						order = 12,
						type = 'group',
						name = STAT_CATEGORY_ENHANCEMENTS,
						args = {
							CRITCHANCE = { order = 1,type = 'toggle',name = STAT_CRITICAL_STRIKE,},
							HASTE = { order = 2,type = 'toggle',name = STAT_HASTE,},
							MASTERY = { order = 3,type = 'toggle',name = STAT_MASTERY,},
							VERSATILITY = { order = 4,type = 'toggle',name = STAT_VERSATILITY,},
							LIFESTEAL = { order = 5,type = 'toggle',name = STAT_LIFESTEAL,},
						},
					},
					Defence = {
						order = 13,
						type = 'group',
						name = DEFENSE,
						args = {
							ARMOR = { order = 1,type = 'toggle',name = STAT_ARMOR,},
							AVOIDANCE = { order = 2,type = 'toggle',name = STAT_AVOIDANCE,},
							DODGE = { order = 3,type = 'toggle',name = STAT_DODGE,},
							PARRY = { order = 4,type = 'toggle',name = STAT_PARRY,},
							BLOCK = { order = 5,type = 'toggle',name = STAT_BLOCK,},
							-- STAGGER = { order = 6,type = 'toggle',name = STAT_STAGGER,},
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
