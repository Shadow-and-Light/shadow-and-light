local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	--Tab1 LFG
	libTabTabDBtabs1:StripTextures()
	S:HandleTab(libTabTabDBtabs1)
	libTabTabDBtabs1:SetTemplate("Default")
	libTabTabDBtabs1.tex = libTabTabDBtabs1:CreateTexture(nil, 'OVERLAY')
	libTabTabDBtabs1.tex:Point('TOPLEFT', libTabTabDBtabs1, 'TOPLEFT', 2, -2)
	libTabTabDBtabs1.tex:Point('BOTTOMRIGHT', libTabTabDBtabs1, 'BOTTOMRIGHT', -2, 2)
	libTabTabDBtabs1.tex:SetTexture("Interface\\LFGFrame\\UI-LFG-PORTRAIT")
	
	--Tab2 LFR
	libTabTabDBtabs2:StripTextures()
	S:HandleTab(libTabTabDBtabs2)
	libTabTabDBtabs2:SetTemplate("Default")
	libTabTabDBtabs2.tex = libTabTabDBtabs2:CreateTexture(nil, 'OVERLAY')
	libTabTabDBtabs2.tex:Point('TOPLEFT', libTabTabDBtabs2, 'TOPLEFT', 2, -3)
	libTabTabDBtabs2.tex:Point('BOTTOMRIGHT', libTabTabDBtabs2, 'BOTTOMRIGHT', -2, 1)
	libTabTabDBtabs2.tex:SetTexture("Interface\\LFGFrame\\UI-LFR-PORTRAIT")
	
	--Tab3 PvP
	libTabTabDBtabs3:StripTextures()
	S:HandleTab(libTabTabDBtabs3)
	libTabTabDBtabs3:SetTemplate("Default")
	libTabTabDBtabs3.tex = libTabTabDBtabs3:CreateTexture(nil, 'OVERLAY')
	libTabTabDBtabs3.tex:Point('TOPLEFT', libTabTabDBtabs3, 'TOPLEFT', 2, -2)
	libTabTabDBtabs3.tex:Point('BOTTOMRIGHT', libTabTabDBtabs3, 'BOTTOMRIGHT', -2, 2)
	libTabTabDBtabs3.tex:SetTexture("Interface\\BattlefieldFrame\\UI-Battlefield-Icon")
end

S:RegisterSkin("tabDB", LoadSkin)