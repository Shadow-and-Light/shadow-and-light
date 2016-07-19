local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins');
local Sk = SLE:NewModule("Skins")
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G

function Sk:CreateUnderline(frame, texture, shadow, height)
	local line = CreateFrame("Frame", nil, frame)
	if line then
		line:SetPoint('BOTTOM', frame, -1, 1)
		line:SetSize(frame:GetWidth(), height or 1)
		line.Texture = line:CreateTexture(nil, 'OVERLAY')
		line.Texture:SetTexture(texture)
		if shadow then
			if shadow == "backdrop" then
				line:CreateShadow()
			else
				line:CreateBackdrop()
			end
		end
		line.Texture:SetAllPoints(line)
	end
	return line
end

function Sk:Initialize()
	
	function Sk:ForUpdateAll()
		Sk:Update_ObjectiveTrackerUnderlinesVisibility()
		Sk:Update_ObjectiveTrackerUnderlinesColor()
	end
end

SLE:RegisterModule(Sk:GetName())