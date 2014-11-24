local E, L, V, P, G = unpack(ElvUI)
local SB = E:GetModule("SLE_Bags")
local B = E:GetModule('Bags')

function SB:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then		
		return; 
	end

	local slot = self.Bags[bagID][slotID];

	E:StopFlash(slot.shadow);

	if (slot:IsShown() and C_NewItems.IsNewItem(bagID, slotID)) then
		SB:StartAnim(slot);
	end
end

function SB:UpdateReagentSlot(slotID)
	local bagID = REAGENTBANK_CONTAINER;
	local slot = _G["ElvUIReagentBankFrameItem"..slotID];
	if not slot then return end;

	E:StopFlash(slot.shadow);

	if (slot:IsShown() and C_NewItems.IsNewItem(bagID, slotID)) then
		SB:StartAnim(slot);
	end
end

function SB:StartAnim(slot)
	slot.shadow:Show();
	slot.flashTex:Show();
	slot.flashAnim:Play();
	slot.glowAnim:Play();
end

function SB:StopAnim(slot)
	slot.shadow:Hide();
	slot.flashTex:Hide();
	slot.flashAnim:Stop();
	slot.glowAnim:Stop();
end

function SB:HookSlot(slot, bagID, slotID)
	slot:HookScript('OnEnter', function()
		C_NewItems.RemoveNewItem(bagID, slotID);
		SB:StopAnim(slot);
	end);

	slot:HookScript('OnShow', function()
		if (C_NewItems.IsNewItem(bagID, slotID)) then
			SB:StartAnim(slot);			
		else
			SB:StopAnim(slot);
		end
	end);

	slot:HookScript('OnHide', function()
		C_NewItems.RemoveNewItem(bagID, slotID);
		SB:StopAnim(slot);
	end);

	slot.flashTex = slot:CreateTexture('flashTex', 'OVERLAY', 1);
	slot.flashTex:SetBlendMode("ADD");
	slot.flashTex:SetAtlas("bags-glow-flash");
	slot.flashTex:SetAllPoints();
	slot.flashTex:SetAlpha(0);

	slot.shadow:SetAlpha(0);
	
	local flashAnimGroup = slot:CreateAnimationGroup("flashAnim");
	local flashAnim = flashAnimGroup:CreateAnimation("Alpha");
	flashAnim:SetChildKey("flashTex");
	flashAnim:SetFromAlpha(1);
	flashAnim:SetToAlpha(0);
	flashAnim:SetSmoothing("OUT");
	flashAnim:SetDuration(0.6);
	flashAnim:SetOrder(1);
	slot.flashAnim = flashAnimGroup;

	local glowAnimGroup = slot:CreateAnimationGroup("NewItemGlow");
	glowAnimGroup:SetLooping("REPEAT");
	local glowFlash1 = glowAnimGroup:CreateAnimation("Alpha");
	glowFlash1:SetChildKey("shadow");
	glowFlash1:SetDuration(0.8);
	glowFlash1:SetOrder(1);
	glowFlash1:SetFromAlpha(1);
	glowFlash1:SetToAlpha(0.4);

	local glowFlash2 = glowAnimGroup:CreateAnimation("Alpha");
	glowFlash2:SetChildKey("shadow");
	glowFlash2:SetDuration(0.8);
	glowFlash2:SetOrder(2);
	glowFlash2:SetFromAlpha(0.4);
	glowFlash2:SetToAlpha(1);

	slot.glowAnim = glowAnimGroup;
end

function SB:HookBags()
	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in pairs(bagFrame.BagIDs) do
			if (not self.hookedBags[bagID]) then
				for slotID = 1, GetContainerNumSlots(bagID) do
					local slot = bagFrame.Bags[bagID][slotID];
					self:HookSlot(slot, bagID, slotID);
				end
				self.hookedBags[bagID] = true;
			end
		end
	end

	if (ElvUIReagentBankFrameItem1 and not self.hookedBags[REAGENTBANK_CONTAINER]) then
		for slotID = 1, 98 do
			local slot = _G["ElvUIReagentBankFrameItem"..slotID];
			self:HookSlot(slot, REAGENTBANK_CONTAINER, slotID);
		end
		self.hookedBags[REAGENTBANK_CONTAINER] = true;
	end
end

function SB:Initialize()
	self.hookedBags = {};
	local BUpdateSlot = B.UpdateSlot;
	local SBUpdateSlot = SB.UpdateSlot;
	for _, bagFrame in pairs(B.BagFrames) do
		local UpdateSlot = function(self, bagID, slotID)
			BUpdateSlot(bagFrame, bagID, slotID);
			SBUpdateSlot(bagFrame, bagID, slotID);
		end
		bagFrame.UpdateSlot = UpdateSlot;
		local BUpdateReagentSlot = B.UpdateReagentSlot;
		local SBUpdateReagentSlot = SB.UpdateReagentSlot;
		local UpdateReagentSlot = function(self, slotID)
			BUpdateReagentSlot(bagFrame, slotID);
			SBUpdateReagentSlot(bagFrame, slotID);
		end
		bagFrame.UpdateReagentSlot = UpdateReagentSlot;
	end
	self:HookBags();
	hooksecurefunc(B, "Layout", function()
		self:HookBags()
	end);
end