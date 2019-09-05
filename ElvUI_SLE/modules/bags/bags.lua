local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SB = SLE:NewModule("Bags", 'AceHook-3.0')
local Pr
local B = E:GetModule('Bags')
--GLOBALS: hooksecurefunc
local _G = _G

--Updating slot for deconstruct glow hide when item disappears
function SB:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= T.GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return;
	end

	local slot = self.Bags[bagID][slotID];
	if not Pr then Pr = SLE:GetModule("Professions") end
	if not Pr.DeconstructionReal then return end
	if Pr.DeconstructionReal:IsShown() and Pr.DeconstructionReal.Bag == bagID and Pr.DeconstructionReal.Slot == slotID then
		if not slot.hasItem then
			GameTooltip_Hide()
			Pr.DeconstructionReal:OnLeave()
		end
	end
end

function SB:HookBags(isBank)
	local slot
	for _, bagFrame in T.pairs(B.BagFrames) do
		--Hooking slots for deconstruct. Bank is not allowed
		if not bagFrame.SLE_DeconstructHooked and not isBank then
			hooksecurefunc(bagFrame, "UpdateSlot", SB.UpdateSlot)
			bagFrame.SLE_UpdateHooked = true
		end
	end
end

function SB:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	function SB:ForUpdateAll()
		SB.db = E.db.sle.bags
	end
	SB:ForUpdateAll()

	--Applying stuff to already existing bags
	self:HookBags();
	hooksecurefunc(B, "Layout", function(self, isBank)
		SB:HookBags(isBank)
	end);

	--This table is for initial update of a frame, cause applying transparent trmplate breaks color borders
	SB.InitialUpdates = {
		Bank = false,
		ReagentBank = false,
		ReagentBankButton = false,
	}

	--Fix borders for bag frames
	hooksecurefunc(B, "OpenBank", function()
		if not SB.InitialUpdates.Bank then --For bank, just update on first show
			B:Layout(true)
			SB.InitialUpdates.Bank = true
		end
		if not SB.InitialUpdates.ReagentBankButton then --For reagent bank, hook to toggle button and update layout when first clicked
			_G["ElvUI_BankContainerFrame"].reagentToggle:HookScript("OnClick", function()
				if not SB.InitialUpdates.ReagentBank then
					B:Layout(true)
					SB.InitialUpdates.ReagentBank = true
				end
			end)
			SB.InitialUpdates.ReagentBankButton = true
		end
	end)
end

SLE:RegisterModule(SB:GetName())
