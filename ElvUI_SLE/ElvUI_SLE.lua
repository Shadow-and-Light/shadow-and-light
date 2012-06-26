-------------------------------------------------
--Here be Credits
-------------------------------------------------
local E, L, V, P, G =  unpack(ElvUI); --Engine, Locales, Profile, Global
local DPE = E:NewModule('DPE', 'AceHook-3.0', 'AceEvent-3.0');

function DPE:Initialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateThings");
	if E.db.general.loginmessage then
		print(L['DPE_LOGIN_MSG'])
	end
	E:GetModule('Chat'):SetTimer() --If called before Edit loaded from chat.lua will cause errors
	E:GetModule('Chat'):SetChannelsCheck() --If called before Edit loaded from chat.lua will cause errors
end

--Updating things that must be updated only after everything loads
function DPE:UpdateThings()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
end

E.UpdateAllDPE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllDPE(self)
	E:GetModule('DTPanels'):Update()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
	E:GetModule('UIButtons'):Start()
	E:GetModule('DPE'):BPUpdate()
end

E:RegisterModule(DPE:GetName())