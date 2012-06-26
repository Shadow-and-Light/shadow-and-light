local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	DBM_GUI_OptionsFrame:StripTextures()
	DBM_GUI_OptionsFrameBossMods:StripTextures()
	DBM_GUI_OptionsFrameDBMOptions:StripTextures()
	DBM_GUI_OptionsFrame:SetTemplate("Transparent")
	DBM_GUI_OptionsFrameBossMods:SetTemplate("Transparent")
	DBM_GUI_OptionsFrameDBMOptions:SetTemplate("Transparent")
	DBM_GUI_OptionsFramePanelContainer:SetTemplate("Transparent")
	
	S:HandleTab(DBM_GUI_OptionsFrameTab1)
	S:HandleTab(DBM_GUI_OptionsFrameTab2)
	S:HandleButton(DBM_GUI_OptionsFrameOkay, true)
	
	S:HandleScrollBar(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
end

S:RegisterSkin('DBM-GUI', LoadSkin)