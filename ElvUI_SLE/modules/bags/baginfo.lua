local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local BI = SLE.BagInfo
local B = E.Bags

local _G = _G
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
-- local C_Container_GetContainerItemEquipmentSetInfo = C_Container.GetContainerItemEquipmentSetInfo --* API is currently broken and have to use a work around for now
local CUSTOM = CUSTOM
-- local EQUIPMENT_SETS = EQUIPMENT_SETS
-- EQUIPMENT_SETS = E:StripString(EQUIPMENT_SETS)
-- EQUIPMENT_SETS = EQUIPMENT_SETS:gsub('%%s', '')
-- EQUIPMENT_SETS = E:EscapeString(EQUIPMENT_SETS)
local MATCH_EQUIPMENT_SETS = EQUIPMENT_SETS:gsub('%-','%%-'):gsub('%%s', '(.-)') --* Part of the workaround

--* Used this to help translate known texcoords to a |T |t string
-- CreateTextureMarkup('Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs', 64, 256, 0, 0, 0.01562500, 0.53125000, 0.46875000, 0.60546875, 0, 0)
-- CreateTextureMarkup(file, fileWidth, fileHeight, width, height, left, right, top, bottom, xOffset, yOffset)
-- 	return ("|T%s:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"):format(
-- 		file, height, width, xOffset or 0, yOffset or 0, fileWidth, fileHeight, left * fileWidth, right * fileWidth, top * fileHeight, bottom * fileHeight
-- 	)
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

function B:HideSet(slot, keep)
	if not slot or not slot.equipIcon then return end
	slot.equipIcon:Hide()

	if not keep and E:IsEventRegisteredForObject('EQUIPMENT_SETS_CHANGED', slot) then
		E:UnregisterEventForObject('EQUIPMENT_SETS_CHANGED', slot, B.UpdateSet)
	end
end

function B:UpdateSet(slot)
	slot = slot == 'EQUIPMENT_SETS_CHANGED' and self or slot
	if not slot or not slot.itemID then return end
	-- local isInSet, setName = C_Container.GetContainerItemEquipmentSetInfo(bagID, slotID)(slot.bagID, slot.slotID) --* API is currently broken

	--* Start - Part of the workaround
	local isInSet = false
	local tooltipData  = C_TooltipInfo.GetBagItem(slot.BagID, slot.SlotID)

	if slot.isEquipment and tooltipData then
		for _, line in ipairs(tooltipData.lines) do
			if (line and line.leftText) and strmatch(line.leftText, MATCH_EQUIPMENT_SETS) then
				isInSet = true
				break
			end
		end
	end
	--* End - Part of the workaround

	if isInSet then
		slot.equipIcon:SetShown(BI.db.enable)
	else
		B:HideSet(slot, true)
	end
end

local function updateSettings(slot)
	slot.equipIcon:SetSize(E.db.sle.bags.equipmentmanager.size, E.db.sle.bags.equipmentmanager.size)
	slot.equipIcon:ClearAllPoints()
	slot.equipIcon:Point(E.db.sle.bags.equipmentmanager.point, E.db.sle.bags.equipmentmanager.xOffset, E.db.sle.bags.equipmentmanager.yOffset)

	if E.db.sle.bags.equipmentmanager.icon == 'EQUIPMGR' then
		slot.equipIcon:SetTexture([[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]])
		slot.equipIcon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	elseif E.db.sle.bags.equipmentmanager.icon == 'CUSTOM' then
		slot.equipIcon:SetTexture(E.db.sle.bags.equipmentmanager.customTexture)
		slot.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	else
		slot.equipIcon:SetTexture(BI.equipmentmanager.iconLocations[E.db.sle.bags.equipmentmanager.icon] or E.db.sle.bags.equipmentmanager.icon)
		slot.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	end

	slot.equipIcon:SetVertexColor(E.db.sle.bags.equipmentmanager.color.r, E.db.sle.bags.equipmentmanager.color.g, E.db.sle.bags.equipmentmanager.color.b, E.db.sle.bags.equipmentmanager.color.a)
end

function BI:UpdateItemDisplay()
	if not E.private.bags.enable then return end

	for _, bagFrame in next, B.BagFrames do
		for _, bagID in next, bagFrame.BagIDs do
			for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.equipIcon then
					updateSettings(slot)
				end
			end
		end
	end
end

function BI:ConstructContainerButton(f, bagID, slotID)
	if not f then return end
	local bag = f.Bags[bagID]
	if not bag then return end
	local isReagent = bagID == REAGENTBANK_CONTAINER
	local slotName = isReagent and ('ElvUIReagentBankFrameItem'..slotID) or (bag.name..'Slot'..slotID)
	local slot = _G[slotName]
	BI.db = E.db.sle.bags.equipmentmanager

	if not slot.equipIcon then
		slot.equipIcon = slot:CreateTexture(nil, 'OVERLAY')
		updateSettings(slot)
		slot.equipIcon:Hide()
	end
end
hooksecurefunc(B, 'ConstructContainerButton', BI.ConstructContainerButton)

function BI:UpdateSlot(frame, bagID, slotID)
	local bag = frame.Bags[bagID]
	local slot = bag and bag[slotID]
	if not slot or not slot.equipIcon then return end

	if slot.isEquipment then
		B:UpdateSet(slot)

		if not E:IsEventRegisteredForObject('EQUIPMENT_SETS_CHANGED', slot) then
			E:RegisterEventForObject('EQUIPMENT_SETS_CHANGED', slot, B.UpdateSet)
		end
	else
		B:HideSet(slot)
	end
end
hooksecurefunc(B, 'UpdateSlot', BI.UpdateSlot)

function BI:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	function BI:ForUpdateAll()
		BI.db = E.db.sle.bags.equipmentmanager
		B:UpdateAllBagSlots(true)
	end
end

SLE:RegisterModule(BI:GetName())
