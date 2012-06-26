if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')

if not IsAddOnLoaded("Altoholic") then return end

AltoMsgBox:StripTextures()
AltoMsgBox:SetTemplate("Transparent")
S:HandleButton(AltoMsgBoxYesButton)
S:HandleButton(AltoMsgBoxNoButton)

AltoholicFrame:StripTextures()
AltoholicFrame:SetTemplate("Transparent")
AltoholicFrameActivity:StripTextures()
AltoholicFrameActivity:SetTemplate("Transparent")
AltoholicFrameBagUsage:StripTextures()
AltoholicFrameBagUsage:SetTemplate("Transparent")
AltoholicFrameSkills:StripTextures()
AltoholicFrameSkills:SetTemplate("Transparent")
AltoholicFrameSummary:StripTextures()
AltoholicFrameSummary:SetTemplate("Transparent")
AltoholicFramePortrait:Kill()
--Buttons
S:HandleButton(AltoholicFrame_ResetButton)
AltoholicFrame_ResetButton:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 35, -77)
S:HandleButton(AltoholicFrame_SearchButton)
AltoholicFrame_ResetButton:Size(85, 24)
AltoholicFrame_SearchButton:Size(85, 24)

--Summary
for i = 1, 4 do
	_G["AltoholicTabSummaryMenuItem"..i]:StripTextures()
	_G["AltoholicTabSummaryMenuItem"..i]:SetTemplate("Default")	
	_G["AltoholicTabSummaryMenuItem"..i]:StyleButton(hasChecked)
end

--Sorts
for i = 1, 8 do
	_G["AltoholicTabSummary_Sort"..i]:StripTextures()
	_G["AltoholicTabSummary_Sort"..i]:SetTemplate("Default")
	_G["AltoholicTabSummary_Sort"..i]:SetTemplate("Default")
end

-- Buttons
S:HandleCloseButton(AltoholicFrameCloseButton)

--Tabs
for i = 1, 7 do
	S:HandleTab(_G["AltoholicFrameTab"..i])
end

-- Drop Downs
S:HandleDropDownBox(AltoholicTabSummary_SelectLocation)
AltoholicTabSummary_SelectLocation:Size(200, 15)

--Edit Boxs
S:HandleEditBox(_G["AltoholicFrame_SearchEditBox"])
AltoholicFrame_SearchEditBox:Size(175, 15)
AltoholicFrame_SearchEditBox:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 37, -56)

S:HandleScrollBar(AltoholicFrameSummaryScrollFrameScrollBar)
AltoholicFrameSummaryScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameBagUsageScrollFrameScrollBar)
AltoholicFrameBagUsageScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameSkillsScrollFrameScrollBar)
AltoholicFrameSkillsScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameActivityScrollFrameScrollBar)
AltoholicFrameActivityScrollFrame:StripTextures()

AltoholicFrameTab1:Point("TOPLEFT", AltoholicFrame, "BOTTOMLEFT", -5, 2)

AltoTooltip:HookScript( "OnShow", function( self ) self:SetTemplate( "Transparent" ) end )
