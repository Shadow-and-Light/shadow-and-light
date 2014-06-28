--Raid mark bar. Similar to quickmark which just semms to be impossible to skin
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RM = E:NewModule('SLE_RaidMarks', 'AceHook-3.0', 'AceEvent-3.0');
local Mtemplate = "SecureActionButtonTemplate"
local IsInInstance = IsInInstance
local UnitExists = UnitExists
local mark_menu, m1, m2, m3, m4, m5, m6, m7, m8, MarkB
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut

--Main frame
function RM:CreateFrame()
	mark_menu = CreateFrame("Frame", "Mark_Menu", E.UIParent)
	mark_menu:Point("BOTTOMRIGHT", RightChatTab, "TOPRIGHT", 2, 3) --Default positon
	mark_menu:SetFrameStrata('LOW');
	mark_menu:CreateBackdrop();
	mark_menu.backdrop:SetAllPoints();
	
	m1 = CreateFrame("Button", "M1", Mark_Menu, Mtemplate)
	m2 = CreateFrame("Button", "M2", Mark_Menu, Mtemplate)
	m3 = CreateFrame("Button", "M3", Mark_Menu, Mtemplate)
	m4 = CreateFrame("Button", "M4", Mark_Menu, Mtemplate)
	m5 = CreateFrame("Button", "M5", Mark_Menu, Mtemplate)
	m6 = CreateFrame("Button", "M6", Mark_Menu, Mtemplate)
	m7 = CreateFrame("Button", "M7", Mark_Menu, Mtemplate)
	m8 = CreateFrame("Button", "M8", Mark_Menu, Mtemplate)
	
	MarkB = {m1,m2,m3,m4,m5,m6,m7,m8}
	
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
	if not mark_menu then return end
	for i = 1, 8 do
		RM:SetupButton(MarkB[i], 9 - i)
	end
end

--Setting/updating buttons' size
function RM:FrameButtonsSize()
	if not mark_menu then return end
	for i = 1, 8 do
		MarkB[i]:Size(E.db.sle.marks.size)
	end
end

--Setting growth direction for buttons
function RM:FrameButtonsGrowth()
	if not mark_menu then return end
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
	if not mark_menu then return end
	local inInstance, instanceType = IsInInstance()
	local db = E.db.sle.marks
	local show = false
	if (inInstance and instanceType ~= "pvp") and db.showinside then
		if db.target and UnitExists("target") then
			show = true
		elseif db.target and not UnitExists("target") then
			show = false
		else
			show = true
		end
	elseif not inInstance and db.showinside then
		show = false
	elseif not db.showinside then
			if db.target and UnitExists("target") then
			show = true
		elseif db.target and not UnitExists("target") then
			show = false
		else
			show = true
		end
	end
	
	if show then
		E.FrameLocks['Mark_Menu'] = true
		mark_menu:Show()
		for i = 1, 8 do
			MarkB[i]:Show()
		end
	else
		E.FrameLocks['Mark_Menu'] = nil
		mark_menu:Hide()
		for i = 1, 8 do
			MarkB[i]:Hide()
		end
	end
	RM:Mouseover()
end

function RM:Target()
	if not mark_menu then return end
	local db = E.db.sle.marks
	if db.target then
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateVisibility");
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED");
	end
end

function RM:Backdrop()
	if not mark_menu then return end
	if E.db.sle.marks.backdrop then
		mark_menu.backdrop:Show()
	else
		mark_menu.backdrop:Hide()
	end
end

function RM:Mouseover()
	if not mark_menu then return end
	local db = E.db.sle.marks
	if db.mouseover then
		mark_menu:SetScript("OnUpdate", function(self)
			if MouseIsOver(self) then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			else
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			end
		end)
	else
		mark_menu:SetScript("OnUpdate", nil)
		if mark_menu:IsShown() then
			UIFrameFadeIn(mark_menu, 0.2, mark_menu:GetAlpha(), 1)
		end
	end
end

function RM:Update()
	if not mark_menu then return end
	RM:FrameButtonsSize()
	RM:FrameButtonsGrowth()
	RM:Target()
	RM:UpdateVisibility()
	RM:Backdrop()
end

function RM:Initialize()
	if not E.private.sle.marks.marks then return end
	RM:CreateFrame()
	RM:Update()
	RM:CreateButtons()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateVisibility");

	E:CreateMover(mark_menu, "MarkMover", "RM", nil, nil, nil, "ALL,S&L,S&L MISC")
end

E:RegisterModule(RM:GetName())