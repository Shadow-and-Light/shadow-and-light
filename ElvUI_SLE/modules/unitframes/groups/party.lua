local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames')

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_PartyFrame()
	if not E.db.unitframe.units.party.enable then return end

	SUF:ArrangeParty()
end

function SUF:ArrangeParty()
	local enableState = E.db.unitframe.units.party.enable
	local header = _G['ElvUF_Party']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local frame = select(j, group:GetChildren())
			local db = E.db.sle.shadows.unitframes.party

			do
				frame.SLLEGACY_ENHSHADOW = enableState and db.legacy or false
				frame.SLHEALTH_ENHSHADOW = enableState and db.health or false
				frame.SLPOWER_ENHSHADOW = enableState and db.power or false
			end

			-- Health
			SUF:Configure_Health(frame)

			-- Power
			SUF:Configure_Power(frame)

			-- frame:UpdateAllElements("SLE_UpdateAllElements")
		end
	end
end

function SUF:InitParty()
	SUF:Construct_PartyFrame()

	hooksecurefunc(UF, "CreateAndUpdateHeaderGroup", function(_, frame)
		if frame == 'party' then SUF:ArrangeParty() end
	end)
end
