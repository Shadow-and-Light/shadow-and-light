if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
local Altoholic = _G.Altoholic
if not IsAddOnLoaded("Altoholic_Search") then return end

local function LoadSkin()

AltoholicFrameSearch:StripTextures()
AltoholicFrameSearch:SetTemplate("Default")
AltoholicFrameSearchScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameSearchScrollFrameScrollBar)
AltoholicSearchMenuScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicSearchMenuScrollFrameScrollBar)

--Menu Items
for i = 1, 15 do
	_G["AltoholicTabSearchMenuItem"..i]:StripTextures()
	_G["AltoholicTabSearchMenuItem"..i]:SetTemplate("Default")
	_G["AltoholicTabSearchMenuItem"..i]:StyleButton(hasChecked)
end

--Sorts
for i = 1, 3 do
	_G["AltoholicTabSearch_Sort"..i]:StripTextures()
	_G["AltoholicTabSearch_Sort"..i]:SetTemplate("Default")
	_G["AltoholicTabSearch_Sort"..i]:StyleButton(hasChecked)
end

--Drop Downs
S:HandleDropDownBox(AltoholicTabSearch_SelectRarity)
S:HandleDropDownBox(AltoholicTabSearch_SelectSlot)
S:HandleDropDownBox(AltoholicTabSearch_SelectLocation)
AltoholicTabSearch_SelectRarity:Size(125, 32)
AltoholicTabSearch_SelectSlot:Size(125, 32)
AltoholicTabSearch_SelectLocation:Size(175, 32)

--Edit Boxs
S:HandleEditBox(_G["AltoholicTabSearch_MinLevel"])
S:HandleEditBox(_G["AltoholicTabSearch_MaxLevel"])

end

S:RegisterSkin('Altoholic_Search', LoadSkin)