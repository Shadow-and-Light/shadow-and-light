local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_TargetFrame()
	if not E.db.unitframe.units.target.enable then return end

	SUF:ArrangeTarget()
end

function SUF:ArrangeTarget()
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.target.enable
	local frame = _G["ElvUF_Target"]
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

function SUF:InitTarget()
	SUF:Construct_TargetFrame()

	hooksecurefunc(UF, 'Update_TargetFrame', function(_, frame)
		if frame.unitframeType == 'target' then SUF:ArrangeTarget() end
	end)
end
