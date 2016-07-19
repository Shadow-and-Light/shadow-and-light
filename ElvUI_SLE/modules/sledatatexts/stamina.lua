local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DT = E:GetModule('DataTexts')
local STAMINA_COLON = STAMINA_COLON
local displayNumberString = ''
local lastPanel

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayNumberString, STAMINA_COLON, T.select(2, T.UnitStat("player", 3)))
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = T.join("", "%s ", hex, "%.f|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext('Stamina', { "UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)