local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames
local UF = E.UnitFrames

function SUF:PostUpdateBar_AuraBars(a, statusBar, b, c, d, e, debuffType)
	if not statusBar then return end
	local db = E.db.sle.unitframe.statusbarTextures.aurabar
	if not db.enable then return end

	local texture = E.LSM:Fetch('statusbar', db.texture)
	statusBar:SetStatusBarTexture(texture)
end

function SUF:Update_StatusBars()
	local db = E.db.sle.unitframe.statusbarTextures

	for statusbar in pairs(UF.statusbars) do
		-- if statusbar:GetParent().slBarID then print(statusbar:GetName(), statusbar:GetParent().slBarID, 'maybe i can do it here') end  -- another place classbars i found at the end of my changes ....
		if statusbar and statusbar.slBarID and db[statusbar.slBarID].enable then
			local powerTexture = E.LSM:Fetch('statusbar', E.db.sle.unitframe.statusbarTextures[statusbar.slBarID].texture)
			local useBlank = statusbar.isTransparent
			if statusbar.parent then
				useBlank = statusbar.parent.isTransparent
			end
			if statusbar:GetObjectType() == 'StatusBar' then
				if not useBlank then
					statusbar:SetStatusBarTexture(powerTexture)
				end
			elseif statusbar:GetObjectType() == 'Texture' then
				statusbar:SetTexture(powerTexture)
			end
			UF:Update_StatusBar(statusbar.bg or statusbar.BG, (not useBlank and powerTexture) or E.media.blankTex)
		end

		if statusbar.slBarID == 'classbar' and db[statusbar.slBarID].enable then
			SUF:Configure_ClassBar(_G.ElvUF_Player)
		end
	end
end

function SUF:Update_StatusBar(statusbar)
	if not statusbar or not statusbar:GetParent().slBarID then return end
	local slBarID = statusbar:GetParent().slBarID
	if not E.db.sle.unitframe.statusbarTextures[slBarID].enable then return end

	local texture = E.LSM:Fetch('statusbar', E.db.sle.unitframe.statusbarTextures[slBarID].texture)
	if statusbar:IsObjectType('StatusBar') then
		statusbar:SetStatusBarTexture(texture)
	elseif statusbar:IsObjectType('Texture') then
		statusbar:SetTexture(texture)
	end
end

function SUF:ToggleTransparentStatusBar(isTransparent, statusBar, backdropTex, adjustBackdropPoints, invertColors, reverseFill)
	if not statusBar or not statusBar.slBarID then return end
	local slBarID = statusBar.slBarID
	if not E.db.sle.unitframe.statusbarTextures[slBarID].enable then return end

	local parent = statusBar:GetParent()
	local orientation = statusBar:GetOrientation()
	if isTransparent then
		if statusBar.backdrop then
			statusBar.backdrop:SetTemplate('Transparent', nil, nil, nil, true)
		elseif parent.template then
			parent:SetTemplate('Transparent', nil, nil, nil, true)
		end

		statusBar:SetStatusBarTexture(0, 0, 0, 0)
		UF:Update_StatusBar(statusBar.bg or statusBar.BG, E.media.blankTex)

		local barTexture = statusBar:GetStatusBarTexture()
		barTexture:SetInside(nil, 0, 0) --This fixes Center Pixel offset problem

		UF:SetStatusBarBackdropPoints(statusBar, barTexture, backdropTex, orientation, reverseFill)
	else
		if statusBar.backdrop then
			statusBar.backdrop:SetTemplate(nil, nil, nil, nil, true)
		elseif parent.template then
			parent:SetTemplate(nil, nil, nil, nil, true)
		end

		local texture = E.LSM:Fetch('statusbar', E.db.sle.unitframe.statusbarTextures[slBarID].texture)
		statusBar:SetStatusBarTexture(texture)
		SUF:Update_StatusBar(statusBar.bg or statusBar.BG, texture)

		local barTexture = statusBar:GetStatusBarTexture()
		barTexture:SetInside(nil, 0, 0)

		if adjustBackdropPoints then
			UF:SetStatusBarBackdropPoints(statusBar, barTexture, backdropTex, orientation, reverseFill)
		end

	end
end
