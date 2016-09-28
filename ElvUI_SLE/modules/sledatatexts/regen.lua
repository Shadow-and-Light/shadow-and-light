local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local MANA_REGEN = MANA_REGEN
local displayNumberString = ''
local displayNumberStringShort = ''
local lastPanel;
local GetManaRegen = GetManaRegen

local function OnEvent(self, event, unit)
	local baseMR, castingMR = GetManaRegen()
	if T.InCombatLockdown() then
		self.text:SetFormattedText(E.db.sle.dt.regen.short and displayNumberStringShort or displayNumberString, E.db.sle.dt.regen.short and "Mp5" or MANA_REGEN, E.db.sle.dt.regen.short and E:ShortValue(castingMR*5) or castingMR*5)
	else
		self.text:SetFormattedText(E.db.sle.dt.regen.short and displayNumberStringShort or displayNumberString, E.db.sle.dt.regen.short and "Mp5" or MANA_REGEN,  E.db.sle.dt.regen.short and E:ShortValue(baseMR*5) or baseMR*5)
	end
	
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = T.join("", "%s: ", hex, "%.2f|r")
	displayNumberStringShort = T.join("", "%s: ", hex, "%s|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext('Mana Regen', {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)