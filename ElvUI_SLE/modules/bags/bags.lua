local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SB = SLE:NewModule("Bags", 'AceHook-3.0')
local Pr
local B = E:GetModule('Bags')
--GLOBALS: hooksecurefunc
local _G = _G
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER

function SB:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= T.GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return;
	end

	local slot = self.Bags[bagID][slotID];
	if not Pr then Pr = SLE:GetModule("Professions") end
	if not Pr.DeconstructionReal then return end
	if Pr.DeconstructionReal:IsShown() and not slot.hasItem then
		B:Tooltip_Hide()
		Pr.DeconstructionReal:OnLeave()
	end
end

function SB:UpdateReagentSlot(slotID)
	local bagID = REAGENTBANK_CONTAINER;
	local slot = _G["ElvUIReagentBankFrameItem"..slotID];
	if not slot then return end;
end

function SB:HookSlot(slot, bagID, slotID)
	if bagID == REAGENTBANK_CONTAINER and E.private.sle.bags.transparentSlots and not slot.SLErarity then
			slot.SLErarity = true
			B:UpdateReagentSlot(slotID)
	end
end

function SB:HookBags(isBank, force)
	local slot
	for _, bagFrame in T.pairs(B.BagFrames) do
		for _, bagID in T.pairs(bagFrame.BagIDs) do
			if (not self.hookedBags[bagID])then
				for slotID = 1, T.GetContainerNumSlots(bagID) do
					if bagFrame.Bags[bagID] then
						slot = bagFrame.Bags[bagID][slotID];
						self:HookSlot(slot, bagID, slotID);
					end
				end
				self.hookedBags[bagID] = true;
			elseif self.hookedBags[bagID] and force then
				for slotID = 1, T.GetContainerNumSlots(bagID) do
					if bagFrame.Bags[bagID] then
						if force == bagFrame.Bags[bagID][slotID] then self:HookSlot(force, bagID, slotID) end
					end
				end
			end
			for slotID = 1, T.GetContainerNumSlots(bagID) do
				if bagFrame.Bags[bagID] then
					slot = bagFrame.Bags[bagID][slotID];
					if slot.template ~= "Transparent" and E.private.sle.bags.transparentSlots then slot:SetTemplate('Transparent') end
				end
			end
		end
	end

	if (_G["ElvUIReagentBankFrameItem1"] and not self.hookedBags[REAGENTBANK_CONTAINER]) then
		for slotID = 1, 98 do
			local slot = _G["ElvUIReagentBankFrameItem"..slotID];
			self:HookSlot(slot, REAGENTBANK_CONTAINER, slotID);
			if slot.template ~= "Transparent" and E.private.sle.bags.transparentSlots then slot:SetTemplate('Transparent') end
		end
		self.hookedBags[REAGENTBANK_CONTAINER] = true;
	end
end

function SB:Initialize()
	self.hookedBags = {};
	if not SLE.initialized or not E.private.bags.enable then return end

	function SB:ForUpdateAll()
		SB.db = E.db.sle.bags
	end
	SB:ForUpdateAll()

	local BUpdateSlot = B.UpdateSlot;
	self:HookBags();
	hooksecurefunc(B, "Layout", function()
		self:HookBags()
	end);
end

SLE:RegisterModule(SB:GetName())