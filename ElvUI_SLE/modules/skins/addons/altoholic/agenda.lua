if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
local Altoholic = _G.Altoholic
if not IsAddOnLoaded("Altoholic_Agenda") then return end

local function LoadSkin()

AltoholicFrameCalendarScrollFrame:StripTextures()
AltoholicFrameCalendarScrollFrame:SetTemplate("Default")
S:HandleScrollBar(AltoholicFrameCalendarScrollFrameScrollBar)
--Agenda
S:HandleNextPrevButton(AltoholicFrameCalendar_NextMonth)
S:HandleNextPrevButton(AltoholicFrameCalendar_PrevMonth)
AltoholicTabAgendaMenuItem1:StripTextures()
AltoholicTabAgendaMenuItem1:SetTemplate("Default")
AltoholicTabAgendaMenuItem1:StyleButton(hasChecked)

for i = 1, 14 do
	_G["AltoholicFrameCalendarEntry"..i]:StripTextures()
	_G["AltoholicFrameCalendarEntry"..i]:SetTemplate("Default")
end

end

S:RegisterSkin('Altoholic_Agenda', LoadSkin)