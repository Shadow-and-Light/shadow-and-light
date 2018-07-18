local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SA = SLE:NewModule("Auras", 'AceEvent-3.0')
local A = E:GetModule("Auras")
local Masque = LibStub("Masque", true)
local MasqueGroup = Masque and Masque:Group("ElvUI", "Consolidated Buffs")
--GLOBALS: hooksecurefunc
local _G = _G
local NUM_LE_RAID_BUFF_TYPES = NUM_LE_RAID_BUFF_TYPES
local GameTooltip = GameTooltip
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local C_Timer = C_Timer

function SA:UpdateAura(button, index)
	if not SA.db.hideBuffsTimer and not SA.db.hideDebuffsTimer then button.time:Show() return end
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name, _, _, dtype, duration, expiration = T.UnitAura(unit, index, filter)

	if (name) then
		if filter == "HARMFUL" and SA.db.hideDebuffsTimer then
			button.time:Hide()
		elseif filter == "HELPFUL" and SA.db.hideBuffsTimer then
			button.time:Hide()
		else
			button.time:Show()
		end
	end
end

function SA:Initialize()
	if not SLE.initialized or E.private.auras.enable ~= true then return end
	SA.db = E.db.sle.auras
	hooksecurefunc(A, 'UpdateAura', SA.UpdateAura)

	function SA:ForUpdateAll()
		SA.db = E.db.sle.auras
	end
end

SLE:RegisterModule(SA:GetName())