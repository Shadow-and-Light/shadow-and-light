local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")
-- /dump GetInventoryItemLink("player",INVSLOT_HEAD) Leave in here for my notes

local ilvlSlots = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot","MainHandSlot","SecondaryHandSlot",
	"HandsSlot","WaistSlot","LegsSlot","FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot"
}
-- From http://www.wowhead.com/items?filter=qu=7;sl=16:18:5:8:11:10:1:23:7:21:2:22:13:24:15:28:14:4:3:19:25:12:17:6:9;minle=1;maxle=1;cr=166;crs=3;crv=0
local WOW_Heirlooms = {
	[80] = {
		44102,42944,44096,42943,42950,48677,42946,42948,42947,42992,
		50255,44103,44107,44095,44098,44097,44105,42951,48683,48685,
		42949,48687,42984,44100,44101,44092,48718,44091,42952,48689,
		44099,42991,42985,48691,44094,44093,42945,48716
	},
}

function CFO:UpdateItemLevel()
	local frame = _G["CharacterFrame"]
	if not frame:IsShown() then return end

	for i = 1, #ilvlSlots do
		frame = _G[("Character%s"):format(ilvlSlots[i])]
		frame.ItemLevel:SetText()

		local avgItemLevel, avgEquipItemLevel = GetAverageItemLevel()
		local actualItemLevel, itemLink
		itemLink = GetInventoryItemLink("player",GetInventorySlotInfo(ilvlSlots[i]))

		if itemLink then
			local itemLevel = self:GetActualItemLevel(itemLink);
			local rarity = select(3,GetItemInfo(itemLink))
			if rarity == 7 then
				actualItemLevel = self:Heirloom(itemLink);
			else
				actualItemLevel = itemLevel
			end

			if actualItemLevel and actualItemLevel <= avgEquipItemLevel - 10 then
				frame.ItemLevel:SetFormattedText("|cffff0000%i|r", actualItemLevel)
			elseif actualItemLevel and actualItemLevel >= avgEquipItemLevel + 10 then
				frame.ItemLevel:SetFormattedText("|cff00ff00%i|r", actualItemLevel)
			elseif actualItemLevel then
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

function CFO:Heirloom(itemLink)
	local level = UnitLevel("player")

	if level > 80 then
		local _, _, _, _, itemId = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?");
		--print(itemId)
		itemId = tonumber(itemId);

		for k,iid in pairs(WOW_Heirlooms[80]) do
			if iid == itemId then
				level = 80;
			end
		end

        if level > 85 then
            level = 85
        end
	end

	if level > 80 then
		return (( level - 80) * 26.6) + 200;
	elseif level > 70 then
		return (( level - 70) * 10) + 100;
	elseif level > 60 then
		return (( level - 60) * 4) + 60;
	else
		return level;
	end
end

function CFO:GetActualItemLevel(link)
	local levelAdjust={ -- 11th item:id field and level adjustment
		["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,["377"]=4,["379"]=4,["380"]=4,
		["445"]=0,["446"]=4,["447"]=8,["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,
		["456"]=0,["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16,
		["465"]=0,["466"]=4,["467"]=8,["468"] = 0,["469"] = 4,["470"] = 8,["471"] = 12,["472"] = 16,
		["491"]=0,["492"]=4,["493"]=8,["494"]=4,["495"]=8,["496"]=8,["497"]=12,["498"]=16
	}
	local baseLevel = select(4,GetItemInfo(link))
	local upgrade = link:match(":(%d+)\124h%[")
	if baseLevel and upgrade and levelAdjust[upgrade] then
		return baseLevel + levelAdjust[upgrade]
	else
		return baseLevel
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
	--_G["CharacterFrame"]:HookScript("OnShow", function(self)
	--	CFO:UpdateItemLevel()
	--end)

	--self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemLevel")
	--self:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE", "UpdateItemLevel")

	local frame
	for i = 1, #ilvlSlots do
		frame = _G[("Character%s"):format(ilvlSlots[i])]
		frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
		frame.ItemLevel:SetPoint("TOP", frame, "TOP", 2, -3)
		frame.ItemLevel:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemlevel.font), E.db.sle.characterframeoptions.itemlevel.fontSize, E.db.sle.characterframeoptions.itemlevel.fontOutline)
	end
end