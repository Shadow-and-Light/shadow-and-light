local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo("ElvUI_KnightFrame")) and IsAddOnLoaded("ElvUI_KnightFrame") then return end --Don't break korean code :D
local Armory = SLE:NewModule("Armory_Core", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local M = E:GetModule("Misc")
local LCG = LibStub('LibCustomGlow-1.0')

local GetAverageItemLevel = GetAverageItemLevel
local LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION
local TRANSMOGRIFIED_HEADER = TRANSMOGRIFIED_HEADER
local C_Transmog_GetSlotInfo = C_Transmog.GetSlotInfo
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo
local C_TransmogCollection_GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo
local HandleModifiedItemClick = HandleModifiedItemClick

local CA, IA, SA
Armory.Constants = {}

--Create ench replacement string DB
if not SLE_ArmoryDB or type(SLE_ArmoryDB) ~= "table" then
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
	["TabardSlot"] = true,
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
Armory.Constants.Corruption = {
	["DefaultX"] = 5, ["DefaultY"] = -8,
}
--First value is not really needed. I left it for reference rerasons
Armory.Constants.CorruptionSpells = {
	["6483"] = {"Avoidant", "I", 315607},
	["6484"] = {"Avoidant", "II", 315608},
	["6485"] = {"Avoidant", "III", 315609},
	["6474"] = {"Expedient", "I", 315544},
	["6475"] = {"Expedient", "II", 315545},
	["6476"] = {"Expedient", "III", 315546},
	["6471"] = {"Masterful", "I", 315529},
	["6472"] = {"Masterful", "II", 315530},
	["6473"] = {"Masterful", "III", 315531},
	["6480"] = {"Severe", "I", 315554},
	["6481"] = {"Severe", "II", 315557},
	["6482"] = {"Severe", "III", 315558},
	["6477"] = {"Versatile", "I", 315549},
	["6478"] = {"Versatile", "II", 315552},
	["6479"] = {"Versatile", "III", 315553},
	["6493"] = {"Siphoner", "I", 315590},
	["6494"] = {"Siphoner", "II", 315591},
	["6495"] = {"Siphoner", "III", 315592},
	["6437"] = {"Strikethrough", "I", 315277},
	["6438"] = {"Strikethrough", "II", 315281},
	["6439"] = {"Strikethrough", "III", 315282},
	["6555"] = {"Racing Pulse", "I", 318266},
	["6559"] = {"Racing Pulse", "II", 318492},
	["6560"] = {"Racing Pulse", "III", 318496},
	["6556"] = {"Deadly Momentum", "I", 318268},
	["6561"] = {"Deadly Momentum", "II", 318493},
	["6562"] = {"Deadly Momentum", "III", 318497},
	["6558"] = {"Surging Vitality", "I", 318270},
	["6565"] = {"Surging Vitality", "II", 318495},
	["6566"] = {"Surging Vitality", "III", 318499},
	["6557"] = {"Honed Mind", "I", 318269},
	["6563"] = {"Honed Mind", "II", 318494},
	["6564"] = {"Honed Mind", "III", 318498},
	["6549"] = {"Echoing Void", "I", 318280},
	["6550"] = {"Echoing Void", "II", 318485},
	["6551"] = {"Echoing Void", "III", 318486},
	["6552"] = {"Infinite Stars", "I", 318274},
	["6553"] = {"Infinite Stars", "II", 318487},
	["6554"] = {"Infinite Stars", "III", 318488},
	["6547"] = {"Ineffable Truth", "I", 318303},
	["6548"] = {"Ineffable Truth", "II", 318484},
	["6537"] = {"Twilight Devastation", "I", 318276},
	["6538"] = {"Twilight Devastation", "II", 318477},
	["6539"] = {"Twilight Devastation", "III", 318478},
	["6543"] = {"Twisted Appendage", "I", 318481},
	["6544"] = {"Twisted Appendage", "II", 318482},
	["6545"] = {"Twisted Appendage", "III", 318483},
	["6540"] = {"Void Ritual", "I", 318286},
	["6541"] = {"Void Ritual", "II", 318479},
	["6542"] = {"Void Ritual", "III", 318480},
	["6573"] = {"Gushing Wound", "", 318272},
	["6546"] = {"Glimpse of Clarity", "", 318239},
	["6571"] = {"Searing Flames", "", 318293},
	["6572"] = {"Obsidian Skin", "", 316651},
	["6567"] = {"Devour Vitality", "", 318294},
	["6568"] = {"Whispered Truths", "", 316780},
	["6570"] = {"Flash of Insight", "", 318299},
	["6569"] = {"Lash of the Void", "", 317290},
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
		Armory.Constants[which.."_Defaults"][SlotName] = {}
		local Slot = _G[which..SlotName]
		if not Slot then E:Delay(1, function() Armory:BuildFrameDefaultsCache(which) end); return end
		Slot.Direction = i%2 == 1 and "LEFT" or "RIGHT"
		if Slot.iLvlText then
			Armory.Constants[which.."_Defaults"][SlotName]["iLvlText"] = { Slot.iLvlText:GetPoint() }
			Armory.Constants[which.."_Defaults"][SlotName]["textureSlot1"] = { Slot.textureSlot1:GetPoint() }
			for i = 2, 10 do
				if Slot["textureSlot"..i] then Slot["textureSlot"..i]:ClearAllPoints(); Slot["textureSlot"..i]:Point(Slot.Direction, Slot["textureSlot"..(i-1)], Slot.Direction == "LEFT" and "RIGHT" or "LEFT", E.twoPixelsPlease and 3 or 1, 0) end
			end
			Armory.Constants[which.."_Defaults"][SlotName]["enchantText"] = { Slot.enchantText:GetPoint() }
		end
		if SlotName == "NeckSlot" and Slot.RankFrame then
			Armory.Constants[which.."_Defaults"][SlotName]["RankFrame"] = { Slot.RankFrame:GetPoint() }
		end
	end
	Armory.Constants[which.."_Defaults_Cached"] = true
end

function Armory:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()

	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName.."Texture"..i]:SetTexture(nil)
		_G[TooltipName.."Texture"..i]:ClearAllPoints()
		_G[TooltipName.."Texture"..i]:Point("TOPLEFT", Tooltip)
	end
end

function Armory:GetTransmogInfo(Slot, which, unit)
	if not which or not unit then return nil end
	local transmogLink, TooltipText
	Armory:ClearTooltip(Armory.ScanTT)
	Armory.ScanTT:SetInventoryItem(unit, Slot.ID)

	for i = 1, Armory.ScanTT:NumLines() do
		TooltipText = _G["SLE_Armory_ScanTTTextLeft"..i]:GetText()

		if TooltipText:match(TRANSMOGRIFIED_HEADER) then
			transmogLink = _G["SLE_Armory_ScanTTTextLeft"..(i + 1)]:GetText()
			Armory:ClearTooltip(Armory.ScanTT)
			return transmogLink
		end
	end
end

function Armory:GetCorruptionInfo(Slot, which, unit)
	if not Slot.itemLink then return nil end
	if not which or not unit then return nil end
	local window = strlower(which)
	if IsCorruptedItem(Slot.itemLink) or Slot.ID == 15 then
		local TooltipText
		Armory:ClearTooltip(Armory.ScanTT)
		Armory.ScanTT:SetInventoryItem(unit, Slot.ID)

		for i = 1, Armory.ScanTT:NumLines() do
			TooltipText = _G["SLE_Armory_ScanTTTextLeft"..i]:GetText()

			if TooltipText:match(ITEM_MOD_CORRUPTION_RESISTANCE) then
				TooltipText = gsub(TooltipText, TooltipText:match(ITEM_MOD_CORRUPTION_RESISTANCE), "")
				return "res", TooltipText, nil
			elseif TooltipText:match(ITEM_MOD_CORRUPTION) then
				TooltipText = gsub(TooltipText, TooltipText:match(ITEM_MOD_CORRUPTION), "")

				--Iteration to get corruption spell from bunus ID. Got the script from suspctz
				local itemSplit = SLE:GetItemSplit(Slot.itemLink)
				local bonuses = {}
				local corruptionSpell = ""

				for index= 1, itemSplit[13] do
					bonuses[#bonuses + 1] = itemSplit[13 + index]
				end

				if #bonuses > 0 then
					local Spells = Armory.Constants.CorruptionSpells
					for i, bonus_id in pairs(bonuses) do
						bonus_id = tostring(bonus_id)
						if Spells[bonus_id] ~= nil then
							local name, rank, icon = GetSpellInfo(Spells[bonus_id][3])
							if Spells[bonus_id][2] ~= "" then rank = Spells[bonus_id][2] else rank = "" end
							if E.db.sle.armory[window].corruptionText.icon then
								corruptionSpell = "|T"..icon..":0|t "..name.." "..rank
							else
								corruptionSpell = name.." "..rank
							end
						end
					end
				end

				return "cor", TooltipText, corruptionSpell
			end
		end
	end

	return false, 0, nil
end

--Updates the frame
function Armory:UpdatePageInfo(frame, which, guid, event)
	if not (frame and which) then return end
	if not Armory:CheckOptions(which) then return end
	local window = strlower(which)
	local unit = (which == 'Character' and 'player') or frame.unit
	if which == "Character" then
		CA:Update_Durability()
		CA:Update_SlotCorruption()
	end
	for i, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G[which..SlotName]
		if Slot then
			if Slot.TransmogInfo then
				if which == "Character" then
					Slot.TransmogInfo.Link = select(6, C_TransmogCollection_GetAppearanceSourceInfo(select(3, C_Transmog_GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE))));
				elseif which == "Inspect" then
					Slot.TransmogInfo.Link = Armory:GetTransmogInfo(Slot, which, unit)
				else
					return
				end
				if E.db.sle.armory[window].enable and Slot.TransmogInfo.Link then
					if E.db.sle.armory[window].transmog.enableArrow then Slot.TransmogInfo:Show() else Slot.TransmogInfo:Hide() end
					if E.db.sle.armory[window].transmog.enableGlow then
						LCG.AutoCastGlow_Start(Slot,{1, .5, 1, 1},E.db.sle.armory[window].transmog.glowNumber,0.25,1,E.db.sle.armory[window].transmog.glowOffset,E.db.sle.armory[window].transmog.glowOffset,"_TransmogGlow")
					else
						LCG.AutoCastGlow_Stop(Slot,"_TransmogGlow")
					end
				else
					Slot.TransmogInfo.Link = nil
					Slot.TransmogInfo:Hide()
					LCG.AutoCastGlow_Stop(Slot,"_TransmogGlow")
				end
			end
			if Slot.CorText then --Setting corruption text if it actually exists for the slot
				Slot.CorText:SetText("")
				if E.db.sle.armory[window].corruptionText.style ~= "Hide" and E.db.sle.armory.character.enable then
					local isCorruption, CorValue, CorSpell = Armory:GetCorruptionInfo(Slot, which, unit)
					if isCorruption then
						if isCorruption == "cor" then
							if E.db.sle.armory[window].corruptionText.style == "AMOUNT/SPELL" then
								CorValue = CorValue..CorSpell
							elseif E.db.sle.armory[window].corruptionText.style == "SPELL" then
								CorValue = CorSpell or ""
							end
							CorValue = "|cff956DD1"..CorValue.."|r" --Color purple
						else
							if E.db.sle.armory[window].corruptionText.style == "SPELL" then CorValue = "" end
							CorValue = "|cffFFD100"..CorValue.."|r" --Color yellow
						end
						Slot.CorText:SetText(CorValue)
					end
				end
			end
		end
	end

end

--Updates ilvl and everything tied to the item somehow
function Armory:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which)
	if not Armory:CheckOptions(which) then return end
	Slot.itemLink = GetInventoryItemLink((which == "Character" and "player") or _G["InspectFrame"].unit, Slot.ID)
	if slotInfo.itemLevelColors then
		local window = strlower(which) --to know which settings table to use
		if E.db.sle.armory[window] and E.db.sle.armory[window].enable then --If settings table actually exists and armory for it is enabled
			if Slot.enchantText and not (slotInfo.enchantTextShort == nil or slotInfo.enchantText == nil) then Armory:ProcessEnchant(window, Slot, slotInfo.enchantTextShort, slotInfo.enchantText) end
			if E.db.sle.armory[window].ilvl.colorType == "QUALITY" then
				Slot.iLvlText:SetTextColor(unpack(slotInfo.itemLevelColors)) --Busyness as usual
			elseif E.db.sle.armory[window].ilvl.colorType == "GRADIENT" then
				local equippedIlvl = window == "character" and select(2, GetAverageItemLevel()) or E:CalculateAverageItemLevel(iLevelDB, _G["InspectFrame"].unit)
				local diff
				if slotInfo.iLvl and (equippedIlvl and type(equippedIlvl) ~= "boolean") then
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
	Armory:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.essences, slotInfo.enchantTextShort)
	if CA.DurabilityFontSet then CA:Calculate_Durability(which, Slot) end
end

---Store gem info in our hidden frame
function Armory:UpdateGemInfo(Slot, which)
	local unit = which == "Character" and "player" or (_G["InspectFrame"] and _G["InspectFrame"].unit)
	if not unit then return end
	for i = 1, Armory.Constants.MaxGemSlots do
		local GemLink
		if not Slot["SLE_Gem"..i] then return end
		if Slot.itemLink then
			if Slot.ID == 2 then
				if not CA.HearthMilestonesCached then CA:FixFuckingBlizzardLogic() end
				local window = strlower(which)
				if E.db.sle.armory[window] and E.db.sle.armory[window].enable then
					if which == "Character" and Slot["textureSlotEssenceType"..i] then
						Slot["textureSlotEssenceType"..i]:Hide()
					elseif which == "Inspect" and Slot["textureSlotBackdrop"..i] then
						Slot["textureSlotBackdrop"..i]:Hide()
					end
				end
				if which == "Character" and Armory.Constants.EssenceMilestones[i] then
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
		Slot["SLE_Gem"..i].Link = GemLink
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
			local fontIlvl, sizeIlvl, outlineIlvl, fontEnch, sizeEnch, outlineEnch, fontCor, sizeCor, outlineCor
			if E.db.sle.armory[window].enable then
				fontIlvl, sizeIlvl, outlineIlvl = E.db.sle.armory[window].ilvl.font, E.db.sle.armory[window].ilvl.fontSize, E.db.sle.armory[window].ilvl.fontStyle
				fontEnch, sizeEnch, outlineEnch = E.db.sle.armory[window].enchant.font, E.db.sle.armory[window].enchant.fontSize, E.db.sle.armory[window].enchant.fontStyle
				fontCor, sizeCor, outlineCor = E.db.sle.armory[window].corruptionText.font, E.db.sle.armory[window].corruptionText.fontSize, E.db.sle.armory[window].corruptionText.fontStyle
			else
				fontIlvl, sizeIlvl, outlineIlvl = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or "OUTLINE"
				fontEnch, sizeEnch, outlineEnch = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or "OUTLINE"
				fontCor, sizeCor, outlineCor = E.db.general.itemLevel.itemLevelFont, E.db.general.itemLevel.itemLevelFontSize or 12, E.db.general.itemLevel.itemLevelFontOutline or "OUTLINE"
			end
			Slot.iLvlText:FontTemplate(E.LSM:Fetch('font', fontIlvl), sizeIlvl, outlineIlvl)
			Slot.enchantText:FontTemplate(E.LSM:Fetch('font', fontEnch), sizeEnch, outlineEnch)
			if Slot.CorText then Slot.CorText:FontTemplate(E.LSM:Fetch('font', fontCor), sizeCor, outlineCor) end
		end
	end
end

--Deals with dem enchants
function Armory:ProcessEnchant(which, Slot, enchantTextShort, enchantText)
	if not E.db.sle.armory.enchantString.enable then return end
	if E.db.sle.armory.enchantString.replacement then
		for enchString, enchData in pairs(SLE_ArmoryDB.EnchantString) do
			if enchData.original and enchData.new then
				enchantText = gsub(enchantText, enchData.original, enchData.new)
			end
		end
	end
	Slot.enchantText:SetText(enchantText)
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
	if not self.Link then return end
	self.Texture:SetVertexColor(1, .8, 1)

	_G["GameTooltip"]:SetOwner(self, "ANCHOR_RIGHT")
	if self.isInspect then
		local inspectLink = select(2, GetItemInfo(self.Link)) --In case the client actually decides to give us the info
		if inspectLink then
			_G["GameTooltip"]:SetHyperlink(inspectLink)
		else
			_G["GameTooltip"]:SetText(self.Link)
		end
	else
		_G["GameTooltip"]:SetHyperlink(self.Link)
	end
	_G["GameTooltip"]:Show()
end

function Armory:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)
	_G["GameTooltip"]:Hide()
end

function Armory:Transmog_OnClick(button)
	local ItemName, ItemLink = GetItemInfo(self.Link)

	if not IsShiftKeyDown() then
		SetItemRef(ItemLink, ItemLink, 'LeftButton')
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
	local window = strlower(which)
	if not (E.db.sle.armory[window] and E.db.sle.armory[window].enable and E.db.sle.armory[window].showWarning) then Slot["SLE_Warning"]:Hide(); return end --if something is disdbled
	local SlotName = gsub(Slot:GetName(), which, "")
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false
	if iLvl and Armory.Constants.EnchantableSlots[SlotName] and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local classID, subclassID = select(12, GetItemInfo(Slot.itemLink))
		if (classID == 4 and subclassID == 6) or (classID == 4 and subclassID == 0 and Slot.ID == 17) then --Shields are special
			noChant = false
		else
			noChant = true
		end
	end
	if gems and Slot.ID ~= 2 then --If gems found and not neck
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
		if Slot.SLE_Gradient then Slot.SLE_Gradient:SetVertexColor(1, 0, 0) end
	else
		Slot["SLE_Warning"]:Hide()
	end
end

function Armory:UpdateInspectInfo()
	if not _G["InspectFrame"] then return end --In case update for frame is called before it is actually created
	if not Armory.Constants.Inspect_Defaults_Cached then
		Armory:BuildFrameDefaultsCache("Inspect")
		IA:LoadAndSetup()
	end
	if E.db.sle.armory.inspect.enable then M:UpdatePageInfo(_G["InspectFrame"], "Inspect") end
	if not E.db.general.itemLevel.displayInspectInfo then M:ClearPageInfo(_G["InspectFrame"], "Inspect") end
end

function Armory:UpdateCharacterInfo()
	if E.db.sle.armory.character.enable then M:UpdatePageInfo(_G["CharacterFrame"], "Character") end
	if not E.db.general.itemLevel.displayCharacterInfo then M:ClearPageInfo(_G["CharacterFrame"], "Character") end
	-- CA:UpdateCorruptionLevel()
end

function Armory:ToggleItemLevelInfo(setupCharacterPage)
	if _G["InspectFrame"] and _G["InspectFrame"]:IsShown() and Armory:CheckOptions("Inspect") and E.db.general.itemLevel.displayInspectInfo then
		M:UpdateInspectInfo()
	else
		M:ClearPageInfo(_G["InspectFrame"], "Inspect")
	end
end

function Armory:CheckOptions(which)
	if not E.private.skins.blizzard.enable then return false end
	if (which == "Character" and not E.private.skins.blizzard.character) or (which == "Inspect" and not E.private.skins.blizzard.inspect) then return false end
	return true
end

function Armory:HandleCorruption()
	if SLE._Compatibility["DejaCharacterStats"] then return end
	local CorruptionIcon = _G["CharacterFrame"].SLE_Corruption
	CorruptionIcon:ClearAllPoints()
	CorruptionIcon:SetParent(_G["SLE_Armory_Scroll"])
	if E.db.sle.armory.character.corruption.position == "SLE" and (E.db.sle.armory.character.enable or E.db.sle.armory.stats.enable) then
		CorruptionIcon:SetPoint("LEFT", _G["CharacterFrame"], "TOPRIGHT", -34, -54)
	else
		CorruptionIcon:SetPoint("RIGHT", _G["CharacterStatsPane"].ItemLevelFrame, "RIGHT", Armory.Constants.Corruption.DefaultX, Armory.Constants.Corruption.DefaultY)
	end
end

function Armory:Initialize()
	if not Armory:CheckOptions() then return end

	--May be usefull later
	Armory.ScanTT = CreateFrame("GameTooltip", "SLE_Armory_ScanTT", nil, "GameTooltipTemplate")
	Armory.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')

	hooksecurefunc(M, "UpdatePageInfo", Armory.UpdatePageInfo)
	hooksecurefunc(M, "UpdatePageStrings", Armory.UpdatePageStrings)
	hooksecurefunc(M, "ToggleItemLevelInfo", Armory.ToggleItemLevelInfo)
	hooksecurefunc(M, "UpdateInspectPageFonts", Armory.UpdateSharedStringsFonts)
	hooksecurefunc(M, "CreateSlotStrings", Armory.CreateSlotStrings)

	if Armory:CheckOptions("Character") then
		CA = SLE:GetModule("Armory_Character")
		SA = SLE:GetModule("Armory_Stats")
		Armory:BuildFrameDefaultsCache("Character")
		hooksecurefunc(M, "UpdateCharacterInfo", Armory.UpdateCharacterInfo)
		CA:LoadAndSetup()
		SA:LoadAndSetup()
		Armory:UpdateCharacterInfo()
	end
	if _G["CharacterFrame"].SLE_Corruption then _G["CharacterFrame"].SLE_Corruption:SetFrameLevel(_G["CharacterStatsPane"].ItemLevelFrame:GetFrameLevel() + 5) end --This fixes wrong mouseover for blizz position of the eye

	if Armory:CheckOptions("Inspect") then
		IA = SLE:GetModule("Armory_Inspect")
		hooksecurefunc(M, "UpdateInspectInfo", Armory.UpdateInspectInfo)
		IA:PreSetup()
	end

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
