local E, L, V, P, G = unpack(ElvUI);

P['sle'] = {
	--Auras
	['auras'] = {
		['enable'] = false,
		['buffs'] = {
			['hideTimer'] = false,
		},
		['debuffs'] = {
			['hideTimer'] = false,
		},
		['tempenchants'] = {
			['hideTimer'] = false,
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
			['alpha'] = 1,
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
			['alpha'] = 1,
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
			['alpha'] = 1,
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
			['alpha'] = 1,
		},
	},

	--Caster Name
	['castername'] = false,

	--Character Frame Options
	['armory'] = {
		['character'] = {
			['gradientColor'] = { .41, .83, 1 },
		},
		['inspect'] = {
			['gradientColor'] = { .41, .83, 1 },
		},
	},
	['characterframeoptions'] = {
		['shownormalgradient'] = true,
		['showerrorgradient'] = true,
		['gradientColor'] = { .41, .83, 1 },
		['showimage'] = true,
		['image'] = {
			['dropdown'] = "SPACE",
			['custom'] = "",
		},
		['itemlevel'] = {
			['show'] = true,
			['font'] = "ElvUI Font",
			['fontSize'] = 10,
			['fontOutline'] = "OUTLINE",
		},
		['itemdurability'] = {
			['show'] = true,
			['font'] = "ElvUI Font",
			['fontSize'] = 10,
			['fontOutline'] = "OUTLINE",
		},
		['itemenchant'] = {
			['show'] = true,
			['font'] = "ElvUI Font",
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

	--Chat
	['chat'] = {
		['guildmaster'] = false,
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
			['alpha'] = 1,
		},	
		['dp2'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['top'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5 - 4,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp3'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp4'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
			['pethide'] = true,
			['alpha'] = 1,
		},	
		['dp5'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
			['pethide'] = true,
			['alpha'] = 1,
		},	
		['bottom'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/10 - 4,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp6'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['chatleft'] = {
			['enabled'] = true,
			['width'] = 396,
			['alpha'] = 1,
		},
		['chatright'] = {
			['enabled'] = true,
			['width'] = 396,
			['alpha'] = 1,
		},
		['dashboard'] = {
			['enable'] = false,
			['width'] = 100,
			['alpha'] = 1,
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

	--Flares (Raid)
	['flares'] = {
		['growth'] = "RIGHT",
		['showinside'] = false,
		['size'] = 20,
		['tooltips'] = true,
		['mouseover'] = false,
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

	--Loot (Restructured)
	['loot'] = {
		['enable'] = false,
		['autoroll'] = {
			['enable'] = true,
			['autoconfirm'] = false,
			['autode'] = false,
			['autogreed'] = false,
			['autoqlty'] = 2,
			['bylevel'] = false,
			['level'] = 1,
		},
		['announcer'] = {
			['auto'] = true,
			['channel'] = "RAID",
			['enable'] = false,
			['override'] = '5',
			['quality'] = "EPIC",
		},
		['history'] = {
			['alpha'] = 1,
			['autohide'] = false,
		},
	},

	--Marks (Raid)
	['marks'] = {
		['growth'] = "RIGHT",
		['showinside'] = false,
		['target'] = false,
		['size'] = 18,
		['mouseover'] = false,
	},

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
		['screensaver'] = {
			['enable'] = false,
			['title'] = {
				['font'] = "ElvUI Font",
				['size'] = 28,
				['outline'] = "OUTLINE",
			},
			['subtitle'] = {
				['font'] = "ElvUI Font",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['date'] = {
				['font'] = "ElvUI Font",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['player'] = {
				['font'] = "ElvUI Font",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['tips'] = {
				['font'] = "ElvUI Font",
				['size'] = 20,
				['outline'] = "OUTLINE",
			},
			['playermodel'] = {
				['anim'] = 47,
				['position'] = "RIGHT",
				['distance'] = 1,
				['xaxis'] = -0.5,
				['yaxis'] = 0,
				['width'] = E.screenwidth/4,
				['rotation'] = 0,
			},
			['crest'] = 128,
			['xpack'] = 150,
			['height'] = 135,
		},
	},

	--Minimap Module
	['minimap'] = {
		['enable'] = false,
		['combat'] = false,
		['alpha'] = 1,
		['coords'] = {
			['display'] = "SHOW",
			['middle'] = "CORNERS",
			['decimals'] = true,
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
		['instance'] = {
			['enable'] = false,
			['flag'] = true,
			['xoffset'] = -10,
			['yoffset'] = 0,
		},
	},

	--Nameplate Options
	['nameplate'] = {
		['showthreat'] = false,
		['targetcount'] = false,
	},

	--Power text on classbars
	['powtext'] = false,

	--PvP Auto release
	['pvpautorelease'] = true,

	--Threat
	['threat'] = {
		['enable'] = true,
		['position'] = "RightChatDataPanel",
	},

	--Tooltip
	['tooltip'] = {
		['enable'] = false,
		['showFaction'] = false,
		['xOffset'] = 0,
		['yOffset'] = 0,
	},
	--Tooltip Faction Icon
	--["tooltipicon"] = false,

	--UI Buttons
	['uibuttons'] = {
		['enable'] = false,
		['size'] = 17,
		['mouse'] = false,
		['position'] = "uib_vert",
		['spacing'] = 3,
		['point'] = "TOPLEFT",
		['anchor'] = "TOPRIGHT",
		['xoffset'] = 0,
		['yoffset'] = 0,
		['roll'] = {
			['min'] = "1",
			['max'] = "50",
		}
	},
	
	['rumouseover'] = false,

	['bags'] = {
		['lootshadow'] = true,
	},
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