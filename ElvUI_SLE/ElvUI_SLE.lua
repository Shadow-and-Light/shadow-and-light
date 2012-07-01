-------------------------------------------------
--Here be Credits
-------------------------------------------------
--Testing line
local E, L, V, P, G =  unpack(ElvUI); --Engine, Locales, Profile, Global
local SLE = E:NewModule('SLE', 'AceHook-3.0', 'AceEvent-3.0');

function SLE:Initialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateThings");
	if E.db.general.loginmessage then
		print(L['SLE_LOGIN_MSG'])
	end
	E:GetModule('Chat'):SetTimer() --If called before Edit loaded from chat.lua will cause errors
end

--Updating things that must be updated only after everything loads
function SLE:UpdateThings()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
end

E.UpdateAllSLE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllSLE(self)
	E:GetModule('DTPanels'):Update()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
	E:GetModule('UIButtons'):Start()
end

E:RegisterModule(SLE:GetName())