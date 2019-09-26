local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local SA = SLE:NewModule("Armory_Stats") --, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");

function SA:ToggleArmory()
end

function SA:LoadAndSetup()
	-- SA:ToggleArmory()
end