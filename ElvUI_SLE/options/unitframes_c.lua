local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames')
local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" or E.myclass == 'MAGE')

local texPath = [[Interface\AddOns\ElvUI_SLE\media\textures\role\]]
local texPathE = [[Interface\AddOns\ElvUI\media\textures\]]

local function configTable()
	local positionValues = {
		TOPLEFT = 'TOPLEFT',
		LEFT = 'LEFT',
		BOTTOMLEFT = 'BOTTOMLEFT',
		RIGHT = 'RIGHT',
		TOPRIGHT = 'TOPRIGHT',
		BOTTOMRIGHT = 'BOTTOMRIGHT',
		CENTER = 'CENTER',
		TOP = 'TOP',
		BOTTOM = 'BOTTOM',
	};

	E.Options.args.sle.args.options.args.general.args.unitframes = {
		type = "group",
		name = L["UnitFrames"],
		order = 88,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["UnitFrames"],
			},
			info = {
				order = 2,
				type = "description",
				name = L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."],
			},
			Reset = {
				order = 3,
				type = 'execute',
				name = L['Restore Defaults'],
				desc = L["Reset these options to defaults"],
				func = function() E:GetModule('SLE'):Reset("unitframes") end,
			},
			indicators = {
				order = 4,
				type = "group",
				name = L["Player Frame Indicators"],
				guiInline = true,
				args = {
					combaticopos = {
						order = 1,
						type = "select",
						name = L["Combat Position"],
						desc = L["Set the point to show combat icon"],
						get = function(info) return E.db.sle.combatico.pos end,
						set = function(info, value) E.db.sle.combatico.pos = value; UF:Update_CombatIndicator() end,
						values = positionValues
					},
					roleicons = {
						order = 2,
						type = "select",
						name = L["LFG Icons"],
						desc = L["Choose what icon set will unitframes and chat use."],
						get = function(info) return E.db.sle.roleicons end,
						set = function(info, value) E.db.sle.roleicons = value; E:GetModule('Chat'):CheckLFGRoles(); UF:UpdateAllHeaders() end,
						values = {
							["ElvUI"] = "ElvUI ".."|T"..texPathE.."tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."dps:15:15:0:0:64:64:2:56:2:56|t ",
							["SupervillainUI"] = "Supervillain UI ".."|T"..texPath.."svui-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["Blizzard"] = "Blizzard ".."|T"..texPath.."blizz-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["MiirGui"] = "MiirGui ".."|T"..texPath.."mg-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-dps:15:15:0:0:64:64:2:56:2:56|t ",
						},
					},
				},
			},
		},
	}

	if E.myclass == "DRUID" or E.myclass == "WARLOCK" then
		E.Options.args.sle.args.options.args.general.args.unitframes.args.druid = {
			order = 7,
			type = 'group',
			name = L["Classbar Energy"],
			guiInline = true,
			args = {
				powtext = {
					order = 1,
					type = "toggle",
					name = ENABLE,
					desc = L["Show/hide the text with exact number of energy (Solar/Lunar or Demonic Fury) on your Classbar."],
					get = function(info) return E.db.sle.powtext end,
					set = function(info, value) E.db.sle.powtext = value; UF:ClassbarTextSLE() end,
				},
			},
		}
	end
end

table.insert(E.SLEConfigs, configTable)