local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Armory = SLE.Armory_Core
local CA = SLE.Armory_Character
local M = E.Misc

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory.args.character = {
		type = 'group',
		name = L["Character Armory"],
		order = 10,
		disabled = function() return not E.db.sle.armory.character.enable end,
		hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
		args = {
			header = ACH:Header(L["Character Armory"], 1),
			showWarning = {
				order = 2,
				type = 'toggle',
				name = L["Show Warning Icon"],
				desc = L["Show Missing Enchants or Gems"],
				get = function(info) return E.db.sle.armory.character[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info])] = value; M:UpdateCharacterInfo() end,
			},
			ilvl = {
				type = 'group',
				name = L["Item Level"],
				order = 10,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_ItemLevel(); Armory:UpdateSharedStringsFonts("Character") end,
				disabled = function() return E.db.general.itemLevel.displayCharacterInfo == false or not E.db.sle.armory.character.enable end,
				args = {
					colorType = {
						type = 'select',
						name = L["Item Level Coloring"],
						order = 1,
						set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; M:UpdateCharacterInfo() end,
						values = {
							NONE = NONE,
							QUALITY = COLORBLIND_ITEM_QUALITY,
							GRADIENT = L["Gradient"],
						},
					},
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 10,
						min = -40, max = 150, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 11,
						min = -22, max = 3, step = 1,
					},
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						order = 20,
						values = function() return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {} end,
					},
					fontSize = {
						type = 'range',
						name = L["Font Size"],
						order = 21,
						min = 6, max = 22, step = 1,
					},
					fontStyle = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 22),
				}
			},
			enchant = {
				type = 'group',
				name = L["Enchant String"],
				order = 11,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_Enchant(); Armory:UpdateSharedStringsFonts("Character") end,
				disabled = function() return E.db.general.itemLevel.displayCharacterInfo == false or not E.db.sle.armory.character.enable end,
				args = {
					showReal = {
						order = 1,
						type = 'toggle',
						name = L["Display Quality"],
						desc = L["Displays the quality icon at the end of the enchant string, exactly as it appears when you mouse over the item slot itself and view the tooltip."],
						set = function(info, value) E.db.sle.armory.character[(info[#info-1])][(info[#info])] = value M:UpdatePageInfo(_G.CharacterFrame, 'Character') end,
					},
					spacer1 = {
						name = ' ',
						type = 'description',
						order = 2,
						width = 'full',
					},
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						order = 3,
						values = function() return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {} end,
					},
					fontStyle = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 4),
					fontSize = {
						type = 'range',
						name = L["Font Size"],
						order = 5,
						min = 6, max = 22, step = 1,
					},
					spacer2 = {
						name = ' ',
						type = 'description',
						order = 6,
						width = 'full',
					},
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 7,
						min = -2, max = 40, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 8,
						min = -13, max = 13, step = 1,
					},
				}
			},
			gem = {
				type = 'group',
				name = L["Gem Sockets"],
				order = 12,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_Gems() end,
				disabled = function() return E.db.general.itemLevel.displayCharacterInfo == false or not E.db.sle.armory.character.enable end,
				args = {
					size = {
						type = 'range',
						name = L["Size"],
						order = 1,
						min = 8, max = 30, step = 1,
					},
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 10,
						min = -40, max = 150, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 11,
						min = -3, max = 22, step = 1,
					},
				}
			},
			transmog = {
				order = 13,
				type = 'group',
				name = L["Transmog"],
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; Armory:UpdatePageInfo(_G.CharacterFrame, 'Character') end,
				args = {
					enableArrow = {
						order = 1,
						type = 'toggle',
						name = L["Enable Arrow"],
						desc = L["Enables a small arrow-like indicator on the item slot. Howering over this arrow will show the item this slot is transmogged into."],
					},
					enableGlow = {
						order = 2,
						type = 'toggle',
						name = L["Enable Glow"],
					},
					glowNumber = {
						type = 'range',
						name = L["Glow Number"],
						order = 3,
						min = 2,max = 8,step = 1,
						disabled = function() return not E.db.sle.armory.character.transmog.enableGlow end,
					},
					glowOffset = {
						type = 'range',
						name = L["Glow Offset"],
						order = 4,
						min = -2,max = 4,step = 1,
						disabled = function() return not E.db.sle.armory.character.transmog.enableGlow end,
					},
				},
			},
			gradient = {
				type = 'group',
				name = L["Gradient"],
				order = 14,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; M:UpdateCharacterInfo() end,
				args = {
					enable = {
						type = 'toggle',
						name = L["Enable"],
						order = 1,
					},
					color = {
						type = 'color',
						name = L["Gradient Texture Color"],
						order = 2,
						get = function(info)
							return unpack(E.db.sle.armory.character[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateCharacterInfo() end,
						disabled = function() return E.db.sle.armory.character.enable == false or E.db.sle.armory.character.gradient.enable == false end,
					},
					quality = {
						type = 'toggle',
						name = COLORBLIND_ITEM_QUALITY,
						order = 3,
						disabled = function() return E.db.sle.armory.character.enable == false or E.db.sle.armory.character.gradient.enable == false end,
					},
					setArmor = {
						type = 'toggle',
						name = L["Armor Set"],
						order = 5,
						disabled = function() return E.db.sle.armory.character.enable == false or E.db.sle.armory.character.gradient.enable == false end,
					},
					setArmorColor = {
						type = 'color',
						name = L["Armor Set Gradient Texture Color"],
						order = 6,
						get = function(info)
							return unpack(E.db.sle.armory.character[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateCharacterInfo() end,
						disabled = function() return not E.db.sle.armory.character.enable or not E.db.sle.armory.character.gradient.enable or not E.db.sle.armory.character.gradient.setArmor end,
					},
					warningColor = {
						type = 'color',
						name = L["Warning Gradient Texture Color"],
						order = 7,
						get = function(info)
							return unpack(E.db.sle.armory.character[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateCharacterInfo() end,
						disabled = function() return not E.db.sle.armory.character.enable or not E.db.sle.armory.character.gradient.enable end,
					},
					warningBarColor = {
						type = 'color',
						name = L["Warning Bar Color"],
						order = 8,
						get = function(info)
							return unpack(E.db.sle.armory.character[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateCharacterInfo() end,
						disabled = function() return not E.db.sle.armory.character.enable or not E.db.sle.armory.character.gradient.enable end,
					},
				}
			},
			durability = {
				type = 'group',
				name = DURABILITY,
				order = 15,
				get = function(info) return E.db.sle.armory.character.durability[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character.durability[(info[#info])] = value; M:UpdateCharacterInfo() end,
				args = {
					display = {
						type = 'select',
						name = L["Visibility"],
						order = 1,
						values = {
							Always = L["Always Display"],
							DamagedOnly = L["Only Damaged"],
							Hide = HIDE
						},
					},
					spacer1 = ACH:Spacer(2),
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						order = 3,
						values = function() return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {} end,
					},
					fontSize = {
						type = 'range',
						name = L["Font Size"],
						order = 4,
						min = 6, max = 22, step = 1,
					},
					fontStyle = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 5),
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 8,
						min = -2, max = 150, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 8,
						min = -22, max = 3, step = 1,
					},
				}
			},
			background = {
				type = 'group',
				name = L["Backdrop"],
				order = 20,
				args = {
					selectedBG = {
						type = 'select',
						name = L["Select Image"],
						order = 1,
						get = function() return E.db.sle.armory.character.background.selectedBG end,
						set = function(_, value) E.db.sle.armory.character.background.selectedBG = value; CA:Update_BG() end,
						values = function() return SLE.ArmoryConfigBackgroundValues.BackgroundValues end,
					},
					customTexture = {
						type = 'input',
						name = L["Custom Texture"],
						order = 2,
						get = function() return E.db.sle.armory.character.background.customTexture end,
						set = function(_, value) E.db.sle.armory.character.background.customTexture = value; CA:Update_BG() end,
						width = 'double',
						hidden = function() return E.db.sle.armory.character.background.selectedBG ~= 'CUSTOM' end
					},
					overlay = {
						type = 'toggle',
						order = 3,
						name = L["Overlay"],
						desc = L["Show ElvUI skin's backdrop overlay"],
						get = function() return E.db.sle.armory.character.background.overlay end,
						set = function(_, value) E.db.sle.armory.character.background.overlay = value; CA:ElvOverlayToggle() end
					},
				}
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
