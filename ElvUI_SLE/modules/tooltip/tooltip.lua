local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local TT = E:GetModule('Tooltip');

TT.InitializeSLE = TT.Initialize
function TT:Initialize()
	TT:InitializeSLE(self)

	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
		local srcUnit = select(8,UnitBuff(...))
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

		if src and E.db.sle.castername then
			self:AddLine("|cff1784d1"..src.."|r")
			self:Show()
			self.forceRefresh = true;
		end
	end)

	hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
		local srcUnit = select(8,UnitDebuff(...))
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

		if src and E.db.sle.castername then
			self:AddLine("|cff1784d1"..src.."|r")
			self:Show()
			self.forceRefresh = true;
		end
	end)

	hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
		local srcUnit = select(8,UnitAura(...))
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

		if src and E.db.sle.castername then
			self:AddLine("|cff1784d1"..src.."|r")
			self:Show()
			self.forceRefresh = true;
		end
	end)
end