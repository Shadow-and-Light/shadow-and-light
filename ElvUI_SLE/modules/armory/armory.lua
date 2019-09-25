local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo("ElvUI_KnightFrame")) and IsAddOnLoaded("ElvUI_KnightFrame") then return end --Don't break korean code :D
local Armory = SLE:NewModule("Armory_Core", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local LCG = LibStub('LibCustomGlow-1.0')

Armory.Constants = {}

--Cache--
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION

local C_Transmog_GetSlotInfo = C_Transmog.GetSlotInfo
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo
local C_TransmogCollection_GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo

local HandleModifiedItemClick = HandleModifiedItemClick

--<<Class-to-Spec and localizing stuffs>>--
--[[local ClassToSpec = {
	["DEATHKNIGHT"] = {
		["Blood"] = 250, ["Frost"] = 251, ["Unholy"] = 252,
	},
	["DEMONHUNTER"] = {
		["Havoc"] = 577, ["Vengeance"] = 581,
	},
	["DRUID"] = {
		["Balance"] = 102, ["Feral"] = 103, ["Guardian"] = 104, ["Restoration"] = 105,
	},
	["HUNTER"] = {
		["Beast"] = 253, ["Marksmanship"] = 254, ["Survival"] = 255,
	},
	["MAGE"] = {
		["Arcane"] = 62, ["Fire"] = 63, ["Frost"] = 64,
	},
	["MONK"] = {
		["Brewmaster"] = 268, ["Mistweaver"] = 270, ["Windwalker"] = 269,
	},
	["PALADIN"] = {
		["Holy"] = 65, ["Protection"] = 66, ["Retribution"] = 70,
	},
	["PRIEST"] = {
		["Discipline"] = 256, ["Holy"] = 257, ["Shadow"] = 258,
	},
	["ROGUE"] = {
		["Assassination"] = 259, ["Combat"] = 260, ["Subtlety"] = 261,
	},
	["SHAMAN"] = {
		["Elemental"] = 262, ["Enhancement"] = 263, ["Restoration"] = 264,
	},
	["WARLOCK"] = {
		["Affliction"] = 265, ["Demonology"] = 266, ["Destruction"] = 267,
	},
	["WARRIOR"] = {
		["Arms"] = 71, ["Fury"] = 72, ["Protection"] = 73,
	},
}
--This basically builds a list of locales for each class and spec name.
--Obviously doesn't support locale selection cause info comes from server and it doesn't give a fuck about elvui settings.
for ClassName, Spec_ID_Table in T.pairs(ClassToSpec) do
	-- L["SLE_Armory_"..ClassName] = KF:Color_Class(ClassName, LOCALIZED_CLASS_NAMES_MALE[ClassName])

	-- for SpecName, ID in T.pairs(Spec_ID_Table) do
		-- _, L["SLE_Armory_"..ClassName.."_"..SpecName] = GetSpecializationInfoByID(ID)
	-- end
end]]

	--Create ench replacement string DB
	if type(SLE_ArmoryDB) ~= "table" then
		SLE_ArmoryDB = {
			EnchantString = {}
		}
	end

Armory.Constants.GearList = {
	"HeadSlot", "HandsSlot", "NeckSlot", "WaistSlot", "ShoulderSlot", "LegsSlot", "BackSlot", "FeetSlot", "ChestSlot", "Finger0Slot",
	"ShirtSlot", "Finger1Slot", "TabardSlot", "Trinket0Slot", "WristSlot", "Trinket1Slot", "SecondaryHandSlot", "MainHandSlot"
}
Armory.Constants.AzeriteSlot = {
	"HeadSlot", "ShoulderSlot", "ChestSlot",
}
Armory.Constants.CanTransmogrify = {
	["HeadSlot"] = true, ["ShoulderSlot"] = true, ["BackSlot"] = true, ["ChestSlot"] = true, ["WristSlot"] = true,
	["HandsSlot"] = true, ["WaistSlot"] = true, ["LegsSlot"] = true, ["FeetSlot"] = true, ["MainHandSlot"] = true, ["SecondaryHandSlot"] = true
}

Armory.Constants.AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1}

function Armory:BuildCharacterDefaultsCache()
	Armory.Constants.CA_Defaults = {}
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		Armory.Constants.CA_Defaults[SlotName] = {}
		local Slot = _G["Character"..SlotName]
		Slot.Direction = i%2 == 1 and "LEFT" or "RIGHT"
		if Slot.iLvlText then
			Armory.Constants.CA_Defaults[SlotName]["iLvlText"] = { Slot.iLvlText:GetPoint() } 
			Armory.Constants.CA_Defaults[SlotName]["textureSlot1"] = { Slot.textureSlot1:GetPoint() }
			for i = 2, 10 do
				if Slot["textureSlot"..i] then Slot["textureSlot"..i]:ClearAllPoints(); Slot["textureSlot"..i]:Point(Slot.Direction, Slot["textureSlot"..(i-1)], Slot.Direction == "LEFT" and "RIGHT" or "LEFT", 0,0) end
			end
			Armory.Constants.CA_Defaults[SlotName]["enchantText"] = { Slot.enchantText:GetPoint() }
		end
		if SlotName == "NeckSlot" then
			Armory.Constants.CA_Defaults[SlotName]["RankFrame"] = { Slot.RankFrame:GetPoint() }
		end
	end
end

--Updates the frame
function Armory:UpdatePageInfo(frame, which, guid, event)
	local window = T.lower(which)
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot.TransmogInfo then
			if E.db.sle.armory[window].enable and C_Transmog_GetSlotInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE) then
				Slot.TransmogInfo.Link = T.select(6, C_TransmogCollection_GetAppearanceSourceInfo(T.select(3, C_Transmog_GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE))));
				if E.db.sle.armory[window].transmog.enableArrow then Slot.TransmogInfo:Show() else Slot.TransmogInfo:Hide() end
				if E.db.sle.armory[window].transmog.enableGlow then
					LCG.AutoCastGlow_Start(Slot,{1, .5, 1, 1},E.db.sle.armory[window].transmog.glowNumber,0.25,1,E.db.sle.armory[window].transmog.glowOffset,E.db.sle.armory[window].transmog.glowOffset,"_TransmogGlow")
				else
					LCG.AutoCastGlow_Stop(Slot,"_TransmogGlow")
				end
			else
				Slot.TransmogInfo:Hide()
				LCG.AutoCastGlow_Stop(Slot,"_TransmogGlow")
			end
		end
		Armory:UpdateGemInfo(Slot, which)
	end
end

--Updates ilvl and everything tied to the item somehow
function Armory:UpdatePageStrings(i, iLevelDB, Slot, iLvl, enchant, gems, essences, enchantColors, itemLevelColors, which)
	if itemLevelColors then
		which = T.lower(which) --to know which settings table to use
		if E.db.sle.armory[which] and E.db.sle.armory[which].enable then --If settings table actually exists and armory for it is enabled
			if E.db.sle.armory[which].ilvl.colorType == "QUALITY" then
				Slot.iLvlText:SetTextColor(unpack(itemLevelColors)) --Busyness as usual
			elseif E.db.sle.armory[which].ilvl.colorType == "GRADIENT" then
				local equippedIlvl = which == "character" and T.select(2, T.GetAverageItemLevel()) or E:CalculateAverageItemLevel(iLevelDB, _G["inspectFrame"].unit)
				local diff = iLvl - equippedIlvl
				local aR, aG, aB
				if diff >= 0 then
					aR, aG, aB = 0,1,0
				else
					aR, aG, aB = E:ColorGradient(-(3/diff), 1, 0, 0, 1, 1, 0, 0, 1, 0)
				end
				Slot.iLvlText:SetTextColor(aR, aG, aB)
			else
				Slot.iLvlText:SetTextColor(1, 1, 1)
			end
		else
			Slot.iLvlText:SetTextColor(unpack(itemLevelColors))
		end
		if Slot.SLE_Gradient then --Probably not actually neccesary, but just in case
			if E.db.sle.armory[which].enable and E.db.sle.armory[which].gradient.enable and iLvl then
				Slot.SLE_Gradient:Show()
				if E.db.sle.armory[which].gradient.quality then Slot.SLE_Gradient:SetVertexColor(unpack(itemLevelColors)) else Slot.SLE_Gradient:SetVertexColor(T.unpack(E.db.sle.armory[which].gradient.color)) end
			else
				Slot.SLE_Gradient:Hide()
			end
		end
	else
		if Slot.SLE_Gradient then Slot.SLE_Gradient:Hide() end
	end
end

---Store gem info in our hidden frame
function Armory:UpdateGemInfo(Slot, which)
	local itemLink = T.GetInventoryItemLink(which == "Character" and "player" or frame.unit, Slot.ID)
	if itemLink then
		for i = 1, 3 do
			local GemLink = T.select(2, GetItemGem(itemLink, i))
			Slot["SLE_Gem"..i].Link = GemLink
		end
	end
end

---<<<Global Hide tooltip func for armory>>>---
function Armory:Tooltip_OnLeave()
	_G["GameTooltip"]:Hide()
end

---<<<Show Gem on mouse over>>>---
function Armory:Gem_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Link then --Only do stuff if armory is enabled or the gem is present
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		_G["GameTooltip"]:SetHyperlink(self.Link)
		_G["GameTooltip"]:Show()
	end
end

--<<<<<Transmog functions>>>>>--
function Armory:Transmog_OnEnter()
	self.Texture:SetVertexColor(1, .8, 1)

	_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	_G["GameTooltip"]:SetHyperlink(self.Link)
	_G["GameTooltip"]:Show()
end

function Armory:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)
	_G["GameTooltip"]:Hide()
end

function Armory:Transmog_OnClick(button)
	local ItemName, ItemLink = T.GetItemInfo(self.Link)
	
	if not IsShiftKeyDown() then
		T.SetItemRef(ItemLink, ItemLink, 'LeftButton')
	else
		if HandleModifiedItemClick(ItemLink) then
		elseif _G["BrowseName"] and _G["BrowseName"]:IsVisible() then
			AuctionFrameBrowse_Reset(_G["BrowseResetButton"])
			_G["BrowseName"]:SetText(ItemName)
			_G["BrowseName"]:SetFocus()
		end
	end
end

function Armory:Initialize()
	-- for i = 1, #KF.Modules do
		-- KF.Modules[(KF.Modules[i])]()
	-- end
	Armory:BuildCharacterDefaultsCache()
	SLE:GetModule("Armory_Character"):LoadAndSetup()

	local M = E:GetModule("Misc")
	hooksecurefunc(M, "UpdatePageInfo", Armory.UpdatePageInfo)
	hooksecurefunc(M, "UpdatePageStrings", Armory.UpdatePageStrings)

	function Armory:ForUpdateAll()
		-- _G["CharacterArmory"]:UpdateSettings("all")
		-- if not SLE._Compatibility["DejaCharacterStats"] then
			-- _G["CharacterArmory"]:ToggleStats()
			-- _G["CharacterArmory"]:UpdateIlvlFont()
		-- end
		-- _G["InspectArmory"]:UpdateSettings("all")
	end
end

SLE:RegisterModule(Armory:GetName())
