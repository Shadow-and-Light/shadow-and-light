local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_TankFrames()
	-- print('Construct_TankFrames: ', self:GetName())
	self.SL_DeathIndicator = SUF:Construct_DeathIndicator(self)
	self.SL_OfflineIndicator = SUF:Construct_OfflineIndicator(self)
end

function SUF:Update_TankFrames(frame)
	-- print('Update_TankFrames: ', frame:GetName())
	if not frame then return end
	-- local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.tank.enable

	-- local db = E.db.sle.shadows.unitframes.tank

	-- frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	-- frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	-- frame.SLPOWER_ENHSHADOW = enableState and db.power or false

	-- SUF:Configure_Health(frame)
	-- SUF:Configure_Power(frame)

	if not frame.isChild then
		SUF:Configure_DeathIndicator(frame)
		SUF:Configure_OfflineIndicator(frame)
	end
end
