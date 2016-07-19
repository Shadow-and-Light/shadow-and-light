local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')
local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.character == true then return end
	if E.db.sle.Armory and not E.db.sle.Armory.Character.Enable then return end

	local slots = {
		"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot",
		"TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot",
		"Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot",
	}

	for _, slot in T.pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local cooldown = _G["Character"..slot.."Cooldown"]
		slot = _G["Character"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
		slot:SetTemplate("Default", true)
		icon:SetTexCoord(T.unpack(E.TexCoords))
		icon:SetInside()
		
		if(cooldown) then
			E:RegisterCooldown(cooldown)
		end
	end	

	local function ColorItemBorder()
		for _, slot in T.pairs(slots) do
			local target = _G["Character"..slot]
			local slotId, _, _ = T.GetInventorySlotInfo(slot)
			local itemId = T.GetInventoryItemID("player", slotId)

			if itemId then
				local rarity = T.GetInventoryItemQuality("player", slotId);
				if rarity and rarity > 1 then
					target:SetBackdropBorderColor(T.GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
				end
			else
				target:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)	
	_G["CharacterFrame"]:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()

	local charframe = {
		"CharacterModelFrame",
		"CharacterFrameInset", 
	}

	for _, object in T.pairs(charframe) do
		_G[object]:StripTextures()
	end
end

hooksecurefunc(S, "Initialize", LoadSkin)