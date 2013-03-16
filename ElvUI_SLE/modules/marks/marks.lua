--Raid mark bar. Similar to quickmark which just semms to be impossible to skin
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RM = E:NewModule('RaidMarks', 'AceHook-3.0', 'AceEvent-3.0');
local Mtemplate = "SecureActionButtonTemplate"

local mark_menu = CreateFrame("Frame", "Mark_Menu", E.UIParent)
local m1 = CreateFrame("Button", "M1", Mark_Menu, Mtemplate)
local m2 = CreateFrame("Button", "M2", Mark_Menu, Mtemplate)
local m3 = CreateFrame("Button", "M3", Mark_Menu, Mtemplate)
local m4 = CreateFrame("Button", "M4", Mark_Menu, Mtemplate)
local m5 = CreateFrame("Button", "M5", Mark_Menu, Mtemplate)
local m6 = CreateFrame("Button", "M6", Mark_Menu, Mtemplate)
local m7 = CreateFrame("Button", "M7", Mark_Menu, Mtemplate)
local m8 = CreateFrame("Button", "M8", Mark_Menu, Mtemplate)

local MarkB = {m1,m2,m3,m4,m5,m6,m7,m8}


--Main frame
function RM:CreateFrame()
	mark_menu:Point("BOTTOMRIGHT", RightChatTab, "TOPRIGHT", 2, 3) --Default positon
	mark_menu:SetFrameStrata('LOW');
	mark_menu:CreateBackdrop();
	mark_menu.backdrop:SetAllPoints();
	
	mark_menu:Hide()
end

function RM:SetupButton(button, mark)
	button:CreateBackdrop()
	button.backdrop:SetAllPoints()
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext",  '/script SetRaidTargetIcon("target",'..mark..')')
	
	button.tex = button:CreateTexture(nil, 'OVERLAY')
	button.tex:Point('TOPLEFT', button, 'TOPLEFT', 2, -2)
	button.tex:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
	button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_"..mark)
end

--Buttons creation
function RM:CreateButtons()
	for i = 1, 8 do
		RM:SetupButton(MarkB[i], 9 - i)
	end
end

--Setting/updating buttons' size
function RM:FrameButtonsSize()
	for i = 1, 8 do
		MarkB[i]:Size(E.db.sle.marks.size)
	end
end

--Setting growth direction for buttons
function RM:FrameButtonsGrowth()
	local db = E.db.sle.marks
	local size = db.size
	local width, height, x, y, anchor, point
	local t = {8*size+11,size+4,"LEFT","RIGHT","TOP","BOTTOM",1,0,-1}
	for i = 1, 8 do
		MarkB[i]:ClearAllPoints()
	end
	
	if db.growth == "RIGHT" then
		width, height, anchor, point, _, _, x, y = unpack(t)
	elseif db.growth == "LEFT" then
		width, height, point, anchor, _, _, _, y, x = unpack(t)
	elseif db.growth == "UP" then
		height, width, _, _, point, anchor, y, x = unpack(t)
	elseif db.growth == "DOWN" then
		height, width, _, _, anchor, point, _, x, y = unpack(t)
	end

	mark_menu:SetWidth(width)
	mark_menu:SetHeight(height)

	for i = 1, 8 do
		if i == 1 then
			MarkB[i]:Point(anchor, Mark_Menu, anchor, 2 * x, 2 * y)
		else
			MarkB[i]:Point(anchor, MarkB[i-1], point, x, y)
		end
	end
end

--Visibility/enable check
function RM:UpdateVisibility()
	local inInstance, instanceType = IsInInstance()
	local db = E.db.sle.marks
	if db.enabled then
		if (inInstance and instanceType ~= "pvp") and db.showinside then
			E.FrameLocks['Mark_Menu'] = true -- Because theyre thinking of adding battle pets to raids
			mark_menu:Show()
		elseif not inInstance and db.showinside then
			E.FrameLocks['Mark_Menu'] = nil
			mark_menu:Hide()
		elseif not db.showinside then
			E.FrameLocks['Mark_Menu'] = true
			mark_menu:Show()
		end
	else
		E.FrameLocks['Mark_Menu'] = true
		mark_menu:Hide()
	end
end

function RM:Backdrop()
	if E.db.sle.marks.backdrop then
		mark_menu.backdrop:Show()
	else
		mark_menu.backdrop:Hide()
	end
end

function RM:Update()
	RM:FrameButtonsSize()
	RM:FrameButtonsGrowth()
	RM:UpdateVisibility()
	RM:Backdrop()
end

function RM:Initialize()
	RM:CreateFrame()
	RM:Update()
	RM:CreateButtons()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateVisibility");

	E:CreateMover(mark_menu, "MarkMover", "RM", nil, nil, nil, "ALL,S&L,S&L MISC")
end

E:RegisterModule(RM:GetName())