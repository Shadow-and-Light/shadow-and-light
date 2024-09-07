local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local PI = E.PluginInstaller

--GLOBALS: SkadaDB, Skada, xCTSavedDB, xCT_Plus, UIParent
local _G = _G
local format = format
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local ENABLE, DISABLE, NONE = ENABLE, DISABLE, NONE
local ADDONS = ADDONS
local SetCVar = SetCVar
local SetAutoDeclineGuildInvites = SetAutoDeclineGuildInvites
local C_Container = C_Container
local GetCVarBool, StopMusic, ReloadUI = GetCVarBool, StopMusic, ReloadUI

PI.SLE_Auth = ''
PI.SLE_Word = ''

function PI:DarthSetupDF()
	local layout = E.db.layoutSet
	local installMark = E.private['install_complete']
	local installMarkSLE = E.private['sle']['install_complete']

	wipe(E.db)
	E:CopyTable(E.db, P)

	wipe(E.private)
	E:CopyTable(E.private, V)

	E:ResetMovers('')
	if not E.db['movers'] then E.db['movers'] = {} end

	--General
	do
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["talkingHeadFrameScale"] = 1
		E.db["general"]["vehicleSeatIndicatorSize"] = 112
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["decimalLength"] = 2
		E.db["general"]["font"] = "Expressway"
		E.db["general"]["autoRepair"] = "PLAYER"

		E.db["general"]["torghastBuffsPosition"] = "AUTO"
		E.db["general"]["bonusObjectivePosition"] = "AUTO"
		E.db["general"]["objectiveFrameHeight"] = 500

		E.db["general"]["backdropfadecolor"]["b"] = 0.054
		E.db["general"]["backdropfadecolor"]["g"] = 0.054
		E.db["general"]["backdropfadecolor"]["r"] = 0.054

		E.db["general"]["altPowerBar"]["statusBar"] = "WorldState Score"

		E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.6
		E.db["general"]["minimap"]["icons"]["classHall"]["xOffset"] = -13
		E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = -58
		E.db["general"]["minimap"]["icons"]["mail"]["texture"] = "Mail0"
		E.db["general"]["minimap"]["icons"]["mail"]["xOffset"] = 0
		E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = 0
		E.db["general"]["minimap"]["locationText"] = "HIDE"
		E.db["general"]["minimap"]["size"] = 220

		E.db["general"]["totems"]["growthDirection"] = "HORIZONTAL"
		E.db["general"]["totems"]["size"] = 30
		E.db["general"]["totems"]["spacing"] = 1

		E.db["general"]["valuecolor"]["b"] = 0.15294117647059
		E.db["general"]["valuecolor"]["g"] = 0.74901960784314
		E.db["general"]["valuecolor"]["r"] = 0.23529411764706

		E.db["general"]["font"] = "Expressway"
		E.db["general"]["fonts"]["objective"]["enable"] = true
		E.db["general"]["fonts"]["pvpsubzone"]["enable"] = true
		E.db["general"]["fonts"]["pvpzone"]["enable"] = true
		E.db["general"]["fonts"]["talkingtext"]["enable"] = true
		E.db["general"]["fonts"]["talkingtitle"]["enable"] = true
		E.db["general"]["fonts"]["worldsubzone"]["enable"] = true
		E.db["general"]["fonts"]["worldzone"]["enable"] = true
		E.db["general"]["fonts"]["worldzone"]["size"] = 40

		E.db["convertPages"] = true
		E.db["cooldown"]["targetAura"] = false
	end
	--Actionbars
	do
		E.db["actionbar"]["chargeCooldown"] = true
		E.db["actionbar"]["desaturateOnCooldown"] = true
		E.db["actionbar"]["font"] = "Expressway"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["fontSize"] = 15
		E.db["actionbar"]["transparent"] = true
		E.db["actionbar"]["useDrawSwipeOnCharges"] = true

		E.db["actionbar"]["bar1"]["buttonSize"] = 45
		E.db["actionbar"]["bar1"]["buttonSpacing"] = -1
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 6
		E.db["actionbar"]["bar1"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar1"]["countFontSize"] = 15
		E.db["actionbar"]["bar1"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar1"]["hotkeyFontOutline"] = "OUTLINE"
		E.db["actionbar"]["bar1"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar1"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar1"]["macroFontSize"] = 15
		E.db["actionbar"]["bar1"]["paging"]["WARLOCK"] = ""
		E.db["actionbar"]["bar1"]["point"] = "TOPLEFT"

		E.db["actionbar"]["bar2"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar2"]["countFontSize"] = 15
		E.db["actionbar"]["bar2"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar2"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar2"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar2"]["macroFontSize"] = 15
		E.db["actionbar"]["bar2"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar3"]["buttonSize"] = 40
		E.db["actionbar"]["bar3"]["buttonSpacing"] = -1
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar3"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar3"]["countFontSize"] = 15
		E.db["actionbar"]["bar3"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar3"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar3"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar3"]["macroFontSize"] = 15
		E.db["actionbar"]["bar3"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar4"]["backdrop"] = false
		E.db["actionbar"]["bar4"]["buttonSize"] = 40
		E.db["actionbar"]["bar4"]["buttonSpacing"] = -1
		E.db["actionbar"]["bar4"]["buttonsPerRow"] = 2
		E.db["actionbar"]["bar4"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar4"]["countFontSize"] = 15
		E.db["actionbar"]["bar4"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar4"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar4"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar4"]["macroFontSize"] = 15
		E.db["actionbar"]["bar4"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar5"]["buttonSize"] = 36
		E.db["actionbar"]["bar5"]["buttonSpacing"] = -1
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar5"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar5"]["countFontSize"] = 15
		E.db["actionbar"]["bar5"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar5"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar5"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar5"]["macroFontSize"] = 15
		E.db["actionbar"]["bar5"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar5"]["visibility"] = "[petbattle] hide; show"

		E.db["actionbar"]["bar6"]["buttonSize"] = 36
		E.db["actionbar"]["bar6"]["buttonSpacing"] = -1
		E.db["actionbar"]["bar6"]["buttonsPerRow"] = 4
		E.db["actionbar"]["bar6"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar6"]["countFontSize"] = 15
		E.db["actionbar"]["bar6"]["enabled"] = true
		E.db["actionbar"]["bar6"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar6"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar6"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar6"]["macroFontSize"] = 15
		E.db["actionbar"]["bar6"]["point"] = "TOPLEFT"
		E.db["actionbar"]["bar6"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar6"]["flyoutDirection"] = "LEFT"

		E.db["actionbar"]["bar7"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar7"]["countFontSize"] = 15
		E.db["actionbar"]["bar7"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar7"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar7"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar7"]["macroFontSize"] = 15
		E.db["actionbar"]["bar8"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar8"]["countFontSize"] = 15
		E.db["actionbar"]["bar8"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar8"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar8"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar8"]["macroFontSize"] = 15
		E.db["actionbar"]["bar9"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar9"]["countFontSize"] = 15
		E.db["actionbar"]["bar9"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar9"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar9"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar9"]["macroFontSize"] = 15
		E.db["actionbar"]["bar10"]["countFont"] = "Expressway"
		E.db["actionbar"]["bar10"]["countFontSize"] = 15
		E.db["actionbar"]["bar10"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["bar10"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar10"]["macroFont"] = "Expressway"
		E.db["actionbar"]["bar10"]["macroFontSize"] = 15
		E.db["actionbar"]["bar13"]["countFontSize"] = 15
		E.db["actionbar"]["bar13"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar13"]["macroFontSize"] = 15
		E.db["actionbar"]["bar14"]["countFontSize"] = 15
		E.db["actionbar"]["bar14"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar14"]["macroFontSize"] = 15
		E.db["actionbar"]["bar15"]["countFontSize"] = 15
		E.db["actionbar"]["bar15"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["bar15"]["macroFontSize"] = 15

		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonSize"] = 22
		E.db["actionbar"]["barPet"]["buttonSpacing"] = -1
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["countFont"] = "Expressway"
		E.db["actionbar"]["barPet"]["countFontSize"] = 15
		E.db["actionbar"]["barPet"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["barPet"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["barPet"]["hotkeytext"] = false
		E.db["actionbar"]["barPet"]["point"] = "TOPLEFT"

		E.db["actionbar"]["stanceBar"]["buttonSize"] = 20
		E.db["actionbar"]["stanceBar"]["buttonSpacing"] = 1
		E.db["actionbar"]["stanceBar"]["buttons"] = 6
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
		E.db["actionbar"]["stanceBar"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["stanceBar"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["stanceBar"]["hotkeytext"] = false
		E.db["actionbar"]["stanceBar"]["style"] = "classic"

		E.db["actionbar"]["extraActionButton"]["clean"] = true
		E.db["actionbar"]["extraActionButton"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["extraActionButton"]["hotkeyFontSize"] = 15
		E.db["actionbar"]["extraActionButton"]["scale"] = 0.9

		E.db["actionbar"]["zoneActionButton"]["clean"] = true

		E.db["actionbar"]["vehicleExitButton"]["hotkeyFont"] = "Expressway"
		E.db["actionbar"]["vehicleExitButton"]["hotkeyFontSize"] = 15
	end
	--Auras
	do
		E.db["auras"]["buffs"]["barPosition"] = "RIGHT"
		E.db["auras"]["buffs"]["barShow"] = true
		E.db["auras"]["buffs"]["barSize"] = 3
		E.db["auras"]["buffs"]["barSpacing"] = -1
		E.db["auras"]["buffs"]["countFont"] = "Expressway"
		E.db["auras"]["buffs"]["countFontOutline"] = "OUTLINE"
		E.db["auras"]["buffs"]["countFontSize"] = 14
		E.db["auras"]["buffs"]["maxWraps"] = 2
		E.db["auras"]["buffs"]["size"] = 40
		E.db["auras"]["buffs"]["sortDir"] = "+"
		E.db["auras"]["buffs"]["timeFont"] = "Expressway"
		E.db["auras"]["buffs"]["timeFontOutline"] = "OUTLINE"
		E.db["auras"]["buffs"]["timeFontSize"] = 14

		E.db["auras"]["debuffs"]["barPosition"] = "RIGHT"
		E.db["auras"]["debuffs"]["barShow"] = true
		E.db["auras"]["debuffs"]["barSize"] = 3
		E.db["auras"]["debuffs"]["barSpacing"] = -1
		E.db["auras"]["debuffs"]["countFont"] = "Expressway"
		E.db["auras"]["debuffs"]["countFontOutline"] = "NONE"
		E.db["auras"]["debuffs"]["countFontSize"] = 14
		E.db["auras"]["debuffs"]["size"] = 40
		E.db["auras"]["debuffs"]["timeFont"] = "Expressway"
		E.db["auras"]["debuffs"]["timeFontOutline"] = "NONE"
		E.db["auras"]["debuffs"]["timeFontSize"] = 14
		E.db["auras"]["debuffs"]["barColor"]["b"] = 0.15294118225574
		E.db["auras"]["debuffs"]["barColor"]["g"] = 0.062745101749897
		E.db["auras"]["debuffs"]["barColor"]["r"] = 0.94117653369904
	end
	--Bags
	do
		E.db["bags"]["bagSize"] = 31
		E.db["bags"]["bagWidth"] = 553
		E.db["bags"]["bankSize"] = 31
		E.db["bags"]["bankWidth"] = 553
		E.db["bags"]["clearSearchOnClose"] = true
		E.db["bags"]["countFont"] = "Expressway"
		E.db["bags"]["countFontOutline"] = "OUTLINE"
		E.db["bags"]["countFontSize"] = 12
		E.db["bags"]["currencyFormat"] = "ICON"
		E.db["bags"]["itemLevelFont"] = "Expressway"
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
		E.db["bags"]["itemLevelFontSize"] = 12
		E.db["bags"]["junkIcon"] = true
		E.db["bags"]["moneyFormat"] = "BLIZZARD2"
		E.db["bags"]["scrapIcon"] = true
		E.db["bags"]["spinner"]["size"] = 46
		E.db["bags"]["split"]["bag5"] = true
		E.db["bags"]["split"]["player"] = true
		E.db["bags"]["transparent"] = true
		E.db["bags"]["vendorGrays"]["enable"] = true
	end
	--Chat
	do
		E.db["chat"]["copyChatLines"] = true
		E.db["chat"]["emotionIcons"] = false
		E.db["chat"]["fadeChatToggles"] = false
		E.db["chat"]["fontOutline"] = "OUTLINE"

		E.db["chat"]["panelHeight"] = 236
		E.db["chat"]["panelWidth"] = 475

		E.db["chat"]["showHistory"]["EMOTE"] = false
		E.db["chat"]["showHistory"]["SAY"] = false
		E.db["chat"]["showHistory"]["YELL"] = false

		E.db["chat"]["tabFont"] = "Expressway"
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["tabFontSize"] = 10

		E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
		E.db["chat"]["timeStampLocalTime"] = true
	end
	--Databars
	do
		E.db["databars"]["colors"]["quest"]["a"] = 0
		E.db["databars"]["colors"]["quest"]["g"] = 0
		E.db["databars"]["colors"]["rested"]["a"] = 0.40000003576279

		E.db["databars"]["azerite"]["enable"] = false
		E.db["databars"]["azerite"]["textFormat"] = "CURMAX"
		E.db["databars"]["azerite"]["width"] = 547

		E.db["databars"]["experience"]["height"] = 235
		E.db["databars"]["experience"]["orientation"] = "VERTICAL"
		E.db["databars"]["experience"]["showQuestXP"] = false
		E.db["databars"]["experience"]["width"] = 10

		E.db["databars"]["honor"]["showBubbles"] = true
		E.db["databars"]["honor"]["textFormat"] = "CURMAX"
		E.db["databars"]["honor"]["width"] = 546

		E.db["databars"]["reputation"]["enable"] = true
		E.db["databars"]["reputation"]["height"] = 235
		E.db["databars"]["reputation"]["orientation"] = "VERTICAL"
		E.db["databars"]["reputation"]["width"] = 10

		E.db["databars"]["threat"]["enable"] = false
		E.db["databars"]["threat"]["width"] = 262
	end
	--Datatexts
	do
		E.DataTexts:BuildPanelFrame('Darth_Panel_1')

		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["enable"] = true
		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["height"] = 23
		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["name"] = "Darth_Panel_1"
		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["numPoints"] = 8
		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["panelTransparency"] = true
		E.global["datatexts"]["customPanels"]["Darth_Panel_1"]["width"] = 1185

		E.db["datatexts"]["font"] = "Expressway"
		E.db["datatexts"]["fontOutline"] = "OUTLINE"
		E.db["datatexts"]["noCombatClick"] = true
		E.db["datatexts"]["noCombatHover"] = true

		E.db["datatexts"]["panels"]["LeftChatDataPanel"][1] = "S&L Time Played"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"][3] = "S&L Guild"
		E.db["datatexts"]["panels"]["LeftChatDataPanel"]["panelTransparency"] = true

		E.db["datatexts"]["panels"]["MinimapPanel"][1] = "Time"
		E.db["datatexts"]["panels"]["MinimapPanel"][2] = "Combat"
		E.db["datatexts"]["panels"]["MinimapPanel"]["panelTransparency"] = true

		E.db["datatexts"]["panels"]["RightChatDataPanel"][1] = "Mastery"
		E.db["datatexts"]["panels"]["RightChatDataPanel"][2] = "S&L Item Level"
		E.db["datatexts"]["panels"]["RightChatDataPanel"][3] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["RightChatDataPanel"]["panelTransparency"] = true

		E.global["datatexts"]["settings"]["Currencies"]["displayedCurrency"] = "GOLD"
		E.global["datatexts"]["settings"]["Talent/Loot Specialization"]["displayStyle"] = "SPEC"

		E.db['datatexts']['panels']['Darth_Panel_1'] = {
			[1] = 'S&L Friends',
			[2] = 'S&L Currencies',
			[3] = 'Bags',
			[4] = 'System',
			[5] = 'Primary Stat',
			[6] = 'Versatility',
			[7] = 'Crit',
			[8] = 'Haste',
			['enable'] = true,
		}

		E.db['movers']['DTPanelDarth_Panel_1Mover'] = 'BOTTOM,ElvUIParent,BOTTOM,0,0'
		local newPanel = E.DataTexts:FetchFrame('Darth_Panel_1')
		newPanel:SetPoint('CENTER', newPanel.mover, 'CENTER', 0, 0)
	end
	--Nameplates
	do
		E.db["nameplates"]["clampToScreen"] = true
		E.db["nameplates"]["clickThrough"]["personal"] = true
		E.db["nameplates"]["fadeIn"] = false
		E.db["nameplates"]["statusbar"] = "Polished Wood"
		E.db["nameplates"]["threat"]["beingTankedByTank"] = false

		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["size"] = 25
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 35
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["hideTime"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconSize"] = 24
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterrupt"] = false
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["size"] = 22
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 5
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["position"] = "LEFT"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 10
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["yOffset"] = 16
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["height"] = 5
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 10
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = "[name:long]"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["height"] = 6
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["format"] = ""
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["position"] = "BOTTOMLEFT"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["yOffset"] = 10
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["yOffset"] = -5
		E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["yOffset"] = 20
		E.db["nameplates"]["units"]["ENEMY_NPC"]["raidTargetIndicator"]["size"] = 22

		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["maxDuration"] = 0
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["priority"] = "Blacklist,RaidBuffsElvUI,Dispellable,blockNoDuration,PlayerBuffs,TurtleBuffs,CastByUnit"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["size"] = 25
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 35
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["hideTime"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconSize"] = 24
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterrupt"] = false
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["priority"] = "Blacklist,Personal,CCDebuffs"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["size"] = 22
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["yOffset"] = 5
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["height"] = 5
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["format"] = "[difficultycolor][level][shortclassification]"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 10
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = "[name]"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["height"] = 6
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["format"] = ""
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["position"] = "BOTTOMLEFT"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["yOffset"] = 10
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["yOffset"] = -5
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["raidTargetIndicator"]["size"] = 22
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["format"] = "[npctitle]"

		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["size"] = 22
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["height"] = 5
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["fontSize"] = 10
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["height"] = 6
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["yOffset"] = -5

		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["size"] = 22
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["height"] = 5
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["fontSize"] = 12
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["fontSize"] = 10
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["height"] = 6
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["yOffset"] = -5
		E.db["nameplates"]["units"]["TARGET"]["glowStyle"] = "style1"

		E.db["nameplates"]["visibility"]["enemy"]["pets"] = true
		E.db["nameplates"]["visibility"]["enemy"]["totems"] = true
	end
	--Tooltips
	do
		E.db["tooltip"]["font"] = "Expressway"
		E.db["tooltip"]["headerFont"] = "Expressway"
		E.db["tooltip"]["headerFontSize"] = 14
		E.db["tooltip"]["healthBar"]["font"] = "Expressway"
		E.db["tooltip"]["itemCount"] = "NONE"
		E.db["tooltip"]["mythicDataEnable"] = false
		E.db["tooltip"]["showMount"] = false
	end
	--Unitframes
	do
		E.db["unitframe"]["cooldown"]["threshold"] = 4
		E.db["unitframe"]["font"] = "Expressway"
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["fontSize"] = 14
		E.db["unitframe"]["statusbar"] = "Polished Wood"

		E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 30
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["xOffset"] = -23
		E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = 10
		E.db["unitframe"]["units"]["player"]["RestIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["player"]["RestIcon"]["texture"] = "Resting0"
		E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = 3
		E.db["unitframe"]["units"]["player"]["aurabar"]["abbrevName"] = true
		E.db["unitframe"]["units"]["player"]["aurabar"]["attachTo"] = "DETACHED"
		E.db["unitframe"]["units"]["player"]["aurabar"]["clickThrough"] = true
		E.db["unitframe"]["units"]["player"]["aurabar"]["detachedWidth"] = 160
		E.db["unitframe"]["units"]["player"]["aurabar"]["height"] = 13
		E.db["unitframe"]["units"]["player"]["aurabar"]["maxBars"] = 8
		E.db["unitframe"]["units"]["player"]["aurabar"]["maxDuration"] = 600
		E.db["unitframe"]["units"]["player"]["aurabar"]["priority"] = "blockMount,Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal"
		E.db["unitframe"]["units"]["player"]["aurabar"]["sortDirection"] = "ASCENDING"
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 2
		E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["player"]["buffs"]["priority"] = "Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal"
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["iconAttachedTo"] = "Castbar"
		E.db["unitframe"]["units"]["player"]["castbar"]["iconSize"] = 30
		E.db["unitframe"]["units"]["player"]["castbar"]["iconXOffset"] = 0
		E.db["unitframe"]["units"]["player"]["castbar"]["iconYOffset"] = 6
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 250
		E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 180
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 14
		E.db["unitframe"]["units"]["player"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["player"]["healPrediction"]["absorbStyle"] = "NORMAL"
		E.db["unitframe"]["units"]["player"]["health"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = "[healthcolor][health:current:shortvalue]||cffffffff [absorbs:sl-short]||r"
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = -16
		E.db["unitframe"]["units"]["player"]["height"] = 18
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["player"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["player"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["name"]["text_format"] = "[level] [name]"
		E.db["unitframe"]["units"]["player"]["name"]["yOffset"] = 18
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 3.5
		E.db["unitframe"]["units"]["player"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 100
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current:shortvalue]"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = -36
		E.db["unitframe"]["units"]["player"]["pvpIcon"]["yOffset"] = -13
		E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 20
		E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = 20
		E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["resurrectIcon"]["size"] = 40
		E.db["unitframe"]["units"]["player"]["width"] = 180

		E.db["unitframe"]["units"]["target"]["CombatIcon"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["CombatIcon"]["size"] = 30
		E.db["unitframe"]["units"]["target"]["CombatIcon"]["xOffset"] = 12
		E.db["unitframe"]["units"]["target"]["CombatIcon"]["yOffset"] = -8
		E.db["unitframe"]["units"]["target"]["aurabar"]["abbrevName"] = true
		E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "DETACHED"
		E.db["unitframe"]["units"]["target"]["aurabar"]["clickThrough"] = true
		E.db["unitframe"]["units"]["target"]["aurabar"]["detachedWidth"] = 160
		E.db["unitframe"]["units"]["target"]["aurabar"]["height"] = 13
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxBars"] = 8
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxDuration"] = 600
		E.db["unitframe"]["units"]["target"]["aurabar"]["priority"] = "blockMount,blockNonPersonal,Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist"
		E.db["unitframe"]["units"]["target"]["aurabar"]["sortDirection"] = "ASCENDING"
		E.db["unitframe"]["units"]["target"]["aurabar"]["spacing"] = 2
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "DEBUFFS"
		E.db["unitframe"]["units"]["target"]["buffs"]["growthX"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Blacklist,Whitelist,blockNoDuration,Personal,PlayerBuffs,nonPersonal"
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["iconAttachedTo"] = "Castbar"
		E.db["unitframe"]["units"]["target"]["castbar"]["iconSize"] = 30
		E.db["unitframe"]["units"]["target"]["castbar"]["iconXOffset"] = 0
		E.db["unitframe"]["units"]["target"]["castbar"]["iconYOffset"] = 6
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 250
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPLEFT"
		E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["target"]["debuffs"]["growthX"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Personal,nonPersonal"
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 14
		E.db["unitframe"]["units"]["target"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["target"]["healPrediction"]["absorbStyle"] = "NORMAL"
		E.db["unitframe"]["units"]["target"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = "[healthcolor][health:current:shortvalue]||cffffffff [absorbs:sl-short]||r"
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = -16
		E.db["unitframe"]["units"]["target"]["height"] = 18
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["target"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = "[level][shortclassification] [name:medium]"
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 18
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 3.5
		E.db["unitframe"]["units"]["target"]["portrait"]["fullOverlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlayAlpha"] = 1
		E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 100
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = -10
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = 36
		E.db["unitframe"]["units"]["target"]["pvpIcon"]["yOffset"] = -13
		E.db["unitframe"]["units"]["target"]["raidicon"]["attachTo"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 20
		E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["resurrectIcon"]["size"] = 40
		E.db["unitframe"]["units"]["target"]["width"] = 180

		E.db["unitframe"]["units"]["targettarget"]["buffs"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["targettarget"]["buffs"]["attachTo"] = "DEBUFFS"
		E.db["unitframe"]["units"]["targettarget"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["buffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["targettarget"]["buffs"]["priority"] = "Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal"
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["sortMethod"] = "PLAYER"
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["xOffset"] = 100
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["yOffset"] = -19
		E.db["unitframe"]["units"]["targettarget"]["disableMouseoverGlow"] = true
		E.db["unitframe"]["units"]["targettarget"]["height"] = 18
		E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = 14
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = -19
		E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["targettarget"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["targettarget"]["width"] = 100

		E.db["unitframe"]["units"]["pet"]["castbar"]["iconSize"] = 32
		E.db["unitframe"]["units"]["pet"]["castbar"]["overlayOnFrame"] = "Power"
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["pet"]["disableTargetGlow"] = false
		E.db["unitframe"]["units"]["pet"]["height"] = 16
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[name]"
		E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = 14
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["pet"]["width"] = 100

		E.db["unitframe"]["units"]["focus"]["buffs"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["focus"]["buffs"]["attachTo"] = "DEBUFFS"
		E.db["unitframe"]["units"]["focus"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["buffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["focus"]["buffs"]["priority"] = "Blacklist,blockNoDuration,Personal,PlayerBuffs,CastByUnit,Dispellable,RaidBuffsElvUI"
		E.db["unitframe"]["units"]["focus"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 160
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["perrow"] = 7
		E.db["unitframe"]["units"]["focus"]["debuffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["focus"]["debuffs"]["xOffset"] = -4
		E.db["unitframe"]["units"]["focus"]["height"] = 18
		E.db["unitframe"]["units"]["focus"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["raidicon"]["size"] = 20
		E.db["unitframe"]["units"]["focus"]["raidicon"]["xOffset"] = -20
		E.db["unitframe"]["units"]["focus"]["width"] = 160

		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.15294117647059
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.74901960784314
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.23529411764706
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.28235294117647
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.58823529411765
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.6078431372549
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["customhealthbackdrop"] = true
		E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["class"] = true
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["a"] = 0.61000001430511
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["b"] = 0.5921568627451
		E.db["unitframe"]["colors"]["healPrediction"]["absorbs"]["r"] = 0.95686274509804
		E.db["unitframe"]["colors"]["healPrediction"]["overabsorbs"]["a"] = 0.61073982715607
		E.db["unitframe"]["colors"]["healPrediction"]["overabsorbs"]["b"] = 1
		E.db["unitframe"]["colors"]["healPrediction"]["overhealabsorbs"]["a"] = 0.61000001430511
		E.db["unitframe"]["colors"]["health_backdrop"]["b"] = 0.21960784313725
		E.db["unitframe"]["colors"]["health_backdrop"]["g"] = 0.21960784313725
		E.db["unitframe"]["colors"]["health_backdrop"]["r"] = 0.21960784313725
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["transparentAurabars"] = true

		E.db["unitframe"]["units"]["assist"]["enable"] = false
		E.db["unitframe"]["units"]["tank"]["enable"] = false

		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["party"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[healthcolor][perhp]"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 4
		E.db["unitframe"]["units"]["party"]["height"] = 30
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = -3
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[difficultycolor][smartlevel] [classcolor][name:medium]"
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 22
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["xOffset"] = -49
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 6
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 5
		E.db["unitframe"]["units"]["party"]["width"] = 160
		E.db["unitframe"]["units"]["party"]["classbar"]["enable"] = false

		E.db["unitframe"]["units"]["raid1"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid1"]["health"]["position"] = "TOP"
		E.db["unitframe"]["units"]["raid1"]["health"]["text_format"] = "[perhp]"
		E.db["unitframe"]["units"]["raid1"]["health"]["xOffset"] = 14
		E.db["unitframe"]["units"]["raid1"]["height"] = 30
		E.db["unitframe"]["units"]["raid1"]["name"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["raid1"]["name"]["text_format"] = "[classcolor][name:veryshort]"
		E.db["unitframe"]["units"]["raid1"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid1"]["numGroups"] = 8
		E.db["unitframe"]["units"]["raid1"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid1"]["raidicon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["raid1"]["raidicon"]["size"] = 12
		E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["size"] = 22
		E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["xOffset"] = -24
		E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["yOffset"] = 5
		E.db["unitframe"]["units"]["raid1"]["resurrectIcon"]["attachTo"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["raid1"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid1"]["roleIcon"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["raid1"]["roleIcon"]["size"] = 14
		E.db["unitframe"]["units"]["raid1"]["roleIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid1"]["roleIcon"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid1"]["verticalSpacing"] = 4
		E.db["unitframe"]["units"]["raid1"]["visibility"] = "[@raid6,noexists] hide;show"
		E.db["unitframe"]["units"]["raid1"]["width"] = 90

		E.db["unitframe"]["units"]["raid2"]["enable"] = false

		E.db["unitframe"]["units"]["raid3"]["enable"] = false

		E.db["unitframe"]["units"]["arena"]["health"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["arena"]["health"]["text_format"] = " [absorbs:sl-short] [healthcolor][health:current:shortvalue]"
		E.db["unitframe"]["units"]["arena"]["health"]["xOffset"] = -2
		E.db["unitframe"]["units"]["arena"]["height"] = 40
		E.db["unitframe"]["units"]["arena"]["name"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["arena"]["name"]["text_format"] = "[faction:icon][classcolor][name:medium]"
		E.db["unitframe"]["units"]["arena"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["arena"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["arena"]["width"] = 180

		E.db["unitframe"]["units"]["boss"]["buffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["buffs"]["priority"] = "Blacklist,TurtleBuffs,PlayerBuffs,Dispellable"
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 256
		E.db["unitframe"]["units"]["boss"]["debuffs"]["desaturate"] = false
		E.db["unitframe"]["units"]["boss"]["debuffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["debuffs"]["priority"] = "Blacklist,blockNoDuration,Personal,CCDebuffs,Whitelist"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = -16
		E.db["unitframe"]["units"]["boss"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["health"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = " [absorbs:sl-short] [healthcolor][health:current:shortvalue]"
		E.db["unitframe"]["units"]["boss"]["health"]["xOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["height"] = 40
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 17
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[powercolor][curpp]"
		E.db["unitframe"]["units"]["boss"]["width"] = 180
	end
	--S&L
	do
		E.db["sle"]["afk"]["enable"] = true

		E.db["sle"]["armory"]["character"]["enable"] = true
		E.db["sle"]["armory"]["character"]["gradient"]["quality"] = true
		E.db["sle"]["armory"]["inspect"]["enable"] = true
		E.db["sle"]["armory"]["inspect"]["gradient"]["quality"] = true
		E.db["sle"]["armory"]["stats"]["itemLevel"]["AverageGradient"] = true
		E.db["sle"]["armory"]["stats"]["List"]["ATTACK_AP"] = true

		E.db["sle"]["blizzard"]["rumouseover"] = true

		E.db["sle"]["chat"]["dpsSpam"] = true
		E.db["sle"]["chat"]["guildmaster"] = true

		E.db["sle"]["databars"]["experience"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["experience"]["chatfilter"]["style"] = "STYLE2"
		E.db["sle"]["databars"]["reputation"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["reputation"]["chatfilter"]["style"] = "STYLE2"

		E.db["sle"]["dt"]["currency"]["Archaeology"] = false
		E.db["sle"]["dt"]["currency"]["Unused"] = false
		E.db["sle"]["dt"]["currency"]["gold"]["method"] = "amount"
		E.db["sle"]["dt"]["friends"]["hideBSAp"] = true
		E.db["sle"]["dt"]["friends"]["hideLAZR"] = true
		E.db["sle"]["dt"]["friends"]["hideODIN"] = true
		E.db["sle"]["dt"]["friends"]["hideVIPR"] = true
		E.db["sle"]["dt"]["friends"]["hide_titleline"] = true
		E.db["sle"]["dt"]["friends"]["panelStyle"] = "DEFAULTTOTALS"
		E.db["sle"]["dt"]["guild"]["hide_titleline"] = true
		E.db["sle"]["dt"]["guild"]["totals"] = true

		E.db["sle"]["loot"]["autoroll"]["autogreed"] = true
		E.db["sle"]["loot"]["enable"] = true
		E.db["sle"]["loot"]["history"]["autohide"] = true

		E.db["sle"]["minimap"]["instance"]["enable"] = true
		E.db["sle"]["minimap"]["instance"]["fontSize"] = 14
		E.db["sle"]["minimap"]["locPanel"]["enable"] = true
		E.db["sle"]["minimap"]["locPanel"]["font"] = "Expressway"
		E.db["sle"]["minimap"]["locPanel"]["fontSize"] = 14
		E.db["sle"]["minimap"]["locPanel"]["width"] = 310

		E.db["sle"]["nameplates"]["targetcount"]["enable"] = true
		E.db["sle"]["nameplates"]["targetcount"]["font"] = "Expressway"
		E.db["sle"]["nameplates"]["threat"]["enable"] = true
		E.db["sle"]["nameplates"]["threat"]["font"] = "Expressway"
		E.db["sle"]["nameplates"]["threat"]["size"] = 10

		E.db["sle"]["pvp"]["autorelease"] = true
		E.db["sle"]["pvp"]["duels"]["pet"] = true
		E.db["sle"]["pvp"]["duels"]["regular"] = true

		E.db["sle"]["quests"]["autoReward"] = true

		E.db["sle"]["tooltip"]["alwaysCompareItems"] = true
		E.db["sle"]["tooltip"]["showFaction"] = true

		E.db["sle"]["uibuttons"]["anchor"] = "TOPLEFT"
		E.db["sle"]["uibuttons"]["enable"] = true
		E.db["sle"]["uibuttons"]["point"] = "TOPRIGHT"
		E.db["sle"]["uibuttons"]["spacing"] = 1

		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["anchorPoint"] = "LEFT"
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["enable"] = true
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["font"] = "Expressway"
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["fontOutline"] = "OUTLINE"
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["fontSize"] = 14
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["xOffset"] = 0
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["level"]["yOffset"] = 0
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["timer"]["enable"] = true
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["timer"]["font"] = "Expressway"
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["timer"]["fontOutline"] = "OUTLINE"
		E.db["sle"]["unitframe"]["units"]["player"]["pvpicontext"]["timer"]["fontSize"] = 14
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["anchorPoint"] = "RIGHT"
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["enable"] = true
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["font"] = "Expressway"
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["fontOutline"] = "OUTLINE"
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["fontSize"] = 14
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["xOffset"] = 4
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["level"]["yOffset"] = 0
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["timer"]["enable"] = true
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["timer"]["font"] = "Expressway"
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["timer"]["fontOutline"] = "OUTLINE"
		E.db["sle"]["unitframe"]["units"]["target"]["pvpicontext"]["timer"]["fontSize"] = 14

		E.db["sle"]["unitframes"]["roleIcons"]["enable"] = true
		E.db["sle"]["unitframes"]["roleIcons"]["icons"] = "SupervillainUI"
	end
	--Movers
	do
		E.db["movers"]["AddonCompartmentMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-4,-247"
		E.db["movers"]["AlertFrameMover"] = "TOPLEFT,UIParent,TOPLEFT,367,-141"
		E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,340"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-49,-301"
		E.db["movers"]["AzeriteBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,153"
		E.db["movers"]["BNETMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-249,-175"
		E.db["movers"]["BelowMinimapContainerMover"] = "TOP,ElvUIParent,TOP,0,-117"
		E.db["movers"]["BossBannerMover"] = "TOP,ElvUIParent,TOP,0,-146"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,386"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-49,-300"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-239,-3"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,494"
		E.db["movers"]["DTPanelDarth_Panel_1Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,0"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-239,-116"
		E.db["movers"]["DurabilityFrameMover"] = "BOTTOM,UIParent,BOTTOM,-332,265"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,230"
		E.db["movers"]["ElvAB_10"] = "BOTTOM,ElvUI_Bar1,TOP,0,202"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["ElvAB_3"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,474,23"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-475,23"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,203,230"
		E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvUIParent,BOTTOM,-202,230"
		E.db["movers"]["ElvAB_7"] = "BOTTOM,ElvUI_Bar1,TOP,0,82"
		E.db["movers"]["ElvAB_8"] = "BOTTOM,ElvUI_Bar1,TOP,0,122"
		E.db["movers"]["ElvAB_9"] = "BOTTOM,ElvUI_Bar1,TOP,0,162"
		E.db["movers"]["ElvNP_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,503"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,526,-238"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,438"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,UIParent,BOTTOM,-347,414"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,265"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "TOPLEFT,ElvUF_Pet,BOTTOMLEFT,0,-1"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-186,415"
		E.db["movers"]["ElvUF_PlayerAuraMover"] = "BOTTOM,ElvUIParent,BOTTOM,-216,540"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,455"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-226,459"
		E.db["movers"]["ElvUF_Raid1Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,265"
		E.db["movers"]["ElvUF_Raid2Mover"] = "TOPLEFT,UIParent,TOPLEFT,497,-327"
		E.db["movers"]["ElvUF_Raid3Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,482"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,737"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,518,-316"
		E.db["movers"]["ElvUF_TargetAuraMover"] = "BOTTOM,ElvUIParent,BOTTOM,216,540"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,474"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,226,459"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,186,415"
		E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,257"
		E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,257"
		E.db["movers"]["EventToastMover"] = "TOP,ElvUIParent,TOP,0,-165"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,552,23"
		E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,368,0"
		E.db["movers"]["HonorBarMover"] = "BOTTOM,UIParent,BOTTOM,1,220"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,0"
		E.db["movers"]["LevelUpBossBannerMover"] = "TOP,ElvUIParent,TOP,0,-217"
		E.db["movers"]["LootFrameMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-531,-449"
		E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,505"
		E.db["movers"]["MawBuffsBelowMinimapMover"] = "TOP,Minimap,BOTTOM,0,-26"
		E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-3"
		E.db["movers"]["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-289"
		E.db["movers"]["MirrorTimer2Mover"] = "TOP,MirrorTimer1,BOTTOM,0,0"
		E.db["movers"]["MirrorTimer3Mover"] = "TOP,MirrorTimer2,BOTTOM,0,0"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,94,-10"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,319"
		E.db["movers"]["PetBattleABMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["PetBattleStatusMover"] = "TOP,PetBattleFrame,TOP,0,0"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-301,431"
		E.db["movers"]["PowerBarContainerMover"] = "TOP,ElvUIParent,TOP,0,-96"
		E.db["movers"]["PrivateAurasMover"] = "TOPRIGHT,ElvUI_MinimapHolder,BOTTOMLEFT,-10,-3"
		E.db["movers"]["PrivateRaidWarningMover"] = "TOP,RaidBossEmoteFrame,TOP,0,0"
		E.db["movers"]["QueueStatusMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-22,-246"
		E.db["movers"]["RaidMarkerBarAnchor"] = "BOTTOM,ElvUIParent,BOTTOM,0,361"
		E.db["movers"]["RaidUtility_Mover"] = "TOP,ElvUIParent,TOP,-400,1"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-553,23"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,-1"
		E.db["movers"]["SLE_BG_1_Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,21"
		E.db["movers"]["SLE_BG_2_Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOM,-257,21"
		E.db["movers"]["SLE_BG_3_Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOM,257,21"
		E.db["movers"]["SLE_BG_4_Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,189"
		E.db["movers"]["SLE_FarmPortalMover"] = "BOTTOMLEFT,SLE_ToolsToolbarsAnchor,TOPLEFT,0,1"
		E.db["movers"]["SLE_FarmSeedMover"] = "LEFT,ElvUIParent,LEFT,24,-160"
		E.db["movers"]["SLE_FarmToolMover"] = "BOTTOMLEFT,SLE_SeedToolbarsAnchor,TOPLEFT,0,1"
		E.db["movers"]["SLE_GarrisonToolMover"] = "LEFT,ElvUIParent,LEFT,24,0"
		E.db["movers"]["SLE_Location_Mover"] = "TOP,ElvUIParent,TOP,0,0"
		E.db["movers"]["SLE_UIButtonsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-227,-174"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,-212,334"
		E.db["movers"]["SocialMenuMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-187"
		E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-20"
		E.db["movers"]["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,258"
		E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-74"
		E.db["movers"]["TorghastChoiceToggle"] = "BOTTOM,ElvUIParent,BOTTOM,0,166"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,267"
		E.db["movers"]["TotemTrackerMover"] = "BOTTOM,UIParent,BOTTOM,-197,368"
		E.db["movers"]["UIErrorsFrameMover"] = "TOP,ElvUIParent,TOP,0,-177"
		E.db["movers"]["VOICECHAT"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,586,27"
		E.db["movers"]["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,148,334"
		E.db["movers"]["VehicleSeatMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,575,253"
		E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,386"
	end

	if C_AddOns_IsAddOnLoaded('AddOnSkins') then
		local AS = unpack(_G['AddOnSkins']) or nil
		if AS then
			AS.db['Blizzard_AbilityButton'] = true
			AS.db['EmbedRight'] = 'Details'
			AS.db['EmbedLeft'] = 'Details'
			AS.db['Blizzard_ExtraActionButton'] = true
			AS.db['ElvUIStyle'] = false
			AS.db['BackgroundTexture'] = 'ElvUI Gloss'
			AS.db['EmbedOoC'] = true
			AS.db['EmbedSystemDual'] = true
			AS.db['EmbedOoCDelay'] = 3
		end
	end

	E.private['general']['normTex'] = 'ElvUI Gloss'
	E.private['general']['glossTex'] = 'ElvUI Gloss'
	E.private["general"]["raidUtility"] = false

	E.private["skins"]["blizzard"]["achievement"] = false
	E.private["skins"]["blizzard"]["alertframes"] = false

	E.db['sle']['afk']['enable'] = true

	E.private['sle']['uibuttons']['style'] = 'dropdown'

	E.private["sle"]["professions"]["deconButton"]["style"] = "SMALL"

	E.private['sle']['skins']['merchant']['enable'] = true
	E.private['sle']['skins']['merchant']['style'] = 'List'

	E.private['sle']['skins']['objectiveTracker']['scenarioBG'] = true
	E.private['sle']['skins']['objectiveTracker']['color']['b'] = 0.15294117647059
	E.private['sle']['skins']['objectiveTracker']['color']['g'] = 0.74901960784314
	E.private['sle']['skins']['objectiveTracker']['color']['r'] = 0.23529411764706

	E.private['sle']['pvp']['KBbanner']['enable'] = true

	E.global['general']['fadeMapWhenMoving'] = false
	E.global["general"]["WorldMapCoordinates"]["position"] = "BOTTOMRIGHT"
	E.global['general']['commandBarSetting'] = 'DISABLED'
	E.global["datatexts"]["settings"]["Currencies"]["displayedCurrency"] = "GOLD"
	E.global["datatexts"]["settings"]["Talent/Loot Specialization"]["displayStyle"] = "SPEC"
	E.global['sle']['advanced']['optionsLimits'] = true

	if layout then
		if layout == 'tank' then
			E.db['nameplates']['threat']['beingTankedByTank'] = true

			E.db['sle']['armory']['stats']['List']['SPELLPOWER'] = false
			E.db['sle']['armory']['stats']['List']['ATTACK_DAMAGE'] = true
			E.db['sle']['armory']['stats']['List']['ATTACK_AP'] = true
			E.db['sle']['armory']['stats']['List']['ATTACK_ATTACKSPEED'] = true
			E.db['sle']['armory']['stats']['List']['ENERGY_REGEN'] = true
			E.db['sle']['armory']['stats']['List']['RUNE_REGEN'] = true
			E.db['sle']['armory']['stats']['List']['FOCUS_REGEN'] = true
		elseif layout == 'healer' then
			E.db['unitframe']['units']['party']['healPrediction']['enable'] = true
			E.db['unitframe']['units']['raid1']['healPrediction']['enable'] = true

			E.db["movers"]["ElvUF_Raid1Mover"] = "TOPLEFT,UIParent,TOPLEFT,302,-393"
			E.db["movers"]["ElvUF_PartyMover"] = "TOPLEFT,UIParent,TOPLEFT,605,-500"
		end
		E.db.layoutSet = layout
	else
		E.db.layoutSet = 'dpsCaster'
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:StaggeredUpdateAll(nil, true)

	_G["PluginInstallStepComplete"].message = L["Darth's Default Set"]..": "..(PI.SLE_Word == NONE and L["Caster DPS"] or PI.SLE_Word)
	_G["PluginInstallStepComplete"]:Show()
end

function PI:DarthSetupSL()
	local layout = E.db.layoutSet
	local installMark = E.private['install_complete']
	local installMarkSLE = E.private['sle']['install_complete']

	wipe(E.db)
	E:CopyTable(E.db, P)

	wipe(E.private)
	E:CopyTable(E.private, V)

	E:ResetMovers('')
	if not E.db['movers'] then E.db['movers'] = {} end

	--General
	do
		E.db['general']['totems']['size'] = 42
		E.db['general']['totems']['growthDirection'] = 'HORIZONTAL'
		E.db['general']['totems']['spacing'] = 1

		E.db['general']['stickyFrames'] = false
		E.db['general']['talkingHeadFrameScale'] = 1
		E.db['general']['bottomPanel'] = false

		E.db['general']['bordercolor']['r'] = 0
		E.db['general']['bordercolor']['g'] = 0
		E.db['general']['bordercolor']['b'] = 0

		E.db['general']['autoRepair'] = 'PLAYER'

		E.db['general']['minimap']['size'] = 220
		E.db['general']['minimap']['locationText'] = 'HIDE'

		E.db['general']['decimalLength'] = 2

		E.db['general']['valuecolor']['b'] = 0.15294117647059
		E.db['general']['valuecolor']['g'] = 0.74901960784314
		E.db['general']['valuecolor']['r'] = 0.23529411764706

		E.db['general']['backdropfadecolor']['r'] = 0.054
		E.db['general']['backdropfadecolor']['g'] = 0.054
		E.db['general']['backdropfadecolor']['b'] = 0.054

		E.db['general']['objectiveFrameHeight'] = 500
		E.db['general']['bonusObjectivePosition'] = 'AUTO'

		E.db['general']['vehicleSeatIndicatorSize'] = 112

		E.db['general']['altPowerBar']['statusBar'] = 'WorldState Score'
	end
	--Actionbars
	do
		E.db['actionbar']['font'] = 'PT Sans Narrow'
		E.db['actionbar']['fontSize'] = 12
		E.db['actionbar']['fontOutline'] = 'OUTLINE'
		E.db['actionbar']['chargeCooldown'] = true
		E.db['actionbar']['desaturateOnCooldown'] = true
		E.db['actionbar']['transparent'] = true
		E.db['actionbar']['useDrawSwipeOnCharges'] = true

		E.db['actionbar']['bar1']['point'] = 'TOPLEFT'
		E.db['actionbar']['bar1']['buttonsPerRow'] = 6
		E.db['actionbar']['bar1']['buttonSize'] = 44
		E.db['actionbar']['bar1']['buttonSpacing'] = -1

		E.db['actionbar']['bar2']['enabled'] = true
		E.db['actionbar']['bar2']['point'] = 'TOPLEFT'
		E.db['actionbar']['bar2']['buttonSize'] = 36
		E.db['actionbar']['bar2']['buttonSpacing'] = -1
		E.db['actionbar']['bar2']['buttonsPerRow'] = 4
		E.db['actionbar']['bar2']['visibility'] = '[petbattle] hide; show'

		E.db['actionbar']['bar3']['buttonSize'] = 36
		E.db['actionbar']['bar3']['point'] = 'TOPLEFT'
		E.db['actionbar']['bar3']['buttons'] = 12
		E.db['actionbar']['bar3']['buttonSpacing'] = -1
		E.db['actionbar']['bar3']['buttonsPerRow'] = 4
		E.db['actionbar']['bar3']['visibility'] = '[petbattle] hide; show'

		E.db['actionbar']['bar4']['buttonSize'] = 38
		E.db['actionbar']['bar4']['point'] = 'TOPLEFT'
		E.db['actionbar']['bar4']['buttonSpacing'] = -1
		E.db['actionbar']['bar4']['buttonsPerRow'] = 2
		E.db['actionbar']['bar4']['visibility'] = '[petbattle] hide; show'
		E.db['actionbar']['bar4']['backdrop'] = false

		E.db['actionbar']['bar5']['buttonSize'] = 38
		E.db['actionbar']['bar5']['point'] = 'TOPLEFT'
		E.db['actionbar']['bar5']['buttons'] = 12
		E.db['actionbar']['bar5']['buttonSpacing'] = -1
		E.db['actionbar']['bar5']['buttonsPerRow'] = 2
		E.db['actionbar']['bar5']['visibility'] = '[petbattle] hide; show'

		E.db['actionbar']['bar6']['visibility'] = '[petbattle] hide; show'

		E.db['actionbar']['stanceBar']['style'] = 'classic'
		E.db['actionbar']['stanceBar']['buttonSize'] = 24

		E.db['actionbar']['barPet']['point'] = 'TOPLEFT'
		E.db['actionbar']['barPet']['buttonSpacing'] = -1
		E.db['actionbar']['barPet']['buttonsPerRow'] = 5
		E.db['actionbar']['barPet']['backdrop'] = false
		E.db['actionbar']['barPet']['buttonSize'] = 20
	end
	--Auras
	do
		E.db['auras']['buffs']['sortDir'] = '+'
		E.db['auras']['buffs']['durationFontSize'] = 14
		E.db['auras']['buffs']['horizontalSpacing'] = 3
		E.db['auras']['buffs']['maxWraps'] = 2
		E.db['auras']['buffs']['countFont'] = 'PT Sans Narrow'
		E.db['auras']['buffs']['countFontOutline'] = 'OUTLINE'
		E.db['auras']['buffs']['countFontSize'] = 12
		E.db['auras']['buffs']['size'] = 40

		E.db['auras']['debuffs']['countFont'] = 'PT Sans Narrow'
		E.db['auras']['debuffs']['countFontOutline'] = 'OUTLINE'
		E.db['auras']['debuffs']['countFontSize'] = 12
		E.db['auras']['debuffs']['horizontalSpacing'] = 3
		E.db['auras']['debuffs']['durationFontSize'] = 14
		E.db['auras']['debuffs']['size'] = 40
	end
	--Bags
	do
		E.db['bags']['countFont'] = 'Expressway'
		E.db['bags']['countFontSize'] = 12
		E.db['bags']['countFontOutline'] = 'OUTLINE'
		E.db['bags']['itemLevelFont'] = 'Expressway'
		E.db['bags']['itemLevelFontSize'] = 12
		E.db['bags']['itemLevelFontOutline'] = 'OUTLINE'

		E.db['bags']['transparent'] = true
		E.db['bags']['bagWidth'] = 474
		E.db['bags']['bankWidth'] = 474
		E.db['bags']['bagSize'] = 32
		E.db['bags']['bankSize'] = 32

		E.db['bags']['vendorGrays']['enable'] = true
		E.db['bags']['clearSearchOnClose'] = true
		E.db['bags']['scrapIcon'] = true
		E.db['bags']['junkIcon'] = true
		E.db['bags']['qualityColors'] = true

		E.db['bags']['currencyFormat'] = 'ICON'
		E.db['bags']['moneyFormat'] = 'BLIZZARD2'
	end
	--Chat
	do
		E.db['chat']['copyChatLines'] = true
		E.db['chat']['fadeChatToggles'] = false
		E.db['chat']['emotionIcons'] = false

		E.db['chat']['timeStampFormat'] = '%H:%M:%S '

		E.db['chat']['panelWidth'] = 475
		E.db['chat']['panelHeight'] = 227
		E.db['chat']['tabFontOutline'] = 'OUTLINE'
		E.db['chat']['fontOutline'] = 'OUTLINE'

		E.db['chat']['showHistory']['EMOTE'] = false
		E.db['chat']['showHistory']['YELL'] = false
		E.db['chat']['showHistory']['SAY'] = false

		E.db['chat']['hideVoiceButtons'] = true
	end
	--Databars
	do
		E.db['databars']['colors']['quest']['a'] = 0.40000003576279
		E.db['databars']['colors']['quest']['g'] = 0

		E.db['databars']['reputation']['enable'] = true
		E.db['databars']['reputation']['height'] = 227
		E.db['databars']['reputation']['width'] = 10
		E.db['databars']['reputation']['orientation'] = 'VERTICAL'

		E.db['databars']['azerite']['textFormat'] = 'CURMAX'
		E.db['databars']['azerite']['textSize'] = 10
		E.db['databars']['azerite']['width'] = 547

		E.db['databars']['experience']['height'] = 227
		E.db['databars']['experience']['width'] = 10
		E.db['databars']['experience']['orientation'] = 'VERTICAL'

		E.db['databars']['honor']['textFormat'] = 'CURMAX'
		E.db['databars']['honor']['textSize'] = 10
		E.db['databars']['honor']['width'] = 547

		E.db['databars']['threat']['width'] = 262
	end
	--Datatexts
	do
		E.DataTexts:BuildPanelFrame('Darth_Panel_1')

		E.global['datatexts']['customPanels']['Darth_Panel_1']['panelTransparency'] = true
		E.global['datatexts']['customPanels']['Darth_Panel_1']['border'] = true
		E.global['datatexts']['customPanels']['Darth_Panel_1']['tooltipYOffset'] = 4
		E.global['datatexts']['customPanels']['Darth_Panel_1']['numPoints'] = 8
		E.global['datatexts']['customPanels']['Darth_Panel_1']['tooltipAnchor'] = 'ANCHOR_TOPLEFT'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['frameLevel'] = 1
		E.global['datatexts']['customPanels']['Darth_Panel_1']['enable'] = true
		E.global['datatexts']['customPanels']['Darth_Panel_1']['frameStrata'] = 'LOW'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['width'] = 1184
		E.global['datatexts']['customPanels']['Darth_Panel_1']['fonts']['enable'] = false
		E.global['datatexts']['customPanels']['Darth_Panel_1']['fonts']['font'] = 'PT Sans Narrow'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['fonts']['fontSize'] = 12
		E.global['datatexts']['customPanels']['Darth_Panel_1']['fonts']['fontOutline'] = 'OUTLINE'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['backdrop'] = true
		E.global['datatexts']['customPanels']['Darth_Panel_1']['name'] = 'Darth_Panel_1'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['mouseover'] = false
		E.global['datatexts']['customPanels']['Darth_Panel_1']['height'] = 24
		E.global['datatexts']['customPanels']['Darth_Panel_1']['tooltipXOffset'] = -17
		E.global['datatexts']['customPanels']['Darth_Panel_1']['visibility'] = '[petbattle] hide;show'
		E.global['datatexts']['customPanels']['Darth_Panel_1']['growth'] = 'HORIZONTAL'

		E.db['datatexts']['noCombatClick'] = true
		E.db['datatexts']['noCombatHover'] = true
		E.db['datatexts']['fontOutline'] = 'OUTLINE'
		E.global['datatexts']['settings']['Currencies']['displayedCurrency'] = 'GOLD'

		E.db['datatexts']['panels']['MinimapPanel'][1] = 'Time'
		E.db['datatexts']['panels']['MinimapPanel'][2] = 'Combat'
		E.db['datatexts']['panels']['MinimapPanel']['panelTransparency'] = true

		E.db['datatexts']['panels']['RightChatDataPanel'][1] = 'Mastery'
		E.db['datatexts']['panels']['RightChatDataPanel'][2] = 'S&L Item Level'
		E.db['datatexts']['panels']['RightChatDataPanel'][3] = 'Talent/Loot Specialization'
		E.db['datatexts']['panels']['RightChatDataPanel']['panelTransparency'] = true

		E.db['datatexts']['panels']['LeftChatDataPanel'][1] = 'S&L Time Played'
		E.db['datatexts']['panels']['LeftChatDataPanel'][3] = 'S&L Guild'
		E.db['datatexts']['panels']['LeftChatDataPanel']['panelTransparency'] = true

		E.db['datatexts']['panels']['Darth_Panel_1'] = {
			[1] = 'S&L Friends',
			[2] = 'S&L Currencies',
			[3] = 'Bags',
			[4] = 'System',
			[5] = 'Primary Stat',
			[6] = 'Versatility',
			[7] = 'Crit',
			[8] = 'Haste',
			['enable'] = true,
		}

		E.db['movers']['DTPanelDarth_Panel_1Mover'] = 'BOTTOM,ElvUIParent,BOTTOM,0,0'
		local newPanel = E.DataTexts:FetchFrame('Darth_Panel_1')
		newPanel:SetPoint('CENTER', newPanel.mover, 'CENTER', 0, 0)
	end
	--Nameplates
	do
		E.db['v11NamePlateReset'] = true

		E.db['nameplates']['threat']['beingTankedByTank'] = false
		E.db['nameplates']['statusbar'] = 'Polished Wood'
		E.db['nameplates']['clickThrough']['personal'] = true
		E.db['nameplates']['clampToScreen'] = true
		E.db['nameplates']['visibility']['enemy']['pets'] = true
		E.db['nameplates']['visibility']['enemy']['totems'] = true
		E.db['nameplates']['fadeIn'] = false

		E.db['nameplates']['units']['PLAYER']['enable'] = false

		E.db['nameplates']['units']['TARGET']['glowStyle'] = 'style1'

		E.db['nameplates']['units']['ENEMY_NPC']['name']['format'] = '[name:long]'
		E.db['nameplates']['units']['ENEMY_NPC']['debuffs']['numAuras'] = 6
		E.db['nameplates']['units']['ENEMY_NPC']['debuffs']['size'] = 25
		E.db['nameplates']['units']['ENEMY_NPC']['debuffs']['yOffset'] = 5
		E.db['nameplates']['units']['ENEMY_NPC']['castbar']['iconSize'] = 24
		E.db['nameplates']['units']['ENEMY_NPC']['castbar']['hideTime'] = true
		E.db['nameplates']['units']['ENEMY_NPC']['castbar']['sourceInterrupt'] = false
		E.db['nameplates']['units']['ENEMY_NPC']['questIcon']['yOffset'] = 20
		E.db['nameplates']['units']['ENEMY_NPC']['raidTargetIndicator']['size'] = 22
		E.db['nameplates']['units']['ENEMY_NPC']['eliteIcon']['enable'] = true
		E.db['nameplates']['units']['ENEMY_NPC']['eliteIcon']['xOffset'] = 10
		E.db['nameplates']['units']['ENEMY_NPC']['eliteIcon']['yOffset'] = 16
		E.db['nameplates']['units']['ENEMY_NPC']['eliteIcon']['position'] = 'LEFT'
		E.db['nameplates']['units']['ENEMY_NPC']['buffs']['numAuras'] = 6
		E.db['nameplates']['units']['ENEMY_NPC']['buffs']['size'] = 25
		E.db['nameplates']['units']['ENEMY_NPC']['buffs']['yOffset'] = 35
		E.db['nameplates']['units']['ENEMY_NPC']['power']['enable'] = true
		E.db['nameplates']['units']['ENEMY_NPC']['power']['text']['enable'] = true
		E.db['nameplates']['units']['ENEMY_NPC']['power']['text']['fontSize'] = 12
		E.db['nameplates']['units']['ENEMY_NPC']['power']['text']['position'] = 'BOTTOMLEFT'
		E.db['nameplates']['units']['ENEMY_NPC']['power']['text']['yOffset'] = 10
		E.db['nameplates']['units']['ENEMY_NPC']['health']['text']['fontSize'] = 12

		E.db['nameplates']['units']['ENEMY_PLAYER']['debuffs']['numAuras'] = 6
		E.db['nameplates']['units']['ENEMY_PLAYER']['debuffs']['priority'] = 'Blacklist,Personal,CCDebuffs'
		E.db['nameplates']['units']['ENEMY_PLAYER']['debuffs']['size'] = 25
		E.db['nameplates']['units']['ENEMY_PLAYER']['debuffs']['yOffset'] = 5
		E.db['nameplates']['units']['ENEMY_PLAYER']['castbar']['iconSize'] = 24
		E.db['nameplates']['units']['ENEMY_PLAYER']['castbar']['hideTime'] = true
		E.db['nameplates']['units']['ENEMY_PLAYER']['castbar']['sourceInterrupt'] = false
		E.db['nameplates']['units']['ENEMY_PLAYER']['raidTargetIndicator']['size'] = 22
		E.db['nameplates']['units']['ENEMY_PLAYER']['title']['format'] = '[npctitle]'
		E.db['nameplates']['units']['ENEMY_PLAYER']['health']['text']['fontSize'] = 12
		E.db['nameplates']['units']['ENEMY_PLAYER']['power']['enable'] = true
		E.db['nameplates']['units']['ENEMY_PLAYER']['power']['text']['enable'] = true
		E.db['nameplates']['units']['ENEMY_PLAYER']['power']['text']['fontSize'] = 12
		E.db['nameplates']['units']['ENEMY_PLAYER']['power']['text']['position'] = 'BOTTOMLEFT'
		E.db['nameplates']['units']['ENEMY_PLAYER']['power']['text']['yOffset'] = 10
		E.db['nameplates']['units']['ENEMY_PLAYER']['buffs']['maxDuration'] = 0
		E.db['nameplates']['units']['ENEMY_PLAYER']['buffs']['numAuras'] = 6
		E.db['nameplates']['units']['ENEMY_PLAYER']['buffs']['priority'] = 'Blacklist,RaidBuffsElvUI,Dispellable,blockNoDuration,PlayerBuffs,TurtleBuffs,CastByUnit'
		E.db['nameplates']['units']['ENEMY_PLAYER']['buffs']['size'] = 25
		E.db['nameplates']['units']['ENEMY_PLAYER']['buffs']['yOffset'] = 35
		E.db['nameplates']['units']['ENEMY_PLAYER']['level']['format'] = '[difficultycolor][level][shortclassification]'
		E.db['nameplates']['units']['ENEMY_PLAYER']['name']['format'] = '[name]'
	end
	--Tooltips
	do
		E.db['tooltip']['itemCount'] = 'NONE'
		E.db['tooltip']['healthBar']['height'] = 12
		E.db['tooltip']['healthBar']['font'] = 'PT Sans Narrow'
		E.db['tooltip']['healthBar']['fontSize'] = 12
	end
	--Unitframes
	do
		E.db['unitframe']['fontSize'] = 14
		E.db['unitframe']['font'] = 'PT Sans Narrow'
		E.db['unitframe']['fontOutline'] = 'OUTLINE'
		E.db['unitframe']['statusbar'] = 'Polished Wood'
		E.db['unitframe']['smartRaidFilter'] = false
		E.db['unitframe']['thinBorders'] = true

		E.db['unitframe']['units']['player']['debuffs']['perrow'] = 7
		E.db['unitframe']['units']['player']['debuffs']['yOffset'] = 14
		E.db['unitframe']['units']['player']['portrait']['overlayAlpha'] = 1
		E.db['unitframe']['units']['player']['portrait']['fullOverlay'] = true
		E.db['unitframe']['units']['player']['portrait']['enable'] = true
		E.db['unitframe']['units']['player']['portrait']['camDistanceScale'] = 3.5
		E.db['unitframe']['units']['player']['portrait']['overlay'] = true
		E.db['unitframe']['units']['player']['resurrectIcon']['size'] = 40
		E.db['unitframe']['units']['player']['RestIcon']['anchorPoint'] = 'TOPRIGHT'
		E.db['unitframe']['units']['player']['RestIcon']['yOffset'] = 3
		E.db['unitframe']['units']['player']['health']['yOffset'] = -2
		E.db['unitframe']['units']['player']['health']['position'] = 'TOPLEFT'
		E.db['unitframe']['units']['player']['CombatIcon']['anchorPoint'] = 'TOPRIGHT'
		E.db['unitframe']['units']['player']['CombatIcon']['xOffset'] = 12
		E.db['unitframe']['units']['player']['CombatIcon']['yOffset'] = -8
		E.db['unitframe']['units']['player']['CombatIcon']['size'] = 30
		E.db['unitframe']['units']['player']['aurabar']['maxDuration'] = 600
		E.db['unitframe']['units']['player']['aurabar']['maxBars'] = 8
		E.db['unitframe']['units']['player']['aurabar']['detachedWidth'] = 200
		E.db['unitframe']['units']['player']['aurabar']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal'
		E.db['unitframe']['units']['player']['aurabar']['attachTo'] = 'DETACHED'
		E.db['unitframe']['units']['player']['aurabar']['sortDirection'] = 'ASCENDING'
		E.db['unitframe']['units']['player']['aurabar']['spacing'] = 1
		E.db['unitframe']['units']['player']['classbar']['autoHide'] = true
		E.db['unitframe']['units']['player']['classbar']['detachFromFrame'] = true
		E.db['unitframe']['units']['player']['classbar']['height'] = 14
		E.db['unitframe']['units']['player']['castbar']['insideInfoPanel'] = false
		E.db['unitframe']['units']['player']['castbar']['iconAttachedTo'] = 'Castbar'
		E.db['unitframe']['units']['player']['castbar']['iconYOffset'] = 6
		E.db['unitframe']['units']['player']['castbar']['iconXOffset'] = 0
		E.db['unitframe']['units']['player']['castbar']['iconSize'] = 30
		E.db['unitframe']['units']['player']['castbar']['width'] = 250
		E.db['unitframe']['units']['player']['castbar']['icon'] = false
		E.db['unitframe']['units']['player']['customTexts'] = {}
		E.db['unitframe']['units']['player']['customTexts']['Absorbs'] = {}
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['attachTextTo'] = 'Health'
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['enable'] = true
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['text_format'] = '[absorbs:sl-short]'
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['yOffset'] = -6
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['font'] = 'PT Sans Narrow'
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['justifyH'] = 'LEFT'
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['fontOutline'] = 'OUTLINE'
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['xOffset'] = 2
		E.db['unitframe']['units']['player']['customTexts']['Absorbs']['size'] = 14
		E.db['unitframe']['units']['player']['healPrediction']['showOverAbsorbs'] = false
		E.db['unitframe']['units']['player']['disableMouseoverGlow'] = true
		E.db['unitframe']['units']['player']['width'] = 220
		E.db['unitframe']['units']['player']['power']['attachTextTo'] = 'Power'
		E.db['unitframe']['units']['player']['power']['position'] = 'LEFT'
		E.db['unitframe']['units']['player']['power']['xOffset'] = 2
		E.db['unitframe']['units']['player']['power']['text_format'] = '[powercolor][curpp]'
		E.db['unitframe']['units']['player']['name']['yOffset'] = 14
		E.db['unitframe']['units']['player']['name']['text_format'] = '[name] [level]'
		E.db['unitframe']['units']['player']['name']['position'] = 'TOPLEFT'
		E.db['unitframe']['units']['player']['raidicon']['attachTo'] = 'BOTTOMRIGHT'
		E.db['unitframe']['units']['player']['raidicon']['size'] = 20
		E.db['unitframe']['units']['player']['raidicon']['xOffset'] = 20
		E.db['unitframe']['units']['player']['raidicon']['yOffset'] = 0
		E.db['unitframe']['units']['player']['height'] = 50
		E.db['unitframe']['units']['player']['buffs']['perrow'] = 7
		E.db['unitframe']['units']['player']['buffs']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal'
		E.db['unitframe']['units']['player']['pvpIcon']['enable'] = true
		E.db['unitframe']['units']['player']['pvpIcon']['xOffset'] = -36
		E.db['unitframe']['units']['player']['pvpIcon']['anchorPoint'] = 'LEFT'
		E.db['unitframe']['units']['player']['pvp']['text_format'] = ''

		E.db['unitframe']['units']['pet']['debuffs']['anchorPoint'] = 'TOPRIGHT'
		E.db['unitframe']['units']['pet']['castbar']['iconSize'] = 32
		E.db['unitframe']['units']['pet']['castbar']['width'] = 100
		E.db['unitframe']['units']['pet']['width'] = 100
		E.db['unitframe']['units']['pet']['infoPanel']['height'] = 14
		E.db['unitframe']['units']['pet']['disableTargetGlow'] = false
		E.db['unitframe']['units']['pet']['height'] = 30

		E.db['unitframe']['units']['target']['debuffs']['anchorPoint'] = 'TOPLEFT'
		E.db['unitframe']['units']['target']['debuffs']['maxDuration'] = 0
		E.db['unitframe']['units']['target']['debuffs']['attachTo'] = 'FRAME'
		E.db['unitframe']['units']['target']['debuffs']['priority'] = 'Blacklist,Personal,nonPersonal'
		E.db['unitframe']['units']['target']['debuffs']['perrow'] = 7
		E.db['unitframe']['units']['target']['debuffs']['yOffset'] = 14
		E.db['unitframe']['units']['target']['portrait']['overlayAlpha'] = 1
		E.db['unitframe']['units']['target']['portrait']['fullOverlay'] = true
		E.db['unitframe']['units']['target']['portrait']['enable'] = true
		E.db['unitframe']['units']['target']['portrait']['camDistanceScale'] = 3.5
		E.db['unitframe']['units']['target']['portrait']['overlay'] = true
		E.db['unitframe']['units']['target']['resurrectIcon']['size'] = 40
		E.db['unitframe']['units']['target']['CombatIcon']['anchorPoint'] = 'TOPLEFT'
		E.db['unitframe']['units']['target']['CombatIcon']['xOffset'] = -12
		E.db['unitframe']['units']['target']['CombatIcon']['yOffset'] = -8
		E.db['unitframe']['units']['target']['CombatIcon']['size'] = 30
		E.db['unitframe']['units']['target']['aurabar']['maxDuration'] = 0
		E.db['unitframe']['units']['target']['aurabar']['maxBars'] = 8
		E.db['unitframe']['units']['target']['aurabar']['detachedWidth'] = 200
		E.db['unitframe']['units']['target']['aurabar']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal'
		E.db['unitframe']['units']['target']['aurabar']['attachTo'] = 'DETACHED'
		E.db['unitframe']['units']['target']['aurabar']['sortDirection'] = 'ASCENDING'
		E.db['unitframe']['units']['target']['aurabar']['spacing'] = 1
		E.db['unitframe']['units']['target']['castbar']['xOffsetText'] = 0
		E.db['unitframe']['units']['target']['castbar']['height'] = 24
		E.db['unitframe']['units']['target']['castbar']['width'] = 250
		E.db['unitframe']['units']['target']['castbar']['insideInfoPanel'] = false
		E.db['unitframe']['units']['target']['customTexts'] = {}
		E.db['unitframe']['units']['target']['customTexts']['Absorbs'] = {}
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['attachTextTo'] = 'Health'
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['enable'] = true
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['text_format'] = '[absorbs:sl-short]'
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['yOffset'] = -6
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['font'] = 'PT Sans Narrow'
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['justifyH'] = 'RIGHT'
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['fontOutline'] = 'OUTLINE'
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['xOffset'] = -2
		E.db['unitframe']['units']['target']['customTexts']['Absorbs']['size'] = 14
		E.db['unitframe']['units']['target']['healPrediction']['showOverAbsorbs'] = false
		E.db['unitframe']['units']['target']['disableMouseoverGlow'] = true
		E.db['unitframe']['units']['target']['width'] = 220
		E.db['unitframe']['units']['target']['health']['yOffset'] = -2
		E.db['unitframe']['units']['target']['health']['position'] = 'TOPRIGHT'
		E.db['unitframe']['units']['target']['name']['yOffset'] = 14
		E.db['unitframe']['units']['target']['name']['text_format'] = '[name] [level]'
		E.db['unitframe']['units']['target']['name']['position'] = 'TOPRIGHT'
		E.db['unitframe']['units']['target']['pvpIcon']['enable'] = true
		E.db['unitframe']['units']['target']['pvpIcon']['xOffset'] = 36
		E.db['unitframe']['units']['target']['pvpIcon']['anchorPoint'] = 'RIGHT'
		E.db['unitframe']['units']['target']['height'] = 50
		E.db['unitframe']['units']['target']['buffs']['anchorPoint'] = 'TOPLEFT'
		E.db['unitframe']['units']['target']['buffs']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal'
		E.db['unitframe']['units']['target']['buffs']['attachTo'] = 'DEBUFFS'
		E.db['unitframe']['units']['target']['buffs']['perrow'] = 7
		E.db['unitframe']['units']['target']['power']['attachTextTo'] = 'Power'
		E.db['unitframe']['units']['target']['power']['position'] = 'RIGHT'
		E.db['unitframe']['units']['target']['power']['xOffset'] = -2
		E.db['unitframe']['units']['target']['power']['text_format'] = '[powercolor][curpp]'
		E.db['unitframe']['units']['target']['raidicon']['attachTo'] = 'BOTTOMLEFT'
		E.db['unitframe']['units']['target']['raidicon']['size'] = 20
		E.db['unitframe']['units']['target']['raidicon']['xOffset'] = -20
		E.db['unitframe']['units']['target']['raidicon']['yOffset'] = 0

		E.db['unitframe']['units']['targettarget']['debuffs']['anchorPoint'] = 'TOPRIGHT'
		E.db['unitframe']['units']['targettarget']['debuffs']['xOffset'] = 100
		E.db['unitframe']['units']['targettarget']['debuffs']['attachTo'] = 'HEALTH'
		E.db['unitframe']['units']['targettarget']['debuffs']['yOffset'] = -19
		E.db['unitframe']['units']['targettarget']['power']['enable'] = false
		E.db['unitframe']['units']['targettarget']['disableMouseoverGlow'] = true
		E.db['unitframe']['units']['targettarget']['width'] = 100
		E.db['unitframe']['units']['targettarget']['buffs']['anchorPoint'] = 'BOTTOMRIGHT'
		E.db['unitframe']['units']['targettarget']['buffs']['xOffset'] = 100
		E.db['unitframe']['units']['targettarget']['buffs']['attachTo'] = 'HEALTH'
		E.db['unitframe']['units']['targettarget']['buffs']['enable'] = true
		E.db['unitframe']['units']['targettarget']['buffs']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,Whitelist,nonPersonal'
		E.db['unitframe']['units']['targettarget']['buffs']['maxDuration'] = 0
		E.db['unitframe']['units']['targettarget']['buffs']['yOffset'] = 12
		E.db['unitframe']['units']['targettarget']['threatStyle'] = 'GLOW'
		E.db['unitframe']['units']['targettarget']['raidicon']['attachTo'] = 'LEFT'
		E.db['unitframe']['units']['targettarget']['raidicon']['xOffset'] = -19
		E.db['unitframe']['units']['targettarget']['raidicon']['yOffset'] = 0

		E.db['unitframe']['units']['focus']['debuffs']['xOffset'] = -4
		E.db['unitframe']['units']['focus']['debuffs']['sizeOverride'] = 30
		E.db['unitframe']['units']['focus']['debuffs']['anchorPoint'] = 'BOTTOMRIGHT'
		E.db['unitframe']['units']['focus']['debuffs']['perrow'] = 7
		E.db['unitframe']['units']['focus']['width'] = 220
		E.db['unitframe']['units']['focus']['castbar']['width'] = 220
		E.db['unitframe']['units']['focus']['height'] = 30
		E.db['unitframe']['units']['focus']['buffs']['anchorPoint'] = 'RIGHT'
		E.db['unitframe']['units']['focus']['buffs']['sizeOverride'] = 30
		E.db['unitframe']['units']['focus']['buffs']['attachTo'] = 'HEALTH'
		E.db['unitframe']['units']['focus']['buffs']['maxDuration'] = 0
		E.db['unitframe']['units']['focus']['buffs']['enable'] = true
		E.db['unitframe']['units']['focus']['buffs']['priority'] = 'Blacklist,blockNoDuration,Personal,PlayerBuffs,CastByUnit,Dispellable,RaidBuffsElvUI'
		E.db['unitframe']['units']['focus']['buffs']['perrow'] = 4
		E.db['unitframe']['units']['focus']['buffs']['yOffset'] = -4
		E.db['unitframe']['units']['focus']['raidicon']['attachTo'] = 'LEFT'
		E.db['unitframe']['units']['focus']['raidicon']['xOffset'] = -20
		E.db['unitframe']['units']['focus']['raidicon']['size'] = 20

		E.db['unitframe']['units']['tank']['enable'] = false
		E.db['unitframe']['units']['assist']['enable'] = false

		E.db['unitframe']['units']['party']['enable'] = false

		E.db['unitframe']['units']['raid1']['rdebuffs']['font'] = 'PT Sans Narrow'
		E.db['unitframe']['units']['raid1']['rdebuffs']['yOffset'] = 10
		E.db['unitframe']['units']['raid1']['numGroups'] = 8
		E.db['unitframe']['units']['raid1']['growthDirection'] = 'RIGHT_UP'
		E.db['unitframe']['units']['raid1']['resurrectIcon']['attachTo'] = 'BOTTOMRIGHT'
		E.db['unitframe']['units']['raid1']['roleIcon']['attachTo'] = 'InfoPanel'
		E.db['unitframe']['units']['raid1']['roleIcon']['size'] = 12
		E.db['unitframe']['units']['raid1']['roleIcon']['xOffset'] = 0
		E.db['unitframe']['units']['raid1']['roleIcon']['yOffset'] = -2
		E.db['unitframe']['units']['raid1']['power']['height'] = 5
		E.db['unitframe']['units']['raid1']['power']['enable'] = false
		E.db['unitframe']['units']['raid1']['health']['text_format'] = ''
		E.db['unitframe']['units']['raid1']['width'] = 92
		E.db['unitframe']['units']['raid1']['infoPanel']['enable'] = true
		E.db['unitframe']['units']['raid1']['name']['attachTextTo'] = 'InfoPanel'
		E.db['unitframe']['units']['raid1']['name']['yOffset'] = -4
		E.db['unitframe']['units']['raid1']['name']['xOffset'] = 2
		E.db['unitframe']['units']['raid1']['name']['position'] = 'BOTTOMLEFT'
		E.db['unitframe']['units']['raid1']['height'] = 22
		E.db['unitframe']['units']['raid1']['visibility'] = '[nogroup] hide;show'
		E.db['unitframe']['units']['raid1']['raidicon']['attachTo'] = 'RIGHT'

		E.db['unitframe']['units']['raid2']['enable'] = false
		E.db['unitframe']['units']['raid3']['enable'] = false

		E.db['unitframe']['units']['arena']['name']['position'] = 'TOPRIGHT'
		E.db['unitframe']['units']['arena']['health']['xOffset'] = -2
		E.db['unitframe']['units']['arena']['health']['position'] = 'BOTTOMRIGHT'
		E.db['unitframe']['units']['arena']['power']['attachTextTo'] = 'Power'
		E.db['unitframe']['units']['arena']['power']['text_format'] = '[powercolor][curpp]'

		E.db['unitframe']['units']['boss']['debuffs']['maxDuration'] = 300
		E.db['unitframe']['units']['boss']['debuffs']['sizeOverride'] = 27
		E.db['unitframe']['units']['boss']['debuffs']['priority'] = 'Blacklist,blockNoDuration,Personal,CCDebuffs,Whitelist'
		E.db['unitframe']['units']['boss']['debuffs']['desaturate'] = false
		E.db['unitframe']['units']['boss']['debuffs']['yOffset'] = -16
		E.db['unitframe']['units']['boss']['power']['attachTextTo'] = 'Power'
		E.db['unitframe']['units']['boss']['power']['text_format'] = '[powercolor][curpp]'
		E.db['unitframe']['units']['boss']['width'] = 246
		E.db['unitframe']['units']['boss']['infoPanel']['height'] = 17
		E.db['unitframe']['units']['boss']['castbar']['width'] = 256
		E.db['unitframe']['units']['boss']['name']['position'] = 'TOPRIGHT'
		E.db['unitframe']['units']['boss']['height'] = 47
		E.db['unitframe']['units']['boss']['buffs']['maxDuration'] = 300
		E.db['unitframe']['units']['boss']['buffs']['sizeOverride'] = 27
		E.db['unitframe']['units']['boss']['buffs']['priority'] = 'Blacklist,TurtleBuffs,PlayerBuffs,Dispellable'
		E.db['unitframe']['units']['boss']['buffs']['yOffset'] = 16
		E.db['unitframe']['units']['boss']['health']['xOffset'] = -2
		E.db['unitframe']['units']['boss']['health']['position'] = 'BOTTOMRIGHT'

		E.db['unitframe']['colors']['transparentAurabars'] = true
		E.db['unitframe']['colors']['healthclass'] = true
		E.db['unitframe']['colors']['colorhealthbyvalue'] = false
		E.db['unitframe']['colors']['frameGlow']['mainGlow']['class'] = true
		E.db['unitframe']['colors']['auraBarBuff']['r'] = 0.23529411764706
		E.db['unitframe']['colors']['auraBarBuff']['g'] = 0.74901960784314
		E.db['unitframe']['colors']['auraBarBuff']['b'] = 0.15294117647059
		E.db['unitframe']['colors']['castColor']['r'] = 0.6078431372549
		E.db['unitframe']['colors']['castColor']['g'] = 0.58823529411765
		E.db['unitframe']['colors']['castColor']['b'] = 0.28235294117647
		E.db['unitframe']['colors']['healPrediction']['absorbs']['a'] = 0.61000001430511
		E.db['unitframe']['colors']['healPrediction']['absorbs']['b'] = 0.5921568627451
		E.db['unitframe']['colors']['healPrediction']['absorbs']['r'] = 0.95686274509804
		E.db['unitframe']['colors']['healPrediction']['overabsorbs']['a'] = 0.61073982715607
		E.db['unitframe']['colors']['healPrediction']['overabsorbs']['b'] = 1
		E.db['unitframe']['colors']['healPrediction']['overhealabsorbs']['a'] = 0.61000001430511

	end
	--S&L
	do
		E.db['sle']['blizzard']['rumouseover'] = true

		E.db['sle']['armory']['stats']['List']['ATTACK_AP'] = true
		E.db['sle']['armory']['stats']['itemLevel']['AverageGradient'] = true
		E.db['sle']['armory']['character']['enable'] = true
		E.db['sle']['armory']['character']['gradient']['quality'] = true
		E.db['sle']['armory']['inspect']['enable'] = true
		E.db['sle']['armory']['inspect']['gradient']['quality'] = true

		E.db['sle']['unitframe']['units']['raid1']['offlineIndicator']['enable'] = true
		E.db['sle']['unitframe']['units']['raid1']['offlineIndicator']['size'] = 22
		E.db['sle']['unitframe']['units']['raid1']['deathIndicator']['enable'] = true
		E.db['sle']['unitframe']['units']['raid1']['deathIndicator']['size'] = 22
		-- E.db['sle']['unitframe']['units']['player']['pvpIconText']['enable'] = true
		-- E.db['sle']['unitframe']['units']['player']['pvpIconText']['yoffset'] = -6

		E.db['sle']['loot']['history']['autohide'] = true
		E.db['sle']['loot']['enable'] = true
		E.db['sle']['loot']['autoroll']['autogreed'] = true

		E.db['sle']['uibuttons']['point'] = 'TOPRIGHT'
		E.db['sle']['uibuttons']['enable'] = true
		E.db['sle']['uibuttons']['spacing'] = 1
		E.db['sle']['uibuttons']['anchor'] = 'TOPLEFT'

		E.db['sle']['tooltip']['showFaction'] = true
		E.db['sle']['tooltip']['alwaysCompareItems'] = true

		E.db['sle']['legacy']['warwampaign']['autoOrder']['enable'] = true

		E.db['sle']['chat']['guildmaster'] = true
		E.db['sle']['chat']['dpsSpam'] = true

		E.db["sle"]["databars"]["experience"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["experience"]["chatfilter"]["style"] = "STYLE2"
		E.db["sle"]["databars"]["reputation"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["reputation"]["chatfilter"]["style"]["increase"] = "STYLE2"

		E.db['sle']['dt']['friends']['hideODIN'] = true
		E.db['sle']['dt']['friends']['hideLAZR'] = true
		E.db['sle']['dt']['friends']['hide_titleline'] = true
		E.db['sle']['dt']['friends']['hideBSAp'] = true
		E.db['sle']['dt']['friends']['hideVIPR'] = true
		E.db['sle']['dt']['friends']['panelStyle'] = 'DEFAULTTOTALS'
		E.db['sle']['dt']['currency']['Unused'] = false
		E.db['sle']['dt']['currency']['Archaeology'] = false
		E.db['sle']['dt']['currency']['gold']['method'] = 'amount'
		E.db['sle']['dt']['guild']['totals'] = true
		E.db['sle']['dt']['guild']['hide_titleline'] = true

		E.db['sle']['nameplates']['targetcount']['enable'] = true
		E.db['sle']['nameplates']['threat']['enable'] = true

		E.db['sle']['minimap']['instance']['enable'] = true
		E.db['sle']['minimap']['instance']['fontSize'] = 14
		E.db['sle']['minimap']['locPanel']['enable'] = true
		E.db['sle']['minimap']['locPanel']['width'] = 310

		E.db['sle']['quests']['autoReward'] = true

		E.db['sle']['pvp']['autorelease'] = true
		E.db['sle']['pvp']['duels']['pet'] = true
		E.db['sle']['pvp']['duels']['regular'] = true
	end
	--Movers
	do
		E.db["movers"]["AlertFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,297,-572"
		E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,84"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-300"
		E.db["movers"]["AzeriteBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,153"
		E.db["movers"]["BNETMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,29"
		E.db["movers"]["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-247"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,433"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-301"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUI_MinimapHolder,TOPLEFT,-7,-1"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,412"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-231,-116"
		E.db["movers"]["DurabilityFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,164,30"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,171"
		E.db["movers"]["ElvAB_10"] = "BOTTOM,ElvUI_Bar1,TOP,0,202"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,202,171"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-202,171"
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-474,23"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,475,23"
		E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvUI_Bar2,TOP,0,2"
		E.db["movers"]["ElvAB_7"] = "BOTTOM,ElvUI_Bar1,TOP,0,82"
		E.db["movers"]["ElvAB_8"] = "BOTTOM,ElvUI_Bar1,TOP,0,122"
		E.db["movers"]["ElvAB_9"] = "BOTTOM,ElvUI_Bar1,TOP,0,162"
		E.db["movers"]["ElvNP_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,503"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,526,-238"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,391"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,261,306"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,248"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "TOPLEFT,ElvUF_Pet,BOTTOMLEFT,0,-1"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-317,344"
		E.db["movers"]["ElvUF_PlayerAuraMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,498,407"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,339"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-257,377"
		E.db["movers"]["ElvUF_Raid1Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,253"
		E.db["movers"]["ElvUF_Raid2Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,482"
		E.db["movers"]["ElvUF_Raid3Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,482"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,737"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,518,-316"
		E.db["movers"]["ElvUF_TargetAuraMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-490,406"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,362"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,261,376"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,201,338"
		E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,249"
		E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,249"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,551,23"
		E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,368,0"
		E.db["movers"]["HonorBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,162"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,0"
		E.db["movers"]["LevelUpBossBannerMover"] = "TOP,ElvUIParent,TOP,0,-217"
		E.db["movers"]["LootFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,533,-366"
		E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,549"
		E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-48"
		E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-3"
		E.db["movers"]["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-289"
		E.db["movers"]["MirrorTimer2Mover"] = "TOP,MirrorTimer1,BOTTOM,0,0"
		E.db["movers"]["MirrorTimer3Mover"] = "TOP,MirrorTimer2,BOTTOM,0,0"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,90,0"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-218,336"
		E.db["movers"]["PetBattleABMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["PetBattleStatusMover"] = "TOP,PetBattleFrame,TOP,0,0"
		E.db["movers"]["RaidMarkerBarAnchor"] = "BOTTOM,ElvUIParent,BOTTOM,0,312"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-550,23"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,-1"
		E.db["movers"]["SLE_BG_1_Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,21"
		E.db["movers"]["SLE_BG_2_Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOM,-257,21"
		E.db["movers"]["SLE_BG_3_Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOM,257,21"
		E.db["movers"]["SLE_BG_4_Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,189"
		E.db["movers"]["SLE_GarrisonToolMover"] = "LEFT,ElvUIParent,LEFT,24,0"
		E.db["movers"]["SLE_Location_Mover"] = "TOP,ElvUIParent,TOP,0,0"
		E.db["movers"]["SLE_UIButtonsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-227,-174"
		E.db["movers"]["ShiftAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,798,277"
		E.db["movers"]["SocialMenuMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-187"
		E.db["movers"]["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,258"
		E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-27"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,267"
		E.db["movers"]["UIErrorsFrameMover"] = "TOP,ElvUIParent,TOP,0,-177"
		E.db["movers"]["VOICECHAT"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,586,27"
		E.db["movers"]["VehicleLeaveButton"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-190,-248"
		E.db["movers"]["VehicleSeatMover"] = "BOTTOM,ElvUIParent,BOTTOM,-204,27"
		E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,433"
	end

	if C_AddOns_IsAddOnLoaded('AddOnSkins') then
		local AS = unpack(_G['AddOnSkins']) or nil
		if AS then
			AS.db['Blizzard_AbilityButton'] = true
			AS.db['EmbedRight'] = 'Details'
			AS.db['EmbedLeft'] = 'Details'
			AS.db['Blizzard_ExtraActionButton'] = true
			AS.db['ElvUIStyle'] = false
			AS.db['BackgroundTexture'] = 'ElvUI Gloss'
			AS.db['EmbedOoC'] = true
			AS.db['EmbedSystemDual'] = true
			AS.db['EmbedOoCDelay'] = 3
		end
	end

	E.private['general']['normTex'] = 'ElvUI Gloss'
	E.private['general']['glossTex'] = 'ElvUI Gloss'
	E.private['general']['minimap']['hideClassHallReport'] = true

	E.db['sle']['afk']['enable'] = true

	E.private['sle']['uibuttons']['style'] = 'dropdown'

	E.private['sle']['skins']['merchant']['enable'] = true
	E.private['sle']['skins']['merchant']['style'] = 'List'

	E.private['sle']['skins']['objectiveTracker']['scenarioBG'] = true
	E.private['sle']['skins']['objectiveTracker']['color']['b'] = 0.15294117647059
	E.private['sle']['skins']['objectiveTracker']['color']['g'] = 0.74901960784314
	E.private['sle']['skins']['objectiveTracker']['color']['r'] = 0.23529411764706

	E.private['sle']['pvp']['KBbanner']['enable'] = true

	E.global['general']['fadeMapWhenMoving'] = false
	E.global['general']['commandBarSetting'] = 'DISABLED'
	E.global['sle']['advanced']['optionsLimits'] = true

	if layout then
		if layout == 'tank' then
			E.db['nameplates']['threat']['beingTankedByTank'] = true
			-- E.db['unitframe']['units']['raid']['power']['enable'] = true
			E.db['sle']['armory']['stats']['List']['SPELLPOWER'] = false
			E.db['sle']['armory']['stats']['List']['ATTACK_DAMAGE'] = true
			E.db['sle']['armory']['stats']['List']['ATTACK_AP'] = true
			E.db['sle']['armory']['stats']['List']['ATTACK_ATTACKSPEED'] = true
		-- elseif layout == 'dpsMelee' then
			-- E.db['sle']['armory']['stats']['List']['SPELLPOWER'] = false
			-- E.db['sle']['armory']['stats']['List']['ATTACK_DAMAGE'] = true
			-- E.db['sle']['armory']['stats']['List']['ATTACK_AP'] = true
			-- E.db['sle']['armory']['stats']['List']['ATTACK_ATTACKSPEED'] = true
			E.db['sle']['armory']['stats']['List']['ENERGY_REGEN'] = true
			E.db['sle']['armory']['stats']['List']['RUNE_REGEN'] = true
			E.db['sle']['armory']['stats']['List']['FOCUS_REGEN'] = true
		elseif layout == 'healer' then
			E.db['unitframe']['units']['raid1']['healPrediction']['enable'] = true

			E.db['movers']['ElvUF_RaidMover'] = 'TOPLEFT,ElvUIParent,TOPLEFT,362,-272'
			E.db['movers']['LootFrameMover'] = 'TOPLEFT,ElvUIParent,TOPLEFT,1,-467'
			E.db['movers']['AlertFrameMover'] = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,252,249'
		end
		E.db.layoutSet = layout
	else
		E.db.layoutSet = 'dpsCaster'
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:StaggeredUpdateAll(nil, true)

	_G["PluginInstallStepComplete"].message = L["Darth's Default Set"]..": "..(PI.SLE_Word == NONE and L["Caster DPS"] or PI.SLE_Word)
	_G["PluginInstallStepComplete"]:Show()
end

function PI:DarthAddons()
	if xCTSavedDB and C_AddOns_IsAddOnLoaded('xCT+') then
		xCTSavedDB["profiles"]["S&L Darth"] = {
			["frames"] = {
				["general"] = {
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
				},
				["outgoing"] = {
					["enableFontShadow"] = false,
					["Width"] = 98,
					["font"] = "PT Sans Narrow",
					["fontSize"] = 12,
					["Y"] = -249,
					["X"] = 560,
					["Height"] = 177,
				},
				["critical"] = {
					["enableFontShadow"] = false,
					["Width"] = 130,
					["font"] = "PT Sans Narrow",
					["fontSize"] = 16,
					["Y"] = -252,
					["X"] = 674,
					["Height"] = 174,
				},
				["power"] = {
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
				},
				["procs"] = {
					["enabledFrame"] = false,
					["font"] = "PT Sans Narrow",
				},
				["healing"] = {
					["enableFontShadow"] = false,
					["enableOverHeal"] = false,
					["Width"] = 115,
					["fontJustify"] = "RIGHT",
					["font"] = "PT Sans Narrow",
					["enableRealmNames"] = false,
					["fontSize"] = 13,
					["showFriendlyHealers"] = false,
					["insertText"] = "top",
					["Y"] = 28,
					["X"] = 78,
					["Height"] = 157,
					["names"] = {
						["PLAYER"] = {
							["nameType"] = 0,
						},
						["NPC"] = {
							["nameType"] = 0,
						},
					},
					["enableClassNames"] = false,
				},
				["loot"] = {
					["enableFontShadow"] = false,
					["Width"] = 232,
					["font"] = "PT Sans Narrow",
					["fontSize"] = 12,
					["Y"] = -102,
					["X"] = 627,
					["Height"] = 115,
				},
				["damage"] = {
					["enableFontShadow"] = false,
					["Width"] = 115,
					["font"] = "PT Sans Narrow",
					["fontSize"] = 13,
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
					["Y"] = 29,
					["X"] = -79,
					["Height"] = 157,
				},
			},
			["dbVersion"] = "4.7.2",
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
	SetCVar("minimapTrackingShowAll", "1")

	SetAutoDeclineGuildInvites(true)
	C_Container.SetInsertItemsLeftToRight(false)

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
	OnCancel = E.noop
}

E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnCancel = E.noop
}

local function StartSetup(Author)
	if Author == "DARTH" then
		E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.DarthSetupDF
	elseif Author == "DARTH_SL" then
		E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.DarthSetupSL
	-- elseif Author == "REPOOC" then
	-- elseif Author == "AFFINITY" then
		-- E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'].OnAccept = PI.AffinitySetup
	end
	E:StaticPopup_Show("SLE_INSTALL_SETTINGS_LAYOUT")
end

local function SetupAddons(Author)
	if AddOnSkins and (not EmbedSystem_LeftWindow or not EmbedSystem_LeftWindow) then
		local AS = unpack(AddOnSkins)
		local ES = AS.EmbedSystem
		ES:Check(true)
	end
	if Author == "DARTH" then
		local list = "xCT+"
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].OnAccept = PI.DarthAddons
	-- elseif Author == "AFFINITY" then
		-- local list = "Skada\nxCT+"
		-- E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
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
			_G.PluginInstallFrame.SubTitle:SetText(format(L["Welcome to |cff9482c9Shadow & Light|r version %s!"], SLE.version))
			_G.PluginInstallFrame.Desc1:SetText(L["SLE_INSTALL_WELCOME"])
			_G.PluginInstallFrame.Desc2:SetText("")
			_G.PluginInstallFrame.Desc3:SetText(L["Please press the continue button to go onto the next step."])

			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			_G.PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			PI.SLE_Auth = ""
			PI.SLE_Word = E.db.layoutSet == 'tank' and _G.STAT_CATEGORY_MELEE or E.db.layoutSet == 'healer' and _G.CLUB_FINDER_HEALER or E.db.layoutSet == 'dpsCaster' and _G.STAT_CATEGORY_RANGED or NONE
			_G.PluginInstallFrame.SubTitle:SetText(L["Shadow & Light Imports"])
			_G.PluginInstallFrame.Desc1:SetText(L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."])
			_G.PluginInstallFrame.Desc2:SetText(format(L["SLE_Install_Text_AUTHOR"], PI.SLE_Word))
			_G.PluginInstallFrame.Desc3:SetText(L["Importance: |cFF33FF33Low|r"])

			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript('OnClick', function()
				PI.SLE_Auth = "DARTH"
				_G.PluginInstallFrame.Next:Click()
			end)
			_G.PluginInstallFrame.Option1:SetText(L["Darth's Config"])

			-- _G["PluginInstallFrame"].Option2:Show()
			-- _G["PluginInstallFrame"].Option2:SetScript('OnClick', function() PI.SLE_Auth = "REPOOC"; _G["PluginInstallFrame"].Next:Click() end)
			-- _G["PluginInstallFrame"].Option2:SetText(L["Repooc's Config"])

			_G["PluginInstallFrame"]:Size(550, 500)
		end,
		[3] = function()
			if PI.SLE_Auth == '' then
				if _G["PluginInstallFrame"].PrevPage == 2 then
					E.PluginInstaller.SetPage(2, 4)
				else
					E.PluginInstaller.SetPage(4, 2)
				end
				return
			end
			PI.SLE_Word = E.db.layoutSet == 'tank' and _G.STAT_CATEGORY_MELEE or E.db.layoutSet == 'healer' and _G.CLUB_FINDER_HEALER or E.db.layoutSet == 'dpsCaster' and _G.STAT_CATEGORY_RANGED or NONE
			_G["PluginInstallFrame"].SubTitle:SetText(L["Layout & Settings Import"])
			_G["PluginInstallFrame"].Desc1:SetText(format(L["You have selected to use %s and role %s."], PI.SLE_Auth == "DARTH" and L["Darth's Config"] or PI.SLE_Auth == "REPOOC" and L["Repooc's Config"] or PI.SLE_Auth == "AFFINITY" and L["Affinitii's Config"], PI.SLE_Word))
			_G["PluginInstallFrame"].Desc2:SetText(L["SLE_INSTALL_LAYOUT_TEXT2"])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])

			if PI.SLE_Auth == "DARTH" then
				_G["PluginInstallFrame"].Option1:Show()
				_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() StartSetup("DARTH") end)
				_G["PluginInstallFrame"].Option1:SetText(L["Layout"])

				_G["PluginInstallFrame"].Option2:Show()
				_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() StartSetup("DARTH_SL") end)
				_G["PluginInstallFrame"].Option2:SetText(L["Layout"].." SL")

				_G["PluginInstallFrame"].Option3:Show()
				_G["PluginInstallFrame"].Option3:SetScript('OnClick', function() SetupAddons("DARTH") end)
				_G["PluginInstallFrame"].Option3:SetText(ADDONS)

				_G["PluginInstallFrame"].Option4:Show()
				_G["PluginInstallFrame"].Option4:SetScript('OnClick', function() SetupCVars("DARTH") end)
				_G["PluginInstallFrame"].Option4:SetText(L["CVars"])
			end
			-- if PI.SLE_Auth == "AFFINITY" then
			-- 	_G["PluginInstallFrame"].Option1:Show()
			-- 	_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() StartSetup("AFFINITY") end)
			-- 	_G["PluginInstallFrame"].Option1:SetText(L["Layout"])

			-- 	_G["PluginInstallFrame"].Option2:Show()
			-- 	_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() SetupAddons("AFFINITY") end)
			-- 	_G["PluginInstallFrame"].Option2:SetText(ADDONS)
			-- end
		end,
		[4] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["Armory Mode"])
			_G["PluginInstallFrame"].Desc1:SetText(L["SLE_ARMORY_INSTALL"])
			_G["PluginInstallFrame"].Desc2:SetText(L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cFF33FF33Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() E.db.sle.armory.character.enable = true E.db.sle.armory.inspect.enable = true end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() E.db.sle.armory.character.enable = false E.db.sle.armory.inspect.enable = false end)
			_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		end,
		[5] = function()
			_G["PluginInstallFrame"].SubTitle:SetText(L["AFK Mode"])
			_G["PluginInstallFrame"].Desc1:SetText(L["AFK Mode in |cff9482c9Shadow & Light|r is additional settings/elements for standard |cff1784d1ElvUI|r AFK screen."])
			_G["PluginInstallFrame"].Desc2:SetText(L["This option is bound to character and requires a UI reload to take effect."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cFF33FF33Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() E.db.sle.afk.enable = true end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() E.db.sle.afk.enable = false end)
			_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		end,
		-- [7] = function()
		-- 	_G["PluginInstallFrame"].SubTitle:SetText(L["Raid Frame Power"])
		-- 	_G["PluginInstallFrame"].Desc1:SetText(L["Show power bar for raid frames."])
		-- 	_G["PluginInstallFrame"].Desc2:SetText(L["Can be useful for tanks who know healers actually need mana to heal."])
		-- 	_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cFF33FF33Low|r"])

		-- 	_G["PluginInstallFrame"].Option1:Show()
		-- 	_G["PluginInstallFrame"].Option1:SetScript('OnClick', function()
		-- 		E.db.unitframe.units.raid.power.enable = true
		-- 		_G["PluginInstallStepComplete"].message = L["Raid Frame Power"]..": |cff00FF00"..ENABLE.."|r"
		-- 		_G["PluginInstallStepComplete"]:Show()
		-- 	end)
		-- 	_G["PluginInstallFrame"].Option1:SetText(ENABLE)

		-- 	_G["PluginInstallFrame"].Option2:Show()
		-- 	_G["PluginInstallFrame"].Option2:SetScript('OnClick', function()
		-- 		E.db.unitframe.units.raid.power.enable = false
		-- 		_G["PluginInstallStepComplete"].message = L["Raid Frame Power"]..": |cffFF0000"..DISABLE.."|r"
		-- 		_G["PluginInstallStepComplete"]:Show()
		-- 	end)
		-- 	_G["PluginInstallFrame"].Option2:SetText(DISABLE)
		-- end,
		[6] = function()
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
		[2] = L["Import Profile"],
		[3] = L["Author Presets"].." *",
		[4] = L["Armory Mode"],
		[5] = L["AFK Mode"],
		-- [7] = L["Raid Frame Power"],
		[6] = L["Finished"],
	},
	["StepTitlesColorSelected"] = {.53,.53,.93},
}
