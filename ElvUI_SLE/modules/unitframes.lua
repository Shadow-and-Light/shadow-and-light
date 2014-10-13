local E, L, V, P, G = unpack(ElvUI);
if not E.private.unitframe.enable then return end
local UF = E:GetModule('UnitFrames');
local SLE = E:GetModule('SLE');
local RC = LibStub("LibRangeCheck-2.0")
local format = format

--Replacement of text formats on unitframes.
local styles = {
	['CURRENT'] = '%s',
	['CURRENT_MAX'] = '%s - %s',
	['CURRENT_PERCENT'] =  '%s - %s%%',
	['CURRENT_MAX_PERCENT'] = '%s - %s | %s%%',
	['DEFICIT'] = '-%s'
}

local function GetFormattedTextSLE(style, min, max)
	assert(styles[style], 'Invalid format style: '..style)
	assert(min, 'You need to provide a current value. Usage: E:GetFormattedText(style, min, max)')
	assert(max, 'You need to provide a maximum value. Usage: E:GetFormattedText(style, min, max)')

	if max == 0 then max = 1 end

	local useStyle = styles[style]

	if style == 'DEFICIT' then
		local deficit = max - min
		if deficit <= 0 then
			return ''
		else
			return format(useStyle, deficit)
		end
	elseif style == 'CURRENT' or ((style == 'CURRENT_MAX' or style == 'CURRENT_MAX_PERCENT' or style == 'CURRENT_PERCENT') and min == max) then
			return format(styles['CURRENT'], min)
	elseif style == 'CURRENT_MAX' then
			return format(useStyle, min, max)
	elseif style == 'CURRENT_PERCENT' then
			return format(useStyle, min, format("%.1f", min / max * 100))
	elseif style == 'CURRENT_MAX_PERCENT' then
			return format(useStyle, min, max, format("%.1f", min / max * 100))
	end
end

--New Tags
local function AddTags()

	ElvUF.Tags.Events['vengeance:current:sl'] = 'UNIT_AURA'
	ElvUF.Tags.Methods['vengeance:current:sl'] = function(unit)
		local SPELL_VENGEANCE_NAME = (GetSpellInfo(93098))
		local veng = select(15, UnitAura(unit, SPELL_VENGEANCE_NAME, nil, 'HELPFUL')) or 0
		if (veng > 999999) then
			veng = math.floor(veng/1000000) .. "m"
		elseif (veng > 999) then
			veng = math.floor(veng/1000) .. "k"
		end
		if veng == 0 then
			return ' '
		else
			return veng
		end
	end

	ElvUF.Tags.Events['resolve:current-percent:sl'] = 'UNIT_AURA'
	ElvUF.Tags.Methods['resolve:current-percent:sl'] = function(unit)
	local SPELL_RESOLVE_NAME = GetSpellInfo(158300)
	--/run print(GetSpellInfo(158300))
	--/run print(UnitAura('player', 'Resolve', nil, 'HELPFUL'))
	end

	ElvUF.Tags.Methods['range:sl'] = function(unit)
		local name, server = UnitName(unit)
		local rangeText = ''
		local min, max = RC:GetRange(unit)
		curMin = min
		curMax = max

		if(server and server ~= "") then
			name = format("%s-%s", name, server)
		end

		if min and max and (name ~= UnitName('player')) then
			rangeText = curMin.."-"..curMax
		end
		return rangeText
	end

	ElvUF.Tags.Events['health:current:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
	ElvUF.Tags.Methods['health:current:sl'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD
	
		if (status) then
			return status
		else
			return GetFormattedTextSLE('CURRENT', min, max)
		end
	end

	ElvUF.Tags.Events['health:deficit:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
	ElvUF.Tags.Methods['health:deficit:sl'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

		if (status) then
			return status
		else
			return GetFormattedTextSLE('DEFICIT', min, max)
		end
	end

	ElvUF.Tags.Events['health:current-percent:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
	ElvUF.Tags.Methods['health:current-percent:sl'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

		if (status) then
			return status
		else
			return GetFormattedTextSLE('CURRENT_PERCENT', min, max)
		end
	end

	ElvUF.Tags.Events['health:current-max:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
	ElvUF.Tags.Methods['health:current-max:sl'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

		if (status) then
			return status
		else
			return GetFormattedTextSLE('CURRENT_MAX', min, max)
		end
	end

	ElvUF.Tags.Events['health:current-max-percent:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
	ElvUF.Tags.Methods['health:current-max-percent:sl'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

		if (status) then
			return status
		else
			return GetFormattedTextSLE('CURRENT_MAX_PERCENT', min, max)
		end
	end

	ElvUF.Tags.Events['power:current:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
	ElvUF.Tags.Methods['power:current:sl'] = function(unit)
		local pType = UnitPowerType(unit)
		local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)

		if min == 0 then
			return ' '
		else
			return GetFormattedTextSLE('CURRENT', min, max)
		end
	end

	ElvUF.Tags.Events['power:current-max:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
	ElvUF.Tags.Methods['power:current-max:sl'] = function(unit)
		local pType = UnitPowerType(unit)
		local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)

		if min == 0 then
			return ' '
		else
			return GetFormattedTextSLE('CURRENT_MAX', min, max)
		end
	end

	ElvUF.Tags.Events['power:current-percent:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
	ElvUF.Tags.Methods['power:current-percent:sl'] = function(unit)
		local pType = UnitPowerType(unit)
		local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)

		if min == 0 then
			return ' '
		else
			return GetFormattedTextSLE('CURRENT_PERCENT', min, max)
		end
	end

	ElvUF.Tags.Events['power:current-max-percent:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
	ElvUF.Tags.Methods['power:current-max-percent:sl'] = function(unit)
		local pType = UnitPowerType(unit)
		local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)

		if min == 0 then
			return ' '
		else
			return GetFormattedTextSLE('CURRENT_MAX_PERCENT', min, max)
		end
	end

	ElvUF.Tags.Events['power:deficit:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
	ElvUF.Tags.Methods['power:deficit:sl'] = function(unit)
		local pType = UnitPowerType(unit)
		local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)

		return GetFormattedTextSLE('DEFICIT', min, max, r, g, b)
	end
end
AddTags()

--Player Frame Enhancements
function UF:Update_CombatIndicator()
	local CombatText = ElvUF_Player.Combat
	if E.db.sle.combatico.pos == "NONE" then
		CombatText:ClearAllPoints()
	else
		local x, y = UF:GetPositionOffset(E.db.sle.combatico.pos)
		CombatText:ClearAllPoints()
		CombatText:Point(E.db.sle.combatico.pos, ElvUF_Player.Health, E.db.sle.combatico.pos, x, x)
	end
	SLE:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

local function EclipseTextSLE()
	local eclipseBar = ElvUF_Player.EclipseBar
	local spower = UnitPower( PlayerFrame.unit, SPELL_POWER_ECLIPSE );
	if E.db.sle.powtext then
		eclipseBar.powtext:SetText(spower)
	else
		eclipseBar.powtext:SetText('')
	end
end

local function DFTextSLE()
	local ShardBar = ElvUF_Player.ShardBar
	local dfpower = UnitPower( PlayerFrame.unit, SPELL_POWER_DEMONIC_FURY );
	local hasspec = GetSpecialization(false, false)
	if hasspec == nil then return end
	local index = select(1, GetSpecializationInfo(GetSpecialization(false, false, active)), false, false)
	if index == 266 then --This crap is checking the spec.
		if E.db.sle.powtext then
			ShardBar.powtext:SetText(dfpower)
			if E.db.unitframe.units.player.classbar.fill == "spaced" then
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("LEFT", ShardBar, "RIGHT")
			else
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("CENTER", ShardBar, "CENTER")
			end
		else
			ShardBar.powtext:SetText('')
		end
	else
		ShardBar.powtext:SetText('')
	end
end

local function PlayerFrameAnchors()	
	if E.myclass == "DRUID" then
		EclipseTextSLE()
	elseif E.myclass == "WARLOCK" then
		DFTextSLE()
	end
end

hooksecurefunc(UF, "UpdatePlayerFrameAnchors", PlayerFrameAnchors)

function UF:ClassbarTextSLE()
	if E.myclass == "DRUID" then
		EclipseTextSLE()
	elseif E.myclass == "WARLOCK" then
		DFTextSLE()
	end
end

--Text for druid eclipse bar
if E.myclass == "DRUID" then
	local eclipseBar = ElvUF_Player.EclipseBar
	local lunarBar = eclipseBar.LunarBar

	eclipseBar.powtext = lunarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBar.powtext:SetPoint("CENTER", eclipseBar, "CENTER")
	eclipseBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end

if E.myclass == "WARLOCK" then
	local ShardBar = ElvUF_Player.ShardBar
	local dfbar = select(2, ShardBar:GetChildren())

	ShardBar.powtext = dfbar:CreateFontString(nil, 'OVERLAY')
	ShardBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end