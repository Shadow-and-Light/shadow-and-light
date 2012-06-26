local E, L, V, P, G =  unpack(ElvUI); -- Import Functions/Constants, Config, Locales
local RU = E:GetModule('RaidUtility');
local M = E:GetModule('Misc');

E.RaidUtility = RU

--Moved RU down cause of top datatext panels
function RU:MoveButton()
	ShowButton:ClearAllPoints()
	ShowButton:Point("CENTER", E.UIParent, "BOTTOMLEFT", E.db.dpe.raidutil.xpos, E.db.dpe.raidutil.ypos)
end

--For moving raid utility button
M.InitializeDPE = M.Initialize
function M:Initialize()
	M.InitializeDPE(self)

	RU:MoveButton()
end


ShowButton:RegisterForDrag("") --Unregister any buttons for dragging. 