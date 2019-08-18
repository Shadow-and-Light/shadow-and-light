local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local MC

local function CreateBackgrounds()
	local config = MC:CreateModuleConfigGroup(L["Backgrounds"], "backgrounds", "sle")
	for i = 1, 4 do
		config.args["bg"..i] = {
			order = 1+i,
			type = "toggle",
			name = L["SLE_BG_"..i],
			get = function(info) return E.global.profileCopy.sle.backgrounds[ info[#info] ] end,
			set = function(info, value) E.global.profileCopy.sle.backgrounds[ info[#info] ] = value; end
		}
	end

	return config
end
local function CreateBags()
	local config = MC:CreateModuleConfigGroup(L["Bags"], "bags", "sle")
	config.args.petLevel = {
		order = 2,
		type = "toggle",
		name = AUCTION_CATEGORY_BATTLE_PETS,
		get = function(info) return E.global.profileCopy.sle.bags[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.bags[ info[#info] ] = value; end
	}

	return config
end
local function CreateChat()
	local config = MC:CreateModuleConfigGroup(L["Chat"], "chat", "sle")
	config.args.justify = {
		order = 2,
		type = "toggle",
		name = L["Chat Frame Justify"],
		get = function(info) return E.global.profileCopy.sle.chat[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.chat[ info[#info] ] = value; end
	}
	config.args.tab = {
		order = 3,
		type = "toggle",
		name = L["Tabs"],
		get = function(info) return E.global.profileCopy.sle.chat[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.chat[ info[#info] ] = value; end
	}
	config.args.invite = {
		order = 3,
		type = "toggle",
		name = INVITE,
		get = function(info) return E.global.profileCopy.sle.chat[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.chat[ info[#info] ] = value; end
	}

	return config
end
local function CreateDatatbarsConfig()
	local config = MC:CreateModuleConfigGroup(L["DataBars"], "databars", "sle")

	config.args.experience = {
		order = 2,
		type = "toggle",
		name = XPBAR_LABEL,
		get = function(info) return E.global.profileCopy.sle.databars[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.databars[ info[#info] ] = value; end
	}
	config.args.reputation = {
		order = 3,
		type = "toggle",
		name = REPUTATION,
		get = function(info) return E.global.profileCopy.sle.databars[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.databars[ info[#info] ] = value; end
	}
	config.args.honor = {
		order = 4,
		type = "toggle",
		name = HONOR,
		get = function(info) return E.global.profileCopy.sle.databars[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.databars[ info[#info] ] = value; end
	}
	config.args.azerite = {
		order = 5,
		type = "toggle",
		name = L["Azerite Bar"],
		get = function(info) return E.global.profileCopy.sle.databars[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.databars[ info[#info] ] = value; end
	}

	return config
end
local function CreateDatatextsConfig()
	local config = MC:CreateModuleConfigGroup(L["DataTexts"], "datatexts", "sle")
	for i = 1, 8 do
		config.args["panel"..i] = {
			order = 1 + i,
			type = "toggle",
			name = L["SLE_DataPanel_"..i],
			get = function(info) return E.global.profileCopy.sle.datatexts[ info[#info] ] end,
			set = function(info, value) E.global.profileCopy.sle.datatexts[ info[#info] ] = value; end
		}
	end
	config.args.leftchat = {
		order = 10,
		type = "toggle",
		name = L["leftchat"],
		get = function(info) return E.global.profileCopy.sle.datatexts[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.datatexts[ info[#info] ] = value; end
	}
	config.args.rightchat = {
		order = 11,
		type = "toggle",
		name = L["rightchat"],
		get = function(info) return E.global.profileCopy.sle.datatexts[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.datatexts[ info[#info] ] = value; end
	}

	return config
end
local function CreateSLEDatatextsConfig()
	local config = MC:CreateModuleConfigGroup(L["S&L Datatexts"], "dt", "sle")
	config.args.friends = {
		order = 2,
		type = "toggle",
		name = L["S&L Friends"],
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}

	config.args.guild = {
		order = 3,
		type = "toggle",
		name = L["S&L Guild"],
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}
	config.args.mail = {
		order = 4,
		type = "toggle",
		name = L["S&L Mail"],
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}
	config.args.durability = {
		order = 5,
		type = "toggle",
		name = DURABILITY,
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}
	config.args.currency = {
		order = 6,
		type = "toggle",
		name = "S&L Currency",
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}
	config.args.regen = {
		order = 7,
		type = "toggle",
		name = MANA_REGEN,
		get = function(info) return E.global.profileCopy.sle.dt[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.dt[ info[#info] ] = value; end
	}

	return config
end
local function CreateLegacyConfig()
	local config = MC:CreateModuleConfigGroup(SLE.Russian and ITEM_QUALITY7_DESC or LFG_LIST_LEGACY, "legacy", "sle")
	config.args.farm = {
		order = 2,
		type = "toggle",
		name = L["Farm"],
		get = function(info) return E.global.profileCopy.sle.legacy[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.legacy[ info[#info] ] = value; end
	}
	config.args.garrison = {
		order = 3,
		type = "toggle",
		name = GARRISON_LOCATION_TOOLTIP,
		get = function(info) return E.global.profileCopy.sle.legacy[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.legacy[ info[#info] ] = value; end
	}
	config.args.orderhall = {
		order = 4,
		type = "toggle",
		name = L["Class Hall"],
		get = function(info) return E.global.profileCopy.sle.legacy[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.legacy[ info[#info] ] = value; end
	}
	config.args.warwampaign = {
		order = 5,
		type = "toggle",
		name = WAR_CAMPAIGN,
		get = function(info) return E.global.profileCopy.sle.legacy[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.legacy[ info[#info] ] = value; end
	}

	return config
end
local function CreateLootConfig()
	local config = MC:CreateModuleConfigGroup(L["Loot"], "loot", "sle")
	config.args.autoroll = {
		order = 2,
		type = "toggle",
		name = L["Loot Auto Roll"],
		get = function(info) return E.global.profileCopy.sle.loot[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.loot[ info[#info] ] = value; end
	}
	config.args.announcer = {
		order = 3,
		type = "toggle",
		name = L["Loot Announcer"],
		get = function(info) return E.global.profileCopy.sle.loot[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.loot[ info[#info] ] = value; end
	}
	config.args.history = {
		order = 4,
		type = "toggle",
		name = L["Loot Roll History"],
		get = function(info) return E.global.profileCopy.sle.loot[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.loot[ info[#info] ] = value; end
	}
	config.args.looticons = {
		order = 5,
		type = "toggle",
		name = L["Loot Icons"],
		get = function(info) return E.global.profileCopy.sle.loot[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.loot[ info[#info] ] = value; end
	}

	return config
end
local function CreateMinimapConfig()
	local config = MC:CreateModuleConfigGroup(MINIMAP_LABEL, "minimap", "sle")
	config.args.coords = {
		order = 2,
		type = "toggle",
		name = L["Minimap Coordinates"],
		get = function(info) return E.global.profileCopy.sle.minimap[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.minimap[ info[#info] ] = value; end
	}
	config.args.mapicons = {
		order = 3,
		type = "toggle",
		name = L["Minimap Coordinates"],
		get = function(info) return E.global.profileCopy.sle.minimap[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.minimap[ info[#info] ] = value; end
	}
	config.args.instance = {
		order = 4,
		type = "toggle",
		name = L["Instance indication"],
		get = function(info) return E.global.profileCopy.sle.minimap[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.minimap[ info[#info] ] = value; end
	}
	config.args.locPanel = {
		order = 5,
		type = "toggle",
		name = L["Location Panel"],
		get = function(info) return E.global.profileCopy.sle.minimap[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.minimap[ info[#info] ] = value; end
	}

	return config
end

local function CreateUnitframesConfig()
	local config = MC:CreateModuleConfigGroup(L["UnitFrames"], "unitframes", "sle")
	config.args.unit = {
		order = 2,
		type = "group",
		guiInline = true,
		name = L["UnitFrames"],
		get = function(info) return E.global.profileCopy.sle.unitframes[info[#info - 1]][ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.unitframes[info[#info - 1]][ info[#info] ] = value; end,
		args = {
			["player"] = {
				order = 1,
				type = "toggle",
				name = L["Player Frame"],
			},
			["target"] = {
				order = 2,
				type = "toggle",
				name = L["Target Frame"],
			},
			["targettarget"] = {
				order = 3,
				type = "toggle",
				name = L["TargetTarget Frame"],
			},
			["targettargettarget"] = {
				order = 4,
				type = "toggle",
				name = L["TargetTargetTarget Frame"],
			},
			["focus"] = {
				order = 5,
				type = "toggle",
				name = L["Focus Frame"],
			},
			["focustarget"] = {
				order = 6,
				type = "toggle",
				name = L["FocusTarget Frame"],
			},
			["pet"] = {
				order = 7,
				type = "toggle",
				name = L["Pet Frame"],
			},
			["pettarget"] = {
				order = 8,
				type = "toggle",
				name = L["PetTarget Frame"],
			},
			["boss"] = {
				order = 9,
				type = "toggle",
				name = L["Boss Frames"],
			},
			["arena"] = {
				order = 10,
				type = "toggle",
				name = L["Arena Frames"],
			},
			["party"] = {
				order = 11,
				type = "toggle",
				name = L["Party Frames"],
			},
			["raid"] = {
				order = 12,
				type = "toggle",
				name = L["Raid Frames"],
			},
			["raid40"] = {
				order = 13,
				type = "toggle",
				name = L["Raid-40 Frames"],
			},
		},
	}

	return config
end

local function configTable()
	if not E.Options.args.modulecontrol then return end
	MC = E:GetModule('ModuleCopy')

	E.Options.args.modulecontrol.args.modulecopy.args.sle = {
		order = 11,
		type = 'group',
		name = SLE.Title,
		childGroups = "tab",
		disabled = E.Options.args.profiles.args.copyfrom.disabled,
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["|cff9482c9Shadow & Light|r options"],
			},
			actionbar = MC:CreateModuleConfigGroup(L["ActionBars"], "actionbars", "sle"),
			auras = MC:CreateModuleConfigGroup(L["Auras"], "auras", "sle"),
			backgrounds = CreateBackgrounds(),
			bags = CreateBags(),
			blizzard = MC:CreateModuleConfigGroup("Blizzard", "blizzard", "sle"),
			chat = CreateChat(),
			databars = CreateDatatbarsConfig(),
			datatexts = CreateDatatextsConfig(),
			dt = CreateSLEDatatextsConfig(),
			legacy = CreateLegacyConfig(),
			lfr = MC:CreateModuleConfigGroup(RAID_FINDER, "lfr", "sle"),
			loot = CreateLootConfig(),
			media = MC:CreateModuleConfigGroup(L["Media"], "media", "sle"),
			minimap = CreateMinimapConfig(),
			nameplates = MC:CreateModuleConfigGroup(L["NamePlates"], "nameplates", "sle"),
			quests = MC:CreateModuleConfigGroup(QUESTS_LABEL, "quests", "sle"),
			pvp = MC:CreateModuleConfigGroup(PVP, "pvp", "sle"),
			raidmanager = MC:CreateModuleConfigGroup(RAID_CONTROL, "raidmanager", "sle"),
			raidmarkers = MC:CreateModuleConfigGroup(L["Raid Markers"], "raidmarkers", "sle"),
			screensaver = MC:CreateModuleConfigGroup(L["AFK Mode"], "screensaver", "sle"),
			shadows = MC:CreateModuleConfigGroup(L["Enhanced Shadows"], "shadows", "sle"),
			skins = MC:CreateModuleConfigGroup(L["Skins"], "skins", "sle"),
			tooltip = MC:CreateModuleConfigGroup(L["Tooltip"], "tooltip", "sle"),
			uibuttons = MC:CreateModuleConfigGroup(L["UI Buttons"], "uibuttons", "sle"),
			unitframes = CreateUnitframesConfig(),
		},
	}
end

T.tinsert(SLE.Configs, configTable)
