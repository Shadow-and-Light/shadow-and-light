local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:NewModule('BackGrounds', 'AceHook-3.0', 'AceEvent-3.0');

local BGb = CreateFrame('Frame', "BottomBG", E.UIParent);
local BGl = CreateFrame('Frame', "LeftBG", E.UIParent);
local BGr = CreateFrame('Frame', "RightBG", E.UIParent);
local BGaction = CreateFrame('Frame', "ActionBG", E.UIParent);

--Frames setup
function BG:FramesCreate()
	--Bottom
	BGb:CreateBackdrop(E.private.sle.backgrounds.bottom.template);
	BGb.backdrop:SetAllPoints();
	BGb:SetFrameLevel(BGb:GetFrameLevel() - 1)
	BGb:SetFrameStrata('BACKGROUND');
	BGb:EnableMouse(true)
	BGb:SetScript("OnShow", function() BGb:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGb.tex = BGb:CreateTexture(nil, 'OVERLAY')
	BGb.tex:SetAlpha(0.5)

	--Left
	BGl:CreateBackdrop(E.private.sle.backgrounds.left.template);
	BGl.backdrop:SetAllPoints();
	BGl:SetFrameLevel(BGl:GetFrameLevel() - 1)
	BGl:SetFrameStrata('BACKGROUND');
	BGl:SetScript("OnShow", function() BGl:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGl.tex = BGl:CreateTexture(nil, 'OVERLAY')
	BGl.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)

	--Right
	BGr:CreateBackdrop(E.private.sle.backgrounds.right.template);
	BGr.backdrop:SetAllPoints();
	BGr:SetFrameLevel(BGr:GetFrameLevel() - 1)
	BGr:SetFrameStrata('BACKGROUND');
	BGr:SetScript("OnShow", function() BGr:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGr.tex = BGr:CreateTexture(nil, 'OVERLAY')
	BGr.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)	

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
	BGb:Hide()
	BGl:Hide()
	BGr:Hide()
	BGaction:Hide()
end

--Frames Size
function BG:FramesSize()
	BGb:SetWidth(E.db.sle.backgrounds.bottom.width)
	BGb:SetHeight(E.db.sle.backgrounds.bottom.height)

	BGl:SetWidth(E.db.sle.backgrounds.left.width)
	BGl:SetHeight(E.db.sle.backgrounds.left.height)

	BGr:SetWidth(E.db.sle.backgrounds.right.width)
	BGr:SetHeight(E.db.sle.backgrounds.right.height)

	BGaction:SetWidth(E.db.sle.backgrounds.action.width)
	BGaction:SetHeight(E.db.sle.backgrounds.action.height)
end

--Frames points
function BG:FramesPositions()
	BGb:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.bottom.xoffset, 21 + E.db.sle.backgrounds.bottom.yoffset); 
	BGl:Point("BOTTOMRIGHT", E.UIParent, "BOTTOM", -(E.screenwidth/4 + 32)/2 - 1 + E.db.sle.backgrounds.left.xoffset, 21 + E.db.sle.backgrounds.left.yoffset); 
	BGr:Point("BOTTOMLEFT", E.UIParent, "BOTTOM", (E.screenwidth/4 + 32)/2 + 1 + E.db.sle.backgrounds.right.xoffset, 21 + E.db.sle.backgrounds.right.yoffset); 
	BGaction:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.action.xoffset, E.screenheight/6 + 9 + E.db.sle.backgrounds.action.yoffset);
end

--Updating textures
function BG:UpdateTex()
	BGb.tex:Point('TOPLEFT', BGb, 'TOPLEFT', 2, -2)
	BGb.tex:Point('BOTTOMRIGHT', BGb, 'BOTTOMRIGHT', -2, 2)
	BGb.tex:SetTexture(E.db.sle.backgrounds.bottom.texture)
	
	BGr.tex:Point('TOPLEFT', BGr, 'TOPLEFT', 2, -2)
	BGr.tex:Point('BOTTOMRIGHT', BGr, 'BOTTOMRIGHT', -2, 2)
	BGr.tex:SetTexture(E.db.sle.backgrounds.right.texture)
	
	BGl.tex:Point('TOPLEFT', BGl, 'TOPLEFT', 2, -2)
	BGl.tex:Point('BOTTOMRIGHT', BGl, 'BOTTOMRIGHT', -2, 2)
	BGl.tex:SetTexture(E.db.sle.backgrounds.left.texture)
	
	BGaction.tex:Point('TOPLEFT', BGaction, 'TOPLEFT', 2, -2)
	BGaction.tex:Point('BOTTOMRIGHT', BGaction, 'BOTTOMRIGHT', -2, 2)
	BGaction.tex:SetTexture(E.db.sle.backgrounds.action.texture)
end

--Visibility / Enable check
function BG:FramesVisibility()
	if E.db.sle.backgrounds.bottom.enabled then
		BGb:Show()
	else
		BGb:Hide()
	end
	
	if E.db.sle.backgrounds.left.enabled then
		BGl:Show()
	else
		BGl:Hide()
	end
	
	if E.db.sle.backgrounds.right.enabled then
		BGr:Show()
	else
		BGr:Hide()
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