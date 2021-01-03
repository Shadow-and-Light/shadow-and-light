local SLE, T, E = unpack(select(2, ...))
local BI = SLE:NewModule('BagInfo', 'AceHook-3.0', 'AceEvent-3.0')
local B = E:GetModule('Bags')

local _G = _G
local GetContainerNumSlots = GetContainerNumSlots
local CUSTOM = CUSTOM
-- local EQUIPMENT_SETS = EQUIPMENT_SETS
-- EQUIPMENT_SETS = E:StripString(EQUIPMENT_SETS)
-- EQUIPMENT_SETS = EQUIPMENT_SETS:gsub('%%s', '')
-- EQUIPMENT_SETS = E:EscapeString(EQUIPMENT_SETS)

local MAX_CONTAINER_ITEMS = 36
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER
local NUM_BANKGENERIC_SLOTS = NUM_BANKGENERIC_SLOTS
local GetContainerItemEquipmentSetInfo = GetContainerItemEquipmentSetInfo
local C_EquipmentSet_GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs
local C_EquipmentSet_GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo

--* Used this to help translate known texcoords to a |T |t string
-- CreateTextureMarkup('Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs', 64, 256, 0, 0, 0.01562500, 0.53125000, 0.46875000, 0.60546875, 0, 0)
-- CreateTextureMarkup(file, fileWidth, fileHeight, width, height, left, right, top, bottom, xOffset, yOffset)
-- 	return ("|T%s:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"):format(
-- 		file, height, width, xOffset or 0, yOffset or 0, fileWidth, fileHeight, left * fileWidth, right * fileWidth, top * fileHeight, bottom * fileHeight
-- 	);
-- end
-- local texture = '|TInterface\\PaperDollInfoFrame\\PaperDollSidebarTabs:20:20:0:0:64:256:1:34:120:155|t'

BI.equipmentmanager = {
	icons = {
		EQUIPMGR = 'Equipment Manager Icon |TInterface\\PaperDollInfoFrame\\PaperDollSidebarTabs:20:20:0:0:64:256:1:34:120:155|t',
		EQUIPLOCK = 'Equipment Lock Icon |TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\lock:14|t',
		NEWICON = 'New Feature Icon |TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14|t',
		CUSTOM = CUSTOM,
	},
	iconLocations = {
		EQUIPLOCK = [[Interface\AddOns\ElvUI_SLE\media\textures\lock]],
		NEWICON = [[Interface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon]],
	},
}

local function ConstructBagIcons()
	for _, f in pairs(B.BagFrames) do
		for _, bagID in next, f.BagIDs do
			for slotID = 1, MAX_CONTAINER_ITEMS do
				local button = f.Bags[bagID][slotID]

				if not button.equipIcon then
					button.equipIcon = button:CreateTexture(nil, 'OVERLAY')
					button.equipIcon:Hide()
				end
			end
		end
	end
end

function BI:UpdateAllBagSlots()
	for _, f in pairs(B.BagFrames) do
		for _, bagID in next, f.BagIDs do
			for slotID = 1, MAX_CONTAINER_ITEMS do
				BI:UpdateSlot(f, bagID, slotID)
			end
		end
	end
end

function BI:UpdateBagSlots(frame, bagID)
	if bagID ~= REAGENTBANK_CONTAINER then
		for slotID = 1, GetContainerNumSlots(bagID) do
			-- print('yo')
			BI:UpdateSlot(frame, bagID, slotID)
		end
	end
end

function BI:UpdateSlot(f, bagID, slotID)
	if not f.Bags[bagID] or not f.Bags[bagID][slotID] then
		return
	end

	local button = f.Bags[bagID][slotID]
	-- local link = GetContainerItemLink(bagID, slotID)

	if not button then return end
	if not button.equipIcon then ConstructBagIcons() end

	local isInSet, setName = GetContainerItemEquipmentSetInfo(bagID, slotID)

	button.equipIcon:SetShown(BI.db.enable and isInSet)
end

function BI:UpdateBagSettings()
	for _, f in pairs(B.BagFrames) do
		for _, bagID in next, f.BagIDs do
			for slotID = 1, MAX_CONTAINER_ITEMS do
				local button = f.Bags[bagID][slotID]
				if not button.equipIcon then return end

				button.equipIcon:SetSize(BI.db.size, BI.db.size)
				button.equipIcon:ClearAllPoints()
				button.equipIcon:Point(BI.db.point, BI.db.xOffset, BI.db.yOffset)

				if BI.db.icon == 'EQUIPMGR' then
					button.equipIcon:SetTexture('Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs')
					button.equipIcon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
				elseif BI.db.icon == 'CUSTOM' then
					button.equipIcon:SetTexture(BI.db.customTexture)
					button.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				else
					-- button.equipIcon:SetTexture(3547163)
					button.equipIcon:SetTexture(BI.equipmentmanager.iconLocations[BI.db.icon] or BI.db.icon)
					button.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				end

				-- button.equipIcon:SetVertexColor(1, .82, 0, 1)
				button.equipIcon:SetVertexColor(BI.db.color.r, BI.db.color.g, BI.db.color.b, BI.db.color.a)
			end
		end
	end
end

function BI:OnEventHook(frame, event, ...)
	if event == 'ITEM_LOCK_CHANGED' then
		BI:UpdateSlot(frame, ...)
	elseif event == 'BAG_UPDATE' then
		BI:UpdateBagSlots(frame, ...)
	elseif event == 'PLAYERBANKSLOTS_CHANGED' then
		local slot = ...
		local bagID = (slot <= NUM_BANKGENERIC_SLOTS) and -1 or (slot - NUM_BANKGENERIC_SLOTS)

		if bagID == -1 then
			BI:UpdateBagSlots(frame, -1)
		end
	elseif event == 'EQUIPMENT_SETS_CHANGED' then
		BI:UpdateAllBagSlots()
	elseif event == 'BAG_UPDATE_DELAYED' and (ElvUI_BankContainerFrame:IsShown() or ElvUI_ContainerFrame:IsShown()) then
		BI:UpdateAllBagSlots()
	end
end

hooksecurefunc(B, 'OnEvent', function(frame, event, ...)
	if not BI.db.enable then return end
	BI:OnEventHook(frame, event, ...)
end)

function BI:ToggleSettings()
	if BI.db.enable then
		BI:RegisterEvent('EQUIPMENT_SETS_CHANGED', function(event)
			BI:OnEventHook(nil, event)
		end)
		BI:RegisterEvent('BAG_UPDATE_DELAYED', function(event)
			BI:OnEventHook(nil, event)
		end)
	else
		BI:UnregisterEvent('EQUIPMENT_SETS_CHANGED')
		BI:UnregisterEvent('BAG_UPDATE_DELAYED')
	end

	BI:UpdateAllBagSlots()
end

function BI:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end
	BI.db = E.db.sle.bags.equipmentmanager

	--* May need to add these, just a note to check these if any weird reports of shit not updating as expected
	-- EQUIPMENT_SWAP_FINISHED
	-- PLAYER_EQUIPMENT_CHANGED

	ConstructBagIcons()
	function BI:ForUpdateAll()
		BI.db = E.db.sle.bags.equipmentmanager
		BI:UpdateBagSettings()
		BI:ToggleSettings()
	end
	BI:ForUpdateAll()

	BI.bankFirstOpen = false
	BI:RegisterEvent('BANKFRAME_OPENED', function()
		-- Update all bag slots on initial bank open so the bank has the icons on them
		if not BI.bankFirstOpen or not BI.db.enable then
			BI.bankFirstOpen = true
			BI:UpdateAllBagSlots()
		end
	end)


end

SLE:RegisterModule(BI:GetName())
