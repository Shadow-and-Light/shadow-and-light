local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P['sle'] = {
	--Background frames
	['backgrounds'] = {
		['bottom'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/4 + 32,
			['height'] = E.screenheight/6 - 13,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
		},
		['left'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
		},
		['right'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
		},
		['action'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/4 + 32,
			['height'] = E.screenheight/20 + 5,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
		},
	},

	--Caster Name
	['castername'] = false,
	
	--Raid marks
	['marks'] = {
		['enabled'] = true,
		['growth'] = "RIGHT",
		['showinside'] = false,
		['size'] = 18,
	},
	
	--Exp/Rep Bar
	['exprep'] = {
		['explong'] = false,
		['replong'] = false,
	},
	
	--Power text on classbars
	['powtext'] = false;
	
	--Auto release
	['pvpautorelease'] = true,
	
	--Datatexts panels
	['datatext'] = {
		['dp1'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},	
		['dp2'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},
		['top'] = {
			['enabled'] = true,
			['width'] = E.screenwidth/5 - 4,
		},
		['dp3'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},
		['dp4'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},	
		['dp5'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
		},	
		['bottom'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/10 - 4,
		},
		['dp6'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
		},
		['chatleft'] = {
			['enabled'] = true,
			['width'] = 396,
		},
		['chatright'] = {
			['enabled'] = true,
			['width'] = 396,
		},
		['dashboard'] = {
			['enable'] = false,
			['width'] = 100,
		},
	},
	
	--Combat Icon
	['combatico'] = {
		['pos'] = 'TOP',
	},
	
	--UI Buttons
	['uibuttons'] = {
		['enable'] = false,
		['size'] = 17,
		['mouse'] = false,
		['position'] = "uib_vert",
	},

	--Autoloot
	['lootwin'] = false,
	['lootalpha'] = 1,
	
	--Error messages
	['errors'] = false,
}

--For some reason datatext settings refuses to work if there is no general setting block here O_o
--Core
P['general'] = {
	["taintLog"] = false,
	["autoscale"] = true,
	["stickyFrames"] = true,
	['loginmessage'] = true,
	["interruptAnnounce"] = "NONE",
	["autoRepair"] = "NONE",
	['autoRoll'] = false,
	['vendorGrays'] = false,
	['autoAcceptInvite'] = false,
	['bottomPanel'] = false,

	["fontSize"] = 12,
	["font"] = "ElvUI Font",

	["bordercolor"] = { r = 0.1,g = 0.1,b = 0.1 },
	["backdropcolor"] = { r = 0.1,g = 0.1,b = 0.1 },
	["backdropfadecolor"] = { r = .054,g = .054,b = .054, a = 0.8 },
	["valuecolor"] = {r = 23/255,g = 132/255,b = 209/255},
	
	['mapAlpha'] = 1,
	['tinyWorldMap'] = true,
	
	['minimap'] = {
		['size'] = 176,
		['locationText'] = 'MOUSEOVER',
	},	
	
	['experience'] = {
		['enable'] = true,
		['width'] = 475,
		['height'] = 10,
		['textFormat'] = 'NONE',
		['textSize'] = 11,
	},
	['reputation'] = {
		['enable'] = true,
		['width'] = 475,
		['height'] = 10,
		['textFormat'] = 'NONE',
		['textSize'] = 11,
	},
	['threat'] = {
		['enable'] = true,
		['position'] = 'RIGHTCHAT',
		['textSize'] = 12,
	},
	['totems'] = {
		['enable'] = true,
		['growthDirection'] = 'VERTICAL',
		['sortDirection'] = 'ASCENDING',
		['size'] = 40,
		['spacing'] = 4,
	}
};

P.chat.editboxhistory = 5
P.auras.perRow = 19

--Datatexts
P['datatexts'] = {
	['font'] = 'ElvUI Font',
	['fontSize'] = 12,
	['fontOutline'] = 'NONE',
	
	['panels'] = {
		['LeftChatDataPanel'] = {
			['left'] = 'Armor',
			['middle'] = 'Durability',
			['right'] = 'Avoidance',
		},
		['RightChatDataPanel'] = {
			['left'] = 'System',
			['middle'] = 'Time',	
			['right'] = 'Gold',
		},
		['DP_1'] = {
			['left'] = 'Swatter',
			['middle'] = 'Skada',
			['right'] = 'MrtWoo',
		},
		['DP_2'] = {
			['left'] = 'Altoholic',
			['middle'] = 'TellMeWhen',
			['right'] = 'AtlasLoot',
		},
		['DP_3'] = {
			['left'] = 'Notes',
			['middle'] = 'DBM-LDB',
			['right'] = 'WIM',
		},
		['DP_4'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
		['DP_5'] = {
			['left'] = 'Bags',
			['middle'] = 'Gold',
			['right'] = 'Armor',
		},
		['DP_6'] = {
			['left'] = 'Spell/Heal Power',
			['middle'] = 'Haste',
			['right'] = 'Crit Chance',
		},
		['Bottom_Panel'] = 'System',
		['LeftMiniPanel'] = 'Guild',
		['RightMiniPanel'] = 'Friends',
	},
	['localtime'] = true,
	['time24'] = false,
	['battleground'] = true,
	['minimapPanels'] = true,
	['leftChatPanel'] = true,
	['rightChatPanel'] = true,
}

P.unitframe.units.player.classbar.xOffset = 0
P.unitframe.units.player.classbar.yOffset = 0
P.unitframe.units.player.classbar.offset = false
P.unitframe.units.player.fixTo = "health"
P.unitframe.units.target.fixTo = "health"
P.unitframe.units.targettarget.fixTo = "health"
P.unitframe.units.focus.fixTo = "health"
P.unitframe.units.arena.fixTo = "health"
P.unitframe.units.boss.fixTo = "health"