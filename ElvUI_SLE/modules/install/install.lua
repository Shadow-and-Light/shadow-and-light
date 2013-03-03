local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');
local AI = E:GetModule('AddonInstaller');

local CURRENT_PAGE = 0
local MAX_PAGE

local function MaxPages()
	if IsAddOnLoaded("ElvUI_Hud") then	
		MAX_PAGE = 11
	else
		MAX_PAGE = 10
	end
end

local function SetupChat()
	InstallStepComplete.message = L["Chat Set"]
	InstallStepComplete:Show()			
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)

	FCF_OpenNewWindow(LOOT)
	FCF_UnDockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3, 1)
	ChatFrame3:Show()			

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		-- move general bottom left
		if i == 1 then
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 1, 3)			
		elseif i == 3 then
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 1, 3)
		end

		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)

		-- set default Elvui font size
		FCF_SetChatWindowFontSize(nil, frame, 12)

		-- rename windows general because moved to chat #3
		if i == 1 then
			FCF_SetWindowName(frame, GENERAL)
		elseif i == 2 then
			FCF_SetWindowName(frame, GUILD_EVENT_LOG)
		elseif i == 3 then 
			FCF_SetWindowName(frame, LOOT.." / "..TRADE) 
		end
	end

	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")	
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")


	ChatFrame_RemoveAllMessageGroups(ChatFrame3)	
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_AddChannel(ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(ChatFrame1, L['Trade'])
	ChatFrame_AddChannel(ChatFrame3, L['Trade'])


	if E.myname == "Elvz" then
		SetCVar("scriptErrors", 1)
	end	

	-- enable classcolor automatically on login and on each character without doing /configure each time.
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")		
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
	
	--Adjust Chat Colors
	--General
	ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
	--Trade
	ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
	--Local Defense
	ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)

	if E.Chat then
		E.Chat:PositionChat(true)
		if E.db['RightChatPanelFaded'] then
			RightChatToggleButton:Click()
		end

		if E.db['LeftChatPanelFaded'] then
			LeftChatToggleButton:Click()
		end		
	end
end

local function SetupCVars()
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("showTutorials", 0)
	SetCVar("UberTooltips", 1)
	SetCVar("threatWarning", 3)
	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('SpamFilter', 0) --Blocks mmo-champion.com, dumb... ElvUI one is more effeciant anyways.
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()

	InstallStepComplete.message = L["CVars Set"]
	InstallStepComplete:Show()					
end	

function E:GetColor(r, b, g, a)	
	return { r = r, b = b, g = g, a = a }
end

function E:SetupPixelPerfect(enabled, noMsg)
	E.private.general.pixelPerfect = enabled;

	if (E.PixelMode ~= enabled) then
		E:StaticPopup_Show('PIXELPERFECT_CHANGED')
	end

	if not noMsg then
		E.db.general.bottomPanel = enabled
		E:GetModule('Layout'):BottomPanelVisibility()
	end

	if noMsg then
		if enabled then
			if not E.db.movers then E.db.movers = {}; end
			
			E.db.actionbar.bar1.backdrop = false;
			E.db.actionbar.bar3.backdrop = false;
			E.db.actionbar.bar5.backdrop = false;			
			E.db.actionbar.bar1.buttonspacing = 2;
			E.db.actionbar.bar2.buttonspacing = 2;
			E.db.actionbar.bar3.buttonspacing = 2;
			E.db.actionbar.bar4.buttonspacing = 2;
			E.db.actionbar.bar5.buttonspacing = 2;
			E.db.actionbar.barPet.buttonspacing = 2;
			E.db.actionbar.stanceBar.buttonspacing = 2;			
		else
			E.db.actionbar.bar1.backdrop = true;
			E.db.actionbar.bar3.backdrop = true;
			E.db.actionbar.bar5.backdrop = true;
			E.db.actionbar.bar1.buttonspacing = 4;
			E.db.actionbar.bar2.buttonspacing = 4;
			E.db.actionbar.bar3.buttonspacing = 4;
			E.db.actionbar.bar4.buttonspacing = 4;
			E.db.actionbar.bar5.buttonspacing = 4;
			E.db.actionbar.barPet.buttonspacing = 4;
			E.db.actionbar.stanceBar.buttonspacing = 4;
		end
	end	

	if InstallStepComplete and not noMsg then
		InstallStepComplete.message = L["Pixel Perfect Set"]
		InstallStepComplete:Show()	
		E:UpdateAll(true)		
	end


	E.PixelMode = enabled
end

function E:SetupTheme(theme, noDisplayMsg)
	local classColor = RAID_CLASS_COLORS[E.myclass]
	E.private.theme = theme


	--Set colors
	if theme == "classic" then
		E.db.general.bordercolor = E:GetColor(.31, .31, .31)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)

		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.health = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.castColor = E:GetColor(.31, .31, .31)

	elseif theme == "class" then
		E.db.general.bordercolor = E:GetColor(.31, .31, .31)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.healthclass = true
		E.db.unitframe.colors.castColor = E:GetColor(classColor.r, classColor.b, classColor.g)
	else
		E.db.general.bordercolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.054, .054, .054, .8)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.1, .1, .1)
		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.health = E:GetColor(.1, .1, .1)
		E.db.unitframe.colors.castColor = E:GetColor(.1, .1, .1)
	end

	--Value Color
	if theme == "class" then
		E.db.general.valuecolor = E:GetColor(classColor.r, classColor.b, classColor.g)
	else
		E.db.general.valuecolor = E:GetColor(.09, .819, .513)
	end

	if not noDisplayMsg then
		E:UpdateAll(true)
	end

	if InstallStatus then
		InstallStatus:SetStatusBarColor(unpack(E['media'].rgbvaluecolor))

		if InstallStepComplete and not noDisplayMsg then
			InstallStepComplete.message = L["Theme Set"]
			InstallStepComplete:Show()
		end
	end
end

function E:SetupResolution(noDataReset)
	if not noDataReset then
		E:ResetMovers('')
	end

	if self == 'low' then
		if not E.db.movers then E.db.movers = {}; end
		if not noDataReset then
			E.db.chat.panelWidth = 400
			E.db.chat.panelHeight = 180

			E:CopyTable(E.db.actionbar, P.actionbar)

			E.db.actionbar.bar1.heightMult = 2;
			E.db.actionbar.bar2.enabled = true;
			E.db.actionbar.bar3.enabled = false;
			E.db.actionbar.bar5.enabled = false;
		end

		if not noDataReset then
			E.db.auras.wrapAfter = 10;
		end
		E.db.general.reputation.width = 400
		E.db.general.experience.width = 400
		E.db.movers.ElvAB_2 = "CENTERElvUIParentBOTTOM056.18"

		if not noDataReset then
			E:CopyTable(E.db.unitframe.units, P.unitframe.units)

			E.db.unitframe.fontSize = 10

			E.db.unitframe.units.player.width = 200;
			E.db.unitframe.units.player.castbar.width = 200;
			E.db.unitframe.units.player.classbar.fill = 'fill';
			E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current]"

			E.db.unitframe.units.target.width = 200;
			E.db.unitframe.units.target.castbar.width = 200;
			E.db.unitframe.units.target.health.text_format = '[healthcolor][health:current]'

			E.db.unitframe.units.pet.power.enable = false;
			E.db.unitframe.units.pet.width = 200;
			E.db.unitframe.units.pet.height = 26;

			E.db.unitframe.units.targettarget.debuffs.enable = false;
			E.db.unitframe.units.targettarget.power.enable = false;
			E.db.unitframe.units.targettarget.width = 200;
			E.db.unitframe.units.targettarget.height = 26;	

			E.db.unitframe.units.boss.width = 200;
			E.db.unitframe.units.boss.castbar.width = 200;
			E.db.unitframe.units.arena.width = 200;
			E.db.unitframe.units.arena.castbar.width = 200;			
		end

		local isPixel = E.private.general.pixelPerfect
		local xOffset = isPixel and 103 or 106;
		local yOffset = isPixel and 125 or 135;
		local yOffsetSmall = isPixel and 76 or 80;

		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM"..-xOffset..""..yOffset
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM"..xOffset..""..yOffsetSmall
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM"..xOffset..""..yOffset
		E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM"..-xOffset..""..yOffsetSmall
		E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"

		E.db.lowresolutionset = true;
	elseif not noDataReset then
		E.db.chat.panelWidth = P.chat.panelWidth
		E.db.chat.panelHeight = P.chat.panelHeight

		E:CopyTable(E.db.actionbar, P.actionbar)
		E:CopyTable(E.db.unitframe.units, P.unitframe.units)
		E:SetupPixelPerfect(E.PixelMode, true)
		E.db.auras.wrapAfter = P.auras.wrapAfter;	
		E.db.general.reputation.width = P.general.reputation.width
		E.db.general.experience.width = P.general.experience.width

		E.db.lowresolutionset = nil;
	end

	if not noDataReset and E.private.theme then
		E:SetupTheme(E.private.theme, true)
	end

	E:UpdateAll(true)

	if InstallStepComplete and not noDataReset then
		InstallStepComplete.message = L["Resolution Style Set"]
		InstallStepComplete:Show()		
	end
end

function E:SetupLayout(layout, noDataReset)
	--Unitframes
	if not noDataReset then
		E:CopyTable(E.db.unitframe.units, P.unitframe.units)
		E:CopyTable(E.db.sle.combatico, P.sle.combatico)
		E.db.sle.powtext = false
	end

	if not noDataReset then
		E:ResetMovers('')
		E:SetupPixelPerfect(E.PixelMode, true)		
		if not E.db.movers then E.db.movers = {} end
		
		E.db.actionbar.bar2.enabled = E.db.lowresolutionset
		if E.PixelMode then
			E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM038"
		else
			E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM040"
		end
		if not E.db.lowresolutionset then
			E.db.actionbar.bar3.buttons = 6
			E.db.actionbar.bar5.buttons = 6
			E.db.actionbar.bar4.enabled = true
		end			
	end

	if layout == 'healer' then
		if not IsAddOnLoaded('Clique') then
			E:Print(L['Using the healer layout it is highly recommended you download the addon Clique to work side by side with ElvUI.'])
		end

		if not noDataReset then
			E.db.unitframe.units.raid10.xOffset = 9;
			E.db.unitframe.units.raid10.rdebuffs.enable = false;
			E.db.unitframe.units.raid10.yOffset = 9;
			E.db.unitframe.units.raid10.debuffs.sizeOverride = 16;
			E.db.unitframe.units.raid10.debuffs.enable = true
			E.db.unitframe.units.raid10.debuffs.anchorPoint = "TOPRIGHT";
			E.db.unitframe.units.raid10.debuffs.xOffset = -4;
			E.db.unitframe.units.raid10.debuffs.yOffset = -7;
			E.db.unitframe.units.raid10.positionOverride = "BOTTOMRIGHT";
			E.db.unitframe.units.raid10.height = 45;
			E.db.unitframe.units.raid10.buffs.noConsolidated = false
			E.db.unitframe.units.raid10.buffs.xOffset = 50;
			E.db.unitframe.units.raid10.buffs.yOffset = -6;
			E.db.unitframe.units.raid10.buffs.clickThrough = true
			E.db.unitframe.units.raid10.buffs.noDuration = false
			E.db.unitframe.units.raid10.buffs.playerOnly = false;
			E.db.unitframe.units.raid10.buffs.perrow = 1
			E.db.unitframe.units.raid10.buffs.useFilter = "TurtleBuffs"
			E.db.unitframe.units.raid10.buffs.sizeOverride = 22
			E.db.unitframe.units.raid10.buffs.useBlacklist = false
			E.db.unitframe.units.raid10.buffs.enable = true

			E.db.unitframe.units.raid25.xOffset = 9;
			E.db.unitframe.units.raid25.rdebuffs.enable = false;
			E.db.unitframe.units.raid25.yOffset = 9;
			E.db.unitframe.units.raid25.debuffs.sizeOverride = 16;
			E.db.unitframe.units.raid25.debuffs.enable = true
			E.db.unitframe.units.raid25.debuffs.anchorPoint = "TOPRIGHT";
			E.db.unitframe.units.raid25.debuffs.xOffset = -4;
			E.db.unitframe.units.raid25.debuffs.yOffset = -7;
			E.db.unitframe.units.raid25.positionOverride = "BOTTOMRIGHT";
			E.db.unitframe.units.raid25.height = 45;
			E.db.unitframe.units.raid25.buffs.noConsolidated = false
			E.db.unitframe.units.raid25.buffs.xOffset = 50;
			E.db.unitframe.units.raid25.buffs.yOffset = -6;
			E.db.unitframe.units.raid25.buffs.clickThrough = true
			E.db.unitframe.units.raid25.buffs.noDuration = false
			E.db.unitframe.units.raid25.buffs.playerOnly = false;
			E.db.unitframe.units.raid25.buffs.perrow = 1
			E.db.unitframe.units.raid25.buffs.useFilter = "TurtleBuffs"
			E.db.unitframe.units.raid25.buffs.sizeOverride = 22
			E.db.unitframe.units.raid25.buffs.useBlacklist = false
			E.db.unitframe.units.raid25.buffs.enable = true			

			E.db.unitframe.units.party.point = "LEFT"
			E.db.unitframe.units.party.xOffset = 9;
			E.db.unitframe.units.party.yOffset = 9;
			E.db.unitframe.units.party.debuffs.sizeOverride = 16;
			E.db.unitframe.units.party.debuffs.enable = true
			E.db.unitframe.units.party.debuffs.anchorPoint = "TOPRIGHT";
			E.db.unitframe.units.party.debuffs.xOffset = -4;
			E.db.unitframe.units.party.debuffs.yOffset = -7;
			E.db.unitframe.units.party.positionOverride = "BOTTOMRIGHT";
			E.db.unitframe.units.party.height = 45;
			E.db.unitframe.units.party.buffs.noConsolidated = false
			E.db.unitframe.units.party.buffs.xOffset = 50;
			E.db.unitframe.units.party.buffs.yOffset = -6;
			E.db.unitframe.units.party.buffs.clickThrough = true
			E.db.unitframe.units.party.buffs.noDuration = false
			E.db.unitframe.units.party.buffs.playerOnly = false;
			E.db.unitframe.units.party.buffs.perrow = 1
			E.db.unitframe.units.party.buffs.useFilter = "TurtleBuffs"
			E.db.unitframe.units.party.buffs.sizeOverride = 22
			E.db.unitframe.units.party.buffs.useBlacklist = false
			E.db.unitframe.units.party.buffs.enable = true	
			E.db.unitframe.units.party.roleIcon.position = "BOTTOMRIGHT"
			E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
			E.db.unitframe.units.party.health.position = "BOTTOM"
			E.db.unitframe.units.party.GPSArrow.size = 40
			E.db.unitframe.units.party.width = 80
			E.db.unitframe.units.party.height = 45
			E.db.unitframe.units.party.name.text_format = "[namecolor][name:short]"
			E.db.unitframe.units.party.name.position = "TOP"
			E.db.unitframe.units.party.power.text_format = ""



			E.db.unitframe.units.raid40.positionOverride = "BOTTOMRIGHT"
			E.db.unitframe.units.raid40.height = 30

			E.db.unitframe.units.party.health.frequentUpdates = true
			E.db.unitframe.units.raid10.health.frequentUpdates = true
			E.db.unitframe.units.raid25.health.frequentUpdates = true
			E.db.unitframe.units.raid40.health.frequentUpdates = true

			E.db.unitframe.units.party.healPrediction = true;
			E.db.unitframe.units.raid10.healPrediction = true;
			E.db.unitframe.units.raid25.healPrediction = true;
			E.db.unitframe.units.raid40.healPrediction = true;	

			E.db.actionbar.bar2.enabled = true
			if not E.db.lowresolutionset then
				E.db.actionbar.bar3.buttons = 12
				E.db.actionbar.bar5.buttons = 12
				E.db.actionbar.bar4.enabled = false
				if not E.PixelMode then
					E.db.actionbar.bar1.heightMult = 2
				end				
			end
		end

		if not E.db.movers then E.db.movers = {}; end
		local xOffset = GetScreenWidth() * 0.34375
		
		if E.PixelMode then
			E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM3124"
			E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-3124"
			E.db.movers.ElvUF_PartyMover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			
			if not E.db.lowresolutionset then
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM278132"
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-278132"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0176"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0132"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310432"
				E.db.movers["BossButton"] = "BOTTOMElvUIParentBOTTOM0275"
			else
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-102182"
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM102182"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM102120"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-102120"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"		
				E.db.movers["BossButton"] = "TOPElvUIParentTOP0-138"
			end
		else
			E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM3324"
			E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-3324"
			E.db.movers.ElvUF_PartyMover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMRIGHTElvUIParentBOTTOMLEFT"..xOffset.."450"
			
			if not E.db.lowresolutionset then
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM307145"
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-307145"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0186"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0145"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310432"
				E.db.movers["BossButton"] = "BOTTOMElvUIParentBOTTOM0275"
			else
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-118182"
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM118182"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM118120"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-118120"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"		
				E.db.movers["BossButton"] = "TOPElvUIParentTOP0-138"
			end		
		end
	elseif E.db.lowresolutionset then
		if not E.db.movers then E.db.movers = {}; end
		if E.PixelMode then
			E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-102135"
			E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM102135"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM10280"
			E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-10280"
			E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"			
		else
			E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-118142"
			E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM118142"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM11884"
			E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-11884"
			E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"	
		end
		
		E.db.movers["BossButton"] = "TOPElvUIParentTOP0-138"
	end
	
	if layout ~= 'healer' and not E.db.lowresolutionset then
		E.db.actionbar.bar1.heightMult = 1
	end
	
	if E.db.lowresolutionset and not noDataReset then
		E.db.unitframe.units.player.width = 200;
		if layout ~= 'healer' then
			E.db.unitframe.units.player.castbar.width = 200;
		end
		E.db.unitframe.units.player.classbar.fill = 'fill';

		E.db.unitframe.units.target.width = 200;
		E.db.unitframe.units.target.castbar.width = 200;

		E.db.unitframe.units.pet.power.enable = false;
		E.db.unitframe.units.pet.width = 200;
		E.db.unitframe.units.pet.height = 26;

		E.db.unitframe.units.targettarget.debuffs.enable = false;
		E.db.unitframe.units.targettarget.power.enable = false;
		E.db.unitframe.units.targettarget.width = 200;
		E.db.unitframe.units.targettarget.height = 26;	

		E.db.unitframe.units.boss.width = 200;
		E.db.unitframe.units.boss.castbar.width = 200;
		E.db.unitframe.units.arena.width = 200;
		E.db.unitframe.units.arena.castbar.width = 200;		
	end

	if(layout == 'dpsCaster' or layout == 'healer' or (layout == 'dpsMelee' and E.myclass == 'HUNTER')) then
		if not E.db.movers then E.db.movers = {}; end
		E.db.unitframe.units.player.castbar.width = 406
		E.db.unitframe.units.player.castbar.height = 28	
		local yOffset = 80
		if not E.db.lowresolutionset then
			if layout ~= 'healer' then
				yOffset = 42
				
				if E.PixelMode then
					E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-278110"
					E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM278110"
					E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0110"
					E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0150"			
					E.db.movers["BossButton"] = "BOTTOMElvUIParentBOTTOM0195"		
				else
					E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-307110"
					E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM307110"
					E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0110"
					E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0150"			
					E.db.movers["BossButton"] = "BOTTOMElvUIParentBOTTOM0195"						
				end
			else
				yOffset = 76
			end
		elseif E.db.lowresolutionset then
			if E.PixelMode then
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-102182"
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM102182"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM102120"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-102120"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"			
			else
				E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-118182"
				E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM118182"
				E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM118120"
				E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-118120"
				E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"						
			end
			
			E.db.movers["BossButton"] = "TOPElvUIParentTOP0-138"
		end
		
		if E.PixelMode then
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM0"..yOffset
		else
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM-2"..(yOffset + 5)
		end
	elseif (layout == 'dpsMelee' or layout == 'tank') and not E.db.lowresolutionset and not E.PixelMode then
		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-30776"
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM30776"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM076"
		E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM0115"			
		E.db.movers["BossButton"] = "BOTTOMElvUIParentBOTTOM0158"		
			
	end

	--Datatexts
	if not noDataReset then
		E:CopyTable(E.db.datatexts.panels, P.datatexts.panels)
		if layout == 'tank' then
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Avoidance';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Vengeance';
		elseif layout == 'healer' or layout == 'dpsCaster' then
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Spell/Heal Power';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Haste';
		else
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Attack Power';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Haste';
		end

		if InstallStepComplete then
			InstallStepComplete.message = L["Layout Set"]
			InstallStepComplete:Show()	
		end		
	end

	E.db.layoutSet = layout

	if not noDataReset and E.private.theme then
		E:SetupTheme(E.private.theme, true)
	end	

	if not noDataReset then
		E:CopyTable(E.db.sle.marks, P.sle.marks)
		E:CopyTable(E.db.sle.backgrounds, P.sle.backgrounds)
		E:CopyTable(E.db.sle.uibuttons, P.sle.uibuttons)
	end

	E:UpdateAll(true)
	local DT = E:GetModule('DataTexts')
	DT:LoadDataTexts()
end


local function SetupAuras(style)
	E:CopyTable(E.db.unitframe.units.player.buffs, P.unitframe.units.player.buffs)
	E:CopyTable(E.db.unitframe.units.player.debuffs, P.unitframe.units.player.debuffs)
	E:CopyTable(E.db.unitframe.units.player.aurabar, P.unitframe.units.player.aurabar)

	E:CopyTable(E.db.unitframe.units.target.buffs, P.unitframe.units.target.buffs)
	E:CopyTable(E.db.unitframe.units.target.debuffs, P.unitframe.units.target.debuffs)	
	E:CopyTable(E.db.unitframe.units.target.aurabar, P.unitframe.units.target.aurabar)
	E.db.unitframe.units.target.smartAuraDisplay = P.unitframe.units.target.smartAuraDisplay

	E:CopyTable(E.db.unitframe.units.focus.buffs, P.unitframe.units.focus.buffs)
	E:CopyTable(E.db.unitframe.units.focus.debuffs, P.unitframe.units.focus.debuffs)	
	E:CopyTable(E.db.unitframe.units.focus.aurabar, P.unitframe.units.focus.aurabar)
	E.db.unitframe.units.focus.smartAuraDisplay = P.unitframe.units.focus.smartAuraDisplay		

	if not style then
		--PLAYER
		E.db.unitframe.units.player.buffs.enable = true;
		E.db.unitframe.units.player.buffs.attachTo = 'FRAME';
		E.db.unitframe.units.player.buffs.noDuration = false;

		E.db.unitframe.units.player.debuffs.attachTo = 'BUFFS';

		E.db.unitframe.units.player.aurabar.enable = false;

		--TARGET
		E.db.unitframe.units.target.smartAuraDisplay = 'DISABLED';
		E.db.unitframe.units.target.debuffs.enable = true;
		E.db.unitframe.units.target.aurabar.enable = false;
	elseif style == 'integrated' then
		--seriosly is this fucking hard??
		E.db.unitframe.units.target.smartAuraDisplay = 'SHOW_DEBUFFS_ON_FRIENDLIES';
		E.db.unitframe.units.target.buffs.playerOnly = {friendly = true, enemy = false};
		E.db.unitframe.units.target.debuffs.enable = false;
		E.db.unitframe.units.target.aurabar.attachTo = 'BUFFS';
	end

	E:GetModule('UnitFrames'):Update_AllFrames()	
	if InstallStepComplete then
		InstallStepComplete.message = L["Auras Set"]
		InstallStepComplete:Show()		
	end	
end


function E:DarthSetup() --The function to switch from classic ElvUI settings to Darth's
	InstallStepComplete.message = L["Darth's Defaults Set"]
	InstallStepComplete:Show()
	E:CopyTable(E.db, P)
	E:CopyTable(E.db.sle, P.sle)
	if not E.db.movers then E.db.movers = {}; end
	if not E.db.loclite then E.db.loclite = {} end

	layout = E.db.layoutSet --To know if some sort of layout was choosed before

	--General options--
	E.db.general.stickyFrames = false
	E.db.general.autoRepair = "PLAYER"
	E.db.general.vendorGrays = true
	E.db.general.fontsize = 10
	E.db.general.minimap.locationText = 'HIDE'
	E.db.general.experience.textFormat = 'CURPERC'
	E.db.general.experience.textSize = 10
	E.db.general.experience.width = 380
	E.db.general.reputation.textFormat = 'CURMAX'
	E.db.general.reputation.textSize = 10
	E.db.general.reputation.width = 380	
	E.db.general.threat.enable = false
	E.db.general.totems.spacing = 2
	E.db.general.totems.size = 25
	E.db.general.bottomPanel = false
	E.db.general.topPanel = false

	--Bags--
	E.db.bags.bagSize = 22
	E.db.bags.bankSize = 22
	E.db.bags.sortInverted = false
	E.db.bags.alignToChat = false
	E.db.bags.bagWidth = 425
	E.db.bags.bankWidth = 425
	E.db.bags.yOffset = 186
	E.db.bags.currencyFormat = "ICON"

	--NamePlate--
	E.db.nameplate.healthtext = 'CURRENT_PERCENT'
	E.db.nameplate.lowHealthWarning = 'NONE'
	E.db.nameplate.fontOutline = "OUTLINE"
	E.db.nameplate.font = "ElvUI Font"
	E.db.nameplate.height = 8
	E.db.nameplate.auraFont = "ElvUI Font"
	E.db.nameplate.auraFontOutline = "OUTLINE"
	E.db.nameplate.classIcons = false

	--Auras--
	E.db.auras.font = "ElvUI Font"
	E.db.auras.fontOutline = "OUTLINE"
	E.db.auras.wrapAfter = 18
	E.db.sle.castername = true
	E.db.auras.fadeThreshold = 3
	E.db.auras.consolidatedBuffs.fontSize = 9
	E.db.auras.consolidatedBuffs.fontOutline = "OUTLINE"
	E.db.auras.consolidatedBuffs.font = "ElvUI Font"
	E.db.auras.consolidatedBuffs.filter = false

	--Chat--
	E.db.chat.editboxhistory = 10
	E.db.chat.emotionIcons = false
	E.db.chat.panelHeight = 192
	E.db.chat.panelWidth = 425
	E.db.chat.panelTabBackdrop = false
	E.db.chat.timeStampFormat = "%H:%M:%S "
	E.db.chat.whisperSound = "Whisper Alert"
	E.db.chat.fade = false
	E.db.chat.fontOutline = "OUTLINE"
	E.db.chat.tabFontOutline = "OUTLINE"

	--Datatexts--
	do
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

		E.db.datatexts.panels.Top_Center = 'Version';
		E.db.datatexts.panels.Bottom_Panel = 'System';
		E.db.datatexts.panels.LeftChatDataPanel.right = 'Friends';
		E.db.datatexts.panels.LeftChatDataPanel.left = 'Call to Arms';
		E.db.datatexts.panels.LeftChatDataPanel.middle = 'Durability';
		E.db.datatexts.panels.LeftMiniPanel = '';
		E.db.datatexts.panels.RightMiniPanel = '';
		E.db.datatexts.panels.DP_1.right = 'AtlasLoot';
		E.db.datatexts.panels.DP_1.middle = 'MrtWoo';
		E.db.datatexts.panels.DP_1.left = 'Swatter';
		E.db.datatexts.panels.DP_2.right = 'Guild';
		E.db.datatexts.panels.DP_2.middle = 'Skada';
		E.db.datatexts.panels.DP_2.left = 'Altoholic';
		E.db.datatexts.panels.DP_3.right = 'Notes';
		E.db.datatexts.panels.DP_3.middle = 'DBM-LDB';
		E.db.datatexts.panels.DP_3.left = 'Time';
		E.db.datatexts.panels.DP_4.right = '';
		E.db.datatexts.panels.DP_4.middle = '';
		E.db.datatexts.panels.DP_4.left = 'Combat Time';
		E.db.datatexts.panels.DP_5.middle = 'Gold';
		E.db.datatexts.panels.DP_5.left = 'Bags';

		if layout == 'tank' then
			E.db.datatexts.panels.DP_6.left = 'Avoidance';
			E.db.datatexts.panels.DP_6.middle = 'Vengeance';
			E.db.datatexts.panels.DP_6.right = 'Expertise';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
			E.db.datatexts.panels.DP_5.right = 'Armor';
		elseif layout == 'healer' then
			E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'MP5';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
			E.db.datatexts.panels.DP_5.right = '';
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
			E.db.datatexts.panels.DP_5.right = '';
		else
			E.db.datatexts.panels.DP_6.left = 'Attack Power';
			E.db.datatexts.panels.DP_6.middle = 'Haste';
			E.db.datatexts.panels.DP_6.right = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
			E.db.datatexts.panels.DP_5.right = 'Expertise';
		end
	end

	--Unitframes--
	do
		E.db.unitframe.smoothbars = false
		E.db.unitframe.font = "ElvUI Font"
		E.db.unitframe.fontsize = 9
		E.db.unitframe.fontOutline = 'OUTLINE'
		E.db.unitframe.colors.castColor = {
									["b"] = 0.396078431372549,
									["g"] = 0.7333333333333333,
									["r"] = 0.796078431372549,
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
		E.db.unitframe.colors.transparentHealth = true
		E.db.unitframe.colors.transparentPower = true
		E.db.unitframe.colors.transparentCastbar = true
		E.db.unitframe.colors.transparentAurabars = true
			--Setting player frame
			E.db.unitframe.units.player.width = 210
			E.db.unitframe.units.player.height = 50
			if layout == "healer" then
				E.db.unitframe.units.player.lowmana = 30;
			else
				E.db.unitframe.units.player.lowmana = 0;
			end
			E.db.unitframe.units.player.health.position = 'BOTTOMRIGHT';
			E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current-percent:sl]"
			E.db.unitframe.units.player.power.text_format = "[powercolor][power:current:sl]";
			E.db.unitframe.units.player.power.height = 8
			E.db.unitframe.units.player.power.position = "BOTTOMRIGHT"
			E.db.unitframe.units.player.power.yOffset = -12
			E.db.unitframe.units.player.name.text_format = "[name] [level]";
			E.db.unitframe.units.player.name.position = 'TOPLEFT';
			E.db.unitframe.units.player.pvp.text_format = "||cFFB04F4F[pvptimer]||r"
			E.db.unitframe.units.player.pvp.position = "BOTTOMLEFT"
			E.db.unitframe.units.player.portrait.enable = true
			E.db.unitframe.units.player.portrait.camDistanceScale = 1.7;
			E.db.unitframe.units.player.portrait.width = 35
			E.db.unitframe.units.player.debuffs.enable = false;
			E.db.unitframe.units.player.castbar.format = 'CURRENTMAX';
			if layout == "healer" then
				E.db.unitframe.units.player.castbar.width = 200
			else
				E.db.unitframe.units.player.castbar.width = 210
			end
			E.db.unitframe.units.player.classbar.fill = 'fill'
			E.db.unitframe.units.player.classbar.height = 8
			E.db.unitframe.units.player.aurabar.enable = false
			E.db.unitframe.units.player.raidicon.enable = false
			
			--Setting target frame
			E.db.unitframe.units.target.width = 210
			E.db.unitframe.units.target.height = 50
			E.db.unitframe.units.target.health.position = 'BOTTOMRIGHT';
			if layout == "healer" then
				E.db.unitframe.units.target.health.text_format = "[healthcolor][health:deficit] [health:current-percent:sl]"
			else
				E.db.unitframe.units.target.health.text_format = "[healthcolor][health:current-percent:sl]"
			end
			E.db.unitframe.units.target.power.position = 'RIGHT';
			E.db.unitframe.units.target.power.hideonnpc = false;
			E.db.unitframe.units.target.power.text_format = "[powercolor][power:current:sl]"
			E.db.unitframe.units.target.power.height = 8
			E.db.unitframe.units.target.power.position = "BOTTOMRIGHT"
			E.db.unitframe.units.target.power.yOffset = -12
			E.db.unitframe.units.target.name.text_format = "[name:medium] [level] [shortclassification]";
			E.db.unitframe.units.target.name.position = 'TOPLEFT';
			E.db.unitframe.units.target.portrait.enable = true
			E.db.unitframe.units.target.portrait.camDistanceScale = 1.7;
			E.db.unitframe.units.target.portrait.width = 35;
			E.db.unitframe.units.target.buffs.perrow = 10;
			E.db.unitframe.units.target.buffs.numrows = 2;
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
			
			--Target of Target
			if layout == "healer" then
				E.db.unitframe.units.targettarget.width = 100
			else
				E.db.unitframe.units.targettarget.width = 130
			end
			E.db.unitframe.units.targettarget.name.text_format = "[name:medium]"
			E.db.unitframe.units.targettarget.debuffs.enable = false
			
			--Focus
			if layout == "healer" then
				E.db.unitframe.units.focus.height = 34
			else
				E.db.unitframe.units.focus.height = 50
			end
			E.db.unitframe.units.focus.health.position = 'BOTTOMRIGHT'
			E.db.unitframe.units.focus.debuffs.sizeOverride = 22
			E.db.unitframe.units.focus.debuffs.anchorPoint = "TOPLEFT"
			E.db.unitframe.units.focus.castbar.format = 'CURRENTMAX'
			if layout == "healer" then
				E.db.unitframe.units.focus.castbar.width = 179
			else
				E.db.unitframe.units.focus.castbar.width = 190
			end
			
			--Focus Target
			E.db.unitframe.units.focustarget.enable = true
			if layout == "healer" then
				E.db.unitframe.units.focustarget.width = 179
			else
				E.db.unitframe.units.focustarget.width = 190
			end
			
			--Pet
			E.db.unitframe.units.pet.height = 30
			E.db.unitframe.units.pet.width = 105
			
			--Pet Target
			E.db.unitframe.units.pettarget.name.text_format = "[name:short]"
			E.db.unitframe.units.pettarget.enable = true
			E.db.unitframe.units.pettarget.height = 30
			E.db.unitframe.units.pettarget.width = 105
			
			--Party
			if layout == "healer" then
				E.db.unitframe.units.party.showSolo = true
				E.db.unitframe.units.party.healPrediction = true
				E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.party.health.orientation = "VERTICAL"
				E.db.unitframe.units.party.health.frequentUpdates = true
				E.db.unitframe.units.party.debuffs.enable = true
				E.db.unitframe.units.party.debuffs.anchorPoint = "BOTTOMLEFT"
				E.db.unitframe.units.party.GPSArrow.onMouseOver = false
				E.db.unitframe.units.party.GPSArrow.outOfRange = true
			else
				E.db.unitframe.units.party.showSolo = false
				E.db.unitframe.units.party.healPrediction = false
				E.db.unitframe.units.party.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.party.health.orientation = "HORIZONTAL"
				E.db.unitframe.units.party.health.frequentUpdates = false
				E.db.unitframe.units.party.debuffs.enable = false
				E.db.unitframe.units.party.GPSArrow.onMouseOver = true
				E.db.unitframe.units.party.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.party.point = "LEFT"
			E.db.unitframe.units.party.width = 80
			E.db.unitframe.units.party.xOffset = 3
			E.db.unitframe.units.party.health.position = "BOTTOM"
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
				E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:dificit]"
				E.db.unitframe.units.raid10.health.orientation = "VERTICAL"
				E.db.unitframe.units.raid10.GPSArrow.onMouseOver = false
				E.db.unitframe.units.raid10.GPSArrow.outOfRange = true
			else
				E.db.unitframe.units.raid10.height = 44
				E.db.unitframe.units.raid10.healPrediction = false
				E.db.unitframe.units.raid10.health.frequentUpdates = false
				E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.raid10.health.orientation = "HORIZONTAL"
				E.db.unitframe.units.raid10.GPSArrow.onMouseOver = true
				E.db.unitframe.units.raid10.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.raid10.xOffset = 1
			E.db.unitframe.units.raid10.yOffset = 1
			E.db.unitframe.units.raid10.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid10.rdebuffs.size = 18
			E.db.unitframe.units.raid10.roleIcon.position = "RIGHT"
			E.db.unitframe.units.raid10.groupBy = "GROUP"
			E.db.unitframe.units.raid10.GPSArrow.size = 30
			
			--Raid 25
			if layout == "healer" then
				E.db.unitframe.units.raid25.healPrediction = true
				E.db.unitframe.units.raid25.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.raid25.health.frequentUpdates = true
				E.db.unitframe.units.raid25.health.orientation = "VERTICAL"
				E.db.unitframe.units.raid25.height = 36
				E.db.unitframe.units.raid25.GPSArrow.onMouseOver = false
				E.db.unitframe.units.raid25.GPSArrow.outOfRange = true
			else
				E.db.unitframe.units.raid25.healPrediction = false
				E.db.unitframe.units.raid25.health.text_format = "[healthcolor][health:current]"
				E.db.unitframe.units.raid25.health.frequentUpdates = false
				E.db.unitframe.units.raid25.health.orientation = "HORIZONTAL"
				E.db.unitframe.units.raid25.height = 44
				E.db.unitframe.units.raid25.GPSArrow.onMouseOver = true
				E.db.unitframe.units.raid25.GPSArrow.outOfRange = false
			end
			E.db.unitframe.units.raid25.xOffset = 1
			E.db.unitframe.units.raid25.yOffset = 1
			E.db.unitframe.units.raid25.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid25.rdebuffs.size = 18
			E.db.unitframe.units.raid25.roleIcon.position = "RIGHT"
			E.db.unitframe.units.raid25.groupBy = "GROUP"
			E.db.unitframe.units.raid25.GPSArrow.size = 30
			
			--Raid 40
			if layout == "healer" then
				E.db.unitframe.units.raid25.healPrediction = true
				E.db.unitframe.units.raid40.health.frequentUpdates = true
				E.db.unitframe.units.raid40.health.text_format = "[healthcolor][health:deficit]"
				E.db.unitframe.units.raid40.health.orientation = "VERTICAL"
			else
				E.db.unitframe.units.raid40.healPrediction = false
				E.db.unitframe.units.raid40.health.frequentUpdates = false
				E.db.unitframe.units.raid40.health.text_format = ""
				E.db.unitframe.units.raid40.health.orientation = "HORIZONTAL"
			end
			E.db.unitframe.units.raid40.xOffset = 1
			E.db.unitframe.units.raid40.yOffset = 1
			E.db.unitframe.units.raid40.name.text_format = "[name:medium]"
			E.db.unitframe.units.raid40.name.position = "TOP"
			E.db.unitframe.units.raid25.roleIcon.enable = true
			E.db.unitframe.units.raid25.roleIcon.position = "RIGHT"
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
			E.db.unitframe.units.arena.castbar.format = 'CURRENTMAX'
			E.db.unitframe.units.arena.castbar.width = 200
								
			--Boss
			E.db.unitframe.units.boss.width = 200
			E.db.unitframe.units.boss.growthDirection = 'DOWN'
								
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
		E.db.actionbar.bar2.visibility = "[overridebar] hide; [petbattle] hide; show"
		
		E.db.actionbar.bar3.point = "TOPLEFT"
		E.db.actionbar.bar3.buttons = 12
		E.db.actionbar.bar3.buttonsPerRow = 3
		E.db.actionbar.bar3.buttonspacing = 1
		E.db.actionbar.bar3.buttonsize = 23
		E.db.actionbar.bar3.visibility = "[overridebar] hide; [petbattle] hide; show"
		
		E.db.actionbar.bar4.point = "TOPLEFT"
		E.db.actionbar.bar4.buttonsPerRow = 6
		E.db.actionbar.bar4.buttonspacing = 1
		E.db.actionbar.bar4.buttonsize = 23
		E.db.actionbar.bar4.visibility = "[overridebar] hide; [petbattle] hide; show"
		E.db.actionbar.bar4.backdrop = false
		
		E.db.actionbar.bar5.point = "TOPLEFT"
		E.db.actionbar.bar5.buttons = 12
		E.db.actionbar.bar5.buttonspacing = 1
		E.db.actionbar.bar5.buttonsize = 23
		E.db.actionbar.bar5.visibility = "[overridebar] hide; [petbattle] hide; show"
		
		E.db.actionbar.microbar.enabled = true
		E.db.actionbar.microbar.buttonsPerRow = 6
		E.db.actionbar.microbar.mouseover = true
		
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

	--Exp/Rep Bars--
	E.db.sle.exprep.explong = true
	E.db.sle.exprep.replong = true

	--Combat icon--
	E.db.sle.combatico.pos = 'TOPRIGHT'

	--Loot History--
	E.db.sle.lootwin = true
	E.db.sle.lootalpha = 0.9

	--Errors--
	E.db.sle.errors = true

	--UI Buttons--
	E.db.sle.uibuttons.enable = true
	E.db.sle.uibuttons.mouse = true
	
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
		E.private.auras.size = 22
		E.private.skins.addons.DBMSkinHalf = true
		E.private.skins.addons.EmbedSkada = true
		E.private.skins.addons.EmbedOoC = true
		E.private.skins.addons.AlwaysTrue = true

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
			E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT547147"
			E.db.movers.ElvUF_PetTargetMover = "BOTTOMElvUIParentBOTTOM-254147"
			E.db.movers.PetAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT547105"
			E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT438199"
			E.db.movers.TempEnchantMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT474164"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM0183"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMElvUIParentBOTTOM0156"
			E.db.movers.ElvUF_TankMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT428228"
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
			E.db.movers.TempEnchantMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT540174"
			E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0212"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0212"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0212"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT0212"	
			E.db.movers.BossButton = "BOTTOMElvUIParentBOTTOM0195"
			E.db.movers.BNETMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-42753"
		end
		E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM020"
		E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM7320"
		E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM-7320"
		E.db.movers.ElvAB_4 = "BOTTOMElvUIParentBOTTOM-18220"
		E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM18220"
		E.db.movers.MinimapMover = "TOPRIGHTElvUIParentTOPRIGHT2-19"
		E.db.movers.UIBFrameMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-426112"
		E.db.movers.WatchFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-219-208"
		E.db.movers.BossHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-2-199"
		E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-2-200"
		E.db.movers.PetBattleABMover = "BOTTOMElvUIParentBOTTOM019"
		E.db.movers.ShiftAB = "BOTTOMElvUIParentBOTTOM-16168"
		if UnitLevel('player') == 90 then
			E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP0-19"
			E.db.movers.ReputationBarMover = "TOPElvUIParentTOP0-19"
			E.db.movers.PvPMover = "TOPElvUIParentTOP0-48"
			E.db.movers.LocationMover = "TOPElvUIParentTOP0-28"
			E.db.movers.LocationLiteMover = "TOPElvUIParentTOP0-28"
			E.db.movers.AlertFrameMover = "TOPElvUIParentTOP0-105"
		else
			E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP0-19"
			E.db.movers.ReputationBarMover = "TOPElvUIParentTOP0-28"
			E.db.movers.LocationMover = "TOPElvUIParentTOP0-37"
			E.db.movers.LocationLiteMover = "TOPElvUIParentTOP0-37"
			E.db.movers.AlertFrameMover = "TOPElvUIParentTOP0-113"
			E.db.movers.PvPMover = "TOPElvUIParentTOP0-57"
		end
		E.db.movers.MarkMover = "BOTTOMElvUIParentBOTTOM0115"
		E.db.movers.MicrobarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT55620"
		E.db.movers.LootFrameMover = "TOPLEFTElvUIParentTOPLEFT238-329"
		E.db.movers.AurasMover = "TOPRIGHTElvUIParentTOPRIGHT-201-18"
		E.db.movers.GMMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT0454"
		E.db.movers.VehicleSeatMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT42419"
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
		E.db.movers.AltPowerBarMover = "TOPElvUIParentTOP0-238"
		E.db.movers.FarmSeedMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-300211"
		E.db.movers.FarmToolMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-175211"
	end
	
	E:UpdateAll(true)
end

function E:RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
	InstallStepComplete.message = L["Repooc's Defaults Set"]
	InstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end

	layout = E.db.layoutSet  --Pull which layout was selected if any.
	pixel = E.PixelMode  --Pull PixelMode
	--print(pixel);
	--General Options
	E.db.general.bottomPanel = true
	E.db.general.topPanel = true
	E.db.general.backdropfadecolor = {
		["b"] = 0.06,
		["g"] = 0.06,
		["r"] = 0.06,
	}
	E.db.general.valuecolor = {
		["b"] = 0.59,
		["g"] = 1,
		["r"] = 0,
	}
	E.db.general.vendorGrays = true
	E.db.general.bordercolor = {
		["b"] = 0.31,
		["g"] = 0.31,
		["r"] = 0.31,
	}
	E.db.general.experience.enable = true
	E.db.general.experience.textFormat = "CURPERC"
	E.db.general.experience.textSize = 10
	E.db.general.reputation.enable = true
	E.db.general.reputation.textFormat = "CURPERC"
	E.db.general.interruptAnnounce = "RAID"

	--Bags
	E.db.bags.xOffset = 3

	E.db.hideTutorial = 1

	--Chat
	E.db.chat.hyperlinkHover = false
	E.db.chat.editBoxPosition = "ABOVE_CHAT"
	E.db.chat.fontOutline = "OUTLINE"
	E.db.chat.panelBackdropNameLeft = "Interface\\AddOns\\ElvUI_SLE\\media\\textures\\logo_elvui_sle.tga"
	E.db.chat.panelBackdropNameRight = "Interface\\AddOns\\ElvUI_SLE\\media\\textures\\logo_elvui_sle.tga"
	E.db.chat.panelTabBackdrop = false
	E.db.chat.panelWidth = 433
	E.db.chat.tabFontSize = 11
	E.db.chat.timeStampFormat = "%I:%M %p "

	--Tooltip
	E.db.tooltip.count = false
	E.db.tooltip.spellid = false

	--Datatext
	do
		E.db.datatexts.minimapPanels = false
		E.db.datatexts.fontOutline = "OUTLINE"
		E.db.datatexts.lfrshow = true

		E.db.sle.datatext.bottom.enabled = true  --Checked
		E.private.sle.datatext.bottomhide = true
		E.db.sle.datatext.chatleft.width = 417
		E.db.sle.datatext.chatright.width = 417
		E.db.sle.datatext.dp1.enabled = false
		E.db.sle.datatext.dp2.enabled = false
		E.db.sle.datatext.dp3.enabled = false
		E.db.sle.datatext.dp4.enabled = false
		E.db.sle.datatext.dp5.enabled = true
		E.db.sle.datatext.dp5.width = 433
		E.private.sle.datatext.dp5hide = true
		E.db.sle.datatext.dp6.enabled = true
		E.db.sle.datatext.dp6.width = 433
		E.private.sle.datatext.dp6hide = true
		E.db.sle.datatext.top.enabled = true
		E.private.sle.datatext.tophide = true

		--Datatext Panels Presets
		E.db.datatexts.panels['DP_1']['left'] = ""
		E.db.datatexts.panels['DP_1']['middle'] = ""
		E.db.datatexts.panels['DP_1']['righ'] = ""
		E.db.datatexts.panels['DP_2']['left'] = ""
		E.db.datatexts.panels['DP_2']['middle'] = ""
		E.db.datatexts.panels['DP_2']['right'] = ""
		E.db.datatexts.panels['DP_3']['left'] = ""
		E.db.datatexts.panels['DP_3']['middle'] = ""
		E.db.datatexts.panels['DP_3']['right'] = ""
		E.db.datatexts.panels['DP_4']['left'] = ""
		E.db.datatexts.panels['DP_4']['middle'] = ""
		E.db.datatexts.panels['DP_4']['right'] = ""
		E.db.datatexts.panels['DP_5']['left'] = "Durability"
		E.db.datatexts.panels['DP_5']['middle'] = ""
		E.db.datatexts.panels['DP_5']['right'] = ""
		E.db.datatexts.panels['DP_6']['left'] = ""
		E.db.datatexts.panels['DP_6']['middle'] = ""
		E.db.datatexts.panels['DP_6']['right'] = ""
		E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Bags"
		E.db.datatexts.panels['LeftChatDataPanel']['middle'] = ""
		E.db.datatexts.panels['LeftChatDataPanel']['right'] = ""
		E.db.datatexts.panels['RightChatDataPanel']['left'] = "SocialState"
		E.db.datatexts.panels['RightChatDataPanel']['middle'] = "Gold"
		E.db.datatexts.panels['RightChatDataPanel']['right'] = "Time"
		E.db.datatexts.panels['Top_Center'] = "Version"
		E.db.datatexts.panels['Bottom_Panel'] = "System"
		E.db.datatexts.panels['LeftMiniPanel'] = ""
		E.db.datatexts.panels['RightMiniPanel'] = ""

		--Datatext Panels Spec Specific
		if layout == 'tank' then
			E.db.datatexts.panels.DP_5.middle = ""
			E.db.datatexts.panels.DP_5.right = ""
			E.db.datatexts.panels.DP_6.left = ""
			E.db.datatexts.panels.DP_6.middle = ""
		elseif layout == 'healer' then
			E.db.datatexts.panels.DP_5.middle = "MP5"
			E.db.datatexts.panels.DP_5.right = "Spell/Heal Power"
			E.db.datatexts.panels.DP_6.left = "Haste"
			E.db.datatexts.panels.DP_6.middle = "Crit Chance"
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels.DP_5.middle = ""
			E.db.datatexts.panels.DP_5.right = ""
			E.db.datatexts.panels.DP_6.left = ""
			E.db.datatexts.panels.DP_6.middle = ""
		else
			E.db.datatexts.panels.DP_5.middle = ""
			E.db.datatexts.panels.DP_5.right = ""
			E.db.datatexts.panels.DP_6.left = ""
			E.db.datatexts.panels.DP_6.middle = ""
		end
	end

	--Unitframes
	do
		--Player
		E.db.unitframe.units.player.health.position = "TOPRIGHT"
		E.db.unitframe.units.player.portrait.overlay = true
		E.db.unitframe.units.player.portrait.enable = true
		E.db.unitframe.units.player.portrait.camDistanceScale = 3
		E.db.unitframe.units.player.power.position = "BOTTOMRIGHT"

		--Target
		E.db.unitframe.units.target.aurabar.attachTo = "BUFFS"
		E.db.unitframe.units.target.smartAuraDisplay = "SHOW_DEBUFFS_ON_FRIENDLIES"
		E.db.unitframe.units.target.buffs.playerOnly.friendly = true
		E.db.unitframe.units.target.debuffs.enable = false
		E.db.unitframe.units.target.power.position = "BOTTOMLEFT"
		E.db.unitframe.units.target.power.hideonnpc = false
		E.db.unitframe.units.target.health.position = "LEFT"
		E.db.unitframe.units.target.portrait.overlay = true
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.camDistanceScale = 3

		--Party
		E.db.unitframe.units.party.columnAnchorPoint = "LEFT"
		E.db.unitframe.units.party.healPrediction = true
		E.db.unitframe.units.party.height = 52
		E.db.unitframe.units.party.point = "LEFT"
		E.db.unitframe.units.party.width = 80
		E.db.unitframe.units.party.xOffset = 5
		E.db.unitframe.units.party.debuffs.anchorPoint = "BOTTOMLEFT"
		E.db.unitframe.units.party.debuffs.initialAnchor = "TOPLEFT"
		E.db.unitframe.units.party.debuffs.sizeOverride = 0
		E.db.unitframe.units.party.debuffs.useFilter = "Blacklist"
		E.db.unitframe.units.party.health.frequentUpdates = true
		E.db.unitframe.units.party.health.orientation = "VERTICAL"
		E.db.unitframe.units.party.health.position = "BOTTOM"
		E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
		E.db.unitframe.units.party.targetsGroup.anchorPoint = "TOP"
		E.db.unitframe.units.party.targetsGroup.initialAnchor = "BOTTOM"
		E.db.unitframe.units.party.targetsGroup.width = 80
		E.db.unitframe.units.party.targetsGroup.xOffset = 0
		E.db.unitframe.units.party.targetsGroup.yOffset = 1
		E.db.unitframe.units.party.name.position = "TOP"
		E.db.unitframe.units.party.name.text_format = "[namecolor][name:medium]"
		E.db.unitframe.units.party.petsGroup.anchorPoint = "TOP"
		E.db.unitframe.units.party.petsGroup.enable = true
		E.db.unitframe.units.party.petsGroup.initialAnchor = "BOTTOM"
		E.db.unitframe.units.party.petsGroup.width = 80
		E.db.unitframe.units.party.petsGroup.xOffset = 0
		E.db.unitframe.units.party.petsGroup.yOffset = 1

		--Raid10
		E.db.unitframe.units.raid10.xOffset = 2
		E.db.unitframe.units.raid10.healPrediction = true
		E.db.unitframe.units.raid10.width = 79

		--Raid25
		E.db.unitframe.units.raid25.customTexts = {}
		E.db.unitframe.units.raid25.healPrediction = true
		E.db.unitframe.units.raid25.health.frequentUpdates = true
		E.db.unitframe.units.raid25.health.orientation = "VERTICAL"
		E.db.unitframe.units.raid25.width = 79
		E.db.unitframe.units.raid25.xOffset = 2

		--Raid40
		E.db.unitframe.units.raid40.healPrediction = true
		E.db.unitframe.units.raid40.health.frequentUpdates = true
		E.db.unitframe.units.raid40.health.text = true
		E.db.unitframe.units.raid40.health.orientation = "VERTICAL"
		E.db.unitframe.units.raid40.height = 36
		E.db.unitframe.units.raid40.name.position = "TOP"
		E.db.unitframe.units.raid40.roleIcon.enable = true
		E.db.unitframe.units.raid40.width = 79
		E.db.unitframe.units.raid40.xOffset = 2

		--Arena
		E.db.unitframe.units.arena.castbar.width = 200
		E.db.unitframe.units.arena.width = 200

		--Boss
		E.db.unitframe.units.boss.width = 200
		E.db.unitframe.units.boss.castbar.width = 200

		--Main Tank & Assist
		E.db.unitframe.units.tank.enable = false
		E.db.unitframe.units.assist.enable = false

		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.auraBarBuff = {
			["b"] = 0.59,
			["g"] = 1,
			["r"] = 0,
		}
		E.db.unitframe.colors.castColor = {
			["b"] = 0.59,
			["g"] = 1,
			["r"] = 0,
		}
	end

	--Actionbars
	--Bar 1
	E.db.actionbar.bar1.enabled = true
	E.db.actionbar.bar1.backdrop = false
	E.db.actionbar.bar1.buttonspacing = 2
	--Bar 2
	E.db.actionbar.bar2.enabled = true
	E.db.actionbar.bar2.backdrop = false
	E.db.actionbar.bar2.buttonspacing = 2
	--Bar 3
	E.db.actionbar.bar3.enabled = false
	E.db.actionbar.bar3.backdrop = false
	E.db.actionbar.bar3.buttonspacing = 2
	--Bar 4
	E.db.actionbar.bar4.enabled = true
	E.db.actionbar.bar4.backdrop = false
	E.db.actionbar.bar4.buttonsize = 28
	E.db.actionbar.bar4.buttonspacing = 1
	--Bar 5
	E.db.actionbar.bar5.enabled = false
	E.db.actionbar.bar5.backdrop = false
	E.db.actionbar.bar5.buttonspacing = 2

	--Stance Bar
	E.db.actionbar.stanceBar.buttonspacing = 2

	--UIButtons
	E.db.sle.uibuttons.enable = true
	E.db.sle.uibuttons.position = "uib_hor"	

	--SLE Tooltip
	E.db.sle.castername = true

	--Exp & Rep
	E.db.sle.exprep.explong = true


	do
		if layout == "healer" then			
			E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460187"
			E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460187"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460129"
			E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460129"
			E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-50052"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460166"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT13202"
			E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460166"
			E.db.movers.UIBFrameMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT329175"
			E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM021"
			E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM055"
			E.db.movers.ElvUF_FocusCastbarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-50031"
			E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM3110"
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
			E.db.movers.DP_5_Mover = "BOTTOMElvUIParentBOTTOM-3100"
			E.db.movers.ReputationBarMover = "TOPElvUIParentTOP0-21"
			E.db.movers.AlertFrameMover = "TOPElvUIParentTOP0-43"
			E.db.movers.WatchFrameMover = "TOPLEFTElvUIParentTOPLEFT115-123"
			E.db.movers.LootFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-140-356"
			E.db.movers.RaidUtility_Mover = "TOPLEFTElvUIParentTOPLEFT524-4"
			E.db.movers.BossHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-91-210"
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
			E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP0-32"

		else
			E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460187"
			E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460187"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460129"
			E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460129"
			E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-50052"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT460166"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM091"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT13202"
			E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-460166"
			E.db.movers.UIBFrameMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT329175"
			E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM021"
			E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM055"
			E.db.movers.ElvUF_FocusCastbarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-50031"
			E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM3110"
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
			E.db.movers.DP_5_Mover = "BOTTOMElvUIParentBOTTOM-3100"
			E.db.movers.ReputationBarMover = "TOPElvUIParentTOP0-21"
			E.db.movers.AlertFrameMover = "TOPElvUIParentTOP0-43"
			E.db.movers.WatchFrameMover = "TOPLEFTElvUIParentTOPLEFT115-123"
			E.db.movers.LootFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-140-356"
			E.db.movers.RaidUtility_Mover = "TOPLEFTElvUIParentTOPLEFT524-4"
			E.db.movers.BossHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-91-210"
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
			E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP0-32"
		end
		E.db.movers.BossButton = "BOTTOMElvUIParentBOTTOM559200"
		E.db.movers.ElvAB_4 = "TOPRIGHTElvUIParentTOPRIGHT0-200"
	end

	E:UpdateAll(true)
end

function E:AffinitiiSetup(loadAddons) --The function to switch from class ElvUI settings to Affinitii's
	InstallStepComplete.message = L["Affinitii's Defaults Set"]
	InstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	local xOffset = GetScreenWidth() * 0.34375
	--can try * .135417 for ab 3 and 5 positions or do xoffset - blah blah
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
	E.db.unitframe.font = "Doris PP"
	E.db.unitframe.fontOutline = "OUTLINE"
	E.db.unitframe.statusbar = "Polished Wood"
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
	E.db.unitframe.units.party.positionOverride = "BOTTOMRIGHT"
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
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
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
		["font"] = "Doris PP",
		["justifyH"] = "CENTER",
		["fontOutline"] = "OUTLINE",
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
	E.db.unitframe.units.raid25.positionOverride = "BOTTOMRIGHT"
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
	E.db.unitframe.units.raid40.positionOverride = "BOTTOMRIGHT"
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
	E.db.actionbar.barPet.point = "RIGHT"
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
		E.db.datatexts.panels['LeftChatDataPanel']['middle'] = ""
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
			E.db.datatexts.panels['LeftChatDataPanel']['middle'] = "Durability"
			E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Haste"
		elseif layout == 'dpsCaster' then
			E.db.datatexts.panels['LeftChatDataPanel']['left'] = "Spell/Heal Power"
			E.db.datatexts.panels['LeftChatDataPanel']['middle'] = "Durability"
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

	--if loadAddons then
	--	AI:LoadAddons("Affinitii, All")
	--end
	E:UpdateAll(true)
end
function E:HudSimple()
	local H = E:GetModule('HUD')
	InstallStepComplete.message = L["Simple Layout Set"]
	InstallStepComplete:Show()
	H:SimpleLayout()
	H:UpdateAllFrames()
end

function E:HudDefault()
	local H = E:GetModule('HUD')
	InstallStepComplete.message = L["Default Layout"]
	InstallStepComplete:Show()
	E:CopyTable(E.db.hud,P.hud)
	H:UpdateAllFrames()
end

local function InstallComplete()
	E.private.install_complete = E.version

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
	ElvUIInstallFrame.SubTitle:SetText("")
	ElvUIInstallFrame.Desc1:SetText("")
	ElvUIInstallFrame.Desc2:SetText("")
	ElvUIInstallFrame.Desc3:SetText("")
	ElvUIInstallFrame:Size(550, 400)
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	InstallStatus:SetValue(PageNum)

	local f = ElvUIInstallFrame

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
		f.SubTitle:SetText(format(L["Welcome to ElvUI version %s!"], E.version))
		f.Desc1:SetText(L["This install process will help you learn some of the features in ElvUI has to offer and also prepare your user interface for usage."])
		f.Desc2:SetText(L["The in-game configuration menu can be accesses by typing the /ec command or by clicking the 'C' button on the minimap. Press the button below if you wish to skip the installation process."])
		f.Desc3:SetText(L["Please press the continue button to go onto the next step."])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Skip Process"])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L["CVars"])
		f.Desc1:SetText(L["This part of the installation process sets up your World of Warcraft default options it is recommended you should do this step for everything to behave properly."])
		f.Desc2:SetText(L["Please click the button below to setup your CVars."])
		f.Desc3:SetText(L["Importance: |cff07D400High|r"])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", SetupCVars)
		InstallOption1Button:SetText(L["Setup CVars"])
	elseif PageNum == 3 then
		f.SubTitle:SetText(L["Chat"])
		f.Desc1:SetText(L["This part of the installation process sets up your chat windows names, positions and colors."])
		f.Desc2:SetText(L["The chat windows function the same as Blizzard standard chat windows, you can right click the tabs and drag them around, rename, etc. Please click the button below to setup your chat windows."])
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", SetupChat)
		InstallOption1Button:SetText(L["Setup Chat"])
	elseif PageNum == 4 then
		f.SubTitle:SetText(L["Pixel Perfect"])
		f.Desc1:SetText(L['The Pixel Perfect option will change the overall apperance of your UI. Using Pixel Perfect is a slight performance increase over the traditional layout.'])
		f.Desc2:SetText(L['Using this option will cause your borders around frames to be 1 pixel wide instead of 3 pixel. You may have to finish the installation to notice a differance. By default this is enabled.'])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:SetupPixelPerfect(true) end)
		InstallOption1Button:SetText(L["Enable"])	
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:SetupPixelPerfect(false) end)
		InstallOption2Button:SetText(L['Disable'])
	elseif PageNum == 5 then
		f.SubTitle:SetText(L['Theme Setup'])
		f.Desc1:SetText(L['Choose a theme layout you wish to use for your initial setup.'])
		f.Desc2:SetText(L['You can always change fonts and colors of any element of elvui from the in-game configuration.'])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:SetupTheme('classic') end)
		InstallOption1Button:SetText(L["Classic"])	
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:SetupTheme('default') end)
		InstallOption2Button:SetText(L['Dark'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() E:SetupTheme('class') end)
		InstallOption3Button:SetText(CLASS)	
	elseif PageNum == 6 then
		f.SubTitle:SetText(L["Resolution"])
		f.Desc1:SetText(format(L["Your current resolution is %s, this is considered a %s resolution."], E.resolution, E.lowversion == true and L["low"] or L["high"]))
		if E.lowversion then
			f.Desc2:SetText(L["This resolution requires that you change some settings to get everything to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["You may need to further alter these settings depending how low you resolution is."])
			f.Desc3:SetText(L["Importance: |cff07D400High|r"])
		else
			f.Desc2:SetText(L["This resolution doesn't require that you change settings for the UI to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["This is completely optional."])
			f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
		end

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E.SetupResolution('high') end)
		InstallOption1Button:SetText(L["High Resolution"])	
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E.SetupResolution('low') end)
		InstallOption2Button:SetText(L['Low Resolution'])
	elseif PageNum == 7 then
		f.SubTitle:SetText(L["Layout"])
		f.Desc1:SetText(L["You can now choose what layout you wish to use based on your combat role."])
		f.Desc2:SetText(L["This will change the layout of your unitframes, raidframes, and datatexts."])
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E.db.layoutSet = nil; E:SetupLayout('tank') end)
		InstallOption1Button:SetText(L['Tank'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E.db.layoutSet = nil; E:SetupLayout('healer') end)
		InstallOption2Button:SetText(L['Healer'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() E.db.layoutSet = nil; E:SetupLayout('dpsMelee') end)
		InstallOption3Button:SetText(L['Physical DPS'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() E.db.layoutSet = nil; E:SetupLayout('dpsCaster') end)
		InstallOption4Button:SetText(L['Caster DPS'])
	elseif PageNum == 8 then
		f.SubTitle:SetText(L["Auras System"])
		f.Desc1:SetText(L["Select the type of aura system you want to use with ElvUI's unitframes. The integrated system utilizes both aura-bars and aura-icons. The icons only system will display only icons and aurabars won't be used. The classic system will configure your auras to how they were pre-v4."])
		f.Desc2:SetText(L["If you have an icon or aurabar that you don't want to display simply hold down shift and right click the icon for it to disapear."])
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupAuras('classic') end)
		InstallOption1Button:SetText(L['Classic'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() SetupAuras() end)
		InstallOption2Button:SetText(L['Icons Only'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() SetupAuras('integrated') end)
		InstallOption3Button:SetText(L['Integrated'])	
	elseif PageNum == 9 then --The new page
		f.SubTitle:SetText(L["Shadow & Light Settings"])
		f.Desc1:SetText(L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."])
		f.Desc2:SetText(L["SLE_Install_Text2"])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:DarthSetup() end)
		InstallOption1Button:SetText(L["Darth's Config"])	

		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:AffinitiiSetup() end)
		InstallOption2Button:SetText(L["Affinitii's Config"])

		InstallOption3Button:Show()
		local pixel = E.PixelMode
		if pixel then
			InstallOption3Button:SetScript('OnClick', function() E:RepoocSetup() end)
		else
			InstallOption3Button:SetScript('OnClick', function() E:StaticPopup_Show("ELVUI_SLE_REPOOC") end)
		end
		InstallOption3Button:SetText(L["Repooc's Config"])
	elseif PageNum == 10 and IsAddOnLoaded("ElvUI_Hud") then --Hud's page if enabled
		f.SubTitle:SetText("ElvUI Hud")
		f.Desc1:SetText(L["Thank you for using ElvUI Hud!"])
		f.Desc2:SetText(L["Here you can choose between the simple layout (only player health and power) or the default layout for the hud"])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])

		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:HudSimple() end)
		InstallOption1Button:SetText(L["Simple Layout"])	
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:HudDefault() end)
		InstallOption2Button:SetText(L["Default Layout"])
	elseif PageNum == 10 and not IsAddOnLoaded("ElvUI_Hud") then --Finish install if Hud disabled
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Finished"])				
		ElvUIInstallFrame:Size(550, 350)
	elseif PageNum == 11 then --Finish install if Hud enabled
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Finished"])				
		ElvUIInstallFrame:Size(550, 350)
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
function E:Install()
	--ElvUI don't have this?
	MaxPages()
	if not InstallStepComplete then
		local imsg = CreateFrame("Frame", "InstallStepComplete", E.UIParent)
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
	if not ElvUIInstallFrame then
		local f = CreateFrame("Button", "ElvUIInstallFrame", E.UIParent)
		f.SetPage = SetPage
		f:Size(550, 400)
		f:SetTemplate("Transparent")
		f:SetPoint("CENTER")
		f:SetFrameStrata('TOOLTIP')

		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point("TOP", 0, -5)
		f.Title:SetText(L["ElvUI Installation"])

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
		f.tutorialImage:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\logo_elvui_sle.tga')
		f.tutorialImage:Point('BOTTOM', 0, 70)

	end

	ElvUIInstallFrame:Show()
	NextPage()
end