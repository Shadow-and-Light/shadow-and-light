local SLE, T, E, L, V, P, G = unpack(select(2, ...))

V["skins"]["addons"] = {
	["EmbedSkada"] = true,
}

V["sle"] = {
	["equip"] = {
		["enable"] = false,
		["spam"] = false,
		["instanceSet"] = false,
		["pvpSet"] = false,
		["firstSpec"] = {
			["general"] = "NONE",
			["pvp"] = "NONE",
			["instance"] = "NONE",
		},
		["secondSpec"] = {
			["general"] = "NONE",
			["pvp"] = "NONE",
			["instance"] = "NONE",
		},
		["thirdSpec"] = {
			["general"] = "NONE",
			["pvp"] = "NONE",
			["instance"] = "NONE",
		},
		["forthSpec"] = {
			["general"] = "NONE",
			["pvp"] = "NONE",
			["instance"] = "NONE",
		},
		["setoverlay"] = false,
	},

	--Minimap Module
	["minimap"] = {
		["buttons"] = {
			["enable"] = true,
		},
		["mapicons"] = {
			["enable"] = false,
			["barenable"] = false,
		},
	},

	["bags"] = {
		["transparentSlots"] = false,
	},

	["vehicle"] = {
		["enable"] = false,
	},
	
	["professions"] = {
		["deconButton"] = {
			["enable"] = true,
			["style"] = "BIG",
			["buttonGlow"] = true,
		},
		["enchant"] = {
			["enchScroll"] = false,
		},
		["fishing"] = {
			["EasyCast"] = false,
			["FromMount"] = false,
			["UseLures"] = true,
			["IgnorePole"] = false,
			["CastButton"] = "Shift",
		},
	},

	["module"] = {
		["screensaver"] = false,
		["blizzmove"] = true,
	},
	
	["unitframe"] = {
		["resizeHealthPrediction"] = false,
		["statusbarTextures"] = {
			["power"] = false,
			["cast"] = false,
			["aura"] = false,
			["class"] = false,
		},
	},
	
	["chat"] = {
		["chatMax"] = 128,
		["chatHistory"] = {
			["CHAT_MSG_INSTANCE_CHAT"] = true,
			["CHAT_MSG_INSTANCE_CHAT_LEADER"] = true,
			["CHAT_MSG_BN_WHISPER"] = true,
			["CHAT_MSG_BN_WHISPER_INFORM"] = true,
			["CHAT_MSG_CHANNEL"] = true,
			["CHAT_MSG_EMOTE"] = true,
			["CHAT_MSG_GUILD"] = true,
			["CHAT_MSG_GUILD_ACHIEVEMENT"] = true,
			["CHAT_MSG_OFFICER"] = true,
			["CHAT_MSG_PARTY"] = true,
			["CHAT_MSG_PARTY_LEADER"] = true,
			["CHAT_MSG_RAID"] = true,
			["CHAT_MSG_RAID_LEADER"] = true,
			["CHAT_MSG_RAID_WARNING"] = true,
			["CHAT_MSG_SAY"] = true,
			["CHAT_MSG_WHISPER"] = true,
			["CHAT_MSG_WHISPER_INFORM"] = true,
			["CHAT_MSG_YELL"] = true,
			["size"] = 128,
		},
	},
	["pvp"] = {
		["KBbanner"] = {
			["enable"] = false,
			["sound"] = true,
		},
	},
	["actionbars"] = {
		["oorBind"] = false,
		["checkedtexture"] = false,
		["checkedColor"] = {r = 0, g = 1, b = 0, a = 0.3},
		["transparentBackdrop"] = false,
		["transparentButtons"] = false,
	},
	["skins"] = {
		["objectiveTracker"] = {
			["enable"] = true,
			["texture"] = "ElvUI Norm",
			["class"] = false,
			["color"] = {r = 0.26, g = 0.42, b = 1},
			["underlineHeight"] = 1,
		},
		["QuestKing"] = {
			["enable"] = false,
			["tooltipAnchor"] = "ANCHOR_LEFT",
			["tooltipScale"] = 0.9,
			["clickTemplate"] = "QuestKing",
			["trackerIcon"] = "DEFAULT",
			["trackerIconCustom"] = "",
			["trackerSize"] = 10,
			["questTypes"] = {
				["daily"] = "DEFAULT",
				["weekly"] = "DEFAULT",
				["group"] = "DEFAULT",
				["raid"] = "DEFAULT",
				["dungeon"] = "DEFAULT",
				["heroic"] = "DEFAULT",
				["legend"] = "DEFAULT",
				["scenario"] = "DEFAULT",
			},
		},
		["petbattles"] = {
			["enable"] = true,
		},
		["merchant"] = {
			["enable"] = false,
			["subpages"] = 2,
		},
	},
	["uiButtonStyle"] = "classic"
}

G["sle"] = {
	["DE"] = {
		["Blacklist"] = "",
		["IgnoreTabards"] = true,
		["IgnorePanda"] = true,
		["IgnoreCooking"] = true,
		["IgnoreFishing"] = true,
	},
	["LOCK"] = {
		["Blacklist"] = "",
		["TradeOpen"] = false,
	},
	["advanced"] = {
		["general"] = false,
		["optionsLimits"] = false,
		["gameMenu"] = {
			["enable"] = true,
			["reload"] = false,
		},
		["confirmed"] = false,
		["cyrillics"] = {
			["commands"] = false,
			["devCommands"] = false,
		},
	},
}