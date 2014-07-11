local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local unit

local modules = {
	['SLE_AutoRelease'] = { 'AceHook-3.0', 'AceEvent-3.0' },
	['SLE_DTPanels'] = { 'AceHook-3.0', 'AceEvent-3.0' },
	['SLE_BackGrounds'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_BagInfo'] = { 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0'},
	['CharacterFrameOptions'] = { 'AceEvent-3.0'},
	['InspectFrameOptions'] = { 'AceEvent-3.0'},
	['SLE_EquipManager'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_Farm'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_AddonInstaller'] = {},
	['SLE_Loot'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_RaidFlares'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_RaidMarks'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_SquareMinimapButtons'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_PvPMover'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_UIButtons'] = { 'AceHook-3.0', 'AceEvent-3.0'},
	['SLE_EnhancedVehicleBar'] = {},
	['SLE_Test'] = { 'AceHook-3.0', 'AceEvent-3.0'}, --Testing module in dev folder
	['SLE'] = { 'AceHook-3.0', 'AceEvent-3.0' },
}

local function Register()
	for name, libs in pairs(modules) do
		local lib1, lib2, lib3 = unpack(libs)
		if not lib1 then
			unit = E:NewModule(name)
		elseif not lib2 then
			unit = E:NewModule(name, lib1)
		elseif not lib3 then
			unit = E:NewModule(name, lib1, lib2)
		else
			unit = E:NewModule(name, lib1, lib2, lib3)
		end	
		E:RegisterModule(unit:GetName())
	end
end

Register()

