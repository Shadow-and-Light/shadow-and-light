local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Armory = SLE:GetModule("Armory_Core")
local CA = SLE:GetModule("Armory_Character")
local M = E:GetModule("Misc")

local function configTable()
	if not SLE.initialized then return end
	
	E.Options.args.sle.args.modules.args.armory.args.character = {
		type = 'group',
		name = L["Character Armory"],
		order = 400,
		disabled = function() return E.db.sle.armory.character.enable == false end,
		args = {
			ilvl = {
				type = 'group',
				name = L["Item Level"],
				order = 1,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_ItemLevel() end,
				args = {
					colorType = {
						type = 'select',
						name = L["Item Level Coloring"],
						order = 7,
						set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; M:UpdateCharacterInfo() end,
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
				}
			},
			enchant = {
				type = 'group',
				name = L["Enchant String"],
				order = 2,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_Enchant() end,
				args = {
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 10,
						min = -2, max = 40, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 11,
						min = -13, max = 13, step = 1,
					},
				}
			},
			gem = {
				type = 'group',
				name = L["Gem Sockets"],
				order = 3,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; CA:Update_Gems() end,
				args = {
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
				order = 4,
				type = 'group',
				name = L["Transmog"],
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; Armory:UpdatePageInfo(_G.CharacterFrame, "Character") end,
				args = {
					enableGlow = {
						order = 1,
						type = "toggle",
						name = L["Enable Glow"],
					},
					enableArrow = {
						order = 2,
						type = "toggle",
						name = L["Enable Arrow"],
						desc = L["Enables a small arrow-like indicator on the item slot. Howering over this arrow will show the item this slot is transmogged into."],
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
			background = {
				type = 'group',
				name = L["Backdrop"],
				order = 10,
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
						name = L["Custom Image Path"],
						order = 2,
						get = function() return E.db.sle.armory.character.background.customTexture end,
						set = function(_, value) E.db.sle.armory.character.background.customTexture = value; CA:Update_BG() end,
						width = 'double',
						hidden = function() return E.db.sle.armory.character.background.selectedBG ~= 'CUSTOM' end
					},
					overlay = {
						type = "toggle",
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

T.tinsert(SLE.Configs, configTable)
