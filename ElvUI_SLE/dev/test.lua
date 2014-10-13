local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
--[[local T = E:NewModule('Test', 'AceHook-3.0', 'AceEvent-3.0');

local f1, f2, b1, b2

function T:Initialize()
	f1 = CreateFrame("PlayerModel")
	f1:SetPoint("TOPLEFT", LeftChatPanel,"TOPLEFT",0,0)
	f1:SetHeight(E.db.chat.panelHeight)
	f1:SetWidth(E.db.chat.panelWidth)
	
	f1:SetFrameStrata(LeftChatPanel:GetFrameStrata())
	f1:SetFrameLevel(LeftChatPanel:GetFrameLevel() - 2)
	f1:SetScale(0.71)
	f1:SetUnit("player")
	
	f1:SetPosition(2.5,0,-0.9)
	f1:SetFacing(0.5)
end

E:RegisterModule(T:GetName())]]
