local E, L, V, P, G = unpack(ElvUI);
local AT = E:GetModule('SLE_AuraTimers');
local A = E:GetModule('Auras');

function AT:UpdateAura(button, index)
	if not E.db.sle.auras.enable then return end
	local isDebuff
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name, _, _, _, dtype, duration, expiration = UnitAura(unit, index, filter)

	if (name) then
		if UnitBuff('player', name) then
			isDebuff = false
		elseif UnitDebuff('player', name) then
			isDebuff = true
		end

		if isDebuff == false and E.db.sle.auras.buffs.hideTimer then
			button.time:Hide()
		elseif isDebuff == false then
			button.time:Show()
		end

		if isDebuff == true and E.db.sle.auras.debuffs.hideTimer then
			button.time:Hide()
		elseif isDebuff == true then
			button.time:Show()
		end
	end
end

function AT:UpdateTempEnchant(button, index)
	--Might do tempenchant stuff later
end

function AT:Initialize()
	if E.private.auras.enable ~= true then return end
	hooksecurefunc(A, 'UpdateAura', AT.UpdateAura)
	--hooksecurefunc(A, 'UpdateTempEnchant', AT.UpdateTempEnchant)
end