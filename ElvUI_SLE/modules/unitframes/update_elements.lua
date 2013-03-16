local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
if not E.private.unitframe.enable then return end
local UF = E:GetModule('UnitFrames');

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

if E.myclass == "WARLOCK" then
	ElvUF_Player.ShardBar.PostUpdate = function(self, spec)
		local maxBars = self.number
		local db = self:GetParent().db
		local frame = self:GetParent()
		
		for i=1, UF['classMaxResourceBar'][E.myclass] do
			if self[i]:IsShown() and db.classbar.fill == 'spaced' then
				self[i].backdrop:Show()
			else
				self[i].backdrop:Hide()
			end
		end
	
		if not E.db.unitframe.units.player.classbar.offset then
			if db.classbar.fill == 'spaced' and maxBars == 1 then
				self:ClearAllPoints()
				self:Point("LEFT", frame.Health.backdrop, "TOPLEFT", 8, 0)
			elseif db.classbar.fill == 'spaced' then
				self:ClearAllPoints()
				self:Point("CENTER", frame.Health.backdrop, "TOP", -12, -2)
			end
		else
			if db.classbar.fill == 'spaced' and maxBars == 1 then
				self:ClearAllPoints()
				self:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(E:Scale(2)*3 + 6), db.classbar.yOffset -E:Scale(1))
			elseif db.classbar.fill == 'spaced' then
				self:ClearAllPoints()
				self:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(E:Scale(2)*3 + 6), db.classbar.yOffset -E:Scale(1))
			end
		end
		
		local SPACING = db.classbar.fill == 'spaced' and 13 or 1
		for i = 1, maxBars do
			self[i]:SetHeight(self:GetHeight())	
			self[i]:SetWidth((self:GetWidth() - (maxBars - 1)) / maxBars)
			self[i]:ClearAllPoints()
			if i == 1 then
				self[i]:SetPoint("LEFT", self)
			else
				self[i]:Point("LEFT", self[i-1], "RIGHT", SPACING , 0)
			end		
		end
		
		UF:UpdatePlayerFrameAnchors(frame, self:IsShown())
	end
end