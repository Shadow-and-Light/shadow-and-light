local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:NewModule('BackGrounds', 'AceHook-3.0', 'AceEvent-3.0');

local BGb = CreateFrame('Frame', "BottomBG", E.UIParent);
local BGl = CreateFrame('Frame', "LeftBG", E.UIParent);
local BGr = CreateFrame('Frame', "RightBG", E.UIParent);
local BGa = CreateFrame('Frame', "ActionBG", E.UIParent);

local Fr = {
	b = {BGb,"bottom"},
	l = {BGl,"left"},
	r = {BGr,"right"},
	a = {BGa,"action"},
}

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
	BGa:CreateBackdrop(E.private.sle.backgrounds.action.template);
	BGa.backdrop:SetAllPoints();
	BGa:SetFrameLevel(BGa:GetFrameLevel() - 1)
	BGa:SetFrameStrata('BACKGROUND');
	BGa:EnableMouse(true)
	BGa:SetScript("OnShow", function() BGa:SetFrameStrata('BACKGROUND') end)
	--Texture
	BGa.tex = BGa:CreateTexture(nil, 'OVERLAY')
	BGa.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)
	
	--Hiding
	BGb:Hide()
	BGl:Hide()
	BGr:Hide()
	BGa:Hide()
end

--Frames Size
function BG:FramesSize()
	local db = E.db.sle.backgrounds
	for k,v in pairs(Fr) do
		v[1]:SetWidth(db[v[2]].width)
		v[1]:SetHeight(db[v[2]].height)
	end
end

--Frames points
function BG:FramesPositions()
	BGb:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.bottom.xoffset, 21 + E.db.sle.backgrounds.bottom.yoffset); 
	BGl:Point("BOTTOMRIGHT", E.UIParent, "BOTTOM", -(E.screenwidth/4 + 32)/2 - 1 + E.db.sle.backgrounds.left.xoffset, 21 + E.db.sle.backgrounds.left.yoffset); 
	BGr:Point("BOTTOMLEFT", E.UIParent, "BOTTOM", (E.screenwidth/4 + 32)/2 + 1 + E.db.sle.backgrounds.right.xoffset, 21 + E.db.sle.backgrounds.right.yoffset); 
	BGa:Point("BOTTOM", E.UIParent, "BOTTOM", 0 + E.db.sle.backgrounds.action.xoffset, E.screenheight/6 + 9 + E.db.sle.backgrounds.action.yoffset);
end

--Updating textures
function BG:UpdateTex()
	local db = E.db.sle.backgrounds
	for k,v in pairs(Fr) do
		v[1].tex:Point('TOPLEFT', v[1], 'TOPLEFT', 2, -2)
		v[1].tex:Point('BOTTOMRIGHT', v[1], 'BOTTOMRIGHT', -2, 2)
		v[1].tex:SetTexture(db[v[2]].texture)
	end
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
		BGa:Show()
	else
		BGa:Hide()
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