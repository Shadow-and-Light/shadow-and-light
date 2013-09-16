local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")

local enchantSlot = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot",
	"MainHandSlot","SecondaryHandSlot","HandsSlot","WaistSlot",
	"LegsSlot","FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot"
}

local isEnchantable = {
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"LegsSlot",
	"FeetSlot"
}
local frameDB = {
	CharacterHeadSlot, CharacterNeckSlot, CharacterShoulderSlot, CharacterBackSlot, CharacterChestSlot, CharacterWristSlot,
	CharacterMainHandSlot, CharacterSecondaryHandSlot, CharacterHandsSlot, CharacterWaistSlot,
	CharacterLegsSlot, CharacterFeetSlot, CharacterFinger0Slot, CharacterFinger1Slot, CharacterTrinket0Slot, CharacterTrinket1Slot
}
local PlayerProfession = {}

local nameEnch = GetSpellInfo(110400)

function CFO:UpdateItemEnchants()
	local frame = _G["CharacterFrame"]
	if not frame:IsShown() then return end
	--print("opened enchant")
	for k, myslot in pairs(enchantSlot) do
		--frame = _G[("Character%s"):format(enchantSlot[i])]
		frame = frameDB[k]
		frame.ItemEnchant:SetText()

		local canEnchant, isEnchanted
		--slot = GetInventorySlotInfo(enchantSlot[i])
		local itemLink = GetInventoryItemLink("player",GetInventorySlotInfo(myslot))
		if itemLink then
			if myslot == "Finger0Slot" or myslot == "Finger1Slot" then
				local profNames = self:fetchProfs()
				for k, v in pairs(profNames) do
					if v == nameEnch then
						canEnchant = true
						isEnchanted = self:fetchChant(myslot)
					end
				end
			elseif myslot == "RangedSlot" then
				local subClass = self:fetchSubclass(myslot)
				if subClass == "Bows" or subClass == "Guns" or subClass == "Crossbows" then
					canEnchant = true
					isEnchanted = self:fetchChant(myslot)
				end
			elseif myslot == "WristSlot" or myslot == "HandsSlot" then
				canEnchant = true
				isEnchanted = self:fetchChant(myslot)
			else
				for k ,v in pairs(isEnchantable) do
					if v == myslot then
						canEnchant = true
						isEnchanted = self:fetchChant(myslot)
					end
				end
			end
			
			isEnchanted = tonumber(isEnchanted)
			if canEnchant == true then
				if isEnchanted == 0 then
					--self.ItemEnchant:SetFormattedText("|cffff0000%s|r|cffff0000%s|r", "E", "G")
					frame.ItemEnchant:SetFormattedText("|cffff0000%s|r", L["Not Enchanted"])
				elseif isEnchanted > 0 then
					--self.ItemEnchant:SetFormattedText("|cff00ff00%i|r|cffff0000%s|r", "E", "G")
					frame.ItemEnchant:SetFormattedText("|cff00ff00%s|r", L["Enchanted"])
				end
			elseif canEnchant == false then
					frame.ItemEnchant:SetFormattedText("|cff00ff00%s|r", L["Can't Enchant"])
			elseif canEnchant == nil then
				frame.ItemEnchant:SetFormattedText("")
			end

			if not E.db.sle.characterframeoptions.itemenchant.enable then
				frame.ItemEnchant:Hide()
			else
				frame.ItemEnchant:Show()
			end
		end
	end
end
function CFO:fetchChant(slotName)
	local inventoryID = GetInventorySlotInfo(slotName)
	local myLink = GetInventoryItemLink("player", inventoryID)
	local parsedItemDataTable = {}
	local foundStart, foundEnd, parsedItemData = string.find(myLink, "^|c%x+|H(.+)|h%[.*%]")
	for v in string.gmatch(parsedItemData, "[^:]+") do
		tinsert(parsedItemDataTable, v)
	end
	
	return parsedItemDataTable[3]
end

function CFO:fetchProfs()
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
	local profs = {prof1, prof2, archaeology, fishing, cooking, firstAid}
	local profNames = {}
	
	for k, v in pairs(profs) do
		local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(v)
		tinsert(profNames, name)
	end
	
	return profNames
end
function CFO:fetchSubclass(slotName)
	local slotId, texture, checkRelic = GetInventorySlotInfo(slotName)
	local itemId = GetInventoryItemID("player", slotId)
	if itemId then
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		return(subclass)
	end
end
function CFO:UpdateItemEnchantFont()
	local frame
	for i = 1, #enchantSlot do
		frame = _G[("Character%s"):format(enchantSlot[i])]
		frame.ItemEnchant:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemenchant.font), E.db.sle.characterframeoptions.itemenchant.fontSize, E.db.sle.characterframeoptions.itemenchant.fontOutline)
	end
end

function CFO:LoadItemEnchants()
	--_G["CharacterFrame"]:HookScript("OnShow", function(self)
		--CFO:UpdateItemMods()
	--end)

	--self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemMods")

	local frame
	for i = 1, #enchantSlot do
		frame = _G[("Character%s"):format(enchantSlot[i])]
		frame.ItemEnchant = frame:CreateFontString(nil, "OVERLAY")

		if frame == CharacterHeadSlot or frame == CharacterNeckSlot or frame == CharacterShoulderSlot or frame == CharacterBackSlot or frame == CharacterChestSlot or frame == CharacterWristSlot or frame == CharacterShirtSlot or frame == CharacterTabardSlot then
			frame.ItemEnchant:SetPoint("LEFT", frame, "RIGHT", 8, 7)
		elseif frame == CharacterHandsSlot or frame == CharacterWaistSlot or frame == CharacterLegsSlot or frame == CharacterFeetSlot or frame == CharacterFinger0Slot or frame == CharacterFinger1Slot or frame == CharacterTrinket0Slot or frame == CharacterTrinket1Slot then
			frame.ItemEnchant:SetPoint("RIGHT", frame, "LEFT", -5, 7)
		elseif frame == CharacterMainHandSlot then
			frame.ItemEnchant:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 5, -3)
		elseif frame == CharacterSecondaryHandSlot then
			frame.ItemEnchant:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -2, -3)
		end		
		frame.ItemEnchant:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemenchant.font), E.db.sle.characterframeoptions.itemenchant.fontSize, E.db.sle.characterframeoptions.itemenchant.fontOutline)
		
		--frame.EnchantWarning = CreateFrame('Button', nil, frame)
		--frame.EnchantWarning:Size(12)
		--frame.EnchantWarning.Texture = frame.EnchantWarning:CreateTexture(nil, 'OVERLAY')
		--frame.EnchantWarning.Texture:SetInside()
		--frame.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\Media\\Textures\\Warning-Small.tga')
		--frame.EnchantWarning:Point("LEFT", frame.ItemEnchant, "RIGHT", 3, 0)
		--frame.EnchantWarning:Hide()
	end
end