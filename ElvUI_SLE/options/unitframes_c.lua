local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames')
local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" or E.myclass == 'MAGE')

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
		NONE = L['Hide']
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
				order = 5,
				type = "group",
				name = L["Player Frame Indicators"],
				guiInline = true,
				args = {
					combaticopos = {
						order = 6,
						type = "select",
						name = L["Combat Position"],
						desc = L["Set the point to show combat icon"],
						get = function(info) return E.db.sle.combatico.pos end,
						set = function(info, value) E.db.sle.combatico.pos = value; UF:Update_CombatIndicator() end,
						values = positionValues
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
					name = L["Enable"],
					desc = L["Show/hide the text with exact number of energy (Solar/Lunar or Demonic Fury) on your Classbar."],
					get = function(info) return E.db.sle.powtext end,
					set = function(info, value) E.db.sle.powtext = value; UF:ClassbarTextSLE() end,
				},
			},
		}
	end
end

table.insert(E.SLEConfigs, configTable)