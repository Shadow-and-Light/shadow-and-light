local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

-- GLOBALS: unpack, select
local tinsert = tinsert

L["SLE_CYR_COM_DESC"] = [[
- /rl
- /in
- /ec
- /elvui
- /bgstats
- /hellokitty
- /hellokittyfix
- /harlemshake
- /egrid
- /moveui
- /resetui
- /kb]]
L["SLE_CYR_DEVCOM_DESC"] = [[
- /luaerror
- /frame
- /framelist
- /texlist
- /cpuimpact
- /cpuusage
- /enableblizzard]]

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	--Main options group
	E.Options.args.sle.args.advanced = {
		type = 'group',
		name = L["Advanced Options"],
		order = 100,
		get = function(info) return E.global.sle.advanced[info[#info]] end,
		set = function(info, value) E.global.sle.advanced[info[#info]] = value end,
		args = {
			header = ACH:Header(L["Advanced Options"], 1),
			info = ACH:Description(L["SLE_Advanced_Desc"], 2),
			general = {
				order = 3,
				type = 'toggle',
				name = L["Allow Advanced Options"],
				set = function(info, value)
					if value == true and not E.global.sle.advanced.confirmed then
						E:StaticPopup_Show('SLE_ADVANCED_POPUP')
						return
					end
					E.global.sle.advanced[info[#info]] = value
				end,
			},
			optionsLimits = {
				order = 4,
				type = 'toggle',
				name = L["Change Elv's options limits"],
				desc = L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."],
				disabled = function() return not E.global.sle.advanced.general end,
				set = function(info, value) E.global.sle.advanced[info[#info]] = value; E:StaticPopup_Show('GLOBAL_RL') end,
			},
			cyrillics = {
				order = 20,
				type = 'group',
				name = L["Cyrillics Support"],
				guiInline = true,
				hidden = function() return not E.global.sle.advanced.general end,
				get = function(info) return E.global.sle.advanced.cyrillics[info[#info]] end,
				set = function(info, value) E.global.sle.advanced.cyrillics[info[#info]] = value; E:StaticPopup_Show('GLOBAL_RL') end,
				args = {
					info = ACH:Description(L["SLE_CYR_DESC"], 1),
					commands = {
						order = 2,
						type = 'toggle',
						name = L["Commands"],
						desc = L["SLE_CYR_COM_DESC"],
						descStyle = 'inline',
						width = 'full',
					},
					devCommandsInfo = ACH:Description(L["SLE_CYR_DEV_DESC"], 3),
					devCommands = {
						order = 4,
						type = 'toggle',
						name = L["Dev Commands"],
						desc = L["SLE_CYR_DEVCOM_DESC"],
						descStyle = 'inline',
						width = 'full',
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
