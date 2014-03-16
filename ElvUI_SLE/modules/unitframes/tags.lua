local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local RC = LibStub("LibRangeCheck-2.0")

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
		return E:GetFormattedTextSLE('CURRENT', min, max)
	end
end

ElvUF.Tags.Events['health:deficit:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
ElvUF.Tags.Methods['health:deficit:sl'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

	if (status) then
		return status
	else
		return E:GetFormattedTextSLE('DEFICIT', min, max)
	end
end

ElvUF.Tags.Events['health:current-percent:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
ElvUF.Tags.Methods['health:current-percent:sl'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

	if (status) then
		return status
	else
		return E:GetFormattedTextSLE('CURRENT_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['health:current-max:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
ElvUF.Tags.Methods['health:current-max:sl'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

	if (status) then
		return status
	else
		return E:GetFormattedTextSLE('CURRENT_MAX', min, max)
	end
end

ElvUF.Tags.Events['health:current-max-percent:sl'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION'
ElvUF.Tags.Methods['health:current-max-percent:sl'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and L['Offline'] or UnitIsGhost(unit) and L['Ghost'] or UnitIsDead(unit) and DEAD

	if (status) then
		return status
	else
		return E:GetFormattedTextSLE('CURRENT_MAX_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['power:current:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current:sl'] = function(unit)
	local pType = UnitPowerType(unit)
	local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		
	if min == 0 then
		return ' '
	else
		return E:GetFormattedTextSLE('CURRENT', min, max)
	end
end

ElvUF.Tags.Events['power:current-max:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-max:sl'] = function(unit)
	local pType = UnitPowerType(unit)
	local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		
	if min == 0 then
		return ' '
	else
		return E:GetFormattedTextSLE('CURRENT_MAX', min, max)
	end
end

ElvUF.Tags.Events['power:current-percent:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-percent:sl'] = function(unit)
	local pType = UnitPowerType(unit)
	local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		
	if min == 0 then
		return ' '
	else
		return E:GetFormattedTextSLE('CURRENT_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['power:current-max-percent:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-max-percent:sl'] = function(unit)
	local pType = UnitPowerType(unit)
	local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		
	if min == 0 then
		return ' '
	else
		return E:GetFormattedTextSLE('CURRENT_MAX_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['power:deficit:sl'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:deficit:sl'] = function(unit)
	local pType = UnitPowerType(unit)
	local min, max = UnitPower(unit, pType), UnitPowerMax(unit, pType)
		
	return E:GetFormattedTextSLE('DEFICIT', min, max, r, g, b)
end