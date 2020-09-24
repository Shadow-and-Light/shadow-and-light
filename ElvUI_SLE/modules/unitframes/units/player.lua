local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames')

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_PlayerFrame()
	if not E.db.unitframe.units.player.enable then return end

	SUF:ArrangePlayer()
end

function SUF:ArrangePlayer()
	local enableState = E.db.unitframe.units.player.enable
	local frame = _G["ElvUF_Player"]
	local db = E.db.sle.shadows.unitframes.player

	do
		frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
		frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
		frame.SLPOWER_ENHSHADOW = enableState and db.power or false
		frame.SLCLASSBAR_ENHSHADOW = enableState and db.classbar or false
	end

	-- Health
	SUF:Configure_Health(frame)

	-- Power
	SUF:Configure_Power(frame)

	-- ClassBar shadows
	SUF:Configure_ClassBar(frame)

	-- frame:UpdateAllElements("SLE_UpdateAllElements")
end

function SUF:InitPlayer()
	SUF:Construct_PlayerFrame()

	hooksecurefunc(UF, 'Update_PlayerFrame', function(_, frame)
		if frame.unitframeType == 'player' then SUF:ArrangePlayer() end
	end)
	hooksecurefunc(UF, 'Configure_ClassBar', function(_, frame)
		if frame.unit == 'player' then SUF:Configure_ClassBar(frame) end
	end)
end
