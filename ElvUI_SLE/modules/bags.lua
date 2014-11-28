local E, L, V, P, G = unpack(ElvUI)
local SB = E:GetModule("SLE_Bags")
local B = E:GetModule('Bags')

function SB:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then		
		return; 
	end

	local slot = self.Bags[bagID][slotID];
	slot.shadow:Hide();
	E:StopFlash(slot.shadow);

	if (slot:IsShown() and C_NewItems.IsNewItem(bagID, slotID)) then
		SB:StartAnim(slot);
	end
end

function SB:UpdateReagentSlot(slotID)
	local bagID = REAGENTBANK_CONTAINER;
	local slot = _G["ElvUIReagentBankFrameItem"..slotID];
	if not slot then return end;
	slot.shadow:Hide();
	E:StopFlash(slot.shadow);

	if (slot:IsShown() and C_NewItems.IsNewItem(bagID, slotID)) then
		SB:StartAnim(slot);
	end
end

function SB:StartAnim(slot)
	slot.flashTex:Show();
	slot.flashAnim:Play();
	slot.glowAnim:Play();
end

function SB:StopAnim(slot)
	slot.flashTex:Hide();
	slot.flashAnim:Stop();
	slot.glowAnim:Stop();
end

function SB:HookSlot(slot, bagID, slotID)
	slot:HookScript('OnEnter', function()
		if (E.db.sle.bags.lootflash) then
			C_NewItems.RemoveNewItem(bagID, slotID);
			SB:StopAnim(slot);
		end
	end);

	slot:HookScript('OnShow', function()
		if (E.db.sle.bags.lootflash) then
			if (C_NewItems.IsNewItem(bagID, slotID)) then
				SB:StartAnim(slot);			
			else
				SB:StopAnim(slot);
			end
		end
	end);

	slot:HookScript('OnHide', function()
		if (E.db.sle.bags.lootflash) then
			C_NewItems.RemoveNewItem(bagID, slotID);
			SB:StopAnim(slot);
		end
	end);

	slot.flashTex = slot:CreateTexture('flashTex', 'OVERLAY', 1);
	slot.flashTex:SetBlendMode("ADD");
	slot.flashTex:SetTexture(.7, .7, .7);
	slot.flashTex:SetInside();
	slot.flashTex:SetAlpha(0);

	slot.shadow:SetAlpha(0);
	
	local flashAnimGroup = slot:CreateAnimationGroup("flashAnim");
	local flashAnim1 = flashAnimGroup:CreateAnimation("Alpha");
	flashAnim1:SetChildKey("flashTex");
	flashAnim1:SetFromAlpha(0);
	flashAnim1:SetToAlpha(1);
	--flashAnim1:SetSmoothing("IN");
	flashAnim1:SetDuration(0.2);
	flashAnim1:SetOrder(1);
	local flashAnim2 = flashAnimGroup:CreateAnimation("Alpha");
	flashAnim2:SetChildKey("flashTex");
	flashAnim2:SetFromAlpha(1);
	flashAnim2:SetToAlpha(0);
	--flashAnim2:SetSmoothing("OUT");
	flashAnim2:SetDuration(0.2);
	flashAnim2:SetOrder(2);
	slot.flashAnim = flashAnimGroup;

	local glowAnimGroup = slot:CreateAnimationGroup("NewItemGlow");
	glowAnimGroup:SetLooping("REPEAT");
	local glowFlash1 = glowAnimGroup:CreateAnimation("Alpha");
	glowFlash1:SetChildKey("backdrop");
	--glowFlash1:SetStartDelay(0.4);
	glowFlash1:SetDuration(0.8);
	glowFlash1:SetOrder(1);
	glowFlash1:SetFromAlpha(1);
	glowFlash1:SetToAlpha(0.4);

	local glowFlash2 = glowAnimGroup:CreateAnimation("Alpha");
	glowFlash2:SetChildKey("backdrop");
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
	if not E.private.bags.enable then return end
	local BUpdateSlot = B.UpdateSlot;
	local SBUpdateSlot = SB.UpdateSlot;
	for _, bagFrame in pairs(B.BagFrames) do
		local UpdateSlot = function(self, bagID, slotID)
			BUpdateSlot(bagFrame, bagID, slotID);
			if (E.db.sle.bags.lootflash) then
				SBUpdateSlot(bagFrame, bagID, slotID);
			end
		end
		bagFrame.UpdateSlot = UpdateSlot;
		local BUpdateReagentSlot = B.UpdateReagentSlot;
		local SBUpdateReagentSlot = SB.UpdateReagentSlot;
		local UpdateReagentSlot = function(self, slotID)
			BUpdateReagentSlot(bagFrame, slotID);
			if (E.db.sle.bags.lootflash) then
				SBUpdateReagentSlot(bagFrame, slotID);
			end
		end
		bagFrame.UpdateReagentSlot = UpdateReagentSlot;
	end
	self:HookBags();
	hooksecurefunc(B, "Layout", function()
		self:HookBags()
	end);
end