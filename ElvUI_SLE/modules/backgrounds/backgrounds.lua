local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:NewModule('BackGrounds', 'AceHook-3.0', 'AceEvent-3.0');

local BGbottom = CreateFrame('Frame', "BottomBG", E.UIParent);
local BGleft = CreateFrame('Frame', "LeftBG", E.UIParent);
local BGright = CreateFrame('Frame', "RightBG", E.UIParent);
local BGaction = CreateFrame('Frame', "ActionBG", E.UIParent);

--Frames setup
function BG:FramesCreate()
	--Bottom
	BGbottom:CreateBackdrop(E.private.sle.backgrounds.bottom.template);
	BGbottom.backdrop:SetAllPoints();
	BGbottom:SetFrameLevel(BGbottom:GetFrameLevel() - 1)
	BGbottom:SetFrameStrata('BACKGROUND');
	BGbottom:EnableMouse(true)
	BGbottom:SetScript("OnShow", function() BGbottom:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGbottom.tex = BGbottom:CreateTexture(nil, 'OVERLAY')
	BGbottom.tex:SetAlpha(0.5)

	--Left
	BGleft:CreateBackdrop(E.private.sle.backgrounds.left.template);
	BGleft.backdrop:SetAllPoints();
	BGleft:SetFrameLevel(BGleft:GetFrameLevel() - 1)
	BGleft:SetFrameStrata('BACKGROUND');
	BGleft:SetScript("OnShow", function() BGleft:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGleft.tex = BGleft:CreateTexture(nil, 'OVERLAY')
	BGleft.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)

	--Right
	BGright:CreateBackdrop(E.private.sle.backgrounds.right.template);
	BGright.backdrop:SetAllPoints();
	BGright:SetFrameLevel(BGright:GetFrameLevel() - 1)
	BGright:SetFrameStrata('BACKGROUND');
	BGright:SetScript("OnShow", function() BGright:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGright.tex = BGright:CreateTexture(nil, 'OVERLAY')
	BGright.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)	

	--Action
	BGaction:CreateBackdrop(E.private.sle.backgrounds.action.template);
	BGaction.backdrop:SetAllPoints();
	BGaction:SetFrameLevel(BGaction:GetFrameLevel() - 1)
	BGaction:SetFrameStrata('BACKGROUND');
	BGaction:EnableMouse(true)
	BGaction:SetScript("OnShow", function() BGaction:SetFrameStrata('BACKGROUND') end)
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
	BGbottom:SetWidth(E.db.sle.backgrounds.bottom.width)
	BGbottom:SetHeight(E.db.sle.backgrounds.bottom.height)

	BGleft:SetWidth(E.db.sle.backgrounds.left.width)
	BGleft:SetHeight(E.db.sle.backgrounds.left.height)

	BGright:SetWidth(E.db.sle.backgrounds.right.width)
	BGright:SetHeight(E.db.sle.backgrounds.right.height)

	BGaction:SetWidth(E.db.sle.backgrounds.action.width)
	BGaction:SetHeight(E.db.sle.backgrounds.action.height)
end

--Frames points
function BG:FramesPositions()
	BGbottom:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.bottom.xoffset, 21 + E.db.sle.backgrounds.bottom.yoffset); 
	BGleft:Point("BOTTOMRIGHT", E.UIParent, "BOTTOM", -(E.screenwidth/4 + 32)/2 - 1 + E.db.sle.backgrounds.left.xoffset, 21 + E.db.sle.backgrounds.left.yoffset); 
	BGright:Point("BOTTOMLEFT", E.UIParent, "BOTTOM", (E.screenwidth/4 + 32)/2 + 1 + E.db.sle.backgrounds.right.xoffset, 21 + E.db.sle.backgrounds.right.yoffset); 
	BGaction:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.action.xoffset, E.screenheight/6 + 9 + E.db.sle.backgrounds.action.yoffset);
end

--Updating textures
function BG:UpdateTex()
	BGbottom.tex:Point('TOPLEFT', BGbottom, 'TOPLEFT', 2, -2)
	BGbottom.tex:Point('BOTTOMRIGHT', BGbottom, 'BOTTOMRIGHT', -2, 2)
	BGbottom.tex:SetTexture(E.db.sle.backgrounds.bottom.texture)
	
	BGright.tex:Point('TOPLEFT', BGright, 'TOPLEFT', 2, -2)
	BGright.tex:Point('BOTTOMRIGHT', BGright, 'BOTTOMRIGHT', -2, 2)
	BGright.tex:SetTexture(E.db.sle.backgrounds.right.texture)
	
	BGleft.tex:Point('TOPLEFT', BGleft, 'TOPLEFT', 2, -2)
	BGleft.tex:Point('BOTTOMRIGHT', BGleft, 'BOTTOMRIGHT', -2, 2)
	BGleft.tex:SetTexture(E.db.sle.backgrounds.left.texture)
	
	BGaction.tex:Point('TOPLEFT', BGaction, 'TOPLEFT', 2, -2)
	BGaction.tex:Point('BOTTOMRIGHT', BGaction, 'BOTTOMRIGHT', -2, 2)
	BGaction.tex:SetTexture(E.db.sle.backgrounds.action.texture)
end

--Visibility / Enable check
function BG:FramesVisibility()
	if E.db.sle.backgrounds.bottom.enabled then
		BGbottom:Show()
	else
		BGbottom:Hide()
	end
	
	if E.db.sle.backgrounds.left.enabled then
		BGleft:Show()
	else
		BGleft:Hide()
	end
	
	if E.db.sle.backgrounds.right.enabled then
		BGright:Show()
	else
		BGright:Hide()
	end
	
	if E.db.sle.backgrounds.action.enabled then
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

function BG:RegisterHide()
	if E.db.sle.backgrounds.bottom.pethide then
		E.FrameLocks['BottomBG'] = true
	else
		E.FrameLocks['BottomBG'] = nil
	end
	if E.db.sle.backgrounds.left.pethide then
		E.FrameLocks['LeftBG'] = true
	else
		E.FrameLocks['LeftBG'] = nil
	end
	if E.db.sle.backgrounds.right.pethide then
		E.FrameLocks['RightBG'] = true
	else
		E.FrameLocks['RightBG'] = nil
	end
	if E.db.sle.backgrounds.action.pethide then
		E.FrameLocks['ActionBG'] = true
	else
		E.FrameLocks['ActionBG'] = nil
	end
end

function BG:Initialize()
	BG:FramesCreate()
	BG:UpdateFrames()
	BG:RegisterHide()
end

E:RegisterModule(BG:GetName())