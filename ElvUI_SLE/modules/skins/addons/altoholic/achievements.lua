if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
local Altoholic = _G.Altoholic
if not IsAddOnLoaded("Altoholic_Achievements") then return end

local function LoadSkin()

AltoholicFrameAchievements:StripTextures()
AltoholicFrameAchievements:SetTemplate("Default")
AltoholicFrameAchievementsScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameAchievementsScrollFrameScrollBar)
AltoholicAchievementsMenuScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicAchievementsMenuScrollFrameScrollBar)
S:HandleDropDownBox(AltoholicTabAchievements_SelectRealm)
AltoholicTabAchievements_SelectRealm:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 205, -57)

for i = 1, 15 do
	_G["AltoholicTabAchievementsMenuItem"..i]:StripTextures()
	_G["AltoholicTabAchievementsMenuItem"..i]:SetTemplate("Default")
	_G["AltoholicTabAchievementsMenuItem"..i]:StyleButton(hasChecked)
end
for i = 1, 10 do
	_G["AltoholicFrameAchievementsEntry1Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry2Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry3Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry4Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry5Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry6Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry7Item"..i]:StripTextures()
	_G["AltoholicFrameAchievementsEntry8Item"..i]:StripTextures()
end

end

S:RegisterSkin('Altoholic_Achievements', LoadSkin)