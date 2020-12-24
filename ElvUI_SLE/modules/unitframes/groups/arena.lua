local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_ArenaFrame()
	if not E.db.unitframe.units.arena.enable then return end

	SUF:ArrangeArena()
end

function SUF:ArrangeArena()
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.arena.enable

	for i = 1, 5 do
		local frame = _G["ElvUF_Arena"..i]
		local db = E.db.sle.shadows.unitframes.arena

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

function SUF:InitArena()
	SUF:Construct_ArenaFrame()

	hooksecurefunc(UF, "Update_ArenaFrames", function(_, frame)
		if frame.unitframeType == 'arena' then SUF:ArrangeArena() end
	end)
end
