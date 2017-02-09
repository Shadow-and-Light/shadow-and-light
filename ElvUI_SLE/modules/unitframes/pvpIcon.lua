local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');
local _G = _G

local Frames = {
	"ElvUF_Player",
	"ElvUF_Target",
}

function SUF:Create_PvpIconText(frame)
	local PvP = frame.PvP
	PvP.text = CreateFrame("Frame", nil, frame)
	PvP.text:Point("TOP", PvP, "BOTTOM", 0, -4)
	PvP.text:Size(10,10)
	PvP.text:SetFrameLevel(PvP:GetParent():GetFrameLevel() + 3)

	PvP.text.value = PvP.text:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvP.text.value)
	PvP.text.value:Point("CENTER")

	frame:Tag(PvP.text.value, "[sl:pvptimer]")
end

function SUF:Configure_PVPIcon(frame)
	local PvP = frame.PvP
	local iconEnabled = frame:IsElementEnabled('PvP')

	if iconEnabled then
		PvP.text:Show()
	else
		PvP.text:Hide()
	end
end

function SUF:UpgradePvPIcon()
	for i = 1, #Frames do
		local frame = _G[Frames[i]]
		SUF:Create_PvpIconText(frame)
	end

	hooksecurefunc(UF, "Configure_PVPIcon", SUF.Configure_PVPIcon)
end