local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

local function DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	SLEInstallStepComplete.message = L["Darth's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	if not E.db.loclite then E.db.loclite = {} end

	local layout = E.db.layoutSet --To know if some sort of layout was choosed before

	if SLE:Auth() then
		E.db.hideTutorial = 1
		E.db.general.loginmessage = false
	end
	
	E:UpdateAll(true)
end

local function RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
	SLEInstallStepComplete.message = L["Repooc's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end

	local layout = E.db.layoutSet  --Pull which layout was selected if any.
	pixel = E.PixelMode  --Pull PixelMode

	E.db.hideTutorial = 1 --5.4

	E.db.general.autoAcceptInvite = true --5.4
--	E.db.general.autoRepair = "GUILD"
	E.db.general.autoRoll = false --5.4
--	E.db.general.backdropfadecolor = {["r"] = 0.054,["g"] = 0.054,["b"] = 0.054,}
	E.db.general.bordercolor = {["r"] = 0.31,["g"] = 0.31,["b"] = 0.31,} --5.4
	E.db.general.bottomPanel = true --5.4
	E.db.general.experience.orientation = "VERTICAL"
	E.db.general.experience.height = 180 --5.4
	E.db.general.experience.width = 10 --5.4
	E.db.general.interruptAnnounce = "RAID" --5.4
	E.db.general.minimap.locationText = "SHOW" --5.4
--	E.db.general.health = {}
--	E.db.general.BUFFS = {}
	E.db.general.reputation.orientation = "VERTICAL"
	E.db.general.reputation.height = 180 --5.4
	E.db.general.reputation.orientation = "VERTICAL" --5.4
	E.db.general.reputation.width = 10 --5.4
--	E.db.general.threat.position = "LEFTCHAT"
	E.db.general.topPanel = true --5.4
	E.db.general.valuecolor = {["r"] = 0.09,["g"] = 0.513,["b"] = 0.819,} --5.4
	E.db.general.vendorGrays = true --5.4

	--SLE Configs
	E.private.sle.characterframeoptions.enable = true --5.4
	E.private.sle.exprep.autotrack = true --5.4
	E.private.sle.farm.enable = true --5.4
	E.db.sle.characterframeoptions.itemdurability.font = "ElvUI Font" --5.4
	E.db.sle.characterframeoptions.itemdurability.fontSize = 12 --5.4
	E.db.sle.characterframeoptions.itemdurability.fontOutline = "OUTLINE" --5.4
	E.db.sle.characterframeoptions.itemlevel.font = "ElvUI Alt-Font" --5.4
	E.db.sle.characterframeoptions.itemlevel.fontOutline = "THICKOUTLINE" --5.4
	E.db.sle.characterframeoptions.itemlevel.fontSize = 12 --5.4
	E.db.sle.datatext.bottom.enabled = false --5.4
	E.db.sle.datatext.chatleft.width = 396 --5.4
	E.db.sle.datatext.chatright.width = 396 --5.4
	E.db.sle.datatext.dp1.enabled = false --5.4
	E.db.sle.datatext.dp2.enabled = false --5.4
	E.db.sle.datatext.dp3.enabled = false --5.4
	E.db.sle.datatext.dp4.enabled = false --5.4
	E.db.sle.datatext.dp5.enabled = false --5.4
	E.db.sle.datatext.dp6.enabled = false --5.4
	E.db.sle.datatext.top.enabled = false --5.4
	E.db.sle.dt.friends.hide_hintline = true --5.4
	E.db.sle.dt.friends.sortBN = "REALID" --5.4
	E.db.sle.dt.guild.hide_hintline = true --5.4
	E.db.sle.dt.guild.sortGuild = "revRANKINDEX" --5.4
	E.db.sle.farm.autotarget = true --5.4
	E.db.sle.minimap.enable = true --5.4
	E.db.sle.minimap.buttons.anchor = "HORIZONTAL" --5.4
	E.db.sle.minimap.coords.middle = "CENTER" --5.4
	E.db.sle.uibuttons.enable = true --5.4
	E.db.sle.uibuttons.position = "uib_hor" --5.4
	E.db.sle.uibuttons.size = 17 --5.4

	E.private.general.pixelPerfect = true --5.4
	E.private.general.normTex = "Minimalist" --5.4
	E.private.general.glossTex = "Minimalist" --5.4
	
	--Addon Skins
	if IsAddOnLoaded("ElvUI_AddOnSkins") then
		E.private.addonskins.EmbedSkada = true --5.4
		E.private.addonskins.EmbedalDamageMeter = false --5.4
		E.private.addonskins.EmbedSystemDual = true --5.4
	end


--	E.db.gridSize = 110
--	E.db.tooltip.style = "inset"

	--Chat
	E.db.chat.editBoxPosition = "ABOVE_CHAT" --5.4
	E.db.chat.hyperlinkHover = false --5.4
	E.db.chat.panelTabTransparency = true --5.4
	if GetScreenWidth() < 1920 then --5.4
		E.db.chat.panelWidth = 380
	else
		E.db.chat.panelWidth = 412
	end
	E.db.chat.timeStampFormat = "%I:%M %p " --5.4

	--Unitframes
	E.db.unitframe.smartRaidFilter = true
	E.db.unitframe.font = "KGSmallTownSouthernGirl"
	E.db.unitframe.fontOutline = "OUTLINE"
	E.db.unitframe.fontSize = 12
	E.db.unitframe.statusbar = "Polished Wood"
	E.db.unitframe.colors.healthclass = false
	E.db.unitframe.colors.castColor = {["r"] = 0.1,["g"] = 0.1,["b"] = 0.1,}
	E.db.unitframe.colors.health = {["r"] = 0.2352941176470588,["g"] = 0.2352941176470588,["b"] = 0.2352941176470588,}
	E.db.unitframe.colors.auraBarBuff = {["b"] = 0.09411764705882353,["g"] = 0.07843137254901961,["r"] = 0.3098039215686275,}
	E.db.unitframe.colors.transparentPower = true
	E.db.unitframe.colors.transparentHealth = true
	E.db.unitframe.colors.colorhealthbyvalue = false
	E.db.unitframe.colors.customhealthbackdrop = true
	E.db.unitframe.colors.health_backdrop = {["r"] = 0.7333333333333333,["g"] = 0,["b"] = 0.01176470588235294,}

	E.db.unitframe.units.tank.enable = false

	E.db.unitframe.units.assist.enable = false
	E.db.unitframe.units.assist.targetsGroup.enable = false

	E.db.unitframe.units.arena.power.width = "inset"
	E.db.unitframe.units.arena.power.offset = 0

	E.db.unitframe.units.targettarget.power.width = "inset"
	E.db.unitframe.units.targettarget.power.offset = 0
	E.db.unitframe.units.targettarget.width = 190
	E.db.unitframe.units.targettarget.health.xOffset = 5
	E.db.unitframe.units.targettarget.health.text_format = "[healthcolor][health:current]"
	E.db.unitframe.units.targettarget.health.position = "TOPRIGHT"

	E.db.unitframe.units.pet.power.width = "inset"
	E.db.unitframe.units.pet.power.offset = 0

	E.db.unitframe.units.pettarget.power.width = "inset"
	E.db.unitframe.units.pettarget.power.offset = 0

	E.db.unitframe.units.boss.portrait.enable = true
	E.db.unitframe.units.boss.portrait.overlay = true
	E.db.unitframe.units.boss.power.width = "inset"
	E.db.unitframe.units.boss.power.offset = 0

	E.db.unitframe.units.focus.power.width = "inset"
	E.db.unitframe.units.focus.power.offset = 0
	E.db.unitframe.units.focus.health.text_format = "[healthcolor][health:current]"

	E.db.unitframe.units.player.debuffs.attachTo = "FRAME"
	E.db.unitframe.units.player.debuffs.sizeOverride = 25
	E.db.unitframe.units.player.debuffs.yOffset = 2
	E.db.unitframe.units.player.portrait.overlay = true
	E.db.unitframe.units.player.portrait.enable = true
	E.db.unitframe.units.player.classbar.enable = false
	E.db.unitframe.units.player.classbar.height = 7
	E.db.unitframe.units.player.classbar.fill = "spaced"
	E.db.unitframe.units.player.aurabar.enable = false
	E.db.unitframe.units.player.power.width = "inset"
	E.db.unitframe.units.player.power.offset = 0
	E.db.unitframe.units.player.power.position = "LEFT"
	E.db.unitframe.units.player.width = 404
	E.db.unitframe.units.player.name.text_format = "[namecolor][name]"
	E.db.unitframe.units.player.buffs.enable = true
	E.db.unitframe.units.player.buffs.attachTo = "FRAME"
	E.db.unitframe.units.player.buffs.noDuration = false
	E.db.unitframe.units.player.buffs.yOffset = 4
	E.db.unitframe.units.player.buffs.xOffset = -2
	E.db.unitframe.units.player.buffs.anchorPoint = "LEFT"
	E.db.unitframe.units.player.buffs.numrows = 3
	E.db.unitframe.units.player.buffs.perrow = 3
	E.db.unitframe.units.player.buffs.sizeOverride = 25
	E.db.unitframe.units.player.castbar.width = 404
	E.db.unitframe.units.player.castbar.height = 20
	E.db.unitframe.units.player.castbar.latency = false
	E.db.unitframe.units.player.height = 36
	E.db.unitframe.units.player.health.position = "RIGHT"

	E.db.unitframe.units.target.portrait.enable = true
	E.db.unitframe.units.target.portrait.overlay = true
	E.db.unitframe.units.target.aurabar.enable = false
	E.db.unitframe.units.target.power.width = "inset"
	E.db.unitframe.units.target.power.offset = 0
	E.db.unitframe.units.target.power.position = "RIGHT"
	E.db.unitframe.units.target.debuffs.sizeOverride = 25
	E.db.unitframe.units.target.debuffs.attachTo = "FRAME"
	E.db.unitframe.units.target.debuffs.yOffset = 2
	E.db.unitframe.units.target.castbar.height = 20
	E.db.unitframe.units.target.castbar.width = 404
	E.db.unitframe.units.target.width = 404
	E.db.unitframe.units.target.height = 36
	E.db.unitframe.units.target.health.position = "LEFT"
	E.db.unitframe.units.target.buffs.sizeOverride = 25
	E.db.unitframe.units.target.buffs.anchorPoint = "RIGHT"
	E.db.unitframe.units.target.buffs.numrows = 3
	E.db.unitframe.units.target.buffs.perrow = 3
	E.db.unitframe.units.target.buffs.yOffset = 4
	E.db.unitframe.units.target.buffs.xOffset = 2

	E.db.unitframe.units.focustarget.power.width = "inset"
	E.db.unitframe.units.focustarget.power.offset = 0

	if not E.db.unitframe.units.party.customTexts then
		E.db.unitframe.units.party.customTexts = {};
		if not E.db.unitframe.units.party.customTexts["Health Text"] then
			E.db.unitframe.units.party.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.party.customTexts["Health Text"] = {
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.party.debuffs.xOffset = -4
	E.db.unitframe.units.party.debuffs.yOffset = -7
	E.db.unitframe.units.party.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.party.debuffs.sizeOverride = 21
	E.db.unitframe.units.party.columnAnchorPoint = "BOTTOM"
	E.db.unitframe.units.party.point = "RIGHT"
	E.db.unitframe.units.party.xOffset = -1
	E.db.unitframe.units.party.yOffset = 1
	E.db.unitframe.units.party.power.width = "inset"
	E.db.unitframe.units.party.power.offset = 0
	E.db.unitframe.units.party.power.text_format = ""
	E.db.unitframe.units.party.buffIndicator.size = 10
	E.db.unitframe.units.party.roleIcon.enable = false
	E.db.unitframe.units.party.roleIcon.position = "BOTTOMRIGHT"
	E.db.unitframe.units.party.GPSArrow.size = 40
	E.db.unitframe.units.party.growthDirection = "RIGHT_DOWN"
	E.db.unitframe.units.party.startOutFromCenter = true
	E.db.unitframe.units.party.healPrediction = true
	E.db.unitframe.units.party.health.frequentUpdates = true
	E.db.unitframe.units.party.health.text_format = ""
	E.db.unitframe.units.party.health.position = "BOTTOM"
	E.db.unitframe.units.party.health.orientation = "VERTICAL"
	E.db.unitframe.units.party.name.text_format = "[namecolor][name:short] [difficultycolor][smartlevel]"
	E.db.unitframe.units.party.name.position = "TOP"
	E.db.unitframe.units.party.buffs.noConsolidated = false
	E.db.unitframe.units.party.buffs.enable = true
	E.db.unitframe.units.party.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.party.buffs.clickThrough = true
	E.db.unitframe.units.party.buffs.useBlacklist = false
	E.db.unitframe.units.party.buffs.noDuration = false
	E.db.unitframe.units.party.buffs.playerOnly = false
	E.db.unitframe.units.party.buffs.perrow = 1
	E.db.unitframe.units.party.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.party.buffs.yOffset = 28
	E.db.unitframe.units.party.buffs.xOffset = 30
	E.db.unitframe.units.party.buffs.sizeOverride = 22
	E.db.unitframe.units.party.petsGroup.anchorPoint = "TOP"
	E.db.unitframe.units.party.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.party.raidicon.xOffset = 9
	E.db.unitframe.units.party.raidicon.size = 13
	E.db.unitframe.units.party.raidicon.yOffset = 0
	E.db.unitframe.units.party.targetsGroup.anchorPoint = "TOP"
	E.db.unitframe.units.party.width = 80
	E.db.unitframe.units.party.height = 45
	E.db.unitframe.units.party.groupBy = "GROUP"
	E.db.unitframe.units.party.visibility = "[@raid6,exists] hide;show"

	if not E.db.unitframe.units.raid10.customTexts then
		E.db.unitframe.units.raid10.customTexts = {};
		if not E.db.unitframe.units.raid10.customTexts["Health Text"] then
			E.db.unitframe.units.raid10.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.raid10.customTexts["Health Text"] = {
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid10.columnAnchorPoint = "BOTTOM"
	E.db.unitframe.units.raid10.point = "RIGHT"
	E.db.unitframe.units.raid10.rdebuffs.enable = false
	E.db.unitframe.units.raid10.yOffset = 4
	E.db.unitframe.units.raid10.xOffset = -1
	E.db.unitframe.units.raid10.roleIcon.enable = false
	E.db.unitframe.units.raid10.power.width = "inset"
	E.db.unitframe.units.raid10.power.offset = 0
	E.db.unitframe.units.raid10.growthDirection = "RIGHT_DOWN"
	E.db.unitframe.units.raid10.startOutFromCenter = true
	E.db.unitframe.units.raid10.healPrediction = true
	E.db.unitframe.units.raid10.health.frequentUpdates = true
	E.db.unitframe.units.raid10.health.text_format = ""
	E.db.unitframe.units.raid10.health.orientation = "VERTICAL"
	E.db.unitframe.units.raid10.debuffs.enable = true
	E.db.unitframe.units.raid10.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.raid10.buffs.enable = true
	E.db.unitframe.units.raid10.buffs.noConsolidated = false
	E.db.unitframe.units.raid10.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.raid10.buffs.clickThrough = true
	E.db.unitframe.units.raid10.buffs.useBlacklist = false
	E.db.unitframe.units.raid10.buffs.noDuration = false
	E.db.unitframe.units.raid10.buffs.playerOnly = false
	E.db.unitframe.units.raid10.buffs.perrow = 1
	E.db.unitframe.units.raid10.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.raid10.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.raid10.raidicon.xOffset = 9
	E.db.unitframe.units.raid10.raidicon.size = 13
	E.db.unitframe.units.raid10.raidicon.yOffset = 0
	E.db.unitframe.units.raid10.name.text_format = "[namecolor][name:short]"
	E.db.unitframe.units.raid10.debuffs.sizeOverride = 21
	E.db.unitframe.units.raid10.debuffs.xOffset = -4
	E.db.unitframe.units.raid10.debuffs.yOffset = -7
	E.db.unitframe.units.raid10.height = 45
	E.db.unitframe.units.raid10.width = 80
	E.db.unitframe.units.raid10.buffs.yOffset = 28
	E.db.unitframe.units.raid10.buffs.xOffset = 30
	E.db.unitframe.units.raid10.buffs.sizeOverride = 22
	E.db.unitframe.units.raid10.groupBy = "GROUP"

	if not E.db.unitframe.units.raid25.customTexts then
		E.db.unitframe.units.raid25.customTexts = {};
		if not E.db.unitframe.units.raid25.customTexts["Health Text"] then
			E.db.unitframe.units.raid25.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.raid25.customTexts["Health Text"] = {
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid25.columnAnchorPoint = "RIGHT"
	E.db.unitframe.units.raid25.point = "BOTTOM"
	E.db.unitframe.units.raid25.rdebuffs.enable = false
	E.db.unitframe.units.raid25.xOffset = 1
	E.db.unitframe.units.raid25.roleIcon.enable = false
	E.db.unitframe.units.raid25.power.offset = 0
	E.db.unitframe.units.raid25.power.width = "inset"
	E.db.unitframe.units.raid25.power.position = "CENTER"
	E.db.unitframe.units.raid25.growthDirection = "RIGHT_DOWN"
	E.db.unitframe.units.raid25.startOutFromCenter = true
	E.db.unitframe.units.raid25.healPrediction = true
	E.db.unitframe.units.raid25.health.frequentUpdates = true
	E.db.unitframe.units.raid25.health.text_format = ""
	E.db.unitframe.units.raid25.health.orientation = "VERTICAL"
	E.db.unitframe.units.raid25.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.raid25.debuffs.enable = true
	E.db.unitframe.units.raid25.debuffs.xOffset = -4
	E.db.unitframe.units.raid25.debuffs.yOffset = -7
	E.db.unitframe.units.raid25.debuffs.sizeOverride = 21
	E.db.unitframe.units.raid25.debuffs.countFontSize = 12
	E.db.unitframe.units.raid25.debuffs.fontSize = 9
	E.db.unitframe.units.raid25.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.raid25.raidicon.xOffset = 9
	E.db.unitframe.units.raid25.raidicon.yOffset = 0
	E.db.unitframe.units.raid25.raidicon.size = 13
	E.db.unitframe.units.raid25.buffs.noConsolidated = false
	E.db.unitframe.units.raid25.buffs.enable = true
	E.db.unitframe.units.raid25.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.raid25.buffs.clickThrough = true
	E.db.unitframe.units.raid25.buffs.useBlacklist = false
	E.db.unitframe.units.raid25.buffs.noDuration = false
	E.db.unitframe.units.raid25.buffs.playerOnly = false
	E.db.unitframe.units.raid25.buffs.perrow = 1
	E.db.unitframe.units.raid25.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.raid25.name.text_format = "[namecolor][name:short]"
	E.db.unitframe.units.raid25.yOffset = 4
	E.db.unitframe.units.raid25.width = 80
	E.db.unitframe.units.raid25.height = 40
	E.db.unitframe.units.raid25.buffs.yOffset = 28
	E.db.unitframe.units.raid25.buffs.xOffset = 30
	E.db.unitframe.units.raid25.buffs.sizeOverride = 22
	E.db.unitframe.units.raid25.groupBy = "GROUP"

	if not E.db.unitframe.units.raid40.customTexts then
		E.db.unitframe.units.raid40.customTexts = {};
		if not E.db.unitframe.units.raid40.customTexts["Health Text"] then
			E.db.unitframe.units.raid40.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.raid40.customTexts["Health Text"] = {
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid40.columnAnchorPoint = "RIGHT"
	E.db.unitframe.units.raid40.point = "BOTTOM"
	E.db.unitframe.units.raid40.xOffset = 1
	E.db.unitframe.units.raid40.yOffset = 1
	E.db.unitframe.units.raid40.growthDirection = "RIGHT_DOWN"
	E.db.unitframe.units.raid40.startOutFromCenter = true
	E.db.unitframe.units.raid40.healPrediction = true
	E.db.unitframe.units.raid40.width = 48
	E.db.unitframe.units.raid40.height = 43
	E.db.unitframe.units.raid40.raidicon.xOffset = 9
	E.db.unitframe.units.raid40.raidicon.yOffset = 0
	E.db.unitframe.units.raid40.raidicon.size = 13
	E.db.unitframe.units.raid40.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.raid40.rdebuffs.size = 26
	E.db.unitframe.units.raid40.name.position = "TOP"
	E.db.unitframe.units.raid40.name.text_position = "[namecolor][name:short]"
	E.db.unitframe.units.raid40.power.enable = true
	E.db.unitframe.units.raid40.power.offset = 0
	E.db.unitframe.units.raid40.power.width = "inset"
	E.db.unitframe.units.raid40.power.position = "CENTER"
	E.db.unitframe.units.raid40.health.frequentUpdates = true
	E.db.unitframe.units.raid40.health.orientation = "VERTICAL"
	E.db.unitframe.units.raid40.debuffs.sizeOverride = 21
	E.db.unitframe.units.raid40.debuffs.enable = true
	E.db.unitframe.units.raid40.debuffs.perrow = 2
	E.db.unitframe.units.raid40.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.raid40.debuffs.clickThrough = true
	E.db.unitframe.units.raid40.debuffs.xOffset = -4
	E.db.unitframe.units.raid40.debuffs.yOffset = -9
	E.db.unitframe.units.raid40.debuffs.useBlacklist = false
	E.db.unitframe.units.raid40.debuffs.useFilter = "Blacklist"
	E.db.unitframe.units.raid40.buffs.xOffset = 21
	E.db.unitframe.units.raid40.buffs.yOffset = 25
	E.db.unitframe.units.raid40.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.raid40.buffs.clickThrough = true
	E.db.unitframe.units.raid40.buffs.noConsolidated = false
	E.db.unitframe.units.raid40.buffs.noDuration = false
	E.db.unitframe.units.raid40.buffs.playerOnly = false
	E.db.unitframe.units.raid40.buffs.perrow = 1
	E.db.unitframe.units.raid40.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.raid40.buffs.sizeOverride = 17
	E.db.unitframe.units.raid40.buffs.useBlacklist = false
	E.db.unitframe.units.raid40.buffs.enable = true
	E.db.unitframe.units.raid40.groupBy = "GROUP"

	--Actionbars
	--Bar 1
	E.db.actionbar.bar1.enabled = true
	E.db.actionbar.bar1.backdrop = true
	E.db.actionbar.bar1.buttons = 12
	E.db.actionbar.bar1.buttonsize = 32
	E.db.actionbar.bar1.buttonspacing = 2
	--Bar 2
	E.db.actionbar.bar2.enabled = true
	E.db.actionbar.bar2.backdrop = false
	E.db.actionbar.bar2.buttons = 6
	E.db.actionbar.bar2.buttonsize = 32
	E.db.actionbar.bar2.buttonspacing = 2
	E.db.actionbar.bar2.buttonsPerRow = 6
	E.db.actionbar.bar2.heightMult = 1
	--Bar 3
	E.db.actionbar.bar3.enabled = true
	E.db.actionbar.bar3.backdrop = false
	E.db.actionbar.bar3.buttons = 6
	E.db.actionbar.bar3.buttonsize = 32
	E.db.actionbar.bar3.buttonspacing = 2
	E.db.actionbar.bar3.buttonsPerRow = 6
	--Bar 4
	E.db.actionbar.bar4.enabled = true
	E.db.actionbar.bar4.backdrop = false
	E.db.actionbar.bar4.buttons = 12
	E.db.actionbar.bar4.buttonsize = 32
	E.db.actionbar.bar4.buttonspacing = 2
	E.db.actionbar.bar4.buttonsPerRow = 6
	E.db.actionbar.bar4.mouseover = true
	E.db.actionbar.bar4.point = "BOTTOMLEFT"
	--Bar 5
	E.db.actionbar.bar5.enabled = true
	E.db.actionbar.bar5.backdrop = true
	E.db.actionbar.bar5.buttons = 6
	E.db.actionbar.bar5.buttonsize = 32
	E.db.actionbar.bar5.buttonspacing = 2
	E.db.actionbar.bar5.buttonsPerRow = 3
	E.db.actionbar.bar5.mouseover = true
	--Stance Bar
	E.db.actionbar.stanceBar.buttonsPerRow = 1
	--Pet Bar
	E.db.actionbar.barPet.point = "TOPRIGHT"
	E.db.actionbar.barPet.buttonsPerRow = 1

	--Datatext
	do
		E.db.datatexts.panelTransparency = false --5.4
		E.db.datatexts.minimapPanels = true --5.4
		E.db.datatexts.fontOutline = "None" --5.4
		E.db.datatexts.panels['LeftChatDataPanel']['left'] = "" --5.4
		E.db.datatexts.panels['LeftChatDataPanel']['middle'] = "Durability" --5.4
		E.db.datatexts.panels['LeftChatDataPanel']['right'] = "" --5.4
		E.db.datatexts.panels['RightChatDataPanel']['left'] = "Gold" --5.4
		E.db.datatexts.panels['RightChatDataPanel']['middle'] = "System" --5.4
		E.db.datatexts.panels['RightChatDataPanel']['right'] = "Time" --5.4
		E.db.datatexts.panels['Top_Center'] = "Version" --5.4
		E.db.datatexts.panels['LeftMiniPanel'] = "S&L Friends" --5.4
		E.db.datatexts.panels['RightMiniPanel'] = "S&L Guild" --5.4

		--Datatext Panels Spec Specific
		if layout == 'tank' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Avoidance" --5.4
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Vengeance" --5.4
		elseif layout == 'healer' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Spell/Heal Power" --5.4
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Haste" --5.4
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Spell/Heal Power" --5.4
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Haste" --5.4
		end
	end

	do
		E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-210-410"
		E.db.movers.BossButton = "BOTTOMElvUIParentBOTTOM-315300"
		E.db.movers.BossHeaderMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-210435"
		E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM00"
		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-20782"
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM-20758"
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM20782"
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMElvUIParentBOTTOM20758"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM314223"
		--E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310432"
		E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM-314223"
		E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0230"
		E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM021"
		E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM-30821"
		E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM30821"
		--E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-380200"
		E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-413200"
		--E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-26027"
		E.db.movers.ElvAB_5 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4298"
		E.db.movers.ElvUF_PetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-551312"
		E.db.movers.Top_Center_Mover = "TOPElvUIParentTOP00"
		E.db.movers.PetAB = "RIGHTElvUIParentRIGHT00"
		E.db.movers.MinimapMover = "TOPRIGHTElvUIParentTOPRIGHT00"
		E.db.movers.LossControlMover = "TOPElvUIParentTOP0-379"
		E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT41220"
		E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
		E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT41219"
		E.db.movers.UIBFrameMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT315178"
		E.db.movers.WatchFrameMover = "TOPLEFTElvUIParentTOPLEFT75-239"
		E.db.movers.ExperienceBarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42619"
		E.db.movers.ReputationBarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-41419"
		if layout == 'dpsCaster' or layout == 'dpsMelee' or layout == 'tank' then
			E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT7200"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT7200"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT7200"
			--E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT1162121"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT7200"
		else
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM0121"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM0121"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM0121"
			--E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT1162121"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMElvUIParentBOTTOM0121"
		end
	end

	E:UpdateAll(true)
end

local function AffinitiiSetup() --The function to switch from class ElvUI settings to Affinitii's
	SLEInstallStepComplete.message = L["Affinitii's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	-- layout = E.db.layoutSet  --Pull which layout was selected if any.
	pixel = E.PixelMode  --Pull PixelMode
	
	--Profile--
	E.db.general.autoRepair = "GUILD"
	E.db.general.bottomPanel = false
	E.db.general.backdropfadecolor.b = 0.054
	E.db.general.backdropfadecolor.g = 0.054
	E.db.general.backdropfadecolor.r = 0.054
	E.db.general.valuecolor.b = 0.819
	E.db.general.valuecolor.g = 0.513
	E.db.general.valuecolor.r = 0.09
	E.db.general.threat.position = "LEFTCHAT"
	E.db.general.vendorGrays = true
	E.db.general.topPanel = false
	E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM03"
	E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM097"
	E.db.movers.ElvUF_RaidMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT440511"
	E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
	E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT449511"
	E.db.movers.BossButton = "TOPLEFTElvUIParentTOPLEFT622-352"
	E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM-63436"
	E.db.movers.ClassBarMover = "BOTTOMElvUIParentBOTTOM-337500"
	E.db.movers.SquareMinimapBar = "TOPRIGHTElvUIParentTOPRIGHT-4-211"
	E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM278200"
	E.db.movers.ElvUF_Raid40Mover = "TOPLEFTElvUIParentTOPLEFT447-468"
	E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM059"
	E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM0273"
	E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-413200"
	E.db.movers.AltPowerBarMover = "BOTTOMElvUIParentBOTTOM-300338"
	E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM26427"
	E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-26427"
	E.db.movers.ElvUF_Raid25Mover = "TOPLEFTElvUIParentTOPLEFT449-448"
	E.db.movers.PetAB = "TOPRIGHTElvUIParentTOPRIGHT-4-433"
	E.db.movers.ElvAB_6 = "BOTTOMElvUIParentBOTTOM0102"
	E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
	E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT449511"
	E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
	E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-210-410"
	E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0230"
	E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2644"
	E.db.movers.BossHeaderMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-210435"
	E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-278200"
	E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM025"
	E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
	E.db.movers.MMButtonsMover = "TOPRIGHTElvUIParentTOPRIGHT-214-160"
	E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0190"
	E.db.movers.DP_5_Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4327"
	E.db.gridSize = 110
	E.db.tooltip.style = "inset"
	E.db.tooltip.visibility.combat = true
	E.db.hideTutorial = true
	E.db.chat.timeStampFormat = "%I:%M"
	E.db.chat.editBoxPosition = "ABOVE_CHAT"
	E.db.chat.lfgIcons = false
	E.db.chat.emotionIcons = false
	E.db.unitframe.units.tank.enable = false
	E.db.unitframe.units.boss.portrait.enable = true
	E.db.unitframe.units.boss.portrait.overlay = true
	E.db.unitframe.units.boss.power.width = "inset"
	E.db.unitframe.units.raid40.horizontalSpacing = 1
	E.db.unitframe.units.raid40.debuffs.xOffset = -4
	E.db.unitframe.units.raid40.debuffs.yOffset = -9
	E.db.unitframe.units.raid40.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.raid40.debuffs.clickThrough = true
	E.db.unitframe.units.raid40.debuffs.useBlacklist = false
	E.db.unitframe.units.raid40.debuffs.perrow = 2
	E.db.unitframe.units.raid40.debuffs.useFilter = "Blacklist"
	E.db.unitframe.units.raid40.debuffs.sizeOverride = 21
	E.db.unitframe.units.raid40.debuffs.enable = true
	E.db.unitframe.units.raid40.rdebuffs.size = 26
	E.db.unitframe.units.raid40.invertGroupingOrder = false
	E.db.unitframe.units.raid40.name.text_format = "[namecolor][name:veryshort]"
	E.db.unitframe.units.raid40.name.position = "TOP"
	E.db.unitframe.units.raid40.power.enable = true
	E.db.unitframe.units.raid40.power.width = "inset"
	E.db.unitframe.units.raid40.power.position = "CENTER"
	E.db.unitframe.units.raid40.customTexts = {}
	E.db.unitframe.units.raid40.customTexts['Health Text'] = {}
	E.db.unitframe.units.raid40.customTexts['Health Text'].font = "ElvUI Pixel"
	E.db.unitframe.units.raid40.customTexts['Health Text'].justifyH = "CENTER"
	E.db.unitframe.units.raid40.customTexts['Health Text'].fontOutline = "MONOCHROMEOUTLINE"
	E.db.unitframe.units.raid40.customTexts['Health Text'].xOffset = 0
	E.db.unitframe.units.raid40.customTexts['Health Text'].size = 10
	E.db.unitframe.units.raid40.customTexts['Health Text'].text_format = "[healthcolor][health:deficit]"
	E.db.unitframe.units.raid40.customTexts['Health Text'].yOffset = -7
	E.db.unitframe.units.raid40.healPrediction = true
	E.db.unitframe.units.raid40.width = 50
	E.db.unitframe.units.raid40.growthDirection = "UP_LEFT"
	E.db.unitframe.units.raid40.health.frequentUpdates = true
	E.db.unitframe.units.raid40.buffs.xOffset = 21
	E.db.unitframe.units.raid40.buffs.yOffset = 25
	E.db.unitframe.units.raid40.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.raid40.buffs.clickThrough = true
	E.db.unitframe.units.raid40.buffs.useBlacklist = false
	E.db.unitframe.units.raid40.buffs.noDuration = false
	E.db.unitframe.units.raid40.buffs.playerOnly = false
	E.db.unitframe.units.raid40.buffs.perrow = 1
	E.db.unitframe.units.raid40.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.raid40.buffs.noConsolidated = false
	E.db.unitframe.units.raid40.buffs.sizeOverride = 17
	E.db.unitframe.units.raid40.buffs.enable = true
	E.db.unitframe.units.raid40.height = 43
	E.db.unitframe.units.raid40.verticalSpacing = 1
	E.db.unitframe.units.raid40.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.raid40.raidicon.xOffset = 9
	E.db.unitframe.units.raid40.raidicon.yOffset = 0
	E.db.unitframe.units.raid40.raidicon.size = 13
	E.db.unitframe.units.focus.power.width = "inset"
	E.db.unitframe.units.target.portrait.overlay = true
	E.db.unitframe.units.target.aurabar.enable = false
	E.db.unitframe.units.target.power.width = "inset"
	E.db.unitframe.units.target.power.height = 11
	E.db.unitframe.units.raid.debuffs.countFontSize = 13
	E.db.unitframe.units.raid.debuffs.fontSize = 9
	E.db.unitframe.units.raid.debuffs.enable = true
	E.db.unitframe.units.raid.debuffs.yOffset = -7
	E.db.unitframe.units.raid.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.raid.debuffs.sizeOverride = 21
	E.db.unitframe.units.raid.debuffs.xOffset = -4
	E.db.unitframe.units.raid.growthDirection = "LEFT_UP"
	E.db.unitframe.units.raid.numGroups = 6
	E.db.unitframe.units.raid.roleIcon.enable = false
	E.db.unitframe.units.raid.healPrediction = true
	E.db.unitframe.units.raid.power.height = 8
	E.db.unitframe.units.raid.buffs.enable = true
	E.db.unitframe.units.raid.buffs.yOffset = 28
	E.db.unitframe.units.raid.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.raid.buffs.clickThrough = true
	E.db.unitframe.units.raid.buffs.useBlacklist = false
	E.db.unitframe.units.raid.buffs.noDuration = false
	E.db.unitframe.units.raid.buffs.playerOnly = false
	E.db.unitframe.units.raid.buffs.perrow = 1
	E.db.unitframe.units.raid.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.raid.buffs.noConsolidated = false
	E.db.unitframe.units.raid.buffs.sizeOverride = 22
	E.db.unitframe.units.raid.buffs.xOffset = 30
	E.db.unitframe.units.focustarget.power.width = "inset"
	E.db.unitframe.units.pet.power.width = "inset"
	E.db.unitframe.units.targettarget.power.width = "inset"
	E.db.unitframe.units.player.debuffs.attachTo = "BUFFS"
	E.db.unitframe.units.player.portrait.overlay = true
	E.db.unitframe.units.player.classbar.detachFromFrame = true
	E.db.unitframe.units.player.classbar.enable = false
	E.db.unitframe.units.player.aurabar.enable = false
	E.db.unitframe.units.player.power.width = "inset"
	E.db.unitframe.units.player.power.height = 11
	E.db.unitframe.units.player.buffs.enable = true
	E.db.unitframe.units.player.buffs.noDuration = false
	E.db.unitframe.units.player.buffs.attachTo = "FRAME"
	E.db.unitframe.units.player.castbar.width = 399
	E.db.unitframe.units.player.castbar.height = 25
	E.db.unitframe.units.party.horizontalSpacing = 1
	E.db.unitframe.units.party.debuffs.sizeOverride = 21
	E.db.unitframe.units.party.debuffs.yOffset = -7
	E.db.unitframe.units.party.debuffs.anchorPoint = "TOPRIGHT"
	E.db.unitframe.units.party.debuffs.xOffset = -4
	E.db.unitframe.units.party.buffs.enable = true
	E.db.unitframe.units.party.buffs.yOffset = 28
	E.db.unitframe.units.party.buffs.anchorPoint = "BOTTOMLEFT"
	E.db.unitframe.units.party.buffs.clickThrough = true
	E.db.unitframe.units.party.buffs.useBlacklist = false
	E.db.unitframe.units.party.buffs.noDuration = false
	E.db.unitframe.units.party.buffs.playerOnly = false
	E.db.unitframe.units.party.buffs.perrow = 1
	E.db.unitframe.units.party.buffs.useFilter = "TurtleBuffs"
	E.db.unitframe.units.party.buffs.noConsolidated = false
	E.db.unitframe.units.party.buffs.sizeOverride = 22
	E.db.unitframe.units.party.buffs.xOffset = 30
	E.db.unitframe.units.party.growthDirection = "LEFT_UP"
	E.db.unitframe.units.party.power.text_format = ""
	E.db.unitframe.units.party.power.width = "inset"
	E.db.unitframe.units.party.buffIndicator.size = 10
	E.db.unitframe.units.party.roleIcon.enable = false
	E.db.unitframe.units.party.roleIcon.position = "BOTTOMRIGHT"
	E.db.unitframe.units.party.targetsGroup.anchorPoint = "BOTTOM"
	E.db.unitframe.units.party.GPSArrow.size = 40
	E.db.unitframe.units.party.customTexts = {}
	E.db.unitframe.units.party.customTexts['Health Text'] = {}
	E.db.unitframe.units.party.customTexts['Health Text'].font = "ElvUI Pixel"
	E.db.unitframe.units.party.customTexts['Health Text'].justifyH = "CENTER"
	E.db.unitframe.units.party.customTexts['Health Text'].fontOutline = "MONOCHROMEOUTLINE"
	E.db.unitframe.units.party.customTexts['Health Text'].xOffset = 0
	E.db.unitframe.units.party.customTexts['Health Text'].size = 10
	E.db.unitframe.units.party.customTexts['Health Text'].text_format = "[healthcolor][health:deficit]"
	E.db.unitframe.units.party.customTexts['Health Text'].yOffset = -7
	E.db.unitframe.units.party.healPrediction = true
	E.db.unitframe.units.party.width = 80
	E.db.unitframe.units.party.name.text_format = "[namecolor][name:veryshort] [difficultycolor][smartlevel]"
	E.db.unitframe.units.party.name.position = "TOP"
	E.db.unitframe.units.party.health.frequentUpdates = true
	E.db.unitframe.units.party.health.position = "BOTTOM"
	E.db.unitframe.units.party.health.text_format = ""
	E.db.unitframe.units.party.height = 45
	E.db.unitframe.units.party.verticalSpacing = 1
	E.db.unitframe.units.party.petsGroup.anchorPoint = "BOTTOM"
	E.db.unitframe.units.party.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.party.raidicon.xOffset = 9
	E.db.unitframe.units.party.raidicon.yOffset = 0
	E.db.unitframe.units.party.raidicon.size = 13
	E.db.unitframe.units.arena.power.width = "inset"
	E.db.unitframe.units.pettarget.power.width = "inset"
	E.db.unitframe.units.assist.targetsGroup.enable = false
	E.db.unitframe.units.assist.enable = false
	E.db.unitframe.colors.auraBarBuff.b = 0.094117647058824
	E.db.unitframe.colors.auraBarBuff.g = 0.07843137254902
	E.db.unitframe.colors.auraBarBuff.r = 0.30980392156863
	E.db.unitframe.colors.transparentPower = true
	E.db.unitframe.colors.castColor.b = 0.1
	E.db.unitframe.colors.castColor.g = 0.1
	E.db.unitframe.colors.castColor.r = 0.1
	E.db.unitframe.colors.health.b = 0.23529411764706
	E.db.unitframe.colors.health.g = 0.23529411764706
	E.db.unitframe.colors.health.r = 0.23529411764706
	E.db.unitframe.colors.transparentCastbar = true
	E.db.unitframe.colors.transparentHealth = true
	E.db.unitframe.colors.transparentAurabars = true
	E.db.unitframe.smartRaidFilter = false
	E.db.unitframe.statusbar = "Polished Wood"
	E.db.datatexts.minimapPanels = false
	E.db.datatexts.fontSize = 12
	E.db.datatexts.panelTransparency = true
	E.db.datatexts.panels.DP_3.middle = "DPS"
	E.db.datatexts.panels.RightChatDataPanel.right = "Skada"
	E.db.datatexts.panels.RightChatDataPanel.left = "Combat/Arena Time"
	E.db.datatexts.panels.DP_1.middle = "Friends"
	E.db.datatexts.panels.DP_5.middle = "Friends"
	E.db.datatexts.panels.LeftChatDataPanel.right = "Haste"
	E.db.datatexts.panels.LeftChatDataPanel.left = "Spell/Heal Power"
	E.db.datatexts.panels.RightMiniPanel = "Gold"
	E.db.datatexts.panels.Top_Center = "WIM"
	E.db.datatexts.panels.Bottom_Panel = "System"
	E.db.datatexts.panels.DP_6.right = "Gold"
	E.db.datatexts.panels.DP_6.left = "System"
	E.db.datatexts.panels.DP_6.middle = "Time"
	E.db.datatexts.panels.DP_2.middle = "Attack Power"
	E.db.datatexts.panels.LeftMiniPanel = "Time"
	E.db.datatexts.font = "ElvUI Font"
	E.db.datatexts.fontOutline = "None"
	E.db.datatexts.battleground = false
	E.db.actionbar.bar3.enabled = false
	E.db.actionbar.bar3.buttonsPerRow = 3
	E.db.actionbar.bar3.alpha = 0.4
	E.db.actionbar.bar2.enabled = true
	E.db.actionbar.bar2.buttonspacing = 1
	E.db.actionbar.bar2.alpha = 0.6
	E.db.actionbar.bar5.enabled = false
	E.db.actionbar.bar5.buttonsPerRow = 3
	E.db.actionbar.bar5.alpha = 0.4
	E.db.actionbar.bar1.buttonspacing = 1
	E.db.actionbar.bar1.alpha = 0.6
	E.db.actionbar.stanceBar.buttonsPerRow = 1
	E.db.actionbar.stanceBar.alpha = 0.6
	E.db.actionbar.bar4.enabled = false
	E.db.actionbar.bar4.point = "BOTTOMLEFT"
	E.db.actionbar.bar4.mouseover = true
	E.db.actionbar.bar4.backdrop = false
	E.db.actionbar.bar4.buttonsPerRow = 6
	E.db.actionbar.bar4.alpha = 0.4
	E.db.layoutSet = "healer"
	E.db.sle.datatext.chathandle = true
	E.db.sle.datatext.top.transparent = true
	E.db.sle.datatext.top.width = 101
	E.db.sle.datatext.bottom.transparent = true
	E.db.sle.datatext.bottom.alpha = 0.8
	E.db.sle.datatext.bottom.width = 411
	E.db.sle.datatext.dp6.enabled = true
	E.db.sle.datatext.dp6.transparent = true
	E.db.sle.datatext.dp6.alpha = 0.8
	E.db.sle.datatext.dp6.width = 399
	E.db.sle.minimap.buttons.anchor = "VERTICAL"
	E.db.sle.minimap.buttons.mouseover = true
	E.db.sle.minimap.mapicons.skinmail = false
	E.db.sle.minimap.mapicons.iconmouseover = true
	--Character--
	E.private.general.chatBubbles = "nobackdrop"
	E.private.addonskins = {}
	E.private.addonskins.EmbedSystemDual = true
	E.private.sle.inspectframeoptions.enable = true
	E.private.sle.characterframeoptions.enable = true
	E.private.theme = "classic"
	--Global--
	E.global.unitframe.aurafilters.TurtleBuffs = {}
	E.global.unitframe.aurafilters.TurtleBuffs.spells = {}
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Alter Time'] = {}
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Elusive Brew'] = {}
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Alter Time'].enable = true
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Alter Time'].priority = 0
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Elusive Brew'].enable = false
	E.global.unitframe.aurafilters.TurtleBuffs.spells['Elusive Brew'].priority = 99
	E.global.unitframe.aurafilters.Blacklist = {}
	E.global.unitframe.aurafilters.Blacklist.spells = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Bright Light'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Keen Eyesight'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Clear Mind'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Rays'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Inferno Breath'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Infrared Light'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Thick Bones'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Dark Winds'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Fully Mutated'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Improved Synapses'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Unleashed Anima'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Recently Bandaged'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Timer'] = {}
	E.global.unitframe.aurafilters.Blacklist.spells['Bright Light'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Bright Light'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Keen Eyesight'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Keen Eyesight'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Clear Mind'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Clear Mind'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Rays'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Rays'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Inferno Breath'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Inferno Breath'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Infrared Light'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Infrared Light'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Thick Bones'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Thick Bones'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Dark Winds'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Dark Winds'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Fully Mutated'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Fully Mutated'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Improved Synapses'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Improved Synapses'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Unleashed Anima'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Unleashed Anima'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Recently Bandaged'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Recently Bandaged'].priority = 0
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Timer'].enable = true
	E.global.unitframe.aurafilters.Blacklist.spells['Blue Timer'].priority = 0
	-- E.global.unitframe.buffwatch.SHAMAN[1].color.b = 1
	-- E.global.unitframe.buffwatch.SHAMAN[1].color.g = 1
	-- E.global.unitframe.buffwatch.SHAMAN[1].color.r = 1
	-- E.global.unitframe.buffwatch.SHAMAN[1].displayText = true
	-- E.global.unitframe.buffwatch.SHAMAN[1].style = "NONE"
	-- E.global.unitframe.buffwatch.SHAMAN[2].point = "BOTTOMRIGHT"
	-- E.global.unitframe.buffwatch.SHAMAN[2].yOffset = 10
	-- E.global.unitframe.buffwatch.SHAMAN[2].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.SHAMAN[3].point = "TOPLEFT"
	-- E.global.unitframe.buffwatch.SHAMAN[3].color.r = 1
	-- E.global.unitframe.buffwatch.SHAMAN[3].color.g = 1
	-- E.global.unitframe.buffwatch.SHAMAN[3].color.b = 1
	-- E.global.unitframe.buffwatch.SHAMAN[3].displayText = true
	-- E.global.unitframe.buffwatch.SHAMAN[3].style = "NONE"
	-- E.global.unitframe.buffwatch.PRIEST[1].point = "LEFT"
	-- E.global.unitframe.buffwatch.PRIEST[1].displayText = true
	-- E.global.unitframe.buffwatch.PRIEST[1].yOffset = 2
	-- E.global.unitframe.buffwatch.PRIEST[1].style = "NONE"
	-- E.global.unitframe.buffwatch.PRIEST[1].textColor.g = 0
	-- E.global.unitframe.buffwatch.PRIEST[1].textColor.b = 0
	-- E.global.unitframe.buffwatch.PRIEST[2].point = "TOPRIGHT"
	-- E.global.unitframe.buffwatch.PRIEST[2].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.PRIEST[3].enabled = false
	-- E.global.unitframe.buffwatch.PRIEST[4].color.r = 1
	-- E.global.unitframe.buffwatch.PRIEST[4].color.g = 1
	-- E.global.unitframe.buffwatch.PRIEST[4].color.b = 1
	-- E.global.unitframe.buffwatch.PRIEST[4].displayText = true
	-- E.global.unitframe.buffwatch.PRIEST[4].style = "NONE"
	-- E.global.unitframe.buffwatch.PRIEST[6].enabled = false
	-- E.global.unitframe.buffwatch.PRIEST[7].enabled = false
	-- E.global.unitframe.buffwatch.PRIEST[8].enabled = false
	-- E.global.unitframe.buffwatch.PRIEST[9].enabled = true
	-- E.global.unitframe.buffwatch.PRIEST[9].anyUnit = false
	-- E.global.unitframe.buffwatch.PRIEST[9].point = "BOTTOMLEFT"
	-- E.global.unitframe.buffwatch.PRIEST[9].color.b = 1
	-- E.global.unitframe.buffwatch.PRIEST[9].color.g = 1
	-- E.global.unitframe.buffwatch.PRIEST[9].color.r = 1
	-- E.global.unitframe.buffwatch.PRIEST[9].displayText = true
	-- E.global.unitframe.buffwatch.PRIEST[9].textThreshold = -1
	-- E.global.unitframe.buffwatch.PRIEST[9].yOffset = 8
	-- E.global.unitframe.buffwatch.PRIEST[9].style = "NONE"
	-- E.global.unitframe.buffwatch.PRIEST[9].id = 47753
	-- E.global.unitframe.buffwatch.PRIEST[10].enabled = true
	-- E.global.unitframe.buffwatch.PRIEST[10].anyUnit = false
	-- E.global.unitframe.buffwatch.PRIEST[10].point = "BOTTOMRIGHT"
	-- E.global.unitframe.buffwatch.PRIEST[10].color.b = 1
	-- E.global.unitframe.buffwatch.PRIEST[10].color.g = 1
	-- E.global.unitframe.buffwatch.PRIEST[10].color.r = 1
	-- E.global.unitframe.buffwatch.PRIEST[10].displayText = true
	-- E.global.unitframe.buffwatch.PRIEST[10].textThreshold = -1
	-- E.global.unitframe.buffwatch.PRIEST[10].yOffset = 8
	-- E.global.unitframe.buffwatch.PRIEST[10].style = "NONE"
	-- E.global.unitframe.buffwatch.PRIEST[10].id = 114908
	-- E.global.unitframe.buffwatch.DRUID[1].point = "TOPLEFT"
	-- E.global.unitframe.buffwatch.DRUID[1].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[1].style = "NONE"
	-- E.global.unitframe.buffwatch.DRUID[2].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[2].style = "NONE"
	-- E.global.unitframe.buffwatch.DRUID[3].point = "BOTTOMRIGHT"
	-- E.global.unitframe.buffwatch.DRUID[3].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[3].textThreshold = 5
	-- E.global.unitframe.buffwatch.DRUID[3].yOffset = 12
	-- E.global.unitframe.buffwatch.DRUID[3].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.DRUID[4].point = "TOPRIGHT"
	-- E.global.unitframe.buffwatch.DRUID[4].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[4].textThreshold = 3
	-- E.global.unitframe.buffwatch.DRUID[4].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.DRUID[5].enabled = true
	-- E.global.unitframe.buffwatch.DRUID[5].anyUnit = false
	-- E.global.unitframe.buffwatch.DRUID[5].point = "LEFT"
	-- E.global.unitframe.buffwatch.DRUID[5].id = 155777
	-- E.global.unitframe.buffwatch.DRUID[5].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[5].color.r = 1
	-- E.global.unitframe.buffwatch.DRUID[5].color.g = 0
	-- E.global.unitframe.buffwatch.DRUID[5].color.b = 0
	-- E.global.unitframe.buffwatch.DRUID[5].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.DRUID[6].enabled = true
	-- E.global.unitframe.buffwatch.DRUID[6].anyUnit = false
	-- E.global.unitframe.buffwatch.DRUID[6].point = "BOTTOMRIGHT"
	-- E.global.unitframe.buffwatch.DRUID[6].id = 162359
	-- E.global.unitframe.buffwatch.DRUID[6].displayText = true
	-- E.global.unitframe.buffwatch.DRUID[6].color.r = 1
	-- E.global.unitframe.buffwatch.DRUID[6].color.g = 0
	-- E.global.unitframe.buffwatch.DRUID[6].color.b = 0
	-- E.global.unitframe.buffwatch.MONK[1].color.r = 1
	-- E.global.unitframe.buffwatch.MONK[1].color.g = 1
	-- E.global.unitframe.buffwatch.MONK[1].color.b = 1
	-- E.global.unitframe.buffwatch.MONK[1].displayText = true
	-- E.global.unitframe.buffwatch.MONK[1].style = "NONE"
	-- E.global.unitframe.buffwatch.MONK[2].enabled = false
	-- E.global.unitframe.buffwatch.MONK[3].color.r = 1
	-- E.global.unitframe.buffwatch.MONK[3].color.g = 1
	-- E.global.unitframe.buffwatch.MONK[3].color.b = 1
	-- E.global.unitframe.buffwatch.MONK[3].displayText = true
	-- E.global.unitframe.buffwatch.MONK[3].style = "NONE"
	-- E.global.unitframe.buffwatch.MONK[4].color.r = 1
	-- E.global.unitframe.buffwatch.MONK[4].color.g = 1
	-- E.global.unitframe.buffwatch.MONK[4].color.b = 1
	-- E.global.unitframe.buffwatch.MONK[4].displayText = true
	-- E.global.unitframe.buffwatch.MONK[4].style = "NONE"
	-- E.global.unitframe.buffwatch.MONK[5].enabled = true
	-- E.global.unitframe.buffwatch.MONK[5].anyUnit = false
	-- E.global.unitframe.buffwatch.MONK[5].point = "TOPRIGHT"
	-- E.global.unitframe.buffwatch.MONK[5].color.b = 1
	-- E.global.unitframe.buffwatch.MONK[5].color.g = 1
	-- E.global.unitframe.buffwatch.MONK[5].color.r = 1
	-- E.global.unitframe.buffwatch.MONK[5].id = 115175
	-- E.global.unitframe.buffwatch.MONK[5].displayText = false
	-- E.global.unitframe.buffwatch.MONK[5].style = "texturedIcon"
	-- E.global.unitframe.buffwatch.MONK[5].yOffset = 0
	-- E.global.unitframe.buffwatch.PALADIN[2].enabled = false
	-- E.global.unitframe.buffwatch.PALADIN[3].enabled = false
	-- E.global.unitframe.buffwatch.PALADIN[4].enabled = false
	-- E.global.unitframe.buffwatch.PALADIN[5].enabled = false
	-- E.global.unitframe.buffwatch.PALADIN[8].anyUnit = false
	-- E.global.unitframe.buffwatch.PALADIN[8].point = "TOPRIGHT"
	-- E.global.unitframe.buffwatch.PALADIN[8].color.r = 1
	-- E.global.unitframe.buffwatch.PALADIN[8].color.g = 0
	-- E.global.unitframe.buffwatch.PALADIN[8].color.b = 0
	-- E.global.unitframe.buffwatch.PALADIN[8].displayText = true
	-- E.global.unitframe.buffwatch.PALADIN[8].style = "NONE"
	
	-- do
		-- if GetScreenWidth() > 1920 then
			-- E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM25427"
			-- E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-25427"
			-- E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM2544"
			-- E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2544"
		-- else
			-- E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM26027"
			-- E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-26027"
			-- E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM2604"
			-- E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2604"
		-- end
		-- E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-278200"
		-- E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM0100"
		-- E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM278200"
		-- E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0190"
		-- E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM-63436"
		-- E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0230"
		-- E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM060"
		-- E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM027"
		-- E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM04"
		-- E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
		-- E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
		-- E.db.movers.PetAB = "RIGHTElvUIParentRIGHT00"
		-- E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-210-410"
		-- E.db.movers.BossHeaderMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-210435"
		-- if layout == 'dpsCaster' or layout == 'dpsMelee' or layout == 'tank' then
			-- E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			-- E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			-- E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			-- E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			-- E.db.movers["BossButton"] = "CENTERElvUIParentCENTER-413188"
		-- else
			-- E.db.movers.ElvUF_PartyMover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			-- E.db.movers.ElvUF_Raid10Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			-- E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			-- E.db.movers.ElvUF_Raid40Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			-- E.db.movers["BossButton"] = "CENTERElvUIParentCENTER-413188"
		-- end
		
		-- if GetScreenWidth() < 1920 then
			-- E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-380200"
			-- E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT38221"
			-- E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT38221"
		-- else
			-- E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-413200"
			-- E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
			-- E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
		-- end
	-- end

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
		f.Desc1:SetText("This install process will setup configuration of Shadow & Light.")
		f.Desc2:SetText("")
		f.Desc3:SetText(L["Please press the continue button to go onto the next step."])

		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", InstallComplete)
		SLEInstallOption1Button:SetText(L["Skip Process"])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L["Chat"])
		f.Desc1:SetText("This options will determine if you want to use default ElvUI's chat datapanels or let Shadow & Light handle them.")
		f.Desc2:SetText("Shadow & Light will dock them outside of actual chat panels.")
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", function() E.db.sle.datatext.chathandle = false; E:GetModule('Layout'):ToggleChatPanels() end)
		SLEInstallOption1Button:SetText("ElvUI Panels")
		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() E.db.sle.datatext.chathandle = true; E:GetModule('Layout'):ToggleChatPanels() end)
		SLEInstallOption2Button:SetText("S&L Panels")
	elseif PageNum == 3 then
		f.SubTitle:SetText(L["Armory Mode"])
		f.Desc1:SetText("Imma test text")
		f.Desc2:SetText("This page is for armory mode disable/enable stuff")
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
		
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript('OnClick', function() E.private.sle.characterframeoptions.enable = true; E.private.sle.inspectframeoptions.enable = true; end)
		SLEInstallOption1Button:SetText(L["Enable"])	
	elseif PageNum == 4 then
		f.SubTitle:SetText("Shadow & Light Settings")
		f.Desc1:SetText(L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."])
		f.Desc2:SetText(L["SLE_Install_Text2"])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript('OnClick', function() DarthSetup() end)
		SLEInstallOption1Button:SetText(L["Darth's Config"])	

		SLEInstallOption2Button:Show()
		SLEInstallOption2Button:SetScript('OnClick', function() AffinitiiSetup() end)
		SLEInstallOption2Button:SetText(L["Affinitii's Config"])

		SLEInstallOption3Button:Show()
		SLEInstallOption3Button:SetScript('OnClick', function() RepoocSetup() end)
		SLEInstallOption3Button:SetText(L["Repooc's Config"])
	elseif PageNum == 5 then 
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		SLEInstallOption1Button:Show()
		SLEInstallOption1Button:SetScript("OnClick", InstallComplete)
		SLEInstallOption1Button:SetText(L["Finished"])				
		SLEInstallFrame:Size(550, 350)
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
		f.Option1:Point("BOTTOM", 0, 45)
		f.Option1:SetText("")
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)

		f.Option2 = CreateFrame("Button", "SLEInstallOption2Button", f, "UIPanelButtonTemplate")
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45)
		f.Option2:SetText("")
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 45) end)
		E.Skins:HandleButton(f.Option2, true)		

		f.Option3 = CreateFrame("Button", "SLEInstallOption3Button", f, "UIPanelButtonTemplate")
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText("")
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45)  end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
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
			f.Option2:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45)  
		end)
		f.Option4:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
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
		f.Desc3:Point("TOPLEFT", 20, -175)	
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
		f.tutorialImage:Point('BOTTOM', 0, 70)
	end

	SLEInstallFrame:Show()
	NextPage()
end