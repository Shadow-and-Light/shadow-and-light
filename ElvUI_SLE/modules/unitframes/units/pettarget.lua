local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

function SUF:Construct_PetTargetFrame(frame)
	-- print('Construct_PetTargetFrame: ', frame:GetName())
	-- frame.SL_DeathIndicator = SUF:Construct_DeathIndicator(frame)

	if frame.Power then
		frame.Power.slBarID = 'powerbar'
	end
end

function SUF:Update_PetTargetFrame(frame)
	-- print('Update_PetTargetFrame: ', frame:GetName())
	if not frame then return end
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.pettarget.enable
	local db = E.db.sle.shadows.unitframes[frame.unit]

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false

	SUF:Configure_Health(frame)
	SUF:Configure_Power(frame)
	-- SUF:Configure_DeathIndicator(frame)
end
