local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_FocusTargetFrame()
	if not E.db.unitframe.units.focustarget.enable then return end

	SUF:ArrangeFocusTarget()
end

function SUF:ArrangeFocusTarget()
	local enableState = E.db.unitframe.units.focustarget.enable
	local frame = _G["ElvUF_FocusTarget"]
	local db = E.db.sle.shadows.unitframes[frame.unit]

	do
		frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
		frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
		frame.SLPOWER_ENHSHADOW = enableState and db.power or false
	end

	-- Health
	SUF:Configure_Health(frame)

	-- Power
	SUF:Configure_Power(frame)

	frame:UpdateAllElements("SLE_UpdateAllElements")
end

function SUF:InitFocusTarget()
	SUF:Construct_FocusTargetFrame()

	hooksecurefunc(UF, 'Update_FocusTargetFrame', function(_, frame)
		if frame.unitframeType == 'focustarget' then SUF:ArrangeFocusTarget() end
	end)
end
