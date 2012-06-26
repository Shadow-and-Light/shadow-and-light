if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
local Altoholic = _G.Altoholic
if not IsAddOnLoaded("Altoholic_Characters") then return end
LoadAddOn("Altoholic_Characters")

AltoholicFrameContainers:StripTextures()
AltoholicFrameContainers:SetTemplate("Default")
AltoholicFrameRecipes:SetTemplate("Default")
AltoholicFrameQuests:SetTemplate("Default")
AltoholicFrameTalents:SetTemplate("Default")
AltoholicFrameGlyphs:SetTemplate("Default")
AltoholicFrameMail:SetTemplate("Default")
AltoholicFrameSpellbook:SetTemplate("Default")
AltoholicFramePets:SetTemplate("Default")
AltoholicFrameAuctions:SetTemplate("Default")

S:HandleScrollBar(AltoholicFrameContainersScrollFrameScrollBar)
AltoholicFrameContainersScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameQuestsScrollFrameScrollBar)
AltoholicFrameQuestsScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameRecipesScrollFrameScrollBar)
AltoholicFrameRecipesScrollFrame:StripTextures()

S:HandleDropDownBox(AltoholicFrameTalents_SelectMember)
S:HandleDropDownBox(AltoholicTabCharacters_SelectRealm)

S:HandleNextPrevButton(AltoholicFrameSpellbookPrevPage)
S:HandleNextPrevButton(AltoholicFrameSpellbookNextPage)
S:HandleRotateButton(AltoholicFramePetsNormal_ModelFrameRotateLeftButton)
S:HandleRotateButton(AltoholicFramePetsNormal_ModelFrameRotateRightButton)
S:HandleNextPrevButton(AltoholicFramePetsNormalPrevPage)
S:HandleNextPrevButton(AltoholicFramePetsNormalNextPage)
S:HandleButton(AltoholicTabCharacters_Sort1)
S:HandleButton(AltoholicTabCharacters_Sort2)
S:HandleButton(AltoholicTabCharacters_Sort3)

for i = 1, 14 do
	_G["AltoholicFrameContainersEntry1Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry2Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry3Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry4Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry5Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry6Item"..i]:StripTextures()
	_G["AltoholicFrameContainersEntry7Item"..i]:StripTextures()
end