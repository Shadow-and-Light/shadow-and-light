local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_BossFrames(frame)
	-- print('Construct_BossFrames: ', frame:GetName())
	if self.Castbar then
		self.Castbar.slBarID = 'castbar'
	end
	if self.Power then
		self.Power.slBarID = 'powerbar'
	end
end

function SUF:Update_BossFrames(frame)
	-- print('Update_BossFrames: ', frame:GetName())
	if not frame then return end
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.boss.enable

	local db = E.db.sle.shadows.unitframes[frame.unitframeType]

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false

	SUF:Configure_Health(frame)
	SUF:Configure_Power(frame)
end
