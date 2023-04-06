local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SB = SLE.Bags
local B = E.Bags

--GLOBALS: hooksecurefunc
local _G = _G
local Pr

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots

-- Updating slot for deconstruct glow hide when item disappears
function SB:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= C_Container_GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return
	end

	local slot = self.Bags[bagID][slotID]
	if not Pr then Pr = SLE.Professions end
	if not Pr.DeconstructionReal then return end
	if Pr.DeconstructionReal:IsShown() and Pr.DeconstructionReal.Bag == bagID and Pr.DeconstructionReal.Slot == slotID then
		if not slot.hasItem then
			GameTooltip_Hide()
			Pr.DeconstructionReal:OnLeave()
		end
	end
end

function SB:HookBags(isBank)
	for _, bagFrame in pairs(B.BagFrames) do
		--Hooking slots for deconstruct. Bank is not allowed
		if not bagFrame.SLE_DeconstructHooked and not isBank then
			hooksecurefunc(bagFrame, 'UpdateSlot', SB.UpdateSlot)
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
	SB:HookBags()
	hooksecurefunc(B, 'Layout', function(_, isBank)
		SB:HookBags(isBank)
	end)

	--This table is for initial update of a frame, cause applying transparent template breaks color borders
	SB.InitialUpdates = {
		Bank = false,
		ReagentBank = false,
		ReagentBankButton = false,
	}

	--Fix borders for bag frames
	hooksecurefunc(B, 'OpenBank', function()
		if not SB.InitialUpdates.Bank then --For bank, just update on first show
			B:Layout(true)
			SB.InitialUpdates.Bank = true
		end
		if not SB.InitialUpdates.ReagentBankButton then --For reagent bank, hook to toggle button and update layout when first clicked
			_G.ElvUI_BankContainerFrame.reagentToggle:HookScript('OnClick', function()
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
