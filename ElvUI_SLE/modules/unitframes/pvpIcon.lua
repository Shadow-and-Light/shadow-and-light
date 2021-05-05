local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE.UnitFrames
local UF = E.UnitFrames

--Creating texts for ElvUI's pvp icon
function SUF:Create_PvpIconText(frame)
	local PvP = frame.PvPIndicator
	if frame.unit == "player" then --if player then we actually need 2 texts, one being da timer
		PvP.SLE_timerText = CreateFrame("Frame", nil, frame)
		PvP.SLE_timerText:Size(10,10)
		PvP.SLE_timerText:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

		PvP.SLE_timerText.value = PvP.SLE_timerText:CreateFontString(nil, 'OVERLAY')
		UF:Configure_FontString(PvP.SLE_timerText.value)
		PvP.SLE_timerText.value:Point("CENTER")
		PvP.SLE_timerText.value:SetText("Ima placeholder")

		frame:Tag(PvP.SLE_timerText.value, "[sl:pvptimer]")
	end
	--The main text being honor level, cause fuck guessing your opponent's level by looking at the icon you've never seen before
	PvP.SLE_levelText = CreateFrame("Frame", nil, frame)
	PvP.SLE_levelText:Size(10,10)
	PvP.SLE_levelText:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

	PvP.SLE_levelText.value = PvP.SLE_levelText:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvP.SLE_levelText.value)
	PvP.SLE_levelText.value:Point("CENTER")
	PvP.SLE_levelText.value:SetText("Ima placeholder")

	frame:Tag(PvP.SLE_levelText.value, "[sl:pvplevel]")
end

function SUF:Configure_PVPIcon(frame)
	local PvP = frame.PvPIndicator
	local iconEnabled = frame:IsElementEnabled('PvPIndicator')

	if not iconEnabled then --if indicator is dissabled in ElvUI
		if PvP.SLE_timerText then PvP.SLE_timerText:Hide() end
		PvP.SLE_levelText:Hide()
		return
	end
	if frame.unit == "player" then --do timer stuff if this is update for player frame
		if E.db.sle.unitframes.unit.player.pvpIconText.enable then
			PvP.SLE_timerText:Show()
			PvP.SLE_timerText:Point("TOP", PvP, "BOTTOM", E.db.sle.unitframes.unit.player.pvpIconText.xoffset, -4 + E.db.sle.unitframes.unit.player.pvpIconText.yoffset)
		else
			PvP.SLE_timerText:Hide()
		end
	end
	if E.db.sle.unitframes.unit[frame.unit] and E.db.sle.unitframes.unit[frame.unit].pvpIconText.level then
		PvP.SLE_levelText:Show()
		PvP.SLE_levelText:Point("CENTER", PvP, "BOTTOM", 0, 0)
	else
		PvP.SLE_levelText:Hide()
	end
end

--Pimping up that icon for pvp on da frames
function SUF:UpgradePvPIcon()
	SUF:Create_PvpIconText(ElvUF_Player)
	SUF:Create_PvpIconText(ElvUF_Target)

	hooksecurefunc(UF, "Configure_PVPIcon", SUF.Configure_PVPIcon)
end