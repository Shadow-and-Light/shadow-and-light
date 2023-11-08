local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Armory = SLE.Armory_Core
local IA = SLE.Armory_Inspect
local M = E.Misc

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory.args.inspect = {
		type = 'group',
		name = L["Inspect Armory"],
		order = 20,
		disabled = function() return not E.db.sle.armory.inspect.enable end,
		hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
		args = {
			header = ACH:Header(L["Inspect Armory"], 1),
			showWarning = {
				order = 2,
				type = 'toggle',
				name = L["Show Warning Icon"],
				desc = L["Show Missing Enchants or Gems"],
				get = function(info) return E.db.sle.armory.inspect[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info])] = value; M:UpdateInspectInfo() end,
			},
			ilvl = {
				type = 'group',
				name = L["Item Level"],
				order = 10,
				get = function(info) return E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; IA:Update_ItemLevel(); Armory:UpdateSharedStringsFonts("Inspect") end,
				disabled = function() return E.db.general.itemLevel.displayInspectInfo == false or not E.db.sle.armory.inspect.enable end,
				args = {
					colorType = {
						type = 'select',
						name = L["Item Level Coloring"],
						order = 7,
						set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; M:UpdateInspectInfo() end,
						values = {
							["NONE"] = NONE,
							["QUALITY"] = COLORBLIND_ITEM_QUALITY,
							["GRADIENT"] = L["Gradient"],
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
				get = function(info) return E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; IA:Update_Enchant(); Armory:UpdateSharedStringsFonts("Inspect") end,
				disabled = function() return E.db.general.itemLevel.displayInspectInfo == false or not E.db.sle.armory.inspect.enable end,
				args = {
					showReal = {
						order = 1,
						type = 'toggle',
						name = L["Display Quality"],
						desc = L["Displays the quality icon at the end of the enchant string, exactly as it appears when you mouse over the item slot itself and view the tooltip."],
						set = function(info, value) E.db.sle.armory.inspect[(info[#info-1])][(info[#info])] = value M:UpdatePageInfo(_G.InspectFrame, 'Inspect') end,
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
				get = function(info) return E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; IA:Update_Gems() end,
				disabled = function() return E.db.general.itemLevel.displayInspectInfo == false or not E.db.sle.armory.inspect.enable end,
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
				get = function(info) return E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; Armory:UpdatePageInfo(_G.InspectFrame, 'Inspect') end,
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
						disabled = function() return not E.db.sle.armory.inspect.transmog.enableGlow end,
					},
					glowOffset = {
						type = 'range',
						name = L["Glow Offset"],
						order = 4,
						min = -2,max = 4,step = 1,
						disabled = function() return not E.db.sle.armory.inspect.transmog.enableGlow end,
					},
				},
			},
			gradient = {
				type = 'group',
				name = L["Gradient"],
				order = 14,
				get = function(info) return E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = value; M:UpdateInspectInfo() end,
				disabled = function() return not E.db.sle.armory.inspect.enable end,
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
						get = function(info) return unpack(E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])]) end,
						set = function(info, r, g, b, a) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateInspectInfo() end,
						disabled = function() return not E.db.sle.armory.inspect.gradient.enable end,
					},
					quality = {
						type = 'toggle',
						name = COLORBLIND_ITEM_QUALITY,
						order = 3,
						disabled = function() return not E.db.sle.armory.inspect.gradient.enable end,
					},
					setArmor = {
						type = 'toggle',
						name = L["Armor Set"],
						order = 5,
						disabled = function() return E.db.sle.armory.inspect.enable == false or E.db.sle.armory.inspect.gradient.enable == false end,
					},
					setArmorColor = {
						type = 'color',
						name = L["Armor Set Gradient Texture Color"],
						order = 6,
						get = function(info)
							return unpack(E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateInspectInfo() end,
						disabled = function() return not E.db.sle.armory.inspect.enable or not E.db.sle.armory.inspect.gradient.enable or not E.db.sle.armory.inspect.gradient.setArmor end,
					},
					warningColor = {
						type = 'color',
						name = L["Warning Gradient Texture Color"],
						order = 7,
						get = function(info)
							return unpack(E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateInspectInfo() end,
						disabled = function() return not E.db.sle.armory.inspect.enable or not E.db.sle.armory.inspect.gradient.enable end,
					},
					warningBarColor = {
						type = 'color',
						name = L["Warning Bar Color"],
						order = 8,
						get = function(info)
							return unpack(E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])])
						end,
						set = function(info, r, g, b, a) E.db.sle.armory.inspect[(info[#info - 1])][(info[#info])] = { r, g, b, a }; M:UpdateInspectInfo() end,
						disabled = function() return not E.db.sle.armory.inspect.enable or not E.db.sle.armory.inspect.gradient.enable end,
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
						get = function() return E.db.sle.armory.inspect.background.selectedBG end,
						set = function(_, value) E.db.sle.armory.inspect.background.selectedBG = value; IA:Update_BG() end,
						values = function() return SLE.ArmoryConfigBackgroundValues.BackgroundValues end,
					},
					customTexture = {
						type = 'input',
						name = L["Custom Texture"],
						order = 2,
						get = function() return E.db.sle.armory.inspect.background.customTexture end,
						set = function(_, value) E.db.sle.armory.inspect.background.customTexture = value; IA:Update_BG() end,
						width = 'double',
						hidden = function() return E.db.sle.armory.inspect.background.selectedBG ~= 'CUSTOM' end
					},
					overlay = {
						type = 'toggle',
						order = 3,
						name = L["Overlay"],
						desc = L["Show ElvUI skin's backdrop overlay"],
						get = function() return E.db.sle.armory.inspect.background.overlay end,
						set = function(_, value) E.db.sle.armory.inspect.background.overlay = value; IA:ElvOverlayToggle() end
					},
				}
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
