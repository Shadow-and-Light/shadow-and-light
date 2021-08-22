local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE.UnitFrames
local UF = E.UnitFrames

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:ArrangePlayer()
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.player.enable
	local frame = _G["ElvUF_Player"]
	if not frame then return end
	local db = E.db.sle.shadows.unitframes.player

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false
	frame.SLCLASSBAR_ENHSHADOW = enableState and db.classbar or false

	-- Health
	SUF:Configure_Health(frame)

	-- Power
	SUF:Configure_Power(frame)

	-- ClassBar shadows
	SUF:Configure_ClassBar(frame)
end
