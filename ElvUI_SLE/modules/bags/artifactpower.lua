local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local AP = SLE:NewModule("ArtifactPowerBags", 'AceHook-3.0', 'AceEvent-3.0')
local B = E:GetModule('Bags')

--GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local tooltipScanner
local tooltipName = "SLE_ArtifactPowerTooltipScanner"
local EMPOWERING_SPELL_ID = 227907
local empoweringSpellName
local arcanePower
local AP_NAME = format("%s|r", ARTIFACT_POWER)
local pcall = pcall
local GetItemSpell = GetItemSpell

-- local apLineIndex
local apItemCache = {}
local apStringValueMillion = {
	["enUS"] = "(%d*[%p%s]?%d+) million",
	["enGB"] = "(%d*[%p%s]?%d+) million",
	["ptBR"] = "(%d*[%p%s]?%d+) [[milhão][milhões]]?",
	["esMX"] = "(%d*[%p%s]?%d+) [[millón][millones]]?",
	["deDE"] = "(%d*[%p%s]?%d+) [[Million][Millionen]]?",
	["esES"] = "(%d*[%p%s]?%d+) [[millón][millones]]?",
	["frFR"] = "(%d*[%p%s]?%d+) [[million][millions]]?",
	["itIT"] = "(%d*[%p%s]?%d+) [[milione][milioni]]?",
	["ruRU"] = "(%d*[%p%s]?%d+) млн",
	["koKR"] = "(%d*[%p%s]?%d+)만",
	["zhTW"] = "(%d*[%p%s]?%d+)萬",
	["zhCN"] = "(%d*[%p%s]?%d+)万",
}
local apStringValueMillionLocal = apStringValueMillion[GetLocale()]
local function GetItemLinkArtifactPower(slotLink)
	local apValue
	if not slotLink then return nil end
	local itemSpell = GetItemSpell(slotLink)
	if itemSpell and itemSpell == empoweringSpellName then
		tooltipScanner:ClearLines()
		local success = pcall(tooltipScanner.SetHyperlink, tooltipScanner, slotLink)
		if (not success) then
			return nil
		end

		local apFound
		for i = 3, 7 do
			local tooltipText = _G[tooltipName.."TextLeft"..i]:GetText()
			if (tooltipText and not T.match(tooltipText, AP_NAME)) then
				local digit1, digit2, digit3, ap
				local value = T.match(tooltipText, apStringValueMillionLocal)

				if value then
					digit1, digit2 = T.match(value, "(%d+)[%p%s](%d+)")
					if digit1 and digit2 then
						ap = T.tonumber(T.format("%s.%s", digit1, digit2)) * 1e6 --Multiply by one million
					else
						ap = T.tonumber(value) * 1e6 --Multiply by one million
					end
				else
					digit1, digit2, digit3 = T.match(tooltipText,"(%d+)[%p%s]?(%d+)[%p%s]?(%d+)")
					ap = T.tonumber(T.format("%s%s%s", digit1 or "", digit2 or "", (digit2 and digit3) and digit3 or ""))
				end

				if ap then
					apValue = ap
					apValue = T.tonumber(apValue)
					apFound = true
					break
				end
			end
		end

		if (not apFound) then
			apItemCache[slotLink] = false --Cache item as not granting AP
		end
	else
		apItemCache[slotLink] = false --Cache item as not granting AP
	end

	return apValue
end


local function SlotUpdate(self, bagID, slotID)
	if (not bagID or not slotID) or bagID == -3 then return end
	if not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return;
	end
	
	local frame = self.Bags[bagID][slotID]
	if (not frame.artifactpowerinfo) and E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo = frame:CreateFontString(nil, 'OVERLAY')
		frame.artifactpowerinfo:Point("BOTTOMLEFT", 2, 2)
	end

	if E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo:FontTemplate(E.LSM:Fetch("font", E.db.sle.bags.artifactPower.fonts.font), E.db.sle.bags.artifactPower.fonts.size, E.db.sle.bags.artifactPower.fonts.outline)
		frame.artifactpowerinfo:SetText("")
		local r,g,b = E.db.sle.bags.artifactPower.color.r, E.db.sle.bags.artifactPower.color.g, E.db.sle.bags.artifactPower.color.b
		frame.artifactpowerinfo:SetTextColor(r, g, b)

		if (frame.artifactpowerinfo) then
			local ID = T.select(10, T.GetContainerItemInfo(bagID, slotID))
			local slotLink = T.GetContainerItemLink(bagID,slotID)
			if (ID and slotLink) then
				local arcanePower
				if apItemCache[slotLink] then
					if apItemCache[slotLink] ~= false then
						arcanePower = apItemCache[slotLink]
					end
				else
					arcanePower = GetItemLinkArtifactPower(slotLink)
					apItemCache[slotLink] = arcanePower
				end
				if E.db.sle.bags.artifactPower.short and arcanePower then arcanePower = E:ShortValue(arcanePower) end
				frame.artifactpowerinfo:SetText(arcanePower)
			end
		end
	elseif not E.db.sle.bags.artifactPower.enable and frame.artifactpowerinfo then
		frame.artifactpowerinfo:SetText("")
	end
end

function AP:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	tooltipScanner = CreateFrame("GameTooltip", tooltipName, nil, "GameTooltipTemplate")
	tooltipScanner:SetOwner(E.UIParent, "ANCHOR_NONE")
	empoweringSpellName = T.GetSpellInfo(EMPOWERING_SPELL_ID)

	hooksecurefunc(B,"UpdateSlot", SlotUpdate)
	hooksecurefunc(_G["ElvUI_ContainerFrame"],"UpdateSlot", SlotUpdate)
	self:RegisterEvent("BANKFRAME_OPENED", function()
		AP:UnregisterEvent("BANKFRAME_OPENED")
		B:Layout()
	end)
end
SLE:RegisterModule(AP:GetName())