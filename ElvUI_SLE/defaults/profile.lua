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
			['width'] = (E.eyefinity or E.screenwidth)/4 + 32,
			['height'] = E.screenheight/6 - 13,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
			['template'] = "Default",
			['alpha'] = 1,
			['clickthrough'] = true,
		},
		['left'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = (E.eyefinity or E.screenwidth)/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
			['template'] = "Default",
			['alpha'] = 1,
			['clickthrough'] = false,
		},
		['right'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = (E.eyefinity or E.screenwidth)/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
			['template'] = "Default",
			['alpha'] = 1,
			['clickthrough'] = false,
		},
		['action'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = (E.eyefinity or E.screenwidth)/4 + 32,
			['height'] = E.screenheight/20 + 5,
			['xoffset'] = 0,
			['yoffset'] = 0,
			['pethide'] = true,
			['template'] = "Default",
			['alpha'] = 1,
			['clickthrough'] = true,
		},
	},

	--Chat
	['chat'] = {
		['guildmaster'] = false,
		['dpsSpam'] = false,
		['textureAlpha'] = {
			['enable'] = false,
			['alpha'] = 0.5,
		},
		['combathide'] = "NONE",
	},

	--Combat Icon
	['combatico'] = {
		['pos'] = 'TOP',
	},

	--Datatexts panels
	['datatext'] = {
		['dp1'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/5,
			['pethide'] = true,
			['alpha'] = 1,
		},	
		['dp2'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/5,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['top'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/5 - 4,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp3'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/5,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp4'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/5,
			['pethide'] = true,
			['alpha'] = 1,
		},	
		['dp5'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/4 - 60,
			['pethide'] = true,
			['alpha'] = 1,
		},	
		['bottom'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/10 - 4,
			['pethide'] = true,
			['alpha'] = 1,
		},
		['dp6'] = {
			['enabled'] = false,
			['width'] = (E.eyefinity or E.screenwidth)/4 - 60,
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
		['durability'] = {
			['gradient'] = false,
			['threshold'] = -1,
		}
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
		['leishen'] = false,
		['hm'] = false,
		['brf'] = false,
		['hfc'] = false,
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

	--Media
	['media'] = {
		['fonts'] = {
			['zone'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 32,
				['outline'] = "OUTLINE",
				['width'] = 512,
			},
			['subzone'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 25,
				['outline'] = "OUTLINE",
				['offset'] = 0,
				['width'] = 512,
			},
			['pvp'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 22,
				['outline'] = "OUTLINE",
				['width'] = 512,
			},
			['mail'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 12,
				['outline'] = "NONE",
			},
			['editbox'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 12,
				['outline'] = "NONE",
			},
			['gossip'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 12,
				['outline'] = "NONE",
			},
		},
		['screensaver'] = {
			['enable'] = false,
			['title'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 28,
				['outline'] = "OUTLINE",
			},
			['subtitle'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['date'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['player'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 15,
				['outline'] = "OUTLINE",
			},
			['tips'] = {
				['font'] = "PT Sans Narrow",
				['size'] = 20,
				['outline'] = "OUTLINE",
			},
			['playermodel'] = {
				['anim'] = 47,
				['position'] = "RIGHT",
				['distance'] = 1,
				['xaxis'] = -0.5,
				['yaxis'] = 0,
				['width'] = (E.eyefinity or E.screenwidth)/4,
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
			['colors'] = {
				['lfr'] = {r = 0.32,g = 0.91,b = 0.25 },
				['normal'] = {r = 0.09,g = 0.51,b = 0.82 },
				['heroic'] = {r = 0.82,g = 0.42,b = 0.16 },
				['challenge'] = {r = 0.9,g = 0.89,b = 0.27 },
				['mythic'] = {r = 0.9,g = 0.14,b = 0.15 },
			},
			['font'] = "PT Sans Narrow",
			['fontSize'] = 12,
			['fontOutline'] = "OUTLINE",
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

	--Raid Markers
	['raidmarkers'] = {
		['enable'] = true,
		['visibility'] = 'DEFAULT',
		['customVisibility'] = "[noexists, nogroup] hide; show",
		['backdrop'] = false,
		['buttonSize'] = 22,
		['spacing'] = 2,
		['orientation'] = 'HORIZONTAL',
		['modifier'] = 'shift-',
		['reverse'] = false,
	},

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
		['menuBackdrop'] = false,
		['dropdownBackdrop'] = false,
		['orientation'] = "vertical",
		['spacing'] = 3,
		['point'] = "TOPLEFT",
		['anchor'] = "TOPRIGHT",
		['xoffset'] = 0,
		['yoffset'] = 0,
		['customroll'] = {
			['min'] = "1",
			['max'] = "50",
		},
		['Config'] = {
			['enabled'] = false,
			['called'] = "Reload",
		},
		['Addon'] = {
			['enabled'] = false,
			['called'] = "Manager",
		},
		['Status'] = {
			['enabled'] = false,
			['called'] = "AFK",
		},
		['Roll'] = {
			['enabled'] = false,
			['called'] = "Hundred",
		},
	},

	['rumouseover'] = false,

	['bags'] = {
		['lootflash'] = true,
	},

	['garrison'] = {
		['autoOrder'] = false,
		['autoWar'] = false,
		['autoTrade'] = false,
		['autoShip'] = false,
	},

	['errorframe'] = {
		['height'] = 60,
		['width'] = 512,
	},

	['roleicons'] = "ElvUI",

	['quests'] = {
		['visibility'] = {
			['bg'] = "COLLAPSED",
			['arena'] = "COLLAPSED",
			['dungeon'] = "FULL",
			['raid'] = "COLLAPSED",
			['scenario'] = "FULL",
			['rested'] = "FULL",
			['garrison'] = "FULL",
		},
	},
	
	['raidmanager'] = {
		['level'] = true,
		['roles'] = false,
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