local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RU = E:GetModule('RaidUtility');
local M = E:GetModule('Misc');

E.RaidUtility = RU

--Moved RU down cause of top datatext panels
function RU:MoveButton()
	RaidUtility_ShowButton:ClearAllPoints()
	RaidUtility_ShowButton:Point("CENTER", E.UIParent, "BOTTOMLEFT", E.db.sle.raidutil.xpos, E.db.sle.raidutil.ypos)
end

--For moving raid utility button
M.InitializeSLE = M.Initialize
function M:Initialize()
	M.InitializeSLE(self)

	RU:MoveButton()
end

function RU:ToggleButton()
	if RaidUtility_ShowButton:IsShown() then
		RaidUtility_ShowButton:Hide()
	else
		RaidUtility_ShowButton:Show()
	end
end


RaidUtility_ShowButton:RegisterForDrag("") --Unregister any buttons for dragging. 