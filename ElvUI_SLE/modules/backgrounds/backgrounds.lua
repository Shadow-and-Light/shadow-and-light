--Submodule to create several backgrounds for some elements
local E, L, V, P, G =  unpack(ElvUI); --Engine
local BG = E:NewModule('BackGrounds', 'AceHook-3.0', 'AceEvent-3.0');

local BGbottom = CreateFrame('Frame', "BottomBG", E.UIParent);
local BGleft = CreateFrame('Frame', "LeftBG", E.UIParent);
local BGright = CreateFrame('Frame', "RightBG", E.UIParent);
local BGaction = CreateFrame('Frame', "ActionBG", E.UIParent);

--Frames setup
function BG:FramesCreate()
	--Bottom
	BGbottom:CreateBackdrop('Default');
	BGbottom.backdrop:SetAllPoints();
	BGbottom:SetFrameLevel(5);
	BGbottom:SetFrameStrata('BACKGROUND');
	BGbottom:EnableMouse(true)
	--Texture
	BGbottom.tex = BGbottom:CreateTexture(nil, 'OVERLAY')
	BGbottom.tex:SetAlpha(0.5)

	--Left
	BGleft:CreateBackdrop('Transparent');
	BGleft.backdrop:SetAllPoints();
	BGleft:SetFrameLevel(5);
	BGleft:SetFrameStrata('BACKGROUND');
	--Texture
	BGleft.tex = BGleft:CreateTexture(nil, 'OVERLAY')
	BGleft.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)

	--Right
	BGright:CreateBackdrop('Transparent');
	BGright.backdrop:SetAllPoints();
	BGright:SetFrameLevel(5);
	BGright:SetFrameStrata('BACKGROUND');
	--Texture
	BGright.tex = BGright:CreateTexture(nil, 'OVERLAY')
	BGright.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)	

	--Action
	BGaction:CreateBackdrop('Default');
	BGaction.backdrop:SetAllPoints();
	BGaction:SetFrameLevel(5);
	BGaction:SetFrameStrata('BACKGROUND');
	BGaction:EnableMouse(true)
	--Texture
	BGaction.tex = BGaction:CreateTexture(nil, 'OVERLAY')
	BGaction.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)
	
	--Hiding
	BGbottom:Hide()
	BGleft:Hide()
	BGright:Hide()
	BGaction:Hide()
end

--Frames Size
function BG:FramesSize()
	BGbottom:SetWidth(E.db.dpe.backgrounds.bottom.width)
	BGbottom:SetHeight(E.db.dpe.backgrounds.bottom.height)

	BGleft:SetWidth(E.db.dpe.backgrounds.left.width)
	BGleft:SetHeight(E.db.dpe.backgrounds.left.height)

	BGright:SetWidth(E.db.dpe.backgrounds.right.width)
	BGright:SetHeight(E.db.dpe.backgrounds.right.height)

	BGaction:SetWidth(E.db.dpe.backgrounds.action.width)
	BGaction:SetHeight(E.db.dpe.backgrounds.action.height)
end

--Frames points
function BG:FramesPositions()
	BGbottom:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.dpe.backgrounds.bottom.xoffset, 21 + E.db.dpe.backgrounds.bottom.yoffset); 
	BGleft:Point("BOTTOMRIGHT", E.UIParent, "BOTTOM", -(E.screenwidth/4 + 32)/2 - 1 + E.db.dpe.backgrounds.left.xoffset, 21 + E.db.dpe.backgrounds.left.yoffset); 
	BGright:Point("BOTTOMLEFT", E.UIParent, "BOTTOM", (E.screenwidth/4 + 32)/2 + 1 + E.db.dpe.backgrounds.right.xoffset, 21 + E.db.dpe.backgrounds.right.yoffset); 
	BGaction:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.dpe.backgrounds.action.xoffset, E.screenheight/6 + 9 + E.db.dpe.backgrounds.action.yoffset);
end

--Updating textures
function BG:UpdateTex()
	BGbottom.tex:Point('TOPLEFT', BGbottom, 'TOPLEFT', 2, -2)
	BGbottom.tex:Point('BOTTOMRIGHT', BGbottom, 'BOTTOMRIGHT', -2, 2)
	BGbottom.tex:SetTexture(E.db.dpe.backgrounds.bottom.texture)
	
	BGright.tex:Point('TOPLEFT', BGright, 'TOPLEFT', 2, -2)
	BGright.tex:Point('BOTTOMRIGHT', BGright, 'BOTTOMRIGHT', -2, 2)
	BGright.tex:SetTexture(E.db.dpe.backgrounds.right.texture)
	
	BGleft.tex:Point('TOPLEFT', BGleft, 'TOPLEFT', 2, -2)
	BGleft.tex:Point('BOTTOMRIGHT', BGleft, 'BOTTOMRIGHT', -2, 2)
	BGleft.tex:SetTexture(E.db.dpe.backgrounds.left.texture)
	
	BGaction.tex:Point('TOPLEFT', BGaction, 'TOPLEFT', 2, -2)
	BGaction.tex:Point('BOTTOMRIGHT', BGaction, 'BOTTOMRIGHT', -2, 2)
	BGaction.tex:SetTexture(E.db.dpe.backgrounds.action.texture)
end

--Visibility / Enable check
function BG:FramesVisibility()
	if E.db.dpe.backgrounds.bottom.enabled then
		BGbottom:Show()
	else
		BGbottom:Hide()
	end
	
	if E.db.dpe.backgrounds.left.enabled then
		BGleft:Show()
	else
		BGleft:Hide()
	end
	
	if E.db.dpe.backgrounds.right.enabled then
		BGright:Show()
	else
		BGright:Hide()
	end
	
	if E.db.dpe.backgrounds.action.enabled then
		BGaction:Show()
	else
		BGaction:Hide()
	end
end

function BG:UpdateFrames()
	BG:FramesSize()
	BG:FramesPositions()
	BG:FramesVisibility()
    BG:UpdateTex()
end

--Hook to updating during profile change
E.UpdateAllHUD = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllHUD(self)
	
	BG:UpdateFrames()
end

function BG:Initialize()
	BG:FramesPositions()
	BG:FramesSize()
	BG:FramesCreate()
	BG:FramesVisibility()
	BG:UpdateTex()
end

E:RegisterModule(BG:GetName())