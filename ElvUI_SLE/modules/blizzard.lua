local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = SLE:NewModule("Blizzard", 'AceHook-3.0', 'AceEvent-3.0')
local _G = _G

local EnableMouse = EnableMouse
local SetMovable = SetMovable
local SetClampedToScreen = SetClampedToScreen
local RegisterForDrag = RegisterForDrag
local StartMoving = StartMoving
local StopMovingOrSizing = StopMovingOrSizing

B.Frames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"BonusRollFrame",
	"BonusRollLootWonFrame",
	"BonusRollMoneyWonFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"DressUpFrame",
	"FriendsFrame",
	"FriendsFriendsFrame",
	"GameMenuFrame",
	"GossipFrame",
	"GuildInviteFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemTextFrame",
	"LFDRoleCheckPopup",
	"LFGDungeonReadyDialog",
	"LFGDungeonReadyStatus",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"OpenMailFrame",
	"PVEFrame",
	"PetStableFrame",
	"PetitionFrame",
	"PVPReadyDialog",
	"QuestFrame",
	"QuestLogPopupDetailFrame",
	"RaidBrowserFrame",
	"RaidInfoFrame",
	"RaidParentFrame",
	"ReadyCheckFrame",
	"ReportCheatingDialog",
	"RolePollPopup",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"SplashFrame",
	"StackSplitFrame",
	"StaticPopup1",
	"StaticPopup2",
	"StaticPopup3",
	"StaticPopup4",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"WorldMapFrame",
}

B.AddonsList = {
	["Blizzard_AchievementUI"] = { "AchievementFrame" },
	["Blizzard_ArchaeologyUI"] = { "ArchaeologyFrame" },
	["Blizzard_AuctionUI"] = { "AuctionFrame" },
	["Blizzard_BarberShopUI"] = { "BarberShopFrame" },
	["Blizzard_BindingUI"] = { "KeyBindingFrame" },
	["Blizzard_BlackMarketUI"] = { "BlackMarketFrame" },
	["Blizzard_Calendar"] = { "CalendarCreateEventFrame", "CalendarFrame", "CalendarViewEventFrame", "CalendarViewHolidayFrame" },
	["Blizzard_ChallengesUI"] = { "ChallengesKeystoneFrame" }, -- 'ChallengesLeaderboardFrame'
	["Blizzard_Collections"] = { "CollectionsJournal" },
	["Blizzard_Communities"] = { "CommunitiesFrame" },
	["Blizzard_EncounterJournal"] = { "EncounterJournal" },
	["Blizzard_GarrisonUI"] = { "GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame", "GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame", "GarrisonShipyardFrame" },
	["Blizzard_GMChatUI"] = { "GMChatStatusFrame" },
	["Blizzard_GMSurveyUI"] = { "GMSurveyFrame" },
	["Blizzard_GuildBankUI"] = { "GuildBankFrame" },
	["Blizzard_GuildControlUI"] = { "GuildControlUI" },
	["Blizzard_GuildUI"] = { "GuildFrame", "GuildLogFrame" },
	["Blizzard_InspectUI"] = { "InspectFrame" },
	["Blizzard_ItemAlterationUI"] = { "TransmogrifyFrame" },
	["Blizzard_ItemSocketingUI"] = { "ItemSocketingFrame" },
	["Blizzard_ItemUpgradeUI"] = { "ItemUpgradeFrame" },
	["Blizzard_LookingForGuildUI"] = { "LookingForGuildFrame" },
	["Blizzard_MacroUI"] = { "MacroFrame" },
	["Blizzard_OrderHallUI"] = { "OrderHallTalentFrame" },
	["Blizzard_QuestChoice"] = { "QuestChoiceFrame" },
	["Blizzard_TalentUI"] = { "PlayerTalentFrame" },
	["Blizzard_TalkingHeadUI"] = { "TalkingHeadFrame" },
	["Blizzard_TradeSkillUI"] = { "TradeSkillFrame" },
	["Blizzard_TrainerUI"] = { "ClassTrainerFrame" },
	["Blizzard_VoidStorageUI"] = { "VoidStorageFrame" },
}

local function LoadPosition(self)
	if self.IsMoving == true then return end
	local Name = self:GetName()
	if not self:GetPoint() then
		self:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
	end

	if E.private.sle.module.blizzmove.remember and E.private.sle.module.blizzmove.points[Name] then
		self:ClearAllPoints()
		self:SetPoint(T.unpack(E.private.sle.module.blizzmove.points[Name]))
	end
end

local function OnDragStart(self)
	self.IsMoving = true
	self:StartMoving()
end

local function OnDragStop(self)
	self:StopMovingOrSizing()
	self.IsMoving = false
	local Name = self:GetName()
	if E.private.sle.module.blizzmove.remember then
		local a, b, c, d, e = self:GetPoint()
		if self:GetParent() then 
			b = self:GetParent():GetName() or UIParent
		else
			b = UIParent
		end
		if Name == "QuestFrame" or Name == "GossipFrame" then
			E.private.sle.module.blizzmove.points["GossipFrame"] = {a, b, c, d, e}
			E.private.sle.module.blizzmove.points["QuestFrame"] = {a, b, c, d, e}
		else
			E.private.sle.module.blizzmove.points[Name] = {a, b, c, d, e}
		end
	else
		self:SetUserPlaced(false)
	end
end


function B:MakeMovable(Name)
	local frame = _G[Name]
	if not frame then
		SLE:ErrorPrint("Frame to move doesn't exist: "..(frameName or "Unknown"))
		return
	end

	if Name == "AchievementFrame" then AchievementFrameHeader:EnableMouse(false) end

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:HookScript("OnShow", LoadPosition)
	frame:HookScript("OnDragStart", OnDragStart)
	frame:HookScript("OnDragStop", OnDragStop)
	frame:HookScript("OnHide", OnDragStop)

	if E.private.sle.module.blizzmove.remember then
		frame.ignoreFramePositionManager = true
		if UIPanelWindows[Name] then
			for Key in T.pairs(UIPanelWindows[Name]) do
				if Key == 'area' or Key == "pushable" then
					UIPanelWindows[Name][Key] = nil
				end
			end
		end
	end

	C_Timer.After(0, function()
		if E.private.sle.module.blizzmove.remember and E.private.sle.module.blizzmove.points[Name] then
			if not frame:GetPoint() then
				frame:SetPoint('TOPLEFT', 'UIParent', 'TOPLEFT', 16, -116)
			end

			frame:ClearAllPoints()
			frame:SetPoint(T.unpack(E.private.sle.module.blizzmove.points[Name]))
		end
	end)

end

function B:Addons(event, addon)
	addon = B.AddonsList[addon]
	if not addon then return end
	if T.type(addon) == "table" then
		for i = 1, #addon do
			B:MakeMovable(addon[i])
		end
	else
		B:MakeMovable(addon)
	end
	B.addonCount = B.addonCount + 1
	if B.addonCount == #B.AddonsList then B:UnregisterEvent(event) end
end

function B:VehicleScale()
	local frame = _G["VehicleSeatIndicator"]
	local frameScale = B.db.vehicleSeatScale
	frame:SetScale(frameScale)
	if frame.mover then
		frame.mover:SetSize(frameScale * frame:GetWidth(), frameScale * frame:GetHeight())
	end
end

function B:ErrorFrameSize()
	_G["UIErrorsFrame"]:SetSize(B.db.errorframe.width, B.db.errorframe.height) --512 x 60
end

function B:Initialize()
	B.db = E.db.sle.blizzard
	if not SLE.initialized then return end
	B.addonCount = 0
	if E.private.sle.module.blizzmove and T.type(E.private.sle.module.blizzmove) == "boolean" then E.private.sle.module.blizzmove = V.sle.module.blizzmove end --Old setting conversions
	E.global.sle.pvpreadydialogreset = nil
	if not E.private.sle.pvpreadydialogreset then E.private.sle.module.blizzmove.points["PVPReadyDialog"] = nil; E.private.sle.pvpreadydialogreset = true end
	PVPReadyDialog:Hide()
	if E.private.sle.module.blizzmove.enable then
		for i = 1, #B.Frames do
			B:MakeMovable(B.Frames[i])
		end
		self:RegisterEvent("ADDON_LOADED", "Addons")
		
		-- Check Forced Loaded AddOns
		for AddOn, Table in T.pairs(B.AddonsList) do
			if IsAddOnLoaded(AddOn) then
				for _, frame in T.pairs(Table) do
					B:MakeMovable(frame)
				end
			end
		end

	end

	hooksecurefunc(VehicleSeatIndicator,"SetPoint", B.VehicleScale)
	B:ErrorFrameSize()
	function B:ForUpdateAll()
		B.db = E.db.sle.blizzard
		B:VehicleScale()
		B:ErrorFrameSize()
	end
end

SLE:RegisterModule(B:GetName())