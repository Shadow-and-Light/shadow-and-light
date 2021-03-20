local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Armory = SLE:NewModule('Armory_Core', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0');
local M = E:GetModule('Misc')
local LCG = LibStub('LibCustomGlow-1.0')

local GetAverageItemLevel = GetAverageItemLevel
local TRANSMOGRIFIED_HEADER = TRANSMOGRIFIED_HEADER
local C_Transmog_GetSlotInfo = C_Transmog.GetSlotInfo
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo
local C_TransmogCollection_GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo
local HandleModifiedItemClick = HandleModifiedItemClick
local C_TransmogCollection_GetInspectSources = C_TransmogCollection.GetInspectSources
local GetSpecialization, GetSpecializationInfo, GetInspectSpecialization = GetSpecialization, GetSpecializationInfo, GetInspectSpecialization
local InCombatLockdown = InCombatLockdown
local CA, IA, SA
Armory.Constants = {}

--Create ench replacement string DB
if not SLE_ArmoryDB or type(SLE_ArmoryDB) ~= 'table' then
	SLE_ArmoryDB = {
		EnchantString = {}
	}
end

Armory.Constants.GearList = {
	'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
	'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
}
Armory.Constants.AzeriteSlot = {
	'HeadSlot', 'ShoulderSlot', 'ChestSlot',
}
Armory.Constants.CanTransmogrify = {
	['HeadSlot'] = true,
	['ShoulderSlot'] = true,
	['BackSlot'] = true,
	['ChestSlot'] = true,
	['TabardSlot'] = true,
	['WristSlot'] = true,
	['HandsSlot'] = true,
	['WaistSlot'] = true,
	['LegsSlot'] = true,
	['FeetSlot'] = true,
	['MainHandSlot'] = true,
	['SecondaryHandSlot'] = true
}

Armory.Constants.EnchantableSlots = {
	['Finger0Slot'] = true, ['Finger1Slot'] = true, ['MainHandSlot'] = true, ['SecondaryHandSlot'] = true,
	--Uncomment this when shadowlands actually launches
	['ChestSlot'] = true, ['BackSlot'] = true,
	['FeetSlot'] = 2, ['WristSlot'] = 4, ['HandsSlot'] = 1,
}
Armory.Constants.SpecPrimaryStats = {
	[250] = 1, --DK Blood
	[251] = 1, --DK Frost
	[252] = 1, --DK Unholy
	[577] = 2, --DH Havoc
	[581] = 2, --DH Vengeance
	[102] = 4, --Druid Balance
	[103] = 2, --Druid Feral
	[104] = 2, --Druid Guardian
	[105] = 4, --Druid Restoration
	[253] = 2, --Hunter Beast Mastery
	[254] = 2, --Hunter Marksmanship
	[255] = 2, --Hunter Survival
	[62] = 4, --Mage Arcane
	[63] = 4, --Mage Fire
	[64] = 4, --Mage Frost
	[268] = 2, --Monk Brewmaster
	[270] = 4, --Monk Mistweaver
	[269] = 2, --Monk Windwalker
	[65] = 4, --Paladin Holy
	[66] = 1, --Paladin Protection
	[70] = 1, --Paladin Retribution
	[256] = 4, --Priest Discipline
	[257] = 4, --Priest Holy
	[258] = 4, --Priest Shadow
	[259] = 2, --Rogue Assassination
	[260] = 2, --Rogue Outlaw
	[261] = 2, --Rogue Subtlety
	[262] = 4, --Shaman Elemental
	[263] = 2, --Shaman Enhancement
	[264] = 4, --Shaman Restoration
	[265] = 4, --Warlock Affliction
	[266] = 4, --Warlock Demonology
	[267] = 4, --Warlock Destruction
	[71] = 1, --Warrior Arms
	[72] = 1, --Warrior Fury
	[73] = 1, --Warrior Protection
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
Armory.Constants.EssenceMilestones = {}
Armory.Constants.Stats = {
	ScrollStepMultiplier = 5,
}

--Remembering default positions of stuff
function Armory:BuildFrameDefaultsCache(which)
	for i, SlotName in pairs(Armory.Constants.GearList) do
		Armory.Constants[which..'_Defaults'][SlotName] = {}
		local Slot = _G[which..SlotName]
		if not Slot then E:Delay(1, function() Armory:BuildFrameDefaultsCache(which) end); return end
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		if Slot.iLvlText then
			Armory.Constants[which..'_Defaults'][SlotName]['iLvlText'] = { Slot.iLvlText:GetPoint() }
			Armory.Constants[which..'_Defaults'][SlotName]['textureSlot1'] = { Slot.textureSlot1:GetPoint() }
			for i = 2, 10 do
				if Slot['textureSlot'..i] then Slot['textureSlot'..i]:ClearAllPoints(); Slot['textureSlot'..i]:Point(Slot.Direction, Slot['textureSlot'..(i-1)], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', E.twoPixelsPlease and 3 or 1, 0) end
			end
			Armory.Constants[which..'_Defaults'][SlotName]['enchantText'] = { Slot.enchantText:GetPoint() }
		end
		if SlotName == 'NeckSlot' and Slot.RankFrame then
			Armory.Constants[which..'_Defaults'][SlotName]['RankFrame'] = { Slot.RankFrame:GetPoint() }
		end
	end
	Armory.Constants[which..'_Defaults_Cached'] = true
end

function Armory:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()

	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end

function Armory:GetTransmogInfo(Slot, which, unit)
	if not which or not unit then return nil end

	local transmogLink, TooltipText
	Armory:ClearTooltip(Armory.ScanTT)
	Armory.ScanTT:SetInventoryItem(unit, Slot.ID)

	for i = 1, Armory.ScanTT:NumLines() do
		TooltipText = _G['SLE_Armory_ScanTTTextLeft'..i]:GetText()

		if TooltipText and TooltipText:match(TRANSMOGRIFIED_HEADER) then
			transmogLink = _G['SLE_Armory_ScanTTTextLeft'..(i + 1)]:GetText()
			Armory:ClearTooltip(Armory.ScanTT)
		end
	end

	if not transmogLink then return nil end

	local appearenceIDs = C_TransmogCollection_GetInspectSources()
	local mogLink
	if appearenceIDs then
		for i = 1, #appearenceIDs do
			if (appearenceIDs[i] and appearenceIDs[i] ~= NO_TRANSMOG_SOURCE_ID) then
				if i == Slot.ID then
					mogLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(appearenceIDs[i]))
					return mogLink
				end
			end
		end
	end
end

--Updates the frame
function Armory:UpdatePageInfo(frame, which, guid, event)
	if not (frame and which) then return end
	if not Armory:CheckOptions(which) then return end
	local window = strlower(which)
	local unit = (which == 'Character' and 'player') or frame.unit
	if which == 'Character' then
		CA:Update_Durability()
		Armory.CharacterPrimaryStat = select(6, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex('player')))
	else
		Armory.InspectPrimaryStat = Armory.Constants.SpecPrimaryStats[GetInspectSpecialization(unit)]
	end
	for i, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot then
			if Slot.TransmogInfo then
				if which == 'Character' then
					local transmogLocation = TransmogUtil.GetTransmogLocation(Slot.ID, Enum.TransmogType.Appearance, Enum.TransmogModification.None)
					if not transmogLocation then return end

					local itemBaseSourceID = select(3, C_Transmog_GetSlotVisualInfo(transmogLocation))
					if not itemBaseSourceID then return end

					Slot.TransmogInfo.Link = select(6, C_TransmogCollection_GetAppearanceSourceInfo(itemBaseSourceID))
				elseif which == 'Inspect' then
					Slot.TransmogInfo.Link = Armory:GetTransmogInfo(Slot, which, unit)
				else
					return
				end
				if E.db.sle.armory[window].enable and Slot.TransmogInfo.Link then
					if E.db.sle.armory[window].transmog.enableArrow then Slot.TransmogInfo:Show() else Slot.TransmogInfo:Hide() end
					if E.db.sle.armory[window].transmog.enableGlow then
						LCG.AutoCastGlow_Start(Slot,{1, .5, 1, 1},E.db.sle.armory[window].transmog.glowNumber,0.25,1,E.db.sle.armory[window].transmog.glowOffset,E.db.sle.armory[window].transmog.glowOffset,'_TransmogGlow')
					else
						LCG.AutoCastGlow_Stop(Slot,'_TransmogGlow')
					end
				else
					Slot.TransmogInfo.Link = nil
					Slot.TransmogInfo:Hide()
					LCG.AutoCastGlow_Stop(Slot,'_TransmogGlow')
				end
			end
		end
	end

end

--Updates ilvl and everything tied to the item somehow
function Armory:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which)
	if not Armory:CheckOptions(which) then return end
	Slot.itemLink = GetInventoryItemLink((which == 'Character' and 'player') or _G['InspectFrame'].unit, Slot.ID)
	if slotInfo.itemLevelColors then
		local window = strlower(which) --to know which settings table to use
		if E.db.sle.armory[window] and E.db.sle.armory[window].enable then --If settings table actually exists and armory for it is enabled
			if Slot.enchantText and not (slotInfo.enchantTextShort == nil or slotInfo.enchantText == nil) then Armory:ProcessEnchant(window, Slot, slotInfo.enchantTextShort, slotInfo.enchantText) end
			if E.db.sle.armory[window].ilvl.colorType == 'QUALITY' then
				Slot.iLvlText:SetTextColor(unpack(slotInfo.itemLevelColors)) --Busyness as usual
			elseif E.db.sle.armory[window].ilvl.colorType == 'GRADIENT' then
				local equippedIlvl = window == 'character' and select(2, GetAverageItemLevel()) or E:CalculateAverageItemLevel(iLevelDB, _G['InspectFrame'].unit)
				local diff
				if slotInfo.iLvl and (equippedIlvl and type(equippedIlvl) ~= 'boolean') then
					diff = slotInfo.iLvl - equippedIlvl
				else
					diff = 0
				end
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
			Slot.iLvlText:SetTextColor(unpack(slotInfo.itemLevelColors))
		end
		--This block is separate cause disabling armory will not hide dem gradients otherwise
		if Slot.SLE_Gradient then --First call for this function for inspect is before gradient is created. To avoid errors
			if E.db.sle.armory[window].enable and E.db.sle.armory[window].gradient.enable and slotInfo.iLvl then
				Slot.SLE_Gradient:Show()
				if E.db.sle.armory[window].gradient.quality then Slot.SLE_Gradient:SetVertexColor(unpack(slotInfo.itemLevelColors)) else Slot.SLE_Gradient:SetVertexColor(unpack(E.db.sle.armory[window].gradient.color)) end
			else
				Slot.SLE_Gradient:Hide()
			end
		end
	else
		if Slot.SLE_Gradient then Slot.SLE_Gradient:Hide() end
	end
	--If put inside "if slotInfo.itemLevelColors" condition will not actually hide gem links/warnings on empty slots
	Armory:UpdateGemInfo(Slot, which)
	Armory:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.essences, slotInfo.enchantTextShort, Armory[which.."PrimaryStat"])
	if CA.DurabilityFontSet then CA:Calculate_Durability(which, Slot) end
end

---Store gem info in our hidden frame
function Armory:UpdateGemInfo(Slot, which)
	local unit = which == 'Character' and 'player' or (_G['InspectFrame'] and _G['InspectFrame'].unit)
	if not unit then return end
	for i = 1, Armory.Constants.MaxGemSlots do
		local GemLink
		if not Slot['SLE_Gem'..i] then return end
		if Slot.itemLink then
			if Slot.ID == 2 then
				if not CA.HearthMilestonesCached then CA:FixFuckingBlizzardLogic() end
				local window = strlower(which)
				if E.db.sle.armory[window] and E.db.sle.armory[window].enable then
					if which == 'Character' and Slot['textureSlotEssenceType'..i] then
						Slot['textureSlotEssenceType'..i]:Hide()
					elseif which == 'Inspect' and Slot['textureSlotBackdrop'..i] then
						Slot['textureSlotBackdrop'..i]:Hide()
					end
				end
				if which == 'Character' and Armory.Constants.EssenceMilestones[i] then
					local GemID = C_AzeriteEssence.GetMilestoneEssence(Armory.Constants.EssenceMilestones[i]) --Blizz messed up milestones IDs so using a god damned cache table
					if GemID then
						local rank = C_AzeriteEssence.GetEssenceInfo(GemID).rank
						GemLink = C_AzeriteEssence.GetEssenceHyperlink(GemID, rank)
					end
				end
			else
				GemLink = select(2, GetItemGem(Slot.itemLink, i))
			end
		end
		Slot['SLE_Gem'..i].Link = GemLink
	end
end

function Armory:CreateSlotStrings(_, which)
	Armory:UpdateSharedStringsFonts(which)
end

function Armory:UpdateSharedStringsFonts(which)
	local window = strlower(which)
	for i, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if not Slot then return end
		if Slot.iLvlText then
			local fontIlvl, sizeIlvl, outlineIlvl, fontEnch, sizeEnch, outlineEnch
			if E.db.sle.armory[window].enable then
				fontIlvl, sizeIlvl, outlineIlvl = E.db.sle.armory[window].ilvl.font, E.db.sle.armory[window].ilvl.fontSize, E.db.sle.armory[window].ilvl.fontStyle
				fontEnch, sizeEnch, outlineEnch = E.db.sle.armory[window].enchant.font, E.db.sle.armory[window].enchant.fontSize, E.db.sle.armory[window].enchant.fontStyle
			else
				fontIlvl, sizeIlvl, outlineIlvl = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or 'OUTLINE'
				fontEnch, sizeEnch, outlineEnch = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or 'OUTLINE'
			end
			Slot.iLvlText:FontTemplate(E.LSM:Fetch('font', fontIlvl), sizeIlvl, outlineIlvl)
			Slot.enchantText:FontTemplate(E.LSM:Fetch('font', fontEnch), sizeEnch, outlineEnch)
		end
	end
end

--Deals with dem enchants
function Armory:ProcessEnchant(which, Slot, enchantTextShort, enchantText)
	if not E.db.sle.armory.enchantString.enable then return end
	local strict = E.db.sle.armory.enchantString.strict

	if E.db.sle.armory.enchantString.replacement then
		for _, enchData in pairs(SLE_ArmoryDB.EnchantString) do
			if strict and enchantText == enchData.original then
				enchantText = enchData.new
			elseif not strict and enchData.original and enchData.new then
				enchantText = gsub(enchantText, E:EscapeString(enchData.original), enchData.new)
			end
		end
	end
	Slot.enchantText:SetText(enchantText)
end

---<<<Global Hide tooltip func for armory>>>---
function Armory:Tooltip_OnLeave()
	_G['GameTooltip']:Hide()
end

---<<<Show Gem on mouse over>>>---
function Armory:Gem_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Link then --Only do stuff if armory is enabled or the gem is present
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:SetHyperlink(self.Link)
		_G['GameTooltip']:Show()
	end
end

---<<<Show what the fuck is wrong with this item>>>---
function Armory:Warning_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Reason then --Only do stuff if armory is enabled and something is actually missing
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:AddLine(self.Reason, 1, 1, 1)
		_G['GameTooltip']:Show()
	end
end

--<<<<<Transmog functions>>>>>--
function Armory:Transmog_OnEnter()
	if not self.Link then return end

	self.Texture:SetVertexColor(1, .8, 1)
	_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')

	if self.isInspect then
		local inspectLink = select(2, GetItemInfo(self.Link)) --In case the client actually decides to give us the info
		if inspectLink then
			_G['GameTooltip']:SetHyperlink(inspectLink)
		else
			_G['GameTooltip']:SetText(self.Link)
		end
	else
		_G['GameTooltip']:SetHyperlink(self.Link)
	end

	_G['GameTooltip']:Show()
end

function Armory:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)
	_G['GameTooltip']:Hide()
end

function Armory:Transmog_OnClick()
	local ItemName, ItemLink = GetItemInfo(self.Link)

	if not IsShiftKeyDown() then
		SetItemRef(ItemLink, ItemLink, 'LeftButton')
	else
		HandleModifiedItemClick(ItemLink)
	-- 	if HandleModifiedItemClick(ItemLink) then
	-- 		print('test')
	-- 	elseif _G.BrowseName and _G.BrowseName:IsVisible() then
	-- 		print('test2')
	-- 		AuctionFrameBrowse_Reset(_G.BrowseResetButton)
	-- 		_G.BrowseName:SetText(ItemName)
	-- 		_G.BrowseName:SetFocus()
	-- 	end
	end
end

function Armory:CheckForMissing(which, Slot, iLvl, gems, essences, enchant, primaryStat)
	if not Slot['SLE_Warning'] then return end --Shit happens
	Slot['SLE_Warning'].Reason = nil --Clear message, cause disabling armory doesn't affect those otherwise
	local window = strlower(which)
	if not (E.db.sle.armory[window] and E.db.sle.armory[window].enable and E.db.sle.armory[window].showWarning) then Slot['SLE_Warning']:Hide(); return end --if something is disdbled
	local SlotName = gsub(Slot:GetName(), which, '')
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false
	if iLvl and (Armory.Constants.EnchantableSlots[SlotName] == true or Armory.Constants.EnchantableSlots[SlotName] == primaryStat) and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local classID, subclassID = select(12, GetItemInfo(Slot.itemLink))
		if (classID == 4 and subclassID == 6) or (classID == 4 and subclassID == 0 and Slot.ID == 17) then --Shields are special
			noChant = false
		else
			noChant = true
		end
	end
	if gems and Slot.ID ~= 2 then --If gems found and not neck
		for i = 1, Armory.Constants.MaxGemSlots do
			local texture = Slot['textureSlot'..i]
			if (texture and texture:GetTexture()) and (Slot['SLE_Gem'..i] and not Slot['SLE_Gem'..i].Link) then noGem = true; break end --If there is a texture (e.g. actual slot), but no link = no gem installed
		end
	end
	if (noChant or noGem) then --If anything us missing
		local message = ''
		if noGem then message = message..'|cffff0000'..L["Empty Socket"]..'|r\n' end
		if noChant then message = message..'|cffff0000'..L["Not Enchanted"]..'|r\n' end
		Slot['SLE_Warning'].Reason = message or nil
		Slot['SLE_Warning']:Show()
		if Slot.SLE_Gradient then Slot.SLE_Gradient:SetVertexColor(1, 0, 0) end
	else
		Slot['SLE_Warning']:Hide()
	end
end

function Armory:UpdateInspectInfo()
	if not _G['InspectFrame'] then return end --In case update for frame is called before it is actually created
	if not Armory.Constants.Inspect_Defaults_Cached then
		Armory:BuildFrameDefaultsCache('Inspect')
		IA:LoadAndSetup()
	end
	if E.db.sle.armory.inspect.enable then M:UpdatePageInfo(_G['InspectFrame'], 'Inspect') end
	if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G['InspectFrame'], 'Inspect') end
end

function Armory:UpdateCharacterInfo(event)
	if event == 'CRITERIA_UPDATE' and InCombatLockdown() then return end

	if E.db.sle.armory.character.enable then
		M:UpdatePageInfo(_G['CharacterFrame'], 'Character')
	end
	if not E.db.general.itemLevel.displayCharacterInfo then
		M:ClearPageInfo(_G['CharacterFrame'], 'Character')
	end
end

function Armory:ToggleItemLevelInfo()
	if E.db.general.itemLevel.displayCharacterInfo then
		-- Armory:UnregisterEvent('AZERITE_ESSENCE_UPDATE')
		Armory:UnregisterEvent('CRITERIA_UPDATE')
		Armory:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
		Armory:UnregisterEvent('UPDATE_INVENTORY_DURABILITY')
		-- Armory:UnregisterEvent('PLAYER_AVG_ITEM_LEVEL_UPDATE')
	else
		-- Armory:RegisterEvent('AZERITE_ESSENCE_UPDATE', 'UpdateCharacterInfo')
		Armory:RegisterEvent('CRITERIA_UPDATE', 'UpdateCharacterInfo')
		Armory:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'UpdateCharacterInfo')
		Armory:RegisterEvent('UPDATE_INVENTORY_DURABILITY', 'UpdateCharacterInfo')
		-- Armory:RegisterEvent('PLAYER_AVG_ITEM_LEVEL_UPDATE', 'UpdateCharacterItemLevel')
	end

	if _G['InspectFrame'] and _G['InspectFrame']:IsShown() and Armory:CheckOptions('Inspect') and E.db.general.itemLevel.displayInspectInfo then
		M:UpdateInspectInfo()
	else
		M:ClearPageInfo(_G['InspectFrame'], 'Inspect')
	end
end

function Armory:CheckOptions(which)
	if not E.private.skins.blizzard.enable then return false end
	if (which == 'Character' and not E.private.skins.blizzard.character) or (which == 'Inspect' and not E.private.skins.blizzard.inspect) then return false end
	return true
end

function Armory:Initialize()
	if not Armory:CheckOptions() then return end

	--May be usefull later
	Armory.ScanTT = CreateFrame('GameTooltip', 'SLE_Armory_ScanTT', nil, 'GameTooltipTemplate')
	Armory.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')

	hooksecurefunc(M, 'UpdatePageInfo', Armory.UpdatePageInfo)
	hooksecurefunc(M, 'UpdatePageStrings', Armory.UpdatePageStrings)
	hooksecurefunc(M, 'ToggleItemLevelInfo', Armory.ToggleItemLevelInfo)
	hooksecurefunc(M, 'UpdateInspectPageFonts', Armory.UpdateSharedStringsFonts)
	hooksecurefunc(M, 'CreateSlotStrings', Armory.CreateSlotStrings)

	Armory:ToggleItemLevelInfo()
	if Armory:CheckOptions('Character') then
		CA = SLE:GetModule('Armory_Character')
		SA = SLE:GetModule('Armory_Stats')
		Armory:BuildFrameDefaultsCache('Character')
		hooksecurefunc(M, 'UpdateCharacterInfo', Armory.UpdateCharacterInfo)
		CA:LoadAndSetup()
		SA:LoadAndSetup()
		Armory:UpdateCharacterInfo()
	end

	if Armory:CheckOptions('Inspect') then
		IA = SLE:GetModule('Armory_Inspect')
		hooksecurefunc(M, 'UpdateInspectInfo', Armory.UpdateInspectInfo)
		IA:PreSetup()
	end

	function Armory:ForUpdateAll()
		SLE:GetModule('Armory_Character'):ToggleArmory()
		M:UpdatePageInfo(_G.CharacterFrame, 'Character')
		if not E.db.general.itemLevel.displayCharacterInfo then M:ClearPageInfo(_G.CharacterFrame, 'Character') end

		SLE:GetModule('Armory_Inspect'):ToggleArmory();
		M:UpdatePageInfo(_G.InspectFrame, "Inspect") --Putting this under the elv's option check just breaks the shit out of the frame
		if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G.InspectFrame, "Inspect") end --Clear the infos if those are actually not supposed to be shown.
	end

	_G.CharacterFrame:HookScript('OnShow', function()
		if not E.db.general.itemLevel.displayCharacterInfo then
			M:ClearPageInfo(_G.CharacterFrame, 'Character')
			-- SLE:Print("Charcter Page Hook Done")
		end
	end)

	--Move Pawn buttons. Cause Pawn buttons happen to be overlapped by some shit
	if SLE._Compatibility["Pawn"] then
		PawnUI_InventoryPawnButton:SetFrameLevel(PawnUI_InventoryPawnButton:GetFrameLevel() + 5)
		hooksecurefunc("PawnUI_InventoryPawnButton_Move", function()
			if PawnCommon.ButtonPosition == PawnButtonPositionRight then
				PawnUI_InventoryPawnButton:ClearAllPoints()
				if PaperDollFrame.ExpandButton then --Try not to break Pawn's DCS innate compatibility
					PawnUI_InventoryPawnButton:SetPoint("TOPRIGHT", "CharacterTrinket1Slot", "BOTTOMRIGHT", -31, -8)
				else
					PawnUI_InventoryPawnButton:SetPoint("TOPRIGHT", "CharacterTrinket1Slot", "BOTTOMRIGHT", -1, -8)
				end
			end
		end)
	end
end

SLE:RegisterModule(Armory:GetName())
