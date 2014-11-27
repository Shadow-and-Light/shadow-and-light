local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

function AI:DarthCaster()
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Crit Chance"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Spell/Heal Power"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Haste"
	
	--Movers--
	do
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-279140"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM0142"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM279140"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM279119"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM-309114"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM26556"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM30934"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM23493"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["BossButton"] = "BOTTOMElvUIParentBOTTOM0168"
		E.db["movers"]["AlertFrameMover"] = "BOTTOMElvUIParentBOTTOM0234"
		E.db["movers"]["ComboBarMover"] = nil
		E.db["movers"]["ClassBarMover"] = nil
	end
end

function AI:DarthTank()
	E.db["nameplate"]["healthBar"]["lowHPScale"]["toFront"] = false
	E.db["nameplate"]["healthBar"]["lowThreshold"] = 0
	E.db["nameplate"]["threat"]["badScale"] = 1.2
	E.db["nameplate"]["threat"]["badColor"] = {
		["r"] = 0.780392156862745,
		["g"] = 0.0784313725490196,
		["b"] = 0.101960784313725,
	}
	
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Armor"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Avoidance"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Resolve"
	--Movers--
	do
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-279140"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM0142"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM279140"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM279119"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM-309114"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM26556"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM30934"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM23493"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["BossButton"] = "BOTTOMElvUIParentBOTTOM0168"
		E.db["movers"]["AlertFrameMover"] = "BOTTOMElvUIParentBOTTOM0234"
		E.db["movers"]["ComboBarMover"] = nil
		E.db["movers"]["ClassBarMover"] = nil
	end
end

function AI:DarthPhys()
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Crit Chance"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Attack Power"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Haste"

	E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["target"]["combobar"]["detachFromFrame"] = true
	--Movers--
	do
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-279140"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM0142"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM279140"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM279119"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM-309114"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM26556"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM30934"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM23493"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT0207"
		E.db["movers"]["BossButton"] = "BOTTOMElvUIParentBOTTOM0168"
		E.db["movers"]["AlertFrameMover"] = "BOTTOMElvUIParentBOTTOM0234"
		E.db["movers"]["ComboBarMover"] = "BOTTOMElvUIParentBOTTOM0356"
		E.db["movers"]["ClassBarMover"] = "BOTTOMElvUIParentBOTTOM0364"
	end
end

function AI:DarthHeal()
	do
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 18
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 190
		
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = "[healthcolor][health:sl:darth-heal]"
		
		E.db["unitframe"]["units"]["party"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][health:deficit]"

		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["xOffset"] = -27
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["yOffset"] = 8
		E.db["unitframe"]["units"]["raid"]["healPrediction"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[healthcolor][health:deficit]"
	end
	--Movers--
	do
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-289137"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-289116"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM289137"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM289116"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM-31988"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMElvUIParentBOTTOM26554"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMElvUIParentBOTTOM30932"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM24489"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT768134"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT768134"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT768134"
		E.db["movers"]["BossButton"] = "BOTTOMElvUIParentBOTTOM-31822"
		E.db["movers"]["AlertFrameMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT198207"
		E.db["movers"]["ComboBarMover"] = nil
		E.db["movers"]["ClassBarMover"] = nil
	end
end

function AI:DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	local layout = E.db.layoutSet
	local word = layout == 'tank' and L["Tank"] or layout == 'healer' and L["Healer"] or layout == 'dpsMelee' and L['Physical DPS'] or L['Caster DPS']
	SLEInstallStepComplete.message = L["Darth's Defaults Set"]..": "..word
	SLEInstallStepComplete:Show()
	E:CopyTable(E.db, P)
	E:CopyTable(E.private, V)
	if not E.db.movers then E.db.movers = {}; end
	--General--
	do
		E.db["general"]["threat"]["enable"] = false
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["hideErrorFrame"] = false
		E.db["general"]["reputation"]["height"] = 187
		E.db["general"]["afk"] = false
		E.db["general"]["autoRepair"] = "PLAYER"
		E.db["general"]["minimap"]["locationText"] = "HIDE"
		E.db["general"]["minimap"]["icons"]["garrison"]["position"] = "BOTTOMLEFT"
		E.db["general"]["experience"]["height"] = 187
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["vendorGrays"] = true
	end
	--Nameplates--
	do
		E.db["nameplate"]["fontSize"] = 10
		E.db["nameplate"]["healthBar"]["height"] = 10
		E.db["nameplate"]["healthBar"]["text"]["enable"] = true
		E.db["nameplate"]["healthBar"]["lowHPScale"]["enable"] = true
		E.db["nameplate"]["healthBar"]["lowHPScale"]["height"] = 10
		E.db["nameplate"]["colorNameByValue"] = false
		E.db["nameplate"]["debuffs"]["numAuras"] = 6
		E.db["nameplate"]["debuffs"]["font"] = "ElvUI Font"
		E.db["nameplate"]["debuffs"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["debuffs"]["stretchTexture"] = false
		E.db["nameplate"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["font"] = "ElvUI Font"
		E.db["nameplate"]["buffs"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["buffs"]["font"] = "ElvUI Font"
		E.db["nameplate"]["raidHealIcon"]["xOffset"] = 0
	end
	--Bags--
	do
		E.db["bags"]["bagWidth"] = 425
		E.db["bags"]["yOffsetBank"] = 181
		E.db["bags"]["currencyFormat"] = "ICON"
		E.db["bags"]["yOffset"] = 181
		E.db["bags"]["bankSize"] = 31
		E.db["bags"]["bankWidth"] = 425
		E.db["bags"]["moneyFormat"] = "CONDENSED"
		E.db["bags"]["bagSize"] = 31
		E.db["bags"]["alignToChat"] = false
	end
	--Chat--
	do
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["tabFont"] = "ElvUI Font"
		E.db["chat"]["tabFontSize"] = 11
		E.db["chat"]["editboxhistory"] = 10
		E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT"
		E.db["chat"]["emotionIcons"] = false
		E.db["chat"]["panelHeight"] = 187
		E.db["chat"]["panelHeightRight"] = 187
		E.db["chat"]["panelWidthRight"] = 425
		E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
		E.db["chat"]["panelWidth"] = 425
	end
	--Tooltip--
	E.db["tooltip"]["healthBar"]["font"] = "ElvUI Font"
	E.db["tooltip"]["itemCount"] = "BOTH"
	--Unitframes--
	do
		E.db["unitframe"]["smartRaidFilter"] = false
		E.db["unitframe"]["fontSize"] = 11
		E.db["unitframe"]["debuffHighlighting"] = false
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["statusbar"] = "Polished Wood"
		E.db["unitframe"]["font"] = "ElvUI Font"
		E.db["unitframe"]["colors"]["castNoInterrupt"]["b"] = 0.250980392156863
		E.db["unitframe"]["colors"]["castNoInterrupt"]["g"] = 0.250980392156863
		E.db["unitframe"]["colors"]["castNoInterrupt"]["r"] = 0.780392156862745
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.109803921568627
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.552941176470588
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.317647058823529
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["healthclass"] = true
		
		E.db["unitframe"]["units"]["player"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["portrait"]["rotation"] = 345
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 20
		E.db["unitframe"]["units"]["player"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 300
		E.db["unitframe"]["units"]["player"]["width"] = 190
		E.db["unitframe"]["units"]["player"]["aurabar"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["aurabar"]["maxBars"] = 8
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = "||cFFB04F4F[pvptimer]||r"
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = "[healthcolor][health:current-percent:sl]"
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["player"]["lowmana"] = 0
		E.db["unitframe"]["units"]["player"]["height"] = 40
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current:sl]"
		E.db["unitframe"]["units"]["player"]["power"]["attachTextToPower"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 8
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 22
		
		E.db["unitframe"]["units"]["target"]["combobar"]["height"] = 8
		E.db["unitframe"]["units"]["target"]["combobar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["target"]["portrait"]["rotation"] = 345
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 190
		E.db["unitframe"]["units"]["target"]["width"] = 190
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = "[namecolor][name:medium] [difficultycolor][level] [shortclassification]"
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["height"] = 40
		E.db["unitframe"]["units"]["target"]["buffs"]["useBlacklist"]["enemy"] = false
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["attachTextToPower"] = true
		E.db["unitframe"]["units"]["target"]["power"]["position"] = "RIGHT"
		
		E.db["unitframe"]["units"]["targettarget"]["height"] = 25
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100
		
		E.db["unitframe"]["units"]["focus"]["height"] = 30
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["sizeOverride"] = 29
		E.db["unitframe"]["units"]["focus"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["focus"]["width"] = 160
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 248
		
		E.db["unitframe"]["units"]["pet"]["height"] = 25
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5

		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][health:current]"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 13
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["height"] = 35
		E.db["unitframe"]["units"]["party"]["GPSArrow"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["width"] = 75
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOP"
		
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 2
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 18
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 6
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid"]["height"] = 35
		E.db["unitframe"]["units"]["raid"]["width"] = 75
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show"
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[healthcolor][health:current]"
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "BOTTOMLEFT"
		
		E.db["unitframe"]["units"]["raid40"]["height"] = 25
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid40"]["visibility"] = "[@raid31,noexists] hide;show"
		E.db["unitframe"]["units"]["raid40"]["width"] = 75
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 2
		
		E.db["unitframe"]["units"]["assist"]["enable"] = false
		E.db["unitframe"]["units"]["tank"]["enable"] = false
		
		E.db["unitframe"]["units"]["arena"]["width"] = 198
		E.db["unitframe"]["units"]["arena"]["pvpTrinket"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"
		E.db["unitframe"]["units"]["arena"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["arena"]["height"] = 40
		E.db["unitframe"]["units"]["arena"]["health"]["text_format"] = "[healthcolor][health:current-percent:sl]"
		E.db["unitframe"]["units"]["arena"]["castbar"]["height"] = 15
		E.db["unitframe"]["units"]["arena"]["castbar"]["width"] = 198
		E.db["unitframe"]["units"]["arena"]["growthDirection"] = "DOWN"

		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = "[healthcolor][health:current-percent:sl]"
		E.db["unitframe"]["units"]["boss"]["castbar"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["height"] = 40
		E.db["unitframe"]["units"]["boss"]["width"] = 198
		E.db["unitframe"]["units"]["boss"]["growthDirection"] = "DOWN"
	end
	--Datatexts--
	do
		E.db["datatexts"]["minimapPanels"] = false
		E.db["datatexts"]["font"] = "ElvUI Font"
		E.db["datatexts"]["goldFormat"] = "CONDENSED"
		E.db["datatexts"]["panelTransparency"] = true
		E.db["datatexts"]["time24"] = true
		E.db["datatexts"]["panels"]["Bottom_Panel"] = "System"
		E.db["datatexts"]["panels"]["DP_5"]["right"] = "Durability"
		E.db["datatexts"]["panels"]["DP_5"]["left"] = "S&L Currency"
		E.db["datatexts"]["panels"]["DP_5"]["middle"] = "Bags"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Mastery"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "S&L Friends"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Combat/Arena Time"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = "S&L Guild"
	end
	--Actionbars--
	do
		E.db["actionbar"]["fontSize"] = 12
		E.db["actionbar"]["keyDown"] = false
		E.db["actionbar"]["font"] = "ElvUI Font"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["hotkeytext"] = false
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar1"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar2"]["buttonsize"] = 28
		E.db["actionbar"]["bar2"]["visibility"] = " [petbattle] hide; show"
		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar3"]["buttonsize"] = 28
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar4"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar4"]["buttonspacing"] = 1
		E.db["actionbar"]["bar4"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar4"]["buttonsize"] = 30
		E.db["actionbar"]["bar4"]["backdrop"] = false
		E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonspacing"] = 1
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["visibility"] = " [petbattle] hide; show"
		E.db["actionbar"]["microbar"]["enabled"] = true
		E.db["actionbar"]["microbar"]["buttonsPerRow"] = 11
		E.db["actionbar"]["stanceBar"]["style"] = "classic"
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 20
		E.db["actionbar"]["barPet"]["point"] = "TOPLEFT"
		E.db["actionbar"]["barPet"]["buttonspacing"] = 1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 2
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsize"] = 18
	end
	--Auras--
	do
		E.db["auras"]["font"] = "ElvUI Font"
		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["consolidatedBuffs"]["filter"] = false
		E.db["auras"]["consolidatedBuffs"]["font"] = "ElvUI Font"
		E.db["auras"]["consolidatedBuffs"]["fontSize"] = 11
		E.db["auras"]["consolidatedBuffs"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["buffs"]["size"] = 26
		E.db["auras"]["debuffs"]["size"] = 26
	end
	--SLE--
	do
		E.db["sle"]["nameplate"]["showthreat"] = true
		E.db["sle"]["threat"]["enable"] = false
		E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["screensaver"]["enable"] = true
		E.db["sle"]["media"]["screensaver"]["xpack"] = 200
		E.db["sle"]["media"]["screensaver"]["playermodel"]["rotation"] = 345
		E.db["sle"]["media"]["screensaver"]["playermodel"]["xaxis"] = 0.1
		E.db["sle"]["media"]["screensaver"]["playermodel"]["yaxis"] = -0.2
		E.db["sle"]["media"]["screensaver"]["playermodel"]["distance"] = 0
		E.db["sle"]["media"]["screensaver"]["playermodel"]["anim"] = 70
		E.db["sle"]["media"]["screensaver"]["playermodel"]["width"] = 650
		E.db["sle"]["media"]["screensaver"]["crest"] = 150
		E.db["sle"]["characterframeoptions"]["image"]["dropdown"] = "CASTLE"
		E.db["sle"]["datatext"]["chathandle"] = true
		E.db["sle"]["datatext"]["chatleft"]["width"] = 408
		E.db["sle"]["datatext"]["chatright"]["width"] = 408
		E.db["sle"]["datatext"]["top"]["enabled"] = true
		E.db["sle"]["datatext"]["top"]["transparent"] = true
		E.db["sle"]["datatext"]["bottom"]["enabled"] = true
		E.db["sle"]["datatext"]["bottom"]["transparent"] = true
		E.db["sle"]["datatext"]["bottom"]["width"] = 196
		E.db["sle"]["datatext"]["dp5"]["enabled"] = true
		E.db["sle"]["datatext"]["dp5"]["transparent"] = true
		E.db["sle"]["datatext"]["dp5"]["width"] = 440
		E.db["sle"]["datatext"]["dp6"]["enabled"] = true
		E.db["sle"]["datatext"]["dp6"]["transparent"] = true
		E.db["sle"]["datatext"]["dp6"]["width"] = 440
		E.db["sle"]["dt"]["friends"]["sortBN"] = "REALID"
		E.db["sle"]["dt"]["friends"]["combat"] = true
		E.db["sle"]["dt"]["friends"]["hide_hintline"] = false
		E.db["sle"]["dt"]["friends"]["totals"] = true
		E.db["sle"]["dt"]["friends"]["expandBNBroadcast"] = true
		E.db["sle"]["dt"]["guild"]["totals"] = true
		E.db["sle"]["dt"]["guild"]["combat"] = true
		E.db["sle"]["loot"]["enable"] = true
		E.db["sle"]["loot"]["autoroll"]["autode"] = true
		E.db["sle"]["loot"]["autoroll"]["autoconfirm"] = true
		E.db["sle"]["loot"]["autoroll"]["autogreed"] = true
		E.db["sle"]["loot"]["history"]["alpha"] = 0.7
		E.db["sle"]["loot"]["history"]["autohide"] = true
		E.db["sle"]["combatico"]["pos"] = "BOTTOMLEFT"
		E.db["sle"]["tooltip"]["showFaction"] = true
		E.db["sle"]['raidmarkers']['visibility'] = 'INPARTY'
		E.db["sle"]['raidmarkers']['buttonSize'] = 16
		E.db["sle"]['raidmarkers']['spacing'] = 1
		E.db["sle"]['raidmarkers']['reverse'] = true
		E.db["sle"]["uibuttons"]["yoffset"] = -2
		E.db["sle"]["uibuttons"]["point"] = "TOPRIGHT"
		E.db["sle"]["uibuttons"]["spacing"] = 1
		E.db["sle"]["uibuttons"]["enable"] = true
		E.db["sle"]["uibuttons"]["anchor"] = "BOTTOMRIGHT"
		E.db["sle"]["uibuttons"]["position"] = "uib_hor"
		E.db["sle"]["uibuttons"]["size"] = 20
	end
	--Movers--
	do
		E.db["movers"]["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM019"
		E.db["movers"]["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM12419"
		E.db["movers"]["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM-12419"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42520"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT42520"
		E.db["movers"]["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-11210"
		E.db["movers"]["PetAB"] = "BOTTOMElvUIParentBOTTOM-20320"
		E.db["movers"]["ShiftAB"] = "BOTTOMElvUIParentBOTTOM-133108"
		E.db["movers"]["MicrobarMover"] = "TOPElvUIParentTOP0-19"
		E.db["movers"]["Top_Center_Mover"] = "TOPElvUIParentTOP00"
		E.db["movers"]["DP_5_Mover"] = "BOTTOMElvUIParentBOTTOM-3170"
		E.db["movers"]["DP_6_Mover"] = "BOTTOMElvUIParentBOTTOM3170"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT019"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
		E.db["movers"]["GMMover"] = "TOPLEFTElvUIParentTOPLEFT2790"
		E.db["movers"]["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-200-1"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-200-130"
		E.db["movers"]["GhostFrameMover"] = "TOPElvUIParentTOP2570"
		E.db["movers"]["LootFrameMover"] = "BOTTOMElvUIParentBOTTOM-313527"
		E.db["movers"]["DigSiteProgressBarMover"] = "TOPElvUIParentTOP0-106"
		E.db["movers"]["AltPowerBarMover"] = "TOPElvUIParentTOP0-113"
		E.db["movers"]["VehicleSeatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT420205"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT48919"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-48919"
		E.db["movers"]["PetBattleStatusMover"] = "TOPElvUIParentTOP0-69"
		E.db["movers"]["PetBattleABMover"] = "BOTTOMElvUIParentBOTTOM020"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFTElvUIParentTOPLEFT870"
		E.db["movers"]["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-86-179"
		E.db["movers"]["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT00"
		E.db["movers"]["PvPMover"] = "TOPElvUIParentTOP0-51"
		E.db["movers"]["RaidUtility_Mover"] = "TOPElvUIParentTOP-3060"
		E.db["movers"]["UIBFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT2-179"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT0-202"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT0-202"
		E.db["movers"]["TotemBarMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT50123"
		E.db["movers"]["RaidMarkerBarAnchor"] = "BOTTOMElvUIParentBOTTOM0114"
	end
	
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["glossTex"] = "Polished Wood"

	E.private["sle"]["inspectframeoptions"]["enable"] = true
	E.private["sle"]["characterframeoptions"]["enable"] = true
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["equip"]["spam"] = true
	E.private["sle"]["equip"]["setoverlay"] = true
	E.private["sle"]["marks"]["marks"] = true

	E.private["ElvUI_Currency"]["Unused"] = false
	E.private["ElvUI_Currency"]["Archaeology"] = false

	if layout then
		if layout == 'tank' then AI:DarthTank() 
		elseif layout == 'dpsMelee' then AI:DarthPhys() 
		elseif layout == 'healer' then AI:DarthHeal() 
		else AI:DarthCaster()
		end
		E.db.layoutSet = layout
	else
		AI:DarthCaster()
	end
	
	if IsAddOnLoaded("ElvUI_LocLite") then
		E.db["loclite"]["lpwidth"] = 300
		E.db["loclite"]["dtheight"] = 20
		E.db["loclite"]["lpfontsize"] = 10
		E.db["loclite"]["EmbedLeft"] = "Skada"
		E.db["loclite"]["EmbedRight"] = "Skada"
		E.db["loclite"]["dig"] = false
		E.db["loclite"]["lpauto"] = false
		E.db["loclite"]["lpfontflags"] = "OUTLINE"
		E.db["movers"]["LocationLiteMover"] = "TOPElvUIParentTOP00"
		E.db["movers"]["MicrobarMover"] = "TOPElvUIParentTOP0-38"
		E.db["movers"]["Top_Center_Mover"] = "TOPElvUIParentTOP0-19"
		E.db["movers"]["PvPMover"] = "TOPElvUIParentTOP0-70"
	end

	if SLE:Auth() then
		E.db["hideTutorial"] = true
		E.db["general"]["loginmessage"] = false
		E.db["tooltip"]["itemCount"] = "NONE"
	end

	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedOoCDelay"] = 2
		E.private["addonskins"]["AuctionHouse"] = false
		E.private["addonskins"]["EmbedLeftWidth"] = 213
		E.private["addonskins"]["DBMFontSize"] = 10
		E.private["addonskins"]["DBMFont"] = "ElvUI Font"
		E.private["addonskins"]["DBMSkinHalf"] = true
		E.private["addonskins"]["Blizzard_DraenorAbilityButton"] = true
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]["Blizzard_ExtraActionButton"] = true
		E.private["addonskins"]["EmbedOoC"] = true
		E.private["addonskins"]["SkinTemplate"] = "Default"
	end
	
	E:UpdateAll(true)
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