local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local IA = SLE:NewModule("Armory_Inspect", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");

function IA:ToggleArmory()
end

function IA:LoadAndSetup()
	IA:ToggleArmory()
end