local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Armory = SLE.Armory_Core
local M = E.Misc
local LCG = E.Libs.CustomGlow

local GetAverageItemLevel = GetAverageItemLevel
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo
local HandleModifiedItemClick = HandleModifiedItemClick
local C_TransmogCollection_GetInspectItemTransmogInfoList = C_TransmogCollection.GetInspectItemTransmogInfoList
local C_Item_GetItemGem = C_Item.GetItemGem
local C_Item_GetItemInfo = C_Item.GetItemInfo
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
	['BackSlot'] = true,
	['ChestSlot'] = true,
	['LegsSlot'] = true,
	['FeetSlot'] = true,
	['Finger0Slot'] = true,
	['Finger1Slot'] = true,
	['MainHandSlot'] = true,
	['SecondaryHandSlot'] = true,
	['WristSlot'] = true,
}
Armory.Constants.SpecPrimaryStats = {
	[62] = 4,	-- Mage: Arcane
	[63] = 4,	-- Mage: Fire
	[64] = 4,	-- Mage: Frost
	[65] = 4,	-- Paladin: Holy
	[66] = 1,	-- Paladin: Protection
	[70] = 1,	-- Paladin: Retribution
	[71] = 1,	-- Warrior: Arms
	[72] = 1,	-- Warrior: Fury
	[73] = 1,	-- Warrior: Protection
	[102] = 4,	-- Druid: Balance
	[103] = 2,	-- Druid: Feral
	[104] = 2,	-- Druid: Guardian
	[105] = 4,	-- Druid: Restoration
	[250] = 1,	-- Death Knight: Blood
	[251] = 1,	-- Death Knight: Frost
	[252] = 1,	-- Death Knight: Unholy
	[253] = 2,	-- Hunter: Beast Mastery
	[254] = 2,	-- Hunter: Marksmanship
	[255] = 2,	-- Hunter: Survival
	[256] = 4,	-- Priest: Discipline
	[257] = 4,	-- Priest: Holy
	[258] = 4,	-- Priest: Shadow
	[259] = 2,	-- Rogue: Assassination
	[260] = 2,	-- Rogue: Outlaw
	[261] = 2,	-- Rogue: Subtlety
	[262] = 4,	-- Shaman: Elemental
	[263] = 2,	-- Shaman: Enhancement
	[264] = 4,	-- Shaman: Restoration
	[265] = 4,	-- Warlock: Affliction
	[266] = 4,	-- Warlock: Demonology
	[267] = 4,	-- Warlock: Destruction
	[268] = 2,	-- Monk: Brewmaster
	[269] = 2,	-- Monk: Windwalker
	[270] = 4,	-- Monk: Mistweaver
	[577] = 2,	-- DH: Havoc
	[581] = 2,	-- DH: Vengeance
	[1467] = 4,	-- Evoker: Devastation
	[1468] = 4,	-- Evoker: Preservation
	[1473] = 4,	-- Evoker: Augmentation
}

Armory.Constants.AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1}
Armory.Constants.Character_Defaults_Cached = false
Armory.Constants.Inspect_Defaults_Cached = false
Armory.Constants.Character_Defaults = {}
Armory.Constants.Inspect_Defaults = {}
-- Armory.Constants.WarningTexture = [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Warning-Small]]
Armory.Constants.WarningTexture = [[Interface\AddOns\ElvUI\Core\Media\Textures\Minimalist]]
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
			for v = 2, 10 do
				if Slot['textureSlot'..v] then Slot['textureSlot'..v]:ClearAllPoints(); Slot['textureSlot'..v]:Point(Slot.Direction, Slot['textureSlot'..(v-1)], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', E.twoPixelsPlease and 3 or 1, 0) end
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

	local appearenceIDs = {}
	local mogLink
	local data = C_TransmogCollection_GetInspectItemTransmogInfoList()

	if data then
		for slotID, v in ipairs(data) do
			if v.appearanceID and v.appearanceID > 0 then
				appearenceIDs[slotID] = v.appearanceID
			end
		end
	end

	if appearenceIDs then
		if appearenceIDs[Slot.ID] then
			mogLink = select(6, C_TransmogCollection_GetAppearanceSourceInfo(appearenceIDs[Slot.ID]))
			return mogLink
		end
	end
end

--Updates the frame
function Armory:UpdatePageInfo(frame, which)
	if not (frame and which) then return end
	local window = strlower(which)
	if not (E.db.sle.armory[window].enable or Armory:CheckOptions(which)) then return end

	local window = strlower(which)
	local unit = (which == 'Character' and 'player') or frame.unit

	if which == 'Character' then
		CA:Update_Durability()
		Armory.CharacterPrimaryStat = select(6, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex('player')))
	else
		Armory.InspectPrimaryStat = Armory.Constants.SpecPrimaryStats[GetInspectSpecialization(unit)]
		if _G.InspectPaperDollFrame.SLE_Armory_BG then
			IA:Update_BG()
		end

		InspectFrame.TitleContainer:ClearAllPoints()
		InspectFrame.TitleContainer:Point('TOPLEFT', InspectFrame, 'TOPLEFT', 24, -1)
		InspectFrame.TitleContainer:Point('TOPRIGHT', InspectFrame, 'TOPRIGHT', -24, -1)

		InspectPaperDollFrame.LevelTextWrapper:ClearAllPoints()
		InspectPaperDollFrame.LevelTextWrapper:Point('TOP', InspectPaperDollFrame, 'TOP', 0, -22)
	end

	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot then
			if Slot.TransmogInfo then
				if which == 'Character' then
					local transmogLocation = TransmogUtil.GetTransmogLocation(Slot.ID, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
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
						LCG.AutoCastGlow_Start(Slot, {1, 0.5, 1, 1}, E.db.sle.armory[window].transmog.glowNumber, 0.25, 1, E.db.sle.armory[window].transmog.glowOffset, E.db.sle.armory[window].transmog.glowOffset, '_TransmogGlow')
					else
						LCG.AutoCastGlow_Stop(Slot, '_TransmogGlow')
					end
				else
					Slot.TransmogInfo.Link = nil
					Slot.TransmogInfo:Hide()
					LCG.AutoCastGlow_Stop(Slot, '_TransmogGlow')
				end
			end
		end
	end

end

--Updates ilvl and everything tied to the item somehow
function Armory:UpdatePageStrings(_, iLevelDB, Slot, slotInfo, which)
	if not which then return end
	local window = strlower(which) --to know which settings table to use
	if (not (E.db.sle.armory[window] and E.db.sle.armory[window].enable) and Armory:CheckOptions(which)) then return end

	Slot.itemLink = GetInventoryItemLink((which == 'Character' and 'player') or _G.InspectFrame.unit, Slot.ID)
	if slotInfo.itemLevelColors then
		local iR, iG, iB = unpack(slotInfo.itemLevelColors)
		if Slot.enchantText and not (slotInfo.enchantTextShort == nil or slotInfo.enchantText == nil) then Armory:ProcessEnchant(window, Slot, slotInfo.enchantText, slotInfo.enchantTextReal) end
		if E.db.sle.armory[window].ilvl.colorType == 'QUALITY' then
			if iR ~= nil then
				Slot.iLvlText:SetTextColor(iR, iG, iB) --Business as usual
			end
		elseif E.db.sle.armory[window].ilvl.colorType == 'GRADIENT' then
			local equippedIlvl = window == 'character' and select(2, GetAverageItemLevel()) or E:CalculateAverageItemLevel(iLevelDB, _G.InspectFrame.unit)
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

		--This block is separate cause disabling armory will not hide dem gradients otherwise
		if Slot.SLE_Gradient then --First call for this function for inspect is before gradient is created. To avoid errors
			if E.db.sle.armory[window].enable and E.db.sle.armory[window].gradient.enable and slotInfo.iLvl then
				Slot.SLE_Gradient:Show()
				if E.db.sle.armory[window].gradient.setArmor and select(16, C_Item_GetItemInfo(Slot.itemLink)) then
					Slot.SLE_Gradient:SetVertexColor(unpack(E.db.sle.armory[window].gradient.setArmorColor))
				elseif E.db.sle.armory[window].gradient.quality then
					Slot.SLE_Gradient:SetVertexColor(unpack(slotInfo.itemLevelColors))
				else
					Slot.SLE_Gradient:SetVertexColor(unpack(E.db.sle.armory[window].gradient.color))
				end
			else
				Slot.SLE_Gradient:Hide()
			end
		end
	else
		if Slot.SLE_Gradient then Slot.SLE_Gradient:Hide() end
	end
	--If put inside "if slotInfo.itemLevelColors" condition will not actually hide gem links/warnings on empty slots
	Armory:UpdateGemInfo(Slot, which)
	Armory:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.enchantTextShort, Armory[which..'PrimaryStat'])
	if CA.DurabilityFontSet then CA:Calculate_Durability(which, Slot) end
end

---Store gem info in our hidden frame
function Armory:UpdateGemInfo(Slot, which)
	local unit = which == 'Character' and 'player' or (_G.InspectFrame and _G.InspectFrame.unit)
	if not unit then return end
	local itemLink = Slot.itemLink

	for i = 1, Armory.Constants.MaxGemSlots do
		if not Slot['SLE_Gem'..i] then return end

		local gemLink, gemTexture
		if itemLink then
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
						gemLink = C_AzeriteEssence.GetEssenceHyperlink(GemID, rank)
					end
				end
				if not gemLink then
					gemLink = select(2, C_Item_GetItemGem(itemLink, i))
				end
			else
				local textureSlot = Slot['textureSlot'..i]
				local textureID = textureSlot:GetTexture()

				gemLink = select(2, C_Item_GetItemGem(itemLink, i))
				if gemLink then
					gemTexture = select(10, C_Item_GetItemInfo(gemLink))
					gemLink = select(2, C_Item_GetItemGem(itemLink, textureID == gemTexture and i or i + 1))
				end
			end
		end
		Slot['SLE_Gem'..i].Link = gemLink
	end
end

function Armory:CreateSlotStrings(_, which)
	Armory:UpdateSharedStringsFonts(which)
end

function Armory:UpdateSharedStringsFonts(which)
	local window = strlower(which)
	for _, SlotName in pairs(Armory.Constants.GearList) do
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
function Armory:ProcessEnchant(which, Slot, enchantText, enchantTextReal)
	if not E.db.sle.armory.enchantString.enable then return end
	local window = strlower(which)
	local strict = E.db.sle.armory.enchantString.strict

	local showReal = E.db.sle.armory[window].enchant.showReal
	local text = showReal and enchantTextReal or enchantText

	if E.db.sle.armory.enchantString.replacement then
		local profQuality = strmatch(enchantTextReal, '|A.-|a')
		for _, enchData in pairs(SLE_ArmoryDB.EnchantString) do
			if enchData.new and strict and enchantText == enchData.original then
				text = enchData.new..' '..(showReal and profQuality or '')
			elseif not strict and enchData.original and enchData.new then
				text = gsub(text, E:EscapeString(enchData.original), enchData.new)
			end
		end
	end
	Slot.enchantText:SetText(text)
end

---<<<Global Hide tooltip func for armory>>>---
function Armory:Tooltip_OnLeave()
	_G.GameTooltip:Hide()
end

---<<<Show Gem on mouse over>>>---
function Armory:Gem_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Link then --Only do stuff if armory is enabled or the gem is present
		_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		_G.GameTooltip:SetHyperlink(self.Link)
		_G.GameTooltip:Show()
	end
end

---<<<Show what the fuck is wrong with this item>>>---
function Armory:Warning_OnEnter()
	if E.db.sle.armory[self.frame].enable and self.Reason then --Only do stuff if armory is enabled and something is actually missing
		_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		_G.GameTooltip:AddLine(self.Reason, 1, 1, 1)
		_G.GameTooltip:Show()
	end
end

--<<<<<Transmog functions>>>>>--
function Armory:Transmog_OnEnter()
	if not self.Link then return end

	self.Texture:SetVertexColor(1, 0.8, 1)
	_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

	if self.isInspect then
		local inspectLink = select(2, C_Item_GetItemInfo(self.Link)) --In case the client actually decides to give us the info
		if inspectLink then
			_G.GameTooltip:SetHyperlink(inspectLink)
		else
			_G.GameTooltip:SetText(self.Link)
		end
	else
		_G.GameTooltip:SetHyperlink(self.Link)
	end

	_G.GameTooltip:Show()
end

function Armory:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)
	_G['GameTooltip']:Hide()
end

function Armory:Transmog_OnClick()
	local _, ItemLink = C_Item_GetItemInfo(self.Link)

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

function Armory:CheckForMissing(which, Slot, iLvl, gems, enchant, primaryStat)
	if not Slot.SLE_Warning then return end --Shit happens
	Slot.SLE_Warning.Reason = nil --Clear message, cause disabling armory doesn't affect those otherwise
	local window = strlower(which)
	if not (E.db.sle.armory[window] and E.db.sle.armory[window].enable and E.db.sle.armory[window].showWarning) then Slot.SLE_Warning:Hide(); return end --if something is disdbled
	local SlotName = gsub(Slot:GetName(), which, '')
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false
	if iLvl and (Armory.Constants.EnchantableSlots[SlotName] == true or Armory.Constants.EnchantableSlots[SlotName] == primaryStat) and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local classID, subclassID = select(12, C_Item_GetItemInfo(Slot.itemLink))
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
		Slot.SLE_Warning.Reason = message or nil
		Slot.SLE_Warning:Show()
		Slot.SLE_Warning.texture:SetVertexColor(unpack(E.db.sle.armory.character.gradient.warningBarColor))
		if Slot.SLE_Gradient then Slot.SLE_Gradient:SetVertexColor(unpack(E.db.sle.armory[window].gradient.warningColor)) end
	else
		Slot.SLE_Warning:Hide()
	end
end

function Armory:UpdateInspectInfo()
	if not _G.InspectFrame then return end --In case update for frame is called before it is actually created
	if not Armory.Constants.Inspect_Defaults_Cached then
		Armory:BuildFrameDefaultsCache('Inspect')
		IA:LoadAndSetup()
	end
	if E.db.sle.armory.inspect.enable then M:UpdatePageInfo(_G.InspectFrame, 'Inspect') end
	if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G.InspectFrame, 'Inspect') end
end

function Armory:UpdateCharacterInfo(event)
	if event == 'CRITERIA_UPDATE' and (InCombatLockdown() or not _G.CharacterFrame:IsShown()) then return end

	if E.db.sle.armory.character.enable then
		M:UpdatePageInfo(_G.CharacterFrame, 'Character')
	end
	if not E.db.general.itemLevel.displayCharacterInfo then
		M:ClearPageInfo(_G.CharacterFrame, 'Character')
	end
end

function Armory:ToggleItemLevelInfo()
	if E.db.general.itemLevel.displayCharacterInfo then
		-- Armory:UnregisterEvent('AZERITE_ESSENCE_UPDATE')
		Armory:UnregisterEvent('SOCKET_INFO_UPDATE')
		Armory:UnregisterEvent('WEAPON_ENCHANT_CHANGED')
		Armory:UnregisterEvent('ENCHANT_SPELL_COMPLETED')
		Armory:UnregisterEvent('CRITERIA_UPDATE')
		Armory:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
		Armory:UnregisterEvent('UPDATE_INVENTORY_DURABILITY')
		-- Armory:UnregisterEvent('PLAYER_AVG_ITEM_LEVEL_UPDATE')
	else
		-- Armory:RegisterEvent('AZERITE_ESSENCE_UPDATE', 'UpdateCharacterInfo')
		Armory:RegisterEvent('SOCKET_INFO_UPDATE', 'UpdateCharacterInfo')
		Armory:RegisterEvent('WEAPON_ENCHANT_CHANGED', 'UpdateCharacterInfo')
		Armory:RegisterEvent('ENCHANT_SPELL_COMPLETED', 'UpdateCharacterInfo')
		Armory:RegisterEvent('CRITERIA_UPDATE', 'UpdateCharacterInfo')
		Armory:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'UpdateCharacterInfo')
		Armory:RegisterEvent('UPDATE_INVENTORY_DURABILITY', 'UpdateCharacterInfo')
		-- Armory:RegisterEvent('PLAYER_AVG_ITEM_LEVEL_UPDATE', 'UpdateCharacterItemLevel')
	end

	if _G.InspectFrame and _G.InspectFrame:IsShown() and Armory:CheckOptions('Inspect') and E.db.general.itemLevel.displayInspectInfo then
		M:UpdateInspectInfo()
	else
		M:ClearPageInfo(_G.InspectFrame, 'Inspect')
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
	SA = SLE.Armory_Stats
	CA = SLE.Armory_Character
	SA:LoadAndSetup()
	-- if not E.db.sle.armory.character.enable and not E.db.sle.armory.inspect.enable then return end

	hooksecurefunc(M, 'UpdatePageInfo', Armory.UpdatePageInfo)
	hooksecurefunc(M, 'UpdatePageStrings', Armory.UpdatePageStrings) --should be ok to call
	hooksecurefunc(M, 'ToggleItemLevelInfo', Armory.ToggleItemLevelInfo) --! idk yet
	hooksecurefunc(M, 'UpdateInspectPageFonts', Armory.UpdateSharedStringsFonts) --should be ok to call
	hooksecurefunc(M, 'CreateSlotStrings', Armory.CreateSlotStrings) --should be ok to call

	Armory:ToggleItemLevelInfo()
	if E.db.sle.armory.character.enable and Armory:CheckOptions('Character') then
		Armory:BuildFrameDefaultsCache('Character')
		hooksecurefunc(M, 'UpdateCharacterInfo', Armory.UpdateCharacterInfo)
		CA:LoadAndSetup()
		Armory:UpdateCharacterInfo()
	end

	if E.db.sle.armory.inspect.enable and Armory:CheckOptions('Inspect') then
		IA = SLE.Armory_Inspect
		hooksecurefunc(M, 'UpdateInspectInfo', Armory.UpdateInspectInfo)
		IA:PreSetup()
	end

	function Armory:ForUpdateAll()
		-- if E.db.sle.armory.character.enable then
		-- 	SLE.Armory_Character:ToggleArmory()
		-- 	M:UpdatePageInfo(_G.CharacterFrame, 'Character')
		-- 	if not E.db.general.itemLevel.displayCharacterInfo then M:ClearPageInfo(_G.CharacterFrame, 'Character') end
		-- end

		-- if E.db.sle.armory.inspect.enable then
		-- 	SLE.Armory_Inspect:ToggleArmory()
		-- 	M:UpdatePageInfo(_G.InspectFrame, "Inspect") --Putting this under the elv's option check just breaks the shit out of the frame
		-- 	if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G.InspectFrame, 'Inspect') end --Clear the infos if those are actually not supposed to be shown.
		-- end
	end

	_G.CharacterFrame:HookScript('OnShow', function()
		-- if not E.db.general.itemLevel.displayCharacterInfo then
		-- 	M:ClearPageInfo(_G.CharacterFrame, 'Character')
		-- 	-- SLE:Print("Charcter Page Hook Done")
		-- end
	end)

	--Move Pawn buttons. Cause Pawn buttons happen to be overlapped by some shit
	if SLE._Compatibility['Pawn'] then
		PawnUI_InventoryPawnButton:SetFrameLevel(PawnUI_InventoryPawnButton:GetFrameLevel() + 5)
		hooksecurefunc('PawnUI_InventoryPawnButton_Move', function()
			if PawnCommon.ButtonPosition == PawnButtonPositionRight then
				PawnUI_InventoryPawnButton:ClearAllPoints()
				if PaperDollFrame.ExpandButton then --Try not to break Pawn's DCS innate compatibility
					PawnUI_InventoryPawnButton:SetPoint('TOPRIGHT', 'CharacterTrinket1Slot', 'BOTTOMRIGHT', -31, -8)
				else
					PawnUI_InventoryPawnButton:SetPoint('TOPRIGHT', 'CharacterTrinket1Slot', 'BOTTOMRIGHT', -1, -8)
				end
			end
		end)
	end
end

SLE:RegisterModule(Armory:GetName())
