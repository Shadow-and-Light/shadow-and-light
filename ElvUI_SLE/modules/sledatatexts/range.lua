local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local RC = LibStub("LibRangeCheck-2.0")
local displayString = ''
local lastPanel
local int = 1
local curMin, curMax
local updateTargetRange = false
local forceUpdate = false

local function OnUpdate(self, t)
	if not updateTargetRange then return end

	int = int - t
	if int > 0 then return end
	int = .25

	local min, max = RC:GetRange('target')
	if not forceUpdate and (min == curMin and max == curMax) then return end

	curMin = min
	curMax = max
	
	if min and max then
		self.text:SetFormattedText(displayString, "Range", min, max)
	else
		self.text:SetText(SPELL_FAILED_BAD_IMPLICIT_TARGETS)
	end
	forceUpdate = false	
	lastPanel = self
end

local function OnEvent(self, event)
	updateTargetRange = UnitName("target") ~= nil
	int = 0
	if updateTargetRange then
		forceUpdate = true
	else
		self.text:SetText(SPELL_FAILED_BAD_IMPLICIT_TARGETS)
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = string.join("", "%s: ", hex, "%d|r-", hex, "%d|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('S&L Target Range', {"PLAYER_TARGET_CHANGED"}, OnEvent, OnUpdate)