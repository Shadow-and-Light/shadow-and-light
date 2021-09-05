local SLE, _, E = unpack(select(2, ...))
local SUF = SLE.UnitFrames

function SUF:Construct_PlayerFrame(frame)
	-- print('Construct_PlayerFrame: ', frame:GetName())
	frame.SL_DeathIndicator = SUF:Construct_DeathIndicator(frame)
end

function SUF:Update_PlayerFrame(frame, elvdb)
	-- print('Update_PlayerFrame: ', frame:GetName())
	--* db is passed as 2nd arg as i have elvdb atm to remind me
	if not frame then return end
	local enableState = E.private.sle.module.shadows.enable and E.db.unitframe.units.player.enable
	local db = E.db.sle.shadows.unitframes.player

	frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
	frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
	frame.SLPOWER_ENHSHADOW = enableState and db.power or false
	frame.SLCLASSBAR_ENHSHADOW = enableState and db.classbar or false

	SUF:Configure_Health(frame)
	SUF:Configure_Power(frame)
	-- SUF:Configure_ClassBar(frame)
	SUF:Configure_DeathIndicator(frame)
end
