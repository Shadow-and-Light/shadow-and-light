local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

local CURRENT_PAGE = 0
local MAX_PAGE

local function MaxPages()
	if IsAddOnLoaded("ElvUI_Hud") then	
		MAX_PAGE = 10
	else
		MAX_PAGE = 9
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

function E:SetupTheme(theme, noDisplayMsg, noPopup)
	local classColor = RAID_CLASS_COLORS[E.myclass]
	E.db.theme = theme

	if not noPopup and ((not E.PixelMode and theme == 'pixelPerfect') or (E.PixelMode and theme ~= 'pixelPerfect')) then
		E:StaticPopup_Show('PIXELPERFECT_CHANGED')
	end

	E.private.general.pixelPerfect = false;
	
	if not noDisplayMsg then
		E:CopyTable(E.db.unitframe.units, P.unitframe.units)
		E:CopyTable(E.db.actionbar, P.actionbar)
		E:CopyTable(E.db.nameplate, P.nameplate)
		E:CopyTable(E.db.bags, P.bags)
		E:CopyTable(E.private.auras, V.auras)
		
		if E.db.movers then
			E.db.movers.AurasMover = nil;
		end
	end
	
	--Set colors
	if theme == 'pixelPerfect' then
		E.global.newThemePrompt = true;
		E.private.general.pixelPerfect = true;
		E.db.general.bordercolor = E:GetColor(0, 0, 0)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)
		
		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.health = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.castColor = E:GetColor(.31, .31, .31)	

		E.db.general.bottomPanel = true;
		E.db.actionbar.bar1.buttonspacing = 2;
		E.db.actionbar.bar2.buttonspacing = 2;
		E.db.actionbar.bar3.buttonspacing = 2;
		E.db.actionbar.bar4.buttonspacing = 2;
		E.db.actionbar.bar5.buttonspacing = 2;
		E.db.actionbar.stanceBar.buttonspacing = 2;
		E.db.actionbar.barPet.buttonspacing = 2;
		
		E.db.actionbar.bar1.backdrop = false;
		E.db.actionbar.bar2.backdrop = false;
		E.db.actionbar.bar5.backdrop = false;
		E.db.actionbar.bar3.backdrop = false;
		
		E.db.actionbar.bar1.buttonsize = 32;
		E.db.actionbar.bar2.buttonsize = 32;
		E.db.actionbar.bar3.buttonsize = 32;
		E.db.actionbar.bar4.buttonsize = 32;
		E.db.actionbar.bar5.buttonsize = 32;
		E.db.actionbar.stanceBar.buttonsize = 32;
		E.db.actionbar.barPet.buttonsize = 32;
		
		E.db.unitframe.units.player.classbar.fill = 'fill';
		E.db.unitframe.units.target.combobar.fill = 'fill';
		
		E.db.nameplate.fontSize = 7;
		E.db.nameplate.fontOutline = 'MONOCHROMEOUTLINE';
		E.db.nameplate.font = 'ElvUI Pixel';
		E.db.nameplate.height = 7;
		E.db.nameplate.width = 112;
		
		E.db.bags.bagSize = 34;
		E.db.bags.bankSize = 34;
		E.private.auras.size = 30;
		
		if not noDisplayMsg or noPopup then
			if not E.db.movers then E.db.movers = {}; end
			E.db.movers["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0104"
			E.db.movers["AurasMover"] = "TOPRIGHTElvUIParentTOPRIGHT-221-5"
			E.db.movers["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM064"
			E.db.movers["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-27865"
			E.db.movers["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM27864"		
		end
	elseif theme == "classic" then
		E.db.general.bottomPanel = false;
		E.db.general.bordercolor = E:GetColor(.31, .31, .31)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)
		
		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.health = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.31, .31, .31)
		E.db.unitframe.colors.castColor = E:GetColor(.31, .31, .31)
		
	elseif theme == "class" then
		E.db.general.bottomPanel = false;
		E.db.general.bordercolor = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)
		E.db.unitframe.colors.auraBarBuff = E:GetColor(classColor.r, classColor.b, classColor.g)
		E.db.unitframe.colors.healthclass = true
		E.db.unitframe.colors.castColor = E:GetColor(classColor.r, classColor.b, classColor.g)
	else
		E.db.general.bottomPanel = false;
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
		
		if E.private.general.pixelPerfect then
			if not E.db.movers then E.db.movers = {}; end
			
			E.db.movers["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0104"
			E.db.movers["AurasMover"] = "TOPRIGHTElvUIParentTOPRIGHT-221-5"
			E.db.movers["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM064"
			E.db.movers["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-27865"
			E.db.movers["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM27864"
		end

		E.db.auras.wrapAfter = P.auras.wrapAfter;	
		E.db.general.reputation.width = P.general.reputation.width
		E.db.general.experience.width = P.general.experience.width
		
		E.db.lowresolutionset = nil;
	end
	
	if not noDataReset and E.db.theme then
		E:SetupTheme(E.db.theme, true)
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
	end
	if layout == 'healer' then
		if not IsAddOnLoaded('Clique') then
			E:Print(L['Using the healer layout it is highly recommended you download the addon Clique to work side by side with ElvUI.'])
		end
		
		if not noDataReset then
			E.db.unitframe.units.party.health.frequentUpdates = true;
			E.db.unitframe.units.raid25.health.frequentUpdates = true;
			E.db.unitframe.units.raid40.health.frequentUpdates = true;
			
			E.db.unitframe.units.raid40.height = 36;
			E.db.unitframe.units.raid40.health.text = true;
			E.db.unitframe.units.raid40.name.position = 'TOP';
			E.db.unitframe.units.raid40.roleIcon.enable = true;
			E.db.unitframe.units.boss.width = 200;
			E.db.unitframe.units.boss.castbar.width = 200;
			E.db.unitframe.units.arena.width = 200;
			E.db.unitframe.units.arena.castbar.width = 200;
			
			E.db.unitframe.units.party.point = 'LEFT';
			E.db.unitframe.units.party.xOffset = 5;
			E.db.unitframe.units.party.healPrediction = true;
			E.db.unitframe.units.party.columnAnchorPoint = 'LEFT';
			E.db.unitframe.units.party.width = 80;
			E.db.unitframe.units.party.height = 52;
			E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
			E.db.unitframe.units.party.health.position = 'BOTTOM';
			E.db.unitframe.units.party.health.orientation = 'VERTICAL';
			E.db.unitframe.units.party.name.position = 'TOP';
			E.db.unitframe.units.party.name.text_format = "[namecolor][name:medium]";
			E.db.unitframe.units.party.debuffs.anchorPoint = 'BOTTOMLEFT';
			E.db.unitframe.units.party.debuffs.initialAnchor = 'TOPLEFT';
			E.db.unitframe.units.party.debuffs.useFilter = 'Blacklist';
			E.db.unitframe.units.party.debuffs.sizeOverride = 0;
			E.db.unitframe.units.party.petsGroup.enable = true;
			E.db.unitframe.units.party.petsGroup.width = 80;
			E.db.unitframe.units.party.petsGroup.initialAnchor = 'BOTTOM';
			E.db.unitframe.units.party.petsGroup.anchorPoint = 'TOP';
			E.db.unitframe.units.party.petsGroup.xOffset = 0;
			E.db.unitframe.units.party.petsGroup.yOffset = 1;
			E.db.unitframe.units.party.targetsGroup.enable = false;
			E.db.unitframe.units.party.targetsGroup.width = 80;
			E.db.unitframe.units.party.targetsGroup.initialAnchor = 'BOTTOM';
			E.db.unitframe.units.party.targetsGroup.anchorPoint = 'TOP';
			E.db.unitframe.units.party.targetsGroup.xOffset = 0;
			E.db.unitframe.units.party.targetsGroup.yOffset = 1;

			E.db.unitframe.units.raid25.healPrediction = true;
			E.db.unitframe.units.raid25.health.orientation = 'VERTICAL';

			E.db.unitframe.units.raid40.healPrediction = true;
			E.db.unitframe.units.raid40.health.orientation = 'VERTICAL';		
		end
			
		if not E.db.movers then E.db.movers = {}; end
		if E.db.lowresolutionset then
			E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-305242"
			E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM305242"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMElvUIParentBOTTOM080"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM080"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM080"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM305187"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM0104"
			E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-305187"
			E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310432"
			
		else
			E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT464242"
			E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-464242"
			E.db.movers.ElvUF_Raid40Mover = "BOTTOMElvUIParentBOTTOM050"
			E.db.movers.ElvUF_Raid25Mover = "BOTTOMElvUIParentBOTTOM050"
			E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM050"
			E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-464151"
			E.db.movers.ElvUF_PartyMover = "BOTTOMElvUIParentBOTTOM074"
			E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT464151"
			E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM280332"			
		end
	elseif E.db.lowresolutionset then
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-106135"
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM106135"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM10680"
		E.db.movers.ElvUF_PetMover = "BOTTOMElvUIParentBOTTOM-10680"
		E.db.movers.ElvUF_FocusMover = "BOTTOMElvUIParentBOTTOM310332"			
	else
		if not noDataReset then
			E:ResetMovers('')
			if E.private.general.pixelPerfect then
				if not E.db.movers then E.db.movers = {}; end
				E.db.movers["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0104"
				E.db.movers["AurasMover"] = "TOPRIGHTElvUIParentTOPRIGHT-221-5"
				E.db.movers["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM064"
				E.db.movers["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-27865"
				E.db.movers["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM27864"		
			end			
		end
	end
	
	if E.db.lowresolutionset and not noDataReset then
		E.db.unitframe.units.player.width = 200;
		E.db.unitframe.units.player.castbar.width = 200;
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
	
	if not E.db.lowresolutionset and (layout == 'dpsCaster' or (layout == 'dpsMelee' and E.myclass == 'HUNTER')) then
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM0180"
	--[[elseif not E.db.lowresolutionset and layout == 'tank' then --Not sure if i want to keep this.
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMElvUIParentBOTTOM0180"]]
	end
	
	--Datatexts
	if not noDataReset then
		E:CopyTable(E.db.datatexts.panels, P.datatexts.panels)
		if layout == 'tank' then
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Armor';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Avoidance';
		elseif layout == 'healer' or layout == 'dpsCaster' then
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Spell/Heal Power';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Haste';
		else
			E.db.datatexts.panels.LeftChatDataPanel.left = 'Attack Power';
			E.db.datatexts.panels.LeftChatDataPanel.right = 'Crit Chance';
		end

		if InstallStepComplete then
			InstallStepComplete.message = L["Layout Set"]
			InstallStepComplete:Show()	
		end		
	end
	
	E.db.layoutSet = layout
	
	if not noDataReset and E.db.theme then
		E:SetupTheme(E.db.theme, true)
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
	elseif style == 'classic' then
		--seriosly is this fucking hard??
		E.db.unitframe.units.target.smartAuraDisplay = 'DISABLED';
		E.db.unitframe.units.target.buffs.playerOnly = {friendly = false, enemy = false};
		E.db.unitframe.units.target.debuffs.enable = true;
		E.db.unitframe.units.target.aurabar.attachTo = 'DEBUFFS';
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
	if not E.db.movers then E.db.movers = {}; end

	layout = E.db.layoutSet --To know if some sort of layout was choosed before

	--General options--
	E.db.general.stickyFrames = false
	E.db.general.autoRepair = "PLAYER"
	E.db.general.vendorGrays = true
	E.db.general.fontsize = 10
	E.db.general.minimap.locationText = 'SHOW'
	E.db.general.experience.textFormat = 'CURPERC'
	E.db.general.experience.textSize = 10
	E.db.general.reputation.textFormat = 'CURMAX'
	E.db.general.reputation.textSize = 10	
	E.db.general.threat.enable = false
	E.db.general.totems.spacing = 2
	E.db.general.totems.growthDirection = "HORIZONTAL"
	E.db.general.totems.size = 24

	--Bags--
	E.db.bags.bagSize = 25
	E.db.bags.bankSize = 25
	E.db.bags.sortInverted = false
	E.db.bags.alignToChat = false
	E.db.bags.bagWidth = 633
	E.db.bags.bankWidth = 633
	E.db.bags.yOffset = 225
	E.db.bags.currencyFormat = "ICON"
	E.db.bags.growthDirection = "HORIZONTAL"

	--NamePlate--
	E.db.nameplate.healthtext = 'CURRENT_PERCENT'
	E.db.nameplate.lowHealthWarning = 'NONE'
	E.db.nameplate.lowHealthWarningThreshold = .20

	--Auras--
	E.db.auras.font = "ElvUI Font"
	E.db.auras.fontOutline = "OUTLINE"
	E.db.auras.wrapAfter = 18

	--Chat--
	E.db.chat.editboxhistory = 10
	E.db.chat.emotionIcons = false
	E.db.chat.whisperSound = 'None'
	E.db.chat.panelHeight = 227
	if E.db.lowresolutionset then
		E.db.chat.panelWidth = 400
	else
		E.db.chat.panelWidth = 444
	end

	--Datatexts--
	E.db.datatexts.font = "ElvUI Pixel"
	E.db.datatexts.fontSize = 11
	E.db.datatexts.time24 = true
	E.db.sle.datatext.top.enabled = true
	E.db.sle.datatext.bottom.enabled = true
	if E.db.lowresolutionset then
		E.db.sle.datatext.dp1.enabled = false
		E.db.sle.datatext.dp2.enabled = false
		E.db.sle.datatext.dp3.enabled = false
		E.db.sle.datatext.dp4.enabled = false
		E.db.sle.datatext.dp5.enabled = false
		E.db.sle.datatext.dp6.enabled = false
		E.db.sle.datatext.chatleft.width = 384
		E.db.sle.datatext.chatright.width = 384
		E.db.sle.datatext.bottom.width = E.screenwidth/3 + 52
	else
		E.db.sle.datatext.dp1.enabled = true
		E.db.sle.datatext.dp2.enabled = true
		E.db.sle.datatext.dp3.enabled = true
		E.db.sle.datatext.dp4.enabled = true
		E.db.sle.datatext.dp5.enabled = true
		E.db.sle.datatext.dp6.enabled = true
		E.db.sle.datatext.chatleft.width = 428
		E.db.sle.datatext.chatright.width = 428
		E.db.sle.datatext.bottom.width = E.screenwidth/10 - 4
	end

	if E.db.lowresolutionset then
		E.db.datatexts.panels.LeftChatDataPanel.left = 'Bags';
		E.db.datatexts.panels.LeftChatDataPanel.middle = 'Gold';
		E.db.datatexts.panels.LeftChatDataPanel.right = 'Durability';
	else
		E.db.datatexts.panels.LeftChatDataPanel.right = 'Friends';
		E.db.datatexts.panels.LeftChatDataPanel.left = 'Call to Arms';
		E.db.datatexts.panels.LeftChatDataPanel.middle = 'Durability';
	end
	E.db.datatexts.panels.LeftMiniPanel = 'Time';
	E.db.datatexts.panels.RightMiniPanel = 'Guild';

	if layout == 'tank' then
		E.db.datatexts.panels.DP_6.left = 'Avoidance';
		E.db.datatexts.panels.DP_6.middle = 'Vengeance';
		E.db.datatexts.panels.DP_6.right = 'Expertise';
		if E.db.lowresolutionset then
			E.db.datatexts.panels.RightChatDataPanel.left = 'Avoidance';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Vengeance';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Expertise';
		else
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
		end
		E.db.datatexts.panels.DP_5.right = 'Armor';
	elseif layout == 'healer' then
		E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
		E.db.datatexts.panels.DP_6.middle = 'Haste';
		E.db.datatexts.panels.DP_6.right = 'Crit Chance';
		if E.db.lowresolutionset then
			E.db.datatexts.panels.RightChatDataPanel.left = 'Spell/Heal Power';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Crit Chance';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Mana Regen';
		else
			E.db.datatexts.panels.RightChatDataPanel.left = 'Mana Regen';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
		end
		E.db.datatexts.panels.DP_5.right = 'Armor';
	elseif layout == 'dpsCaster' then
		E.db.datatexts.panels.DP_6.left = 'Spell/Heal Power';
		E.db.datatexts.panels.DP_6.middle = 'Haste';
		E.db.datatexts.panels.DP_6.right = 'Crit Chance';
		if E.db.lowresolutionset then
			E.db.datatexts.panels.RightChatDataPanel.left = 'Spell/Heal Power';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Haste';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Crit Chance';
		else
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
		end
		E.db.datatexts.panels.DP_5.right = 'Armor';
	else
		E.db.datatexts.panels.DP_6.left = 'Attack Power';
		E.db.datatexts.panels.DP_6.middle = 'Haste';
		E.db.datatexts.panels.DP_6.right = 'Crit Chance';
		if E.db.lowresolutionset then
			E.db.datatexts.panels.RightChatDataPanel.left = 'Attack Power';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Haste';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Crit Chance';
		else
			E.db.datatexts.panels.RightChatDataPanel.left = 'Hit Rating';
			E.db.datatexts.panels.RightChatDataPanel.middle = 'Mastery';
			E.db.datatexts.panels.RightChatDataPanel.right = 'Spec Switch';
		end
		E.db.datatexts.panels.DP_5.right = 'Expertise';
	end

	--Unitframes--
	E.db.unitframe.smoothbars = false
	E.db.unitframe.font = "ElvUI Font"
	E.db.unitframe.fontsize = 9
	E.db.unitframe.fontOutline = 'OUTLINE'
	E.db.unitframe.colors.castColor = {
								["b"] = 0.3098039215686275,
								["g"] = 0.792156862745098,
								["r"] = 0.8274509803921568,
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
		E.db.unitframe.units.player.width = 200
		if layout == "healer" then
			E.db.unitframe.units.player.lowmana = 30;
		else
			E.db.unitframe.units.player.lowmana = 0;
		end
		E.db.unitframe.units.player.health.position = 'BOTTOMRIGHT';
		E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current-percent:sl]"
		E.db.unitframe.units.player.power.text_format = "[powercolor][power:current:sl]";
		E.db.unitframe.units.player.name.text_format = "[name:medium]";
		E.db.unitframe.units.player.name.position = 'TOPLEFT';
		E.db.unitframe.units.player.pvp.text_format = "||cFFB04F4F[pvptimer]||r"
		E.db.unitframe.units.player.pvp.position = "BOTTOMLEFT"
		E.db.unitframe.units.player.portrait.enable = true
		E.db.unitframe.units.player.portrait.camDistanceScale = 1.5;
		E.db.unitframe.units.player.debuffs.enable = false;
		E.db.unitframe.units.player.castbar.format = 'CURRENTMAX';
		E.db.unitframe.units.player.castbar.width = 237
		E.db.unitframe.units.player.classbar.fill = 'fill'
		E.db.unitframe.units.player.classbar.height = 8
		E.db.unitframe.units.player.aurabar.enable = false
		--Setting target frame
		E.db.unitframe.units.target.width = 200
		E.db.unitframe.units.target.smartAuraDisplay = "DISABLED"
		E.db.unitframe.units.target.hideonnpc = false;
		E.db.unitframe.units.target.health.position = 'BOTTOMRIGHT';
		E.db.unitframe.units.target.power.position = 'RIGHT';
		E.db.unitframe.units.target.power.hideonnpc = false;
		E.db.unitframe.units.target.power.text_format = "[powercolor][power:current:sl]"
		E.db.unitframe.units.target.name.text_format = "[name:medium] [smartlevel] [shortclassification]";
		E.db.unitframe.units.target.name.position = 'TOPLEFT';
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.camDistanceScale = 1.5;
		E.db.unitframe.units.target.buffs.perrow = 9;
		E.db.unitframe.units.target.buffs.numrows = 2;
		E.db.unitframe.units.target.buffs.playerOnly = "NONE";
		E.db.unitframe.units.target.buffs.noDuration = "NONE";
		E.db.unitframe.units.target.buffs.anchorPoint = 'TOPLEFT';
		E.db.unitframe.units.target.buffs.clickThrough = false
		E.db.unitframe.units.target.buffs.noConsolidated = "NONE"
		E.db.unitframe.units.target.debuffs.perrow = 9;
		E.db.unitframe.units.target.debuffs.useBlacklis = "NONE";
		E.db.unitframe.units.target.debuffs.playerOnly = "NONE";
		E.db.unitframe.units.target.debuffs.enable = true
		E.db.unitframe.units.target.debuffs.clickThrough = false
		E.db.unitframe.units.target.castbar.format = 'CURRENTMAX';
		if layout == "healer" then
			E.db.unitframe.units.target.castbar.width = 237
		else
			E.db.unitframe.units.target.castbar.width = 200
		end
		E.db.unitframe.units.target.aurabar.enable = false
		--Target of Target
		E.db.unitframe.units.targettarget.height = 26
		if layout == "healer" then
			E.db.unitframe.units.targettarget.width = 115
		else
			E.db.unitframe.units.targettarget.width = 120
		end
		E.db.unitframe.units.targettarget.name.text_format = "[name:medium]"
		E.db.unitframe.units.targettarget.debuffs.enable = false
		--Focus
		E.db.unitframe.units.focus.height = 42
		E.db.unitframe.units.focus.width = 179
		E.db.unitframe.units.focus.health.position = 'BOTTOMRIGHT'
		E.db.unitframe.units.focus.health.text_format = "[healthcolor][health:current-percent:sl]"
		E.db.unitframe.units.focus.power.text_format = "[powercolor][power:current:sl]"
		E.db.unitframe.units.focus.power.position = "RIGHT"
		E.db.unitframe.units.focus.name.text_format = "[name:medium]"
		E.db.unitframe.units.focus.name.position = 'TOPLEFT'
		E.db.unitframe.units.focus.debuffs.perrow = 8
		E.db.unitframe.units.focus.debuffs.anchorPoint = "TOPLEFT"
		E.db.unitframe.units.focus.castbar.format = 'CURRENTMAX'
		E.db.unitframe.units.focus.castbar.width = 179
		--Focus Target
		E.db.unitframe.units.focustarget.name.text_format = "[name:medium]"
		E.db.unitframe.units.focustarget.enable = true
		E.db.unitframe.units.focustarget.height = 34
		E.db.unitframe.units.focustarget.width = 179
		--Pet
		E.db.unitframe.units.pet.name.text_format = "[name:medium]"
		if layout == "healer" then
			E.db.unitframe.units.pet.width = 115
		else
			E.db.unitframe.units.pet.width = 128
		end
		--Pet Target
		E.db.unitframe.units.pettarget.name.text_format = "[name:medium]"
		E.db.unitframe.units.pettarget.enable = true
		if layout == "healer" then
			E.db.unitframe.units.pettarget.width = 115
		else
			E.db.unitframe.units.pettarget.width = 119
		end
		--Party
		if layout == "healer" then
			E.db.unitframe.units.party.point = "LEFT"
			E.db.unitframe.units.party.xOffset = 5
			E.db.unitframe.units.party.debuffs.perrow = 3
			E.db.unitframe.units.party.debuffs.anchorPoint = "BOTTOMLEFT"
			E.db.unitframe.units.party.debuffs.useFilter = "Blacklist"
			E.db.unitframe.units.party.debuffs.initialAnchor = "TOPLEFT"
			E.db.unitframe.units.party.roleIcon.position = "RIGHT"
			E.db.unitframe.units.party.width = 80
			E.db.unitframe.units.party.height = 52
			E.db.unitframe.units.party.healPrediction = true
			E.db.unitframe.units.party.health.text_format = "[healthcolor][health:deficit]"
			E.db.unitframe.units.party.health.position = "CENTER"
			E.db.unitframe.units.party.health.frequentUpdates = true
			E.db.unitframe.units.party.health.orientation = "VERTICAL"
		else
			E.db.unitframe.units.party.debuffs.perrow = 4
			E.db.unitframe.units.party.roleIcon.position = "TOPRIGHT"
			E.db.unitframe.units.party.health.position = "BOTTOMLEFT"
		end
		E.db.unitframe.units.party.debuffs.sizeOverride = 26
		E.db.unitframe.units.party.buffIndicator.colorIcons = false
		E.db.unitframe.units.party.power.height = 8
		E.db.unitframe.units.party.power.text_format = ""
		E.db.unitframe.units.party.name.position = "TOP"
		E.db.unitframe.units.party.name.text_format = "[name:medium] [difficultycolor][smartlevel]"
		--Raid 10
		if layout == "healer" then
			E.db.unitframe.units.raid10.health.frequentUpdates = true
			E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:dificit]"
			E.db.unitframe.units.raid10.health.orientation = "VERTICAL"
			E.db.unitframe.units.raid10.health.position = "CENTER"
		else
			E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:current]"
			E.db.unitframe.units.raid10.columnAnchorPoint = "LEFT"
			E.db.unitframe.units.raid10.point = "TOP"
		end
		E.db.unitframe.units.raid10.name.text_format = "[name:medium]"
		E.db.unitframe.units.raid10.buffIndicator.colorIcons = false
		E.db.unitframe.units.raid10.rdebuffs.size = 22
		E.db.unitframe.units.raid10.power.height = 8
		E.db.unitframe.units.raid10.power.text_format = ""
		E.db.unitframe.units.raid10.health.position = "BOTTOMLEFT"
		E.db.unitframe.units.raid10.health.text_format = "[healthcolor][health:current]"
		--Raid 25
		if layout == "healer" then
			E.db.unitframe.units.raid25.health.text_format = "[healthcolor][health:deficit]"
			E.db.unitframe.units.raid25.health.frequentUpdates = true
			E.db.unitframe.units.raid25.health.orientation = "VERTICAL"
			E.db.unitframe.units.raid25.health.position = "CENTER"
		else
			E.db.unitframe.units.raid25.point = "TOP"
			E.db.unitframe.units.raid25.columnAnchorPoint = "LEFT"
			E.db.unitframe.units.raid25.health.text_format = ""
		end
		E.db.unitframe.units.raid25.buffIndicator.colorIcons = false
		E.db.unitframe.units.raid25.name.text_format = "[name:medium]"
		E.db.unitframe.units.raid25.rdebuffs.size = 22
		E.db.unitframe.units.raid25.power.height = 8
		E.db.unitframe.units.raid25.power.text_format = ""
		--Raid 40
		if layout == "healer" then
			E.db.unitframe.units.raid40.health.frequentUpdates = true
			E.db.unitframe.units.raid40.health.text_format = ""
			E.db.unitframe.units.raid40.health.orientation = "VERTICAL"
		else
			E.db.unitframe.units.raid40.health.text_format = ""
		end
		E.db.unitframe.units.raid40.name.text_format = "[name:short]"
		E.db.unitframe.units.raid40.buffIndicator.colorIcons = false

		--Tank
		if layout == "healer" then
			E.db.unitframe.units.tank.enable = true
			E.db.unitframe.units.tank.targetsGroup.enable = false
		else
			E.db.unitframe.units.tank.enable = false
		end
		--Assist
		E.db.unitframe.units.assist.enable = false

		--Arena
		E.db.unitframe.units.arena.width = 200
		E.db.unitframe.units.arena.height = 40
		E.db.unitframe.units.arena.growthDirection = 'DOWN'
		E.db.unitframe.units.arena.health.position = 'BOTTOMRIGHT'
		E.db.unitframe.units.arena.health.text_format = "[healthcolor][health:current-percent:sl]"
		E.db.unitframe.units.arena.power.text_format = "[powercolor][power:current:sl]"
		E.db.unitframe.units.arena.name.text_format = "[name:long]"
		E.db.unitframe.units.arena.name.position = 'TOPLEFT'
		E.db.unitframe.units.arena.buffs.enable = false
		E.db.unitframe.units.arena.debuffs.enable = false
		E.db.unitframe.units.arena.castbar.format = 'CURRENTMAX'
		E.db.unitframe.units.arena.castbar.height = 15
		E.db.unitframe.units.arena.castbar.width = 200
		E.db.unitframe.units.arena.castbar.color = {
								["r"] = 0.8274509803921568,
								["g"] = 0.792156862745098,
								["b"] = 0.3098039215686275,
							}
		--Boss
		E.db.unitframe.units.boss.width = 200
		E.db.unitframe.units.boss.height = 40
		E.db.unitframe.units.boss.growthDirection = 'DOWN'
		E.db.unitframe.units.boss.health.position = 'BOTTOMRIGHT'
		E.db.unitframe.units.boss.health.text_format = "[healthcolor][health:current-percent]"
		E.db.unitframe.units.boss.power.height = 10
		E.db.unitframe.units.boss.power.text_format = "[powercolor][power:current:sl]"
		E.db.unitframe.units.boss.name.text_format = "[name:long]"
		E.db.unitframe.units.boss.name.position = 'TOPLEFT'
		E.db.unitframe.units.boss.buffs.enable = false
		E.db.unitframe.units.boss.debuffs.enable = false
		E.db.unitframe.units.boss.castbar.format = 'CURRENTMAX'
		E.db.unitframe.units.boss.castbar.height = 15
		E.db.unitframe.units.boss.castbar.width = 200
		E.db.unitframe.units.boss.castbar.color = {
								["r"] = 0.8274509803921568,
								["g"] = 0.792156862745098,
								["b"] = 0.3098039215686275,
							}
		--Power text
		E.db.sle.powtext = true

	--Actionbars
	E.db.actionbar.hotkeytext = false
	E.db.actionbar.keyDown = false
	E.db.actionbar.bar1.point = "TOPLEFT"
	E.db.actionbar.bar1.buttonsPerRow = 3
	E.db.actionbar.bar1.buttonsize = 26
	E.db.actionbar.bar2.enabled = true
	E.db.actionbar.bar2.point = "TOPLEFT"
	E.db.actionbar.bar2.backdrop = true
	E.db.actionbar.bar2.buttonsPerRow = 3
	E.db.actionbar.bar2.buttonsize = 26
	E.db.actionbar.bar2.visibility = "[petbattle] hide; show"
	E.db.actionbar.bar3.point = "TOPLEFT"
	E.db.actionbar.bar3.buttons = 12
	E.db.actionbar.bar3.buttonsPerRow = 3
	E.db.actionbar.bar3.visibility = "[petbattle] hide; show"
	E.db.actionbar.bar3.buttonsize = 26
	E.db.actionbar.bar4.enabled = false
	E.db.actionbar.bar5.enabled = false
	E.db.actionbar.microbar.enabled = true
	E.db.actionbar.microbar.buttonsPerRow = 2
	E.db.actionbar.microbar.alpha = 0.2
	E.db.actionbar.stanceBar.buttonspacing = 2
	E.db.actionbar.stanceBar.backdrop = true
	E.db.actionbar.stanceBar.buttonsPerRow = 1
	E.db.actionbar.stanceBar.buttonsize = 22
	E.db.actionbar.barPet.point = "TOPLEFT"
	E.db.actionbar.barPet.buttonspacing = 1
	E.db.actionbar.barPet.backdrop = false
	E.db.actionbar.barPet.buttonsPerRow = 5
	E.db.actionbar.barPet.buttonsize = 20

	--Raid marks--
	E.db.sle.marks.growth = "LEFT"

	--Background Frames--
	E.db.sle.backgrounds.right.enabled = true
	E.db.sle.backgrounds.right.pethide = false
	E.db.sle.backgrounds.right.xoffset = 70
	E.db.sle.backgrounds.left.enabled = true
	E.db.sle.backgrounds.left.pethide = false
	E.db.sle.backgrounds.left.xoffset = -70

	--Raid utility--
	E.db.sle.raidutil.ypos = 1050

	--Exp/Rep Bars--
	E.db.sle.exprep.explong = true
	E.db.sle.exprep.replong = true

	--Combat icon--
	E.db.sle.combatico.pos = 'TOPRIGHT'

	--UI buttons--
	E.db.sle.uibuttons.enable = true
	E.db.sle.uibuttons.size = 14
	E.db.sle.uibuttons.position = "uib_hor"

	--Moving stuff--
	if layout == "healer" then
		E.db.movers.PetAB = "BOTTOMLEFTUIParentBOTTOMLEFT633141"
		E.db.movers.ElvUF_Raid10Mover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-754215"
		E.db.movers.ElvUF_Raid25Mover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-754215"
		E.db.movers.ExperienceBarMover = "TOPLEFTUIParentTOPLEFT722-21"
		E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-549249"
		E.db.movers.ElvUF_Raid40Mover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-754215"
		E.db.movers.ElvUF_PetMover = "BOTTOMLEFTUIParentBOTTOMLEFT634212"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-634222"
		E.db.movers.ElvUF_PetTargetMover = "BOTTOMLEFTUIParentBOTTOMLEFT634185"
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMLEFTUIParentBOTTOMLEFT841169"
		E.db.movers.ElvUF_TankMover = "BOTTOMLEFTUIParentBOTTOMLEFT428249"
		E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTUIParentBOTTOMLEFT549249"
		E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT750251"
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMLEFTUIParentBOTTOMLEFT841192"
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT547302"
	else
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-841212"
		E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTUIParentBOTTOMLEFT4249"
		E.db.movers.ElvUF_PetTargetMover = "BOTTOMLEFTUIParentBOTTOMLEFT835169"
		E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTUIParentBOTTOMLEFT4249"
		E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-634194"
		E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTUIParentBOTTOMLEFT4249"
		E.db.movers.PetAB = "BOTTOMLEFTUIParentBOTTOMLEFT633114"
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-634171"
		E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTUIParentBOTTOMLEFT634194"
		E.db.movers.ElvUF_PetMover = "BOTTOMLEFTUIParentBOTTOMLEFT634157"
		E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTUIParentBOTTOMLEFT4249"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-835169"
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT632247"
	end
	E.db.movers.ElvAB_1 = "BOTTOMLEFTUIParentBOTTOMLEFT91321"
	E.db.movers.ElvAB_2 = "BOTTOMRIGHTUIParentBOTTOMRIGHT-81821"
	E.db.movers.ElvAB_4 = "TOPRIGHTUIParentTOPRIGHT-311-319"
	E.db.movers.ElvAB_3 = "BOTTOMLEFTUIParentBOTTOMLEFT81821"
	E.db.movers.ElvAB_5 = "BOTTOMLEFTUIParentBOTTOMLEFT549479"
	E.db.movers.MinimapMover = "TOPRIGHTUIParentTOPRIGHT0-21"
	E.db.movers.UIBFrameMover = "BOTTOMLEFTUIParentBOTTOMLEFT63421"
	E.db.movers.WatchFrameMover = "TOPRIGHTUIParentTOPRIGHT-237-231"
	E.db.movers.BossHeaderMover = "TOPRIGHTUIParentTOPRIGHT0-233"
	E.db.movers.ArenaHeaderMover = "TOPRIGHTUIParentTOPRIGHT0-233"
	E.db.movers.PetBattleABMover = "BOTTOMLEFTUIParentBOTTOMLEFT76921"
	E.db.movers.ShiftAB = "BOTTOMLEFTUIParentBOTTOMLEFT79121"
	E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP0-32"
	E.db.movers.ReputationBarMover = "TOPElvUIParentTOP0-21"
	E.db.movers.MarkMover = "BOTTOMLEFTUIParentBOTTOMLEFT882146"
	E.db.movers.MicrobarMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT0248"
	E.db.movers.LootFrameMover = "TOPLEFTUIParentTOPLEFT60-360"
	E.db.movers.AurasMover = "TOPRIGHTUIParentTOPRIGHT-214-21"
	E.db.movers.BagsMover = "TOPLEFTUIParentTOPLEFT0-21"
	E.db.movers.GMMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT0456"
	E.db.movers.BossButton = "BOTTOMLEFTUIParentBOTTOMLEFT66846"
	E.db.movers.BNETMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT0481"
	E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-636103"
	E.db.movers.ElvUF_FocusTargetMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT-63634"
	E.db.movers.VehicleSeatMover = "TOPLEFTElvUIParentTOPLEFT187-21"

	E:UpdateAll(true)
end

function E:RepoocSetup() --The function to switch from classic ElvUI settings to Repooc's
	InstallStepComplete.message = L["Repooc's Defaults Set"]
	InstallStepComplete:Show()
	if not E.db.movers then E.db.movers = {}; end
	layout = E.db.layoutSet  --Pull which layout was selected if any.

--	P.sle.auras.castername = true
	--General Options
	E.db.general.autoRepair = "PLAYER"  --Checked
	E.db.general.backdropcolor = {
		["b"] = 0.2509803921568627,
		["g"] = 0.2509803921568627,
		["r"] = 0.2509803921568627,
	}  --Checked
	E.db.general.backdropfadecolor = {
		["a"] = 0.3500000238418579,
		["b"] = 0.2980392156862745,
		["g"] = 0.2980392156862745,
		["r"] = 0.2980392156862745,
	}  --Checked
	E.db.general.bordercolor = {
		["b"] = 0,
		["g"] = 0,
		["r"] = 0,
	}  --Checked
	E.db.general.health = {
	}  --Checked
	E.db.general.health_backdrop = {
	}  --Checked
	E.db.general.interruptAnnounce = "RAID"  --Checked
	E.db.general.stickyFrames = true  --Checked
	E.db.general.tapped = {
	}  --Checked
	E.db.general.threat.enable = true  --Checked
	E.db.general.totems.growthDirection = "HORIZONTAL"  --Checked
	E.db.general.totems.size = 30  --Checked
	E.db.general.valuecolor = {
		["a"] = 1,
		["b"] = 1,
		["g"] = 1,
		["r"] = 1,
	}  --Checked
	E.db.general.vendorGrays = true  --Checked
	E.db.hideTutorial = 1  --Checked

	--Bags
	E.db.bags.bagCols = 13  --Checked
	E.db.bags.yOffset = 208  --Checked

	--Chat
	E.db.chat.hyperlinkHover = false  --Checked
	E.db.chat.font = "Accidental Presidency"  --Checked
	E.db.chat.fontOutline = "OUTLINE"
	E.db.chat.panelHeight = "209"  --Checked
	E.db.chat.panelBackdropNameLeft = "Interface\\addons\\ElvUI_SLE\\media\\textures\\chat_1.tga"  --Checked
	E.db.chat.panelBackdropNameRight = "Interface\\addons\\ElvUI_SLE\\media\\textures\\chat_1.tga"  --Checked
	E.db.chat.panelWidth = 440  --Checked
	E.db.chat.tabFont = "Morpheus"  --Checked
	E.db.chat.tabFontOutline = "OUTLINE"  --Checked
	E.db.chat.tabFontSize = 14  --Checked
	E.db.scrollDownInterval = 30  --Checked

	--LFR Lockout
	E.db.datatexts.lfrshow = true  --Checked
	
	--Raid utility
	E.db.sle.raidutil.ypos = E.screenheight - 30  --Checked
	
	--PvP & Combat Icon
	E.db.sle.combatico.pos = 'TOP'  --Checked
	
	--UIButtons
	E.db.sle.uibuttons.enable = true  --Checked

	--Nameplate
	E.db.nameplate.healthtext = "CURRENT_MAX_PERCENT"  --Checked
	--Actionbars
	E.db.actionbar.font = "Accidental Presidency"  --Checked
	E.db.actionbar.fontsize = 13  --Checked
	E.db.actionbar.fontOutline = "OUTLINE"  --Checked
	E.db.actionbar.hotkeytext = true  --Checked
	E.db.actionbar.macrotext = true  --Checked
	--Bar 1
	E.db.actionbar.bar1.enabled = true  --Checked
	E.db.actionbar.bar1.backdrop = true  --Checked
	E.db.actionbar.bar1.buttons = 12  --Checked
	E.db.actionbar.bar1.buttonsPerRow = 6  --Checked
	--Bar 2
	E.db.actionbar.bar2.enabled = true  --Checked
	E.db.actionbar.bar2.backdrop = true  --Checked
	E.db.actionbar.bar2.buttons = 12  --Checked
	E.db.actionbar.bar2.buttonsPerRow = 6  --Checked
	--Bar 3
	E.db.actionbar.bar3.enabled = true  --Checked
	E.db.actionbar.bar3.backdrop = false  --Checked
	E.db.actionbar.bar3.buttons = 12  --Checked
	E.db.actionbar.bar3.buttonsize = 20  --Checked
	E.db.actionbar.bar3.buttonsPerRow = 2  --Checked
	--Bar 4
	E.db.actionbar.bar4.enabled = true  --Checked
	E.db.actionbar.bar4.backdrop = true  --Checked
	E.db.actionbar.bar4.buttons = 12  --Checked
	E.db.actionbar.bar4.buttonsize = 25  --Checked
	E.db.actionbar.bar4.buttonsPerRow = 1  --Checked
	--Bar 5
	E.db.actionbar.bar5.enabled = true  --Checked
	E.db.actionbar.bar5.backdrop = false  --Checked
	E.db.actionbar.bar5.buttons = 12  --Checked
	E.db.actionbar.bar5.buttonsize = 20  --Checked
	E.db.actionbar.bar5.buttonsPerRow = 2  --Checked
	--Stance Bar
	--E.db.actionbar.stanceBar.buttonsize = 31
	--E.db.actionbar.stanceBar.buttonsPerRow = 1
	--E.db.actionbar.stanceBar.buttonspacing = 5
	--E.db.actionbar.stanceBar.backdrop = true
	--Pet Bar
	E.db.actionbar.barPet.buttonsize = 25  --Checked	

	--Datatext Panels Settings
	E.db.datatexts.font = "Accidental Presidency"  --Checked
	E.db.datatexts.fontOutline = "OUTLINE"  --Checked
	E.db.datatexts.fontSize = 15  --Checked
	E.db.sle.datatext.bottom.enabled = true  --Checked
	E.db.sle.datatext.chatleft.width = 424 --Checked
	E.db.sle.datatext.chatright.width = 424  --Checked
	E.db.sle.datatext.dp1.enabled = false  --Checked
	E.db.sle.datatext.dp2.enabled = false  --Checked
	E.db.sle.datatext.dp3.enabled = false  --Checked
	E.db.sle.datatext.dp4.enabled = false  --Checked
	E.db.sle.datatext.dp5.enabled = true  --Checked
	E.db.sle.datatext.dp5.width = 424  --Checked
	E.db.sle.datatext.dp6.enabled = true  --Checked
	E.db.sle.datatext.dp6.width = 424  --Checked
	E.db.sle.datatext.top.enabled = false  --Checked

	--Datatext Panels Presets
	E.db.datatexts.panels['DP_1']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_1']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_1']['righ'] = ""  --Checked
	E.db.datatexts.panels['DP_2']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_2']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_2']['right'] = ""  --Checked
	E.db.datatexts.panels['DP_3']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_3']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_3']['right'] = ""  --Checked
	E.db.datatexts.panels['DP_4']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_4']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_4']['right'] = ""  --Checked
	E.db.datatexts.panels['DP_5']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_5']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_5']['right'] = ""  --Checked
	E.db.datatexts.panels['DP_6']['left'] = ""  --Checked
	E.db.datatexts.panels['DP_6']['middle'] = ""  --Checked
	E.db.datatexts.panels['DP_6']['right'] = "Bags"  --Checked
	E.db.datatexts.panels['LeftChatDataPanel']['left'] = "BugSack"  --Checked
	E.db.datatexts.panels['LeftChatDataPanel']['middle'] = "AtlasLoot"  --Checked
	E.db.datatexts.panels['LeftChatDataPanel']['right'] = "Durability"  --Checked
	E.db.datatexts.panels['RightChatDataPanel']['left'] = "WIM"  --Checked
	E.db.datatexts.panels['RightChatDataPanel']['middle'] = "SocialState"  --Checked
	E.db.datatexts.panels['RightChatDataPanel']['right'] = "Time"  --Checked
	E.db.datatexts.panels['Top_Center'] = "Version"  --Checked
	E.db.datatexts.panels['Bottom_Panel'] = "System"  --Checked
	E.db.datatexts.panels['LeftMiniPanel'] = "Gold"  --Checked
	E.db.datatexts.panels['RightMiniPanel'] = "Spec Switch"  --Checked

	--Datatext Panels Spec Specific
	if layout == 'tank' then
		E.db.datatexts.panels.DP_5.left = '';  --Checked
		E.db.datatexts.panels.DP_5.middle = '';  --Checked
		E.db.datatexts.panels.DP_5.right = '';  --Checked
		E.db.datatexts.panels.DP_6.left = '';  --Checked
		E.db.datatexts.panels.DP_6.middle = '';  --Checked
	elseif layout == 'healer' then
		E.db.datatexts.panels.DP_5.left = '';  --Checked
		E.db.datatexts.panels.DP_5.middle = 'Crit Chance';  --Checked
		E.db.datatexts.panels.DP_5.right = 'Spell/Heal Power';  --Checked
		E.db.datatexts.panels.DP_6.left = 'Haste';  --Checked
		E.db.datatexts.panels.DP_6.middle = '';  --Checked
	elseif layout == 'dpsCaster' then
		E.db.datatexts.panels.DP_5.left = 'Hit Rating';  --Checked
		E.db.datatexts.panels.DP_5.middle = 'Crit Chance';  --Checked
		E.db.datatexts.panels.DP_5.right = 'Spell/Heal Power';  --Checked
		E.db.datatexts.panels.DP_6.left = 'Haste';  --Checked
		E.db.datatexts.panels.DP_6.middle = 'DPS';  --Checked
	else
		E.db.datatexts.panels.DP_5.left = '';  --Checked
		E.db.datatexts.panels.DP_5.middle = 'Crit Chance';  --Checked
		E.db.datatexts.panels.DP_5.right = '';  --Checked
		E.db.datatexts.panels.DP_6.left = 'Haste';  --Checked
		E.db.datatexts.panels.DP_6.middle = 'DPS';  --Checked
	end

	--Unitframes
	E.db.unitframe.colors.colorhealthbyvalue = false  --Checked
	E.db.unitframe.colors.customhealthbackdrop = true  --Checked
	E.db.unitframe.colors.health = {
		["b"] = 0.3764705882352941,
		["g"] = 0.3764705882352941,
		["r"] = 0.3764705882352941,
	}  --Checked
	E.db.unitframe.colors.health_backdrop = {
		["b"] = 0,
		["g"] = 0,
		["r"] = 0.8784313725490196,
	}  --Checked
	E.db.unitframe.font = "Accidental Presidency"  --Checked
	E.db.unitframe.fontSize = 13  --Checked
	E.db.unitframe.fontOutline = 'THICKOUTLINE'  --Checked

	--Unitframes (Player)
	E.db.unitframe.units.player.castbar.height = 15  --Checked
	E.db.unitframe.units.player.castbar.width = 308  --Checked
	E.db.unitframe.units.player.classbar.fill = "fill"  --Checked
	E.db.unitframe.units.player.health.position = "BOTTOMLEFT"  --Checked
	E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current-percent:sl]"  --Checked
	E.db.unitframe.units.player.height = 54  --Checked
	E.db.unitframe.units.player.name.position = "BOTTOMRIGHT"  --Checked
	E.db.unitframe.units.player.name.text_format = "[namecolor][name:medium]"  --Checked
	E.db.unitframe.units.player.portrait.camDistanceScale = 2  --Checked
	E.db.unitframe.units.player.portrait.enable = true  --Checked
	E.db.unitframe.units.player.portrait.overlay = true  --Checked
	E.db.unitframe.units.player.power.offset = 20  --Checked
	E.db.unitframe.units.player.power.position = "BOTTOMLEFT"  --Checked
	E.db.unitframe.units.player.power.text_format = "[powercolor][power:current:sl]"  --Checked
	E.db.unitframe.units.player.pvp.text_format = "||cFFB04F4F[pvptimer]||r"  --Checked
	E.db.unitframe.units.player.restIcon = false  --Checked
	E.db.unitframe.units.player.width = 270  --Checked

	--Unitframes (Target)
	E.db.unitframe.units.target.castbar.height = 25  --Checked
	E.db.unitframe.units.target.castbar.width = 308  --Checked
	E.db.unitframe.units.target.healPrediction = true  --Checked
	E.db.unitframe.units.target.health.position = "BOTTOMRIGHT"  --Checked
	E.db.unitframe.units.target.health.text = true  --Checked
	E.db.unitframe.units.target.name.enable = true  --Checked
	E.db.unitframe.units.target.name.position = "BOTTOMLEFT"  --Checked
	E.db.unitframe.units.target.portrait.camDistanceScale = 2  --Checked
	E.db.unitframe.units.target.portrait.enable = true  --Checked
	E.db.unitframe.units.target.portrait.overlay = true  --Checked
	E.db.unitframe.units.target.power.hideonnpc = false  --Checked
	E.db.unitframe.units.target.power.offset = 20  --Checked
	E.db.unitframe.units.target.power.position = "BOTTOMRIGHT"  --Checked
	E.db.unitframe.units.target.power.hideonnpc = false  --Checked

	--Unitframes (Raid10)
	E.db.unitframe.units.raid10.health.orientation = "VERTICAL"  --Checked
	E.db.unitframe.units.raid10.width = 69  --Checked

	--Unitframes (Raid25)
	E.db.unitframe.units.raid25.healPrediction = true  --Checked
	E.db.unitframe.units.raid25.width = 69  --Checked
	E.db.unitframe.units.raid25.health.orientation = "VERTICAL"  --Checked
	E.db.unitframe.units.raid25.height = 39  --Checked

	--Unitframes (Raid40)
	E.db.unitframe.units.raid40.width = 69  --Checked

	if layout == "healer" then			
		E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT489332"  --Checked
		E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-492332"  --Checked
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-789347"  --Checked
		E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT489294"  --Checked
		E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-260342"  --Checked
		E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTUIParentBOTTOMLEFT44379"  --Checked
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT806170"  --Checked
		E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44379"  --Checked
		E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44323"  --Checked
		E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44323"  --Checked
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT806193"  --Checked
		E.db.movers.MarkMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT883229"  --Checked
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT552232"  --Checked
		E.db.movers.UIBFrameMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-44222"  --Checked
		E.db.movers.ElvAB_1 = "BOTTOMLEFTElvUIParentBOTTOMLEFT85695"  --Checked
		E.db.movers.ElvAB_2 = "BOTTOMLEFTElvUIParentBOTTOMLEFT85621"  --Checked
		E.db.movers.ElvAB_3 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-80222"  --Checked
		E.db.movers.ElvAB_5 = "BOTTOMLEFTElvUIParentBOTTOMLEFT80222"  --Checked
	else
		E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT489332"  --Checked
		E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-492332"  --Checked
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-789347"  --Checked
		E.db.movers.ElvUF_PetMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT489294"  --Checked
		E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-260342"  --Checked
		E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTUIParentBOTTOMLEFT44379"  --Checked
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT806170"  --Checked
		E.db.movers.ElvUF_Raid10Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44379"  --Checked
		E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44323"  --Checked
		E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT44323"  --Checked
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT806193"  --Checked
		E.db.movers.MarkMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT883229"  --Checked
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT552232"  --Checked
		E.db.movers.UIBFrameMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-44222"  --Checked
		E.db.movers.ElvAB_1 = "BOTTOMLEFTElvUIParentBOTTOMLEFT85695"  --Checked
		E.db.movers.ElvAB_2 = "BOTTOMLEFTElvUIParentBOTTOMLEFT85621"  --Checked
		E.db.movers.ElvAB_3 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-80222"  --Checked
		E.db.movers.ElvAB_5 = "BOTTOMLEFTElvUIParentBOTTOMLEFT80222"  --Checked
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		FCF_SetChatWindowFontSize(nil, frame, 14)		
	end

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
	E.db.install_complete = E.version
	
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
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() E:SetupTheme('pixelPerfect') end)
		InstallOption4Button:SetText(L['Pixel Perfect'])		
	elseif PageNum == 5 then
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
	elseif PageNum == 6 then
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
	elseif PageNum == 7 then
		f.SubTitle:SetText(L["Auras System"])
		f.Desc1:SetText(L["Select the type of aura system you want to use with ElvUI's unitframes. The integrated system utilizes both aura-bars and aura-icons. The icons only system will display only icons and aurabars won't be used. The classic system will configure your auras to how they were pre-v4."])
		f.Desc2:SetText(L["If you have an icon or aurabar that you don't want to display simply hold down shift and right click the icon for it to disapear."])
		f.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupAuras('integrated') end)
		InstallOption1Button:SetText(L['Integrated'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() SetupAuras() end)
		InstallOption2Button:SetText(L['Icons Only'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() SetupAuras('classic') end)
		InstallOption3Button:SetText(L['Classic'])	
	elseif PageNum == 8 then --The new page
		f.SubTitle:SetText(L["Shadow & Light Settings"])
		f.Desc1:SetText(L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."])
		f.Desc2:SetText(L["SLE_Install_Text2"])
		f.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
		
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:DarthSetup() end)
		InstallOption1Button:SetText(L["Darth's Config"])	
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:RepoocSetup() end)
		InstallOption2Button:SetText(L["Repooc's Config"])
	elseif PageNum == 9 and IsAddOnLoaded("ElvUI_Hud") then --Hud's page if enabled
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
	elseif PageNum == 9 and not IsAddOnLoaded("ElvUI_Hud") then --Finish install if Hud disabled
		f.SubTitle:SetText(L["Installation Complete"])
		f.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
		f.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript("OnClick", InstallComplete)
		InstallOption1Button:SetText(L["Finished"])				
		ElvUIInstallFrame:Size(550, 350)
	elseif PageNum == 10 then --Finish install if Hud enabled
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