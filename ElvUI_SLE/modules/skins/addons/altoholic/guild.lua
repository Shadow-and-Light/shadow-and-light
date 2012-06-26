if not IsAddOnLoaded("ElvUI") then return end
local E, L, V, P, G =  unpack(ElvUI);
local S = E:GetModule('Skins')
local Altoholic = _G.Altoholic
if not IsAddOnLoaded("Altoholic_Guild") then return end

local function LoadSkin()

AltoholicFrameGuildMembers:StripTextures()
AltoholicFrameGuildMembers:SetTemplate("Default")
AltoholicFrameGuildBank:StripTextures()
AltoholicFrameGuildBank:SetTemplate("Default")
AltoholicFrameGuildMembersScrollFrame:StripTextures()
S:HandleScrollBar(AltoholicFrameGuildMembersScrollFrameScrollBar)

--Guild
for i = 1, 2 do
	_G["AltoholicTabGuildMenuItem"..i]:StripTextures()
	_G["AltoholicTabGuildMenuItem"..i]:SetTemplate("Default")
	_G["AltoholicTabGuildMenuItem"..i]:StyleButton(hasChecked)
end
for i = 1, 14 do
	_G["AltoholicFrameGuildBankEntry1Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry2Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry3Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry4Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry5Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry6Item"..i]:StripTextures()
	_G["AltoholicFrameGuildBankEntry7Item"..i]:StripTextures()
end
for i = 1, 19 do
	_G["AltoholicFrameGuildMembersItem"..i]:StripTextures()
end

--Sorts
for i = 1, 5 do
	_G["AltoholicTabGuild_Sort"..i]:StripTextures()
	_G["AltoholicTabGuild_Sort"..i]:SetTemplate("Default")
	_G["AltoholicTabGuild_Sort"..i]:StyleButton(hasChecked)
end

end

S:RegisterSkin('Altoholic_Guild', LoadSkin)