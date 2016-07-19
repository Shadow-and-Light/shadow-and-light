local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local MANA_REGEN = MANA_REGEN
local displayNumberString = ''
local lastPanel;
local GetManaRegen = GetManaRegen

local function OnEvent(self, event, unit)
	local baseMR, castingMR = GetManaRegen()
	if T.InCombatLockdown() then
		self.text:SetFormattedText(displayNumberString, E.db.sle.dt.regen.short and "Mp5" or MANA_REGEN, castingMR*5)
	else
		self.text:SetFormattedText(displayNumberString, E.db.sle.dt.regen.short and "Mp5" or MANA_REGEN, baseMR*5)
	end
	
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = T.join("", "%s: ", hex, "%.2f|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext('Mana Regen', {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)