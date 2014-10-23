local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

function AI:DarthCaster()
	
end

function AI:DarthTank()
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Avoidance"
end

function AI:DarthPhys()
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Attack Power"
end

function AI:DarthHeal()
	E.db["general"]["totems"] = {
		["size"] = 34,
	}
	
	E.db["movers"]["PetAB"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT54366"
	E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMElvUIParentBOTTOM0152"
	E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM0130"
	E.db["movers"]["BossButton"] = "BOTTOMElvUIParentBOTTOM1440"
	E.db["movers"]["MarkMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-517138"
	E.db["movers"]["VehicleSeatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT416209"
	E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM312177"
	E.db["movers"]["ElvUF_PlayerCastbarMover"] = nil --"BOTTOMElvUIParentBOTTOM-312152"
	E.db["movers"]["ElvUF_TargetCastbarMover"] = nil
	E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-543114"
	E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMElvUIParentBOTTOM0152"
	E.db["movers"]["TotemBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT50050"
	E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT543114"
	E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-312177"
	E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMElvUIParentBOTTOM0152"
	E.db["movers"]["AlertFrameMover"] = "BOTTOMElvUIParentBOTTOM3432"
	
	E.db["unitframe"] = P.unitframe
	
	E.db["unitframe"] = {
		["fontSize"] = 11,
		["units"] = {
			["tank"] = {
				["enable"] = false,
			},
			["party"] = {
				["horizontalSpacing"] = 3,
				["debuffs"] = {
					["anchorPoint"] = "TOPLEFT",
					["sizeOverride"] = 0,
				},
				["health"] = {
					["frequentUpdates"] = true,
					["position"] = "BOTTOMLEFT",
					["text_format"] = "[healthcolor][health:deficit]",
				},
				["growthDirection"] = "RIGHT_UP",
				["GPSArrow"] = {
					["xOffset"] = -27,
					["size"] = 25,
					["yOffset"] = 12,
				},
				["roleIcon"] = {
					["position"] = "BOTTOMRIGHT",
				},
				["power"] = {
					["text_format"] = "",
				},
				["healPrediction"] = true,
				["width"] = 80,
				["name"] = {
					["text_format"] = "[name:medium]",
					["position"] = "TOP",
				},
			},
			["raid40"] = {
				["GPSArrow"] = {
					["enable"] = true,
					["xOffset"] = -27,
					["size"] = 20,
				},
				["name"] = {
					["position"] = "TOP",
				},
				["rdebuffs"] = {
					["size"] = 16,
				},
				["height"] = 32,
				["visibility"] = "[@raid31,noexists] hide;show",
			},
			["target"] = {
				["combobar"] = {
					["fill"] = "spaced",
				},
				["portrait"] = {
					["rotation"] = 345,
					["enable"] = true,
					["overlay"] = true,
					["camDistanceScale"] = 3,
				},
				["castbar"] = {
					["height"] = 20,
					["width"] = 210,
				},
				["width"] = 210,
				["name"] = {
					["position"] = "TOPLEFT",
					["text_format"] = "[namecolor][name:medium] [difficultycolor][level] [shortclassification]",
					["yOffset"] = -2,
				},
				["health"] = {
					["text_format"] = "[healthcolor][health:deficit] - [health:current-percent]",
					["yOffset"] = -5,
				},
				["power"] = {
					["attachTextToPower"] = true,
					["width"] = "inset",
					["position"] = "RIGHT",
					["hideonnpc"] = false,
				},
				["height"] = 51,
			},
			["raid"] = {
				["growthDirection"] = "RIGHT_UP",
				["health"] = {
					["frequentUpdates"] = true,
					["position"] = "BOTTOMLEFT",
				},
				["rdebuffs"] = {
					["size"] = 18,
				},
				["GPSArrow"] = {
					["xOffset"] = -27,
					["size"] = 25,
					["yOffset"] = 12,
				},
				["healPrediction"] = true,
				["numGroups"] = 6,
				["name"] = {
					["text_format"] = "[name:medium]",
				},
				["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show",
			},
			["player"] = {
				["debuffs"] = {
					["enable"] = false,
				},
				["portrait"] = {
					["rotation"] = 345,
					["enable"] = true,
					["overlay"] = true,
					["camDistanceScale"] = 3,
				},
				["classbar"] = {
					["fill"] = "spaced",
				},
				["aurabar"] = {
					["attachTo"] = "FRAME",
					["maxBars"] = 8,
				},
				["castbar"] = {
					["width"] = 210,
					["height"] = 20,
					["format"] = "CURRENTMAX",
				},
				["width"] = 210,
				["lowmana"] = 0,
				["health"] = {
					["position"] = "RIGHT",
					["text_format"] = "[healthcolor][health:current-percent:sl]",
					["yOffset"] = -4,
				},
				["power"] = {
					["attachTextToPower"] = true,
					["text_format"] = "[powercolor][power:current:sl]",
					["width"] = "inset",
				},
				["height"] = 51,
				["pvp"] = {
					["text_format"] = "||cFFB04F4F[pvptimer]||r",
				},
				["raidicon"] = {
					["attachTo"] = "LEFT",
					["xOffset"] = -20,
					["size"] = 22,
					["yOffset"] = 0,
				},
			},
			["arena"] = {
				["debuffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["pvpTrinket"] = {
					["position"] = "LEFT",
				},
				["power"] = {
					["width"] = "inset",
					["position"] = "RIGHT",
				},
				["growthDirection"] = "DOWN",
				["health"] = {
					["text_format"] = "[healthcolor][health:current-percent:sl]",
				},
				["buffs"] = {
					["anchorPoint"] = "RIGHT",
				},
			},
			["boss"] = {
				["debuffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["growthDirection"] = "DOWN",
				["health"] = {
					["text_format"] = "[healthcolor][health:current-percent:sl]",
				},
				["buffs"] = {
					["anchorPoint"] = "RIGHT",
				},
			},
			["assist"] = {
				["enable"] = false,
			},
		},
		["statusbar"] = "Polished Wood",
		["colors"] = {
			["auraBarBuff"] = {
				["r"] = 0.317647058823529,
				["g"] = 0.552941176470588,
				["b"] = 0.109803921568627,
			},
			["colorhealthbyvalue"] = false,
			["healthclass"] = true,
			["customhealthbackdrop"] = true,
			["castColor"] = {
				["r"] = 0.854901960784314,
				["g"] = 0.772549019607843,
				["b"] = 0.36078431372549,
			},
			["castNoInterrupt"] = {
				["r"] = 0.780392156862745,
				["g"] = 0.250980392156863,
				["b"] = 0.250980392156863,
			},
		},
		["fontOutline"] = "OUTLINE",
		["smartRaidFilter"] = false,
		["font"] = "ElvUI Font",
	}
end

function AI:DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	local layout = E.db.layoutSet
	local word = layout == 'tank' and L["Tank"] or layout == 'healer' and L["Healer"] or layout == 'dpsMelee' and L['Physical DPS'] or L['Caster DPS']
	SLEInstallStepComplete.message = L["Darth's Defaults Set"]..": "..word
	SLEInstallStepComplete:Show()
	
	if not E.db.movers then E.db.movers = {}; end

	E.db["general"] = {
		["loginmessage"] = false,
		["threat"] = {
			["enable"] = false,
		},
		["stickyFrames"] = false,
		["hideErrorFrame"] = false,
		["vendorGrays"] = true,
		["autoRepair"] = "PLAYER",
		["minimap"] = {
			["locationText"] = "HIDE",
		},
		["castNoInterrupt"] = {
		},
		["bottomPanel"] = false,
		["reputation"] = {
			["height"] = 187,
		},
		["NEUTRAL"] = {
		},
		["experience"] = {
			["height"] = 187,
		},
		["castColor"] = {
		},
	}

	E.db["nameplate"] = {
		["debuffs"] = {
			["stretchTexture"] = false,
			["font"] = "ElvUI Font",
			["numAuras"] = 5,
			["fontOutline"] = "OUTLINE",
		},
		["healthBar"] = {
			["lowHPScale"] = {
				["enable"] = true,
			},
			["text"] = {
				["enable"] = true,
			},
		},
		["fontOutline"] = "OUTLINE",
		["fontSize"] = 8,
		["buffs"] = {
			["font"] = "ElvUI Font",
			["fontOutline"] = "OUTLINE",
		},
		["font"] = "ElvUI Font",
		["raidHealIcon"] = {
			["xOffset"] = 0,
		},
	}
	
	E.db["datatexts"] = {
		["minimapPanels"] = false,
		["font"] = "ElvUI Font",
		["panelTransparency"] = true,
		["time24"] = true,
		["panels"] = {
			["RightChatDataPanel"] = {
				["left"] = "Mastery",
				["right"] = "Talent/Loot Specialization",
			},
			["Bottom_Panel"] = "System",
			["DP_6"] = {
				["right"] = "Crit Chance",
				["left"] = "Spell/Heal Power",
				["middle"] = "Haste",
			},
			["DP_5"] = {
				["right"] = "Durability",
				["left"] = "S&L Currency",
				["middle"] = "Bags",
			},
			["LeftChatDataPanel"] = {
				["right"] = "S&L Friends",
				["left"] = "Combat/Arena Time",
				["middle"] = "S&L Guild",
			},
		},
	}
	
	E.db["actionbar"] = {
		["bar3"] = {
			["point"] = "TOPLEFT",
			["buttons"] = 12,
			["buttonsPerRow"] = 4,
			["buttonsize"] = 30,
			["visibility"] = "[petbattle] hide; show",
		},
		["fontSize"] = 12,
		["bar2"] = {
			["enabled"] = true,
			["point"] = "TOPLEFT",
			["buttonsPerRow"] = 4,
			["buttonsize"] = 30,
			["visibility"] = " [petbattle] hide; show",
		},
		["bar1"] = {
			["point"] = "TOPLEFT",
			["buttonsPerRow"] = 4,
		},
		["bar5"] = {
			["point"] = "TOPLEFT",
			["buttons"] = 12,
			["buttonspacing"] = 1,
			["buttonsPerRow"] = 2,
			["buttonsize"] = 30,
			["visibility"] = " [petbattle] hide; show",
		},
		["bar4"] = {
			["point"] = "TOPLEFT",
			["visibility"] = "[petbattle] hide; show",
			["buttonspacing"] = 1,
			["buttonsPerRow"] = 2,
			["backdrop"] = false,
			["buttonsize"] = 30,
		},
		["font"] = "ElvUI Font",
		["barPet"] = {
			["point"] = "TOPLEFT",
			["buttonspacing"] = 1,
			["buttonsPerRow"] = 5,
			["buttonsize"] = 22,
			["backdrop"] = false,
		},
		["fontOutline"] = "OUTLINE",
		["hotkeytext"] = false,
		["stanceBar"] = {
			["buttonsize"] = 20,
		},
		["microbar"] = {
			["enabled"] = true,
			["buttonsPerRow"] = 11,
		},
		["keyDown"] = false,
	}
	
	E.db["tooltip"] = {
		["healthBar"] = {
			["font"] = "ElvUI Font",
		},
	}
	
	E.db["unitframe"] = {
		["debuffHighlighting"] = false,
		["fontSize"] = 11,
		["colors"] = {
			["auraBarBuff"] = {
				["r"] = 0.317647058823529,
				["g"] = 0.552941176470588,
				["b"] = 0.109803921568627,
			},
			["castNoInterrupt"] = {
				["b"] = 0.250980392156863,
				["g"] = 0.250980392156863,
				["r"] = 0.780392156862745,
			},
			["castColor"] = {
				["b"] = 0.36078431372549,
				["g"] = 0.772549019607843,
				["r"] = 0.854901960784314,
			},
			["colorhealthbyvalue"] = false,
			["healthclass"] = true,
		},
		["fontOutline"] = "OUTLINE",
		["smartRaidFilter"] = false,
		["font"] = "ElvUI Font",
		["statusbar"] = "Polished Wood",
		["units"] = {
			["tank"] = {
				["enable"] = false,
			},
			["boss"] = {
				["buffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["debuffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["health"] = {
					["text_format"] = "[healthcolor][health:current-percent:sl]",
				},
				["growthDirection"] = "DOWN",
			},
			["party"] = {
				["horizontalSpacing"] = 3,
				["debuffs"] = {
					["enable"] = false,
				},
				["power"] = {
					["text_format"] = "",
				},
				["growthDirection"] = "RIGHT_UP",
				["health"] = {
					["text_format"] = "[healthcolor][health:current]",
					["position"] = "BOTTOMLEFT",
				},
				["name"] = {
					["text_format"] = "[name:medium]",
					["position"] = "TOP",
				},
				["GPSArrow"] = {
					["enable"] = false,
					["size"] = 30,
				},
				["roleIcon"] = {
					["position"] = "BOTTOMRIGHT",
				},
				["width"] = 80,
			},
			["raid40"] = {
				["height"] = 32,
				["visibility"] = "[@raid31,noexists] hide;show",
			},
			["arena"] = {
				["debuffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["health"] = {
					["text_format"] = "[healthcolor][health:current-percent:sl]",
				},
				["power"] = {
					["position"] = "RIGHT",
					["width"] = "inset",
				},
				["buffs"] = {
					["anchorPoint"] = "RIGHT",
				},
				["pvpTrinket"] = {
					["position"] = "LEFT",
				},
				["growthDirection"] = "DOWN",
			},
			["assist"] = {
				["enable"] = false,
			},
			["raid"] = {
				["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show",
				["health"] = {
					["text_format"] = "[healthcolor][health:current]",
					["position"] = "BOTTOMLEFT",
				},
				["GPSArrow"] = {
					["enable"] = false,
					["size"] = 30,
				},
				["name"] = {
					["text_format"] = "[name:medium]",
				},
				["rdebuffs"] = {
					["size"] = 18,
				},
				["numGroups"] = 6,
				["growthDirection"] = "RIGHT_UP",
			},
			["player"] = {
				["debuffs"] = {
					["enable"] = false,
				},
				["portrait"] = {
					["rotation"] = 345,
					["overlay"] = true,
					["camDistanceScale"] = 3,
					["enable"] = true,
				},
				["castbar"] = {
					["height"] = 20,
					["format"] = "CURRENTMAX",
					["width"] = 300,
				},
				["width"] = 210,
				["raidicon"] = {
					["attachTo"] = "LEFT",
					["yOffset"] = 0,
					["xOffset"] = -20,
					["size"] = 22,
				},
				["pvp"] = {
					["text_format"] = "||cFFB04F4F[pvptimer]||r",
				},
				["health"] = {
					["yOffset"] = -4,
					["text_format"] = "[healthcolor][health:current-percent:sl]",
					["position"] = "RIGHT",
				},
				["power"] = {
					["width"] = "inset",
					["text_format"] = "[powercolor][power:current:sl]",
					["attachTextToPower"] = true,
				},
				["height"] = 51,
				["lowmana"] = 0,
				["classbar"] = {
					["fill"] = "spaced",
				},
				["aurabar"] = {
					["maxBars"] = 8,
					["attachTo"] = "FRAME",
				},
			},
			["target"] = {
				["combobar"] = {
					["fill"] = "spaced",
				},
				["power"] = {
					["position"] = "RIGHT",
					["hideonnpc"] = false,
					["width"] = "inset",
					["attachTextToPower"] = true,
				},
				["portrait"] = {
					["rotation"] = 345,
					["overlay"] = true,
					["camDistanceScale"] = 3,
					["enable"] = true,
				},
				["castbar"] = {
					["height"] = 20,
					["width"] = 210,
				},
				["height"] = 51,
				["health"] = {
					["yOffset"] = -5,
				},
				["name"] = {
					["yOffset"] = -2,
					["text_format"] = "[namecolor][name:medium] [difficultycolor][level] [shortclassification]",
					["position"] = "TOPLEFT",
				},
				["width"] = 210,
			},
		},
	}
	
	E.db["bags"] = {
		["bagWidth"] = 425,
		["bankWidth"] = 425,
		["bagSize"] = 30,
		["currencyFormat"] = "ICON",
		["bankSize"] = 30,
		["alignToChat"] = false,
		["yOffset"] = 181,
	}
	
	E.db["chat"] = {
		["editboxhistory"] = 10,
		["emotionIcons"] = false,
		["tabFontOutline"] = "OUTLINE",
		["panelHeight"] = 187,
		["timeStampFormat"] = "%H:%M:%S ",
		["tabFont"] = "ElvUI Font",
		["tabFontSize"] = 11,
		["panelWidth"] = 425,
	}
	
	E.db["auras"] = {
		["font"] = "ElvUI Font",
		["fontOutline"] = "OUTLINE",
		["consolidatedBuffs"] = {
			["fontOutline"] = "OUTLINE",
			["font"] = "ElvUI Font",
			["fontSize"] = 11,
			["filter"] = false,
		},
		["buffs"] = {
			["size"] = 30,
		},
		["debuffs"] = {
			["size"] = 30,
		},
	}
	
	E.db["sle"] = {
		["combatico"] = {
			["pos"] = "TOPRIGHT",
		},
		["threat"] = {
			["enable"] = false,
		},
		["media"] = {
			["fonts"] = {
				["subzone"] = {
					["font"] = "Old Cyrillic",
				},
				["pvp"] = {
					["font"] = "Old Cyrillic",
				},
				["zone"] = {
					["font"] = "Old Cyrillic",
				},
			},
			["screensaver"] = {
				["enable"] = true,
				["xpack"] = 200,
				["playermodel"] = {
					["rotation"] = 345,
					["xaxis"] = -0.2,
					["yaxis"] = -0.2,
					["distance"] = -0.0999999999999999,
					["anim"] = 70,
					["width"] = 530,
				},
				["crest"] = 150,
			},
		},
		["tooltip"] = {
			["showFaction"] = true,
		},
		["datatext"] = {
			["top"] = {
				["enabled"] = true,
				["transparent"] = true,
			},
			["chatright"] = {
				["width"] = 408,
			},
			["bottom"] = {
				["enabled"] = true,
				["width"] = 196,
				["transparent"] = true,
			},
			["dp6"] = {
				["enabled"] = true,
				["width"] = 440,
				["transparent"] = true,
			},
			["chathandle"] = true,
			["chatleft"] = {
				["width"] = 408,
			},
			["dp5"] = {
				["enabled"] = true,
				["width"] = 440,
				["transparent"] = true,
			},
		},
		["dt"] = {
			["friends"] = {
				["totals"] = true,
				["expandBNBroadcast"] = true,
				["combat"] = true,
				["hide_hintline"] = false,
			},
			["guild"] = {
				["totals"] = true,
				["combat"] = true,
			},
		},
		["loot"] = {
			["enable"] = true,
			["autoroll"] = {
				["autoconfirm"] = true,
				["autogreed"] = true,
			},
			["history"] = {
				["alpha"] = 0.7,
				["autohide"] = true,
			},
		},
		["marks"] = {
			["target"] = true,
			["mouseover"] = true,
			["growth"] = "UP",
			["size"] = 20,
		},
		["nameplate"] = {
			["showthreat"] = true,
		},
		["uibuttons"] = {
			["enable"] = true,
			["size"] = 20,
			["spacing"] = 4,
			["position"] = "uib_hor",
		},
	}
	
	E.db["movers"] = {
		["DP_6_Mover"] = "BOTTOMElvUIParentBOTTOM3170",
		["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM0189",
		["PetAB"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT55152",
		["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT019",
		["GMMover"] = "TOPLEFTElvUIParentTOPLEFT00",
		["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2000",
		["BossButton"] = "BOTTOMElvUIParentBOTTOM-1210",
		["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM29421",
		["MicrobarMover"] = "TOPElvUIParentTOP0-18",
		["VehicleSeatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT420205",
		["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM304140",
		["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0211",
		["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0210",
		["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM019",
		["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM13319",
		["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM0165",
		["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM0142",
		["ElvAB_4"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42520",
		["RightChatMover"] = "BOTTOMRIGHTUIParentBOTTOMRIGHT019",
		["AltPowerBarMover"] = "TOPElvUIParentTOP0-195",
		["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM-13319",
		["DP_5_Mover"] = "BOTTOMElvUIParentBOTTOM-3170",
		["ReputationBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-48919",
		["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-304140",
		["ElvUF_TargetTargetMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-551100",
		["ObjectiveFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-61-205",
		["PetBattleStatusMover"] = "TOPElvUIParentTOP0-69",
		["UIBFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT0-177",
		["ElvAB_5"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT42520",
		["RaidUtility_Mover"] = "TOPElvUIParentTOP-3060",
		["ArenaHeaderMover"] = "TOPLEFTElvUIParentTOPLEFT0-209",
		["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-11210",
		["PvPMover"] = "TOPElvUIParentTOP0-50",
		["BossHeaderMover"] = "TOPLEFTElvUIParentTOPLEFT0-209",
		["ElvUF_PetMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT551100",
		["PetBattleABMover"] = "BOTTOMElvUIParentBOTTOM020",
		["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0210",
		["AlertFrameMover"] = "BOTTOMElvUIParentBOTTOM0280",
		["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-200-143",
		["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT00",
		["ShiftAB"] = "BOTTOMElvUIParentBOTTOM-133116",
		["LootFrameMover"] = "BOTTOMElvUIParentBOTTOM-313527",
		["TotemBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT50123",
		["ExperienceBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT48919",
	}
	
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["glossTex"] = "Polished Wood"

	E.private["sle"]["inspectframeoptions"]["enable"] = true
	E.private["sle"]["characterframeoptions"]["enable"] = true
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["equip"]["spam"] = true
	E.private["sle"]["equip"]["setoverlay"] = true
	E.private["sle"]["marks"]["marks"] = true

	E.private["ElvUI_Currency"] = {
		["Unused"] = false,
	}

	if layout then
		if layout == 'tank' then AI:DarthTank() 
		elseif layout == 'dpsMelee' then AI:DarthPhys() 
		elseif layout == 'healer' then AI:DarthHeal() 
		end
	end
	
	if IsAddOnLoaded("ElvUI_LocLite") then
		E.db["loclite"] = {
			["dig"] = false,
			["lpwidth"] = 300,
			["lpauto"] = false,
			["lpfontsize"] = 10,
			["lpfontflags"] = "OUTLINE",
			["dtheight"] = 20,
		}
		E.db["movers"]["LocationLiteMover"] = "TOPElvUIParentTOP0-19"
		E.db["movers"]["MicrobarMover"] = "TOPElvUIParentTOP0-38"
		E.db["movers"]["PvPMover"] = "TOPElvUIParentTOP0-70"
	end

	if SLE:Auth() then
		E.db.hideTutorial = 1
		E.db.general.loginmessage = false
	end
	
	E:UpdateAll(true)
	
	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedOoCDelay"] = 5
		E.private["addonskins"]["EmbedOoC"] = true
		E.private["addonskins"]["DBMFontSize"] = 10
		E.private["addonskins"]["DBMSkinHalf"] = true
		E.private["addonskins"]["DBMFont"] = "ElvUI Font"
		E.private["addonskins"]["EmbedLeftWidth"] = 213
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]['EmbedLeft'] = 'Skada'
		E.private["addonskins"]['EmbedRight'] = 'Skada'
		E.private["addonskins"]["EmbedSystem"] = false
	end
end

local function RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
	SLEInstallStepComplete.message = L["Repooc's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end

	local layout = E.db.layoutSet

	if SLE:Auth() then
		E.db.hideTutorial = 1
		E.db.general.loginmessage = false
	end

	E.db["actionbar"] = {
		["bar3"] = {
			["point"] = "TOPLEFT",
			["buttons"] = 12,
		},
		["fontOutline"] = "OUTLINE",
		["bar2"] = {
			["enabled"] = true,
		},
		["bar5"] = {
			["point"] = "TOPLEFT",
			["buttons"] = 12,
		},
		["font"] = "Rubino",
		["fontSize"] = 12,
	}

	E.db["auras"] = {
		["consolidatedBuffs"] = {
			["font"] = "Intro Black",
			["fontOutline"] = "NONE",
		},
	}

	E.db["chat"] = {
		["font"] = "Univers",
		["tabFontSize"] = 12,
		["tabFont"] = "Rubino",
	}

	E.db["datatexts"] = {
		["minimapPanels"] = false,
		["panels"] = {
			["Top_Center"] = "S&L Guild",
			["Bottom_Panel"] = "S&L Friends",
			["DP_6"] = {
				["right"] = "Time",
				["left"] = "S&L Currency",
				["middle"] = "System",
			},
		},
		["leftChatPanel"] = false,
		["rightChatPanel"] = false,
	}

	E.db["general"] = {
		["bottomPanel"] = false,
		["valuecolor"] = {
			["r"] = 0,
			["g"] = 1,
			["b"] = 0.59,
		},
		["vendorGrays"] = true,
		["bordercolor"] = {
			["r"] = 0.31,
			["g"] = 0.31,
			["b"] = 0.31,
		},
		["font"] = "Rubino",
	}

	E.db["movers"] = {
		["BossButton"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-448415",
		["Bottom_Panel_Mover"] = "BOTTOMElvUIParentBOTTOM-3122",
		["DP_6_Mover"] = "BOTTOMElvUIParentBOTTOM02",
		["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM057",
		["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM022",
		["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM31223",
		["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-31223",
		["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-311145",
		["ElvUF_PetMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT410240",
		["ElvUF_RaidMover"] = "BOTTOMElvUIParentBOTTOM095",
		["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM311145",
		["ElvUF_TargetTargetMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-410240",
		["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-311122",
		["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT22",
		["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-22",
		["Top_Center_Mover"] = "BOTTOMElvUIParentBOTTOM3122",
	}

	E.db["nameplate"] = {
		["healthBar"] = {
			["text"] = {
				["enable"] = true,
				["format"] = "CURRENT_PERCENT",
			},
		},
		["threat"] = {
			["goodScale"] = 1.1,
		},
		["targetIndicator"] = {
			["color"] = {
				["g"] = 0,
				["b"] = 0,
			},
		},
		["font"] = "Intro Black",
		["fontOutline"] = "OUTLINE",
	}

	E.db["sle"] = {
		["characterframeoptions"] = {
			["image"] = {
				["dropdown"] = "ALLIANCE",
			},
		},
		["datatext"] = {
			["top"] = {
				["enabled"] = true,
				["width"] = 202,
			},
			["bottom"] = {
				["enabled"] = true,
				["width"] = 202,
			},
			["dp6"] = {
				["enabled"] = true,
				["width"] = 406,
			},
		},
		["loot"] = {
			["announcer"] = {
				["enable"] = true,
			},
			["autoroll"] = {
				["enable"] = false,
			},
			["enable"] = true,
		},
		["media"] = {
			["fonts"] = {
				["zone"] = {
					["font"] = "Durandal Light",
				},
				["subzone"] = {
					["font"] = "Durandal Light",
				},
				["pvp"] = {
					["font"] = "Trafaret",
					["size"] = 20,
				},
			},
		},
		["minimap"] = {
			["mapicons"] = {
				["skindungeon"] = true,
			},
		},
		["tooltip"] = {
			["showFaction"] = true,
		},
		["uibuttons"] = {
			["enable"] = true,
		},
	}

	E.db["tooltip"] = {
		["healthBar"] = {
		["font"] = "Rubino",
			["fontSize"] = 11,
		},
	}

	E.db["unitframe"] = {
		["colors"] = {
			["auraBarBuff"] = {
				["r"] = 0,
				["g"] = 1,
				["b"] = 0.59,
			},
			["healthclass"] = true,
			["castClassColor"] = true,
			["castColor"] = {
				["r"] = 0.1,
				["g"] = 0.1,
				["b"] = 0.1,
			},
			["health"] = {
				["r"] = 0.1,
				["g"] = 0.1,
				["b"] = 0.1,
			},
		},
		["statusbar"] = "Minimalist",
		["smoothbars"] = true,
		["units"] = {
			["raid40"] = {
				["colorOverride"] = "FORCE_OFF",
			},
			["raid"] = {
				["width"] = 79,
				["health"] = {
					["frequentUpdates"] = true,
					["orientation"] = "VERTICAL",
				},
				["GPSArrow"] = {
					["enable"] = false,
				},
				["colorOverride"] = "FORCE_OFF",
			},
			["target"] = {
				["castbar"] = {
					["width"] = 202,
				},
				["width"] = 202,
			},
			["player"] = {
				["restIcon"] = false,
				["castbar"] = {
					["width"] = 202,
				},
				["width"] = 202,
			},
		},
	}

	E.private["sle"]["inspectframeoptions"]["enable"] = true
	E.private["sle"]["characterframeoptions"]["enable"] = true
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["minimap"]["mapicons"]["barenable"] = true
	E.private["sle"]["equip"]["setoverlay"] = true
	E.private["sle"]["exprep"]["autotrack"] = true

	E:UpdateAll(true)

	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedOoC"] = false
		E.private["addonskins"]["DBMSkinHalf"] = true
		E.private["addonskins"]["DBMFont"] = "ElvUI Font"
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]["EmbedLeft"] = "Skada"
		E.private["addonskins"]["EmbedRight"] = "Skada"
		E.private["addonskins"]["EmbedSystem"] = false
	end
end

local function AffinitiiSetup() --The function to switch from class ElvUI settings to Affinitii's
	SLEInstallStepComplete.message = L["Affinitii's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	-- layout = E.db.layoutSet  --Pull which layout was selected if any.
	pixel = E.PixelMode  --Pull PixelMode
	
	E.db["sle"] = {
		["nameplate"] = {
			["showthreat"] = true,
			["targetcount"] = true,
		},
		["datatext"] = {
			["chathandle"] = true,
			["top"] = {
				["enabled"] = true,
				["transparent"] = true,
				["width"] = 100,
			},
			["bottom"] = {
				["enabled"] = true,
				["transparent"] = true,
				["width"] = 100,
			},
			["dp6"] = {
				["enabled"] = true,
				["transparent"] = true,
				["alpha"] = 0.8,
				["width"] = 399,
			},
		},
		["minimap"] = {
			["buttons"] = {
				["anchor"] = "VERTICAL",
				["mouseover"] = true,
			},
			["mapicons"] = {
				["skinmail"] = false,
				["iconmouseover"] = true,
			},
		},
	}
	
	E.db["movers"] = {
		["DP_6_Mover"] = "BOTTOMElvUIParentBOTTOM03",
		["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM096",
		["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT440511",
		["LeftChatMover"] = "BOTTOMLEFTUIParentBOTTOMLEFT021",
		["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT449511",
		["BossButton"] = "TOPLEFTElvUIParentTOPLEFT622-352",
		["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM-63436",
		["ClassBarMover"] = "BOTTOMElvUIParentBOTTOM-337500",
		["SquareMinimapBar"] = "TOPRIGHTElvUIParentTOPRIGHT-4-211",
		["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278200",
		["ElvUF_Raid40Mover"] = "TOPLEFTElvUIParentTOPLEFT447-468",
		["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM059",
		["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM025",
		["ElvAB_4"] = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-413200",
		["AltPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-300338",
		["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM25425",
		["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-25425",
		["MMButtonsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-214-160",
		["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278200",
		["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0190",
		["ShiftAB"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421",
		["RightChatMover"] = "BOTTOMRIGHTUIParentBOTTOMRIGHT021",
		["TotemBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421",
		["ArenaHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-210-410",
		["DP_5_Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4327",
		["Top_Center_Mover"] = "BOTTOMElvUIParentBOTTOM-2543",
		["BossHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-210435",
		["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0230",
		["ElvAB_6"] = "BOTTOMElvUIParentBOTTOM0102",
		["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT449511",
		["Bottom_Panel_Mover"] = "BOTTOMElvUIParentBOTTOM2543",
		["PetAB"] = "TOPRIGHTElvUIParentTOPRIGHT-4-433",
		["ElvUF_Raid25Mover"] = "TOPLEFTElvUIParentTOPLEFT449-448",
	}
	
	E.db["gridSize"] = 110
	
	E.db["tooltip"] = {
		["style"] = "inset",
		["visibility"] = {
			["combat"] = true,
		},
	}

	E.db["chat"] = {
		["timeStampFormat"] = "%I:%M ",
		["editBoxPosition"] = "ABOVE_CHAT",
		["lfgIcons"] = false,
		["emotionIcons"] = false,
	}
	
	E.db["unitframe"] = {
		["units"] = {
			["tank"] = {
				["enable"] = false,
			},
			["party"] = {
				["horizontalSpacing"] = 1,
				["debuffs"] = {
					["sizeOverride"] = 21,
					["yOffset"] = -7,
					["anchorPoint"] = "TOPRIGHT",
					["xOffset"] = -4,
				},
				["buffs"] = {
					["enable"] = true,
					["yOffset"] = 28,
					["anchorPoint"] = "BOTTOMLEFT",
					["clickThrough"] = true,
					["useBlacklist"] = false,
					["noDuration"] = false,
					["playerOnly"] = false,
					["perrow"] = 1,
					["useFilter"] = "TurtleBuffs",
					["noConsolidated"] = false,
					["sizeOverride"] = 22,
					["xOffset"] = 30,
				},
				["growthDirection"] = "LEFT_UP",
				["GPSArrow"] = {
					["size"] = 40,
				},
				["buffIndicator"] = {
					["size"] = 10,
				},
				["roleIcon"] = {
					["enable"] = false,
					["position"] = "BOTTOMRIGHT",
				},
				["targetsGroup"] = {
					["anchorPoint"] = "BOTTOM",
				},
				["power"] = {
					["text_format"] = "",
					["width"] = "inset",
				},
				["customTexts"] = {
					["Health Text"] = {
						["font"] = "ElvUI Pixel",
						["justifyH"] = "CENTER",
						["fontOutline"] = "MONOCHROMEOUTLINE",
						["xOffset"] = 0,
						["yOffset"] = -7,
						["text_format"] = "[healthcolor][health:deficit]",
						["size"] = 10,
					},
				},
				["healPrediction"] = true,
				["width"] = 80,
				["name"] = {
					["text_format"] = "[namecolor][name:veryshort] [difficultycolor][smartlevel]",
					["position"] = "TOP",
				},
				["health"] = {
					["frequentUpdates"] = true,
					["position"] = "BOTTOM",
					["text_format"] = "",
				},
				["height"] = 45,
				["verticalSpacing"] = 1,
				["petsGroup"] = {
					["anchorPoint"] = "BOTTOM",
				},
				["raidicon"] = {
					["attachTo"] = "LEFT",
					["xOffset"] = 9,
					["yOffset"] = 0,
					["size"] = 13,
				},
			},
			["raid40"] = {
				["horizontalSpacing"] = 1,
				["debuffs"] = {
					["enable"] = true,
					["yOffset"] = -9,
					["anchorPoint"] = "TOPRIGHT",
					["clickThrough"] = true,
					["useBlacklist"] = false,
					["perrow"] = 2,
					["useFilter"] = "Blacklist",
					["sizeOverride"] = 21,
					["xOffset"] = -4,
				},
				["rdebuffs"] = {
					["size"] = 26,
				},
				["growthDirection"] = "UP_LEFT",
				["health"] = {
					["frequentUpdates"] = true,
				},
				["power"] = {
					["enable"] = true,
					["width"] = "inset",
					["position"] = "CENTER",
				},
				["customTexts"] = {
					["Health Text"] = {
						["font"] = "ElvUI Pixel",
						["justifyH"] = "CENTER",
						["fontOutline"] = "MONOCHROMEOUTLINE",
						["xOffset"] = 0,
						["yOffset"] = -7,
						["text_format"] = "[healthcolor][health:deficit]",
						["size"] = 10,
					},
				},
				["healPrediction"] = true,
				["width"] = 50,
				["invertGroupingOrder"] = false,
				["name"] = {
					["text_format"] = "[namecolor][name:veryshort]",
					["position"] = "TOP",
				},
				["buffs"] = {
					["enable"] = true,
					["yOffset"] = 25,
					["anchorPoint"] = "BOTTOMLEFT",
					["clickThrough"] = true,
					["useBlacklist"] = false,
					["noDuration"] = false,
					["playerOnly"] = false,
					["perrow"] = 1,
					["useFilter"] = "TurtleBuffs",
					["noConsolidated"] = false,
					["sizeOverride"] = 17,
					["xOffset"] = 21,
				},
				["height"] = 43,
				["verticalSpacing"] = 1,
				["raidicon"] = {
					["attachTo"] = "LEFT",
					["xOffset"] = 9,
					["yOffset"] = 0,
					["size"] = 13,
				},
			},
			["focus"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["target"] = {
				["portrait"] = {
					["overlay"] = true,
				},
				["aurabar"] = {
					["enable"] = false,
				},
				["power"] = {
					["width"] = "inset",
					["height"] = 11,
				},
			},
			["raid"] = {
				["debuffs"] = {
					["countFontSize"] = 13,
					["fontSize"] = 9,
					["enable"] = true,
					["yOffset"] = -7,
					["anchorPoint"] = "TOPRIGHT",
					["sizeOverride"] = 21,
					["xOffset"] = -4,
				},
				["growthDirection"] = "LEFT_UP",
				["numGroups"] = 8,
				["roleIcon"] = {
					["enable"] = false,
				},
				["healPrediction"] = true,
				["power"] = {
					["height"] = 8,
				},
				["buffs"] = {
					["enable"] = true,
					["yOffset"] = 28,
					["anchorPoint"] = "BOTTOMLEFT",
					["clickThrough"] = true,
					["useBlacklist"] = false,
					["noDuration"] = false,
					["playerOnly"] = false,
					["perrow"] = 1,
					["useFilter"] = "TurtleBuffs",
					["noConsolidated"] = false,
					["sizeOverride"] = 22,
					["xOffset"] = 30,
				},
			},
			["focustarget"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["pettarget"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["pet"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["player"] = {
				["debuffs"] = {
					["attachTo"] = "BUFFS",
				},
				["portrait"] = {
					["overlay"] = true,
				},
				["classbar"] = {
					["detachFromFrame"] = true,
					["enable"] = false,
				},
				["aurabar"] = {
					["enable"] = false,
				},
				["power"] = {
					["width"] = "inset",
					["height"] = 11,
				},
				["buffs"] = {
					["enable"] = true,
					["noDuration"] = false,
					["attachTo"] = "FRAME",
				},
				["castbar"] = {
					["width"] = 399,
					["height"] = 25,
				},
			},
			["boss"] = {
				["portrait"] = {
					["enable"] = true,
					["overlay"] = true,
				},
				["power"] = {
					["width"] = "inset",
				},
			},
			["arena"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["targettarget"] = {
				["power"] = {
					["width"] = "inset",
				},
			},
			["assist"] = {
				["targetsGroup"] = {
					["enable"] = false,
				},
				["enable"] = false,
			},
		},
		["statusbar"] = "Polished Wood",
		["colors"] = {
			["auraBarBuff"] = {
				["b"] = 0.0941176470588236,
				["g"] = 0.0784313725490196,
				["r"] = 0.309803921568628,
			},
			["transparentPower"] = true,
			["castColor"] = {
				["b"] = 0.1,
				["g"] = 0.1,
				["r"] = 0.1,
			},
			["health"] = {
				["b"] = 0.235294117647059,
				["g"] = 0.235294117647059,
				["r"] = 0.235294117647059,
			},
			["transparentHealth"] = true,
			["transparentCastbar"] = true,
			["transparentAurabars"] = true,
		},
	}
	
	E.db["datatexts"] = {
		["minimapPanels"] = false,
		["fontSize"] = 12,
		["panelTransparency"] = true,
		["panels"] = {
			["DP_3"] = {
				["middle"] = "DPS",
			},
			["RightChatDataPanel"] = {
				["right"] = "Skada",
				["left"] = "Combat/Arena Time",
			},
			["DP_1"] = {
				["middle"] = "Friends",
			},
			["DP_5"] = {
				["middle"] = "Friends",
			},
			["LeftChatDataPanel"] = {
				["right"] = "Haste",
				["left"] = "Spell/Heal Power",
			},
			["RightMiniPanel"] = "Gold",
			["Top_Center"] = "WIM",
			["Bottom_Panel"] = "Talent/Loot Specialization",
			["DP_6"] = {
				["right"] = "Gold",
				["left"] = "System",
				["middle"] = "Time",
			},
			["DP_2"] = {
				["middle"] = "Attack Power",
			},
			["LeftMiniPanel"] = "Time",
		},
		["font"] = "ElvUI Font",
		["fontOutline"] = "None",
		["battleground"] = false,
	}
	
	E.db["actionbar"] = {
		["bar3"] = {
			["buttonspacing"] = 1,
			["buttonsPerRow"] = 3,
			["alpha"] = 0.4,
		},
		["bar2"] = {
			["enabled"] = true,
			["buttonspacing"] = 1,
			["alpha"] = 0.6,
		},
		["bar5"] = {
			["buttonspacing"] = 1,
			["buttonsPerRow"] = 3,
			["alpha"] = 0.4,
		},
		["bar1"] = {
			["buttonspacing"] = 1,
			["alpha"] = 0.6,
		},
		["stanceBar"] = {
			["buttonsPerRow"] = 1,
			["alpha"] = 0.6,
		},
		["bar4"] = {
			["enabled"] = false,
			["point"] = "BOTTOMLEFT",
			["alpha"] = 0.4,
			["buttonsPerRow"] = 6,
			["backdrop"] = false,
		},
	}
	
	E.db["general"] = {
		["autoRepair"] = "GUILD",
		["bottomPanel"] = false,
		["backdropfadecolor"] = {
			["b"] = 0.054,
			["g"] = 0.054,
			["r"] = 0.054,
		},
		["valuecolor"] = {
			["b"] = 0.819,
			["g"] = 0.513,
			["r"] = 0.09,
		},
		["threat"] = {
			["position"] = "LEFTCHAT",
		},
		["topPanel"] = false,
		["health"] = {
		},
		["BUFFS"] = {
		},
		["vendorGrays"] = true,
	}
	
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["chatBubbles"] = "nobackdrop"
	E.private["general"]["glossTex"] = "Polished Wood"
	
	E.private["skins"] = {
		["addons"] = {
			["EmbedSystemDual"] = true,
			["EmbedMain"] = "Skada, Skada",
			["EmbedalDamageMeter"] = false,
			["TransparentEmbed"] = true,
		},
	}
	
	
	E.private["sle"]["inspectframeoptions"]["enable"] = true
	E.private["sle"]["characterframeoptions"]["enable"] = true
	
	E.private["theme"] = "default"

	E:UpdateAll(true)
	
	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedSystem"] = false
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]['EmbedLeft'] = 'Skada'
		E.private["addonskins"]['EmbedRight'] = 'Skada'
	end
end

local function InstallComplete()
	E.private.sle.install_complete = SLE.version

	if GetCVarBool("Sound_EnableMusic") then
		StopMusic()
	end

	ReloadUI()
end

local function ResetAll()
	SLEInstallNextButton:Disable()
	SLEInstallPrevButton:Disable()
	SLEInstallOption1Button:Hide()
	SLEInstallOption1Button:SetScript("OnClick", nil)
	SLEInstallOption1Button:SetText("")
	SLEInstallOption2Button:Hide()
	SLEInstallOption2Button:SetScript('OnClick', nil)
	SLEInstallOption2Button:SetText('')
	SLEInstallOption3Button:Hide()
	SLEInstallOption3Button:SetScript('OnClick', nil)
	SLEInstallOption3Button:SetText('')	
	SLEInstallOption4Button:Hide()
	SLEInstallOption4Button:SetScript('OnClick', nil)
	SLEInstallOption4Button:SetText('')
	SLEInstallFrame.SubTitle:SetText("")
	SLEInstallFrame.Desc1:SetText("")
	SLEInstallFrame.Desc2:SetText("")
	SLEInstallFrame.Desc3:SetText("")
	SLEInstallFrame:Size(550, 400)
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	SLEInstallStatus:SetValue(PageNum)

	local f = SLEInstallFrame

	if PageNum == MAX_PAGE then
		SLEInstallNextButton:Disable()
	else
		SLEInstallNextButton:Enable()
	end

	if PageNum == 1 then
		SLEInstallPrevButton:Disable()
	else
		SLEInstallPrevButton:Enable()
	end

	if PageNum == 1 then
		f.SubTitle:SetText(format(L["Welcome to |cff1784d1Shadow & Light|r version %s!"], SLE.version))
		f.Desc1:SetText(L["This will take you through a quick install process to setup some Shadow & Light features.\nIf you choose to not setup any options through this config, click Skip Process button to finish the installation."])
		f.Desc2:SetText("")
		f.Desc3:SetText(L["Please press the continue button to go onto the next step."])

		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", InstallComplete)
		SLEInstallOption1Button:SetText(L["Skip Process"])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L["Chat"])
		f.Desc1:SetText(L["This will determine if you want to use ElvUI's default layout for chat datatext panels or let Shadow & Light handle them."])
		f.Desc2:SetText(L["If you select S&L Panels, the datatext panels will be attached below the left and right chat frames instead of being inside the chat frame."])
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", function() E.db.sle.datatext.chathandle = false; E:GetModule('Layout'):ToggleChatPanels() end)
		SLEInstallOption1Button:SetText("ElvUI")
		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() E.db.sle.datatext.chathandle = true; E:GetModule('Layout'):ToggleChatPanels() end)
		SLEInstallOption2Button:SetText("Shadow & Light")
	elseif PageNum == 3 then
		f.SubTitle:SetText(L["Armory Mode"])
		f.Desc1:SetText(L["SLE_ARMORY_INSTALL"])
		f.Desc2:SetText(L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
		
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript('OnClick', function() E.private.sle.characterframeoptions.enable = true; E.private.sle.inspectframeoptions.enable = true; end)
		SLEInstallOption1Button:SetText(ENABLE)

		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() E.private.sle.characterframeoptions.enable = true; E.private.sle.inspectframeoptions.enable = true; end)
		SLEInstallOption2Button:SetText(DISABLE)

	elseif PageNum == 4 then
		f.SubTitle:SetText(L["Shadow & Light Layouts"])
		f.Desc1:SetText(L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."])
		local word = E.db.layoutSet == 'tank' and L["Tank"] or E.db.layoutSet == 'healer' and L["Healer"] or E.db.layoutSet == 'dpsMelee' and L['Physical DPS'] or E.db.layoutSet == 'dpsCaster' and L['Caster DPS'] or NONE
		f.Desc2:SetText(format(L["SLE_Install_Text2"], word))
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript('OnClick', function() AI:DarthSetup() end)
		SLEInstallOption1Button:SetText(L["Darth's Config"])	

		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() AffinitiiSetup() end)
		SLEInstallOption2Button:SetText(L["Affinitii's Config"])

		SLEInstallOption3Button:Show()
		SLEInstallOption3Button:SetScript('OnClick', function() RepoocSetup() end)
		SLEInstallOption3Button:SetText(L["Repooc's Config"])
		
		SLEInstallFrame:Size(550, 500)
	elseif PageNum == 5 then 
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", InstallComplete)
		SLEInstallOption1Button:SetText(L["Finished"])				
		SLEInstallFrame:Size(550, 400)
	end
end

local function NextPage()
	if CURRENT_PAGE ~= MAX_PAGE then
		CURRENT_PAGE = CURRENT_PAGE + 1
		SetPage(CURRENT_PAGE)
	end
end

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then
		CURRENT_PAGE = CURRENT_PAGE - 1
		SetPage(CURRENT_PAGE)
	end
end

--Install UI
function SLE:Install()
	if not SLEInstallStepComplete then
		local imsg = CreateFrame("Frame", "SLEInstallStepComplete", E.UIParent)
		imsg:Size(418, 72)
		imsg:Point("TOP", 0, -190)
		imsg:Hide()
		imsg:SetScript('OnShow', function(self)
			if self.message then 
				PlaySoundFile([[Sound\Interface\LevelUp.wav]])
				self.text:SetText(self.message)
				UIFrameFadeOut(self, 3.5, 1, 0)
				E:Delay(4, function() self:Hide() end)	
				self.message = nil

				if imsg.firstShow == false then
					if GetCVarBool("Sound_EnableMusic") then
						PlayMusic([[Sound\Music\ZoneMusic\DMF_L70ETC01.mp3]])
					end					
					imsg.firstShow = true
				end
			else
				self:Hide()
			end
		end)

		imsg.firstShow = false

		imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.bg:SetPoint('BOTTOM')
		imsg.bg:Size(326, 103)
		imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
		imsg.bg:SetVertexColor(1, 1, 1, 0.6)

		imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
		imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineTop:SetPoint("TOP")
		imsg.lineTop:Size(418, 7)
		imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

		imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
		imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineBottom:SetPoint("BOTTOM")
		imsg.lineBottom:Size(418, 7)
		imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

		imsg.text = imsg:CreateFontString(nil, 'ARTWORK', 'GameFont_Gigantic')
		imsg.text:Point("BOTTOM", 0, 12)
		imsg.text:SetTextColor(1, 0.82, 0)
		imsg.text:SetJustifyH("CENTER")
	end

	--Create Frame
	if not SLEInstallFrame then
		local f = CreateFrame("Button", "SLEInstallFrame", E.UIParent)
		f.SetPage = SetPage
		f:Size(550, 400)
		f:SetTemplate("Transparent")
		f:SetPoint("CENTER")
		f:SetFrameStrata('TOOLTIP')

		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point("TOP", 0, -5)
		f.Title:SetText(L["|cff1784d1Shadow & Light|r Installation"])

		f.Next = CreateFrame("Button", "SLEInstallNextButton", f, "UIPanelButtonTemplate")
		f.Next:StripTextures()
		f.Next:SetTemplate("Default", true)
		f.Next:Size(110, 25)
		f.Next:Point("BOTTOMRIGHT", -5, 5)
		f.Next:SetText(CONTINUE)
		f.Next:Disable()
		f.Next:SetScript("OnClick", NextPage)
		E.Skins:HandleButton(f.Next, true)

		f.Prev = CreateFrame("Button", "SLEInstallPrevButton", f, "UIPanelButtonTemplate")
		f.Prev:StripTextures()
		f.Prev:SetTemplate("Default", true)
		f.Prev:Size(110, 25)
		f.Prev:Point("BOTTOMLEFT", 5, 5)
		f.Prev:SetText(PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript("OnClick", PreviousPage)
		E.Skins:HandleButton(f.Prev, true)

		f.Status = CreateFrame("StatusBar", "SLEInstallStatus", f)
		f.Status:SetFrameLevel(f.Status:GetFrameLevel() + 2)
		f.Status:CreateBackdrop("Default")
		f.Status:SetStatusBarTexture(E["media"].normTex)
		f.Status:SetStatusBarColor(unpack(E["media"].rgbvaluecolor))
		f.Status:SetMinMaxValues(0, MAX_PAGE)
		f.Status:Point("TOPLEFT", f.Prev, "TOPRIGHT", 6, -2)
		f.Status:Point("BOTTOMRIGHT", f.Next, "BOTTOMLEFT", -6, 2)
		f.Status.text = f.Status:CreateFontString(nil, 'OVERLAY')
		f.Status.text:FontTemplate()
		f.Status.text:SetPoint("CENTER")
		f.Status.text:SetText(CURRENT_PAGE.." / "..MAX_PAGE)
		f.Status:SetScript("OnValueChanged", function(self)
			self.text:SetText(self:GetValue().." / "..MAX_PAGE)
		end)

		f.Option1 = CreateFrame("Button", "SLEInstallOption1Button", f, "UIPanelButtonTemplate")
		f.Option1:StripTextures()
		f.Option1:Size(160, 30)
		f.Option1:Point("BOTTOM", 0, 55)
		f.Option1:SetText("")
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)

		f.Option2 = CreateFrame("Button", "SLEInstallOption2Button", f, "UIPanelButtonTemplate")
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 55)
		f.Option2:SetText("")
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 55) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 55) end)
		E.Skins:HandleButton(f.Option2, true)		

		f.Option3 = CreateFrame("Button", "SLEInstallOption3Button", f, "UIPanelButtonTemplate")
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText("")
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 55)  end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 55); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 55) end)
		E.Skins:HandleButton(f.Option3, true)			

		f.Option4 = CreateFrame("Button", "SLEInstallOption4Button", f, "UIPanelButtonTemplate")
		f.Option4:StripTextures()
		f.Option4:Size(100, 30)
		f.Option4:Point('LEFT', f.Option3, 'RIGHT', 4, 0)
		f.Option4:SetText("")
		f.Option4:Hide()
		f.Option4:SetScript('OnShow', function() 
			f.Option1:Width(100)
			f.Option2:Width(100)

			f.Option1:ClearAllPoints(); 
			f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); 
			f.Option2:ClearAllPoints(); 
			f.Option2:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 55)  
		end)
		f.Option4:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 55); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 55) end)
		E.Skins:HandleButton(f.Option4, true)	

		f.SubTitle = f:CreateFontString(nil, 'OVERLAY')
		f.SubTitle:FontTemplate(nil, 15, nil)		
		f.SubTitle:Point("TOP", 0, -40)
		
		f.Desc1 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc1:FontTemplate()	
		f.Desc1:Point("TOPLEFT", 20, -75)	
		f.Desc1:Width(f:GetWidth() - 40)
		
		f.Desc2 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc2:FontTemplate()	
		f.Desc2:Point("TOPLEFT", 20, -125)		
		f.Desc2:Width(f:GetWidth() - 40)
		
		f.Desc3 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc3:FontTemplate()	
		f.Desc3:Point("TOP", f.Desc2, "BOTTOM", 0, -30)	
		f.Desc3:Width(f:GetWidth() - 40)
		local close = CreateFrame("Button", "SLEInstallCloseButton", f, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
		close:SetScript("OnClick", function()
			f:Hide()
			CURRENT_PAGE = 0
		end)		
		E.Skins:HandleCloseButton(close)

		f.tutorialImage = f:CreateTexture('SLEInstallTutorialImage', 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner')
		f.tutorialImage:Point('BOTTOM', 0, 85)
	end

	SLEInstallFrame:Show()
	NextPage()
end