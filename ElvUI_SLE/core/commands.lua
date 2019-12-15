local SLE, T, E, L, V, P, G = unpack(select(2, ...))

function SLE:LuaError(msg)
	local switch = strlower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if (name ~= 'ElvUI' and name ~= 'ElvUI_OptionsUI' and name ~= 'ElvUI_SLE' and name ~= 'ElvUI_SLE_Dev') and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				ElvDB.LuaErrorDisabledAddOns[name] = i
			end
		end

		SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == 'devoff' or switch == '0' then
		if switch == 'off' then
			SetCVar('scriptErrors', 0)
			SLE:Print('Lua errors off.')
		end

		if next(ElvDB.LuaErrorDisabledAddOns) then
			for name in pairs(ElvDB.LuaErrorDisabledAddOns) do
				EnableAddOn(name, E.myname)
			end

			wipe(ElvDB.LuaErrorDisabledAddOns)
			ReloadUI()
		end
    else
        for i=1, GetNumAddOns() do
            local name = GetAddOnInfo(i)
            print(name)
        end
		SLE:Print('/slerror on - /slerror off')
	end
end

function SLE:LoadCommands()
	--Slash Commands
	self:RegisterChatCommand('slerror', 'LuaError')
end