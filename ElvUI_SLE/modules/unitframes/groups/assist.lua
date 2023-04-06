local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_AssistFrames()
	-- print('Construct_AssistFrames: ', self:GetName())
	self.SL_DeathIndicator = SUF:Construct_DeathIndicator(self)
	self.SL_OfflineIndicator = SUF:Construct_OfflineIndicator(self)
end

function SUF:Update_AssistFrames(frame)
	-- print('Update_AssistFrames: ', frame:GetName())
	if not frame then return end
	-- local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.assist.enable

	-- local db = E.db.sle.shadows.unitframes.assist

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
