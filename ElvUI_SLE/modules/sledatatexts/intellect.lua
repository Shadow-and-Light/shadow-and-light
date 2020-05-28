local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

-- GLOBALS: unpack, select, UnitStat, INTELLECT_COLON
local displayNumberString = ''
local lastPanel

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayNumberString, INTELLECT_COLON, select(2, UnitStat("player", 4)))
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = strjoin("", "%s ", hex, "%.f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext('Intellect', 'S&L', { "UNIT_STATS", "UNIT_AURA", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)
