local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:NewModule('CharacterFrameOptions', 'AceHook-3.0', 'AceEvent-3.0');

function CFO:ToggleCFO()
	self:UpdateItemDurability()
	self:UpdateItemLevel()
	self:UpdateItemEnchants()
end

function CFO:OnShowEquipmentChange()
	CFO:UpdateItemLevel()
	CFO:UpdateItemEnchants()
end

function CFO:Initialize()
	if not E.private.sle.characterframeoptions.enable then return; end
	_G["CharacterFrame"]:HookScript("OnShow", function(self)
		CFO:UpdateItemDurability()
		CFO:UpdateItemLevel()
		CFO:UpdateItemEnchants()
	end)

	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "OnShowEquipmentChange")
	--self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemLevel")
	--self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemMods")
	self:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE", "UpdateItemLevel")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdateItemDurability")
	
	self:LoadDurability()
	self:LoadItemLevel()
	self:LoadItemEnchants()
end

E:RegisterModule(CFO:GetName())