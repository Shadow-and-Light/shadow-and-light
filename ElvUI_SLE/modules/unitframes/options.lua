local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
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

E.Options.args.sle.args.unitframes = {
	type = "group",
	name = L["UnitFrames"],
	order = 100,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Additional unit frames options"],
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
			func = function() E:GetModule('SLE'):Reset(nil, true) end,
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
E.Options.args.sle.args.unitframes.args.druid = {
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

if CAN_HAVE_CLASSBAR then
E.Options.args.sle.args.unitframes.args.classbar = {
	order = 6,
	type = "group",
	name = L["Classbar Offset"],
	guiInline = true,
	args = {
		info = {
			order = 1,
			type = "description",
			name = L["This options will allow you to detach your classbar from player's frame and move it in other location."],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.db.unitframe.units.player.classbar.offset end,
			set = function(info, value) E.db.unitframe.units.player.classbar.offset = value; UF:CreateAndUpdateUF('player') end,
		},
		xOffset = {
			order = 7,
			name = L['X Offset'],
			type = 'range',
			disabled = function() return not E.db.unitframe.units.player.classbar.offset end,
			min = -E.screenwidth, max = E.screenwidth, step = 1,
			get = function(info) return E.db.unitframe.units.player.classbar.xOffset end,
			set = function(info, value) E.db.unitframe.units.player.classbar.xOffset = value; UF:CreateAndUpdateUF('player') end,
		},
		yOffset = {
			order = 8,
			name = L['Y Offset'],
			type = 'range',
			disabled = function() return not E.db.unitframe.units.player.classbar.offset end,
			min = -E.screenheight, max = E.screenheight, step = 1,
			get = function(info) return E.db.unitframe.units.player.classbar.yOffset end,
			set = function(info, value) E.db.unitframe.units.player.classbar.yOffset = value; UF:CreateAndUpdateUF('player') end,
		},				
	},
}
end
end

table.insert(E.SLEConfigs, configTable)