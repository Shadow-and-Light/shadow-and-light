local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local AP = SLE:NewModule("ArtifactPowerBags", 'AceHook-3.0', 'AceEvent-3.0')
local B = E:GetModule('Bags')
local _G = _G
local tooltipScanner
local tooltipName = "ArtifactPowerTooltipScanner"
local EMPOWERING_SPELL_ID = 227907
local empoweringSpellName
local arcanePower
AP.containers = {}

local function GetItemLinkArtifactPower(slotLink)
	if slotLink then
		local itemSpell = GetItemSpell(slotLink)

		if itemSpell and itemSpell == empoweringSpellName then
			tooltipScanner:SetOwner(E.UIParent, "ANCHOR_NONE")
			tooltipScanner:SetHyperlink(slotLink)
			local tooltipText = _G[tooltipName.."TextLeft4"]:GetText()

			if(tooltipText == nil) then
				return nil
			end

			local ap = tooltipText:gsub("[,%.]", ""):match("%d.-%s") or ""

			tooltipScanner:Hide()			
			return tonumber(ap);
		else
			return nil
		end
	else
		return nil
	end
end

local bagUpdate = function(self)
	for _, container in T.pairs(AP.containers) do
		for _, bagID in T.ipairs(container.BagIDs) do
			for slotID = 1, T.GetContainerNumSlots(bagID) do
				local slotFrame = _G["ElvUI_ContainerFrameBag"..bagID.."Slot"..slotID]
				local slotLink = GetContainerItemLink(bagID,slotID)

				if not slotFrame.artifactpowerinfo then
					slotFrame.artifactpowerinfo = slotFrame:CreateFontString(nil, 'OVERLAY')
				end

				slotFrame.artifactpowerinfo:Point("BOTTOMRIGHT", 0, 2)
				slotFrame.artifactpowerinfo:FontTemplate(E.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				slotFrame.artifactpowerinfo:SetText("")
				slotFrame.artifactpowerinfo:SetAllPoints(slotFrame)
				slotFrame.artifactpowerinfo:SetTextColor(255, 0, 0)
				
				arcanePower = GetItemLinkArtifactPower(slotLink)

				if arcanePower then
					slotFrame.artifactpowerinfo:SetText(arcanePower)
				end
			end
		end
	end
end

function AP:ToggleSettings()
	self:RegisterEvent("BAG_UPDATE_DELAYED", bagUpdate)
	self:RegisterEvent("ARTIFACT_UPDATE", bagUpdate)
	self:RegisterEvent("BANKFRAME_OPENED", bagUpdate)
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", bagUpdate)
	self:RegisterEvent("BANKFRAME_CLOSED", bagUpdate)
	self:RegisterEvent("BAG_UPDATE", bagUpdate)
	self:RegisterEvent("ITEM_LOCKED", bagUpdate)
	self:RegisterEvent("ITEM_LOCK_CHANGED", bagUpdate)
end

function AP:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	tooltipScanner = CreateFrame("GameTooltip", tooltipName, nil, "GameTooltipTemplate")
	empoweringSpellName = GetSpellInfo(EMPOWERING_SPELL_ID)

	T.tinsert(AP.containers, _G["ElvUI_ContainerFrame"])
	self:SecureHook(B, "OpenBank", function()
		self:Unhook(B, "OpenBank")
		T.tinsert(AP.containers, _G["ElvUI_BankContainerFrame"])
		AP:ToggleSettings()
	end)

	AP:ToggleSettings()
end
SLE:RegisterModule(AP:GetName())