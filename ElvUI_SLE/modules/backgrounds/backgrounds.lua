local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:NewModule('BackGrounds', 'AceHook-3.0', 'AceEvent-3.0');

local BGb = CreateFrame('Frame', "BottomBG", E.UIParent);
local BGl = CreateFrame('Frame', "LeftBG", E.UIParent);
local BGr = CreateFrame('Frame', "RightBG", E.UIParent);
local BGa = CreateFrame('Frame', "ActionBG", E.UIParent);

local Fr = {
	BottomBG = {BGb,"bottom"},
	LeftBG = {BGl,"left"},
	RightBG = {BGr,"right"},
	ActionBG = {BGa,"action"},
}

--Frames setup
function BG:FramesCreate()
	local pr = E.private.sle.backgrounds
	for _,v in pairs(Fr) do
		v[1]:CreateBackdrop(pr[v[2]].template);
		v[1].backdrop:SetAllPoints();
		v[1]:SetFrameLevel(v[1]:GetFrameLevel() - 1)
		v[1]:SetScript("OnShow", function() v[1]:SetFrameStrata('BACKGROUND') end)
		v[1].tex = v[1]:CreateTexture(nil, 'OVERLAY')
		v[1]:Hide()
	end
	
	BGb:EnableMouse(true) --Maybe add an option to actually allow change this click catching?
	BGb.tex:SetAlpha(0.5) 
	--Also the problem. As long as bottom bg can be transparent it's no good in keeping fixed transparency for the texture.
	--Maybe add an option to change this from using Elv's trnsparency to additional user-set one?
	BGl.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)

	BGr.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)	

	BGa:EnableMouse(true)
	BGa.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)
end

--Frames Size
function BG:FramesSize()
	local db = E.db.sle.backgrounds
	for _,v in pairs(Fr) do
		v[1]:SetSize(db[v[2]].width, db[v[2]].height)
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
	for _,v in pairs(Fr) do
		v[1].tex:Point('TOPLEFT', v[1], 'TOPLEFT', 2, -2)
		v[1].tex:Point('BOTTOMRIGHT', v[1], 'BOTTOMRIGHT', -2, 2)
		v[1].tex:SetTexture(db[v[2]].texture)
	end
end

--Visibility / Enable check
function BG:FramesVisibility()
	local db = E.db.sle.backgrounds
	for _,v in pairs(Fr) do
		if db[v[2]].enabled then
			v[1]:Show()
		else
			v[1]:Hide()
		end
	end
end

function BG:UpdateFrames()
	BG:FramesSize()
	BG:FramesPositions()
	BG:FramesVisibility()
    BG:UpdateTex()
end

function BG:RegisterHide()
	local db = E.db.sle.backgrounds
	for k,v in pairs(Fr) do
		if db[v[2]].pethide then
			E.FrameLocks[k] = true
		else
			E.FrameLocks[k] = nil
		end
	end
end

function BG:Initialize()
	BG:FramesCreate()
	BG:UpdateFrames()
	BG:RegisterHide()
end

E:RegisterModule(BG:GetName())