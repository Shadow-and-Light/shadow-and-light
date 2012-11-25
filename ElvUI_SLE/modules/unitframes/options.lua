local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UF = E:GetModule('UnitFrames')
local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" or E.myclass == 'MAGE')

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

local fixUn = {
	player = {"Player Frame", 2, "player"},
	target = {"Target Frame", 3, "target"},
	targettarget = {"TargetTarget Frame", 4, "targettarget"},
	focus = {"Focus Frame", 5, "focus"},
}

local fixGr = {
	arena = {"Arena Frames", 6, "arena", 5},
	boss = {"Boss Frames", 7, "boss", MAX_BOSS_FRAMES},
}


E.Options.args.sle.args.unitframes = {
	type = "group",
	name = L["UnitFrames"],
	order = 1,
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
		fix = {
			order = 8,
			type = "group",
			name = L["Power Text Position"],
			guiInline = true,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["Position power text on this bar of chosen frame"],
				},
			},
		},
	},
}

for k,v in pairs(fixUn) do
E.Options.args.sle.args.unitframes.args.fix.args[v[3]] = {
	order = v[2],
	type = "select",
	name = L[v[1]],
	get = function(info) return E.db.unitframe.units[v[3]].fixTo end,
	set = function(info, value) E.db.unitframe.units[v[3]].fixTo = value; UF:CreateAndUpdateUF(v[3]) end,
	values = {
		['health'] = L["Health"],
		['power'] = L["Power"],
	},
}
end

for k,v in pairs(fixGr) do
E.Options.args.sle.args.unitframes.args.fix.args[v[3]] = {
	order = v[2],
	type = "select",
	name = L[v[1]],
	get = function(info) return E.db.unitframe.units[v[3]].fixTo end,
	set = function(info, value) E.db.unitframe.units[v[3]].fixTo = value; UF:CreateAndUpdateUFGroup(v[3], v[4]) end,
	values = {
		['health'] = L["Health"],
		['power'] = L["Power"],
	},
}
end

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