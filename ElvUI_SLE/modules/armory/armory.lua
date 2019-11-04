local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if T.select(2, GetAddOnInfo("ElvUI_KnightFrame")) and IsAddOnLoaded("ElvUI_KnightFrame") then return end --Don't break korean code :D
local Armory = SLE:NewModule("Armory_Core", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local LCG = LibStub('LibCustomGlow-1.0')
local CA, IA, SA

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
if not SLE_ArmoryDB or T.type(SLE_ArmoryDB) ~= "table" then
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
	["HeadSlot"] = true,
	["ShoulderSlot"] = true,
	["BackSlot"] = true,
	["ChestSlot"] = true,
	["WristSlot"] = true,
	["HandsSlot"] = true,
	["WaistSlot"] = true,
	["LegsSlot"] = true,
	["FeetSlot"] = true,
	["MainHandSlot"] = true,
	["SecondaryHandSlot"] = true
}
Armory.Constants.EnchantableSlots = {
	["Finger0Slot"] = true, ["Finger1Slot"] = true, ["MainHandSlot"] = true, ["SecondaryHandSlot"] = true,
}

Armory.Constants.AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1}
Armory.Constants.Character_Defaults_Cached = false
Armory.Constants.Inspect_Defaults_Cached = false
Armory.Constants.Character_Defaults = {}
Armory.Constants.Inspect_Defaults = {}
-- Armory.Constants.WarningTexture = [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Warning-Small]]
Armory.Constants.WarningTexture = [[Interface\AddOns\ElvUI\Media\Textures\Minimalist]]
Armory.Constants.GradientTexture = [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Gradation]]
Armory.Constants.TransmogTexture = [[Interface\AddOns\ElvUI_SLE\media\textures\armory\anchor]]
Armory.Constants.MaxGemSlots = 5

--Remembering default positions of stuff
function Armory:BuildFrameDefaultsCache(which)
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		Armory.Constants[which.."_Defaults"][SlotName] = {}
		local Slot = _G[which..SlotName]
		Slot.Direction = i%2 == 1 and "LEFT" or "RIGHT"
		if Slot.iLvlText then
			Armory.Constants[which.."_Defaults"][SlotName]["iLvlText"] = { Slot.iLvlText:GetPoint() } 
			Armory.Constants[which.."_Defaults"][SlotName]["textureSlot1"] = { Slot.textureSlot1:GetPoint() }
			for i = 2, 10 do
				if Slot["textureSlot"..i] then Slot["textureSlot"..i]:ClearAllPoints(); Slot["textureSlot"..i]:Point(Slot.Direction, Slot["textureSlot"..(i-1)], Slot.Direction == "LEFT" and "RIGHT" or "LEFT", 0,0) end
			end
			Armory.Constants[which.."_Defaults"][SlotName]["enchantText"] = { Slot.enchantText:GetPoint() }
		end
		if SlotName == "NeckSlot" and Slot.RankFrame then
			Armory.Constants[which.."_Defaults"][SlotName]["RankFrame"] = { Slot.RankFrame:GetPoint() }
		end
	end
	Armory.Constants[which.."_Defaults_Cached"] = true
end

--Updates the frame
function Armory:UpdatePageInfo(frame, which, guid, event)
	if not (frame and which) then return end
	local window = T.lower(which)
	local unit = (which == 'Character' and 'player') or frame.unit
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot then
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
		end
	end
	if which == "Character" then CA:Update_Durability() end
	Armory:UpdateSharedStringsFonts(which)
end

--Updates ilvl and everything tied to the item somehow
-- M:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which) -- `which` is used by plugins
function Armory:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which) -- `which` is used by plugins
-- function Armory:UpdatePageStrings(i, iLevelDB, Slot, iLvl, enchant, gems, essences, enchantColors, itemLevelColors, which, fullEnchantText)
	if slotInfo.itemLevelColors then
		local window = T.lower(which) --to know which settings table to use
		if E.db.sle.armory[window] and E.db.sle.armory[window].enable then --If settings table actually exists and armory for it is enabled
			if Slot.enchantText and not (slotInfo.enchantTextShort == nil or slotInfo.enchantText == nil) then Armory:ProcessEnchant(window, Slot, slotInfo.enchantTextShort, slotInfo.enchantText) end
			if E.db.sle.armory[window].ilvl.colorType == "QUALITY" then
				Slot.iLvlText:SetTextColor(T.unpack(slotInfo.itemLevelColors)) --Busyness as usual
			elseif E.db.sle.armory[window].ilvl.colorType == "GRADIENT" then
				local equippedIlvl = window == "character" and T.select(2, T.GetAverageItemLevel()) or E:CalculateAverageItemLevel(iLevelDB, _G["InspectFrame"].unit)
				local diff = slotInfo.iLvl - equippedIlvl
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
			Slot.iLvlText:SetTextColor(T.unpack(slotInfo.itemLevelColors))
		end
		--This block is separate cause disabling armory will not hide dem gradients otherwise
		if Slot.SLE_Gradient then --First call for this function for inspect is before gradient is created. To avoid errors
			if E.db.sle.armory[window].enable and E.db.sle.armory[window].gradient.enable and slotInfo.iLvl then
				Slot.SLE_Gradient:Show()
				if E.db.sle.armory[window].gradient.quality then Slot.SLE_Gradient:SetVertexColor(T.unpack(slotInfo.itemLevelColors)) else Slot.SLE_Gradient:SetVertexColor(T.unpack(E.db.sle.armory[window].gradient.color)) end
			else
				Slot.SLE_Gradient:Hide()
			end
		end
	else
		if Slot.SLE_Gradient then Slot.SLE_Gradient:Hide() end
	end
	--If put inside "if slotInfo.itemLevelColors" condition will not actually hide gem links/warnings on empty slots
	Armory:UpdateGemInfo(Slot, which)
	Armory:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.essences, slotInfo.enchantTextShort)
	CA:Calculate_Durability(which, Slot)
end

---Store gem info in our hidden frame
function Armory:UpdateGemInfo(Slot, which)
	local unit = which == "Character" and "player" or (_G["InspectFrame"] and _G["InspectFrame"].unit)
	if not unit then return end
	local itemLink = T.GetInventoryItemLink(unit, Slot.ID)
	for i = 1, Armory.Constants.MaxGemSlots do
		local GemLink
		if not Slot["SLE_Gem"..i] then return end
		if itemLink then
			if Slot.ID == 2 then
				local window = T.lower(which)
				-- inspectItem["textureSlotBackdrop"..x]
				if E.db.sle.armory[window] and E.db.sle.armory[window].enable then
					if which == "Character" and Slot["textureSlotEssenceType"..i] then
						Slot["textureSlotEssenceType"..i]:Hide()
					elseif which == "Inspect" and Slot["textureSlotBackdrop"..i] then
						Slot["textureSlotBackdrop"..i]:Hide()
					end
				end
				if which == "Character" then
					GemID = C_AzeriteEssence.GetMilestoneEssence(i+114) --Milestones are starting with 115, thus 114 + milestone
					if GemID then
						local rank = C_AzeriteEssence.GetEssenceInfo(GemID).rank
						GemLink = C_AzeriteEssence.GetEssenceHyperlink(GemID, rank)
					end
				end
			else
				GemLink = T.select(2, GetItemGem(itemLink, i))
			end
		end
		Slot["SLE_Gem"..i].Link = GemLink
	end
end

function Armory:UpdateSharedStringsFonts(which)
	local window = T.lower(which)
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot.iLvlText then
			local fontIlvl, sizeIlvl, outlineIlvl, fontEnch, sizeEnch, outlineEnch
			if E.db.sle.armory[window].enable then
				fontIlvl, sizeIlvl, outlineIlvl = E.db.sle.armory[window].ilvl.font, E.db.sle.armory[window].ilvl.fontSize, E.db.sle.armory[window].ilvl.fontStyle
				fontEnch, sizeEnch, outlineEnch = E.db.sle.armory[window].enchant.font, E.db.sle.armory[window].enchant.fontSize, E.db.sle.armory[window].enchant.fontStyle
			else
				fontIlvl, sizeIlvl, outlineIlvl = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or "OUTLINE"
				fontEnch, sizeEnch, outlineEnch = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or "OUTLINE"
			end
			Slot.iLvlText:FontTemplate(E.LSM:Fetch('font', fontIlvl), sizeIlvl, outlineIlvl)
			Slot.enchantText:FontTemplate(E.LSM:Fetch('font', fontEnch), sizeEnch, outlineEnch)
		end
	end
end

--Deals with dem enchants
function Armory:ProcessEnchant(which, Slot, enchantTextShort, enchantText)
	if not E.db.sle.armory.enchantString.enable then return end
	-- if E.db.sle.armory.enchantString.fullText then
		if E.db.sle.armory.enchantString.replacement then
			for enchString, enchData in T.pairs(SLE_ArmoryDB.EnchantString) do
				if enchData.original and enchData.new then
					enchantText = T.gsub(enchantText, enchData.original, enchData.new)
				end
			end
		end
		Slot.enchantText:SetText(enchantText)
	-- end
end

---<<<Global Hide tooltip func for armory>>>---
function Armory:Tooltip_OnLeave()
	_G["GameTooltip"]:Hide()
end

---<<<Show Gem on mouse over>>>---
function Armory:Gem_OnEnter()
	-- print(self.Link)
	if E.db.sle.armory[self.frame].enable and self.Link then --Only do stuff if armory is enabled or the gem is present
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		_G["GameTooltip"]:SetHyperlink(self.Link)
		_G["GameTooltip"]:Show()
	end
end

---<<<Show what the fuck is wrong with this item>>>---
function Armory:Warning_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Reason then --Only do stuff if armory is enabled and something is actually missing
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		_G["GameTooltip"]:AddLine(self.Reason, 1, 1, 1)
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

function Armory:CheckForMissing(which, Slot, iLvl, gems, essences, enchant)
	if not Slot["SLE_Warning"] then return end --Shit happens
	Slot["SLE_Warning"].Reason = nil --Clear message, cause disabling armory doesn't affect those otherwise
	local window = T.lower(which)
	if not (E.db.sle.armory[window] and E.db.sle.armory[window].enable and E.db.sle.armory[window].showWarning) then Slot["SLE_Warning"]:Hide(); return end --if something is disdbled
	local SlotName = T.gsub(Slot:GetName(), which, "")
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false
	if iLvl and Armory.Constants.EnchantableSlots[SlotName] and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local itemLink = T.GetInventoryItemLink(which == "Character" and "player" or _G["InspectFrame"].unit, Slot.ID)
		local classID, subclassID = T.select(12, GetItemInfo(itemLink))
		if classID == 4 and subclassID == 6 then --Shields are special
			noChant = false
		else
			noChant = true
		end
	end 
	if gems and not Slot.ID ~= 2 then --If gems found and not neck
		for i = 1, Armory.Constants.MaxGemSlots do
			local texture = Slot["textureSlot"..i]
			if (texture and texture:GetTexture()) and (Slot["SLE_Gem"..i] and not Slot["SLE_Gem"..i].Link) then noGem = true; break end --If there is a texture (e.g. actual slot), but no link = no gem installed
		end
	end
	if (noChant or noGem) then --If anything us missing
		local message = ""
		if noGem then message = message.."|cffff0000"..L["Empty Socket"].."|r\n" end
		if noChant then message = message.."|cffff0000"..L["Not Enchanted"].."|r\n" end
		Slot["SLE_Warning"].Reason = message or nil
		Slot["SLE_Warning"]:Show()
	else
		Slot["SLE_Warning"]:Hide()
	end
end

--Actually only needed only on first load of inspect frame, cause I can't alter shit on the rame that doesn't exist yet
function Armory:UpdateInspectInfo()
	if not Armory.Constants.Inspect_Defaults_Cached then
		Armory:BuildFrameDefaultsCache("Inspect")
		IA:LoadAndSetup()
	end
end

function Armory:Initialize()
	Armory:BuildFrameDefaultsCache("Character")

	--May be usefull later
	Armory.ScanTT = CreateFrame('GameTooltip', 'SLE_Armory_ScanTT', nil, 'GameTooltipTemplate')
	Armory.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')

	CA = SLE:GetModule("Armory_Character")
	IA = SLE:GetModule("Armory_Inspect")
	SA = SLE:GetModule("Armory_Stats")

	CA:LoadAndSetup()
	SA:LoadAndSetup()

	local M = E:GetModule("Misc")
	hooksecurefunc(M, "UpdateInspectInfo", Armory.UpdateInspectInfo)
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
