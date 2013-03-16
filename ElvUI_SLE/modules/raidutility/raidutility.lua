local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RU = E:GetModule('RaidUtility');
local M = E:GetModule('Misc');

E.RaidUtility = RU

--For moving raid utility button
M.InitializeSLE = M.Initialize
function M:Initialize()
	M.InitializeSLE(self)
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
end

RaidUtility_ShowButton:RegisterForDrag("") --Unregister any buttons for dragging. 
