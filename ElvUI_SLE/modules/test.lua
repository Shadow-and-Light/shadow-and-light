local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
--local AL = E:NewModule('Autoloot', 'AceHook-3.0', 'AceEvent-3.0');


--[[
function AL:Initialize()
	self:LootShow()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow')
	self:RegisterEvent('PLAYER_LOGIN', 'LootShow')
end]]

--E:RegisterModule(AL:GetName())