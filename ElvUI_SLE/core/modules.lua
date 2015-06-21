local E, L, V, P, G = unpack(ElvUI);
local unit

local modules = {
	['SLE_AutoRelease'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_AuraTimers'] = {'AceEvent-3.0'},
	['SLE_DTPanels'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_BackGrounds'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_BagInfo'] = {'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0'},
	['SLE_EquipManager'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_Farm'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_AddonInstaller'] = {},
	['SLE_Bags'] = {'AceHook-3.0'},
	['SLE_Loot'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_RaidMarkers'] = {'AceEvent-3.0'},
	['SLE_SquareMinimapButtons'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_Threat'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_PvPMover'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_UIButtons'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_EnhancedVehicleBar'] = {},
	['SLE_Test'] = {'AceHook-3.0', 'AceEvent-3.0'}, --Testing module in dev folder
	['SLE_Media'] = {'AceHook-3.0'},
	['SLE_InstDif'] = {'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_ScreenSaver'] = { 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0'},
	['SLE_Garrison'] = { 'AceEvent-3.0' },
	['SLE_ErrorFrame'] = { },
	['SLE_Quests'] = { 'AceEvent-3.0' },
	['SLE_BlizzRaid'] = { 'AceEvent-3.0' },
	['SLE'] = {'AceHook-3.0', 'AceEvent-3.0'},
}

local function Register()
	for name, libs in pairs(modules) do
		unit = E:NewModule(name, unpack(libs))
		E:RegisterModule(unit:GetName())
	end
end

Register()