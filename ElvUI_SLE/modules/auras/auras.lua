local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local A = E:GetModule('Auras');

--Replacing Elv's function to make buffs smaller
function A:StyleBuffs(buttonName, index, debuff)
	local buff = _G[buttonName..index]
	local icon = _G[buttonName..index.."Icon"]
	local border = _G[buttonName..index.."Border"]
	local duration = _G[buttonName..index.."Duration"]
	local count = _G[buttonName..index.."Count"]
	if icon and not buff.backdrop then
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:Point("TOPLEFT", buff, 2, -2)
		icon:Point("BOTTOMRIGHT", buff, -2, 2)
		
		buff:Size(E.private.dpe.auras.size)
		--buff:Size(35)
				
		duration:ClearAllPoints()
		duration:Point("BOTTOM", 0, -13)
		duration:FontTemplate(nil, nil, 'OUTLINE')
		
		count:ClearAllPoints()
		count:Point("TOPLEFT", 1, -2)
		count:FontTemplate(nil, nil, 'OUTLINE')
		
		buff:CreateBackdrop('Default')
		buff.backdrop:SetAllPoints()
		
		local highlight = buff:CreateTexture(nil, "HIGHLIGHT")
		highlight:SetTexture(1,1,1,0.45)
		highlight:SetAllPoints(icon)
	end
	if border then border:Hide() end
end

function addAuraSource(self, func, unit, index, filter)
	local srcUnit = select(8, func(unit, index, filter))
	if srcUnit then
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
	end
end

A.InitializeDPE = A.Initialize
function A:Initialize()
    A.InitializeDPE(self)
	
	local funcs = {
		SetUnitAura = UnitAura,
		SetUnitBuff = UnitBuff,
		SetUnitDebuff = UnitDebuff,
	}

	for k, v in pairs(funcs) do
		hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
		addAuraSource(self, v, unit, index, filter)
		end)
	end
end