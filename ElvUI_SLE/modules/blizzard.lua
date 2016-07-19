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
	"BankFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"CinematicFrame",
	"DressUpFrame",
	"FriendsFrame",
	"GameMenuFrame",
	"GossipFrame",
	"GuildInviteFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemTextFrame",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"OpenMailFrame",
	"PVEFrame",
	"PetStableFrame",
	"PetitionFrame",
	"QuestFrame",
	"RaidBrowserFrame",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"StackSplitFrame",
	"StaticPopup1",
	"StaticPopup2",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"WorldMapFrame",
}

B.AddonsList = {
	["Blizzard_AchievementUI"] = {"AchievementFrame","AchievementFrameHeader"},
	["Blizzard_ArchaeologyUI"] = "ArchaeologyFrame",
	["Blizzard_AuctionUI"] = "AuctionFrame",
	["Blizzard_Calendar"] = "CalendarFrame",
	["Blizzard_Collections"] = "CollectionsJournal",
	["Blizzard_EncounterJournal"] = "EncounterJournal",
	["Blizzard_GarrisonUI"] = {"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame", "GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame", "GarrisonShipyardFrame"},
	["Blizzard_GuildBankUI"] = "GuildBankFrame",
	["Blizzard_GuildControlUI"] = "GuildControlUI",
	["Blizzard_GuildUI"] = "GuildFrame",
	["Blizzard_InspectUI"] = "InspectFrame",
	["Blizzard_ItemAlterationUI"] = "TransmogrifyFrame",
	["Blizzard_ItemSocketingUI"] = "ItemSocketingFrame",
	["Blizzard_ItemUpgradeUI"] = "ItemUpgradeFrame",
	["Blizzard_LookingForGuildUI"] = "LookingForGuildFrame",
	["Blizzard_MacroUI"] = "MacroFrame",
	["Blizzard_TalentUI"] = "PlayerTalentFrame",
	["Blizzard_TradeSkillUI"] = "TradeSkillFrame",
	["Blizzard_VoidStorageUI"] = "VoidStorageFrame",
}

function B:MakeMovable(frame)
	if frame then
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
		frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		if frame.TitleMouseover then B:MakeMovable(frame.TitleMouseover) end
	end
end

function B:Addons(event, addon)
	local frame
	addon = B.AddonsList[addon]
	if not addon then return end
	if T.type(addon) == "table" then
		for i = 1, #addon do
			frame = _G[addon[i]]
			B:MakeMovable(frame)
		end
	else
		frame = _G[addon]
		B:MakeMovable(frame)
	end
	B.addonCount = B.addonCount + 1
	if B.addonCount == #B.AddonsList then B:UnregisterEvent(event) end
end

function B:VehicleScale()
	local frame = VehicleSeatIndicator
	frame:SetScale(B.db.vehicleSeatScale)
	frame.mover:SetSize(B.db.vehicleSeatScale * frame:GetWidth(), B.db.vehicleSeatScale * frame:GetHeight())
end

function B:ErrorFrameSize()
	UIErrorsFrame:SetSize(B.db.errorframe.width, B.db.errorframe.height) --512 x 60
end

function B:Initialize()
	B.db = E.db.sle.blizzard
	if not SLE.initialized then return end
	B.addonCount = 0
	if E.private.sle.module.blizzmove then
		if E.isMacClient then T.tinsert(B.Frames, "MacOptionsFrame") end
		for i = 1, #B.Frames do
			local frame = _G[B.Frames[i]]
			if frame then B:MakeMovable(frame) else SLE:ErrorPrint("Doesn't exist: "..B.Frames[i]) end
		end
		self:RegisterEvent("ADDON_LOADED", "Addons")
	end

	E:Delay(1, B.VehicleScale)
	B:ErrorFrameSize()
	function B:ForUpdateAll()
		B.db = E.db.sle.blizzard
		B:VehicleScale()
		B:ErrorFrameSize()
	end
end

SLE:RegisterModule(B:GetName())