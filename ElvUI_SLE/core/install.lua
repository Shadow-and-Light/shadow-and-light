local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule("PluginInstaller")
PI.SLE_Auth = ""
PI.SLE_Word = ""
local locale = GetLocale()

--GLOBALS: SkadaDB, Skada, xCTSavedDB, xCT_Plus
local _G = _G
local ENABLE, DISABLE, NONE = ENABLE, DISABLE, NONE
local SetCVar = SetCVar
local SetAutoDeclineGuildInvites = SetAutoDeclineGuildInvites
local SetInsertItemsLeftToRight = SetInsertItemsLeftToRight
local GetCVarBool, StopMusic, ReloadUI = GetCVarBool, StopMusic, ReloadUI

local dtbarsList = {}
local dtbarsTexts = {}

local function DarthHeal()
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["height"] = 22

	E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 200

	E.db["nameplates"]["units"]["PLAYER"]["enable"] = false

	E.db["movers"]["ElvUF_PlayerCastbarMover"] = nil
	E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,285,36"
	E.db["movers"]["PetAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,522,124"
	E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,743,166"
	E.db["movers"]["ClassBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,527,251"
	E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-283,121"
	E.db["movers"]["VehicleSeatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,522,32"
	E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,222,113"
	E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,250,56"
	E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-303,264"
	E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,527,191"
	E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-283,140"
	E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,-300,330"
	E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-186"
	E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-523,187"
	E.db["movers"]["PlayerNameplate"] = nil
	if T.IsAddOnLoaded("ElvUI_AuraBarsMovers") then
		E.db["movers"]["ElvUF_PlayerAuraMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,345,210"
		E.db["movers"]["ElvUF_TargetAuraMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-341,207"
	end
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

	if E.db['movers'] then T.twipe(E.db['movers']) else E.db['movers'] = {} end
	
	--General
	do
		E.db["general"]["totems"]["size"] = 30
		E.db["general"]["totems"]["growthDirection"] = "HORIZONTAL"
		E.db["general"]["threat"]["enable"] = false
		E.db["general"]["stickyFrames"] = false
		E.db["general"]["minimap"]["locationText"] = "HIDE"
		E.db["general"]["bottomPanel"] = false
		E.db["general"]["objectiveFrameHeight"] = 640
		E.db["general"]["bonusObjectivePosition"] = "RIGHT"
		E.db["general"]["hideErrorFrame"] = false
	end
	--Actionbars
	do
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
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = -1
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 1
		E.db["actionbar"]["stanceBar"]["style"] = "classic"
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 28
		E.db["actionbar"]["keyDown"] = false
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
		E.db["bags"]["itemLevelThreshold"] = 650
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
		E.db["databars"]["artifact"]["orientation"] = "HORIZONTAL"
		E.db["databars"]["artifact"]["textFormat"] = "CURMAX"
		E.db["databars"]["artifact"]["height"] = 10
		E.db["databars"]["artifact"]["width"] = 380
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
		E.db["nameplates"]["clampToScreen"] = true
		E.db["nameplates"]["lowHealthThreshold"] = 0
		E.db["nameplates"]["font"] = "PT Sans Narrow"
		E.db["nameplates"]["fontOutline"] = "OUTLINE"
		E.db["nameplates"]["threat"]["beingTankedByTank"] = false
		E.db["nameplates"]["castNoInterruptColor"]["b"] = 0.12549019607843
		E.db["nameplates"]["castNoInterruptColor"]["g"] = 0.098039215686274
		E.db["nameplates"]["castNoInterruptColor"]["r"] = 0.85882352941176
		E.db["nameplates"]["statusbar"] = "ElvUI Gloss"
		E.db["nameplates"]["fontSize"] = 12
		E.db["nameplates"]["reactions"]["good"]["b"] = 0.10980392156863
		E.db["nameplates"]["reactions"]["good"]["g"] = 0.74901960784314
		E.db["nameplates"]["reactions"]["good"]["r"] = 0.082352941176471
		E.db["nameplates"]["reactions"]["tapped"]["b"] = 0.72549019607843
		E.db["nameplates"]["reactions"]["tapped"]["g"] = 0.72549019607843
		E.db["nameplates"]["reactions"]["tapped"]["r"] = 0.72549019607843
		E.db["nameplates"]["reactions"]["bad"]["b"] = 0.050980392156863
		E.db["nameplates"]["reactions"]["bad"]["g"] = 0
		E.db["nameplates"]["reactions"]["bad"]["r"] = 0.93725490196078
		E.db["nameplates"]["reactions"]["neutral"]["b"] = 0.062745098039216
		E.db["nameplates"]["reactions"]["neutral"]["g"] = 0.81176470588235
		E.db["nameplates"]["reactions"]["neutral"]["r"] = 0.92156862745098
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["healthbar"]["enable"] = true
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["powerbar"]["height"] = 4
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["powerbar"]["height"] = 4
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["powerbar"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_NPC"]["healthbar"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["healthbar"]["text"]["format"] = "CURRENT_PERCENT"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["powerbar"]["height"] = 4
		E.db["nameplates"]["units"]["ENEMY_NPC"]["powerbar"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["enable"] = false
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 20
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["yOffset"] = 14
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 6
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["healthbar"]["text"]["enable"] = true
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["healthbar"]["text"]["format"] = "CURRENT_PERCENT"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["powerbar"]["height"] = 4
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["powerbar"]["enable"] = true
		E.db["nameplates"]["units"]["PLAYER"]["enable"] = true
		E.db["nameplates"]["units"]["PLAYER"]["alwaysShow"] = true
		E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["healthbar"]["width"] = 120
		E.db["nameplates"]["units"]["PLAYER"]["castbar"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["buffs"]["enable"] = false
		E.db["nameplates"]["units"]["PLAYER"]["clickthrough"] = true
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
		E.db["unitframe"]["units"]["player"]["pvp"]["text_format"] = "[pvptimer]"

		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 3
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
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
		E.db["sle"]["databars"]["artifact"]["longtext"] = true
		E.db["sle"]["databars"]["artifact"]["chatfilter"]["enable"] = true
		E.db["sle"]["databars"]["artifact"]["chatfilter"]["style"] = "STYLE2"
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
		E.db["sle"]["dt"]["currency"]["gold"]["direction"] = "reverced"
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
		E.db["sle"]["orderhall"]["autoOrder"]["enable"] = true
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
		E.db["sle"]["nameplates"]["showthreat"] = true
		E.db["sle"]["nameplates"]["targetcount"] = true
		E.db["sle"]["chat"]["editboxhistory"] = 10
		E.db["sle"]["chat"]["dpsSpam"] = true
		E.db["sle"]["chat"]["tab"]["select"] = true
		E.db["sle"]["datatexts"]["leftchat"]["width"] = 430
		E.db["sle"]["datatexts"]["panel7"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel7"]["width"] = 191
		E.db["sle"]["datatexts"]["panel7"]["transparent"] = true
		E.db["sle"]["datatexts"]["panel6"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel6"]["width"] = 421
		E.db["sle"]["datatexts"]["panel6"]["transparent"] = true
		E.db["sle"]["datatexts"]["rightchat"]["width"] = 430
		E.db["sle"]["datatexts"]["panel8"]["enabled"] = true
		E.db["sle"]["datatexts"]["panel8"]["width"] = 422
		E.db["sle"]["datatexts"]["panel8"]["transparent"] = true
		E.db["sle"]["unitframes"]["statusTextures"]["auraTexture"] = "Ohi Tribal4"
		E.db["sle"]["unitframes"]["statusTextures"]["castTexture"] = "Ohi Tribal4"
		E.db["sle"]["unitframes"]["statusTextures"]["classTexture"] = "ElvUI Gloss"
		E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["xoffset"] = 112
		E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["red"] = false
		E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["size"] = 32
		E.db["sle"]["unitframes"]["unit"]["player"]["combatico"]["yoffset"] = 5
		E.db["sle"]["unitframes"]["unit"]["player"]["portraitAlpha"] = 1
		E.db["sle"]["unitframes"]["unit"]["player"]["rested"]["xoffset"] = 208
		E.db["sle"]["unitframes"]["unit"]["player"]["rested"]["yoffset"] = -35
		E.db["sle"]["unitframes"]["unit"]["player"]["higherPortrait"] = true
		E.db["sle"]["unitframes"]["unit"]["target"]["higherPortrait"] = true
		E.db["sle"]["unitframes"]["unit"]["target"]["portraitAlpha"] = 1
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
		E.db["sle"]["Armory"]["Inspect"]["Level"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Inspect"]["Enchant"]["FontSize"] = 10
		E.db["sle"]["Armory"]["Character"]["Enchant"]["FontSize"] = 11
		E.db["sle"]["Armory"]["Character"]["Stats"]["IlvlColor"] = true
		E.db["sle"]["Armory"]["Character"]["Stats"]["IlvlFull"] = true
		E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["SPELLPOWER"] = true
		E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["HEALTH"] = true
		E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["POWER"] = true
		E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["MOVESPEED"] = true
		E.db["sle"]["Armory"]["Character"]["Durability"]["FontSize"] = 10
		E.db["sle"]["Armory"]["Character"]["Level"]["FontSize"] = 12
		E.db["sle"]["Armory"]["Character"]["Backdrop"]["SelectedBG"] = "TheEmpire"
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
		E.db["movers"]["ArtifactBarMover"] = "TOP,ElvUIParent,TOP,0,-20"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-3,188"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-220,186"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,98,-4"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-59,-299"
		E.db["movers"]["ShiftAB"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,761,138"
		E.db["movers"]["HonorBarMover"] = "TOP,ElvUIParent,TOP,0,-29"
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
		E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,153,199"
		E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-152,199"
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
		E.private["addonskins"]["EmbedOoC"] = true
		E.private["addonskins"]["EmbedOoCDelay"] = 5
		E.private["addonskins"]["Blizzard_AbilityButton"] = true
		E.private["addonskins"]["EmbedSystemDual"] = true
		E.private["addonskins"]["LoginMsg"] = false
		E.private["addonskins"]["Blizzard_ExtraActionButton"] = true
		E.private["addonskins"]["DBMFont"] = "PT Sans Narrow"
		E.private["addonskins"]["DBMSkinHalf"] = true
		
	end

	E.private["general"]["normTex"] = "Ohi MetalSheet"
	E.private["general"]["glossTex"] = "Ohi MetalSheet"
	E.private["general"]["minimap"]["hideClassHallReport"] = true

	E.private["sle"]["module"]["screensaver"] = true
	E.private["sle"]["uibuttons"]["style"] = "dropdown"
	E.private["sle"]["uibuttons"]["transparent"] = "Transparent"
	E.private["sle"]["bags"]["transparentSlots"] = true
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
	E.private["sle"]["actionbars"]["transparentButtons"] = true

	E.global["sle"]["advanced"]["optionsLimits"] = true
	E.global["sle"]["advanced"]["cyrillics"]["commands"] = true
	E.global["general"]["animateConfig"] = false

	if layout then
		if layout == 'tank' then
			E.db["nameplates"]["threat"]["beingTankedByTank"] = true
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Avoidance"
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Versatility"
			E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_ATTACKSPEED"] = true
		elseif layout == 'dpsMelee' then 
			E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "Attack Power"
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["SPELLPOWER"] = false
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_DAMAGE"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_AP"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ATTACK_ATTACKSPEED"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["ENERGY_REGEN"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["RUNE_REGEN"] = true
			E.db["sle"]["Armory"]["Character"]["Stats"]["List"]["FOCUS_REGEN"] = true
		elseif layout == 'healer' then DarthHeal() 
		end
		E.db.layoutSet = layout
	else
		E.db.layoutSet = "dpsCaster"
	end

	E.private["install_complete"] = installMark
	E.private["sle"]["install_complete"] = installMarkSLE

	E:UpdateAll(true)

	_G["PluginInstallStepComplete"].message = L["Darth's Default Set"]..": "..(PI.SLE_Word == NONE and L['Caster DPS'] or PI.SLE_Word)
	_G["PluginInstallStepComplete"]:Show()
end

function PI:DarthAddons()
	if SkadaDB and T.IsAddOnLoaded("Skada") then
		local damage, healing = locale == "ruRU" and "Нанесённый урон" or "Damage", locale == "ruRU" and "Исцеление" or "Healing"
		local profileName = "Darth "..(locale == "ruRU" and "Ru" or "Eng")
		SkadaDB["profiles"][profileName] = {
			["icon"] = {
				["hide"] = true,
			},
			["windows"] = {
				{
					["barslocked"] = true,
					["background"] = {
						["height"] = 164,
					},
					["barfont"] = "PT Sans Narrow",
					["name"] = "Damage",
					["point"] = "TOPRIGHT",
					["roleicons"] = true,
					["spark"] = false,
					["bartexture"] = "BuiOnePixel",
					["barwidth"] = 200.000061035156,
					["modeincombat"] = damage,
					["title"] = {
						["color"] = {
							["a"] = 0.800000011920929,
							["r"] = 0,
							["g"] = 0,
							["b"] = 0,
						},
						["font"] = "PT Sans Narrow",
						["texture"] = "ElvUI Norm",
					},
				}, -- [1]
				{
					["titleset"] = true,
					["barheight"] = 15,
					["classicons"] = true,
					["barslocked"] = true,
					["enabletitle"] = true,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["barfont"] = "PT Sans Narrow",
					["name"] = "Healing",
					["display"] = "bar",
					["barfontflags"] = "",
					["classcolortext"] = false,
					["scale"] = 1,
					["reversegrowth"] = false,
					["returnaftercombat"] = false,
					["roleicons"] = false,
					["barorientation"] = 1,
					["snapto"] = true,
					["version"] = 1,
					["modeincombat"] = healing,
					["spark"] = false,
					["bartexture"] = "BuiOnePixel",
					["barwidth"] = 237.999954223633,
					["barspacing"] = 0,
					["clickthrough"] = false,
					["barfontsize"] = 11,
					["barbgcolor"] = {
						["a"] = 0.6,
						["b"] = 0.3,
						["g"] = 0.3,
						["r"] = 0.3,
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 71.939697265625,
						["color"] = {
							["a"] = 0.2,
							["b"] = 0.5,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["barcolor"] = {
						["a"] = 1,
						["b"] = 0.8,
						["g"] = 0.3,
						["r"] = 0.3,
					},
					["classcolorbars"] = true,
					["title"] = {
						["color"] = {
							["a"] = 0.800000011920929,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["font"] = "PT Sans Narrow",
						["borderthickness"] = 2,
						["fontsize"] = 11,
						["fontflags"] = "",
						["height"] = 15,
						["margin"] = 0,
						["texture"] = "ElvUI Norm",
					},
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["point"] = "TOPRIGHT",
				}, -- [2]
			},
		}
		Skada.db:SetProfile(profileName)
	end
	if xCTSavedDB and T.IsAddOnLoaded("xCT+") then
		xCTSavedDB["profiles"]["S&L Darth"] = {
			["frames"] = {
				["general"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
				},
				["power"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
				},
				["healing"] = {
					["enableRealmNames"] = false,
					["enableClassNames"] = false,
					["fontOutline"] = "2OUTLINE",
					["enableOverHeal"] = false,
					["Width"] = 128,
					["Y"] = 63,
					["X"] = -209,
					["Height"] = 164,
					["showFriendlyHealers"] = false,
					["font"] = "PT Sans Narrow",
				},
				["outgoing"] = {
					["fontOutline"] = "2OUTLINE",
					["Width"] = 142,
					["Y"] = 71,
					["font"] = "PT Sans Narrow",
					["Height"] = 176,
					["X"] = 333,
				},
				["critical"] = {
					["fontOutline"] = "2OUTLINE",
					["Width"] = 150,
					["Y"] = 71,
					["font"] = "PT Sans Narrow",
					["Height"] = 174,
					["X"] = 481,
				},
				["procs"] = {
					["fontOutline"] = "2OUTLINE",
					["Y"] = -68,
					["font"] = "PT Sans Narrow",
					["enabledFrame"] = false,
					["X"] = -248,
				},
				["loot"] = {
					["fontSize"] = 12,
					["fontOutline"] = "2OUTLINE",
					["Y"] = -76,
					["font"] = "PT Sans Narrow",
					["X"] = 8,
				},
				["class"] = {
					["font"] = "PT Sans Narrow",
					["fontOutline"] = "2OUTLINE",
					["enabledFrame"] = false,
				},
				["damage"] = {
					["X"] = -339,
					["Y"] = 65,
					["font"] = "PT Sans Narrow",
					["fontOutline"] = "2OUTLINE",
				},
			},
		}
		xCT_Plus.db:SetProfile("S&L Darth")
	end

	_G["PluginInstallStepComplete"].message = L["Addons settings imported"]
	_G["PluginInstallStepComplete"]:Show()
end

local function AffinityAddons()
	if SkadaDB and T.IsAddOnLoaded("Skada") then
		SkadaDB["profiles"]["Affinitii"] = {
			["windows"] = {
				{
					["barheight"] = 17,
					["barslocked"] = true,
					["background"] = {
						["height"] = 133.6666717529297,
						["color"] = {
							["a"] = 0.2000000476837158,
							["b"] = 0,
						},
					},
					["hidden"] = true,
					["y"] = 39.89817468303028,
					["x"] = -7.334928625263729,
					["title"] = {
						["color"] = {
							["a"] = 1,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["font"] = "ElvUI Font",
						["fontsize"] = 15,
					},
					["point"] = "BOTTOMRIGHT",
					["barbgcolor"] = {
						["a"] = 1,
						["b"] = 0.3019607843137255,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["barcolor"] = {
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["name"] = "HPS",
					["spark"] = false,
					["bartexture"] = "Polished Wood",
					["barwidth"] = 199.0832316080729,
					["barfontsize"] = 12,
					["mode"] = "Damage",
					["barfont"] = "ElvUI Font",
				}, -- [1]
				{
					["barheight"] = 17,
					["classicons"] = true,
					["barslocked"] = true,
					["clickthrough"] = false,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = true,
					["y"] = 39.89824908834681,
					["barfont"] = "ElvUI Font",
					["name"] = "DPS",
					["display"] = "bar",
					["barfontflags"] = "",
					["classcolortext"] = false,
					["scale"] = 1,
					["reversegrowth"] = false,
					["barfontsize"] = 12,
					["barorientation"] = 1,
					["snapto"] = true,
					["point"] = "BOTTOMRIGHT",
					["x"] = -214.2783479639852,
					["spark"] = false,
					["bartexture"] = "Polished Wood",
					["barwidth"] = 199.0832316080729,
					["barspacing"] = 0,
					["barbgcolor"] = {
						["a"] = 1,
						["b"] = 0.3019607843137255,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["returnaftercombat"] = false,
					["barcolor"] = {
						["a"] = 1,
						["b"] = 0.8,
						["g"] = 0.3019607843137255,
						["r"] = 0.3019607843137255,
					},
					["mode"] = "Healing",
					["enabletitle"] = true,
					["classcolorbars"] = true,
					["modeincombat"] = "",
					["title"] = {
						["borderthickness"] = 2,
						["font"] = "ElvUI Font",
						["fontsize"] = 15,
						["fontflags"] = "",
						["color"] = {
							["a"] = 1,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Aluminium",
					},
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 133.6666717529297,
						["color"] = {
							["a"] = 0.2000000476837158,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
				}, -- [2]
			},
			["report"] = {
				["number"] = 12,
				["chantype"] = "whisper",
				["channel"] = "whisper",
				["target"] = "Affinitii",
				["mode"] = "Riggimon's Death",
			},
			["icon"] = {
				["minimapPos"] = 160.4361246854299,
				["hide"] = true,
			},
		}
		Skada.db:SetProfile("Affinitii")
	end
	if xCTSavedDB and T.IsAddOnLoaded("xCT+") then
		xCTSavedDB["profiles"]["Affinitii"] = {
			["blizzardFCT"] = {
				["font"] = "KGSmallTownSouthernGirl",
			},
			["spells"] = {
				["mergeCriticalsByThemselves"] = true,
				["mergeDontMergeCriticals"] = false,
			},
			["frames"] = {
				["general"] = {
					["showBuffs"] = false,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 510,
					["font"] = "KGSmallTownSouthernGirl",
					["enabledFrame"] = false,
					["Height"] = 127,
				},
				["power"] = {
					["enabledFrame"] = false,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 255,
					["font"] = "KGSmallTownSouthernGirl",
				},
				["healing"] = {
					["enabledFrame"] = false,
					["Width"] = 382,
					["Y"] = 89,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 143,
					["fontOutline"] = "2OUTLINE",
					["X"] = -319,
				},
				["outgoing"] = {
					["fontSize"] = 17,
					["fontOutline"] = "2OUTLINE",
					["enableScrollable"] = true,
					["Width"] = 149,
					["Y"] = -61,
					["X"] = 901,
					["iconsSize"] = 17,
					["font"] = "KGSmallTownSouthernGirl",
				},
				["critical"] = {
					["fontSize"] = 17,
					["iconsSize"] = 19,
					["fontOutline"] = "2OUTLINE",
					["Width"] = 149,
					["Y"] = 102,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 126,
					["X"] = 901,
				},
				["procs"] = {
					["enabledFrame"] = false,
					["enableScrollable"] = true,
					["Y"] = 101,
					["X"] = 1,
					["Height"] = 127,
					["font"] = "KGSmallTownSouthernGirl",
					["fontOutline"] = "2OUTLINE",
				},
				["loot"] = {
					["fontOutline"] = "2OUTLINE",
					["Width"] = 510,
					["Y"] = -223,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 126,
				},
				["class"] = {
					["fontOutline"] = "2OUTLINE",
					["font"] = "KGSmallTownSouthernGirl",
					["enabledFrame"] = false,
				},
				["damage"] = {
					["fontSize"] = 17,
					["X"] = 201,
					["Width"] = 133,
					["Y"] = -32,
					["font"] = "KGSmallTownSouthernGirl",
					["Height"] = 170,
					["fontOutline"] = "2OUTLINE",
				},
			},
		}
		xCT_Plus.db:SetProfile("Affinitii")
	end
end

local function SetupCVars()
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
end

local function AffinitySetup()
	local layout = E.db.layoutSet
	local installMark = E.private["install_complete"]
	local installMarkSLE = E.private["sle"]["install_complete"]
	pixel = E.PixelMode  --Pull PixelMode

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

	E.db["sle"]["nameplates"]["showthreat"] = true
	E.db["sle"]["nameplates"]["targetcount"] = true
	E.db["sle"]["datatexts"]["chathandle"] = true
	E.db["sle"]["datatexts"]["panel3"]["enabled"] = true
	E.db["sle"]["datatexts"]["panel3"]["transparent"] = true
	E.db["sle"]["datatexts"]["panel3"]["width"] = 100
	E.db["sle"]["datatexts"]["panel5"]["width"] = 100
	-- E.db["sle"]["datatexts"]["panel6"]["enabled"] = true
	E.db["sle"]["datatexts"]["panel7"]["enabled"] = true
	E.db["sle"]["datatexts"]["panel7"]["transparent"] = true
	E.db["sle"]["datatexts"]["panel7"]["width"] = 100
	E.db["sle"]["datatexts"]["panel8"]["enabled"] = true
	E.db["sle"]["datatexts"]["panel8"]["transparent"] = true
	E.db["sle"]["datatexts"]["panel8"]["alpha"] = 0.8
	E.db["sle"]["datatexts"]["panel8"]["width"] = 399
	E.db["sle"]["minimap"]["buttons"]["anchor"] = "VERTICAL"
	E.db["sle"]["minimap"]["buttons"]["mouseover"] = true
	E.db["sle"]["minimap"]["mapicons"]["skinmail"] = false
	E.db["sle"]["minimap"]["mapicons"]["iconmouseover"] = true

	SLE:SetMoverPosition("SLE_DataPanel_8_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 3)
	SLE:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 96)
	SLE:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 21)
	SLE:SetMoverPosition("ElvUF_RaidMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 449, 511)
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
	SLE:SetMoverPosition("SLE_DataPanel_6_Mover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 4, 327)
	SLE:SetMoverPosition("SLE_DataPanel_3_Mover", "BOTTOM", ElvUIParent, "BOTTOM", -254, 3)
	SLE:SetMoverPosition("BossHeaderMover", "BOTTOMRIGHT", ElvUIParent, "BOTTOMRIGHT", -210, 435)
	SLE:SetMoverPosition("ElvUF_PetMover", "BOTTOM", ElvUIParent, "BOTTOM", 0, 230)
	SLE:SetMoverPosition("ElvAB_6", "BOTTOM", ElvUIParent, "BOTTOM", 0, 102)
	SLE:SetMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", ElvUIParent, "BOTTOMLEFT", 449, 511)
	SLE:SetMoverPosition("SLE_DataPanel_7_Mover", "BOTTOM", ElvUIParent, "BOTTOM", 254, 3)
	SLE:SetMoverPosition("PetAB", "TOPRIGHT", ElvUIParent, "TOPRIGHT", -4, -433)

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
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMRIGHT"
	E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "BOTTOM"
	E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["party"]["power"]["width"] = "inset"
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"] = {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["Health Text"]["font"] = "ElvUI Pixel"
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
	E.db["unitframe"]["units"]["raid40"]["customTexts"]["Health Text"]["font"] = "ElvUI Pixel"
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
	E.db["datatexts"]["panels"]["SLE_DataPanel_4"]["middle"] = "DPS"
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = "Skada"
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = "Combat/Arena Time"
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Haste"
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = "Spell/Heal Power"
	E.db["datatexts"]["panels"]["RightMiniPanel"] = "Gold"
	E.db["datatexts"]["panels"]["SLE_DataPanel_3"] = "WIM"
	E.db["datatexts"]["panels"]["SLE_DataPanel_7"] = "Talent/Loot Specialization"
	E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["right"] = "Gold"
	E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["left"] = "System"
	E.db["datatexts"]["panels"]["SLE_DataPanel_8"]["middle"] = "Time"
	E.db["datatexts"]["panels"]["LeftMiniPanel"] = "Time"
	E.db["datatexts"]["font"] = "ElvUI Font"
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
	
	_G["PluginInstallStepComplete"].message = L["Affinitii's Default Set"]
	_G["PluginInstallStepComplete"]:Show()
end

E.PopupDialogs['SLE_INSTALL_SETTINGS_LAYOUT'] = {
	text = L["SLE_INSTALL_SETTINGS_LAYOUT_TEXT"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		if PI.SLE_Auth == "DARTH" then
			PI:DarthSetup()
		elseif PI.SLE_Auth == "AFFINITY" then
			AffinitySetup()
		end
	end,
	OnCancel = E.noop;
}

E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		if PI.SLE_Auth == "DARTH" then
			PI:DarthAddons()
		elseif PI.SLE_Auth == "AFFINITY" then
			AffinityAddons()
		end
	end,
	OnCancel = E.noop;
}

local function StartSetup()
	if PI.SLE_Auth == "DARTH" then
		E:StaticPopup_Show("SLE_INSTALL_SETTINGS_LAYOUT")
	elseif PI.SLE_Auth == "REPOOC" then
	elseif PI.SLE_Auth == "AFFINITY" then
		E:StaticPopup_Show("SLE_INSTALL_SETTINGS_LAYOUT")
	end
end

local function SetupAddons()
	if PI.SLE_Auth == "DARTH" then
		local list = "Skada\nxCT+"
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = T.format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
	elseif PI.SLE_Auth == "AFFINITY" then
		local list = "Skada\nxCT+"
		E.PopupDialogs['SLE_INSTALL_SETTINGS_ADDONS'].text = T.format(L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"], list)
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
			local KF, Info, Timer = T.unpack(_G["ElvUI_KnightFrame"])
			_G["PluginInstallFrame"].SubTitle:SetText(L["Armory Mode"])
			_G["PluginInstallFrame"].Desc1:SetText(L["SLE_ARMORY_INSTALL"])
			_G["PluginInstallFrame"].Desc2:SetText(L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffFF0000Low|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', function() E.db.sle.Armory.Character.Enable = true; E.db.sle.Armory.Inspect.Enable = true; KF.Modules.CharacterArmory() end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() E.db.sle.Armory.Character.Enable = false; E.db.sle.Armory.Inspect.Enable = false; KF.Modules.CharacterArmory() end)
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
				E.private.sle.module.blizzmove = true;
				_G["PluginInstallStepComplete"].message = L["Move Blizzard frames"].." ".."Set to |cff00FF00"..ENABLE.."|r"
				_G["PluginInstallStepComplete"]:Show()
			end)
			_G["PluginInstallFrame"].Option1:SetText(ENABLE)

			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function()
				E.private.sle.module.blizzmove = false;
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
			
			_G["PluginInstallFrame"].Option2:Show()
			_G["PluginInstallFrame"].Option2:SetScript('OnClick', function() PI.SLE_Auth = "AFFINITY"; _G["PluginInstallFrame"].Next:Click() end)
			_G["PluginInstallFrame"].Option2:SetText(L["Affinitii's Config"])

			_G["PluginInstallFrame"]:Size(550, 500)
		end,
		[6] = function()
			if PI.SLE_Auth == "" then _G["PluginInstallFrame"].SetPage(_G["PluginInstallFrame"].PrevPage == 5 and 7 or 5) return end
			PI.SLE_Word = E.db.layoutSet == 'tank' and L["Tank"] or E.db.layoutSet == 'healer' and L["Healer"] or E.db.layoutSet == 'dpsMelee' and L['Physical DPS'] or E.db.layoutSet == 'dpsCaster' and L['Caster DPS'] or NONE
			_G["PluginInstallFrame"].SubTitle:SetText(L["Layout & Settings Import"])
			_G["PluginInstallFrame"].Desc1:SetText(T.format(L["You have selected to use %s and role %s."], PI.SLE_Auth == "DARTH" and L["Darth's Config"] or PI.SLE_Auth == "REPOOC" and L["Repooc's Config"] or PI.SLE_Auth == "AFFINITY" and L["Affinitii's Config"], PI.SLE_Word))
			_G["PluginInstallFrame"].Desc2:SetText(L["SLE_INSTALL_LAYOUT_TEXT2"])
			_G["PluginInstallFrame"].Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])

			_G["PluginInstallFrame"].Option1:Show()
			_G["PluginInstallFrame"].Option1:SetScript('OnClick', StartSetup)
			_G["PluginInstallFrame"].Option1:SetText(L["Layout"])

			if PI.SLE_Auth == "DARTH" or PI.SLE_Auth == "AFFINITY" then
				_G["PluginInstallFrame"].Option2:Show()
				_G["PluginInstallFrame"].Option2:SetScript('OnClick', SetupAddons)
				_G["PluginInstallFrame"].Option2:SetText(ADDONS)
			end
			if PI.SLE_Auth == "DARTH" then
				_G["PluginInstallFrame"].Option3:Show()
				_G["PluginInstallFrame"].Option3:SetScript('OnClick', SetupCVars)
				_G["PluginInstallFrame"].Option3:SetText(L["CVars"])
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

-- SLE.installTable2 = {
	-- ["Name"] = "S&L2",
	-- ["tutorialImage"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SLE_Banner]],
	-- ["Pages"] = {
		-- [1] = function()
			-- _G["PluginInstallFrame"].SubTitle:SetText(format(L["Welcome to |cff1784d1Shadow & Light|r 42342 version %s!"], SLE.version))
			-- _G["PluginInstallFrame"].Desc1:SetText(L["This will take you through a quick install process to setup some Shadow & Light features.\nIf you choose to not setup any options through this config, click Skip Process button to finish the installation."])
			-- _G["PluginInstallFrame"].Desc2:SetText("")
			-- _G["PluginInstallFrame"].Desc3:SetText(L["Please press the continue button to go onto the next step."])

			-- _G["PluginInstallFrame"].Option1:Show()
			-- _G["PluginInstallFrame"].Option1:SetScript("OnClick", InstallComplete)
			-- _G["PluginInstallFrame"].Option1:SetText(L["Skip Process"])
		-- end,
	-- },
-- }

