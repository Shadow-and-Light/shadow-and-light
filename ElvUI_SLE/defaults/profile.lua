local SLE, T, E, L, V, P, G = unpack(select(2, ...))

P["sle"] = {
	--Auras
	["auras"] = {
		["hideBuffsTimer"] = false,
		["hideDebuffsTimer"] = false,
	},
	--Screensaver
	["screensaver"] = {
			["keydown"] = false,
			["title"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 28,
				["outline"] = "OUTLINE",
			},
			["subtitle"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 15,
				["outline"] = "OUTLINE",
			},
			["date"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 15,
				["outline"] = "OUTLINE",
			},
			["player"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 15,
				["outline"] = "OUTLINE",
			},
			["tips"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 20,
				["outline"] = "OUTLINE",
			},
			["crest"] = 128,
			["xpack"] = 150,
			["height"] = 135,
			["playermodel"] = {
				["anim"] = 4,
				["distance"] = 4.5,
				["holderXoffset"] = 0,
				["holderYoffset"] = 0,
				["rotation"] = 0,
			},
			["animTime"] = 0,
			["animBounce"] = true,
			["animType"] = "SlideIn",
			["tipThrottle"] = 15,
			["panelTemplate"] = "Transparent",
		},
	--Backgrounds
	["backgrounds"] = {
		["bg1"] = {
			["enabled"] = false,
			["trans"] = false,
			["texture"] = "",
			["width"] = (E.eyefinity or E.screenwidth)/4 + 32,
			["height"] = E.screenheight/6 - 13,
			["xoffset"] = 0,
			["yoffset"] = 0,
			["pethide"] = true,
			["template"] = "Default",
			["alpha"] = 1,
			["clickthrough"] = true,
		},
		["bg2"] = {
			["enabled"] = false,
			["trans"] = false,
			["texture"] = "",
			["width"] = (E.eyefinity or E.screenwidth)/10 - 4,
			["height"] = E.screenheight/5 + 11,
			["xoffset"] = 0,
			["yoffset"] = 0,
			["pethide"] = true,
			["template"] = "Default",
			["alpha"] = 1,
			["clickthrough"] = false,
		},
		["bg3"] = {
			["enabled"] = false,
			["trans"] = false,
			["texture"] = "",
			["width"] = (E.eyefinity or E.screenwidth)/10 - 4,
			["height"] = E.screenheight/5 + 11,
			["xoffset"] = 0,
			["yoffset"] = 0,
			["pethide"] = true,
			["template"] = "Default",
			["alpha"] = 1,
			["clickthrough"] = false,
		},
		["bg4"] = {
			["enabled"] = false,
			["trans"] = false,
			["texture"] = "",
			["width"] = (E.eyefinity or E.screenwidth)/4 + 32,
			["height"] = E.screenheight/20 + 5,
			["xoffset"] = 0,
			["yoffset"] = 0,
			["pethide"] = true,
			["template"] = "Default",
			["alpha"] = 1,
			["clickthrough"] = true,
		},
	},
	--PvP
	["pvp"] = {
		["autorelease"] = false,
		["rebirth"] = true,
		["duels"] = {
			["regular"] = false,
			["pet"] = false,
			["announce"] = false,
		},
	},
	--Datatexts panels
	["datatexts"] = {
		["panel1"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/5,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel2"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/5,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel3"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/5 - 4,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel4"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/5,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel5"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/5,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel6"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/4 - 60,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel7"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/10 - 4,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			["mouseover"] = false,
		},
		["panel8"] = {
			["enabled"] = false,
			["width"] = (E.eyefinity or E.screenwidth)/4 - 60,
			["pethide"] = true,
			["alpha"] = 1,
			["transparent"] = false,
			["noback"] = false,
			
		},
		["leftchat"] = {
			["enabled"] = true,
			["width"] = 396,
			["alpha"] = 1,
		},
		["rightchat"] = {
			["enabled"] = true,
			["width"] = 396,
			["alpha"] = 1,
		},
		["chathandle"] = true,
	},
	--LFR options
	["lfr"] = {
		["enabled"] = false,
		["cata"] = {
			["ds"] = false,
		},
		["mop"] = {
			["mv"] = false,
			["hof"] = false,
			["toes"] = false,
			["tot"] = false,
			["soo"] = false,
		},
		["wod"] = {
			["hm"] = false,
			["brf"] = false,
			["hfc"] = false,
		},
		["legion"] = {
			["nightmare"] = false,
			["palace"] = false,
		},
	},
	--SLE Datatexts
	["dt"] = {
		["friends"] = {
			["combat"] = false,
			["expandBNBroadcast"] = false,
			["hideFriends"] = false,
			["hide_hintline"] = false,
			["sortBN"] = 'TOONNAME',
			["tooltipAutohide"] = 0.2,
			["totals"] = false,
		},
		["guild"] = {
			["combat"] = false,
			["hide_gmotd"] = false,
			["hideGuild"] = false,
			["hide_guildname"] = false,
			["hide_hintline"] = false,
			["sortGuild"] = 'TOONNAME',
			["tooltipAutohide"] = 0.2,
			["totals"] = false,
		},
		["mail"] = {
			["icon"] = true,
		},
		["durability"] = {
			["gradient"] = false,
			["threshold"] = -1,
		},
		["currency"] = {
			["Archaeology"] = true,
			["Jewelcrafting"] = true,
			["PvP"] = true,
			["Raid"] = true,
			["Cooking"] = true,
			["Miscellaneous"] = true,
			["Zero"] = true,
			["Icons"] = true,
			["Faction"] = true,
			["Unused"] = true,
		},
		["regen"] = {
			["short"] = false,
		},
	},
	--Misc
	["misc"] = {
		["threat"] = {
			["enable"] = false,
			["position"] = "RightChatDataPanel",
		},
		["viewport"] = {
			["left"] = 0,
			["right"] = 0,
			["top"] = 0,
			["bottom"] = 0,
		},
	},
	--Blizzard
	["blizzard"] = {
		["rumouseover"] = false,
		["errorframe"] = {
			["height"] = 60,
			["width"] = 512,
		},
		["vehicleSeatScale"] = 1,
	},
	--Chat
	["chat"] = {
		["guildmaster"] = false,
		["dpsSpam"] = false,
		["textureAlpha"] = {
			["enable"] = false,
			["alpha"] = 0.5,
		},
		["combathide"] = "NONE",
		["editboxhistory"] = 5,
		["justify"] = {
			["frame1"] = "LEFT",
			["frame2"] = "LEFT",
			["frame3"] = "LEFT",
			["frame4"] = "LEFT",
			["frame5"] = "LEFT",
			["frame6"] = "LEFT",
			["frame7"] = "LEFT",
			["frame8"] = "LEFT",
			["frame9"] = "LEFT",
			["frame10"] = "LEFT",
		},
		["tab"] = {
			["select"] = false,
			["style"] = "DEFAULT",
			["color"] = {r = 1, g = 1, b = 1},
		},
	},
	--Legacy
	["legacy"] = {
		["garrison"] = {
			["autoOrder"] = {
				["enable"] = false,
				["autoWar"] = false,
				["autoTrade"] = false,
				["autoShip"] = false,
			},
			["toolbar"] = {
				["buttonsize"] = 30,
				["active"] = true,
				["enable"] = false,
			},
		},
		["farm"] = {
			["active"] = true,
			["buttonsize"] = 30,
			["autotarget"] = false,
			["seedor"] = "TOP",
			["quest"] = false,
			["enable"] = false,
		},
	},
	--Nameplate Options
	["nameplate"] = {
		["showthreat"] = false,
		["targetcount"] = false,
	},
	--Loot 
	["loot"] = {
		["enable"] = false,
		["autoroll"] = {
			["enable"] = true,
			["autoconfirm"] = false,
			["autode"] = false,
			["autogreed"] = false,
			["autoqlty"] = 2,
			["bylevel"] = false,
			["level"] = 1,
		},
		["announcer"] = {
			["auto"] = true,
			["channel"] = "RAID",
			["enable"] = false,
			["override"] = '5',
			["quality"] = "EPIC",
		},
		["history"] = {
			["alpha"] = 1,
			["autohide"] = false,
		},
		["looticons"] = {
			["enable"] = false,
			["position"] = "LEFT",
			["size"] = 12,
			["channels"] = {
				["CHAT_MSG_BN_WHISPER"] = false,
				["CHAT_MSG_BN_WHISPER_INFORM"] = false,
				["CHAT_MSG_BN_CONVERSATION"] = false,
				["CHAT_MSG_CHANNEL"] = false,
				["CHAT_MSG_EMOTE"] = false,
				["CHAT_MSG_GUILD"] = false,
				["CHAT_MSG_INSTANCE_CHAT"] = false,
				["CHAT_MSG_INSTANCE_CHAT_LEADER"] = false,
				["CHAT_MSG_LOOT"] = true,
				["CHAT_MSG_OFFICER"] = false,
				["CHAT_MSG_PARTY"] = false,
				["CHAT_MSG_PARTY_LEADER"] = false,
				["CHAT_MSG_RAID"] = false,
				["CHAT_MSG_RAID_LEADER"] = false,
				["CHAT_MSG_RAID_WARNING"] = false,
				["CHAT_MSG_SAY"] = false,
				["CHAT_MSG_SYSTEM"] = true,
				["CHAT_MSG_WHISPER"] = false,
				["CHAT_MSG_WHISPER_INFORM"] = false,
				["CHAT_MSG_YELL"] = false,
			},
		},
	},
	--Datbars
	["databars"] = {
		["exp"] = {
			["longtext"] = false,
			["chatfilter"] = {
				["enable"] = false,
				["iconsize"] = 12,
				["style"] = "STYLE1",
			},
		},
		["rep"] = {
			["longtext"] = false,
			["autotrack"] = false,
			["chatfilter"] = {
				["enable"] = false,
				["iconsize"] = 12,
				["style"] = "STYLE1",
				["styleDec"] = "STYLE1",
				["showAll"] = false,
				["chatframe"] = "AUTO",
			},
		},
		["honor"] = {
			["longtext"] = false,
			["chatfilter"] = {
				["enable"] = false,
				["iconsize"] = 12,
				["style"] = "STYLE1",
				["awardStyle"] = "STYLE1",
			},
		},
		["artifact"] = {
			["longtext"] = false,
			["chatfilter"] = {
				["enable"] = false,
				["iconsize"] = 12,
				["style"] = "STYLE1",
			},
		},
	},
	--Raid Markers
	["raidmarkers"] = {
		["enable"] = true,
		["visibility"] = 'DEFAULT',
		["customVisibility"] = "[noexists, nogroup] hide; show",
		["backdrop"] = false,
		["buttonSize"] = 22,
		["spacing"] = 2,
		["orientation"] = 'HORIZONTAL',
		["modifier"] = 'shift-',
		["reverse"] = false,
	},
	--Quests
	["quests"] = {
		["visibility"] = {
			["bg"] = "COLLAPSED",
			["arena"] = "COLLAPSED",
			["dungeon"] = "FULL",
			["raid"] = "COLLAPSED",
			["scenario"] = "FULL",
			["rested"] = "FULL",
			["garrison"] = "FULL",
		},
		["autoReward"] = false,
	},
	--Tooltip
	["tooltip"] = {
		["showFaction"] = false,
		["xOffset"] = 0,
		["yOffset"] = 0,
		["alwaysCompareItems"] = false,
		["RaidProg"] = {
			["enable"] = false,
			["NameStyle"] = "SHORT",
			["DifStyle"] = "SHORT",
		},
	},
	--Minimap Module
	["minimap"] = {
		["combat"] = false,
		["alpha"] = 1,
		["coords"] = {
			["enable"] = false,
			["display"] = "SHOW",
			["position"] = "BOTTOM",
			["format"] = "%.0f",
			["font"] = "PT Sans Narrow",
			["fontSize"] = 12,
			["fontOutline"] = "OUTLINE",
			["throttle"] = 0.2,
		},
		["buttons"] = {
			["anchor"] = "NOANCHOR",
			["size"] = 24,
			["mouseover"] = false,
		},
		["mapicons"] = {
			["iconmouseover"] = false,
			["iconsize"] = 27,
			["iconperrow"] = 12,
			["pethide"] = false,
			["skindungeon"] = false,
		},
		["instance"] = {
			["enable"] = false,
			["flag"] = true,
			["xoffset"] = -10,
			["yoffset"] = 0,
			["colors"] = {
				["lfr"] = {r = 0.32,g = 0.91,b = 0.25},
				["normal"] = {r = 0.09,g = 0.51,b = 0.82},
				["heroic"] = {r = 0.82,g = 0.42,b = 0.16},
				["challenge"] = {r = 0.9,g = 0.89,b = 0.27},
				["mythic"] = {r = 0.9,g = 0.14,b = 0.15},
				["time"] = {r = 0.41,g = 0.80,b = 0.94}
			},
			["font"] = "PT Sans Narrow",
			["fontSize"] = 12,
			["fontOutline"] = "OUTLINE",
		},
		["locPanel"] = {
			["enable"] = false,
			["width"] = 200,
			["height"] = 21,
			["linkcoords"] = true,
			["template"] = "Transparent",
			["font"] = "PT Sans Narrow",
			["fontSize"] = 12,
			["fontOutline"] = "OUTLINE",
			["throttle"] = 0.2,
			["format"] = "%.0f",
			["zoneText"] = true,
			["colorType"] = "REACTION",
			["customColor"] = {r = 1, g = 1, b = 1 },
			["portals"] = {
				["enable"] = true,
				["customWidth"] = false,
				["customWidthValue"] = 200,
				["justify"] = "LEFT",
				["cdFormat"] = "DEFAULT",
			},
		},
	},
	--Bags
	["bags"] = {
		["lootflash"] = true,
	},
	--Skins
	["skins"] = {
		["objectiveTracker"] = {
			["classHeader"] = false,
			["colorHeader"] = {r = 1, g = 0.82, b = 0},
			["underline"] = true,
			["underlineClass"] = false,
			["underlineColor"] = {r = 1, g = 0.82, b = 0},
		},
	},
	--Unitfrmes
	["unitframes"] = {
		["unit"] = {
			["player"] = {
				["combatico"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
					["size"] = 19,
					["texture"] = "DEFAULT",
					["red"] = true,
				},
				["rested"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
					["size"] = 22,
					["texture"] = "DEFAULT",
					["customTexture"] = "",
				},
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["target"] = {
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["focus"] = {
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["party"] = {
				["offline"] = {
					["enable"] = false,
					["size"] = 36,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "ALERT",
					["CustomTexture"] = "",
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["raid"] = {
				["offline"] = {
					["enable"] = false,
					["size"] = 36,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "ALERT",
					["CustomTexture"] = "",
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["raid40"] = {
				["offline"] = {
					["enable"] = false,
					["size"] = 20,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "ALERT",
					["CustomTexture"] = "",
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["boss"] = {
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
			["arena"] = {
				["higherPortrait"] = false,
				["portraitAlpha"] = 0.35,
			},
		},
		["roleicons"] = "ElvUI",
		["statusTextures"] = {
			["powerTexture"] = "ElvUI Norm",
			["castTexture"] = "ElvUI Norm",
			["auraTexture"] = "ElvUI Norm",
			["classTexture"] = "ElvUI Norm",
		},
	},
	--Raid Manager
	["raidmanager"] = {
		["level"] = true,
		["roles"] = false,
	},
	--Media
	["media"] = {
		["fonts"] = {
			["zone"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 32,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["subzone"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 25,
				["outline"] = "OUTLINE",
				["offset"] = 0,
				["width"] = 512,
			},
			["pvp"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 22,
				["outline"] = "OUTLINE",
				["width"] = 512,
			},
			["mail"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["editbox"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["gossip"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["objective"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["outline"] = "NONE",
			},
			["objectiveHeader"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["outline"] = "NONE",
			},
		},
	},
	--UI Buttons
	["uibuttons"] = {
		["enable"] = false,
		["size"] = 17,
		["mouse"] = false,
		["menuBackdrop"] = false,
		["dropdownBackdrop"] = false,
		["orientation"] = "vertical",
		["spacing"] = 3,
		["point"] = "TOPLEFT",
		["anchor"] = "TOPRIGHT",
		["xoffset"] = 0,
		["yoffset"] = 0,
		["customroll"] = {
			["min"] = "1",
			["max"] = "50",
		},
		["Config"] = {
			["enabled"] = false,
			["called"] = "Reload",
		},
		["Addon"] = {
			["enabled"] = false,
			["called"] = "Manager",
		},
		["Status"] = {
			["enabled"] = false,
			["called"] = "AFK",
		},
		["Roll"] = {
			["enabled"] = false,
			["called"] = "Hundred",
		},
	},
}

--Datatexts
P.datatexts.panels["SLE_DataPanel_1"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}
P.datatexts.panels["SLE_DataPanel_2"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}
P.datatexts.panels["SLE_DataPanel_3"] = 'Version'
P.datatexts.panels["SLE_DataPanel_4"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}
P.datatexts.panels["SLE_DataPanel_5"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}
P.datatexts.panels["SLE_DataPanel_6"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}
P.datatexts.panels["SLE_DataPanel_7"] = ''
P.datatexts.panels["SLE_DataPanel_8"] = {
	["left"] = '',
	["middle"] = '',
	["right"] = '',
}