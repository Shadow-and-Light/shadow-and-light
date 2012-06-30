local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames')

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
		health = {
			type = "group",
			name = L["Health Values"],
			order = 3,
			guiInline = true,
			args = {
				normal = {
					order = 1,
					type = "toggle",
					name = L["Full value"],
					desc = L["Enabling this will show exact hp numbers on player, focus, focus target, target of target, party, boss, arena and raid frames."],
					get = function(info) return E.db.sle.unitframes.normal.health end,
					set = function(info, value) E.db.sle.unitframes.normal.health = value; UF:Update_AllFrames() end
				},
				reverse = {
					order = 2,
					type = "toggle",
					name = L["Target full value"],
					desc = L["Enabling this will show exact hp numbers on target frame."],
					get = function(info) return E.db.sle.unitframes.reverse.health end,
					set = function(info, value) E.db.sle.unitframes.reverse.health = value; UF:Update_AllFrames() end
				},
			},
		},
		resource = {
			type = "group",
			name = L["Power Values"],
			order = 4,
			guiInline = true,
			args = {
				normal = {
					order = 1,
					type = "toggle",
					name = L["Normal Frames"],
					desc = L["Enabling this will show exact power numbers on target of target, focus and focus target frames."],
					get = function(info) return E.db.sle.unitframes.normal.mana end,
					set = function(info, value) E.db.sle.unitframes.normal.mana = value; UF:Update_AllFrames() end
				},
				reverse = {
					order = 2,
					type = "toggle",
					name = L["Reversed Frames"],
					desc = L["Enabling this will show exact power numbers on player, boss, arena, party and raid frames."],
					get = function(info) return E.db.sle.unitframes.reverse.mana end,
					set = function(info, value) E.db.sle.unitframes.reverse.mana = value; UF:Update_AllFrames() end
				},
			},
		},
		indicators = {
			order = 5,
			type = "group",
			name = L["Player Frame Indicators"],
			guiInline = true,
			args = {
				pvpmouse = {
					order = 1,
					type = "toggle",
					name = L["PvP text on mouse over"],
					desc = L["Show PvP text on mouse over player frame."],
					get = function(info) return E.db.sle.pvp.mouse end,
					set = function(info, value) E.db.sle.pvp.mouse = value; end,
				},
				pvp = {
					order = 3,
					type = "select",
					name = L["PvP Position"],
					desc = L["Set the point to show pvp text"],
					get = function(info) return E.db.sle.pvp.pos end,
					set = function(info, value) E.db.sle.pvp.pos = value; end,
					values = positionValues
				},
				combatico = {
					order = 4,
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

if E.myclass == "DRUID" then
E.Options.args.sle.args.unitframes.args.druid = {
	order = 7,
	type = 'group',
	name = L["Balance Power Text"],
	guiInline = true,
	args = {
		bpenable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Show/hide the text with exact number of your Solar/Lunar energy on your Classbar."],
			get = function(info) return E.db.sle.bpenable end,
			set = function(info, value) E.db.sle.bpenable = value; end,
		},
	},
}
end

if E.myclass == "PALADIN" or E.myclass == "WARLOCK" or E.myclass == "DEATHKNIGHT" or E.myclass == "SHAMAN" or E.myclass == "DRUID" then
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