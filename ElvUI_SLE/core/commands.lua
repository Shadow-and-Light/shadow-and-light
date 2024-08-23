local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

--GLOBALS: unpack, select, next, pairs, wipe, strlower, ElvDB, GetNumAddOns, GetAddOnInfo, DisableAddOn, EnableAddOn, SetCVar, ReloadUI
local next, pairs, wipe = next, pairs, wipe
local strlower = strlower
local C_AddOns_GetNumAddOns = C_AddOns and C_AddOns.GetNumAddOns or GetNumAddOns
local C_AddOns_GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo or GetAddOnInfo
local C_AddOns_DisableAddOn = C_AddOns.DisableAddOn or DisableAddOn
local SetCVar, ReloadUI = SetCVar, ReloadUI

function SLE:LuaError(msg)
	local switch = strlower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, C_AddOns_GetNumAddOns() do
			local name = C_AddOns_GetAddOnInfo(i)
			if (name ~= 'ElvUI' and name ~= 'ElvUI_Options' and name ~= 'ElvUI_Libraries' and name ~= 'ElvUI_SLE' and name ~= 'ElvUI_SLE_Dev') and E:IsAddOnEnabled(name) then
				C_AddOns_DisableAddOn(name, E.myname)
				ElvDB.SLErrorDisabledAddOns[name] = i
			end
		end

		SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == 'devoff' or switch == '0' then
		if switch == 'off' then
			SetCVar('scriptErrors', 0)
			SLE:Print('Lua errors off.')
		end

		if next(ElvDB.SLErrorDisabledAddOns) then
			for name in pairs(ElvDB.SLErrorDisabledAddOns) do
				EnableAddOn(name, E.myname)
			end

			wipe(ElvDB.SLErrorDisabledAddOns)
			ReloadUI()
		end
	else
		SLE:Print('/slerror on - /slerror off', 'info')
	end
end

function SLE:LoadCommands()
	--Slash Commands
	self:RegisterChatCommand('slerror', 'LuaError')
end
