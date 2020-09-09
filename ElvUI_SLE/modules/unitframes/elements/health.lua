local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule('UnitFrames');

function SUF:Configure_Health(frame)
	local health = frame.Health
	local db = E.db.sle.shadows
	local r, g, b = db.shadowcolor.r, db.shadowcolor.g, db.shadowcolor.b
	local offset = (E.PixelMode and db.size) or (db.size + 1)

	if frame.SLHEALTH_ENHSHADOW then
		if not health.backdrop.enhshadow then
			health.backdrop.enhshadow = frame:CreateShadow(4, true)
		end

		health.backdrop.enhshadow:SetFrameLevel(health.backdrop:GetFrameLevel())
		if frame.SLLEGACY_ENHSHADOW then
			health.backdrop.enhshadow:SetFrameStrata('BACKGROUND')
		else
			health.backdrop.enhshadow:SetFrameStrata(health.backdrop:GetFrameStrata())
		end

		health.backdrop.enhshadow:SetOutside(frame.TargetGlow, offset-E.Border-3, offset-E.Border-3, nil, true)
		health.backdrop.enhshadow:SetBackdrop({
			edgeFile = E.LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = db.size > 2 and db.size or 2,
			-- insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},  --! Don't see a need for this
		})
		health.backdrop.enhshadow:SetBackdropColor(r, g, b, 0)
		health.backdrop.enhshadow:SetBackdropBorderColor(r, g, b, 0.9)
		health.backdrop.enhshadow:Hide()
	elseif not frame.SLHEALTH_ENHSHADOW then
		if health.backdrop.enhshadow then
			health.backdrop.enhshadow:Kill()
			health.backdrop.enhshadow = nil
		end
	end

	if frame.SLHEALTH_ENHSHADOW then
		health.backdrop.enhshadow:Show()
	end
end
