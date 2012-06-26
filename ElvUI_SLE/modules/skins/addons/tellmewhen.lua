local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	TellMeWhen_IconEditorMain:StripTextures()
	TellMeWhen_IconEditorConditions:StripTextures()
	TellMeWhen_IconEditor:StripTextures()
	TellMeWhen_IconEditorMainOptions:StripTextures()
	
	TellMeWhen_IconEditor:SetTemplate("Transparent")
	TellMeWhen_IconEditorMainOptions:SetTemplate("Transparent")
	
	S:HandleButton(TellMeWhen_IconEditorReset, true)
	S:HandleButton(TellMeWhen_IconEditorUndo, true)
	S:HandleButton(TellMeWhen_IconEditorRedo, true)

	S:HandleTab(TellMeWhen_IconEditorTab1)
	S:HandleTab(TellMeWhen_IconEditorTab2)
	S:HandleTab(TellMeWhen_IconEditorTab3)
	S:HandleTab(TellMeWhen_IconEditorTab4)
	S:HandleTab(TellMeWhen_IconEditorTab5)

	S:HandleButton(TellMeWhen_IconEditorOkay, true)
	S:HandleCloseButton(TellMeWhen_IconEditorClose, true)
	
	TellMeWhen_ConfigWarning:StripTextures()
	TellMeWhen_ConfigWarning:SetTemplate("Transparent")
	S:HandleButton(TellMeWhen_ConfigWarningExit, true)
	S:HandleButton(TellMeWhen_ConfigWarningNeverAgain, true)
	
	
	TellMeWhen_IconEditorSuggest:ClearAllPoints()
	TellMeWhen_IconEditorSuggestItem1:ClearAllPoints()
	TellMeWhen_IconEditorSuggestItem1:SetSize(200, 20)
	TellMeWhen_IconEditorSuggest:SetSize(210, 400)
	TellMeWhen_IconEditorSuggest:SetTemplate("Transparent")
	TellMeWhen_IconEditorSuggest:Point("LEFT", TellMeWhen_IconEditorMain, "RIGHT", 1, 0)
	TellMeWhen_IconEditorSuggestItem1:Point("TOPLEFT", TellMeWhen_IconEditorSuggest, "TOPLEFT", 5, -38)
	
	TellMeWhen_IconEditorTab1:ClearAllPoints()
	TellMeWhen_IconEditorTab2:ClearAllPoints()
	TellMeWhen_IconEditorTab3:ClearAllPoints()
	TellMeWhen_IconEditorTab4:ClearAllPoints()
	TellMeWhen_IconEditorTab5:ClearAllPoints()
	
	TellMeWhen_IconEditorTab1:SetSize(89, 30)
	TellMeWhen_IconEditorTab2:SetSize(94, 30)
	TellMeWhen_IconEditorTab3:SetSize(86, 30)
	TellMeWhen_IconEditorTab4:SetSize(112, 30)
	TellMeWhen_IconEditorTab5:SetSize(210, 30)
	
	TellMeWhen_IconEditorTab1:Point("TOPLEFT", TellMeWhen_IconEditorMain, "BOTTOMLEFT", 0, 4)
	TellMeWhen_IconEditorTab2:Point("LEFT", TellMeWhen_IconEditorTab1, "RIGHT", -19, 0)
	TellMeWhen_IconEditorTab3:Point("LEFT", TellMeWhen_IconEditorTab2, "RIGHT", -19, 0)
	TellMeWhen_IconEditorTab4:Point("LEFT", TellMeWhen_IconEditorTab3, "RIGHT", -19, 0)
	TellMeWhen_IconEditorTab5:Point("LEFT", TellMeWhen_IconEditorTab4, "RIGHT", -19, 0)
	
	S:HandleScrollBar(TellMeWhen_IconEditorEventsSoundSoundsScrollBar)
	S:HandleCheckBox(TellMeWhen_IconEditorEventsEventSettingsPassThrough)
	S:HandleCheckBox(TellMeWhen_IconEditorEventsEventSettingsOnlyShown)
	
end

S:RegisterSkin("TellMeWhen_Options", LoadSkin)