local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE:GetModule("Misc")
local SETTINGS = SETTINGS
local LFG_LIST_LEGACY = LFG_LIST_LEGACY
local function configTable()
	if not SLE.initialized then return end
	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
	SLE.ACD = ACD
	E.Options.args.ElvUI_Header.name = E.Options.args.ElvUI_Header.name.." + |cff9482c9Shadow & Light|r"..T.format(": |cff99ff33%s|r",SLE.version)

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
			func = function() ACD:SelectGroup("ElvUI", "sle", T.unpack(path)) end,
		}
		return config
	end
	--Main options group
	E.Options.args.sle = {
		type = "group",
		name = "|cff9482c9Shadow & Light|r",
		desc = L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."],
		order = 50,
		args = {
			header = {
				order = 1,
				type = "header",
				name = "|cff9482c9Shadow & Light|r"..T.format(": |cff99ff33%s|r", SLE.version),
			},
			logo = {
				type = 'description',
				name = L["SLE_DESC"],
				order = 2,
				image = function() return 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner', 200, 100 end,
			},
			Install = {
				order = 4,
				type = 'execute',
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E:GetModule("PluginInstaller"):Queue(SLE.installTable); E:ToggleConfig();  end,
			},
			infoButton = CreateButton(5, L["About/Help"], "help"),
			Reset = {
				order = 6,
				type = 'execute',
				name = L["Reset All"],
				desc = L["Resets all movers & options for S&L."],
				func = function() SLE:Reset("all") end,
			},
			modulesButton = CreateButton(7, L["Modules"], "modules"),
			mediaButton = CreateButton(8, L["Media"], "media"),
			skinsButton = CreateButton(9, L["Skins"], "skins"),
			threat = {
				type = "group",
				name = L["Threat"],
				order = 12,
				guiInline = true,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.sle.misc.threat.enable end,
						set = function(info, value) E.db.sle.misc.threat.enable = value; M:UpdateThreatConfig(); M:UpdateThreatPosition() end,
					},
					position = {
						order = 2,
						type = 'select',
						name = L["Position"],
						desc = L["Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L."],
						disabled = function() return not E.db.sle.misc.threat.enable end,
						values = {
							["SLE_DataPanel_1"] = L["SLE_DataPanel_1"],
							["SLE_DataPanel_2"] = L["SLE_DataPanel_2"],
							["SLE_DataPanel_3"] = L["SLE_DataPanel_3"],
							["SLE_DataPanel_4"] = L["SLE_DataPanel_4"],
							["SLE_DataPanel_5"] = L["SLE_DataPanel_5"],
							["SLE_DataPanel_6"] = L["SLE_DataPanel_6"],
							["SLE_DataPanel_7"] = L["SLE_DataPanel_7"],
							["SLE_DataPanel_8"] = L["SLE_DataPanel_8"],
							["LeftChatDataPanel"] = L["Left Chat"],
							["RightChatDataPanel"] = L["Right Chat"],
						},
						get = function(info) return E.db.sle.misc.threat.position end,
						set = function(info, value) E.db.sle.misc.threat.position = value; M:UpdateThreatPosition() end,
					},
				},
			},
			advanced = {
				type = "group",
				name = L["Advanced Options"],
				order = 16,
				guiInline = true,
				get = function(info) return E.global.sle.advanced[ info[#info] ] end,
				set = function(info, value) E.global.sle.advanced[ info[#info] ] = value; end,
				args = {
					info = {
						order = 1,
						type = "description",
						name = L["SLE_Advanced_Desc"],
					},
					general = {
						order = 2,
						type = "toggle",
						name = L["Allow Advanced Options"],
						set = function(info, value) 
							if value == true and not E.global.sle.advanced.confirmed then E:StaticPopup_Show("SLE_ADVANCED_POPUP"); return end
							E.global.sle.advanced[ info[#info] ] = value;
						end,
					},
					optionsLimits = {
						order = 3,
						type = "toggle",
						name = L["Change Elv's options limits"],
						desc = L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."],
						disabled = function() return not E.global.sle.advanced.general end,
						set = function(info, value) E.global.sle.advanced[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end,
					},
					gameMenu = {
						order = 4,
						type = "group",
						name = L["Game Menu Buttons"],
						hidden = function() return not E.global.sle.advanced.general end,
						disabled = function() return not E.global.sle.advanced.gameMenu.enable end,
						get = function(info) return E.global.sle.advanced.gameMenu[ info[#info] ] end,
						set = function(info, value) E.global.sle.advanced.gameMenu[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Adds |cff9482c9Shadow & Light|r buttons to main game menu."],
								disabled = false,
							},
							reload = {
								order = 2,
								type = "toggle",
								name = L["Reload UI"],
							},
						},
					},
					cyrillics = {
						order = 5,
						type = "group",
						name = L["Cyrillics Support"],
						hidden = function() return not E.global.sle.advanced.general end,
						get = function(info) return E.global.sle.advanced.cyrillics[ info[#info] ] end,
						set = function(info, value) E.global.sle.advanced.cyrillics[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end,
						args = {
							info = {
								order = 1,
								type = "description",
								name = L["SLE_CYR_DESC"],
							},
							commands = {
								order = 2,
								type = "toggle",
								name = L["Commands"],
								desc = L["SLE_CYR_COM_DESC"],
							},
							devCommands = {
								order = 3,
								type = "toggle",
								name = L["Dev Commands"],
								desc = L["SLE_CYR_DEVCOM_DESC"],
							},
						},
					},
				},
			},
			modules = {
				order = 20,
				type = "group",
				childGroups = "select",
				name = L["Modules"],
				args = {
					info = {
						type = "description",
						order = 1,
						name = L["Options for different S&L modules."],
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)