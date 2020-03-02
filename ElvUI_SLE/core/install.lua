local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule("PluginInstaller")
PI.SLE_Auth = ""
PI.SLE_Word = ""
local locale = GetLocale()

--GLOBALS: SkadaDB, Skada, xCTSavedDB, xCT_Plus, UIParent
local _G = _G
local ENABLE, DISABLE, NONE = ENABLE, DISABLE, NONE
local ADDONS = ADDONS
local SetCVar = SetCVar
local SetAutoDeclineGuildInvites = SetAutoDeclineGuildInvites
local SetInsertItemsLeftToRight = SetInsertItemsLeftToRight
local GetCVarBool, StopMusic, ReloadUI = GetCVarBool, StopMusic, ReloadUI

local dtbarsList = {}
local dtbarsTexts = {}

local function DarthHeal()
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["height"] = 22

	E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,301,601"
	E.db["movers"]["LootFrameMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,249,510"
end

local function DarthOldHeal()
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["height"] = 22

	E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,309,429"
end

function PI:DarthSetup()
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]

	if T.IsAddOnLoaded("ElvUI_DTBars2") then
		T.twipe(dtbarsList)
		T.twipe(dtbarsTexts)
		for name, data in T.pairs(E.global.dtbars) do
			if E.db.dtbars and E.db.dtbars[name] then
				dtbarsList[name] = E.db.dtbars[name]
				dtbarsTexts[name] = E.db.datatexts.panels[name]
			end
		end
	end

	T.twipe(E.db)
	E:CopyTable(E.db, P)

	T.twipe(E.private)
	E:CopyTable(E.private, V)

	E:ResetMovers("")
	if not E.db["movers"] then E.db["movers"] = {} end
	-- if E.db['movers'] then T.twipe(E.db['movers']) else E.db['movers'] = {} end

	--General
	do
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["hideErrorFrame"] = false
		E.db["general"]["talkingHeadFrameScale"] = 0.8
		E.db["general"]["talkingHeadFrameBackdrop"] = true
		E.db["general"]["objectiveFrameHeight"] = 400
		E.db["general"]["vehicleSeatIndicatorSize"] = 88
		E.db["general"]["autoRepair"] = "PLAYER"
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["bonusObjectivePosition"] = "RIGHT"

		E.db["general"]["minimap"]["size"] = 220
		E.db["general"]["minimap"]["locationText"] = "HIDE"

		E.db["general"]["bordercolor"]["b"] = 0
		E.db["general"]["bordercolor"]["g"] = 0
		E.db["general"]["bordercolor"]["r"] = 0

		E.db["general"]["valuecolor"]["a"] = 1
		E.db["general"]["valuecolor"]["b"] = 0
		E.db["general"]["valuecolor"]["g"] = 0.66666666666667
		E.db["general"]["valuecolor"]["r"] = 0

		E.db["general"]["totems"]["size"] = 30
		E.db["general"]["totems"]["growthDirection"] = "HORIZONTAL"
		E.db["general"]["totems"]["spacing"] = 2

		E.db["general"]["threat"]["enable"] = false
	end
	--Actionbars
	do
		E.db["actionbar"]["backdropSpacingConverted"] = true
		E.db["actionbar"]["transparent"] = true

		E.db["actionbar"]["bar1"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 6
		E.db["actionbar"]["bar1"]["buttonsize"] = 48
		E.db["actionbar"]["bar1"]["buttonspacing"] = -1

		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar2"]["buttonspacing"] = -1
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar2"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonspacing"] = -1
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar4"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar4"]["backdrop"] = false
		E.db["actionbar"]["bar4"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar4"]["buttonsize"] = 34
		E.db["actionbar"]["bar4"]["buttonspacing"] = -1

		E.db["actionbar"]["bar5"]["buttonsize"] = 34
		E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonspacing"] = -1
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["barPet"]["point"] = "TOPLEFT"
		E.db["actionbar"]["barPet"]["buttonspacing"] = -1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 5
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsize"] = 24

		E.db["actionbar"]["stanceBar"]["buttonspacing"] = -1
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 22
		E.db["actionbar"]["stanceBar"]["style"] = "classic"

		E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
		E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 16
		E.db["actionbar"]["cooldown"]["mmssThreshold"] = 900
		E.db["actionbar"]["cooldown"]["checkSeconds"] = true
	end
	--Auras
	do
		E.db["auras"]["buffs"]["countFontSize"] = 10
		E.db["auras"]["buffs"]["durationFontSize"] = 12
		E.db["auras"]["buffs"]["size"] = 40
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["wrapAfter"] = 10

		E.db["auras"]["debuffs"]["countFontSize"] = 10
		E.db["auras"]["debuffs"]["durationFontSize"] = 12
		E.db["auras"]["debuffs"]["size"] = 40
		E.db["auras"]["debuffs"]["horizontalSpacing"] = 3
		E.db["auras"]["debuffs"]["wrapAfter"] = 10

		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["font"] = "PT Sans Narrow"
		E.db["auras"]["timeYOffset"] = -2
	end
	--Bags
	do
		E.db["bags"]["transparent"] = true
		E.db["bags"]["countFontSize"] = 12
		E.db["bags"]["itemLevelFont"] = "PT Sans Narrow"
		E.db["bags"]["itemLevelThreshold"] = 140
		E.db["bags"]["bagSize"] = 33
		E.db["bags"]["itemLevelFontSize"] = 12
		E.db["bags"]["scrapIcon"] = true
		E.db["bags"]["bagWidth"] = 472
		E.db["bags"]["countFont"] = "Univers"
		E.db["bags"]["clearSearchOnClose"] = true
		E.db["bags"]["countFontOutline"] = "OUTLINE"
		E.db["bags"]["bankSize"] = 33
		E.db["bags"]["vendorGrays"]["enable"] = true
		E.db["bags"]["bankWidth"] = 472
		E.db["bags"]["moneyFormat"] = "BLIZZARD2"
		E.db["bags"]["junkIcon"] = true
		E.db["bags"]["currencyFormat"] = "ICON"
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	end
	--Chat
	do
		E.db["chat"]["fontSize"] = 10
		E.db["chat"]["fontOutline"] = "OUTLINE"
		E.db["chat"]["tapFontSize"] = 10
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
		E.db["chat"]["whisperSound"] = "None"
		E.db["chat"]["panelColorConverted"] = true
		E.db["chat"]["panelHeight"] = 201
		E.db["chat"]["panelWidth"] = 472
		E.db["chat"]["emotionIcons"] = false
	end
	--Databars
	do
		E.db["databars"]["reputation"]["enable"] = true
		E.db["databars"]["reputation"]["height"] = 201
		E.db["databars"]["reputation"]["width"] = 8

		E.db["databars"]["azerite"]["height"] = 10
		E.db["databars"]["azerite"]["textFormat"] = "CURMAX"
		E.db["databars"]["azerite"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["azerite"]["width"] = 529

		E.db["databars"]["experience"]["height"] = 201
		E.db["databars"]["experience"]["textSize"] = 12
		E.db["databars"]["experience"]["width"] = 8

		E.db["databars"]["honor"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["honor"]["textFormat"] = "CURMAX"
		E.db["databars"]["honor"]["height"] = 10
		E.db["databars"]["honor"]["width"] = 529
	end
	--Datatexts
	do
		E.db["datatexts"]["noCombatClick"] = true
		E.db["datatexts"]["goldCoins"] = true
		E.db["datatexts"]["goldFormat"] = "BLIZZARD2"
		E.db["datatexts"]["panelTransparency"] = true
		E.db["datatexts"]["fontOutline"] = "OUTLINE"
		E.db["datatexts"]["noCombatHover"] = true

		E.db["datatexts"]["panels"]["SLE_DataPanel_7"] = "System"

		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Mastery"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = "S&L Item Level"

		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Combat/Arena Time"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "S&L Guild"

		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["right"] = "Bags"
		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["left"] = "S&L Friends"
		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["middle"] = "S&L Currency"

		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["right"] = "Haste"
		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Spell/Heal Power"
		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Crit Chance"

		E.db["datatexts"]["panels"]["LeftMiniPanel"] = "S&L Time Played"
		E.db["datatexts"]["panels"]["RightMiniPanel"] = "Time"

		if T.IsAddOnLoaded("ElvUI_DTBars2") then
			if not E.db.dtbars then E.db.dtbars = {} end
			for name, data in T.pairs(E.global.dtbars) do
				if dtbarsList[name] then
					E.db.dtbars[name] = dtbarsList[name]
					E.db.datatexts.panels[name] = dtbarsTexts[name]
				end
			end
		end
	end
	--Nameplates
	do
		E.db["v11NamePlateReset"] = true

		E.db["nameplates"]["lowHealthThreshold"] = 0
		E.db["nameplates"]["statusbar"] = "Polished Wood"
		E.db["nameplates"]["clickThrough"]["personal"] = true
		E.db["nameplates"]["clampToScreen"] = true

		E.db["nameplates"]["threat"]["beingTankedByTank"] = false

		E.db["nameplates"]["units"]["PLAYER"]["enable"] = true
		E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["buffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["useStaticPosition"] = true
		E.db["nameplates"]["units"]["PLAYER"]["showWithTarget"] = true
		E.db["nameplates"]["units"]["PLAYER"]["showInCombat"] = true
		E.db["nameplates"]["units"]["PLAYER"]["castbar"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["power"]["yOffset"] = -10
		E.db["nameplates"]["units"]["PLAYER"]["classpower"]["width"] = 146
		E.db["nameplates"]["units"]["PLAYER"]["classpower"]["yOffset"] = 9

		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 10
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterrupt"] = false
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 20
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["yOffset"] = 14
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["height"] = 12
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["format"] = "[health:current-percent]"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 14
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = "[name:medium]"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 14
		E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["fontSize"] = 14
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 40
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["height"] = 4
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["yOffset"] = -9
		E.db["nameplates"]["units"]["ENEMY_NPC"]["questIconSize"] = 24

		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIconSize"] = 24

		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["priority"] = "Blacklist,Personal,CCDebuffs"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["yOffset"] = 10
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["height"] = 4
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["yOffset"] = -9
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterrupt"] = false
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["height"] = 12
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["format"] = "[health:current-percent]"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 14
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["maxDuration"] = 0
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 40
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["fontSize"] = 14
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = "[name:medium]"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 14
	end
	--Tooltips
	do
		E.db["tooltip"]["fontSize"] = 10
		E.db["tooltip"]["healthBar"]["height"] = 12
		E.db["tooltip"]["healthBar"]["font"] = "PT Sans Narrow"
		E.db["tooltip"]["healthBar"]["fontSize"] = 12
		E.db["tooltip"]["itemCount"] = "NONE"
	end
	--Unitframes
	do
		E.db["unitframe"]["fontSize"] = 12
		E.db["unitframe"]["statusbar"] = "Polished Wood"
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["thinBorders"] = true

		E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 17
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 24
		E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 14
		E.db["unitframe"]["units"]["player"]["RestIcon"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = 10
		E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["iconAttachedTo"] = "Castbar"
		E.db["unitframe"]["units"]["player"]["castbar"]["iconXOffset"] = -2
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 22
		E.db["unitframe"]["units"]["player"]["castbar"]["iconSize"] = 32
		E.db["unitframe"]["units"]["player"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 220
		E.db["unitframe"]["units"]["player"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 32
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["xOffset"] = 14
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = -7
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["power"]["powerPrediction"] = true
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 12
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"] = {}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["text_format"] = "[absorbs:sl-short]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorbs"]["size"] = 12
		E.db["unitframe"]["units"]["player"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["player"]["width"] = 220
		E.db["unitframe"]["units"]["player"]["name"]["yOffset"] = 13
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = "[name] [level]"
		E.db["unitframe"]["units"]["player"]["name"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = -30
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["height"] = 50
		E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = ""

		E.db["unitframe"]["units"]["target"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["power"]["powerPrediction"] = true
		E.db["unitframe"]["units"]["target"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 12
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"] = {}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["text_format"] = "[absorbs:sl-short]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["yOffset"] = -6
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorbs"]["size"] = 12
		E.db["unitframe"]["units"]["target"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["target"]["width"] = 220
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["iconAttachedTo"] = "Castbar"
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 220
		E.db["unitframe"]["units"]["target"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["castbar"]["iconSize"] = 32
		E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 22
		E.db["unitframe"]["units"]["target"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["target"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["target"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 13
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = "[name] [level]"
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["height"] = 50
		E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "DEBUFFS"
		E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = 30
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["raidicon"]["attachTo"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 17
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 20
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 24

		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100
		E.db["unitframe"]["units"]["targettarget"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["targettarget"]["height"] = 25
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 20
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 20

		E.db["unitframe"]["units"]["focus"]["width"] = 150
		E.db["unitframe"]["units"]["focus"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["focus"]["raidicon"]["size"] = 22
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 20
		E.db["unitframe"]["units"]["focus"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 270

		E.db["unitframe"]["units"]["pet"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["pet"]["disableTargetGlow"] = false
		E.db["unitframe"]["units"]["pet"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["pet"]["portrait"]["camDistanceScale"] = 2
		E.db["unitframe"]["units"]["pet"]["height"] = 25
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 25
		E.db["unitframe"]["units"]["pet"]["castbar"]["iconSize"] = 32
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 118

		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 24
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 8
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["resurrectIcon"]["attachTo"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["raid"]["width"] = 91
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["raid"]["health"]["bgUseBarTexture"] = false
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = -4
		E.db["unitframe"]["units"]["raid"]["height"] = 28
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[nogroup] hide;show"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["attachTo"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["attachToObject"] = "Health"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 0

		E.db["unitframe"]["units"]["tank"]["enable"] = false
		E.db["unitframe"]["units"]["assist"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["enable"] = false

		E.db["unitframe"]["units"]["arena"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["arena"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["arena"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["arena"]["power"]["yOffset"] = -4
		E.db["unitframe"]["units"]["arena"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["arena"]["name"]["yOffset"] = -2
		E.db["unitframe"]["units"]["arena"]["name"]["text_format"] = "[level] [namecolor][name]"
		E.db["unitframe"]["units"]["arena"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["arena"]["height"] = 40
		E.db["unitframe"]["units"]["arena"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["arena"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["arena"]["castbar"]["format"] = "CURRENTMAX"

		E.db["unitframe"]["units"]["boss"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["debuffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = -16
		E.db["unitframe"]["units"]["boss"]["portrait"]["camDistanceScale"] = 2
		E.db["unitframe"]["units"]["boss"]["portrait"]["width"] = 45
		E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["boss"]["power"]["yOffset"] = -4
		E.db["unitframe"]["units"]["boss"]["width"] = 246
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 17
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = "[namecolor][name]"
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["boss"]["castbar"]["format"] = "CURRENTMAX"
		E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 256
		E.db["unitframe"]["units"]["boss"]["height"] = 40
		E.db["unitframe"]["units"]["boss"]["buffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"

		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.4078431372549
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.82352941176471
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.48235294117647
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.25098039215686
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.76470588235294
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.8156862745098
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["a"] = 0.61000001430511
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["b"] = 0.5921568627451
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["r"] = 0.95686274509804
		E.db["unitframe"]["colors"]["healPrediction"]["overabsorbs"]["a"] = 0.61073982715607
		E.db["unitframe"]["colors"]["healPrediction"]["overabsorbs"]["b"] = 1
		E.db["unitframe"]["colors"]["healPrediction"]["overhealabsorbs"]["a"] = 0.61000001430511
	end
	--S&L
	do
		E.db["sle"]["databars"]["azerite"]["longtext"] = true
		E.db["sle"]["databars"]["honor"]["chatfilter"]["awardStyle"] = "STYLE2"
		E.db["sle"]["databars"]["honor"]["chatfilter"]["style"] = "STYLE8"
		E.db["sle"]["databars"]["honor"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["rep"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["rep"]["chatfilter"]["styleDec"] = "STYLE2"
		E.db["sle"]["databars"]["rep"]["chatfilter"]["style"] = "STYLE2"
		E.db["sle"]["databars"]["exp"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["exp"]["chatfilter"]["style"] = "STYLE2"

		E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Old Cyrillic"

		E.db["sle"]["armory"]["character"]["enchant"]["fontSize"] = 11
		E.db["sle"]["armory"]["character"]["background"]["overlay"] = false
		E.db["sle"]["armory"]["character"]["durability"]["fontSize"] = 10
		E.db["sle"]["armory"]["character"]["gradient"]["quality"] = true
		E.db["sle"]["armory"]["character"]["ilvl"]["fontSize"] = 12
		E.db["sle"]["armory"]["inspect"]["ilvl"]["fontSize"] = 12
		E.db["sle"]["armory"]["inspect"]["enchant"]["fontSize"] = 10
		E.db["sle"]["armory"]["stats"]["List"]["POWER"] = true
		E.db["sle"]["armory"]["stats"]["List"]["HEALTH"] = true
		E.db["sle"]["armory"]["stats"]["IlvlColor"] = true
		E.db["sle"]["armory"]["stats"]["IlvlFull"] = true

		E.db["sle"]["chat"]["tab"]["select"] = true
		E.db["sle"]["chat"]["dpsSpam"] = true

		E.db["sle"]["loot"]["autoroll"]["autoconfirm"] = true
		E.db["sle"]["loot"]["autoroll"]["autogreed"] = true
		E.db["sle"]["loot"]["looticons"]["enable"] = true
		E.db["sle"]["loot"]["enable"] = true

		E.db["sle"]["uibuttons"]["point"] = "TOPRIGHT"
		E.db["sle"]["uibuttons"]["yoffset"] = -1
		E.db["sle"]["uibuttons"]["enable"] = true
		E.db["sle"]["uibuttons"]["orientation"] = "horizontal"
		E.db["sle"]["uibuttons"]["spacing"] = 1
		E.db["sle"]["uibuttons"]["anchor"] = "BOTTOMRIGHT"
		E.db["sle"]["uibuttons"]["size"] = 18

		E.db["sle"]["raidmanager"]["roles"] = true

		E.db["sle"]["minimap"]["instance"]["enable"] = true
		E.db["sle"]["minimap"]["locPanel"]["enable"] = true
		E.db["sle"]["minimap"]["locPanel"]["width"] = 310

		E.db["sle"]["tooltip"]["alwaysCompareItems"] = true
		E.db["sle"]["tooltip"]["showFaction"] = true

		E.db["sle"]["dt"]["friends"]["expandBNBroadcast"] = true
		E.db["sle"]["dt"]["friends"]["totals"] = true
		E.db["sle"]["dt"]["currency"]["Unused"] = false
		E.db["sle"]["dt"]["currency"]["Archaeology"] = false
		E.db["sle"]["dt"]["currency"]["gold"]["method"] = "amount"
		E.db["sle"]["dt"]["currency"]["Jewelcrafting"] = false
		E.db["sle"]["dt"]["guild"]["hide_guildname"] = true
		E.db["sle"]["dt"]["guild"]["totals"] = true
		E.db["sle"]["dt"]["guild"]["hide_gmotd"] = true
		E.db["sle"]["dt"]["durability"]["threshold"] = 30
		E.db["sle"]["dt"]["durability"]["gradient"] = true

		E.db["sle"]["datatexts"]["chathandle"] = true
		E.db["sle"]["datatexts"]["leftchat"]["width"] = 458
		E.db["sle"]["datatexts"]["panel7"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel7"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel7"]["width"] = 253
		E.db["sle"]["datatexts"]["panel7"]["transparent"] = true
		E.db["sle"]["datatexts"]["panel6"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel6"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel6"]["width"] = 470
		E.db["sle"]["datatexts"]["panel6"]["transparent"] = true
		E.db["sle"]["datatexts"]["rightchat"]["width"] = 458
		E.db["sle"]["datatexts"]["panel8"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel8"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel8"]["width"] = 470
		E.db["sle"]["datatexts"]["panel8"]["transparent"] = true

		E.db["sle"]["nameplates"]["targetcount"]["enable"] = true
		E.db["sle"]["nameplates"]["threat"]["enable"] = true

		E.db["sle"]["quests"]["autoReward"] = true

		E.db["sle"]["pvp"]["duels"]["pet"] = true
		E.db["sle"]["pvp"]["duels"]["regular"] = true
		E.db["sle"]["pvp"]["autorelease"] = true
	end
	--Movers
	do
		E.db["movers"]["SLE_DataPanel_6_Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,471,0"
		E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,1,-33"
		E.db["movers"]["RaidMarkerBarAnchor"] = "BOTTOM,ElvUIParent,BOTTOM,0,253"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-328,267"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,223"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,0,19"
		E.db["movers"]["GMMover"] = "BOTTOM,ElvUIParent,BOTTOM,230,21"
		E.db["movers"]["GhostFrameMover"] = "TOP,ElvUIParent,TOP,257,0"
		E.db["movers"]["SLE_UIButtonsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,0,-243"
		E.db["movers"]["LootFrameMover"] = "TOP,ElvUIParent,TOP,-324,-433"
		E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,363"
		E.db["movers"]["SocialMenuMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-187"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-199,283"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-277,349"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,312,279"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-226,319"
		E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,219"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-48,-299"
		E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,219"
		E.db["movers"]["UIErrorsFrameMover"] = "TOP,ElvUIParent,TOP,0,-150"
		E.db["movers"]["VehicleSeatMover"] = "BOTTOM,ElvUIParent,BOTTOM,-196,39"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,277,349"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,538,19"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,337,321"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,333"
		E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,-1,507"
		E.db["movers"]["LevelUpBossBannerMover"] = "TOP,ElvUIParent,TOP,0,-52"
		E.db["movers"]["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-150"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,303"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,159"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,202,159"
		E.db["movers"]["BelowMinimapContainerMover"] = "TOP,ElvUIParent,TOP,0,-94"
		E.db["movers"]["VOICECHAT"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,584,19"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-471,19"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,471,19"
		E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,96"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-202,159"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-538,19"
		E.db["movers"]["ShiftAB"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,802,274"
		E.db["movers"]["AzeriteBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,141"
		E.db["movers"]["SLE_DataPanel_8_Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-471,0"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,96,0"
		E.db["movers"]["BNETMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ElvNP_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,428"
		E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,-1,-16"
		E.db["movers"]["HonorBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,150"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-48,-299"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,280"
		E.db["movers"]["SLE_Location_Mover"] = "TOP,ElvUIParent,TOP,0,0"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-337,319"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,363"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,0,19"
		E.db["movers"]["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,464"
		E.db["movers"]["SLE_DataPanel_7_Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,0"
		E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,1,0"
	end

	if T.IsAddOnLoaded("ElvUI_AuraBarsMovers") then
		E.db["abm"]["target"] = true
		E.db["abm"]["player"] = true
		E.db["abm"]["playerw"] = 180
		E.db["abm"]["targetw"] = 180
		E.db["movers"]["ElvUF_PlayerAuraMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,481,397"
		E.db["movers"]["ElvUF_TargetAuraMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-481,397"
	end

	if T.IsAddOnLoaded("AddOnSkins") then
		local AS = T.unpack(_G["AddOnSkins"]) or nil
		if AS then
			AS.db["Blizzard_AbilityButton"] = true
			AS.db["EmbedRight"] = "Details"
			AS.db["EmbedLeft"] = "Details"
			AS.db["Blizzard_ExtraActionButton"] = true
			AS.db["ElvUIStyle"] = false
			AS.db["BackgroundTexture"] = "ElvUI Gloss"
			AS.db["EmbedOoC"] = true
			AS.db["EmbedSystemDual"] = true
			AS.db["EmbedOoCDelay"] = 3
		end
	end

	E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
	E.private["general"]["normTex"] = "Polished Wood"
	E.private["general"]["glossTex"] = "Polished Wood"
	E.private["general"]["minimap"]["hideClassHallReport"] = true

	E.private["skins"]["blizzard"]["questChoice"] = false

	E.private["sle"]["module"]["screensaver"] = true
	E.private["sle"]["pvpreadydialogreset"] = true
	E.private["sle"]["skins"]["objectiveTracker"]["scenarioBG"] = true
	E.private["sle"]["skins"]["merchant"]["enable"] = true
	E.private["sle"]["skins"]["merchant"]["style"] = "List"
	E.private["sle"]["equip"]["setoverlay"] = true
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["chat"]["chatHistory"]["CHAT_MSG_GUILD_ACHIEVEMENT"] = false
	E.private["sle"]["chat"]["chatHistory"]["CHAT_MSG_EMOTE"] = false
	E.private["sle"]["uibuttons"]["style"] = "dropdown"

	E.global["general"]["commandBarSetting"] = "DISABLED"
	E.global["general"]["fadeMapWhenMoving"] = false
	E.global["unitframe"]["ChannelTicks"][47540] = 3
	E.global["sle"]["advanced"]["general"] = true
	E.global["sle"]["advanced"]["confirmed"] = true

	if layout then
		if layout == 'tank' then
			E.db["nameplates"]["threat"]["beingTankedByTank"] = true
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Avoidance"
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Versatility"
			E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
			E.db["sle"]["armory"]["stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_ATTACKSPEED"] = true
		elseif layout == 'dpsMelee' then
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Attack Power"
			E.db["sle"]["armory"]["stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_ATTACKSPEED"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ENERGY_REGEN"] = true
			E.db["sle"]["armory"]["stats"]["List"]["RUNE_REGEN"] = true
			E.db["sle"]["armory"]["stats"]["List"]["FOCUS_REGEN"] = true
		elseif layout == 'healer' then DarthHeal()
		end
		E.db.layoutSet = layout
	else
		E.db.layoutSet = "dpsCaster"
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:StaggeredUpdateAll(nil, true)

	_G["PluginInstallStepComplete"].message = L["Darth's Default Set"]..": "..(PI.SLE_Word == NONE and L['Caster DPS'] or PI.SLE_Word)
	_G["PluginInstallStepComplete"]:Show()
end

function PI:DarthOldSetup()
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]

	if T.IsAddOnLoaded("ElvUI_DTBars2") then
		T.twipe(dtbarsList)
		T.twipe(dtbarsTexts)
		for name, data in T.pairs(E.global.dtbars) do
			if E.db.dtbars and E.db.dtbars[name] then
				dtbarsList[name] = E.db.dtbars[name]
				dtbarsTexts[name] = E.db.datatexts.panels[name]
			end
		end
	end

	T.twipe(E.db)
	E:CopyTable(E.db, P)

	T.twipe(E.private)
	E:CopyTable(E.private, V)

	-- if E.db['movers'] then T.twipe(E.db['movers']) else E.db['movers'] = {} end
	E:ResetMovers("")
	if not E.db["movers"] then E.db["movers"] = {} end

	--General
	do
		E.db["general"]["totems"]["growthDirection"] = "HORIZONTAL"
		E.db["general"]["totems"]["size"] = 30
		E.db["general"]["threat"]["enable"] = false
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["vendorGrays"] = true
		E.db["general"]["bordercolor"]["r"] = 0
		E.db["general"]["bordercolor"]["g"] = 0
		E.db["general"]["bordercolor"]["b"] = 0
		E.db["general"]["minimap"]["locationText"] = "HIDE"
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["objectiveFrameHeight"] = 640
		E.db["general"]["bonusObjectivePosition"] = "RIGHT"
		E.db["general"]["hideErrorFrame"] = false
		E.db["general"]["valuecolor"]["a"] = 1
		E.db["general"]["valuecolor"]["r"] = 0
		E.db["general"]["valuecolor"]["g"] = 0.66666666666667
		E.db["general"]["valuecolor"]["b"] = 0
	end
	--Actionbars
	do
		E.db["actionbar"]["transparent"] = true
		E.db["actionbar"]["bar1"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 0
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar1"]["buttonsize"] = 41
		E.db["actionbar"]["bar1"]["buttonspacing"] = -1
		E.db["actionbar"]["bar1"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 0
		E.db["actionbar"]["bar2"]["buttonspacing"] = -1
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 3
		E.db["actionbar"]["bar2"]["buttonsize"] = 31
		E.db["actionbar"]["bar2"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 0
		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonspacing"] = -1
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 3
		E.db["actionbar"]["bar3"]["buttonsize"] = 31
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 0
		E.db["actionbar"]["bar4"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar4"]["backdrop"] = false
		E.db["actionbar"]["bar4"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar4"]["buttonsize"] = 31
		E.db["actionbar"]["bar4"]["buttonspacing"] = -1
		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 0
		E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonspacing"] = -1
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar5"]["buttonsize"] = 31
		E.db["actionbar"]["bar5"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["barPet"]["point"] = "TOPLEFT"
		E.db["actionbar"]["barPet"]["buttonspacing"] = -1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 5
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsize"] = 22
		E.db["actionbar"]["backdropSpacingConverted"] = true
		E.db["actionbar"]["font"] = "PT Sans Narrow"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = -1
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 1
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 28
		E.db["actionbar"]["stanceBar"]["style"] = "classic"
		E.db["actionbar"]["keyDown"] = false
		E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
		E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 16
		E.db["actionbar"]["cooldown"]["mmssThreshold"] = 900
		E.db["actionbar"]["cooldown"]["checkSeconds"] = true
	end
	--Auras
	do
		E.db["auras"]["font"] = "PT Sans Narrow"
		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["buffs"]["wrapAfter"] = 10
		E.db["auras"]["fontSize"] = 12
		E.db["auras"]["debuffs"]["size"] = 40
		E.db["auras"]["debuffs"]["wrapAfter"] = 8
	end
	--Bags
	do
		E.db["bags"]["transparent"] = true
		E.db["bags"]["itemLevelFont"] = "PT Sans Narrow"
		E.db["bags"]["currencyFormat"] = "ICON"
		E.db["bags"]["itemLevelFontSize"] = 11
		E.db["bags"]["bagWidth"] = 505
		E.db["bags"]["countFont"] = "Univers"
		E.db["bags"]["countFontOutline"] = "OUTLINE"
		E.db["bags"]["bankSize"] = 33
		E.db["bags"]["bankWidth"] = 505
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
		E.db["bags"]["bagSize"] = 33
		E.db["bags"]["junkIcon"] = true
		E.db["bags"]["itemLevelThreshold"] = 140
	end
	--Chat
	do
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["fontOutline"] = "OUTLINE"
		E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
		E.db["chat"]["panelHeight"] = 181
		E.db["chat"]["emotionIcons"] = false
		E.db["chat"]["panelWidth"] = 445
	end
	--Databars
	do
		E.db["databars"]["azerite"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["azerite"]["textFormat"] = "CURMAX"
		E.db["databars"]["azerite"]["height"] = 10
		E.db["databars"]["azerite"]["width"] = 380
		E.db["databars"]["azerite"]["textSize"] = 10
		E.db["databars"]["reputation"]["reverseFill"] = true
		E.db["databars"]["reputation"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["reputation"]["height"] = 10
		E.db["databars"]["reputation"]["enable"] = true
		E.db["databars"]["reputation"]["width"] = 287
		E.db["databars"]["experience"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["experience"]["height"] = 10
		E.db["databars"]["experience"]["width"] = 286
		E.db["databars"]["honor"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["honor"]["textFormat"] = "CURMAX"
		E.db["databars"]["honor"]["height"] = 10
		E.db["databars"]["honor"]["width"] = 380
		E.db["databars"]["honor"]["textSize"] = 10
	end
	--Datatexts
	do
		E.db["datatexts"]["noCombatClick"] = true
		E.db["datatexts"]["noCombatHover"] = true
		E.db["datatexts"]["goldCoins"] = true
		E.db["datatexts"]["fontOutline"] = "OUTLINE"
		E.db["datatexts"]["panelTransparency"] = true
		E.db["datatexts"]["time24"] = true
		E.db["datatexts"]["panels"]["SLE_DataPanel_7"] = "System"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Mastery"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = "S&L Item Level"
		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["right"] = "Bags"
		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["left"] = "S&L Friends"
		E.db["datatexts"]["panels"]["SLE_DataPanel_6"]["middle"] = "S&L Currency"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Combat/Arena Time"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "S&L Guild"
		E.db["datatexts"]["panels"]["RightMiniPanel"] = "Time"
		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["right"] = "Haste"
		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Spell/Heal Power"
		E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Crit Chance"
		E.db["datatexts"]["panels"]["LeftMiniPanel"] = "S&L Time Played"
		if T.IsAddOnLoaded("ElvUI_DTBars2") then
			if not E.db.dtbars then E.db.dtbars = {} end
			for name, data in T.pairs(E.global.dtbars) do
				if dtbarsList[name] then
					E.db.dtbars[name] = dtbarsList[name]
					E.db.datatexts.panels[name] = dtbarsTexts[name]
				end
			end
		end
	end
	--Nameplates
	do
		E.db["v11NamePlateReset"] = true
	
		E.db["nameplates"]["fontSize"] = 12
		E.db["nameplates"]["statusbar"] = "ElvUI Gloss"
		E.db["nameplates"]["clampToScreen"] = true
		E.db["nameplates"]["clickThrough"]["personal"] = true
		E.db["nameplates"]["lowHealthThreshold"] = 0
		
		E.db["nameplates"]["colors"]["castNoInterruptColor"]["b"] = 0.12549019607843
		E.db["nameplates"]["colors"]["castNoInterruptColor"]["g"] = 0.098039215686274
		E.db["nameplates"]["colors"]["castNoInterruptColor"]["r"] = 0.85882352941176
		E.db["nameplates"]["colors"]["tapped"]["b"] = 0.72549019607843
		E.db["nameplates"]["colors"]["tapped"]["g"] = 0.72549019607843
		E.db["nameplates"]["colors"]["tapped"]["r"] = 0.72549019607843
		E.db["nameplates"]["colors"]["reactions"]["good"]["b"] = 0.10980392156863
		E.db["nameplates"]["colors"]["reactions"]["good"]["g"] = 0.74901960784314
		E.db["nameplates"]["colors"]["reactions"]["good"]["r"] = 0.082352941176471
		E.db["nameplates"]["colors"]["reactions"]["bad"]["b"] = 0.050980392156863
		E.db["nameplates"]["colors"]["reactions"]["bad"]["g"] = 0
		E.db["nameplates"]["colors"]["reactions"]["bad"]["r"] = 0.93725490196078
		E.db["nameplates"]["colors"]["reactions"]["neutral"]["b"] = 0.062745098039216
		E.db["nameplates"]["colors"]["reactions"]["neutral"]["g"] = 0.81176470588235
		E.db["nameplates"]["colors"]["reactions"]["neutral"]["r"] = 0.92156862745098
		
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["enable"] = true
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["height"] = 4
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["height"] = 4

		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["format"] = "[CURRENT_PERCENT]"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["height"] = 4
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["enable"] = false
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 20
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["yOffset"] = 14

		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["format"] = "[CURRENT_PERCENT]"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["height"] = 4

		E.db["nameplates"]["units"]["PLAYER"]["useStaticPosition"] = true
		E.db["nameplates"]["units"]["PLAYER"]["health"]["width"] = 120
		E.db["nameplates"]["units"]["PLAYER"]["power"]["width"] = 120
		E.db["nameplates"]["units"]["PLAYER"]["castbar"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["clickthrough"] = true
		E.db["nameplates"]["units"]["PLAYER"]["buffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["visibility"]["showWithTarget"] = true
		E.db["nameplates"]["units"]["PLAYER"]["enable"] = true

		E.db["nameplates"]["threat"]["beingTankedByTank"] = false
	end

	--Tooltips
	do
		E.db["tooltip"]["itemCount"] = "NONE"
		E.db["tooltip"]["healthBar"]["fontSize"] = 12
		E.db["tooltip"]["healthBar"]["font"] = "PT Sans Narrow"
	end
	--Unitframes
	do
		E.db["unitframe"]["fontSize"] = 12
		E.db["unitframe"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.25490196078431
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.76470588235294
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.20392156862745
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["customhealthbackdrop"] = true
		E.db["unitframe"]["colors"]["health_backdrop"]["b"] = 0
		E.db["unitframe"]["colors"]["health_backdrop"]["g"] = 0
		E.db["unitframe"]["colors"]["health_backdrop"]["r"] = 0
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.8156862745098
		E.db["unitframe"]["colors"]["castColor"]["r"] = 1
		E.db["unitframe"]["colors"]["healPrediction"]["personal"]["b"] = 0.50196078431373
		E.db["unitframe"]["smartRaidFilter"] = false
		E.db["unitframe"]["statusbar"] = "Ohi Dragon"
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["debuffHighlighting"] = "GLOW"

		E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 24
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 22
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 220
		E.db["unitframe"]["units"]["player"]["customTexts"] = {}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"] = {}
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["yOffset"] = -6
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["text_format"] = "[absorbs:sl-short]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["Absorb"]["size"] = 12
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["width"] = 200
		E.db["unitframe"]["units"]["player"]["name"]["yOffset"] = 13
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = "[level] [namecolor][name]"
		E.db["unitframe"]["units"]["player"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["player"]["height"] = 40
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 225
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = -30
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["RestIcon"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = 9
		E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 32
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["xOffset"] = 13
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = -7

		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 200
		E.db["unitframe"]["units"]["target"]["customTexts"] = {}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"] = {}
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["size"] = 12
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["text_format"] = "[absorbs:sl-short]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["Absorb"]["yOffset"] = -6
		E.db["unitframe"]["units"]["target"]["raidicon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 20
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 24
		E.db["unitframe"]["units"]["target"]["width"] = 200
		E.db["unitframe"]["units"]["target"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["height"] = 40
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 13
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = " [difficultycolor][level] [namecolor][name:medium] [shortclassification]"
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = 30
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "RIGHT"

		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100
		E.db["unitframe"]["units"]["targettarget"]["height"] = 25
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 14

		E.db["unitframe"]["units"]["focus"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["focus"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["width"] = 150
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 220
		E.db["unitframe"]["units"]["focus"]["height"] = 25

		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["height"] = 25

		E.db["unitframe"]["units"]["tank"]["enable"] = false
		E.db["unitframe"]["units"]["assist"]["enable"] = false

		E.db["unitframe"]["units"]["boss"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = -18
		E.db["unitframe"]["units"]["boss"]["portrait"]["camDistanceScale"] = 2
		E.db["unitframe"]["units"]["boss"]["portrait"]["width"] = 45
		E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 200
		E.db["unitframe"]["units"]["boss"]["width"] = 200
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 17
		E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["spacing"] = 22
		E.db["unitframe"]["units"]["boss"]["height"] = 47
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 10
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 27

		E.db["unitframe"]["units"]["arena"]["debuffs"]["yOffset"] = -18
		E.db["unitframe"]["units"]["arena"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["arena"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["arena"]["power"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["arena"]["width"] = 200
		E.db["unitframe"]["units"]["arena"]["spacing"] = 22
		E.db["unitframe"]["units"]["arena"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["arena"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["arena"]["buffs"]["yOffset"] = 10
		E.db["unitframe"]["units"]["arena"]["castbar"]["width"] = 200

		E.db["unitframe"]["units"]["party"]["enable"] = false

		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "PT Sans Narrow"
		E.db["unitframe"]["units"]["raid"]['growthDirection'] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 8
		E.db["unitframe"]["units"]["raid"]["width"] = 86
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 15
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = -4
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid"]["height"] = 28
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[nogroup] hide;show"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["attachTo"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["xOffset"] = -2

		E.db["unitframe"]["units"]["raid40"]["enable"] = false
	end
	--S&L
	do
		E.db["sle"]["databars"]["azerite"]["longtext"] = true
		E.db["sle"]["databars"]["honor"]["chatfilter"]["awardStyle"] = "STYLE2"
		E.db["sle"]["databars"]["honor"]["chatfilter"]["style"] = "STYLE8"
		E.db["sle"]["databars"]["honor"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["rep"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["rep"]["chatfilter"]["styleDec"] = "STYLE2"
		E.db["sle"]["databars"]["rep"]["chatfilter"]["style"] = "STYLE2"
		E.db["sle"]["databars"]["exp"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["exp"]["chatfilter"]["style"] = "STYLE2"
		E.db["sle"]["media"]["fonts"]["zone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["subzone"]["font"] = "Old Cyrillic"
		E.db["sle"]["media"]["fonts"]["pvp"]["font"] = "Old Cyrillic"
		E.db["sle"]["blizzard"]["vehicleSeatScale"] = 0.7
		E.db["sle"]["dt"]["durability"]["threshold"] = 30
		E.db["sle"]["dt"]["durability"]["gradient"] = true
		E.db["sle"]["dt"]["currency"]["Jewelcrafting"] = false
		E.db["sle"]["dt"]["currency"]["Archaeology"] = false
		E.db["sle"]["dt"]["currency"]["Unused"] = false
		E.db["sle"]["dt"]["currency"]["gold"]["method"] = "amount"
		E.db["sle"]["dt"]["currency"]["gold"]["direction"] = "normal"
		E.db["sle"]["dt"]["guild"]["hide_guildname"] = true
		E.db["sle"]["dt"]["guild"]["totals"] = true
		E.db["sle"]["dt"]["guild"]["hide_gmotd"] = true
		E.db["sle"]["dt"]["friends"]["expandBNBroadcast"] = true
		E.db["sle"]["dt"]["friends"]["totals"] = true
		E.db["sle"]["loot"]["history"]["alpha"] = 0.7
		E.db["sle"]["loot"]["history"]["autohide"] = true
		E.db["sle"]["loot"]["looticons"]["enable"] = true
		E.db["sle"]["loot"]["enable"] = true
		E.db["sle"]["loot"]["autoroll"]["autoconfirm"] = true
		E.db["sle"]["loot"]["autoroll"]["autogreed"] = true
		E.db["sle"]["uibuttons"]["point"] = "TOPRIGHT"
		E.db["sle"]["uibuttons"]["enable"] = true
		E.db["sle"]["uibuttons"]["spacing"] = 1
		E.db["sle"]["uibuttons"]["anchor"] = "BOTTOMRIGHT"
		E.db["sle"]["uibuttons"]["orientation"] = "horizontal"
		E.db["sle"]["uibuttons"]["yoffset"] = -1
		E.db["sle"]["raidmanager"]["roles"] = true
		E.db["sle"]["tooltip"]["alwaysCompareItems"] = true
		E.db["sle"]["tooltip"]["showFaction"] = true
		E.db["sle"]["raidmarkers"]["spacing"] = -1
		E.db["sle"]["raidmarkers"]["buttonSize"] = 24
		E.db["sle"]["nameplates"]["threat"]["enable"] = true
		E.db["sle"]["nameplates"]["targetcount"]["enable"] = true
		E.db["sle"]["chat"]["dpsSpam"] = true
		E.db["sle"]["chat"]["tab"]["select"] = true
		E.db["sle"]["datatexts"]["chathandle"] = true
		E.db["sle"]["datatexts"]["leftchat"]["width"] = 458
		E.db["sle"]["datatexts"]["panel7"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel7"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel7"]["width"] = 253
		E.db["sle"]["datatexts"]["panel7"]["transparent"] = true
		E.db["sle"]["datatexts"]["panel6"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel6"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel6"]["width"] = 470
		E.db["sle"]["datatexts"]["panel6"]["transparent"] = true
		E.db["sle"]["datatexts"]["rightchat"]["width"] = 458
		E.db["sle"]["datatexts"]["panel8"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel8"]["pethide"] = false
		E.db["sle"]["datatexts"]["panel8"]["width"] = 470
		E.db["sle"]["datatexts"]["panel8"]["transparent"] = true
		E.db["sle"]["unitframes"]["statusTextures"]["auraTexture"] = "Ohi Tribal4"
		E.db["sle"]["unitframes"]["statusTextures"]["castTexture"] = "Ohi Tribal4"
		E.db["sle"]["unitframes"]["statusTextures"]["classTexture"] = "ElvUI Gloss"
		E.db["sle"]["unitframes"]["unit"]["player"]["pvpIconText"]["enable"] = true
		E.db["sle"]["minimap"]["locPanel"]["enable"] = true
		E.db["sle"]["minimap"]["locPanel"]["width"] = 310
		E.db["sle"]["minimap"]["instance"]["enable"] = true
		E.db["sle"]["quests"]["visibility"]["enable"] = true
		E.db["sle"]["quests"]["visibility"]["rested"] = "COLLAPSED"
		E.db["sle"]["quests"]["visibility"]["garrison"] = "COLLAPSED"
		E.db["sle"]["quests"]["autoReward"] = true
		E.db["sle"]["pvp"]["duels"]["pet"] = true
		E.db["sle"]["pvp"]["duels"]["regular"] = true
		E.db["sle"]["pvp"]["autorelease"] = true
		E.db["sle"]["skins"]["merchant"]["list"]["subSize"] = 11
		E.db["sle"]["skins"]["merchant"]["list"]["nameSize"] = 12
		E.db["sle"]["armory"]["inspect"]["ilvl"]["fontSize"] = 12
		E.db["sle"]["armory"]["inspect"]["enchant"]["fontSize"] = 10
		E.db["sle"]["armory"]["character"]["enchant"]["fontSize"] = 11
		E.db["sle"]["armory"]["character"]["durability"]["fontSize"] = 10
		E.db["sle"]["armory"]["character"]["ilvl"]["fontSize"] = 12
		E.db["sle"]["armory"]["character"]["background"]["selectedBG"] = "TheEmpire"
		E.db["sle"]["armory"]["character"]["background"]["overlay"] = false
		E.db["sle"]["armory"]["character"]["gradient"]["quality"] = true
		E.db["sle"]["armory"]["stats"]["IlvlColor"] = true
		E.db["sle"]["armory"]["stats"]["IlvlFull"] = true
		E.db["sle"]["armory"]["stats"]["List"]["SPELLPOWER"] = true
		E.db["sle"]["armory"]["stats"]["List"]["HEALTH"] = true
		E.db["sle"]["armory"]["stats"]["List"]["POWER"] = true
		E.db["sle"]["armory"]["stats"]["List"]["MOVESPEED"] = true
	end
	--Movers
	do
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,286,118"
		E.db["movers"]["RaidMarkerBarAnchor"] = "BOTTOM,ElvUIParent,BOTTOM,0,137"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,165"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,201"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,0,19"
		E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,285,0"
		E.db["movers"]["GhostFrameMover"] = "TOP,ElvUIParent,TOP,288,0"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,1,245"
		E.db["movers"]["LootFrameMover"] = "TOP,ElvUIParent,TOP,270,-528"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,736"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-4,228"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-163,167"
		E.db["movers"]["VehicleSeatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,520,44"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,504,19"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,161,141"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,432"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,290,141"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,19"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,125,19"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-444,19"
		E.db["movers"]["ReputationBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,313,19"
		E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-46"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,195"
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-65"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-125,19"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,444,19"
		E.db["movers"]["AzeriteBarMover"] = "TOP,ElvUIParent,TOP,0,-29"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-3,188"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-220,186"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,98,-4"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-59,-299"
		E.db["movers"]["ShiftAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,761,29"
		E.db["movers"]["HonorBarMover"] = "TOP,ElvUIParent,TOP,0,-20"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-59,-299"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-267,142"
		E.db["movers"]["PvPMover"] = "TOP,ElvUIParent,TOP,-5,-59"
		E.db["movers"]["SLE_Location_Mover"] = "TOP,ElvUIParent,TOP,0,1"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-163,141"
		E.db["movers"]["SLE_UIButtonsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-201"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,19"
		E.db["movers"]["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,312"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-187,-158"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,211,189"
		E.db["movers"]["PlayerNameplate"] = "BOTTOM,ElvUIParent,BOTTOM,0,426"
		E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,199"
		E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,199"
		E.db["movers"]["SLE_DataPanel_8_Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-471,0"
		E.db["movers"]["SLE_DataPanel_6_Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,471,0"
	end

	if T.IsAddOnLoaded("ElvUI_AuraBarsMovers") then
		E.db["abm"]["target"] = true
		E.db["abm"]["player"] = true
		E.db["abm"]["playerw"] = 180
		E.db["abm"]["targetw"] = 180
		E.db["movers"]["ElvUF_PlayerAuraMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,459,206"
		E.db["movers"]["ElvUF_TargetAuraMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-468,209"
	end

	if T.IsAddOnLoaded("AddOnSkins") then
		local AS = T.unpack(_G["AddOnSkins"]) or nil
		AS.db["EmbedOoCDelay"] = 3
		AS.db["Blizzard_AbilityButton"] = true
		AS.db["Blizzard_Transmogrify"] = false
		AS.db["ParchmentRemover"] = false
		AS.db["Parchment"] = true
		AS.db["EmbedIsHidden"] = true
		AS.db["LoginMsg"] = false
		AS.db["EmbedRight"] = "Skada"
		AS.db["EmbedLeft"] = "Skada"
		AS.db["DBMFont"] = "PT Sans Narrow"
		AS.db["Blizzard_ExtraActionButton"] = true
		AS.db["WeakAuraIconCooldown"] = true
		AS.db["EmbedOoC"] = true
		AS.db["EmbedSystemDual"] = true
		AS.db["MasterPlan"] = true
		AS.db["DBMSkinHalf"] = true
	end

	E.private["general"]["normTex"] = "Ohi MetalSheet"
	E.private["general"]["glossTex"] = "Ohi MetalSheet"
	E.private["general"]["minimap"]["hideClassHallReport"] = true
	
	E.private["skins"]["blizzard"]["questChoice"] = false

	E.private["sle"]["module"]["screensaver"] = true
	E.private["sle"]["uibuttons"]["style"] = "dropdown"
	E.private["sle"]["uibuttons"]["transparent"] = "Transparent"
	E.private["sle"]["minimap"]["mapicons"]["enable"] = true
	E.private["sle"]["unitframe"]["resizeHealthPrediction"] = true
	E.private["sle"]["unitframe"]["statusbarTextures"]["cast"] = true
	E.private["sle"]["unitframe"]["statusbarTextures"]["class"] = true
	E.private["sle"]["unitframe"]["statusbarTextures"]["aura"] = true
	E.private["sle"]["chat"]["chatHistory"]["CHAT_MSG_GUILD_ACHIEVEMENT"] = false
	E.private["sle"]["chat"]["chatHistory"]["CHAT_MSG_EMOTE"] = false
	E.private["sle"]["skins"]["merchant"]["enable"] = true
	E.private["sle"]["skins"]["merchant"]["style"] = "List"
	E.private["sle"]["skins"]["objectiveTracker"]["scenarioBG"] = true
	E.private["sle"]["equip"]["setoverlay"] = true

	E.global["sle"]["advanced"]["optionsLimits"] = true
	E.global["sle"]["advanced"]["cyrillics"]["commands"] = true
	E.global["general"]["animateConfig"] = false
	E.global["general"]["commandBarSetting"] = "DISABLED"
	E.global["general"]["fadeMapWhenMoving"] = false

	if layout then
		if layout == 'tank' then
			E.db["nameplates"]["threat"]["beingTankedByTank"] = true
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Avoidance"
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Versatility"
			E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
			E.db["sle"]["armory"]["stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_ATTACKSPEED"] = true
		elseif layout == 'dpsMelee' then
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Attack Power"
			E.db["sle"]["armory"]["stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ATTACK_ATTACKSPEED"] = true
			E.db["sle"]["armory"]["stats"]["List"]["ENERGY_REGEN"] = true
			E.db["sle"]["armory"]["stats"]["List"]["RUNE_REGEN"] = true
			E.db["sle"]["armory"]["stats"]["List"]["FOCUS_REGEN"] = true
		elseif layout == 'healer' then DarthOldHeal()
		end
		E.db.layoutSet = layout
	else
		E.db.layoutSet = "dpsCaster"
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:StaggeredUpdateAll(nil, true)

	_G["PluginInstallStepComplete"].message = L["Darth's Default Set"]..": "..(PI.SLE_Word == NONE and L['Caster DPS'] or PI.SLE_Word)
	_G["PluginInstallStepComplete"]:Show()
end

function PI:DarthAddons()
	if xCTSavedDB and T.IsAddOnLoaded("xCT+") then
		xCTSavedDB["profiles"]["S&L Darth"] = {
			["frames"] = {
				["general"] = {
					["enabledFrame"] = false,
					["font"] = "PT Sans Narrow",
					["fontOutline"] = "2OUTLINE",
				},
				["power"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
				},
				["healing"] = {
					["enableRealmNames"] = false,
					["fontSize"] = 12,
					["enableClassNames"] = false,
					["fontOutline"] = "2OUTLINE",
					["enableOverHeal"] = false,
					["insertText"] = "top",
					["Width"] = 115,
					["Y"] = -30,
					["X"] = 221,
					["Height"] = 157,
					["font"] = "PT Sans Narrow",
					["showFriendlyHealers"] = false,
					["names"] = {
						["PLAYER"] = {
							["nameType"] = 0,
						},
						["NPC"] = {
							["nameType"] = 0,
						},
					},
					["enableFontShadow"] = false,
				},
				["outgoing"] = {
					["fontSize"] = 12,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 98,
					["Y"] = -250,
					["X"] = 560,
					["Height"] = 177,
					["font"] = "PT Sans Narrow",
					["enableFontShadow"] = false,
				},
				["critical"] = {
					["fontSize"] = 16,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 130,
					["Y"] = -252,
					["X"] = 674,
					["Height"] = 174,
					["font"] = "PT Sans Narrow",
					["enableFontShadow"] = false,
				},
				["procs"] = {
					["enabledFrame"] = false,
					["font"] = "PT Sans Narrow",
					["fontOutline"] = "2OUTLINE",
				},
				["loot"] = {
					["fontSize"] = 12,
					["X"] = 627,
					["fontOutline"] = "2OUTLINE",
					["Y"] = -103,
					["font"] = "PT Sans Narrow",
					["Height"] = 115,
					["Width"] = 232,
					["enableFontShadow"] = false,
				},
				["class"] = {
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
					["fontOutline"] = "2OUTLINE",
				},
				["damage"] = {
					["fontSize"] = 12,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 115,
					["fontJustify"] = "RIGHT",
					["font"] = "PT Sans Narrow",
					["Height"] = 157,
					["Y"] = -31,
					["X"] = -217,
					["names"] = {
						["PLAYER"] = {
							["nameType"] = 0,
						},
						["NPC"] = {
							["nameType"] = 0,
						},
						["ENVIRONMENT"] = {
							["nameType"] = 0,
						},
					},
					["enableFontShadow"] = false,
				},
			},
		}
		xCT_Plus.db:SetProfile("S&L Darth")
	end

	_G["PluginInstallStepComplete"].message = L["Addons settings imported"]
	_G["PluginInstallStepComplete"]:Show()
end

local function SetupCVars(Author)
	SetCVar("mapFade", "0")
	SetCVar("cameraSmoothStyle", "0")
	SetCVar("autoLootDefault", "1")
	SetCVar("UberTooltips", "1")

	SetAutoDeclineGuildInvites(true)
	SetInsertItemsLeftToRight(false)

	_G["PluginInstallStepComplete"].message = L["CVars Set"]
	_G["PluginInstallStepComplete"]:Show()
end

function PI:RepoocSetup()
end

function PI:RepoocAddons()
	--Test message
end

E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'] = {
	text = L["SLE_INSTALL_SETTINGS_LAYOUT_TEXT"],
	button1 = YES,
	button2 = NO,
	-- OnAccept = function()
		-- if PI.SLE_Auth == "DARTH" then
			-- PI:DarthSetup()
		-- elseif PI.SLE_Auth == "DARTHOLD" then
			-- PI:DarthOldSetup()
		-- elseif PI.SLE_Auth == "AFFINITY" then
			-- AffinitySetup()
		-- end
	-- end,
	OnCancel = E.noop;
}

E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'] = {
	text = "",
	button1 = YES,
	button2 = NO,
	-- OnAccept = function()
		-- if PI.SLE_Auth == "DARTH" then
			-- PI:DarthAddons()
		-- elseif PI.SLE_Auth == "DARTHOLD" then
			-- PI:DarthAddons()
		-- elseif PI.SLE_Auth == "AFFINITY" then
			-- AffinityAddons()
		-- end
	-- end,
	OnCancel = E.noop;
}

local function StartSetup(Author)
	if Author == "DARTH" then
		E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.DarthSetup
	elseif Author == "DARTHOLD" then
		E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.DarthOldSetup
	-- elseif Author == "REPOOC" then
	-- elseif Author == "AFFINITY" then
		-- E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.AffinitySetup
	end
	E:StaticPopup_Show("SLE_INSTALL_SETTINGS_LAYOUT")
end

local function SetupAddons(Author)
	if AddOnSkins and (not EmbedSystem_LeftWindow or not EmbedSystem_LeftWindow) then
		local AS = T.unpack(AddOnSkins)
		AS:Embed_Check(true)
	end
	if Author == "DARTH" then
		local list = "xCT+"
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = T.format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].OnAccept = PI.DarthAddons
	-- elseif Author == "AFFINITY" then
		-- local list = "Skada\nxCT+"
		-- E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = T.format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
		-- E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].OnAccept = PI.AffinityAddons
	end
	E:StaticPopup_Show("SLE_INSTALL_SETTINGS_ADDONS")
end

local function InstallComplete()
	E.private.sle.install_complete = SLE.version

	if GetCVarBool("Sound_EnableMusic") then
		StopMusic()
	end

	ReloadUI()
end

SLE.installTable = {
	["Name"] = "|cff9482c9Shadow & Light|r",
	["Title"] = L["|cff9482c9Shadow & Light|r Installation"],
	["tutorialImage"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SLE_Banner]],
	["tutorialImageSize"] = {400, 100},
	["tutorialImagePoint"] = {0, 20},
	["Pages"] = {
		[1] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(T.format(L["Welcome to |cff9482c9Shadow & Light|r version %s!"], SLE.version))
			_G["PluginInstallFrame"].Desc1:SetText(L["SLE_INSTALL_WELCOME"])
			_G["PluginInstallFrame"].Desc2:SetText("")
			_G["PluginInstallFrame"].Desc3:SetText(L["Please press the continue button to go onto the next step."])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript("OnClick", InstallComplete)
			_G["PluginInstallFrame"].Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["Armory Mode"])
			_G["PluginInstallFrame"].Desc1:SetText(L["SLE_ARMORY_INSTALL"])
			_G["PluginInstallFrame"].Desc2:SetText(L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffFF0000Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() E.db.sle.armory.character.enable = true; E.db.sle.armory.inspect.enable = true; SLE:GetModule("Armory_Character"):ToggleArmory(); SLE:GetModule("Armory_Inspect"):ToggleArmory() end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() E.db.sle.armory.character.enable = false; E.db.sle.armory.inspect.enable = false; SLE:GetModule("Armory_Character"):ToggleArmory(); SLE:GetModule("Armory_Inspect"):ToggleArmory() end)
			_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		end,
		[3] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["AFK Mode"])
			_G["PluginInstallFrame"].Desc1:SetText(L["AFK Mode in |cff9482c9Shadow & Light|r is additional settings/elements for standard |cff1784d1ElvUI|r AFK screen."])
			_G["PluginInstallFrame"].Desc2:SetText(L["This option is bound to character and requires a UI reload to take effect."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffFF0000Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() E.private.sle.module.screensaver = true; end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() E.private.sle.module.screensaver = false; end)
			_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		end,
		[4] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["Move Blizzard frames"])
			_G["PluginInstallFrame"].Desc1:SetText(L["Allow some Blizzard frames to be moved around."])
			_G["PluginInstallFrame"].Desc2:SetText(L["This option is bound to character and requires a UI reload to take effect."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function()
				E.private.sle.module.blizzmove.enable = true;
				_G["PluginInstallStepComplete"].message = L["Move Blizzard frames"].." ".."Set to |cff00FF00"..ENABLE.."|r"
				_G["PluginInstallStepComplete"]:Show()
			end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function()
				E.private.sle.module.blizzmove.enable = false;
				_G["PluginInstallStepComplete"].message = L["Move Blizzard frames"].." ".."Set to |cffFF0000"..DISABLE.."|r"
				_G["PluginInstallStepComplete"]:Show()
			end)
			_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		end,
		[5] = function()
			PI.SLE_Auth = ""
			PI.SLE_Word = E.db.layoutSet == 'tank' and L["Tank"] or E.db.layoutSet == 'healer' and L["Healer"] or E.db.layoutSet == 'dpsMelee' and L['Physical DPS'] or E.db.layoutSet == 'dpsCaster' and L['Caster DPS'] or NONE
			_G["PluginInstallFrame"].SubTitle:SetText(L["Shadow & Light Imports"])
			_G["PluginInstallFrame"].Desc1:SetText(L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."])
			_G["PluginInstallFrame"].Desc2:SetText(T.format(L["SLE_Install_Text_AUTHOR"], PI.SLE_Word))
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffFF0000Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() PI.SLE_Auth = "DARTH"; _G["PluginInstallFrame"].Next:Click() end)
			_G["PluginInstallFrame"].Option1:SetText(L["Darth's Config"])

			-- _G["PluginInstallFrame"].Option2:Show()
			-- _G["PluginInstallFrame"].Option2:SetScript('OnClick', function() PI.SLE_Auth = "REPOOC"; _G["PluginInstallFrame"].Next:Click() end)
			-- _G["PluginInstallFrame"].Option2:SetText(L["Repooc's Config"])

			-- _G["PluginInstallFrame"].Option2:Show()
			-- _G["PluginInstallFrame"].Option2:SetScript('OnClick', function() PI.SLE_Auth = "AFFINITY"; _G["PluginInstallFrame"].Next:Click() end)
			-- _G["PluginInstallFrame"].Option2:SetText(L["Affinitii's Config"])

			_G["PluginInstallFrame"]:Size(550, 500)
		end,
		[6] = function()
			if PI.SLE_Auth == "" then _G["PluginInstallFrame"].SetPage(_G["PluginInstallFrame"].PrevPage == 5 and 7 or 5) return end
			PI.SLE_Word = E.db.layoutSet == 'tank' and L["Tank"] or E.db.layoutSet == 'healer' and L["Healer"] or E.db.layoutSet == 'dpsMelee' and L['Physical DPS'] or E.db.layoutSet == 'dpsCaster' and L['Caster DPS'] or NONE
			_G["PluginInstallFrame"].SubTitle:SetText(L["Layout & Settings Import"])
			_G["PluginInstallFrame"].Desc1:SetText(T.format(L["You have selected to use %s and role %s."], PI.SLE_Auth == "DARTH" and L["Darth's Config"] or PI.SLE_Auth == "REPOOC" and L["Repooc's Config"] or PI.SLE_Auth == "AFFINITY" and L["Affinitii's Config"], PI.SLE_Word))
			_G["PluginInstallFrame"].Desc2:SetText(L["SLE_INSTALL_LAYOUT_TEXT2"])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])

			

			if PI.SLE_Auth == "DARTH" then
				_G["PluginInstallFrame"].Option1:Show()
				_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() StartSetup("DARTH") end)
				_G["PluginInstallFrame"].Option1:SetText(L["Layout"])

				_G["PluginInstallFrame"].Option2:Show()
				_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() PI.SLE_Auth = "DARTHOLD"; StartSetup("DARTHOLD") end)
				_G["PluginInstallFrame"].Option2:SetText(L["Layout Old"])
				
				_G["PluginInstallFrame"].Option3:Show()
				_G["PluginInstallFrame"].Option3:SetScript('OnClick', function() SetupAddons("DARTH") end)
				_G["PluginInstallFrame"].Option3:SetText(ADDONS)

				_G["PluginInstallFrame"].Option4:Show()
				_G["PluginInstallFrame"].Option4:SetScript('OnClick', function() SetupCVars("DARTH") end)
				_G["PluginInstallFrame"].Option4:SetText(L["CVars"])
			end
			if PI.SLE_Auth == "AFFINITY" then
				_G["PluginInstallFrame"].Option1:Show()
				_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() StartSetup("AFFINITY") end)
				_G["PluginInstallFrame"].Option1:SetText(L["Layout"])
				
				_G["PluginInstallFrame"].Option2:Show()
				_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() SetupAddons("AFFINITY") end)
				_G["PluginInstallFrame"].Option2:SetText(ADDONS)
			end
		end,
		[7] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["Installation Complete"])
			_G["PluginInstallFrame"].Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
			_G["PluginInstallFrame"].Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript("OnClick", InstallComplete)
			_G["PluginInstallFrame"].Option1:SetText(L["Finished"])
		end,
	},
	["StepTitles"] = {
		[1] = START,
		[2] = L["Armory Mode"],
		[3] = L["AFK Mode"],
		[4] = L["Moving Frames"],
		[5] = L["Import Profile"],
		[6] = L["Author Presets"].." *",
		[7] = L["Finished"],
	},
	["StepTitlesColorSelected"] = {.53,.53,.93},
}
