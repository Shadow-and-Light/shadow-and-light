local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_RaidFrame()
	if not E.db.unitframe.units.raid.enable then return end

	SUF:ArrangeRaid()
end

function SUF:ArrangeRaid()
	local enableState = E.db.unitframe.units.raid.enable
	local header = _G['ElvUF_Raid']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local frame = select(j, group:GetChildren())
			local db = E.db.sle.shadows.unitframes.raid

			if frame then
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
end

function SUF:InitRaid()
	SUF:Construct_RaidFrame()

	hooksecurefunc(UF, "CreateAndUpdateHeaderGroup", function(_, frame)
		if frame == 'raid' then SUF:ArrangeRaid() end
	end)
end
