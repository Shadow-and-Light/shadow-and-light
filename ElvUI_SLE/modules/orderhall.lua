local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local OH = SLE:NewModule("OrderHall", 'AceEvent-3.0')
local _G = _G
local C_Garrison = C_Garrison
local PowerButton_OnClick, OnRelicSlotClicked

function OH:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
	if not _G["GarrisonCapacitiveDisplayFrame"] then return end --Just in case
	if not C_Garrison.IsPlayerInGarrison(3) then return end
	local n = _G["GarrisonCapacitiveDisplayFrame"].available or 0
	if OH.clicked or n == 0 or not OH.db.autoOrder.enable then return end
	OH.clicked = true
	local _, _, _, _, followerID = C_Garrison.GetShipmentItemInfo()
	if followerID then
		_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
	else
		if OH.db.autoOrder.autoEquip then
			_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
		end
	end
end

function OH:SHIPMENT_CRAFTER_CLOSED()
	OH.clicked = false
end

--Based on ArtifactTraitLink by Ketho
function OH:ArtClickHook(event, addon)
	if addon == "Blizzard_ArtifactUI" then
		PowerButton_OnClick = ArtifactPowerButtonMixin.OnClick
		-- rather prehook than posthook to prevent purchasing traits
		function ArtifactPowerButtonMixin:OnClick(button)
			if IsModifiedClick("CHATLINK") then
				ChatEdit_InsertLink(GetSpellLink(self.spellID))
			else
				PowerButton_OnClick(self, button)
			end
		end

		OnRelicSlotClicked = ArtifactTitleTemplateMixin.OnRelicSlotClicked
		-- ArtifactTitleTemplateMixin.OnRelicSlotClicked
		function ArtifactFrame.PerksTab.TitleContainer:OnRelicSlotClicked(relicSlot)
			if IsModifiedClick("CHATLINK") then
				for i = 1, #self.RelicSlots do
					if self.RelicSlots[i] == relicSlot then
						ChatEdit_InsertLink( select(4, C_ArtifactUI.GetRelicInfo(i)) )
						break
					end
				end
			else
				OnRelicSlotClicked(self, relicSlot)
			end
		end
		OH:UnregisterEvent(event)
	end
end

function OH:CreateArtifactButton()
	OH.ArtifactButton = CreateFrame("Button", "SLE_ArtifactButton", E.UIParent)
end

function OH:Initialize()
	if not SLE.initialized then return end
	OH.db = E.db.sle.orderhall
	OH.clicked = false

	function OH:ForUpdateAll()
		OH.db = E.db.sle.orderhall
	end

	if E.global.sle.LinkArtifactTrait then
		self:RegisterEvent("ADDON_LOADED", "ArtClickHook")
	end

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end

SLE:RegisterModule(OH:GetName())