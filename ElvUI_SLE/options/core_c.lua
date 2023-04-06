local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
-- local ACH = E.Libs.ACH

--GLOBALS: unpack, select, tinsert, format
local tinsert, format = tinsert, format

local function configTable()
	if not SLE.initialized then return end

	--Main options group
	E.Options.args.sle = {
		type = 'group',
		name = SLE.Title,
		childGroups = 'tab',
		desc = L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."],
		order = 6,
		args = {
			header = E.Libs.ACH:Header(format('|cff99ff33%s|r', SLE.version), 1),
			logo = {
				type = 'description',
				name = '',
				order = 2,
				image = function() return 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner', 200, 50 end,
			},
			Install = {
				order = 4,
				type = 'execute',
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E.PluginInstaller:Queue(SLE.installTable); E:ToggleOptions() end,
			},
			Reset = {
				order = 6,
				type = 'execute',
				name = L["Reset All"],
				desc = L["Resets all movers & options for S&L."],
				func = function() E:StaticPopup_Show("SLE_RESET_ALL") end,
				--func = function() SLE:Reset("all") end,
			},
			modules = {
				order = 10,
				type = 'group',
				name = L["Modules"],
				args = {
					--* Modules are added here
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
