local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

V["skins"]["addons"] = {
	["EmbedSkada"] = true,
}

V["sle"] = {
	armory = {
		stats = {
			enable = true,
		},
	},
	["equip"] = {
		["enable"] = false,
		["spam"] = false,
		["onlyTalent"] = false,
		["conditions"] = "",
		["lockbutton"] = false,
	},
	--Minimap Module
	["minimap"] = {
		rectangle = false,
	},
	["professions"] = {
		["deconButton"] = {
			["enable"] = true,
			["style"] = "BIG",
			["buttonGlow"] = true,
		},
	},
	module = {
		shadows = {
			enable = true,
		},
	},
	objectiveTracker = {
		enable = true,
	},
	["pvp"] = {
		["KBbanner"] = {
			["enable"] = false,
			["sound"] = true,
		},
	},
	["actionbars"] = {
		["checkedtexture"] = false,
		["checkedColor"] = {r = 0, g = 1, b = 0, a = 0.3},
	},
	["skins"] = {
		["objectiveTracker"] = {
			["enable"] = true,
			["texture"] = "ElvUI Norm",
			["class"] = false,
			["color"] = {r = 0.26, g = 0.42, b = 1},
			["underlineHeight"] = 1,
			["scenarioBG"] = false,
			["BGbackdrop"] = true,
			["skinnedTextureLogo"] = "NONE",
			["customTextureLogo"] = "",
			["keyTimers"] = {
				["enable"] = false,
				["showBothTimers"] = false,
				["showMarks"] = true,
			},
			torghastPowers = {
				enable = false,
			},
		},
		["petbattles"] = {
			["enable"] = true,
		},
		["merchant"] = {
			["enable"] = false,
			["style"] = "Default",
			["subpages"] = 2,
		},
		["questguru"] = {
			["enable"] = false,
			["removeParchment"] = false,
		},
	},
	["uibuttons"] = {
		["style"] = "classic",
		["strata"] = "MEDIUM",
		["level"] = 5,
		["transparent"] = "Default",
	},
	viewport = {
		enable = false,
	},
	["characterGoldsSorting"] = {},
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
		["confirmed"] = false,
		["cyrillics"] = {
			["commands"] = false,
			["devCommands"] = false,
		},
		["chat"] = {
			["setupDelay"] = 1,
		},
	},
}

if G["profileCopy"] then
	G["profileCopy"]["sle"] = {
		["actionbars"] = {
			["general"] = true,
		},
		["armory"] = {
			["character"] = true,
			["inspect"] = true,
			["stats"] = true,
		},
		["backgrounds"] = {
			["bg1"] = true,
			["bg2"] = true,
			["bg3"] = true,
			["bg4"] = true,
		},
		["blizzard"] = {
			["general"] = true,
		},
		["chat"] = {
			["general"] = true,
			["justify"] = true,
			["invite"] = true,
		},
		["databars"] = {
			["experience"] = true,
			["reputation"] = true,
			["honor"] = true,
			["azerite"] = true,
		},
		["dt"] = {
			["friends"] = true,
			["guild"] = true,
			["mail"] = true,
			["currency"] = true,
			["regen"] = true,
		},
		["legacy"] = {
			["garrison"] = true,
			["orderhall"] = true,
			["warwampaign"] = true,
		},
		["lfr"] = {
			["general"] = true,
		},
		["loot"] = {
			["general"] = true,
			["autoroll"] = true,
			["announcer"] = true,
			["history"] = true,
			["looticons"] = true,
		},
		["media"] = {
			["general"] = true,
		},
		["minimap"] = {
			["coords"] = true,
			["instance"] = true,
			["locPanel"] = true,
		},
		["nameplates"] = {
			["general"] = true,
		},
		["quests"] = {
			["general"] = true,
		},
		["pvp"] = {
			["general"] = true,
		},
		["raidmanager"] = {
			["general"] = true,
		},
		["raidmarkers"] = {
			["general"] = true,
		},
		["afk"] = {
			["general"] = true,
		},
		["shadows"] = {
			["general"] = true,
		},
		["skins"] = {
			["general"] = true,
		},
		["tooltip"] = {
			["general"] = true,
		},
		["uibuttons"] = {
			["general"] = true,
		},
		["unitframes"] = {
			["general"] = true,
			["unit"] = {
				["player"] = true,
				["target"] = true,
				["targettarget"] = true,
				["targettargettarget"] = true,
				["focus"] = true,
				["focustarget"] = true,
				["pet"] = true,
				["pettarget"] = true,
				["party"] = true,
				["raid1"] = true,
				["raid2"] = true,
				["raid3"] = true,
				["boss"] = true,
				["arena"] = true,
			},
		},
	}
end
