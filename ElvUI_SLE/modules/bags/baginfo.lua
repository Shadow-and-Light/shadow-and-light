local SLE, _, E = unpack(select(2, ...))
local BI = SLE:NewModule('BagInfo', 'AceHook-3.0', 'AceEvent-3.0')
local B = E:GetModule('Bags')

local _G = _G
local GetContainerNumSlots = GetContainerNumSlots
local CUSTOM = CUSTOM
local EQUIPMENT_SETS = EQUIPMENT_SETS

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

local function SetupBags()
	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local button = bagFrame.Bags[bagID][slotID]

				if not button.equipIcon then
					button.equipIcon = button:CreateTexture(nil, 'OVERLAY')
					button.equipIcon:Hide()
				end
			end
		end
	end
end

function BI:UpdateEquipment()
	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local button = bagFrame.Bags[bagID][slotID]
				if not button.equipIcon then
					SetupBags()
					BI:UpdateSettings()
				end
				button.equipIcon:SetShown(BI:CheckVisibility(bagFrame, bagID, slotID))
			end
		end
	end
end

function BI:CheckVisibility(bagFrame, bagID, slotID)
	if not bagFrame or not bagID or not slotID then return end
	local button = bagFrame.Bags[bagID][slotID]
	local show = false

	E.ScanTooltip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
	if button.GetInventorySlot then -- this fixes bank bagid -1
		E.ScanTooltip:SetInventoryItem('player', button:GetInventorySlot())
	else
		E.ScanTooltip:SetBagItem(bagID, slotID)
	end
	E.ScanTooltip:Show()

	for i = 3, E.ScanTooltip:NumLines() do
		local str = _G['ElvUI_ScanTooltipTextLeft' .. i]
		local text = str and str:GetText()

		if not text or text == '' then return end

		if text:find(EQUIPMENT_SETS:gsub('%%s','.-')) then
			show = true
		end
	end
	E.ScanTooltip:Hide()
	return E.db.sle.bags.equipmentmanager.enable and show
end

function BI:ToggleSettings()
	if E.private.sle.equip.setoverlay then
		BI:RegisterEvent('EQUIPMENT_SETS_CHANGED', BI.UpdateEquipment)
		BI:RegisterEvent('BAG_UPDATE', BI.UpdateEquipment)
		BI:RegisterEvent('PLAYERBANKSLOTS_CHANGED', BI.UpdateEquipment)
	else
		BI:UnregisterEvent('EQUIPMENT_SETS_CHANGED')
		BI:UnregisterEvent('BAG_UPDATE')
		BI:UnregisterEvent('PLAYERBANKSLOTS_CHANGED')
	end

	BI:UpdateEquipment()
end

function BI:UpdateSettings()
	local db = E.db.sle.bags.equipmentmanager
	local texture = db.icon

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local button = bagFrame.Bags[bagID][slotID]
				button.equipIcon:SetSize(db.size, db.size)
				button.equipIcon:ClearAllPoints()
				button.equipIcon:Point(db.point, db.xOffset, db.yOffset)

				if texture == 'EQUIPMGR' then
					button.equipIcon:SetTexture('Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs')
					button.equipIcon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
				elseif texture == 'CUSTOM' then
					button.equipIcon:SetTexture(db.customTexture)
					button.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				else
					-- button.equipIcon:SetTexture(3547163)
					button.equipIcon:SetTexture(BI.equipmentmanager.iconLocations[texture] or texture)
					button.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
				end

				-- button.equipIcon:SetVertexColor(1, .82, 0, 1)
				button.equipIcon:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
			end
		end
	end
end

function BI:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	SetupBags()
	BI:UpdateSettings()
	BI:ToggleSettings()
	hooksecurefunc(B, 'OpenBank', function()
		SetupBags()
		BI:UpdateSettings()
		BI:ToggleSettings()
	end)
end

SLE:RegisterModule(BI:GetName())
