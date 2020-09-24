local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

--GLOBALS: hooksecurefunc
local _G = _G

function SUF:Construct_Raid40Frame()
	if not E.db.unitframe.units.raid40.enable then return end

	SUF:ArrangeRaid40()
end

function SUF:ArrangeRaid40()
	local enableState = E.db.unitframe.units.raid40.enable
	local header = _G['ElvUF_Raid40']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local frame = select(j, group:GetChildren())
			local db = E.db.sle.shadows.unitframes.raid40

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

function SUF:InitRaid40()
	SUF:Construct_Raid40Frame()

	hooksecurefunc(UF, "CreateAndUpdateHeaderGroup", function(_, frame)
		if frame == 'raid40' then SUF:ArrangeRaid40() end
	end)
end
