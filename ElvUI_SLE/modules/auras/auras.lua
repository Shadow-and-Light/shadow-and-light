local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local A = E:GetModule('Auras');

local auraCount = 0

function A:addAuraSource(self, func, unit, index, filter)
	local srcUnit = select(8, func(unit, index, filter))
	if srcUnit then
		if auraCount == 1 then
			auraCount = 0
			return
		end
		self:AddLine(" ")
		
		local src = GetUnitName(srcUnit, true)
		if srcUnit == "pet" or srcUnit == "vehicle" then
			src = format("%s (%s)", src, GetUnitName("player", true))
		else
			local partypet = srcUnit:match("^partypet(%d+)$")
			local raidpet = srcUnit:match("^raidpet(%d+)$")
			if partypet then
				src = format("%s (%s)", src, GetUnitName("party"..partypet, true))
			elseif raidpet then
				src = format("%s (%s)", src, GetUnitName("raid"..raidpet, true))
			end
		end
		
		self:AddLine(src)
		self:Show()
		auraCount = 1
	end
end

A.InitializeSLE = A.Initialize
function A:Initialize()
    A.InitializeSLE(self)

	local funcs = {
		SetUnitAura = UnitAura,
		SetUnitBuff = UnitBuff,
		SetUnitDebuff = UnitDebuff,
	}

	if E.private.sle.auras.castername then
		for k, v in pairs(funcs) do
			hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
			A:addAuraSource(self, v, unit, index, filter)
			end)
		end
	end
end