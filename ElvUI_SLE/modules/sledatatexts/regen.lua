local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local displayNumberString = ''
local lastPanel;
local join = string.join

local function OnEvent(self, event, unit)
	local baseMR, castingMR = GetManaRegen()
	if InCombatLockdown() then
		self.text:SetFormattedText(displayNumberString, "MP5", castingMR*5)
	else
		self.text:SetFormattedText(displayNumberString, "MP5", baseMR*5)
	end
	
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = join("", "%s: ", hex, "%.2f|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('MP5', {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)