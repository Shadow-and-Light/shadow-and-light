local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")

local durabilitySlots = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot",
	"ShirtSlot","TabardSlot","MainHandSlot","SecondaryHandSlot","HandsSlot","WaistSlot",
	"LegsSlot","FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot"
}

function CFO:UpdateItemDurability()
	local frame = _G["CharacterFrame"]
	if not frame:IsShown() then return end
	
	local slot, current, maximum, r, g, b
	for i = 1, #durabilitySlots do
		frame = _G[("Character%s"):format(durabilitySlots[i])]
		frame.ItemDurability:SetText()
		slot = GetInventorySlotInfo(durabilitySlots[i])
		current, maximum = GetInventoryItemDurability(slot)
		if current and maximum and current < maximum then
			r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			frame.ItemDurability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
		end
		if not E.db.sle.characterframeoptions.itemdurability.enable then
			frame.ItemDurability:Hide()
		else
			frame.ItemDurability:Show()
		end
	end
end

function CFO:UpdateItemDurabilityFont()
	local frame
	for i = 1, #durabilitySlots do
		frame = _G[("Character%s"):format(durabilitySlots[i])]
		frame.ItemDurability:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemdurability.font), E.db.sle.characterframeoptions.itemdurability.fontSize, E.db.sle.characterframeoptions.itemdurability.fontOutline)
	end
end

function CFO:LoadDurability()
	_G["CharacterFrame"]:HookScript("OnShow", function(self)
		CFO:UpdateItemDurability()
	end)

	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdateItemDurability")

	local frame
	for i = 1, #durabilitySlots do
		frame = _G[("Character%s"):format(durabilitySlots[i])]
		frame.ItemDurability = frame:CreateFontString(nil, "OVERLAY")
		frame.ItemDurability:SetPoint("BOTTOM", frame, "BOTTOM", 2, 2)
		frame.ItemDurability:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemdurability.font), E.db.sle.characterframeoptions.itemdurability.fontSize, E.db.sle.characterframeoptions.itemdurability.fontOutline)
	end
end