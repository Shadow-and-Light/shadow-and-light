local SLE, _, E = unpack(select(2, ...))

--GLOBALS: unpack, select, next, pairs, wipe, strlower, ElvDB, GetNumAddOns, GetAddOnInfo, DisableAddOn, EnableAddOn, SetCVar, ReloadUI
local next, pairs, wipe = next, pairs, wipe
local strlower = strlower
local GetNumAddOns, GetAddOnInfo, DisableAddOn, EnableAddOn = GetNumAddOns, GetAddOnInfo, DisableAddOn, EnableAddOn
local SetCVar, ReloadUI = SetCVar, ReloadUI

function SLE:LuaError(msg)
	local switch = strlower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if (name ~= 'ElvUI' and name ~= 'ElvUI_OptionsUI' and name ~= 'ElvUI_SLE' and name ~= 'ElvUI_SLE_Dev') and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
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
