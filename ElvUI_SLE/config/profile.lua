local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P['sle'] = {
	--Autoloot
	['lootwin'] = false,
	['lootalpha'] = 1,

	--Auto release
	['pvpautorelease'] = true,

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
			['template'] = "Default",
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
			['template'] = "Default",
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
			['template'] = "Default",
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
			['template'] = "Default",
		},
	},

	--Caster Name
	['castername'] = false,

	--Character Frame Options
	['characterframeoptions'] = {
		['shownormalgradient'] = true,
		['showerrorgradient'] = true,
		['showimage'] = true,
		['itemlevel'] = {
			["font"] = "ElvUI Pixel",
			["fontSize"] = 10,
			["fontOutline"] = "OUTLINE",
		},
		['itemdurability'] = {
			["font"] = "ElvUI Pixel",
			["fontSize"] = 10,
			["fontOutline"] = "OUTLINE",
		},
		['itemenchant'] = {
			['font'] = "Arial Narrow",
			['fontSize'] = 12,
			['fontOutline'] = "OUTLINE",
			['showwarning'] = true,
			['warningSize'] = 12,
		},
		['itemgem'] = {
			['showwarning'] = true,
			['socketSize'] = 12,
			['warningSize'] = 12,
		},
	},

	--Knightframe Adaption
	['KnightFrame_Armory'] = {
		['Enable'] = true,
		['NoticeMissing'] = true,
	},
	['KnightFrame_Inspect'] = {
		['Enable'] = true,
	},

	--Combat Icon
	['combatico'] = {
		['pos'] = 'TOP',
	},

	--Datatexts panels
	['datatext'] = {
		['dp1'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
		},	
		['dp2'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
		},
		['top'] = {
			['enabled'] = true,
			['width'] = E.screenwidth/5 - 4,
			['pethide'] = true,
		},
		['dp3'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
		},
		['dp4'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
		},	
		['dp5'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
			['pethide'] = true,
		},	
		['bottom'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/10 - 4,
			['pethide'] = true,
		},
		['dp6'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
			['pethide'] = true,
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
--E.db.sle.dt.guild.totals
	--DT Options
	['dt'] = {
		['friends'] = {
			['combat'] = false,
			['hideFriends'] = false,
			['sortBN'] = 'TOONNAME',
			['tooltipAutohide'] = 0.2,
			['totals'] = false,
		},
		['guild'] = {
			['combat'] = false,
			['hideGuild'] = false,
			['sortGuild'] = 'TOONNAME',
			['tooltipAutohide'] = 0.2,
			['totals'] = false,
		},
		['mail'] = {
			['icon'] = true,
		},
	},

	--Exp/Rep Bar
	['exprep'] = {
		['explong'] = false,
		['replong'] = false,
	},

	--Farm Module
	['farm'] = {
		['active'] = true,
		['size'] = 30,
		['autotarget'] = false,
		['seedor'] = "TOP",
		['quest'] = false,
	},

	--LFR options
	['lfrshow'] = {
		['enabled'] = false,
		['ds'] = false,
		['mv'] = false,
		['hof'] = false,
		['toes'] = false,
		['tot'] = false,
		['soo'] = false,
		['soof'] = false,
		['leishen'] = false,
	},

	--Minimap Module
	['minimap'] = {
		['enable'] = false,
		['coords'] = {
			['display'] = "SHOW",
			['middle'] = "CORNERS",
		},
		['buttons'] = {
			['anchor'] = "NOANCHOR",
			['size'] = 24,
			['mouseover'] = false,
		},
		['mapicons'] = {
			['iconmouseover'] = false,
			['iconsize'] = 27,
			['iconperrow'] = 12,
		},
	},

	--Power text on classbars
	['powtext'] = false;

	--Raid marks
	['marks'] = {
		['enabled'] = false,
		['growth'] = "RIGHT",
		['showinside'] = false,
		['size'] = 18,
	},

	['flares'] = {
		['enabled'] = false,
		['growth'] = "RIGHT",
		['showinside'] = false,
		['size'] = 20,
		['tooltips'] = true,
	},

	--UI Buttons
	['uibuttons'] = {
		['enable'] = false,
		['size'] = 17,
		['mouse'] = false,
		['position'] = "uib_vert",
		['spacing'] = 3,
	},
	
	--Loot
	['loot'] = {
		['quality'] = "EPIC",
		['chat'] = "RAID",
		['auto'] = true,
	},
	
	--Tooltip Faction Icon
	["tooltipicon"] = false,
}

P.chat.editboxhistory = 5
P.auras.perRow = 19

--Datatexts
P.datatexts.panels.DP_1 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.DP_2 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.DP_3 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.DP_4 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.DP_5 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.DP_6 = {
	['left'] = '',
	['middle'] = '',
	['right'] = '',
}
P.datatexts.panels.Top_Center = 'Version'
P.datatexts.panels.Bottom_Panel = ''