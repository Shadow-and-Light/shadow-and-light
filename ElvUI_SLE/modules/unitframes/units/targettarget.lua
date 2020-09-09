local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames')

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_TargetTargetFrame()
	if not E.db.unitframe.units.targettarget.enable then return end

	SUF:ArrangeTargetTarget()
end

function SUF:ArrangeTargetTarget()
	local enableState = E.db.unitframe.units.targettarget.enable
	local frame = _G["ElvUF_TargetTarget"]
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

function SUF:InitTargetTarget()
	SUF:Construct_TargetTargetFrame()

	hooksecurefunc(UF, 'Update_TargetTargetFrame', function(_, frame)
		if frame.unitframeType == 'targettarget' then SUF:ArrangeTargetTarget() end
	end)
end
