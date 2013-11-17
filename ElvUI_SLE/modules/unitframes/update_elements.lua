local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
if not E.private.unitframe.enable then return end
local UF = E:GetModule('UnitFrames');

local format = format

--Replacement of text formats on unitframes.
local styles = {
	['CURRENT'] = '%s',
	['CURRENT_MAX'] = '%s - %s',
	['CURRENT_PERCENT'] =  '%s - %s%%',
	['CURRENT_MAX_PERCENT'] = '%s - %s | %s%%',
	['DEFICIT'] = '-%s'
}

function E:GetFormattedTextSLE(style, min, max)
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