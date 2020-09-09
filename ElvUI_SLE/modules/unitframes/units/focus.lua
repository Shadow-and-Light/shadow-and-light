local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_FocusFrame()
	if not E.db.unitframe.units.focus.enable then return end

	SUF:ArrangeFocus()
end

function SUF:ArrangeFocus()
	local enableState = E.db.unitframe.units.focus.enable
	local frame = _G["ElvUF_Focus"]
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

function SUF:InitFocus()
	SUF:Construct_FocusFrame()

	hooksecurefunc(UF, 'Update_FocusFrame', function(_, frame)
		if frame.unitframeType == 'focus' then SUF:ArrangeFocus() end
	end)
end
