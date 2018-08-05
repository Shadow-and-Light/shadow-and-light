local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

function SUF:Create_PvpIconText(frame)
	local PvP = frame.PvPIndicator
	if frame.unit == "player" then
		PvP.text = CreateFrame("Frame", nil, frame)
		PvP.text:Size(10,10)
		PvP.text:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

		PvP.text.value = PvP.text:CreateFontString(nil, 'OVERLAY')
		UF:Configure_FontString(PvP.text.value)
		PvP.text.value:Point("CENTER")
		PvP.text.value:SetText("Ima placeholder")

		frame:Tag(PvP.text.value, "[sl:pvptimer]")
	end

	PvP.level = CreateFrame("Frame", nil, frame)
	PvP.level:Size(10,10)
	PvP.level:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

	PvP.level.value = PvP.level:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvP.level.value)
	PvP.level.value:Point("CENTER")
	PvP.level.value:SetText("Ima placeholder")

	frame:Tag(PvP.level.value, "[sl:pvplevel]")
end

function SUF:Configure_PVPIcon(frame)
	local PvP = frame.PvPIndicator
	-- if not PvP.text then return end
	local iconEnabled = frame:IsElementEnabled('PvPIndicator')

	if not iconEnabled then 
		if PvP.text then PvP.text:Hide() end
		PvP.level:Hide() 
		return
	end
	if frame.unit == "player" then
		if E.db.sle.unitframes.unit.player.pvpIconText.enable then
			PvP.text:Show()
			PvP.text:Point("TOP", PvP, "BOTTOM", E.db.sle.unitframes.unit.player.pvpIconText.xoffset, -4 + E.db.sle.unitframes.unit.player.pvpIconText.yoffset)
		else
			PvP.text:Hide()
		end
	end
	if E.db.sle.unitframes.unit[frame.unit].pvpIconText.level then
		PvP.level:Show()
		PvP.level:Point("CENTER", PvP, "BOTTOM", 0, 0)
	else
		PvP.level:Hide()
	end
end

function SUF:UpgradePvPIcon()
	SUF:Create_PvpIconText(ElvUF_Player)
	SUF:Create_PvpIconText(ElvUF_Target)

	hooksecurefunc(UF, "Configure_PVPIcon", SUF.Configure_PVPIcon)
end