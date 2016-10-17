local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local AP = SLE:NewModule("ArtifactPowerBags", 'AceHook-3.0', 'AceEvent-3.0')
local B = E:GetModule('Bags')
local _G = _G
local tooltipScanner
local tooltipName = "SLE_ArtifactPowerTooltipScanner"
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
			if E.db.sle.bags.artifactPower.short then ap = E:ShortValue(ap) end
			return ap
		else
			return nil
		end
	else
		return nil
	end
end

local function UpdateContainerFrame(frame, bagID, slotID)
	if (not frame.artifactpowerinfo) and E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo = frame:CreateFontString(nil, 'OVERLAY')
		frame.artifactpowerinfo:Point("BOTTOMLEFT", 2, 2)
		--frame.artifactpowerinfo:SetAllPoints(frame)
	end

	if E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo:FontTemplate(E.LSM:Fetch("font", E.db.sle.bags.artifactPower.fonts.font), E.db.sle.bags.artifactPower.fonts.size, E.db.sle.bags.artifactPower.fonts.outline)
		frame.artifactpowerinfo:SetText("")
		local r,g,b = E.db.sle.bags.artifactPower.color.r, E.db.sle.bags.artifactPower.color.g, E.db.sle.bags.artifactPower.color.b
		frame.artifactpowerinfo:SetTextColor(r, g, b)

		if (frame.artifactpowerinfo) then
			local slotLink = GetContainerItemLink(bagID,slotID)


			arcanePower = GetItemLinkArtifactPower(slotLink)
			frame.artifactpowerinfo:SetText(arcanePower)
		end
	elseif not E.db.sle.bags.artifactPower.enable and frame.artifactpowerinfo then
		frame.artifactpowerinfo:SetText("")
	end
end

function AP:bagUpdate()
	for _, container in T.pairs(AP.containers) do
		for _, bagID in T.ipairs(container.BagIDs) do
			for slotID = 1, T.GetContainerNumSlots(bagID) do
				UpdateContainerFrame(container.Bags[bagID][slotID], bagID, slotID)

				-- local slotFrame = _G["ElvUI_ContainerFrameBag"..bagID.."Slot"..slotID]
				-- local slotLink = GetContainerItemLink(bagID,slotID)

				-- if not slotFrame.artifactpowerinfo then
				-- 	slotFrame.artifactpowerinfo = slotFrame:CreateFontString(nil, 'OVERLAY')
				-- end

				-- slotFrame.artifactpowerinfo:Point("BOTTOMRIGHT", 0, 2)
				-- slotFrame.artifactpowerinfo:FontTemplate(E.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				-- slotFrame.artifactpowerinfo:SetText("")
				-- slotFrame.artifactpowerinfo:SetAllPoints(slotFrame)
				-- slotFrame.artifactpowerinfo:SetTextColor(255, 0, 0)
				
				-- arcanePower = GetItemLinkArtifactPower(slotLink)

				-- if arcanePower then
				-- 	slotFrame.artifactpowerinfo:SetText(arcanePower)
				-- end
			end
		end
	end
end

function AP:ToggleSettings()
	self:RegisterEvent("BAG_UPDATE_DELAYED", "bagUpdate")
	self:RegisterEvent("ARTIFACT_UPDATE", "bagUpdate")
	self:RegisterEvent("BANKFRAME_OPENED", "bagUpdate")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "bagUpdate")
	self:RegisterEvent("BANKFRAME_CLOSED", "bagUpdate")
	self:RegisterEvent("BAG_UPDATE", "bagUpdate")
	self:RegisterEvent("ITEM_LOCKED", "bagUpdate")
	self:RegisterEvent("ITEM_LOCK_CHANGED", "bagUpdate")
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