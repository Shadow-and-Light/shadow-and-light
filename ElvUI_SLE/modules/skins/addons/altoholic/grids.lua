if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
if not IsAddOnLoaded("Altoholic_Grids") then return end

local function LoadSkin()

AltoholicFrameGrids:SetTemplate("Default")

S:HandleScrollBar(AltoholicFrameGridsScrollFrameScrollBar)
AltoholicFrameGridsScrollFrame:StripTextures()

S:HandleDropDownBox(AltoholicTabGrids_SelectRealm)
S:HandleDropDownBox(AltoholicTabGrids_SelectView)

for i = 1, 10 do
	_G["AltoholicFrameGridsEntry1Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry2Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry3Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry4Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry5Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry6Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry7Item"..i]:StripTextures()
	_G["AltoholicFrameGridsEntry8Item"..i]:StripTextures()
end

end
S:RegisterSkin('Altoholic_Grids', LoadSkin)