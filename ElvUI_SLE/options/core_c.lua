local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE:GetModule("Misc")
local SETTINGS = SETTINGS
local LFG_LIST_LEGACY = LFG_LIST_LEGACY
local function configTable()
	if not SLE.initialized then return end
	E.Options.name = E.Options.name.." + |cff9482c9Shadow & Light|r"..T.format(": |cff99ff33%s|r",SLE.version)

	local function CreateButton(number, text, ...)
		local path = {}
		local num = T.select("#", ...)
		for i = 1, num do
			local name = T.select(i, ...)
			T.tinsert(path, #(path)+1, name)
		end
		local config = {
			order = number,
			type = 'execute',
			name = text,
			func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle", T.unpack(path)) end,
		}
		return config
	end
	--Main options group
	E.Options.args.sle = {
		type = "group",
		name = SLE.Title,
		childGroups = "tab",
		desc = L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."],
		-- order = -4,
		order = 6,
		args = {
			header = {
				order = 1,
				type = "header",
				name = "|cff9482c9Shadow & Light|r"..T.format(": |cff99ff33%s|r", SLE.version),
			},
			logo = {
				type = 'description',
				name = "",
				order = 2,
				image = function() return 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner', 200, 50 end,
			},
			Install = {
				order = 4,
				type = 'execute',
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E:GetModule("PluginInstaller"):Queue(SLE.installTable); E:ToggleOptionsUI();  end,
			},
			-- infoButton = CreateButton(5, L["About/Help"], "help"),
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
				type = "group",
				childGroups = "select",
				-- childGroups = "tab",
				name = L["Modules"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Modules"],
					},
					info = {
						type = "description",
						order = 2,
						name = L["Options for different S&L modules."],
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
