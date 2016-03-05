local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

local dtbarsList = {}
local dtbarsTexts = {}

function AI:DarthCaster()
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Crit Chance"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Spell/Heal Power"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Haste"
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
end

function AI:DarthPhys()
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Crit Chance"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Attack Power"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Haste"
end

function AI:DarthHeal()
	do
		E.db["unitframe"]["debuffHighlighting"] = true

		E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][health:deficit]"
		E.db["unitframe"]["units"]["party"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25

		E.db["unitframe"]["units"]["raid"]["healPrediction"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[healthcolor][health:deficit]"
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["xOffset"] = -27
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["yOffset"] = 8

		E.db["unitframe"]["units"]["raidpet"]["enable"] = true
	end

	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Crit Chance"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "Spell/Heal Power"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "MP5"
	--Movers--
	do
		SLE:SetMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 770, 143)
		SLE:SetMoverPosition("ElvUF_RaidMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 770, 143)
		SLE:SetMoverPosition("ElvUF_Raid40Mover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 770, 143)
		SLE:SetMoverPosition("AlertFrameMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 427)
		SLE:SetMoverPosition("UIErrorsFrameMover", "TOP", ElvUIParent, "TOP", 8, -381)
		SLE:SetMoverPosition("BossButton", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -421, 382)
	end
end

function AI:DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]

	local word = layout == 'tank' and L["Tank"] or layout == 'healer' and L["Healer"] or layout == 'dpsMelee' and L['Physical DPS'] or L['Caster DPS']
	SLEInstallStepComplete.message = L["Darth's Default Set"]..": "..word
	SLEInstallStepComplete:Show()

	if IsAddOnLoaded("ElvUI_DTBars2") then
		table.wipe(dtbarsList)
		table.wipe(dtbarsTexts)
		for name, data in pairs(E.global.dtbars) do
			if E.db.dtbars and E.db.dtbars[name] then
				dtbarsList[name] = E.db.dtbars[name]
				dtbarsTexts[name] = E.db.datatexts.panels[name]
			end
		end
	end
	table.wipe(E.db)
	E:CopyTable(E.db, P)

	table.wipe(E.private)
	E:CopyTable(E.private, V)
	
	if E.db['movers'] then table.wipe(E.db['movers']) else E.db['movers'] = {} end

	--General--
	do
		E.db["general"]["totems"]["sortDirection"] = "DESCENDING"
		E.db["general"]["hideErrorFrame"] = false
		E.db["general"]["afk"] = false
		E.db["general"]["autoRepair"] = "PLAYER"
		E.db["general"]["minimap"]["locationText"] = "HIDE"
		E.db["general"]["minimap"]["icons"]["garrison"]["xOffset"] = -22
		E.db["general"]["minimap"]["icons"]["garrison"]["position"] = "LEFT"
		E.db["general"]["minimap"]["size"] = 200
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["objectiveFrameHeight"] = 620
		E.db["general"]["threat"]["enable"] = false
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["topPanel"] = false
		E.db["general"]["experience"]["height"] = 186
		E.db["general"]["reputation"]["height"] = 186
		E.db["general"]["bonusObjectivePosition"] = "RIGHT"
		E.db["general"]["vendorGrays"] = true
	end
	--Nameplates--
	do
		E.db["nameplate"]["fontSize"] = 10
		E.db["nameplate"]["wrapName"] = true
		E.db["nameplate"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["font"] = "PT Sans Narrow"
		E.db["nameplate"]["colorNameByValue"] = false
		E.db["nameplate"]["raidHealIcon"]["xOffset"] = 0
		E.db["nameplate"]["healthBar"]["height"] = 10
		E.db["nameplate"]["healthBar"]["text"]["enable"] = true
		E.db["nameplate"]["healthBar"]["lowHPScale"]["height"] = 10
		E.db["nameplate"]["healthBar"]["lowHPScale"]["enable"] = true
		E.db["nameplate"]["buffs"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["buffs"]["font"] = "PT Sans Narrow"
		E.db["nameplate"]["debuffs"]["font"] = "PT Sans Narrow"
		E.db["nameplate"]["debuffs"]["numAuras"] = 6
		E.db["nameplate"]["debuffs"]["fontOutline"] = "OUTLINE"
		E.db["nameplate"]["debuffs"]["stretchTexture"] = false
	end
	--Bags--
	do
		E.db["bags"]["yOffsetBank"] = 181
		E.db["bags"]["itemLevelFont"] = "PT Sans Narrow"
		E.db["bags"]["yOffset"] = 181
		E.db["bags"]["bagSize"] = 31
		E.db["bags"]["itemLevelFontSize"] = 12
		E.db["bags"]["alignToChat"] = false
		E.db["bags"]["bagWidth"] = 476
		E.db["bags"]["bankSize"] = 31
		E.db["bags"]["bankWidth"] = 476
		E.db["bags"]["moneyFormat"] = "CONDENSED"
		E.db["bags"]["currencyFormat"] = "ICON"
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	end
	--Chat--
	do
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
		E.db["chat"]["editboxhistory"] = 10
		E.db["chat"]["fontOutline"] = "OUTLINE"
		E.db["chat"]["panelHeightRight"] = 187
		E.db["chat"]["panelWidth"] = 445
		E.db["chat"]["emotionIcons"] = false
		E.db["chat"]["tabFontSize"] = 12
		E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT"
		E.db["chat"]["panelWidthRight"] = 425
		E.db["chat"]["tabFont"] = "PT Sans Narrow"
		E.db["chat"]["panelHeight"] = 187
	end
	--Tooltip--
	E.db["tooltip"]["healthBar"]["font"] = "PT Sans Narrow"
	E.db["tooltip"]["itemCount"] = "NONE"
	--Unitframes--
	do
		E.db["unitframe"]["fontSize"] = 12
		E.db["unitframe"]["statusbar"] = "Polished Wood"
		E.db["unitframe"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["debuffHighlighting"] = false
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["smartRaidFilter"] = false
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.552941176470588
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.317647058823529
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.180392156862745
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.76078431372549
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.803921568627451
		E.db["unitframe"]["colors"]["castNoInterrupt"]["b"] = 0.250980392156863
		E.db["unitframe"]["colors"]["castNoInterrupt"]["g"] = 0.250980392156863
		E.db["unitframe"]["colors"]["castNoInterrupt"]["r"] = 0.780392156862745

		E.db["unitframe"]["units"]["player"]["combatfade"] = true
		E.db["unitframe"]["units"]["player"]["width"] = 190
		E.db["unitframe"]["units"]["player"]["lowmana"] = 0
		E.db["unitframe"]["units"]["player"]["height"] = 27
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = "[healthcolor][perhp]% || [health:current]"
		E.db["unitframe"]["units"]["player"]["power"]["attachTextToPower"] = true
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][perpp]% || [power:current]"
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["player"]["name"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = "[level] [namecolor][name:long]"
		E.db["unitframe"]["units"]["player"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 200
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 8
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 240
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["player"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["player"]["debuffs"]["useBlacklist"] = false
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 18
		E.db["unitframe"]["units"]["player"]["aurabar"]["maxBars"] = 10
		E.db["unitframe"]["units"]["player"]["aurabar"]["height"] = 18
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = "||cFFB04F4F[pvptimer]||r"
		E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 22

		E.db["unitframe"]["units"]["target"]["width"] = 190
		E.db["unitframe"]["units"]["target"]["height"] = 27
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = "[absorbs] [healthcolor][health:current] || [perhp]%"
		E.db["unitframe"]["units"]["target"]["power"]["attachTextToPower"] = true
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current] || [perpp]%"
		E.db["unitframe"]["units"]["target"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 5
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 15
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = "[namecolor][name:long]||r [difficultycolor][level] [shortclassification]||r"
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["combobar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["target"]["combobar"]["detachedWidth"] = 200
		E.db["unitframe"]["units"]["target"]["combobar"]["height"] = 8
		E.db["unitframe"]["units"]["target"]["combobar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 190
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 20
		E.db["unitframe"]["units"]["target"]["buffs"]["useBlacklist"]["enemy"] = false
		E.db["unitframe"]["units"]["target"]["debuffs"]["playerOnly"]["enemy"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxBars"] = 9
		E.db["unitframe"]["units"]["target"]["aurabar"]["height"] = 18
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
		E.db["unitframe"]["units"]["target"]["raidicon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 20
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 22

		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100
		E.db["unitframe"]["units"]["targettarget"]["height"] = 25

		E.db["unitframe"]["units"]["pet"]["width"] = 80
		E.db["unitframe"]["units"]["pet"]["height"] = 20
		E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = -1
		E.db["unitframe"]["units"]["pet"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 80
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5

		E.db["unitframe"]["units"]["focus"]["width"] = 120
		E.db["unitframe"]["units"]["focus"]["height"] = 30
		E.db["unitframe"]["units"]["focus"]["debuffs"]["sizeOverride"] = 29
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 208

		E.db["unitframe"]["units"]["tank"]["enable"] = false
		E.db["unitframe"]["units"]["assist"]["enable"] = false

		E.db["unitframe"]["units"]["bodyguard"]["height"] = 20
		E.db["unitframe"]["units"]["bodyguard"]["width"] = 90

		E.db["unitframe"]["units"]["party"]["height"] = 32
		E.db["unitframe"]["units"]["party"]["width"] = 75
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][health:current]"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 3
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 1
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOP"
		E.db["unitframe"]["units"]["party"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 13
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["GPSArrow"]["enable"] = false

		E.db["unitframe"]["units"]["raid"]["height"] = 32
		E.db["unitframe"]["units"]["raid"]["width"] = 75
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 6
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[healthcolor][health:current]"
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 3
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 13
		E.db["unitframe"]["units"]["raid"]["GPSArrow"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 18

		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid40"]["width"] = 75
		E.db["unitframe"]["units"]["raid40"]["height"] = 23
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["visibility"] = "[@raid31,noexists] hide;show"

		E.db["unitframe"]["units"]["boss"]["height"] = 30
		E.db["unitframe"]["units"]["boss"]["width"] = 198
		E.db["unitframe"]["units"]["boss"]["growthDirection"] = "DOWN"
		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = "[healthcolor][health:current-percent]"
		E.db["unitframe"]["units"]["boss"]["power"]["yOffset"] = -4
		E.db["unitframe"]["units"]["boss"]["power"]["width"] = "spaced"
		E.db["unitframe"]["units"]["boss"]["castbar"]["height"] = 15
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 3
		E.db["unitframe"]["units"]["boss"]["buffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "BUFFS"

		E.db["unitframe"]["units"]["arena"]["height"] = 30
		E.db["unitframe"]["units"]["arena"]["width"] = 198
		E.db["unitframe"]["units"]["arena"]["growthDirection"] = "DOWN"
		E.db["unitframe"]["units"]["arena"]["health"]["text_format"] = "[healthcolor][health:current-percent]"
		E.db["unitframe"]["units"]["arena"]["power"]["yOffset"] = -4
		E.db["unitframe"]["units"]["arena"]["power"]["width"] = "spaced"
		E.db["unitframe"]["units"]["arena"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["arena"]["castbar"]["width"] = 198
		E.db["unitframe"]["units"]["arena"]["buffs"]["yOffset"] = 3
		E.db["unitframe"]["units"]["arena"]["buffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["arena"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["arena"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["arena"]["debuffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["arena"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["arena"]["pvpTrinket"]["position"] = "LEFT"
	end
	--Datatexts--
	do
		E.db["datatexts"]["minimapPanels"] = false
		E.db["datatexts"]["fontSize"] = 12
		E.db["datatexts"]["goldFormat"] = "CONDENSED"
		E.db["datatexts"]["panelTransparency"] = true
		E.db["datatexts"]["time24"] = true
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Mastery"
		E.db["datatexts"]["panels"]["DP_5"]["right"] = "Durability"
		E.db["datatexts"]["panels"]["DP_5"]["left"] = "S&L Currency"
		E.db["datatexts"]["panels"]["DP_5"]["middle"] = "Bags"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "S&L Friends"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Combat/Arena Time"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = "S&L Guild"
		E.db["datatexts"]["panels"]["Bottom_Panel"] = "System"
		E.db["datatexts"]["font"] = "PT Sans Narrow"
		E.db["datatexts"]["fontOutline"] = "OUTLINE"

		if IsAddOnLoaded("ElvUI_DTBars2") then
			if not E.db.dtbars then E.db.dtbars = {} end
			for name, data in pairs(E.global.dtbars) do
				if dtbarsList[name] then
					E.db.dtbars[name] = dtbarsList[name]
					E.db.datatexts.panels[name] = dtbarsTexts[name]
				end
			end
		end
	end
	--Actionbars--
	do
		E.db["actionbar"]["fontSize"] = 12
		E.db["actionbar"]["font"] = "PT Sans Narrow"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["keyDown"] = false
		E.db["actionbar"]["hotkeytext"] = false

		E.db["actionbar"]["bar1"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar1"]["buttonspacing"] = 1
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 6
		E.db["actionbar"]["bar1"]["buttonsize"] = 45

		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar2"]["visibility"] = " [petbattle] hide; show"
		E.db["actionbar"]["bar2"]["buttonsize"] = 29

		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar3"]["buttonsize"] = 29

		E.db["actionbar"]["bar4"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar4"]["buttonspacing"] = 1
		E.db["actionbar"]["bar4"]["backdrop"] = false
		E.db["actionbar"]["bar4"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar4"]["buttonsize"] = 30
		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonspacing"] = 1
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["visibility"] = " [petbattle] hide; show"

		E.db["actionbar"]["barPet"]["point"] = "TOPLEFT"
		E.db["actionbar"]["barPet"]["buttonspacing"] = 1
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 5
		E.db["actionbar"]["barPet"]["buttonsize"] = 18
		E.db["actionbar"]["barPet"]["visibility"] = "[petbattle] hide;[pet, combat,novehicleui,nooverridebar,nopossessbar] show;hide"

		E.db["actionbar"]["stanceBar"]["style"] = "classic"
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 18
	end
	--Auras--
	do
		E.db["auras"]["font"] = "PT Sans Narrow"
		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["fontSize"] = 12
		E.db["auras"]["buffs"]["size"] = 28
		E.db["auras"]["debuffs"]["horizontalSpacing"] = 8
		E.db["auras"]["debuffs"]["size"] = 36
		E.db["auras"]["debuffs"]["wrapAfter"] = 9
		E.db["auras"]["consolidatedBuffs"]["fontSize"] = 12
		E.db["auras"]["consolidatedBuffs"]["font"] = "PT Sans Narrow"
		E.db["auras"]["consolidatedBuffs"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["consolidatedBuffs"]["filter"] = false
	end
	--SLE--
	do
		E.db["sle"]["nameplate"]["showthreat"] = true
		E.db["sle"]["raidmarkers"]["buttonSize"] = 18
		E.db["sle"]["raidmarkers"]["spacing"] = 1
		E.db["sle"]["raidmarkers"]["visibility"] = "DEFAULT"
		E.db["sle"]["raidmarkers"]["reverse"] = true
		E.db["sle"]["errorframe"]["width"] = 470

		E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["screensaver"]["enable"] = true
		E.db["sle"]["media"]["screensaver"]["playermodel"]["rotation"] = 345
		E.db["sle"]["media"]["screensaver"]["playermodel"]["xaxis"] = 0.1
		E.db["sle"]["media"]["screensaver"]["playermodel"]["anim"] = 70
		E.db["sle"]["media"]["screensaver"]["playermodel"]["distance"] = 0
		E.db["sle"]["media"]["screensaver"]["playermodel"]["yaxis"] = -0.2
		E.db["sle"]["media"]["screensaver"]["playermodel"]["width"] = 650
		E.db["sle"]["media"]["screensaver"]["xpack"] = 200
		E.db["sle"]["media"]["screensaver"]["crest"] = 150

		E.db["sle"]["Armory"]["Character"]["Enchant"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Character"]["MissingIcon"] = false
		E.db["sle"]["Armory"]["Character"]["Durability"]["Display"] = "DamagedOnly"
		E.db["sle"]["Armory"]["Character"]["Durability"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Character"]["Level"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Character"]["Backdrop"]["SelectedBG"] = "Castle"
		E.db["sle"]["Armory"]["Character"]["Gradation"]["Color"] = {
			0.411764705882353, -- [1]
			0.827450980392157, -- [2]
			nil, -- [3]
			1, -- [4]
		}

		E.db["sle"]["Armory"]["Inspect"]["Gem"]["SocketSize"] = 12
		E.db["sle"]["Armory"]["Inspect"]["MissingIcon"] = false
		E.db["sle"]["Armory"]["Inspect"]["Level"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Inspect"]["Backdrop"]["SelectedBG"] = "Castle"
		E.db["sle"]["Armory"]["Inspect"]["Enchant"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Inspect"]["Gradation"]["Color"] = {
			0.411764705882353, -- [1]
			0.827450980392157, -- [2]
			nil, -- [3]
			1, -- [4]
		}

		E.db["sle"]["datatext"]["chathandle"] = true
		E.db["sle"]["datatext"]["chatright"]["width"] = 428
		E.db["sle"]["datatext"]["chatleft"]["width"] = 428
		E.db["sle"]["datatext"]["bottom"]["enabled"] = true
		E.db["sle"]["datatext"]["bottom"]["transparent"] = true
		E.db["sle"]["datatext"]["bottom"]["width"] = 196
		E.db["sle"]["datatext"]["top"]["enabled"] = true
		E.db["sle"]["datatext"]["top"]["transparent"] = true
		E.db["sle"]["datatext"]["dp5"]["enabled"] = true
		E.db["sle"]["datatext"]["dp5"]["transparent"] = true
		E.db["sle"]["datatext"]["dp6"]["enabled"] = true
		E.db["sle"]["datatext"]["dp6"]["transparent"] = true

		E.db["sle"]["dt"]["friends"]["sortBN"] = "REALID"
		E.db["sle"]["dt"]["friends"]["combat"] = true
		E.db["sle"]["dt"]["friends"]["hide_hintline"] = false
		E.db["sle"]["dt"]["friends"]["expandBNBroadcast"] = true
		E.db["sle"]["dt"]["friends"]["totals"] = true
		E.db["sle"]["dt"]["guild"]["totals"] = true
		E.db["sle"]["dt"]["guild"]["combat"] = true
		E.db["sle"]["dt"]["durability"]["threshold"] = 50
		E.db["sle"]["dt"]["durability"]["gradient"] = true

		E.db["sle"]["loot"]["enable"] = true
		E.db["sle"]["loot"]["history"]["alpha"] = 0.7
		E.db["sle"]["loot"]["history"]["autohide"] = true
		E.db["sle"]["loot"]["autoroll"]["autode"] = true
		E.db["sle"]["loot"]["autoroll"]["autoconfirm"] = true
		E.db["sle"]["loot"]["autoroll"]["autogreed"] = true

		E.db["sle"]["combatico"]["pos"] = "RIGHT"

		E.db["sle"]["threat"]["enable"] = false

		E.db["sle"]["quests"]["visibility"]["arena"] = "HIDE"
		E.db["sle"]["quests"]["visibility"]["bg"] = "HIDE"
		E.db["sle"]["quests"]["visibility"]["rested"] = "COLLAPSED"
		E.db["sle"]["quests"]["visibility"]["garrison"] = "COLLAPSED"

		E.db["sle"]["tooltip"]["showFaction"] = true

		E.db["sle"]["garrison"]["autoOrder"] = true

		E.db["sle"]["chat"]["dpsSpam"] = true
		E.db["sle"]["chat"]["textureAlpha"]["enable"] = true
		E.db["sle"]["chat"]["textureAlpha"]["alpha"] = 0.7

		E.db["sle"]["minimap"]["instance"]["fontSize"] = 14
		E.db["sle"]["minimap"]["instance"]["flag"] = false
		E.db["sle"]["minimap"]["instance"]["enable"] = true

		E.db["sle"]["powtext"] = true

		E.db["sle"]["uibuttons"]["point"] = "TOPRIGHT"
		E.db["sle"]["uibuttons"]["enable"] = true
		E.db["sle"]["uibuttons"]["spacing"] = 1
		E.db["sle"]["uibuttons"]["anchor"] = "BOTTOMRIGHT"
		E.db["sle"]["uibuttons"]["size"] = 20
		E.db["sle"]["uibuttons"]["orientation"] = "horizontal"
		E.db["sle"]["uibuttons"]["yoffset"] = -2
	end
	--Movers--
	do
		SLE:SetMoverPosition("ElvAB_1", "BOTTOM", ElvUIParent, "BOTTOM", 0, 21)
		SLE:SetMoverPosition("ElvAB_2", "BOTTOM", ElvUIParent, "BOTTOM", 202, 20)
		SLE:SetMoverPosition("ElvAB_3", "BOTTOM", ElvUIParent, "BOTTOM", -202, 20)
		SLE:SetMoverPosition("ElvAB_4", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -445, 20)
		SLE:SetMoverPosition("ElvAB_5", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 445, 20)
		SLE:SetMoverPosition("ElvAB_6", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -11, 210)
		SLE:SetMoverPosition("ShiftAB", "TOPLEFT", ElvUIParent, "BOTTOMLEFT", 711, 136)
		SLE:SetMoverPosition("PetAB", "BOTTOM", ElvUIParent, "BOTTOM", -287, 337)
		SLE:SetMoverPosition("BossButton", "BOTTOM", ElvUIParent, "BOTTOM", 0, 170)
		SLE:SetMoverPosition("RaidMarkerBarAnchor", "BOTTOM", ElvUIParent, "BOTTOM", 0, 113)
		SLE:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", ElvUIParent, "BOTTOM", -240, 400)
		SLE:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 381)
		SLE:SetMoverPosition("ClassBarMover", "BOTTOM", ElvUIParent, "BOTTOM", 2, 419)
		SLE:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", ElvUIParent, "BOTTOM", 239, 400)
		SLE:SetMoverPosition("ComboBarMover", "BOTTOM", ElvUIParent, "BOTTOM", 2, 408)
		SLE:SetMoverPosition("ElvUF_PetMover", "BOTTOM", ElvUIParent, "BOTTOM", -295, 379)
		SLE:SetMoverPosition("ElvUF_BodyGuardMover", "BOTTOM", ElvUIParent, "BOTTOM", -208, 379)
		SLE:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOM", ElvUIParent, "BOTTOM", 194, 355)
		SLE:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", ElvUIParent, "BOTTOM", 296, 320)
		SLE:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -516, 303)
		SLE:SetMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 0, 207)
		SLE:SetMoverPosition("ElvUF_RaidMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 0, 207)
		SLE:SetMoverPosition("ElvUF_Raid40Mover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 0, 207)
		SLE:SetMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", ElvUIParent, "BOTTOMLEFT", 379, 369)
		SLE:SetMoverPosition("BossHeaderMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", 0, -229)
		SLE:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", 0, -229)
		SLE:SetMoverPosition("TotemBarMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 576, 337)
		SLE:SetMoverPosition("MicrobarMover", "TOP", ElvUIParent, "TOP", 0, -20)
		SLE:SetMoverPosition("GMMover", "TOPLEFT", ElvUIParent, "TOPLEFT", 267, -1)
		SLE:SetMoverPosition("ObjectiveFrameMover", "TOPLEFT", ElvUIParent, "TOPLEFT", 80, 0)
		SLE:SetMoverPosition("BNETMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -88, -206)
		SLE:SetMoverPosition("RaidUtility_Mover", "TOP", ElvUIParent, "TOP", -306, 0)
		SLE:SetMoverPosition("AlertFrameMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 135)
		SLE:SetMoverPosition("GhostFrameMover", "TOP", ElvUIParent, "TOP", 257, 0)
		SLE:SetMoverPosition("AltPowerBarMover", "TOP", ElvUIParent, "TOP", 0, -113)
		SLE:SetMoverPosition("PvPMover", "TOP", ElvUIParent, "TOP", 0, -70)
		SLE:SetMoverPosition("MinimapMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", 0, 0)
		SLE:SetMoverPosition("BuffsMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -228, -1)
		SLE:SetMoverPosition("DebuffsMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -228, -149)
		SLE:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 0, 19)
		SLE:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", 0, 19)
		SLE:SetMoverPosition("LootFrameMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 420, 383)
		SLE:SetMoverPosition("DigSiteProgressBarMover", "TOP", ElvUIParent, "TOP", 0, -106)
		SLE:SetMoverPosition("SLE_UIButtonsMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", 0, -203)
		SLE:SetMoverPosition("UIErrorsFrameMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 290)
		SLE:SetMoverPosition("VehicleSeatMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 545, 207)
		SLE:SetMoverPosition("ExperienceBarMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 508, 20)
		SLE:SetMoverPosition("ReputationBarMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -508, 20)
		SLE:SetMoverPosition("Top_Center_Mover", "TOP", ElvUIParent, "TOP", 0, 0)
		SLE:SetMoverPosition("DP_5_Mover", "BOTTOM", ElvUIParent, "BOTTOM", -307, 0)
		SLE:SetMoverPosition("DP_6_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 307, 0)
		SLE:SetMoverPosition("SalvageCrateMover", "BOTTOM", ElvUIParent, "BOTTOM", -1, 350)
		SLE:SetMoverPosition("PetBattleStatusMover", "TOP", ElvUIParent, "TOP", 0, -69)
	end

	E.private["general"]["minimap"]["hideGarrison"] = false
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["glossTex"] = "Polished Wood"
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["farm"]["enable"] = true
	E.private["sle"]["equip"]["spam"] = true
	E.private["sle"]["equip"]["setoverlay"] = true
	if E.myclass ~= "HUNTER" and E.myclass ~= "SHAMAN" and E.myclass ~= "ROGUE" then E.private["sle"]["auras"]["consolidatedMark"] = true end
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
		E.db.layoutSet = "dpsCaster"
	end

	if IsAddOnLoaded("ElvUI_LocLite") then
		SLE:SetMoverPosition("LocationLiteMover", "TOP", ElvUIParent, "TOP", 0, -19)
		E.db["loclite"]["dig"] = false
		E.db["loclite"]["lpwidth"] = 300
		E.db["loclite"]["dtheight"] = 20
		E.db["loclite"]["lpauto"] = false
		E.db["loclite"]["lpfontsize"] = 10
		E.db["loclite"]["lpfontflags"] = "OUTLINE"
	end
	
	if IsAddOnLoaded("ElvUI_EverySecondCounts") then
		E.db["ESC"]["font"] = "PT Sans Narrow"
	end

	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["DBMFontSize"] = 10
		E.private["addonskins"]["EmbedIsHidden"] = true
		E.private["addonskins"]["AuctionHouse"] = false
		E.private["addonskins"]["SkinTemplate"] = "Default"
		E.private["addonskins"]["DBMSkinHalf"] = true
		E.private["addonskins"]["DBMFont"] = "PT Sans Narrow"
		E.private["addonskins"]["Blizzard_ExtraActionButton"] = true
		E.private["addonskins"]["EmbedLeftWidth"] = 213
		E.private["addonskins"]["EmbedOoC"] = true
		E.private["addonskins"]["EmbedOoCDelay"] = 2
		E.private["addonskins"]["Blizzard_DraenorAbilityButton"] = true
		E.private["addonskins"]["EmbedSystemDual"] = true
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:UpdateAll(true)
end

function AI:RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]

	SLEInstallStepComplete.message = L["Repooc's Default Set"]
	SLEInstallStepComplete:Show()

	if IsAddOnLoaded("ElvUI_DTBars2") then
		table.wipe(dtbarsList)
		table.wipe(dtbarsTexts)
		for name, data in pairs(E.global.dtbars) do
			if E.db.dtbars and E.db.dtbars[name] then
				dtbarsList[name] = E.db.dtbars[name]
				dtbarsTexts[name] = E.db.datatexts.panels[name]
			end
		end
	end
	table.wipe(E.db)
	E:CopyTable(E.db, P)

	table.wipe(E.private)
	E:CopyTable(E.private, V)
	
	if E.db['movers'] then table.wipe(E.db['movers']) else E.db['movers'] = {} end
	
	E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
	E.db["actionbar"]["bar3"]["buttons"] = 12
	E.db["actionbar"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["bar2"]["enabled"] = true
	E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
	E.db["actionbar"]["bar5"]["buttons"] = 12
	E.db["actionbar"]["font"] = "Rubino"
	E.db["actionbar"]["fontSize"] = 12

	E.db["auras"]["consolidatedBuffs"]["font"] = "Intro Black"
	E.db["auras"]["consolidatedBuffs"]["fontOutline"] = "NONE"

	E.db["chat"]["font"] = "Univers"
	E.db["chat"]["tabFontSize"] = 12
	E.db["chat"]["tabFont"] = "Rubino"

	E.db["datatexts"]["minimapPanels"] = false
	E.db["datatexts"]["panels"]["Top_Center"] = "S&L Guild"
	E.db["datatexts"]["panels"]["Bottom_Panel"] = "S&L Friends"
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Time"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "S&L Currency"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "System"
	E.db["datatexts"]["leftChatPanel"] = false
	E.db["datatexts"]["rightChatPanel"] = false

	if IsAddOnLoaded("ElvUI_DTBars2") then
			if not E.db.dtbars then E.db.dtbars = {} end
			for name, data in pairs(E.global.dtbars) do
				if dtbarsList[name] then
					E.db.dtbars[name] = dtbarsList[name]
					E.db.datatexts.panels[name] = dtbarsTexts[name]
				end
			end
		end

	E.db["general"]["bottomPanel"] = false
	E.db["general"]["valuecolor"] = {
		["r"] = 0,
		["g"] = 1,
		["b"] = 0.59,
	}
	E.db["general"]["vendorGrays"] = true
	E.db["general"]["bordercolor"] = {
		["r"] = 0.31,
		["g"] = 0.31,
		["b"] = 0.31,
	}
	E.db["general"]["font"] = "Rubino"

	SLE:SetMoverPosition("BossButton", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -448, 415)
	SLE:SetMoverPosition("Bottom_Panel_Mover", "BOTTOM", ElvUIParent, "BOTTOM", -312, 2)
	SLE:SetMoverPosition("DP_6_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 2)
	SLE:SetMoverPosition("ElvAB_1", "BOTTOM", ElvUIParent, "BOTTOM", 0, 57)
	SLE:SetMoverPosition("ElvAB_2", "BOTTOM", ElvUIParent, "BOTTOM", 0, 22)
	SLE:SetMoverPosition("ElvAB_3", "BOTTOM", ElvUIParent, "BOTTOM", 312, 23)
	SLE:SetMoverPosition("ElvAB_5", "BOTTOM", ElvUIParent, "BOTTOM", -312, 23)
	SLE:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", ElvUIParent, "BOTTOM", -311, 145)
	SLE:SetMoverPosition("ElvUF_PetMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 410, 240)
	SLE:SetMoverPosition("ElvUF_RaidMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 95)
	SLE:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", ElvUIParent, "BOTTOM", 311, 145)
	SLE:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -410, 240)
	SLE:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", ElvUIParent, "BOTTOM", -311, 122)
	SLE:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 2, 2)
	SLE:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -2, 2)
	SLE:SetMoverPosition("Top_Center_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 312, 2)

	E.db["nameplate"]["healthBar"]["text"]["enable"] = true
	E.db["nameplate"]["healthBar"]["text"]["format"] = "CURRENT_PERCENT"
	E.db["nameplate"]["threat"]["goodScale"] = 1.1
	E.db["nameplate"]["targetIndicator"]["color"]["g"] = 0
	E.db["nameplate"]["targetIndicator"]["color"]["b"] = 0
	E.db["nameplate"]["font"] = "Intro Black"
	E.db["nameplate"]["fontOutline"] = "OUTLINE"

	E.db["sle"]["datatext"]["top"]["enabled"] = true
	E.db["sle"]["datatext"]["top"]["width"] = 202
	E.db["sle"]["datatext"]["bottom"]["enabled"] = true
	E.db["sle"]["datatext"]["bottom"]["width"] = 202
	E.db["sle"]["datatext"]["dp6"]["enabled"] = true
	E.db["sle"]["datatext"]["dp6"]["width"] = 406
	E.db["sle"]["loot"]["announcer"]["enable"] = true
	E.db["sle"]["loot"]["autoroll"]["enable"] = false
	E.db["sle"]["loot"]["enable"] = true
	E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Durandal Light"
	E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Durandal Light"
	E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Trafaret"
	E.db["sle"]["media"]["fonts"]["pvp"]["size"] = 20
	E.db["sle"]["minimap"]["mapicons"]["skindungeon"] = true
	E.db["sle"]["tooltip"]["showFaction"] = true
	E.db["sle"]["uibuttons"]["enable"] = true

	E.db["tooltip"]["healthBar"]["font"] = "Rubino"
	E.db["tooltip"]["healthBar"]["fontSize"] = 11

	E.db["unitframe"]["colors"]["auraBarBuff"] = {
		["r"] = 0,
		["g"] = 1,
		["b"] = 0.59,
	}
	E.db["unitframe"]["colors"]["healthclass"] = true
	E.db["unitframe"]["colors"]["castClassColor"] = true
	E.db["unitframe"]["colors"]["castColor"] = {
		["r"] = 0.1,
		["g"] = 0.1,
		["b"] = 0.1,
	}
	E.db["unitframe"]["colors"]["health"] = {
		["r"] = 0.1,
		["g"] = 0.1,
		["b"] = 0.1,
	}
	E.db["unitframe"]["statusbar"] = "Minimalist"
	E.db["unitframe"]["smoothbars"] = true
	E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_OFF"
	E.db["unitframe"]["units"]["raid"]["width"] = 79
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["health"]["orientation"] = "VERTICAL"
	E.db["unitframe"]["units"]["raid"]["GPSArrow"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_OFF"
	E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 202
	E.db["unitframe"]["units"]["target"]["width"] = 202
	E.db["unitframe"]["units"]["player"]["restIcon"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 202
	E.db["unitframe"]["units"]["player"]["width"] = 202

	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["minimap"]["mapicons"]["barenable"] = true
	E.private["sle"]["equip"]["setoverlay"] = true
	E.private["sle"]["exprep"]["autotrack"] = true

	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedOoC"] = false
		E.private["addonskins"]["DBMSkinHalf"] = true
		E.private["addonskins"]["DBMFont"] = "PT Sans Narrow"
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]["EmbedLeft"] = "Skada"
		E.private["addonskins"]["EmbedRight"] = "Skada"
		E.private["addonskins"]["EmbedSystem"] = false
	end

	E.db.layoutSet = layout
	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:UpdateAll(true)
end

function AI:AffinitiiSetup() --The function to switch from class ElvUI settings to Affinitii's
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]
	pixel = E.PixelMode  --Pull PixelMode

	SLEInstallStepComplete.message = L["Affinitii's Default Set"]
	SLEInstallStepComplete:Show()

	if IsAddOnLoaded("ElvUI_DTBars2") then
		table.wipe(dtbarsList)
		table.wipe(dtbarsTexts)
		for name, data in pairs(E.global.dtbars) do
			if E.db.dtbars and E.db.dtbars[name] then
				dtbarsList[name] = E.db.dtbars[name]
				dtbarsTexts[name] = E.db.datatexts.panels[name]
			end
		end
	end
	table.wipe(E.db)
	E:CopyTable(E.db, P)

	table.wipe(E.private)
	E:CopyTable(E.private, V)

	if E.db['movers'] then table.wipe(E.db['movers']) else E.db['movers'] = {} end
	if not E.db["unitframe"]["units"]["party"]["customTexts"] then E.db["unitframe"]["units"]["party"]["customTexts"] = {} end
	if not E.db["unitframe"]["units"]["raid40"]["customTexts"] then E.db["unitframe"]["units"]["raid40"]["customTexts"] = {} end

	E.db["sle"]["nameplate"]["showthreat"] = true
	E.db["sle"]["nameplate"]["targetcount"] = true
	E.db["sle"]["datatext"]["chathandle"] = true
	E.db["sle"]["datatext"]["top"]["enabled"] = true
	E.db["sle"]["datatext"]["top"]["transparent"] = true
	E.db["sle"]["datatext"]["top"]["width"] = 100
	E.db["sle"]["datatext"]["bottom"]["enabled"] = true
	E.db["sle"]["datatext"]["bottom"]["transparent"] = true
	E.db["sle"]["datatext"]["bottom"]["width"] = 100
	E.db["sle"]["datatext"]["dp6"]["enabled"] = true
	E.db["sle"]["datatext"]["dp6"]["transparent"] = true
	E.db["sle"]["datatext"]["dp6"]["alpha"] = 0.8
	E.db["sle"]["datatext"]["dp6"]["width"] = 399
	E.db["sle"]["minimap"]["buttons"]["anchor"] = "VERTICAL"
	E.db["sle"]["minimap"]["buttons"]["mouseover"] = true
	E.db["sle"]["minimap"]["mapicons"]["skinmail"] = false
	E.db["sle"]["minimap"]["mapicons"]["iconmouseover"] = true

	SLE:SetMoverPosition("DP_6_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 3)
	SLE:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 96)
	SLE:SetMoverPosition("ElvUF_RaidMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 440, 511)
	SLE:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 21)
	SLE:SetMoverPosition("ElvUF_Raid10Mover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 449, 511)
	SLE:SetMoverPosition("BossButton", "TOPLEFT", ElvUIParent, "TOPLEFT", 622, -352)
	SLE:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", ElvUIParent, "BOTTOM", -63, 436)
	SLE:SetMoverPosition("ClassBarMover", "BOTTOM", ElvUIParent, "BOTTOM", -337, 500)
	SLE:SetMoverPosition("SquareMinimapBar", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -4, -211)
	SLE:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", ElvUIParent, "BOTTOM", 278, 200)
	SLE:SetMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", ElvUIParent, "TOPLEFT", 447, -468)
	SLE:SetMoverPosition("ElvAB_1", "BOTTOM", ElvUIParent, "BOTTOM", 0, 59)
	SLE:SetMoverPosition("ElvAB_2", "BOTTOM", ElvUIParent, "BOTTOM", 0, 25)
	SLE:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", ElvUIParent, "BOTTOMRIGHT", -413, 200)
	SLE:SetMoverPosition("AltPowerBarMover", "BOTTOM", ElvUIParent, "BOTTOM", -300, 338)
	SLE:SetMoverPosition("ElvAB_3", "BOTTOM", ElvUIParent, "BOTTOM", 254, 25)
	SLE:SetMoverPosition("ElvAB_5", "BOTTOM", ElvUIParent, "BOTTOM", -254, 25)
	SLE:SetMoverPosition("MMButtonsMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -214, -160)
	SLE:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", ElvUIParent, "BOTTOM", -278, 200)
	SLE:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 190)
	SLE:SetMoverPosition("ShiftAB", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 414, 21)
	SLE:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 21)
	SLE:SetMoverPosition("TotemBarMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 414, 21)
	SLE:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -210, -410)
	SLE:SetMoverPosition("DP_5_Mover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 4, 327)
	SLE:SetMoverPosition("Top_Center_Mover", "BOTTOM", ElvUIParent, "BOTTOM", -254, 3)
	SLE:SetMoverPosition("BossHeaderMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -210, 435)
	SLE:SetMoverPosition("ElvUF_PetMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 230)
	SLE:SetMoverPosition("ElvAB_6", "BOTTOM", ElvUIParent, "BOTTOM", 0, 102)
	SLE:SetMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 449, 511)
	SLE:SetMoverPosition("Bottom_Panel_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 254, 3)
	SLE:SetMoverPosition("PetAB", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -4, -433)
	SLE:SetMoverPosition("ElvUF_Raid25Mover", "TOPLEFT", ElvUIParent, "TOPLEFT", 449, -448)

	E.db["gridSize"] = 110

	E.db["tooltip"]["style"] = "inset"
	E.db["tooltip"]["visibility"]["combat"] = true

	E.db["chat"]["timeStampFormat"] = "%I:%M "
	E.db["chat"]["editBoxPosition"] = "ABOVE_CHAT"
	E.db["chat"]["lfgIcons"] = false
	E.db["chat"]["emotionIcons"] = false

	E.db["unitframe"]["units"]["tank"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
	E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 21
	E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = -7
	E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = -4
	E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = 28
	E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMLEFT"
	E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["party"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["party"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["party"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 22
	E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 30
	E.db["unitframe"]["units"]["party"]["growthDirection"] = "LEFT_UP"
	E.db["unitframe"]["units"]["party"]["GPSArrow"]["size"] = 40
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["font"] = "Homespun"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["justifyH"] = "CENTER"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["fontOutline"] = "MONOCHROMEOUTLINE"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["yOffset"] = -7
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["text_format"] = "[healthcolor][health:deficit]"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["healPrediction"] = true
	E.db["unitframe"]["units"]["party"]["width"] = 80
	E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[namecolor][name:veryshort] [difficultycolor][smartlevel]"
	E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOP"
	E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["party"]["health"]["position"] = "BOTTOM"
	E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["height"] = 45
	E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["party"]["petsGroup"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["party"]["raidicon"]["attachTo"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = 9
	E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["raidicon"]["size"] = 13
	E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -9
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 2
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["useFilter"] = "Blacklist"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 21
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = -4
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 26
	E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "UP_LEFT"
	E.db["unitframe"]["units"]["raid40"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["raid40"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"] = {}
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["font"] = "Homespun"
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["justifyH"] = "CENTER"
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["fontOutline"] = "MONOCHROMEOUTLINE"
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["yOffset"] = -7
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["text_format"] = "[healthcolor][health:deficit]"
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["size"] = 10
	E.db["unitframe"]["units"]["raid40"]["healPrediction"] = true
	E.db["unitframe"]["units"]["raid40"]["width"] = 50
	E.db["unitframe"]["units"]["raid40"]["invertGroupingOrder"] = false
	E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = "[namecolor][name:veryshort]"
	E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "TOP"
	E.db["unitframe"]["units"]["raid40"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["buffs"]["yOffset"] = 25
	E.db["unitframe"]["units"]["raid40"]["buffs"]["anchorPoint"] = "BOTTOMLEFT"
	E.db["unitframe"]["units"]["raid40"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid40"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid40"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid40"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid40"]["buffs"]["sizeOverride"] = 17
	E.db["unitframe"]["units"]["raid40"]["buffs"]["xOffset"] = 21
	E.db["unitframe"]["units"]["raid40"]["height"] = 43
	E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["attachTo"] = "LEFT"
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["xOffset"] = 9
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["raidicon"]["size"] = 13
	E.db["unitframe"]["units"]["focus"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
	E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["target"]["power"]["height"] = 11
	E.db["unitframe"]["units"]["raid"]["debuffs"]["countFontSize"] = 13
	E.db["unitframe"]["units"]["raid"]["debuffs"]["fontSize"] = 9
	E.db["unitframe"]["units"]["raid"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -7
	E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 21
	E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = -4
	E.db["unitframe"]["units"]["raid"]["growthDirection"] = "LEFT_UP"
	E.db["unitframe"]["units"]["raid"]["numGroups"] = 8
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["healPrediction"] = true
	E.db["unitframe"]["units"]["raid"]["power"]["height"] = 8
	E.db["unitframe"]["units"]["raid"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["buffs"]["yOffset"] = 28
	E.db["unitframe"]["units"]["raid"]["buffs"]["anchorPoint"] = "BOTTOMLEFT"
	E.db["unitframe"]["units"]["raid"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid"]["buffs"]["useBlacklist"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["playerOnly"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid"]["buffs"]["useFilter"] = "TurtleBuffs"
	E.db["unitframe"]["units"]["raid"]["buffs"]["noConsolidated"] = false
	E.db["unitframe"]["units"]["raid"]["buffs"]["sizeOverride"] = 22
	E.db["unitframe"]["units"]["raid"]["buffs"]["xOffset"] = 30
	E.db["unitframe"]["units"]["focustarget"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["pettarget"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["pet"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
	E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["player"]["power"]["height"] = 11
	E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
	E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 399
	E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 25
	E.db["unitframe"]["units"]["boss"]["portrait"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["portrait"]["overlay"] = true
	E.db["unitframe"]["units"]["boss"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["targettarget"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["assist"]["targetsGroup"]["enable"] = false
	E.db["unitframe"]["units"]["assist"]["enable"] = false
	E.db["unitframe"]["statusbar"] = "Polished Wood"
	E.db["unitframe"]["colors"]["auraBarBuff"] = {
		["b"] = 0.0941176470588236,
		["g"] = 0.0784313725490196,
		["r"] = 0.309803921568628,
	}
	E.db["unitframe"]["colors"]["transparentPower"] = true
	E.db["unitframe"]["colors"]["castColor"] = {
		["b"] = 0.1,
		["g"] = 0.1,
		["r"] = 0.1,
	}
	E.db["unitframe"]["colors"]["health"] = {
		["b"] = 0.235294117647059,
		["g"] = 0.235294117647059,
		["r"] = 0.235294117647059,
	}
	E.db["unitframe"]["colors"]["transparentHealth"] = true
	E.db["unitframe"]["colors"]["transparentCastbar"] = true
	E.db["unitframe"]["colors"]["transparentAurabars"] = true

	E.db["datatexts"]["minimapPanels"] = false
	E.db["datatexts"]["fontSize"] = 12
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["panels"]["DP_3"]["middle"] = "DPS"
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Skada"
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Combat/Arena Time"
	E.db["datatexts"]["panels"]["DP_1"]["middle"] = "Friends"
	E.db["datatexts"]["panels"]["DP_5"]["middle"] = "Friends"
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Haste"
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Spell/Heal Power"
	E.db["datatexts"]["panels"]["RightMiniPanel"] = "Gold"
	E.db["datatexts"]["panels"]["Top_Center"] = "WIM"
	E.db["datatexts"]["panels"]["Bottom_Panel"] = "Talent/Loot Specialization"
	E.db["datatexts"]["panels"]["DP_6"]["right"] = "Gold"
	E.db["datatexts"]["panels"]["DP_6"]["left"] = "System"
	E.db["datatexts"]["panels"]["DP_6"]["middle"] = "Time"
	E.db["datatexts"]["panels"]["DP_2"]["middle"] = "Attack Power"
	E.db["datatexts"]["panels"]["LeftMiniPanel"] = "Time"
	E.db["datatexts"]["font"] = "PT Sans Narrow"
	E.db["datatexts"]["fontOutline"] = "None"
	E.db["datatexts"]["battleground"] = false

	if IsAddOnLoaded("ElvUI_DTBars2") then
		if not E.db.dtbars then E.db.dtbars = {} end
		for name, data in pairs(E.global.dtbars) do
			if dtbarsList[name] then
				E.db.dtbars[name] = dtbarsList[name]
				E.db.datatexts.panels[name] = dtbarsTexts[name]
			end
		end
	end

	E.db["actionbar"]["bar3"]["buttonspacing"] = 1
	E.db["actionbar"]["bar3"]["buttonsPerRow"] = 3
	E.db["actionbar"]["bar3"]["alpha"] = 0.4
	E.db["actionbar"]["bar2"]["enabled"] = true
	E.db["actionbar"]["bar2"]["buttonspacing"] = 1
	E.db["actionbar"]["bar2"]["alpha"] = 0.6
	E.db["actionbar"]["bar5"]["buttonspacing"] = 1
	E.db["actionbar"]["bar5"]["buttonsPerRow"] = 3
	E.db["actionbar"]["bar5"]["alpha"] = 0.4
	E.db["actionbar"]["bar1"]["buttonspacing"] = 1
	E.db["actionbar"]["bar1"]["alpha"] = 0.6
	E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 1
	E.db["actionbar"]["stanceBar"]["alpha"] = 0.6
	E.db["actionbar"]["bar4"]["enabled"] = false
	E.db["actionbar"]["bar4"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar4"]["alpha"] = 0.4
	E.db["actionbar"]["bar4"]["buttonsPerRow"] = 6
	E.db["actionbar"]["bar4"]["backdrop"] = false

	E.db["general"]["autoRepair"] = "GUILD"
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["backdropfadecolor"]["b"] = 0.054
	E.db["general"]["backdropfadecolor"]["g"] = 0.054
	E.db["general"]["backdropfadecolor"]["r"] = 0.054
	E.db["general"]["valuecolor"] = {
		["b"] = 0.819,
		["g"] = 0.513,
		["r"] = 0.09,
	}
	E.db["general"]["threat"]["position"] = "LEFTCHAT"
	E.db["general"]["topPanel"] = false
	E.db["general"]["vendorGrays"] = true
	
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["chatBubbles"] = "nobackdrop"
	E.private["general"]["glossTex"] = "Polished Wood"

	E.private["theme"] = "default"

	if AddOnSkins then
		E.private["addonskins"]["Blizzard_WorldStateCaptureBar"] = true
		E.private["addonskins"]["EmbedSystem"] = false
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]['EmbedLeft'] = 'Skada'
		E.private["addonskins"]['EmbedRight'] = 'Skada'
	end

	E.db.layoutSet = layout
	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:UpdateAll(true)
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
		SLEInstallOption1Button:SetScript('OnClick', function() E.db.sle.Armory.Character.Enable = true; E.db.sle.Armory.Inspect.Enable = true; end)
		SLEInstallOption1Button:SetText(ENABLE)

		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() E.db.sle.Armory.Character.Enable = false; E.db.sle.Armory.Inspect.Enable = false; end)
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
		SLEInstallOption2Button:SetScript('OnClick', function() AI:AffinitiiSetup() end)
		SLEInstallOption2Button:SetText(L["Affinitii's Config"])

		SLEInstallOption3Button:Show()
		SLEInstallOption3Button:SetScript('OnClick', function() AI:RepoocSetup() end)
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