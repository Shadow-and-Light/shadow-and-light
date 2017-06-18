local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

function SUF:Create_PvpIconText(frame)
	local PvP = frame.PvPIndicator
	PvP.text = CreateFrame("Frame", nil, frame)
	PvP.text:Size(10,10)
	PvP.text:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

	PvP.text.value = PvP.text:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvP.text.value)
	PvP.text.value:Point("CENTER")

	frame:Tag(PvP.text.value, "[sl:pvptimer]")
end

function SUF:Configure_PVPIcon(frame)
	local PvP = frame.PvPIndicator
	if not PvP.text then return end
	local iconEnabled = frame:IsElementEnabled('PvPIndicator')

	if iconEnabled and E.db.sle.unitframes.unit.player.pvpIconText.enable then
		PvP.text:Show()
		PvP.text:Point("TOP", PvP, "BOTTOM", E.db.sle.unitframes.unit.player.pvpIconText.xoffset, -4 + E.db.sle.unitframes.unit.player.pvpIconText.yoffset)
	else
		PvP.text:Hide()
	end
end

function SUF:UpgradePvPIcon()
	SUF:Create_PvpIconText(ElvUF_Player)

	hooksecurefunc(UF, "Configure_PVPIcon", SUF.Configure_PVPIcon)
end