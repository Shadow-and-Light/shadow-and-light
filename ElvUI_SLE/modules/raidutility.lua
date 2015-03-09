local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('Misc');

local function Enter(self)
	if not E.db.sle.rumouseover then return end
	self:SetAlpha(1)
end

local function Leave(self)
	if not E.db.sle.rumouseover then return end
	self:SetAlpha(0)
end

function M:RUReset()
	local a = E.db.sle.rumouseover and 0 or 1
	RaidUtility_ShowButton:SetAlpha(a)
end

--For moving raid utility button
local function MoreInit()
	if not RaidUtility_ShowButton then return end
	E:CreateMover(RaidUtility_ShowButton, "RaidUtility_Mover", L["Raid Utility"], nil, nil, nil, "ALL,S&L,S&L MISC")
	local mover = RaidUtility_Mover
	local frame = RaidUtility_ShowButton
	if E.db.movers == nil then E.db.movers = {} end
	
	mover:HookScript("OnDragStart", function(self) 
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", self)
	end)
	
	local function dropfix()
		local point, anchor, point2, x, y = mover:GetPoint()
		frame:ClearAllPoints()
		if string.find(point, "BOTTOM") then
			frame:SetPoint(point, anchor, point2, x, y)
		else
			frame:SetPoint(point, anchor, point2, x, y)		
		end
	end
	
	mover:HookScript("OnDragStop", dropfix)
	
	if E.db.movers.RaidUtility_Mover == nil then
		frame:ClearAllPoints()
		frame:SetPoint("TOP", E.UIParent, "TOP", -400, E.Border)
	else
		dropfix()
	end
	frame:RegisterForDrag("")
	frame:HookScript("OnEnter", Enter)
	frame:HookScript("OnLeave", Leave)
	Leave(frame)
end

hooksecurefunc(M, "Initialize", MoreInit)