local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local type, pairs, tonumber = type, pairs, tonumber
local lower, wipe, next, print = strlower, wipe, next, print

local ReloadUI = ReloadUI
local strlower = strlower
local DisableAddOn = C_AddOns.DisableAddOn
local EnableAddOn = C_AddOns.EnableAddOn
local GetNumAddOns = C_AddOns.GetNumAddOns
local GetAddOnInfo = C_AddOns.GetAddOnInfo

SL_Addons = {
	ElvUI_SLE = true,
	ElvUI_SLE_Dev = true,
}

function SLE:LuaError(msg)
	local switch = strlower(msg)
	if switch == 'on' or switch == '1' then
		local elvuiaddons = E.Status_Addons
		local sladdons = E.Status_Addons
		local bugsack = E.Status_Bugsack

		for i = 1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if (not elvuiaddons[name] and not sladdons[name] and (switch == '1' or not bugsack[name])) and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myguid)
				ElvDB.SLErrorDisabledAddOns[name] = i
			end
		end

		E:SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == 'devoff' or switch == '0' then
		if switch == 'off' then
			E:SetCVar('scriptProfile', 0)
			E:SetCVar('scriptErrors', 0)
			SLE:Print('Lua errors off.')
		end

		if next(ElvDB.SLErrorDisabledAddOns) then
			for name in pairs(ElvDB.SLErrorDisabledAddOns) do
				EnableAddOn(name, E.myguid)
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
