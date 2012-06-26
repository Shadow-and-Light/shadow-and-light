--Raid mark bar. Similar to quickmark which just semms to be impossible to skin
local E, L, V, P, G = unpack(ElvUI); --Engine
local RM = E:NewModule('RaidMarks', 'AceHook-3.0', 'AceEvent-3.0');

local mark_menu = CreateFrame("Frame", "Mark_Menu", E.UIParent)
local m1 = CreateFrame("Button", "M1", Mark_Menu, "SecureActionButtonTemplate")
local m2 = CreateFrame("Button", "M2", Mark_Menu, "SecureActionButtonTemplate")
local m3 = CreateFrame("Button", "M3", Mark_Menu, "SecureActionButtonTemplate")
local m4 = CreateFrame("Button", "M4", Mark_Menu, "SecureActionButtonTemplate")
local m5 = CreateFrame("Button", "M5", Mark_Menu, "SecureActionButtonTemplate")
local m6 = CreateFrame("Button", "M6", Mark_Menu, "SecureActionButtonTemplate")
local m7 = CreateFrame("Button", "M7", Mark_Menu, "SecureActionButtonTemplate")
local m8 = CreateFrame("Button", "M8", Mark_Menu, "SecureActionButtonTemplate")

--Main frame
function RM:CreateFrame()
	mark_menu:Point('CENTER', E.UIParent, 'CENTER', 0, 0) --Default positon
	mark_menu:SetFrameStrata('LOW');
	mark_menu:CreateBackdrop('Default');
	mark_menu.backdrop:SetAllPoints();
	
	mark_menu:Hide()
end

--Buttons creation
function RM:SetButtonAttributes()
	--Skull
	m1:CreateBackdrop('Default');
	m1.backdrop:SetAllPoints();
	m1:SetAttribute("type", "macro");
	m1:SetAttribute("macrotext",  '/script SetRaidTarget("target",8)');
	--texture
	m1.tex = m1:CreateTexture(nil, 'OVERLAY')
	m1.tex:Point('TOPLEFT', m1, 'TOPLEFT', 2, -2)
	m1.tex:Point('BOTTOMRIGHT', m1, 'BOTTOMRIGHT', -2, 2)
	m1.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_8")

	--Cross
	m2:CreateBackdrop('Default');
	m2.backdrop:SetAllPoints();
	m2:SetAttribute("type", "macro");
	m2:SetAttribute("macrotext",  '/script SetRaidTarget("target",7)');
	--texture
	m2.tex = m2:CreateTexture(nil, 'OVERLAY')
	m2.tex:Point('TOPLEFT', m2, 'TOPLEFT', 2, -2)
	m2.tex:Point('BOTTOMRIGHT', m2, 'BOTTOMRIGHT', -2, 2)
	m2.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_7")

	--Square
	m3:CreateBackdrop('Default');
	m3.backdrop:SetAllPoints();
	m3:SetAttribute("type", "macro");
	m3:SetAttribute("macrotext",  '/script SetRaidTarget("target",6)');
	--texture
	m3.tex = m3:CreateTexture(nil, 'OVERLAY')
	m3.tex:Point('TOPLEFT', m3, 'TOPLEFT', 2, -2)
	m3.tex:Point('BOTTOMRIGHT', m3, 'BOTTOMRIGHT', -2, 2)
	m3.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_6")

	--Moon
	m4:CreateBackdrop('Default');
	m4.backdrop:SetAllPoints();
	m4:SetAttribute("type", "macro");
	m4:SetAttribute("macrotext",  '/script SetRaidTarget("target",5)');
	--texture
	m4.tex = m4:CreateTexture(nil, 'OVERLAY')
	m4.tex:Point('TOPLEFT', m4, 'TOPLEFT', 2, -2)
	m4.tex:Point('BOTTOMRIGHT', m4, 'BOTTOMRIGHT', -2, 2)
	m4.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_5")

	--Triangle
	m5:CreateBackdrop('Default');
	m5.backdrop:SetAllPoints();
	m5:SetAttribute("type", "macro");
	m5:SetAttribute("macrotext",  '/script SetRaidTarget("target",4)');
	--texture
	m5.tex = m5:CreateTexture(nil, 'OVERLAY')
	m5.tex:Point('TOPLEFT', m5, 'TOPLEFT', 2, -2)
	m5.tex:Point('BOTTOMRIGHT', m5, 'BOTTOMRIGHT', -3, 2)
	m5.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_4")

	--Diamond
	m6:CreateBackdrop('Default');
	m6.backdrop:SetAllPoints();
	m6:SetAttribute("type", "macro");
	m6:SetAttribute("macrotext",  '/script SetRaidTarget("target",3)');
	--texture
	m6.tex = m6:CreateTexture(nil, 'OVERLAY')
	m6.tex:Point('TOPLEFT', m6, 'TOPLEFT', 2, -2)
	m6.tex:Point('BOTTOMRIGHT', m6, 'BOTTOMRIGHT', -2, 2)
	m6.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_3")

	--Circle
	m7:CreateBackdrop('Default');
	m7.backdrop:SetAllPoints();
	m7:SetAttribute("type", "macro");
	m7:SetAttribute("macrotext",  '/script SetRaidTarget("target",2)');
	--texture
	m7.tex = m7:CreateTexture(nil, 'OVERLAY')
	m7.tex:Point('TOPLEFT', m7, 'TOPLEFT', 2, -2)
	m7.tex:Point('BOTTOMRIGHT', m7, 'BOTTOMRIGHT', -2, 2)
	m7.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_2")

	--Star
	m8:CreateBackdrop('Default');
	m8.backdrop:SetAllPoints();
	m8:SetAttribute("type", "macro");
	m8:SetAttribute("macrotext",  '/script SetRaidTarget("target",1)');
	--texture
	m8.tex = m8:CreateTexture(nil, 'OVERLAY')
	m8.tex:Point('TOPLEFT', m8, 'TOPLEFT', 2, -2)
	m8.tex:Point('BOTTOMRIGHT', m8, 'BOTTOMRIGHT', -2, 2)
	m8.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_1")
end

--Setting/updating buttons' size
function RM:FrameButtonsSize()
	m1:Size(E.db.dpe.marks.size)
	m2:Size(E.db.dpe.marks.size)
	m3:Size(E.db.dpe.marks.size)
	m4:Size(E.db.dpe.marks.size)
	m5:Size(E.db.dpe.marks.size)
	m6:Size(E.db.dpe.marks.size)
	m7:Size(E.db.dpe.marks.size)
	m8:Size(E.db.dpe.marks.size)
end

--Setting growth direction for buttons
function RM:FrameButtonsGrowth()
	m1:ClearAllPoints()
	m2:ClearAllPoints()
	m3:ClearAllPoints()
	m4:ClearAllPoints()
	m5:ClearAllPoints()
	m6:ClearAllPoints()
	m7:ClearAllPoints()
	m8:ClearAllPoints()
	
	if E.db.dpe.marks.growth == "RIGHT" then
		mark_menu:SetWidth(8 * E.db.dpe.marks.size + 11)
		mark_menu:SetHeight(E.db.dpe.marks.size + 4)
		m1:Point('LEFT', Mark_Menu, 'LEFT', 2, 0) 
		m2:Point('LEFT', m1, 'RIGHT', 1, 0) 
		m3:Point('LEFT', m2, 'RIGHT', 1, 0) 
		m4:Point('LEFT', m3, 'RIGHT', 1, 0) 
		m5:Point('LEFT', m4, 'RIGHT', 1, 0) 
		m6:Point('LEFT', m5, 'RIGHT', 1, 0) 
		m7:Point('LEFT', m6, 'RIGHT', 1, 0) 
		m8:Point('LEFT', m7, 'RIGHT', 1, 0) 
	elseif E.db.dpe.marks.growth == "LEFT" then
		mark_menu:SetWidth(8 * E.db.dpe.marks.size + 11)
		mark_menu:SetHeight(E.db.dpe.marks.size + 4)
		m1:Point('RIGHT', Mark_Menu, 'RIGHT', -2, 0) 
		m2:Point('RIGHT', m1, 'LEFT', -1, 0) 
		m3:Point('RIGHT', m2, 'LEFT', -1, 0) 
		m4:Point('RIGHT', m3, 'LEFT', -1, 0) 
		m5:Point('RIGHT', m4, 'LEFT', -1, 0) 
		m6:Point('RIGHT', m5, 'LEFT', -1, 0) 
		m7:Point('RIGHT', m6, 'LEFT', -1, 0) 
		m8:Point('RIGHT', m7, 'LEFT', -1, 0) 
	elseif E.db.dpe.marks.growth == "UP" then
		mark_menu:SetHeight(8 * E.db.dpe.marks.size + 11)
		mark_menu:SetWidth(E.db.dpe.marks.size + 4)
		m1:Point('BOTTOM', Mark_Menu, 'BOTTOM', 0, 2) 
		m2:Point('BOTTOM', m1, 'TOP', 0, 1) 
		m3:Point('BOTTOM', m2, 'TOP', 0, 1) 
		m4:Point('BOTTOM', m3, 'TOP', 0, 1) 
		m5:Point('BOTTOM', m4, 'TOP', 0, 1) 
		m6:Point('BOTTOM', m5, 'TOP', 0, 1) 
		m7:Point('BOTTOM', m6, 'TOP', 0, 1)
		m8:Point('BOTTOM', m7, 'TOP', 0, 1)
	elseif E.db.dpe.marks.growth == "DOWN" then
		mark_menu:SetHeight(8 * E.db.dpe.marks.size + 11)
		mark_menu:SetWidth(E.db.dpe.marks.size + 4)
		m1:Point('TOP', Mark_Menu, 'TOP', 0, -2) 
		m2:Point('TOP', m1, 'BOTTOM', 0, -1) 
		m3:Point('TOP', m2, 'BOTTOM', 0, -1) 
		m4:Point('TOP', m3, 'BOTTOM', 0, -1) 
		m5:Point('TOP', m4, 'BOTTOM', 0, -1) 
		m6:Point('TOP', m5, 'BOTTOM', 0, -1) 
		m7:Point('TOP', m6, 'BOTTOM', 0, -1)
		m8:Point('TOP', m7, 'BOTTOM', 0, -1)
	end
end

--Visibility/enable check
function RM:UpdateVisibility()
	if E.db.dpe.marks.enabled then
		mark_menu:Show()
	else
		mark_menu:Hide()
	end
end

function RM:Initialize()
	RM:CreateFrame()
	RM:FrameButtonsSize()
	RM:FrameButtonsGrowth()
	RM:SetButtonAttributes()
	RM:UpdateVisibility()
	
	E:CreateMover(mark_menu, "MarkMover", "RM")
end

E:RegisterModule(RM:GetName())