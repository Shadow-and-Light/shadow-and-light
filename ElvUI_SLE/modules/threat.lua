local E, L, V, P, G = unpack(ElvUI);
local SLT = E:GetModule('SLE_Threat');
local T = E:GetModule('Threat');

function SLT:UpdatePosition()
	if not E.db.general.threat.enable or not E.db.sle.threat.enable then return end

	T.bar:SetInside(E.db.sle.threat.position)
	T.bar:SetParent(E.db.sle.threat.position)

	T.bar.text:FontTemplate(nil, E.db.general.threat.textSize)
	T.bar:SetFrameStrata('MEDIUM')
	T.bar:SetAlpha(1)
end

local function LoadConfig(event, addon)
	if addon ~= "ElvUI_Config" then return end

	SLT:Update()
	SLT:UnregisterEvent("ADDON_LOADED")
end

function SLT:Update()
	if E.db.sle.threat.enable then
		E.Options.args.general.args.threat.args.position.disabled = function() return true end
	else
		E.Options.args.general.args.threat.args.position.disabled = function() return false end
	end
end

function SLT:Initialize()
	hooksecurefunc(T, 'UpdatePosition', SLT.UpdatePosition)
	SLT:RegisterEvent("ADDON_LOADED", LoadConfig)
	SLT:UpdatePosition()
end