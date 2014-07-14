local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P['sle'] = {
	--Autoloot
	['lootwin'] = false,
	['lootalpha'] = 1,

	--Auto release
	['pvpautorelease'] = true,
	
	--Media
	['media'] = {
		['fonts'] = {
			['zone'] = {
				['font'] = "ElvUI Font",
				['size'] = 32,
				['outline'] = "OUTLINE",
				['width'] = 512,
			},
			['subzone'] = {
				['font'] = "ElvUI Font",
				['size'] = 25,
				['outline'] = "OUTLINE",
				['offset'] = 0,
				['width'] = 512,
			},
			['pvp'] = {
				['font'] = "ElvUI Font",
				['size'] = 22,
				['outline'] = "OUTLINE",
				['width'] = 512,
			},
			['mail'] = {
				['font'] = "ElvUI Font",
				['size'] = 12,
				['outline'] = "NONE",
			},
			['editbox'] = {
				['font'] = "ElvUI Font",
				['size'] = 12,
				['outline'] = "NONE",
			},
		},
	},

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
		['image'] = {
			['dropdown'] = "SPACE",
			['custom'] = "",
		},
		['itemlevel'] = {
			['show'] = true,
			['font'] = "ElvUI Pixel",
			['fontSize'] = 10,
			['fontOutline'] = "OUTLINE",
		},
		['itemdurability'] = {
			['show'] = true,
			['font'] = "ElvUI Pixel",
			['fontSize'] = 10,
			['fontOutline'] = "OUTLINE",
		},
		['itemenchant'] = {
			['show'] = true,
			['font'] = "ElvUI Pixel",
			['fontSize'] = 10,
			['fontOutline'] = "OUTLINE",
			['showwarning'] = true,
			['warningSize'] = 12,
			['mouseover'] = false,
		},
		['itemgem'] = {	
			['show'] = true,
			['showwarning'] = true,
			['socketSize'] = 12,
			['warningSize'] = 12,
		},
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
		['chathandle'] = false,
	},

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
			['pethide'] = false,
			['skindungeon'] = false,
		},
	},

	--Nameplate Options
	['nameplate'] = {
		['showthreat'] = false,
		['targetcount'] = false,
	},
	--Power text on classbars
	['powtext'] = false,

	--Raid marks
	['marks'] = {
		['growth'] = "RIGHT",
		['showinside'] = false,
		['target'] = false,
		['size'] = 18,
		['mouseover'] = false,
	},

	['flares'] = {
		['growth'] = "RIGHT",
		['showinside'] = false,
		['size'] = 20,
		['tooltips'] = true,
		['mouseover'] = false,
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