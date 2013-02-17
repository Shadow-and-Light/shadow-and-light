local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")

local ilvlSlots = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot","MainHandSlot","SecondaryHandSlot",
	"HandsSlot","WaistSlot","LegsSlot","FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot"
}

function CFO:UpdateItemLevel()
	local frame = _G["CharacterFrame"]
	if not frame:IsShown() then return end
	local itemLink, slot, current, maximum, r, g, b
	for i = 1, #ilvlSlots do
		frame = _G[("Character%s"):format(ilvlSlots[i])]
		frame.ItemLevel:SetText()
		local avgItemLevel, avgEquipItemLevel, actualItemLevel
		avgItemLevel, avgEquipItemLevel = GetAverageItemLevel()
		itemlink = GetInventoryItemLink("player",GetInventorySlotInfo(ilvlSlots[i]))
		if itemlink then
			local levelAdjust={ -- 11th item:id field and level adjustment
				["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,
				["377"]=4,["379"]=4,["380"]=4,["445"]=0,["446"]=4,["447"]=8,
				["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,["456"]=0,
				["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16}
			local baseLevel = select(4,GetItemInfo(itemlink))
			local upgrade = itemlink:match(":(%d+)\124h%[")
			if baseLevel and upgrade and levelAdjust[upgrade] ~= nil then
				actualItemLevel = baseLevel + levelAdjust[upgrade]
			else
				actualItemLevel = baseLevel
			end
			if actualItemLevel <= avgEquipItemLevel - 10 then
				frame.ItemLevel:SetFormattedText("|cffff0000%i|r", actualItemLevel)
			elseif actualItemLevel >= avgEquipItemLevel + 10 then
				frame.ItemLevel:SetFormattedText("|cff00ff00%i|r", actualItemLevel)
			else
				frame.ItemLevel:SetFormattedText("|cffffff99%i|r", actualItemLevel)
			end
		end
		if not E.db.sle.characterframeoptions.itemlevel.enable then
			frame.ItemLevel:Hide()
		else
			frame.ItemLevel:Show()
		end
	end
end

function CFO:UpdateItemLevelFont()
	local frame
	for i = 1, #ilvlSlots do
		frame = _G[("Character%s"):format(ilvlSlots[i])]
		frame.ItemLevel:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemlevel.font), E.db.sle.characterframeoptions.itemlevel.fontSize, E.db.sle.characterframeoptions.itemlevel.fontOutline)
	end
end

function CFO:LoadItemLevel()
	_G["CharacterFrame"]:HookScript("OnShow", function(self)
		CFO:UpdateItemLevel()
	end)

	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemLevel")
	self:RegisterEvent("SOCKET_INFO_UPDATE", "UpdateItemLevel")

	local frame
	for i = 1, #ilvlSlots do
		frame = _G[("Character%s"):format(ilvlSlots[i])]
		frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
		frame.ItemLevel:SetPoint("TOP", frame, "TOP", 2, -3)
		frame.ItemLevel:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemlevel.font), E.db.sle.characterframeoptions.itemlevel.fontSize, E.db.sle.characterframeoptions.itemlevel.fontOutline)
	end
end