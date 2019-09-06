local SLE, T, E, L, V, P, G = unpack(select(2, ...))

P["sle"] = {
	--Actionbars
	["actionbars"] = {
		["vehicle"] = {
			["buttonsize"] = 40,
			["buttonspacing"] = 2,
			["template"] = "Transparent",
		},
	},
	--Auras
	["auras"] = {
		["hideBuffsTimer"] = false,
		["hideDebuffsTimer"] = false,
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
			["visibility"] = "show",
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
			["visibility"] = "show",
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
			["visibility"] = "show",
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
			["visibility"] = "show",
		},
	},
	--Bags
	["bags"] = {
		["petLevel"] = {
			["enable"] = false,
			["color"] = {r = 230, g = 204, b = 128},
			["fonts"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 14,
				["outline"] = "OUTLINE",
			},
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
		["editboxhistory"] = 20,
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
			["resize"] = "Blizzard",
			["customWidth"] = 50,
		},
		["invite"] = {
			["altInv"] = false,
			["invLinks"] = false,
			["keys"] = "invite",
			["color"] = {r = 1, g = 1, b = 0},
		},
	},
	--Databars
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
			["ignoreGuild"] = true,
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
		["azerite"] = {
			["longtext"] = false,
			["chatfilter"] = {
				["enable"] = false,
				["iconsize"] = 12,
				["style"] = "STYLE1",
			},
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
			["noborders"] = false,
		},
		["rightchat"] = {
			["enabled"] = true,
			["width"] = 396,
			["alpha"] = 1,
			["noborders"] = false,
		},
		["chathandle"] = false,
	},
	--SLE Datatexts
	["dt"] = {
		["friends"] = {
			["combat"] = false,
			["expandBNBroadcast"] = false,
			["hideFriends"] = false,
			["hide_hintline"] = false,
			["hide_titleline"] = false,
			["sortBN"] = 'TOONNAME',
			["tooltipAutohide"] = 0.2,
			["totals"] = false,
			["textStyle"] = "Default",
		},
		["guild"] = {
			["combat"] = false,
			["hide_gmotd"] = false,
			["hideGuild"] = false,
			["hide_guildname"] = false,
			["hide_hintline"] = false,
			["hide_titleline"] = false,
			["sortGuild"] = 'TOONNAME',
			["tooltipAutohide"] = 0.2,
			["totals"] = false,
			["textStyle"] = "Default",
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
			["gold"] = {
				["direction"] = "normal",
				["method"] = "name",
				["throttle"] = {
					["mode"] = "NONE",
					["numChars"] = 5,
					["goldAmount"] = 5000,
				},
			},
			["cur"] = {
				["direction"] = "normal",
				["method"] = "name",
			},
		},
		["regen"] = {
			["short"] = false,
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
		["orderhall"] = {
			["autoOrder"] = {
				["enable"] = false,
				["autoEquip"] = false,
			},
		},
		["warwampaign"] = {
			["autoOrder"] = {
				["enable"] = false,
			},
		}
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
			["trial"] = false,
			["palace"] = false,
			["tomb"] = false,
			["antorus"] = false,
		},
		["bfa"] = {
			["uldir"] = false,
			["daz"] = false,
			["sc"] = false,
			["ep"] = false,
		},
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
			["questFontSuperHuge"] = {
				["font"] = "PT Sans Narrow",
				["size"] = 24,
				["outline"] = "NONE",
			},
		},
	},
	--Minimap Module
	["minimap"] = {
		["combat"] = false,
		["coords"] = {
			["enable"] = false,
			["display"] = "SHOW",
			["position"] = "BOTTOM",
			["format"] = "%.0f",
			["font"] = "PT Sans Narrow",
			["fontSize"] = 12,
			["fontOutline"] = "OUTLINE",
			["throttle"] = 0.2,
			["color"] = {r = 1,g = 1,b = 1},
		},
		["mapicons"] = {
			["iconmouseover"] = false,
			["iconsize"] = 27,
			["iconperrow"] = 12,
			["spacing"] = 4,
			["growth_hor"] = "Right",
			["growth_vert"] = "Down",
			["visibility"] = "[petbattle] hide; show",
		},
		["instance"] = {
			["enable"] = false,
			["xoffset"] = -10,
			["yoffset"] = 0,
			["onlyNumber"] = false,
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
			["autowidth"] = false,
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
			["colorType_Coords"] = "DEFAULT",
			["customColor"] = {r = 1, g = 1, b = 1 },
			["customColor_Coords"] = {r = 1, g = 1, b = 1 },
			["combathide"] = false,
			["orderhallhide"] = false,
			["portals"] = {
				["enable"] = true,
				["HSplace"] = true,
				["customWidth"] = false,
				["customWidthValue"] = 200,
				["justify"] = "LEFT",
				["cdFormat"] = "DEFAULT",
				["ignoreMissingInfo"] = false,
				["showHearthstones"] = true,
				["hsPrio"] = "54452,64488,93672,142542,162973,163045,165669,165670,165802,166746,166747",
				["showToys"] = true,
				["showSpells"] = true,
				["showEngineer"] = true,
			},
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
	--Nameplate Options
	["nameplates"] = {
		["threat"] = {
			["enable"] = false,
			["font"] = "PT Sans Narrow",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["xoffset"] = 1,
			["yoffset"] = 2,
		},
		["targetcount"] = {
			["enable"] = false,
			["font"] = "PT Sans Narrow",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["xoffset"] = 1,
			["yoffset"] = 2,
		},
		["visibleRange"] = 60,
	},

	--Quests
	["quests"] = {
		["visibility"] = {
			["enable"] = false,
			["bg"] = "COLLAPSED",
			["arena"] = "COLLAPSED",
			["dungeon"] = "FULL",
			["raid"] = "COLLAPSED",
			["scenario"] = "FULL",
			["rested"] = "FULL",
			["garrison"] = "FULL",
			["orderhall"] = "FULL",
			["combat"] = "NONE",
		},
		["autoReward"] = false,
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
	--Raid Manager
	["raidmanager"] = {
		["level"] = true,
		["roles"] = false,
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
		["mouseover"] = false,
		["notooltip"] = false,
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
			["xOffset"] = 0,
			["yOffset"] = 0,
			["hour24"] = true,
		},
		["player"] = {
			["font"] = "PT Sans Narrow",
			["size"] = 15,
			["outline"] = "OUTLINE",
			["xOffset"] = 0,
			["yOffset"] = 0,
		},
		["tips"] = {
			["font"] = "PT Sans Narrow",
			["size"] = 20,
			["outline"] = "OUTLINE",
		},
		["crest"] = {
			["size"] = 128,
			["xOffset_faction"] = 0,
			["yOffset_faction"] = 0,
			["xOffset_race"] = 0,
			["yOffset_race"] = 0,
		},
		["xpack"] = 150,
		["height"] = 135,
		["playermodel"] = {
			["enable"] = true,
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
	--Shadows
	['shadows'] = {
		['shadowcolor'] = { ['r'] = 0, ['g'] = 0, ['b'] = 0 },
		['classcolor'] = false,
		['size'] = 3,
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
		["merchant"] = {
			["list"] = {
				["nameFont"] = "PT Sans Narrow",
				["nameSize"] = 13,
				["nameOutline"] = "OUTLINE",
				["subFont"] = "PT Sans Narrow",
				["subSize"] = 12,
				["subOutline"] = "OUTLINE",
			},
		},
		["talkinghead"] = {
			["hide"] = false,
		},
	},
	--Tooltip
	["tooltip"] = {
		["showFaction"] = false,
		["alwaysCompareItems"] = false,
		["RaidProg"] = {
			["enable"] = false,
			["NameStyle"] = "SHORT",
			["DifStyle"] = "SHORT",
			["raids"] = {
				["nightmare"] = false,
				["trial"] = false,
				["nighthold"] = false,
				["sargeras"] = false,
				["antorus"] = false,
				["uldir"] = true,
				["daz"] = true,
				["sc"] = true,
				["ep"] = true,
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
		["visibility"] = "show",
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
	--Unitfrmes
	["unitframes"] = {
		["unit"] = {
			["player"] = {
				["pvpIconText"] = {
					["enable"] = false,
					["xoffset"] = 0,
					["yoffset"] = 0,
					["level"] = true,
				},
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["pet"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["pettarget"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["target"] = {
				["pvpIconText"] = {
					["level"] = true,
				},
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["targettarget"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["targettargettarget"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["focus"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["focustarget"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
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
				["dead"] = {
					["enable"] = false,
					["size"] = 36,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "SKULL",
					["CustomTexture"] = "",
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
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
				["dead"] = {
					["enable"] = false,
					["size"] = 36,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "SKULL",
					["CustomTexture"] = "",
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
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
				["dead"] = {
					["enable"] = false,
					["size"] = 36,
					["xOffset"] = 0,
					["yOffset"] = 0,
					["texture"] = "SKULL",
					["CustomTexture"] = "",
				},
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
				["role"] = {
					["xoffset"] = 0,
					["yoffset"] = 0,
				},
			},
			["boss"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
			},
			["arena"] = {
				["auras"] = {
					["buffs"] = {
						["threshold"] = 4,
					},
					["debuffs"] = {
						["threshold"] = 4,
					},
				},
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
