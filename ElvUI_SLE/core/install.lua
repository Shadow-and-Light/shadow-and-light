local E, L, V, P, G = unpack(ElvUI); 
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

local CURRENT_PAGE = 0
local MAX_PAGE = 5

function DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	SLEInstallStepComplete.message = L["Darth's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	if not E.db.loclite then E.db.loclite = {} end

	local layout = E.db.layoutSet --To know if some sort of layout was choosed before

	if SLE:Auth() then
		E.db.hideTutorial = 1
		E.db.general.loginmessage = false
	end

	--General options--
	E.db.general.stickyFrames = false 
	E.db.general.autoRepair = "PLAYER" 
	E.db.general.vendorGrays = true 
	E.db.general.fontsize = 10 
	E.db.general.bottomPanel = false 
	E.db.general.topPanel = false --double check later
	E.db.general.hideErrorFrame = false 
	
	E.db.general.minimap.locationText = 'HIDE'
	
	E.db.general.experience.orientation = "VERTICAL"
	E.db.general.experience.width = 10
	E.db.general.experience.height = 185
	
	E.db.general.reputation.orientation = "VERTICAL"
	E.db.general.reputation.width = 10
	E.db.general.reputation.height = 185
	
	E.db.general.threat.enable = false
	
	if layout == "healer" then
		E.db.general.totems.growthDirection = 'HORIZONTAL'
		E.db.general.totems.size = 24
	else
		E.db.general.totems.size = 25
	end
	
	E.db.general.totems.spacing = 2

	--Bags--
	E.db.bags.bagSize = 26
	E.db.bags.bankSize = 26
	E.db.bags.sortInverted = false
	E.db.bags.alignToChat = false
	E.db.bags.bagWidth = 425
	E.db.bags.bankWidth = 425
	E.db.bags.yOffset = 178
	E.db.bags.currencyFormat = "ICON"

	--NamePlate--
	E.db.nameplate.font = "ElvUI Font"
	E.db.nameplate.fontOutline = "OUTLINE"
	E.db.nameplate.nonTargetAlpha = 0.35
	
	E.db.nameplate.buffs.font = "ElvUI Font"
	E.db.nameplate.buffs.fontOutline = "OUTLINE"
	E.db.nameplate.buffs.numAuras = 6
	E.db.nameplate.buffs.stretchTexture = false
	E.db.nameplate.debuffs.font = "ElvUI Font"
	E.db.nameplate.debuffs.fontOutline = "OUTLINE"
	E.db.nameplate.debuffs.numAuras = 6
	E.db.nameplate.debuffs.stretchTexture = false

	E.db.nameplate.raidHealIcon.attachTo = "TOP"
	E.db.nameplate.raidHealIcon.size = 24
	
	E.db.nameplate.healthBar.text.enable = true
	E.db.nameplate.healthBar.text.format = "CURRENT_PERCENT"
	E.db.nameplate.healthBar.lowThreshold = 0

	E.db.nameplate.targetIndicator.height = 35
	E.db.nameplate.targetIndicator.width = 35
	E.db.nameplate.targetIndicator.style = "arrow"

	--Auras--
	E.db.auras.font = "ElvUI Font"
	E.db.auras.fontOutline = "OUTLINE"
	E.db.sle.castername = true
	E.db.auras.fadeThreshold = 5
	
	E.db.auras.buffs.wrapAfter = 15
	E.db.auras.buffs.size = 26
	
	E.db.auras.debuffs.wrapAfter = 15
	E.db.auras.buffs.size = 26
	
	E.db.auras.consolidatedBuffs.fontSize = 9
	E.db.auras.consolidatedBuffs.fontOutline = "OUTLINE"
	E.db.auras.consolidatedBuffs.font = "ElvUI Font"
	E.db.auras.consolidatedBuffs.filter = false

	--Tooltip--
	E.db.tooltip.healthBar.font = "ElvUI Font"
	E.db.tooltip.talentInfo = true
	E.db.sle.tooltipicon = true
	
	--Chat--
	E.db.chat.editboxhistory = 10
	E.db.chat.emotionIcons = false
	E.db.chat.panelHeight = 185
	E.db.chat.panelWidth = 425
	E.db.chat.panelTabBackdrop = false
	E.db.chat.timeStampFormat = "%H:%M:%S "
	E.db.chat.whisperSound = "Whisper Alert"
	E.db.chat.fontOutline = "OUTLINE"
	E.db.chat.tabFont = "ElvUI Font"
	E.db.chat.tabFontOutline = "OUTLINE"

	--Datatexts--
	do
		E.db.datatexts.font = "ElvUI Font"
		E.db.datatexts.fontSize = 10
		E.db.datatexts.time24 = true
		E.db.sle.lfrshow.enabled = true
		E.db.datatexts.minimapPanels = false
		E.db.datatexts.panelTransparency = true
		E.db.datatexts.fontOutline = "OUTLINE"
		E.db.sle.datatext.top.enabled = true
		E.db.sle.datatext.top.transparent = true
		E.db.sle.datatext.bottom.enabled = true
		E.db.sle.datatext.bottom.width = 190
		E.db.sle.datatext.bottom.transparent = true
		E.db.sle.datatext.dp1.enabled = true
		E.db.sle.datatext.dp1.width = 386
		E.db.sle.datatext.dp1.transparent = true
		E.db.sle.datatext.dp2.enabled = true
		E.db.sle.datatext.dp2.width = 386
		E.db.sle.datatext.dp2.transparent = true
		E.db.sle.datatext.dp3.enabled = true
		E.db.sle.datatext.dp3.width = 386
		E.db.sle.datatext.dp3.transparent = true
		E.db.sle.datatext.dp4.enabled = true
		E.db.sle.datatext.dp4.width = 386
		E.db.sle.datatext.dp4.transparent = true
		E.db.sle.datatext.dp5.enabled = true
		E.db.sle.datatext.dp5.width = 455
		E.db.sle.datatext.dp5.transparent = true
		E.db.sle.datatext.dp6.enabled = true
		E.db.sle.datatext.dp6.width = 455
		E.db.sle.datatext.dp6.transparent = true
		
		E.db.sle.dt.friends.totals = true
		E.db.sle.dt.friends.expandBNBroadcast = true
		E.db.sle.dt.friends.combat = true
		E.db.sle.dt.guild.totals = true
		E.db.sle.dt.guild.hide_guildname = true
		E.db.sle.dt.guild.combat = true

		E.db.datatexts.panels.Top_Center = 'Version';
		E.db.datatexts.panels.Bottom_Panel = 'System';
		E.db.datatexts.panels.LeftChatDataPanel.right = 'S&L Friends';
		E.db.datatexts.panels.LeftChatDataPanel.left = 'Call to Arms';
		E.db.datatexts.panels.LeftChatDataPanel.middle = 'Durability';
		E.db.datatexts.panels.LeftMiniPanel = '';
		E.db.datatexts.panels.RightMiniPanel = '';
		E.db.datatexts.panels.DP_1.right = 'AtlasLoot';
		E.db.datatexts.panels.DP_1.middle = 'MrtWoo';
		E.db.datatexts.panels.DP_1.left = 'Swatter';
		E.db.datatexts.panels.DP_2.right = 'S&L Guild';
		E.db.datatexts.panels.DP_2.middle = 'Skada';
		E.db.datatexts.panels.DP_2.left = 'Altoholic';
		E.db.datatexts.panels.DP_3.right = 'Notes';
		E.db.datatexts.panels.DP_3.middle = 'DBM-LDB';
		E.db.datatexts.panels.DP_3.left = 'Time';
		E.db.datatexts.panels.DP_4.right = '';
		E.db.datatexts.panels.DP_4.middle = '';
		E.db.datatexts.panels.DP_4.left = 'Combat/Arena Time';
		E.db.datatexts.panels.DP_5.middle = 'Gold';
		E.db.datatexts.panels.DP_5.left = 'Bags';

		if layout == 'tank' then
			E.db.datatexts.panels.DP_6.left = 'Avoidance';
			E.db.datatexts.panels.DP_6.middle = 'Vengeance';
			E.db.datatexts.panels.DP_6.right = 'Expertise';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Talent/Loot Specialization';
			E.db.datatexts.panels.DP_5.right = 'Armor';
		elseif layout == 'healer' then
			E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'MP5';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Talent/Loot Specialization';
			E.db.datatexts.panels.DP_5.right = '';
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Talent/Loot Specialization';
			E.db.datatexts.panels.DP_5.right = '';
		else
			E.db.datatexts.panels.DP_6.left = 'Attack Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Talent/Loot Specialization';
			E.db.datatexts.panels.DP_5.right = 'Expertise';
		end
	end

	--Unitframes--
	do
		E.db.unitframe.smoothbars = false
		E.db.unitframe.font = "ElvUI Font"
		E.db.unitframe.fontsize = 9
		E.db.unitframe.fontOutline = 'OUTLINE'
		E.db.unitframe.statusbar = "Polished Wood"
		E.db.unitframe.colors.castColor = {
									["b"] = 0.396078431372549,
									["g"] = 0.7333333333333333,
									["r"] = 0.796078431372549,
								}
		E.db.unitframe.colors.healPrediction.absorbs = {
									["r"] = 0.3294117647058824,
									["g"] = 0.6039215686274509,
									["b"] = 1,
								}
		UF:Update_AllFrames()
		if layout == "healer" then
			E.db.unitframe.debuffHighlighting = true
		else
			E.db.unitframe.debuffHighlighting = false
		end
		E.db.unitframe.smartRaidFilter = false
		E.db.unitframe.colors.healthclass = true
		E.db.unitframe.colors.colorhealthbyvalue = false
			--Setting player frame
			E.db.unitframe.units.player.width = 210
			E.db.unitframe.units.player.height = 50
			if layout == "healer" then
				E.db.unitframe.units.player.lowmana = 30;
			else
				E.db.unitframe.units.player.lowmana = 0;
			end
			E.db.unitframe.units.player.health.position = 'RIGHT'
			E.db.unitframe.units.player.health.yOffset = 2
			E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current-percent:sl]"
			E.db.unitframe.units.player.power.text_format = "[powercolor][power:current:sl]"
			E.db.unitframe.units.player.power.height = 8
			E.db.unitframe.units.player.power.position = "BOTTOMRIGHT"
			E.db.unitframe.units.player.power.yOffset = 8
			E.db.unitframe.units.player.power.width = "inset"
			E.db.unitframe.units.player.name.text_format = "[name] [level]"
			E.db.unitframe.units.player.name.position = 'TOPLEFT'
			E.db.unitframe.units.player.name.yOffset = -3
			E.db.unitframe.units.player.pvp.text_format = "||cFFB04F4F[pvptimer]||r"
			E.db.unitframe.units.player.pvp.position = "LEFT"
			E.db.unitframe.units.player.portrait.enable = true
			E.db.unitframe.units.player.portrait.camDistanceScale = 3
			E.db.unitframe.units.player.portrait.overlay = true
			E.db.unitframe.units.player.portrait.rotation = 345
			E.db.unitframe.units.player.debuffs.enable = false
			E.db.unitframe.units.player.castbar.format = 'CURRENTMAX'
			E.db.unitframe.units.player.castbar.height = 18
			if layout == "healer" then
				E.db.unitframe.units.player.castbar.width = 200
			else
				E.db.unitframe.units.player.castbar.width = 210
			end
			E.db.unitframe.units.player.classbar.fill = "spaced"
			E.db.unitframe.units.player.classbar.height = 8
			E.db.unitframe.units.player.aurabar.enable = false
			E.db.unitframe.units.player.raidicon.enable = false
			
			--Setting target frame
			E.db.unitframe.units.target.width = 210
			E.db.unitframe.units.target.height = 50
			E.db.unitframe.units.target.health.position = 'RIGHT'
			if layout == "healer" then
				E.db.unitframe.units.target.health.text_format = "[healthcolor][health:deficit]      [health:current-percent]"
				E.db.unitframe.units.target.customTexts = {}
				E.db.unitframe.units.target.customTexts.Absorb = {}
				E.db.unitframe.units.target.customTexts.Absorb.font = "ElvUI Font"
				E.db.unitframe.units.target.customTexts.Absorb.justifyH = "CENTER"
				E.db.unitframe.units.target.customTexts.Absorb.fontOutline = "OUTLINE"
				E.db.unitframe.units.target.customTexts.Absorb.xOffset = 40
				E.db.unitframe.units.target.customTexts.Absorb.yOffset = -9
				E.db.unitframe.units.target.customTexts.Absorb.text_format = "[absorbs]"
				E.db.unitframe.units.target.customTexts.Absorb.size = 10
			else
				E.db.unitframe.units.target.health.text_format = "[healthcolor][health:current-percent]"
			end
			E.db.unitframe.units.target.power.position = 'RIGHT';
			E.db.unitframe.units.target.power.hideonnpc = false;
			E.db.unitframe.units.target.power.text_format = "[powercolor][power:current:sl]"
			E.db.unitframe.units.target.power.height = 8
			E.db.unitframe.units.target.power.position = "BOTTOMRIGHT"
			E.db.unitframe.units.target.power.yOffset = 8
			E.db.unitframe.units.target.power.width = "inset"
			E.db.unitframe.units.target.name.text_format = "[name:medium] [level] [shortclassification]";
			E.db.unitframe.units.target.name.position = 'TOPLEFT'
			E.db.unitframe.units.target.name.yOffset = -3
			E.db.unitframe.units.target.portrait.enable = true
			E.db.unitframe.units.target.portrait.overlay = true
			E.db.unitframe.units.target.portrait.camDistanceScale = 3
			E.db.unitframe.units.target.portrait.rotation = 345
			E.db.unitframe.units.target.buffs.perrow = 10
			E.db.unitframe.units.target.buffs.numrows = 2
			E.db.unitframe.units.target.buffs.yOffset = 6
			E.db.unitframe.units.target.buffs.anchorPoint = 'TOPLEFT';
			E.db.unitframe.units.target.buffs.useBlacklist.friendly = false
			E.db.unitframe.units.target.buffs.useBlacklist.enemy = false
			E.db.unitframe.units.target.debuffs.perrow = 10;
			E.db.unitframe.units.target.debuffs.playerOnly.enemy = false
			E.db.unitframe.units.target.debuffs.useBlacklist.friendly = false
			E.db.unitframe.units.target.debuffs.useBlacklist.enemy = false
			E.db.unitframe.units.target.castbar.format = 'CURRENTMAX';
			if layout == "healer" then
				E.db.unitframe.units.target.castbar.width = 200
			else
				E.db.unitframe.units.target.castbar.width = 210
			end
			E.db.unitframe.units.target.aurabar.enable = false
			E.db.unitframe.units.target.combobar.height = 8
			E.db.unitframe.units.target.combobar.fill = "spaced"
			
			--Target of Target
			if layout == "healer" then
				E.db.unitframe.units.targettarget.width = 100
			else
				E.db.unitframe.units.targettarget.width = 130
			end
			E.db.unitframe.units.targettarget.name.text_format = "[name:medium]"
			E.db.unitframe.units.targettarget.debuffs.enable = false
			E.db.unitframe.units.targettarget.power.width = "inset"
			
			--Focus
			if layout == "healer" then
				E.db.unitframe.units.focus.height = 34
				E.db.unitframe.units.focus.width = 170
				E.db.unitframe.units.focus.castbar.width = 170
			else
				E.db.unitframe.units.focus.height = 50
				E.db.unitframe.units.focus.width = 190
				E.db.unitframe.units.focus.castbar.width = 190
			end
			E.db.unitframe.units.focus.health.position = 'BOTTOMRIGHT'
			E.db.unitframe.units.focus.power.width = "inset"
			E.db.unitframe.units.focus.debuffs.sizeOverride = 22
			E.db.unitframe.units.focus.debuffs.anchorPoint = "TOPLEFT"
			E.db.unitframe.units.focus.castbar.format = 'CURRENTMAX'
			
			--Focus Target
			E.db.unitframe.units.focustarget.enable = true
			if layout == "healer" then
				E.db.unitframe.units.focustarget.width = 122
			else
				E.db.unitframe.units.focustarget.width = 190
			end
			
			--Pet
			E.db.unitframe.units.pet.height = 30
			E.db.unitframe.units.pet.width = 105
			E.db.unitframe.units.pet.power.width = "inset"
			E.db.unitframe.units.pet.name.position = 'TOP'
			
			--Pet Target
			E.db.unitframe.units.pettarget.name.text_format = "[name:short]"
			E.db.unitframe.units.pettarget.enable = true
			E.db.unitframe.units.pettarget.height = 30
			E.db.unitframe.units.pettarget.width = 105
			
			--Party
			if layout == "healer" then
				E.db.unitframe.units.party.visibility = "[@raid6,exists] hide;show"
				E.db.unitframe.units.party.healPrediction = true
				E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.party.health.frequentUpdates = true
				E.db.unitframe.units.party.debuffs.enable = true
				E.db.unitframe.units.party.debuffs.anchorPoint = "BOTTOMLEFT"
				E.db.unitframe.units.party.GPSArrow.onMouseOver = false
				E.db.unitframe.units.party.GPSArrow.outOfRange = true
				
				E.db.unitframe.units.party.customTexts = {}
				E.db.unitframe.units.party.customTexts.Absorb = {}
				E.db.unitframe.units.party.customTexts.Absorb.font = "ElvUI Font"
				E.db.unitframe.units.party.customTexts.Absorb.justifyH = "CENTER"
				E.db.unitframe.units.party.customTexts.Absorb.fontOutline = "OUTLINE"
				E.db.unitframe.units.party.customTexts.Absorb.xOffset = 0
				E.db.unitframe.units.party.customTexts.Absorb.yOffset = 3
				E.db.unitframe.units.party.customTexts.Absorb.text_format = "[absorbs]"
				E.db.unitframe.units.party.customTexts.Absorb.size = 10

			else
				E.db.unitframe.units.party.healPrediction = false
				E.db.unitframe.units.party.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.party.health.frequentUpdates = false
				E.db.unitframe.units.party.debuffs.enable = false
				E.db.unitframe.units.party.GPSArrow.onMouseOver = true
				E.db.unitframe.units.party.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.party.health.orientation = "HORIZONTAL"
			E.db.unitframe.units.party.growthDirection = "RIGHT_DOWN"
			E.db.unitframe.units.party.width = 80
			E.db.unitframe.units.party.horizontalSpacing = 1
			E.db.unitframe.units.party.health.position = "BOTTOM"
			E.db.unitframe.units.party.health.yOffset = 8
			E.db.unitframe.units.party.power.width = "inset"
			E.db.unitframe.units.party.power.text_format = ""
			E.db.unitframe.units.party.roleIcon.position = "RIGHT"
			E.db.unitframe.units.party.debuffs.sizeOverride = 0
			E.db.unitframe.units.party.name.position = "TOP"
			E.db.unitframe.units.party.GPSArrow.size = 30
			
			--Raid 10
			if layout == "healer" then
				E.db.unitframe.units.raid10.height = 36
				E.db.unitframe.units.raid10.healPrediction = true
				E.db.unitframe.units.raid10.health.frequentUpdates = true
				E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.raid10.GPSArrow.onMouseOver = false
				E.db.unitframe.units.raid10.GPSArrow.outOfRange = true
				
				E.db.unitframe.units.raid10.customTexts = {}
				E.db.unitframe.units.raid10.customTexts.Absorb = {}
				E.db.unitframe.units.raid10.customTexts.Absorb.font = "ElvUI Font"
				E.db.unitframe.units.raid10.customTexts.Absorb.justifyH = "CENTER"
				E.db.unitframe.units.raid10.customTexts.Absorb.fontOutline = "OUTLINE"
				E.db.unitframe.units.raid10.customTexts.Absorb.xOffset = 0
				E.db.unitframe.units.raid10.customTexts.Absorb.yOffset = 3
				E.db.unitframe.units.raid10.customTexts.Absorb.text_format = "[absorbs]"
				E.db.unitframe.units.raid10.customTexts.Absorb.size = 10
			else
				E.db.unitframe.units.raid10.height = 44
				E.db.unitframe.units.raid10.healPrediction = false
				E.db.unitframe.units.raid10.health.frequentUpdates = false
				E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.raid10.GPSArrow.onMouseOver = true
				E.db.unitframe.units.raid10.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.raid10.health.orientation = "HORIZONTAL"
			E.db.unitframe.units.raid10.horizontalSpacing = 1
			E.db.unitframe.units.raid10.verticalSpacing = 1
			E.db.unitframe.units.raid10.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid10.health.yOffset = 8
			E.db.unitframe.units.raid10.power.width = "inset"
			E.db.unitframe.units.raid10.debuffs.enable = false
			E.db.unitframe.units.raid10.rdebuffs.size = 18
			E.db.unitframe.units.raid10.roleIcon.position = "RIGHT"
			E.db.unitframe.units.raid10.groupBy = "GROUP"
			E.db.unitframe.units.raid10.GPSArrow.size = 30
			
			--Raid 25
			if layout == "healer" then
				E.db.unitframe.units.raid25.healPrediction = true
				E.db.unitframe.units.raid25.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.raid25.health.frequentUpdates = true
				E.db.unitframe.units.raid25.height = 36
				E.db.unitframe.units.raid25.GPSArrow.onMouseOver = false
				E.db.unitframe.units.raid25.GPSArrow.outOfRange = true
				
				E.db.unitframe.units.raid25.customTexts = {}
				E.db.unitframe.units.raid25.customTexts.Absorb = {}
				E.db.unitframe.units.raid25.customTexts.Absorb.font = "ElvUI Font"
				E.db.unitframe.units.raid25.customTexts.Absorb.justifyH = "CENTER"
				E.db.unitframe.units.raid25.customTexts.Absorb.fontOutline = "OUTLINE"
				E.db.unitframe.units.raid25.customTexts.Absorb.xOffset = 0
				E.db.unitframe.units.raid25.customTexts.Absorb.yOffset = 3
				E.db.unitframe.units.raid25.customTexts.Absorb.text_format = "[absorbs]"
				E.db.unitframe.units.raid25.customTexts.Absorb.size = 10
			else
				E.db.unitframe.units.raid25.healPrediction = false
				E.db.unitframe.units.raid25.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.raid25.health.frequentUpdates = false
				E.db.unitframe.units.raid25.height = 44
				E.db.unitframe.units.raid25.GPSArrow.onMouseOver = true
				E.db.unitframe.units.raid25.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.raid25.health.orientation = "HORIZONTAL"
			E.db.unitframe.units.raid25.horizontalSpacing = 1
			E.db.unitframe.units.raid25.verticalSpacing = 1
			E.db.unitframe.units.raid25.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid25.health.yOffset = 8
			E.db.unitframe.units.raid25.power.width = "inset"
			E.db.unitframe.units.raid25.debuffs.enable = false
			E.db.unitframe.units.raid25.rdebuffs.size = 18
			E.db.unitframe.units.raid25.roleIcon.position = "RIGHT"
			E.db.unitframe.units.raid25.groupBy = "GROUP"
			E.db.unitframe.units.raid25.GPSArrow.size = 30
			
			--Raid 40
			if layout == "healer" then
				E.db.unitframe.units.raid40.healPrediction = true
				E.db.unitframe.units.raid40.health.frequentUpdates = true
				E.db.unitframe.units.raid40.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.raid40.health.orientation = "VERTICAL"
			else
				E.db.unitframe.units.raid40.healPrediction = false
				E.db.unitframe.units.raid40.health.frequentUpdates = false
				E.db.unitframe.units.raid40.health.text_format = ""
				E.db.unitframe.units.raid40.health.orientation = "HORIZONTAL"
			end
			E.db.unitframe.units.raid40.horizontalSpacing = 1
			E.db.unitframe.units.raid40.verticalSpacing = 1
			E.db.unitframe.units.raid40.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid40.name.position = "TOP"
			E.db.unitframe.units.raid40.roleIcon.enable = true
			E.db.unitframe.units.raid40.roleIcon.position = "RIGHT"
			E.db.unitframe.units.raid40.groupBy = "GROUP"

			--Tank
			if layout == "healer" then
				E.db.unitframe.units.tank.enable = true
				E.db.unitframe.units.tank.targetsGroup.enable = false
				E.db.unitframe.units.tank.height = 24
			else
				E.db.unitframe.units.tank.enable = false
			end
			
			--Assist
			E.db.unitframe.units.assist.enable = false

			--Arena
			E.db.unitframe.units.arena.width = 200
			E.db.unitframe.units.arena.height = 46
			E.db.unitframe.units.arena.growthDirection = 'DOWN'
			E.db.unitframe.units.arena.health.position = "RIGHT"
			E.db.unitframe.units.arena.health.text_format = "[healthcolor][health:current-percent]"
			E.db.unitframe.units.arena.power.yOffset = 7
			E.db.unitframe.units.arena.power.width = "inset"
			E.db.unitframe.units.arena.castbar.format = 'CURRENTMAX'
			E.db.unitframe.units.arena.castbar.width = 200
			E.db.unitframe.units.arena.pvpTrinket.xOffset = 0
			E.db.unitframe.units.arena.name.position = "TOPLEFT"
								
			--Boss
			E.db.unitframe.units.boss.width = 200
			E.db.unitframe.units.boss.growthDirection = 'DOWN'
			E.db.unitframe.units.boss.portrait.rotation = 345
			E.db.unitframe.units.boss.portrait.overlay = true
			E.db.unitframe.units.boss.portrait.camDistanceScale = 4
			E.db.unitframe.units.boss.portrait.enable = true
			E.db.unitframe.units.boss.health.position = "RIGHT"
			E.db.unitframe.units.boss.health.text_format = "[healthcolor][health:current-percent]"
			E.db.unitframe.units.boss.power.width = "inset"
			E.db.unitframe.units.boss.power.yOffset = 7
			E.db.unitframe.units.boss.castbar.format = 'CURRENTMAX'
			E.db.unitframe.units.boss.castbar.width = 200
			E.db.unitframe.units.boss.name.position = "TOPLEFT"
								
			--Power text
			E.db.sle.powtext = true

	end	

	--Actionbars
	do
		E.db.actionbar.font = "ElvUI Font"
		E.db.actionbar.fontOutline = 'OUTLINE'
		E.db.actionbar.hotkeytext = false
		E.db.actionbar.keyDown = false
		
		E.db.actionbar.bar1.point = "TOPLEFT"
		E.db.actionbar.bar1.buttonsPerRow = 3
		E.db.actionbar.bar1.buttonspacing = 1
		E.db.actionbar.bar1.buttonsize = 23

		E.db.actionbar.bar2.enabled = true
		E.db.actionbar.bar2.point = "TOPLEFT"
		E.db.actionbar.bar2.buttonsPerRow = 3
		E.db.actionbar.bar2.buttonspacing = 1
		E.db.actionbar.bar2.buttonsize = 23
		E.db.actionbar.bar2.visibility = "[petbattle] hide; show"
		
		E.db.actionbar.bar3.point = "TOPLEFT"
		E.db.actionbar.bar3.buttons = 12
		E.db.actionbar.bar3.buttonsPerRow = 3
		E.db.actionbar.bar3.buttonspacing = 1
		E.db.actionbar.bar3.buttonsize = 23
		E.db.actionbar.bar3.visibility = "[petbattle] hide; show"
		
		E.db.actionbar.bar4.enabled = true
		E.db.actionbar.bar4.point = "TOPLEFT"
		E.db.actionbar.bar4.buttonsPerRow = 6
		E.db.actionbar.bar4.buttonspacing = 1
		E.db.actionbar.bar4.buttonsize = 23
		E.db.actionbar.bar4.visibility = "[petbattle] hide; show"
		E.db.actionbar.bar4.backdrop = false
		
		E.db.actionbar.bar5.point = "TOPLEFT"
		E.db.actionbar.bar5.buttons = 12
		E.db.actionbar.bar5.buttonspacing = 1
		E.db.actionbar.bar5.buttonsize = 23
		E.db.actionbar.bar5.visibility = "[petbattle] hide; show"

		E.db.actionbar.bar6.enabled = true
		E.db.actionbar.bar6.point = "TOPLEFT"
		E.db.actionbar.bar6.buttonspacing = 1
		E.db.actionbar.bar6.mouseover = true
		E.db.actionbar.bar6.buttonsize = 20
		E.db.actionbar.bar6.visibility = "show"
		
		E.db.actionbar.microbar.enabled = true
		E.db.actionbar.microbar.buttonsPerRow = 2
		
		E.db.actionbar.stanceBar.buttonspacing = 1
		E.db.actionbar.stanceBar.buttonsize = 16
		
		E.db.actionbar.barPet.point = "TOPLEFT"
		E.db.actionbar.barPet.buttonspacing = 1
		E.db.actionbar.barPet.backdrop = false
		E.db.actionbar.barPet.buttonsPerRow = 5
		E.db.actionbar.barPet.buttonsize = 20
	end

	--Raid marks--
	E.db.sle.marks.enabled = true
	E.db.sle.marks.growth = "LEFT"
	E.db.sle.marks.backdrop = false
	E.db.sle.marks.size = 16

	--Combat icon--
	E.db.sle.combatico.pos = 'TOPRIGHT'

	--Loot History--
	E.db.sle.lootwin = true
	E.db.sle.lootalpha = 0.9

	--UI Buttons--
	E.db.sle.uibuttons.enable = true
	E.db.sle.uibuttons.size = 15
	
	--Farm--
	E.db.sle.farm.size = 23
	E.db.sle.farm.autotarget = true
	E.db.sle.farm.quest = true
	E.db.sle.farm.seedor = "BOTTOM"
	
	--LocationLite--
	E.db.loclite.lpfontsize = 10
	E.db.loclite.lpfontflags = "OUTLINE"
	E.db.loclite.lpwidth = 300
	E.db.loclite.dig = false
	E.db.loclite.lpauto = false
	E.db.loclite.trans = true
	
	--Loading private settings--
	E.private.general.dmgfont = "ElvUI Font"
	
	E.private.sle.farm.enable = true
	E.private.sle.farm.seedtrash = true
	
	E.private.sle.equip.spam = true
	
	E.private.sle.characterframeoptions.enable = true
	
	if IsAddOnLoaded("ElvUI_AddOnSkins") then
		E.private.addonskins.EmbedSkada = true
		E.private.addonskins.EmbedBelowTop = true
		E.private.addonskins.EmbedalDamageMeter = false
		E.private.addonskins.DBMFontSize = 10
		E.private.addonskins.DBMSkinHalf = true
		E.private.addonskins.DBMFont = "ElvUI Font"
		E.private.addonskins.EmbedSystemDual = true
	end
	
	E.private.general.normTex = "Polished Wood"
	E.private.general.glossTex = "Polished Wood"

	--Moving stuff--
	do
		if layout == "healer" then
			E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-308176"
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM-102135"
			E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM308176"
			E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMElvUIParentBOTTOM102135"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-446190"
			E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM308118"
			E.db.movers.ElvUF_FocusTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-445126"
			E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-297147"
			E.db.movers.ElvUF_PetTargetMover = "BOTTOMElvUIParentBOTTOM-29773"
			E.db.movers.PetAB = "BOTTOMElvUIParentBOTTOM-298104"
			E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT442203"
			E.db.movers.TempEnchantMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT488176"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM0182"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_TankMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT428231"
			E.db.movers.BossButton = "BOTTOMElvUIParentBOTTOM2389"
			E.db.movers.BNETMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42743"
		else
			E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-214158"
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM0135"
			E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM214158"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM17497"
			E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-448158"
			E.db.movers.ElvUF_FocusTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-450106"
			E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-266129"
			E.db.movers.ElvUF_PetTargetMover = "BOTTOMElvUIParentBOTTOM-161129"
			E.db.movers.PetAB = "BOTTOMElvUIParentBOTTOM-26685"
			E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT613100"
			E.db.movers.TempEnchantMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT557174"
			E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0203"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0203"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0203"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0203"	
			E.db.movers.BossButton = "BOTTOMElvUIParentBOTTOM0195"
			E.db.movers.BNETMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42753"
		end
		E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM020"
		E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM7320"
		E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM-7320"
		E.db.movers.ElvAB_4 = "BOTTOMElvUIParentBOTTOM-18220"
		E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM18220"
		E.db.movers.ElvAB_6 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT0180"
		E.db.movers.MinimapMover = "TOPRIGHTElvUIParentTOPRIGHT2-19"
		E.db.movers.UIBFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-1-199"
		E.db.movers.WatchFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-47-198"
		E.db.movers.BossHeaderMover = "TOPLEFTElvUIParentTOPLEFT0-280"
		E.db.movers.ArenaHeaderMover = "TOPLEFTElvUIParentTOPLEFT0-280"
		E.db.movers.PetBattleABMover = "BOTTOMElvUIParentBOTTOM019"
		E.db.movers.ShiftAB = "BOTTOMElvUIParentBOTTOM-16168"
		E.db.movers.ExperienceBarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42419"
		E.db.movers.ReputationBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT47319"
		E.db.movers.PvPMover = "TOPElvUIParentTOP0-39"
		E.db.movers.LocationMover = "TOPElvUIParentTOP0-28"
		E.db.movers.LocationLiteMover = "TOPElvUIParentTOP0-19"
		E.db.movers.MarkMover = "BOTTOMElvUIParentBOTTOM0115"
		E.db.movers.MicrobarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT42418"
		E.db.movers.LootFrameMover = "BOTTOMElvUIParentBOTTOM-287461"
		E.db.movers.AurasMover = "TOPRIGHTElvUIParentTOPRIGHT-201-18"
		E.db.movers.GMMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-43319"
		E.db.movers.VehicleSeatMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT48219"
		E.db.movers.DP_1_Mover = "TOPLEFTElvUIParentTOPLEFT00"
		E.db.movers.DP_2_Mover = "TOPLEFTElvUIParentTOPLEFT3850"
		E.db.movers.DP_3_Mover = "TOPRIGHTElvUIParentTOPRIGHT-3850"
		E.db.movers.DP_4_Mover = "TOPRIGHTElvUIParentTOPRIGHT00"
		E.db.movers.DP_5_Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4110"
		E.db.movers.DP_6_Mover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4110"
		E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM00"
		E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
		E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
		E.db.movers.RaidUtility_Mover = "TOPElvUIParentTOP-305-19"
		E.db.movers.AltPowerBarMover = "TOPElvUIParentTOP0-39"
		E.db.movers.FarmSeedMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-300211"
		E.db.movers.FarmToolMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-175211"
		E.db.movers.AlertFrameMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT303416"
	end
	
	E:UpdateAll(true)
end

function RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
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

function AffinitiiSetup() --The function to switch from class ElvUI settings to Affinitii's
	SLEInstallStepComplete.message = L["Affinitii's Defaults Set"]
	SLEInstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	layout = E.db.layoutSet  --Pull which layout was selected if any.
	pixel = E.PixelMode  --Pull PixelMode
	E.private.general.pixelPerfect = true
	E.db.general.autoAcceptInvite = true
	E.db.general.autoRepair = "GUILD"
	E.db.general.bottomPanel = false
	E.db.general.topPanel = false
	E.db.general.backdropfadecolor = {
		["r"] = 0.054,
		["g"] = 0.054,
		["b"] = 0.054,
	}
	E.db.general.valuecolor = {
		["r"] = 0.09,
		["g"] = 0.513,
		["b"] = 0.819,
	}
	E.db.general.health = {
	}
	E.db.general.BUFFS = {
	}
	E.db.general.vendorGrays = true
	E.db.general.autoRoll = true
	E.db.general.threat.position = "LEFTCHAT"

	E.private.general.normTex = "Polished Wood"
	E.private.general.glossTex = "Polished Wood"
	E.private.skins.addons.EmbedSkada = true
	E.private.skins.addons.AlwaysTrue = true

	E.db.gridSize = 110
	E.db.hideTutorial = 1

	E.db.tooltip.style = "inset"

	--Chat
	E.db.chat.editBoxPosition = "ABOVE_CHAT"
	E.db.chat.emotionIcons = false
	if GetScreenWidth() < 1920 then
		E.db.chat.panelWidth = 380
	else
		E.db.chat.panelWidth = 412
	end

	--Unitframes
	E.db.unitframe.font = "ElvUI Pixel"
	E.db.unitframe.fontOutline = "MONOCHROMEOUTLINE"
	E.db.unitframe.statusbar = "Polished Wood"
	E.db.unitframe.smartRaidFilter = true
	E.db.unitframe.colors.healthclass = false
	E.db.unitframe.colors.castColor = {
		["r"] = 0.1,
		["g"] = 0.1,
		["b"] = 0.1,
	}
	E.db.unitframe.colors.health = {--
		["r"] = 0.2352941176470588,
		["g"] = 0.2352941176470588,
		["b"] = 0.2352941176470588,
	}
	E.db.unitframe.colors.auraBarBuff = {
		["b"] = 0.09411764705882353,
		["g"] = 0.07843137254901961,
		["r"] = 0.3098039215686275,
	}
	E.db.unitframe.colors.transparentPower = true
	E.db.unitframe.colors.transparentHealth = true

	E.db.unitframe.units.tank.enable = false

	E.db.unitframe.units.assist.enable = false
	E.db.unitframe.units.assist.targetsGroup.enable = false

	E.db.unitframe.units.arena.power.width = "inset"
	E.db.unitframe.units.arena.power.offset = 0

	E.db.unitframe.units.targettarget.power.width = "inset"
	E.db.unitframe.units.targettarget.power.offset = 0

	E.db.unitframe.units.pet.power.width = "inset"
	E.db.unitframe.units.pet.power.offset = 0

	E.db.unitframe.units.pettarget.power.width = "inset"

	E.db.unitframe.units.boss.portrait.enable = true
	E.db.unitframe.units.boss.portrait.overlay = true
	E.db.unitframe.units.boss.power.width = "inset"
	E.db.unitframe.units.boss.power.offset = 0

	E.db.unitframe.units.focus.power.width = "inset"
	E.db.unitframe.units.focus.power.offset = 0

	E.db.unitframe.units.player.debuffs.attachTo = "BUFFS"
	E.db.unitframe.units.player.portrait.overlay = true
	E.db.unitframe.units.player.portrait.enable = true
	E.db.unitframe.units.player.classbar.enable = false
	E.db.unitframe.units.player.aurabar.enable = false
	E.db.unitframe.units.player.power.width = "inset"
	E.db.unitframe.units.player.power.offset = 0
	E.db.unitframe.units.player.buffs.enable = true
	E.db.unitframe.units.player.buffs.attachTo = "FRAME"
	E.db.unitframe.units.player.buffs.noDuration = false
	E.db.unitframe.units.player.castbar.width = 410
	E.db.unitframe.units.player.castbar.height = 25

	E.db.unitframe.units.target.portrait.enable = true
	E.db.unitframe.units.target.portrait.overlay = true
	E.db.unitframe.units.target.aurabar.enable = false
	E.db.unitframe.units.target.power.width = "inset"
	E.db.unitframe.units.target.power.offset = 0

	E.db.unitframe.units.focustarget.power.width = "inset"

	if not E.db.unitframe.units.party.customTexts then
		E.db.unitframe.units.party.customTexts = {};
		if not E.db.unitframe.units.party.customTexts["Health Text"] then
			E.db.unitframe.units.party.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.party.customTexts["Health Text"] = {
		["font"] = "ElvUI Pixel",
		["justifyH"] = "CENTER",
		["fontOutline"] = "MONOCHROMEOUTLINE",
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
	E.db.unitframe.units.party.buffIndicator.size = 10
	E.db.unitframe.units.party.point = "RIGHT"
	E.db.unitframe.units.party.xOffset = -1
	E.db.unitframe.units.party.yOffset = 1
	E.db.unitframe.units.party.power.width = "inset"
	E.db.unitframe.units.party.power.offset = 0
	E.db.unitframe.units.party.power.text_format = ""
	E.db.unitframe.units.party.buffIndicator.size = 10
	E.db.unitframe.units.party.roleIcon.enable = false
	E.db.unitframe.units.party.GPSArrow.size = 40
	E.db.unitframe.units.party.growthDirection = "LEFT_UP"
	E.db.unitframe.units.party.healPrediction = true
	E.db.unitframe.units.party.health.frequentUpdates = true
	E.db.unitframe.units.party.health.text_format = ""
	E.db.unitframe.units.party.health.position = "BOTTOM"
	E.db.unitframe.units.party.name.text_format = "[namecolor][name:veryshort] [difficultycolor][smartlevel]"
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
	E.db.unitframe.units.party.petsGroup.anchorPoint = "BOTTOM"
	E.db.unitframe.units.party.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.party.raidicon.xOffset = 9
	E.db.unitframe.units.party.raidicon.size = 13
	E.db.unitframe.units.party.raidicon.yOffset = 0
	E.db.unitframe.units.party.targetsGroup.anchorPoint = "BOTTOM"
	E.db.unitframe.units.party.width = 80
	E.db.unitframe.units.party.height = 45
	E.db.unitframe.units.party.groupBy = "GROUP"

	if not E.db.unitframe.units.raid10.customTexts then
		E.db.unitframe.units.raid10.customTexts = {};
		if not E.db.unitframe.units.raid10.customTexts["Health Text"] then
			E.db.unitframe.units.raid10.customTexts["Health Text"] = {};
		end
	end
	E.db.unitframe.units.raid10.customTexts["Health Text"] = {
		["font"] = "ElvUI Pixel",
		["justifyH"] = "CENTER",
		["fontOutline"] = "MONOCHROMEOUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid10.columnAnchorPoint = "BOTTOM"
	E.db.unitframe.units.raid10.buffIndicator.fontSize = 10
	E.db.unitframe.units.raid10.point = "RIGHT"
	E.db.unitframe.units.raid10.rdebuffs.enable = false
	E.db.unitframe.units.raid10.yOffset = 4
	E.db.unitframe.units.raid10.xOffset = -1
	E.db.unitframe.units.raid10.roleIcon.enable = false
	E.db.unitframe.units.raid10.power.width = "inset"
	E.db.unitframe.units.raid10.power.offset = 0
	E.db.unitframe.units.raid10.positionOverride = "BOTTOMRIGHT"
	E.db.unitframe.units.raid10.healPrediction = true
	E.db.unitframe.units.raid10.health.frequentUpdates = true
	E.db.unitframe.units.raid10.health.text_format = ""
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
	E.db.unitframe.units.raid10.name.text_format = "[namecolor][name:veryshort]"
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
		["font"] = "ElvUI Pixel",
		["justifyH"] = "CENTER",
		["fontOutline"] = "MONOCHROMEOUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid25.columnAnchorPoint = "RIGHT"
	E.db.unitframe.units.raid25.buffIndicator.fontSize = 10
	E.db.unitframe.units.raid25.point = "BOTTOM"
	E.db.unitframe.units.raid25.rdebuffs.enable = false
	E.db.unitframe.units.raid25.xOffset = 1
	E.db.unitframe.units.raid25.roleIcon.enable = false
	E.db.unitframe.units.raid25.power.offset = 0
	E.db.unitframe.units.raid25.power.width = "inset"
	E.db.unitframe.units.raid25.power.position = "CENTER"
	E.db.unitframe.units.raid25.growthDirection = "UP_LEFT"
	E.db.unitframe.units.raid25.healPrediction = true
	E.db.unitframe.units.raid25.health.frequentUpdates = true
	E.db.unitframe.units.raid25.health.text_format = ""
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
	E.db.unitframe.units.raid25.name.text_format = "[namecolor][name:veryshort]"
	E.db.unitframe.units.raid25.yOffset = 4
	E.db.unitframe.units.raid25.width = 80
	E.db.unitframe.units.raid25.height = 45
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
		["font"] = "ElvUI Pixel",
		["justifyH"] = "CENTER",
		["fontOutline"] = "MONOCHROMEOUTLINE",
		["xOffset"] = 0,
		["size"] = 10,
		["text_format"] = "[healthcolor][health:deficit]",
		["yOffset"] = -7,
	}
	E.db.unitframe.units.raid40.columnAnchorPoint = "RIGHT"
	E.db.unitframe.units.raid40.point = "BOTTOM"
	E.db.unitframe.units.raid40.xOffset = 1
	E.db.unitframe.units.raid40.yOffset = 1
	E.db.unitframe.units.raid40.growthDirection = "UP_LEFT"
	E.db.unitframe.units.raid40.healPrediction = true
	E.db.unitframe.units.raid40.width = 50
	E.db.unitframe.units.raid40.height = 43
	E.db.unitframe.units.raid40.raidicon.xOffset = 9
	E.db.unitframe.units.raid40.raidicon.yOffset = 0
	E.db.unitframe.units.raid40.raidicon.size = 13
	E.db.unitframe.units.raid40.raidicon.attachTo = "LEFT"
	E.db.unitframe.units.raid40.rdebuffs.size = 26
	E.db.unitframe.units.raid40.name.position = "TOP"
	E.db.unitframe.units.raid40.buffIndicator.fontSize = 10
	E.db.unitframe.units.raid40.power.enable = true
	E.db.unitframe.units.raid40.power.offset = 0
	E.db.unitframe.units.raid40.power.width = "inset"
	E.db.unitframe.units.raid40.power.position = "CENTER"
	E.db.unitframe.units.raid40.health.frequentUpdates = true
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
	E.db.unitframe.units.raid40.name.text_format = "[namecolor][name:veryshort]"
	E.db.unitframe.units.raid40.groupBy = "GROUP"

	--Actionbars
	--Bar 1
	E.db.actionbar.bar1.enabled = true
	E.db.actionbar.bar1.backdrop = false
	E.db.actionbar.bar1.buttons = 12
	E.db.actionbar.bar1.buttonsize = 32
	E.db.actionbar.bar1.buttonspacing = 2
	--Bar 2
	E.db.actionbar.bar2.enabled = true
	E.db.actionbar.bar2.backdrop = true
	E.db.actionbar.bar2.buttons = 12
	E.db.actionbar.bar2.buttonsize = 32
	E.db.actionbar.bar2.buttonspacing = 2
	E.db.actionbar.bar2.heightMult = 2
	--Bar 3
	E.db.actionbar.bar3.enabled = true
	E.db.actionbar.bar3.backdrop = true
	E.db.actionbar.bar3.buttons = 6
	E.db.actionbar.bar3.buttonsize = 32
	E.db.actionbar.bar3.buttonspacing = 2
	E.db.actionbar.bar3.buttonsPerRow = 3
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
	--Stance Bar
	E.db.actionbar.stanceBar.buttonsPerRow = 1
	--Pet Bar
	E.db.actionbar.barPet.point = "TOPRIGHT"
	E.db.actionbar.barPet.buttonsPerRow = 1

	--Datatext
	do
		E.db.datatexts.panelTransparency = false
		E.db.datatexts.minimapPanels = true
		E.db.datatexts.fontOutline = "None"
		E.db.sle.datatext.dp1.enabled = false
		E.db.sle.datatext.dp2.enabled = false
		E.db.sle.datatext.dp3.enabled = false
		E.db.sle.datatext.dp4.enabled = false
		E.db.sle.datatext.dp5.enabled = false
		E.db.sle.datatext.dp6.enabled = true
		E.db.sle.datatext.top.enabled = true
		E.db.sle.datatext.bottom.enabled = true
		if GetScreenWidth() < 1920 then
			E.db.sle.datatext.dp6.width = 410
			E.db.sle.datatext.bottom.width = 104
			E.db.sle.datatext.top.width = 104
			E.db.sle.datatext.chatleft.width = 364
			E.db.sle.datatext.chatright.width = 364
		elseif GetScreenWidth() > 1920 then
			E.db.sle.datatext.dp6.width = 402
			E.db.sle.datatext.bottom.width = 102
			E.db.sle.datatext.top.width = 102
			E.db.sle.datatext.chatleft.width = 396
			E.db.sle.datatext.chatright.width = 396
		else
			E.db.sle.datatext.dp6.width = 410
			E.db.sle.datatext.bottom.width = 104
			E.db.sle.datatext.top.width = 104
			E.db.sle.datatext.chatleft.width = 396
			E.db.sle.datatext.chatright.width = 396
		end
		E.db.datatexts.panels['DP_6']['left'] = "System"
		E.db.datatexts.panels['DP_6']['middle'] = "Time"
		E.db.datatexts.panels['DP_6']['right'] = "Gold"
		E.db.datatexts.panels['LeftChatDataPanel']['left'] = ""
		E.db.datatexts.panels['LeftChatDataPanel']['middle'] = "Durability"
		E.db.datatexts.panels['LeftChatDataPanel']['right'] = ""
		E.db.datatexts.panels['RightChatDataPanel']['left'] = "Skada"
		E.db.datatexts.panels['RightChatDataPanel']['middle'] = "Combat Time"
		E.db.datatexts.panels['RightChatDataPanel']['right'] = "WeakAuras"
		E.db.datatexts.panels['Top_Center'] = "Spec Switch"
		E.db.datatexts.panels['Bottom_Panel'] = "Bags"
		E.db.datatexts.panels['LeftMiniPanel'] = "Guild"
		E.db.datatexts.panels['RightMiniPanel'] = "Friends"

		--Datatext Panels Spec Specific
		if layout == 'tank' then
			--E.db.datatexts.panels.DP_5.middle = ""
			--E.db.datatexts.panels.DP_5.right = ""
			--E.db.datatexts.panels.DP_6.left = ""
			--E.db.datatexts.panels.DP_6.middle = ""
		elseif layout == 'healer' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Spell/Heal Power"
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Haste"
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Spell/Heal Power"
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Haste"
		else
			--E.db.datatexts.panels.DP_5.middle = ""
			--E.db.datatexts.panels.DP_5.right = ""
			--E.db.datatexts.panels.DP_6.left = ""
			--E.db.datatexts.panels.DP_6.middle = ""
		end
	end
	do
		if GetScreenWidth() > 1920 then
			E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM25427"
			E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-25427"
			E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM2544"
			E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2544"
		else
			E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM26027"
			E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-26027"
			E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM2604"
			E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2604"
		end
		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-278200"
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM0100"
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM278200"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0190"
		--E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310432"
		E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM-63436"
		E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0230"
		E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM060"
		E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM027"
		E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM04"
		E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
		E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
		E.db.movers.PetAB = "RIGHTElvUIParentRIGHT00"
		E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-210-410"
		E.db.movers.BossHeaderMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-210435"
		if layout == 'dpsCaster' or layout == 'dpsMelee' or layout == 'tank' then
			E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT4200"
			E.db.movers["BossButton"] = "CENTERElvUIParentCENTER-413188"
		else
			E.db.movers.ElvUF_PartyMover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMRIGHTElvUIParentCENTER-213-90"
			E.db.movers["BossButton"] = "CENTERElvUIParentCENTER-413188"
		end
		
		if GetScreenWidth() < 1920 then
			E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-380200"
			E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT38221"
			E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT38221"
		else
			E.db.movers.ElvAB_4 = "BOTTOMLEFTElvUIParentBOTTOMRIGHT-413200"
			E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
			E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT41421"
		end
	end

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
	InstallNextButton:Disable()
	InstallPrevButton:Disable()
	InstallOption1Button:Hide()
	InstallOption1Button:SetScript("OnClick", nil)
	InstallOption1Button:SetText("")
	InstallOption2Button:Hide()
	InstallOption2Button:SetScript('OnClick', nil)
	InstallOption2Button:SetText('')
	InstallOption3Button:Hide()
	InstallOption3Button:SetScript('OnClick', nil)
	InstallOption3Button:SetText('')	
	InstallOption4Button:Hide()
	InstallOption4Button:SetScript('OnClick', nil)
	InstallOption4Button:SetText('')
	SLEInstallFrame.SubTitle:SetText("")
	SLEInstallFrame.Desc1:SetText("")
	SLEInstallFrame.Desc2:SetText("")
	SLEInstallFrame.Desc3:SetText("")
	SLEInstallFrame:Size(550, 400)
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	InstallStatus:SetValue(PageNum)

	local f = SLEInstallFrame

	if PageNum == MAX_PAGE then
		InstallNextButton:Disable()
	else
		InstallNextButton:Enable()
	end

	if PageNum == 1 then
		InstallPrevButton:Disable()
	else
		InstallPrevButton:Enable()
	end

	if PageNum == 1 then
		f.SubTitle:SetText(format(L["Welcome to |cff1784d1Shadow & Light|r version %s!"], SLE.version))
		f.Desc1:SetText("This install process will setup configuration of Shadow & Light.")
		f.Desc2:SetText("")
		f.Desc3:SetText(L["Please press the continue button to go onto the next step."])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Skip Process"])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L["Chat"])
		f.Desc1:SetText("This options will determine if you want to use default ElvUI's chat datapanels or let Shadow & Light handle them.")
		f.Desc2:SetText("Shadow & Light will dock them outside of actual chat panels.")
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", function() E.db.sle.datatext.chathandle = false; E:GetModule('Layout'):ToggleChatPanels() end)
		InstallOption1Button:SetText("ElvUI Panels")
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E.db.sle.datatext.chathandle = true; E:GetModule('Layout'):ToggleChatPanels() end)
		InstallOption2Button:SetText("S&L Panels")
	elseif PageNum == 3 then
		f.SubTitle:SetText(L["Armory Mode"])
		f.Desc1:SetText("Imma test text")
		f.Desc2:SetText("This page is for armory mode disable/enable stuff")
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
		
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E.private.sle.characterframeoptions.enable = true; E.private.sle.inspectframeoptions.enable = true; end)
		InstallOption1Button:SetText(L["Enable"])	
	elseif PageNum == 4 then
		f.SubTitle:SetText("Shadow & Light Settings")
		f.Desc1:SetText(L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."])
		f.Desc2:SetText(L["SLE_Install_Text2"])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() DarthSetup() end)
		InstallOption1Button:SetText(L["Darth's Config"])	

		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() AffinitiiSetup() end)
		InstallOption2Button:SetText(L["Affinitii's Config"])

		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() RepoocSetup() end)
		InstallOption3Button:SetText(L["Repooc's Config"])
	elseif PageNum == 5 then 
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Finished"])				
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

		f.Next = CreateFrame("Button", "InstallNextButton", f, "UIPanelButtonTemplate")
		f.Next:StripTextures()
		f.Next:SetTemplate("Default", true)
		f.Next:Size(110, 25)
		f.Next:Point("BOTTOMRIGHT", -5, 5)
		f.Next:SetText(CONTINUE)
		f.Next:Disable()
		f.Next:SetScript("OnClick", NextPage)
		E.Skins:HandleButton(f.Next, true)

		f.Prev = CreateFrame("Button", "InstallPrevButton", f, "UIPanelButtonTemplate")
		f.Prev:StripTextures()
		f.Prev:SetTemplate("Default", true)
		f.Prev:Size(110, 25)
		f.Prev:Point("BOTTOMLEFT", 5, 5)
		f.Prev:SetText(PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript("OnClick", PreviousPage)
		E.Skins:HandleButton(f.Prev, true)

		f.Status = CreateFrame("StatusBar", "InstallStatus", f)
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

		f.Option1 = CreateFrame("Button", "InstallOption1Button", f, "UIPanelButtonTemplate")
		f.Option1:StripTextures()
		f.Option1:Size(160, 30)
		f.Option1:Point("BOTTOM", 0, 45)
		f.Option1:SetText("")
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)

		f.Option2 = CreateFrame("Button", "InstallOption2Button", f, "UIPanelButtonTemplate")
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45)
		f.Option2:SetText("")
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 45) end)
		E.Skins:HandleButton(f.Option2, true)		

		f.Option3 = CreateFrame("Button", "InstallOption3Button", f, "UIPanelButtonTemplate")
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText("")
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45)  end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point("BOTTOM", 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option3, true)			

		f.Option4 = CreateFrame("Button", "InstallOption4Button", f, "UIPanelButtonTemplate")
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

		local close = CreateFrame("Button", "InstallCloseButton", f, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
		close:SetScript("OnClick", function()
			f:Hide()
		end)		
		E.Skins:HandleCloseButton(close)

		f.tutorialImage = f:CreateTexture('InstallTutorialImage', 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner')
		f.tutorialImage:Point('BOTTOM', 0, 70)
	end

	SLEInstallFrame:Show()
	NextPage()
end