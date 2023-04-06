local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_PlayerFrame(frame)
	-- print('Construct_PlayerFrame: ', frame:GetName())
	frame.SL_DeathIndicator = SUF:Construct_DeathIndicator(frame)

	SUF:Construct_PvPTimerText(frame)
	SUF:Construct_PvPLevelText(frame)

	if frame.AuraBars then
		frame.AuraBars.slBarID = 'aurabar'
		hooksecurefunc(frame.AuraBars, 'PostUpdateBar', SUF.PostUpdateBar_AuraBars)
	end
	if frame.Castbar then
		frame.Castbar.slBarID = 'castbar'
	end
	if frame.Power then
		frame.Power.slBarID = 'powerbar'
	end
end

function SUF:Update_PlayerFrame(frame)
	-- print('Update_PlayerFrame: ', frame:GetName())
	if not frame then return end
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.player.enable
	local db = E.db.sle.shadows.unitframes.player

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false
	frame.SLCLASSBAR_ENHSHADOW = enableState and db.classbar or false

	SUF:Configure_Health(frame)
	SUF:Configure_Power(frame)
	SUF:Configure_ClassBar(frame)
	SUF:Configure_DeathIndicator(frame)

	SUF:Configure_PvPTimerText(frame)
	SUF:Configure_PvPLevelText(frame)
end
