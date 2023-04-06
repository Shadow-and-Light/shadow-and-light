local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Configure_Health(frame)
	if not frame or not frame.Health then return end
	local health = frame.Health

	local db = E.db.sle.shadows
	local offset = (E.PixelMode and db.unitframes.size) or (db.unitframes.size + 1)

	if not SUF.CreatedShadows[health.backdrop.enhshadow] then
		health.backdrop.enhshadow = frame:CreateShadow(4, true)
		SUF.CreatedShadows[health.backdrop.enhshadow] = true
	end

	health.backdrop.enhshadow:SetFrameLevel(health.backdrop:GetFrameLevel())
	if frame.SLLEGACY_ENHSHADOW then
		health.backdrop.enhshadow:SetFrameStrata('BACKGROUND')
	else
		health.backdrop.enhshadow:SetFrameStrata(health.backdrop:GetFrameStrata())
	end

	health.backdrop.enhshadow:SetOutside(frame.TargetGlow, offset-E.Border-3, offset-E.Border-3, nil, true)
	health.backdrop.enhshadow:SetBackdrop({
		edgeFile = E.LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = db.unitframes.size > 2 and db.unitframes.size or 2,
		-- insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},  --! Don't see a need for this
	})
	SUF:UpdateShadowColor(health.backdrop.enhshadow)

	if frame.SLHEALTH_ENHSHADOW then
		health.backdrop.enhshadow:Show()
	else
		health.backdrop.enhshadow:Hide()
	end
end
