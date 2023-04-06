local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Configure_Power(frame)
	local power = frame.Power
	if not power then return end

	local db = E.db.sle.shadows
	local offset = (E.PixelMode and db.unitframes.size) or (db.unitframes.size + 1)

	if not SUF.CreatedShadows[power.backdrop.enhshadow] then
		power.backdrop.enhshadow = power.backdrop:CreateShadow(4, true)
		SUF.CreatedShadows[power.backdrop.enhshadow] = true
	end

	power.backdrop.enhshadow:SetFrameLevel(power.backdrop:GetFrameLevel())
	if frame.SLLEGACY_ENHSHADOW then
		power.backdrop.enhshadow:SetFrameStrata('BACKGROUND')
	else
		power.backdrop.enhshadow:SetFrameStrata(power.backdrop:GetFrameStrata())
	end

	power.backdrop.enhshadow:SetOutside(power.backdrop.enhshadow:GetParent(), offset, offset, nil, true)
	power.backdrop.enhshadow:SetBackdrop({
		edgeFile = E.LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = db.unitframes.size > 3 and db.unitframes.size or 3,
		-- insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},  --! Don't see a need for this
	})
	SUF:UpdateShadowColor(power.backdrop.enhshadow)

	if frame.USE_POWERBAR and frame.SLPOWER_ENHSHADOW then
		if frame.POWERBAR_DETACHED then
			power.backdrop.enhshadow:Show()
		else
			if frame.db.power and frame.db.power.width ~= 'fill' then
				power.backdrop.enhshadow:Show()
			elseif not frame.SLHEALTH_ENHSHADOW then
				power.backdrop.enhshadow:Show()
			else
				power.backdrop.enhshadow:Hide()
			end
		end
	elseif not frame.SLPOWER_ENHSHADOW then
		power.backdrop.enhshadow:Hide()
	end
end
