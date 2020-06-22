local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Armory = SLE:GetModule("Armory_Core")
local M = E:GetModule("Misc")
-- local CA = SLE:GetModule("Armory_Character")

local _G = _G
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory = {
		type = 'group',
		name = L["Armory Mode"],
		order = 1,
		childGroups = "tab",
		-- hidden = function() return not E.private.skins.blizzard.enable end,
		args = {
			desc = ACH:Description(L["SLE_Armory_Info"].."\n", 1, nil, nil, function() return not E.private.skins.blizzard.enable or (not E.private.skins.blizzard.character and not E.private.skins.blizzard.inspect) end),
			CA_enable = {
				type = "toggle",
				name = L["Character Armory"],
				order = 10,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
				get = function() return E.db.sle.armory.character.enable end,
				set = function(_, value)
					E.db.sle.armory.character.enable = value;
					SLE:GetModule("Armory_Character"):ToggleArmory();
					M:UpdatePageInfo(_G.CharacterFrame, "Character")
					if not E.db.general.itemLevel.displayCharacterInfo then M:ClearPageInfo(_G.CharacterFrame, "Character") end
				end,
			},
			IA_enable = {
				type = 'toggle',
				name = L["Inspect Armory"],
				order = 11,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
				get = function() return E.db.sle.armory.inspect.enable end,
				set = function(_, value)
					E.db.sle.armory.inspect.enable = value;
					SLE:GetModule("Armory_Inspect"):ToggleArmory();
					M:UpdatePageInfo(_G.InspectFrame, "Inspect") --Putting this under the elv's option check just breaks the shit out of the frame
					if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G.InspectFrame, "Inspect") end --Clear the infos if those are actually not supposed to be shown.
				end,
			},
			SA_enable = {
				type = 'toggle',
				name = STAT_CATEGORY_ATTRIBUTES,
				order = 12,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
				disabled = function() return (SLE._Compatibility["DejaCharacterStats"] or not E.private.skins.blizzard.enable) end,
				get = function() return E.db.sle.armory.stats.enable end,
				set = function(_, value) E.db.sle.armory.stats.enable = value; SLE:GetModule("Armory_Stats"):ToggleArmory(); end
			},
			corruption = {
				type = 'group',
				name = GetSpellInfo(172),
				order = 13,
				get = function(info) return E.db.sle.armory.character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; SLE:GetModule("Armory_Character"):UpdateCorruptionText(); SLE:GetModule("Armory_Character"):UpdateCorruptionLevel() end,
				disabled = function() return not (E.db.sle.armory.character.enable or E.db.sle.armory.stats.enable or SLE._Compatibility["DejaCharacterStats"]) end,
				args = {
					position = {
						type = 'select',
						name = L["Position"],
						order = 1,
						set = function(info, value) E.db.sle.armory.character[(info[#info - 1])][(info[#info])] = value; Armory:HandleCorruption() end,
						values = {
							["SLE"] = "S&L",
							["BLIZZARD"] = "Blizzard",
						},
					},
					valueColor = {
						type = 'toggle',
						name = L["Value Color"],
						order = 2,
					},
					style = {
						type = 'select',
						name = L["Text Format"],
						order = 3,
						values = {
							["TOTAL"] = TOTAL,
							["COR-RES"] = L["Corruption / Resist"],
							["Hide"] = HIDE,
						},
					},
					spacer1 = ACH:Spacer(4),
					xOffset = {
						type = 'range',
						name = L["X-Offset"],
						order = 10,
						min = -10, max = 70, step = 1,
					},
					yOffset = {
						type = 'range',
						name = L["Y-Offset"],
						order = 11,
						min = -40, max = 40, step = 1,
					},
					spacer2 = ACH:Spacer(15),
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
						min = 6, max = 32, step = 1,
					},
					fontStyle = {
						type = 'select',
						name = L["Font Outline"],
						order = 22,
						values = {
							NONE = NONE,
							OUTLINE = 'OUTLINE',
							MONOCHROMEOUTLINE = 'MONOCROMEOUTLINE',
							THICKOUTLINE = 'THICKOUTLINE'
						},
					},
				}
			},
			GoToElv = {
				order = 100,
				type = "execute",
				name = "ElvUI: "..L["Item Level"],
				func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "general", "blizzUIImprovements") end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return true end
					return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			},
			--In case some fucker disabled all the skins
			SkinsDisabled = ACH:Description("|cffff0000 !!!|r "..L["SLE_Armory_SkinDisabled"].." |cffff0000 !!!|r", 500, "medium", nil, nil, nil, nil, nil, function() if not E.private.skins.blizzard.enable then return false end return (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect) end),
			GoToElv_Skins = {
				order = 501,
				type = "execute",
				name = "ElvUI: "..L["Skins"],
				func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "skins") end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return false end
					return (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)