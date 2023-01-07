local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = SLE.Blizzard
local _G = _G

--Frames to move
B.Frames = {
	AddonList = true,
	BankFrame = true,
	CharacterFrame = true,
	ChatConfigFrame = true,
	DressUpFrame = true,
	FriendsFrame = true,
	FriendsFriendsFrame = true,
	GameMenuFrame = true,
	GhostFrame = true,
	GossipFrame = true,
	GuildInviteFrame = true,
	GuildRegistrarFrame = true,
	HelpFrame = true,
	ItemTextFrame = true,
	LFDRoleCheckPopup = true,
	LFGDungeonReadyDialog = true,
	LFGDungeonReadyStatus = true,
	LootFrame = true,
	-- MailFrame = true,
	MerchantFrame = true,
	PVEFrame = true,
	PetStableFrame = true,
	PetitionFrame = true,
	PVPReadyDialog = true,
	QuestFrame = true,
	QuestLogPopupDetailFrame = true,
	RaidBrowserFrame = true,
	RaidInfoFrame = true,
	RaidParentFrame = true,
	ReadyCheckFrame = true,
	ReportCheatingDialog = true,
	RolePollPopup = true,
	SettingsPanel = true,
	SpellBookFrame = true,
	SplashFrame = true,
	StackSplitFrame = true,
	StaticPopup1 = true,
	StaticPopup2 = true,
	StaticPopup3 = true,
	StaticPopup4 = true,
	TabardFrame = true,
	TaxiFrame = true,
	TimeManagerFrame = true,
	TradeFrame = true,
	TutorialFrame = true,
	WorldMapFrame = true,
}

--These should be only temporary movable due to complications
B.TempOnly = {
	BonusRollFrame = true,
	BonusRollLootWonFrame = true,
	BonusRollMoneyWonFrame = true,
	StaticPopup1 = true,
	StaticPopup2 = true,
	StaticPopup3 = true,
	StaticPopup4 = true,
}

--Blizz addons that load later
B.AddonsList = {
	Blizzard_AchievementUI = {
		AchievementFrame = true,
	},
	Blizzard_AlliedRacesUI = {
		AlliedRacesFrame = true,
	},
	Blizzard_ArchaeologyUI = {
		ArchaeologyFrame = true,
	},
	Blizzard_AuctionUI = {
		AuctionFrame = true,
	},
	Blizzard_AuctionHouseUI = {
		AuctionHouseFrame = true,
	},
	Blizzard_AzeriteUI = {
		AzeriteEmpoweredItemUI = true,
	},
	Blizzard_BarberShopUI = {
		BarberShopFrame = true,
	},
	Blizzard_BindingUI = {
		KeyBindingFrame = true,
	},
	Blizzard_BlackMarketUI = {
		BlackMarketFrame = true,
	},
	Blizzard_Calendar = {
		CalendarCreateEventFrame = true,
		CalendarFrame = true,
	},
	Blizzard_ChallengesUI = {
		ChallengesKeystoneFrame = true,
		-- ChallengesLeaderboardFrame = false,
	},
	Blizzard_Channels = {
		ChannelFrame = true,
	},
	Blizzard_Collections = {
		CollectionsJournal = false,
		WardrobeFrame = true,
	},
	Blizzard_Communities = {
		CommunitiesFrame = true,
	},
	Blizzard_CovenantSanctum = {
		CovenantSanctumFrame = true,
	},
	Blizzard_EncounterJournal = {
		EncounterJournal = true,
	},
	Blizzard_GarrisonUI = {
		GarrisonLandingPage = true,
		GarrisonMissionFrame = true,
		GarrisonCapacitiveDisplayFrame = true,
		GarrisonBuildingFrame = true,
		GarrisonRecruiterFrame = true,
		GarrisonRecruitSelectFrame = true,
		GarrisonShipyardFrame = true,
		OrderHallMissionFrame = true,
		BFAMissionFrame = true,
		CovenantMissionFrame = true,
	},
	Blizzard_GMChatUI = {
		GMChatStatusFrame = true,
	},
	Blizzard_GMSurveyUI = {
		GMSurveyFrame = true,
	},
	Blizzard_GuildBankUI = {
		GuildBankFrame = true,
	},
	Blizzard_GuildControlUI = {
		GuildControlUI = true,
	},
	Blizzard_GuildUI = {
		GuildFrame = true,
		GuildLogFrame = true,
	},
	Blizzard_InspectUI = {
		InspectFrame = true,
	},
	Blizzard_ItemAlterationUI = {
		TransmogrifyFrame = true,
	},
	Blizzard_ItemSocketingUI = {
		ItemSocketingFrame = true,
	},
	Blizzard_ItemUpgradeUI = {
		ItemUpgradeFrame = true,
	},
	-- Blizzard_LookingForGuildUI = {
	-- 	LookingForGuildFrame = true,
	-- },
	Blizzard_MacroUI = {
		MacroFrame = true,
	},
	Blizzard_OrderHallUI = {
		OrderHallTalentFrame = true,
	},
	Blizzard_QuestChoice = {
		QuestChoiceFrame = true,
	},
	Blizzard_Soulbinds = {
		SoulbindViewer = true,
	},
	Blizzard_ScrappingMachineUI = {
		ScrappingMachineFrame = true,
	},
	Blizzard_ClassTalentUI = {
		ClassTalentFrame = true,
	},
	Blizzard_Professions = {
		ProfessionsFrame = true,
	},
	Blizzard_TrainerUI = {
		ClassTrainerFrame = true,
	},
	Blizzard_VoidStorageUI = {
		VoidStorageFrame = true,
	},
}

--These should not be on screen at the same time
B.ExlusiveFrames = {
	QuestFrame = { 'GossipFrame', },
	GossipFrame = { 'QuestFrame', },
	GameMenuFrame = { 'HelpFrame', 'SettingsPanel',},
	HelpFrame = { 'GameMenuFrame',},
	SettingsPanel = { 'GameMenuFrame',},
}

--Don't even ask
B.FramesAreaAlter = {
	GarrisonMissionFrame = 'left',
	OrderHallMissionFrame = 'left',
	BFAMissionFrame = 'left',
}
B.SpecialDefaults = {
	GarrisonMissionFrame = { 'CENTER', _G.UIParent, 'CENTER', 0, 0 },
	OrderHallMissionFrame = { 'CENTER', _G.UIParent, 'CENTER', 0, 0 },
	BFAMissionFrame = { 'CENTER', _G.UIParent, 'CENTER', 0, 0 },
}

B.OriginalDefaults = {} --Don't even ask 2: The Reckoning

local function OnDragStart(self)
	if _G.UnitAffectingCombat('player') then return end --Not allowed to move in combat, cause reasons.
	local Name = self:GetName()
	if not E.private.sle.module.blizzmove.remember and not B.OriginalDefaults[Name] then --Don't even ask 3: Return of the bullshit
		local a, _, c, d, e = self:GetPoint()
		local b = self:GetParent():GetName() or _G.UIParent
		B.OriginalDefaults[Name] = {a, b, c, d, e}
	end
	self.IsMoving = true
	self:StartMoving()
end

--When stop moving (or hiding), remember frame's positions.
local function OnDragStop(self)
	self:StopMovingOrSizing()
	local Name = self:GetName()
	if E.private.sle.module.blizzmove.remember and not B.TempOnly[Name] then --Saving positions only if option is enabled and frame is not temporary movable
		local a, _, c, d, e = self:GetPoint()
		local b = self:GetParent():GetName() or _G.UIParent
		if Name == 'QuestFrame' or Name == 'GossipFrame' then --These 2 frames should always be in the same place. So having coordinates for them at the same time
			E.private.sle.module.blizzmove.points['GossipFrame'] = {a, b, c, d, e}
			E.private.sle.module.blizzmove.points['QuestFrame'] = {a, b, c, d, e}
		else
			E.private.sle.module.blizzmove.points[Name] = {a, b, c, d, e}
		end
		self:SetUserPlaced(true)
	elseif self:IsUserPlaced() then --Unfuck the game
		self:ClearAllPoints()
		self:SetUserPlaced(false)
	end
	self.IsMoving = false
end

--On show set saved position
local function LoadPosition(self)
	if self.IsMoving == true then return end
	local Name = self:GetName()

	if not self:GetPoint() then --Some frames don't have set positions when show script runs (e.g. CharacterFrame). For those set default position and save that.
		if B.SpecialDefaults[Name] then
			local a,b,c,d,e = unpack(B.SpecialDefaults[Name])
			self:SetPoint(a,b,c,d,e, true)
		elseif B.OriginalDefaults[Name] then
			local a,b,c,d,e = unpack(B.OriginalDefaults[Name])
			self:SetPoint(a,b,c,d,e, true)
		else
			self:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 16, -116, true)
		end
		OnDragStop(self)
	end

	if E.private.sle.module.blizzmove.remember and E.private.sle.module.blizzmove.points[Name] and not B.TempOnly[Name] then
		self:ClearAllPoints()
		local a,b,c,d,e = unpack(E.private.sle.module.blizzmove.points[Name])
		if a ~= nil then
			self:SetPoint(a,b,c,d,e, true)
		end
	end

	if B.ExlusiveFrames[Name] then for _, name in pairs(B.ExlusiveFrames[Name]) do _G[name]:Hide() end end --If this frame has others that should not be shown at the same time, hide those
end

--Hooking this to movable frames' SetPoint.
--Blizz love to move some frames when stuff happens, so if SetPoint is not passing an additional arg we call SetPoint again with saved position.
function B:RewritePoint(anchor, parent, point, x, y, SLEcalled)
	if not SLEcalled then LoadPosition(self) end
end

function B:MakeMovable(Name, AddOn)
	if Name == true then
		E:Delay(1, function() B:Addons(nil, AddOn) end)
		return
	end
	local frame = _G[Name]
	if not frame then --Frame in the list was removed since the last time I checked
		SLE:Print("Frame to move doesn't exist: "..(Name or 'Unknown'), 'error')
		return
	end

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag('LeftButton')

	frame:HookScript('OnShow', LoadPosition)
	frame:HookScript('OnDragStart', OnDragStart)
	frame:HookScript('OnDragStop', OnDragStop)
	frame:HookScript('OnHide', OnDragStop)
	hooksecurefunc(frame, 'SetPoint', B.RewritePoint)
end

function B:Addons(event, addon)
	if not B.AddonsList[addon] then return end
	if type(B.AddonsList[addon]) == 'table' then
		for FrameName, state in pairs(B.AddonsList[addon]) do
			if state then B:MakeMovable(FrameName, addon) end
		end
	else
		if B.AddonsList[addon] then B:MakeMovable(addon) end
	end
	B.addonCount = B.addonCount + 1
	--If every blizz addon is loaded we don't need to listen to these event
	if B.addonCount == #B.AddonsList then B:UnregisterEvent(event) end
end

function B:ErrorFrameSize()
	_G.UIErrorsFrame:SetSize(B.db.errorframe.width, B.db.errorframe.height) --512 x 60
end

local function CompatibilityChecks()
	if SLE._Compatibility['Mapster'] then B.Frames['WorldMapFrame'] = false end
	if SLE._Compatibility['TradeSkillMaster'] then B.Frames['MerchantFrame'] = false end
end

function B:SLETalkingHead()
	if not _G.TalkingHeadFrame.mover then return end
	if E.db.sle.skins.talkinghead.hide then
		E:DisableMover(_G.TalkingHeadFrame.mover:GetName())
	else
		E:EnableMover(_G.TalkingHeadFrame.mover:GetName())
	end
end

function B:UpdateAll()
	B.db = E.db.sle.blizzard
	B:ErrorFrameSize()
	B:SLETalkingHead()
end

function B:Initialize()
	B.db = E.db.sle.blizzard
	if not SLE.initialized then return end
	B.addonCount = 0

	PVPReadyDialog:Hide()

	if E.private.sle.module.blizzmove.enable then
		CompatibilityChecks()
		for FrameName, state in pairs(B.Frames) do
			if state then B:MakeMovable(FrameName) end
		end

		self:RegisterEvent('ADDON_LOADED', 'Addons')

		-- Check Forced Loaded AddOns
		for AddOn, Table in pairs(B.AddonsList) do
			if IsAddOnLoaded(AddOn) then
				for _, frame in pairs(Table) do
					B:MakeMovable(frame, AddOn)
				end
			end
		end

		--Removing stuff from auto positioning
		self:SecureHook('UIParent_ManageFramePositions', function()
			for FrameName, state in pairs(B.Frames) do
				local frame = _G[FrameName]
				if state and frame and frame:IsShown() then
					if FrameName == 'CharacterFrame' or FrameName == 'WorldMapFrame' then return end
					LoadPosition(frame)
				end
			end
		end, true)
	end

	B:ErrorFrameSize()
	SLE.UpdateFunctions["Blizzard"] = B.UpdateAll

	B:SLETalkingHead()
	hooksecurefunc(TalkingHeadFrame, 'PlayCurrent', function(self)
		if E.db.sle.skins.talkinghead.hide then
			self:Close()
			self:Hide()
		end
	end)
end

SLE:RegisterModule(B:GetName())
