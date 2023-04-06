local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_RaidPetFrames()
	-- print('Construct_RaidPetFrames: ', frame:GetName())
	-- self.SL_DeathIndicator = SUF:Construct_DeathIndicator(self)
end

function SUF:Update_RaidPetFrames(frame)
	-- print('Update_RaidPetFrames: ', frame:GetName())
	if not frame then return end
	-- local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units[frame.unitframeType].enable

	-- local db = E.db.sle.shadows.unitframes[frame.unitframeType]

	-- frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	-- frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	-- frame.SLPOWER_ENHSHADOW = enableState and db.power or false

	-- SUF:Configure_Health(frame)
	-- SUF:Configure_Power(frame)
	-- SUF:Configure_DeathIndicator(frame)
end
