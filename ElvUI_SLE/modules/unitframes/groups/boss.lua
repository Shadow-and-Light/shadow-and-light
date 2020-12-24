local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_BossFrame()
	if not E.db.unitframe.units.boss.enable then return end

	SUF:ArrangeBoss()
end

function SUF:ArrangeBoss()
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.boss.enable

	for i = 1, 5 do
		local frame = _G["ElvUF_Boss"..i]
		local db = E.db.sle.shadows.unitframes.boss

		do
			frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
			frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
			frame.SLPOWER_ENHSHADOW = enableState and db.power or false
		end

		-- Health
		SUF:Configure_Health(frame)

		-- Power
		SUF:Configure_Power(frame)

		-- frame:UpdateAllElements("SLE_UpdateAllElements")
	end
end

function SUF:InitBoss()
	SUF:Construct_BossFrame()

	hooksecurefunc(UF, "Update_BossFrames", function(_, frame)
		if frame.unitframeType == 'boss' then SUF:ArrangeBoss() end
	end)
end
