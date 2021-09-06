local SLE, _, E = unpack(select(2, ...))
local SUF = SLE.UnitFrames

function SUF:Construct_RaidFrames()
	-- print('Construct_RaidFrames: ', frame:GetName())
	self.SL_DeathIndicator = SUF:Construct_DeathIndicator(self)
	self.SL_OfflineIndicator = SUF:Construct_OfflineIndicator(self)

	if self.Power then
		self.Power.slBarID = 'powerbar'
	end
end

function SUF:Update_RaidFrames(frame)
	-- print('Update_RaidFrames: ', frame:GetName())
	if not frame then return end
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.raid.enable

	local db = E.db.sle.shadows.unitframes.raid

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false

	SUF:Configure_Health(frame)
	SUF:Configure_Power(frame)
	SUF:Configure_DeathIndicator(frame)
	SUF:Configure_OfflineIndicator(frame)
end
