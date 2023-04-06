local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DT = E.DataTexts
local RC = E.Libs.RangeCheck

local UnitName = UnitName
local SPELL_FAILED_BAD_IMPLICIT_TARGETS = SPELL_FAILED_BAD_IMPLICIT_TARGETS

local displayString = ''
local curMin, curMax
local int = 1
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
		self.text:SetFormattedText(displayString, L["Range"], min, max)
	else
		self.text:SetText(SPELL_FAILED_BAD_IMPLICIT_TARGETS)
	end
	forceUpdate = false
end

local function OnEvent(self)
	updateTargetRange = UnitName("target") ~= nil
	int = 0
	if updateTargetRange then
		forceUpdate = true
	else
		self.text:SetText(SPELL_FAILED_BAD_IMPLICIT_TARGETS)
	end
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', '%s: ', hex, '%d|r-', hex, '%d|r')
	OnEvent(self)
end

DT:RegisterDatatext('S&L Target Range', 'S&L', {'PLAYER_TARGET_CHANGED'}, OnEvent, OnUpdate, nil, nil, nil, nil, nil, ValueColorUpdate)
