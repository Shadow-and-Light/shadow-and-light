local E, L, V, P, G =  unpack(ElvUI); 
local SLE = E:GetModule('SLE')
local LT = E:GetModule('SLE_Loot')

local function configTable()
	E.Options.args.ElvUI_Header = {
			order = 1,
			type = "header",
			name = "ElvUI"..format(": |cff99ff33%s|r",E.version).."  ".."Shadow & Light"..format(": |cff99ff33%s|r",SLE.version),
			width = "full",
	}

	--local size = E.db.general.fontSize

	--Main options group
	E.Options.args.sle = {
		type = "group",
		name = L["Shadow & Light"],
		desc = "Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc.",
		order = 50,
		args = {
			header = {
				order = 1,
				type = "header",
				name = "Shadow & Light"..format(": |cff99ff33%s|r", SLE.version),
			},
			logo = {
				type = 'description',
				name = '',
				order = 2,
				image = function() return 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Title', 650, 410 end,
			},
			info = {
				order = 3,
				type = "description",
				name = L["SLE_DESC"],
			},
			Install = {
				order = 4,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() SLE:Install(); E:ToggleConfig() end,
			},
			options = {
				order = 1,
				type = "group",
				childGroups = 'tab',
				name = SETTINGS,
				args = {
					--[[intro = {
						order = 1,
						type = "description",
						name = L["Below you can see option groups presented by |cff1784d1Shadow & Light|r."],
					},]]
					general = {
						order = 2,
						type = "group",
						name = L["General"],
						args = {
							--[[intro = {
								order = 1,
								type = "description",
								name = L["General options of |cff1784d1Shadow & Light|r."],
							},]]
							Reset = {
								order = 2,
								type = 'execute',
								name = L["Reset All"],
								desc = L["Resets all movers & options for S&L."],
								func = function() SLE:Reset(true) end,
							},
							space1 = {
								order = 3,
								type = 'description',
								name = "",
							},
							space2 = {
								order = 4,
								type = 'description',
								name = "",
							},
						},
					},
				},
			},
			links = {
				type = 'group',
				name = 'About/Help',
				order = -2,
				args = {
					desc = {
						order = 1,
						type = 'description',
						fontSize = 'medium',
						name = 'Da LinkZ!!!!',
					},
					tukuilink = {
						type = 'input',
						width = 'full',
						name = 'On TukUI.org',
						get = function(info) return 'http://www.tukui.org/addons/index.php?act=view&id=42' end,
						order = 2,
					},
					wowilink = {
						type = 'input',
						width = 'full',
						name = 'On WoWI',
						get = function(info) return 'http://www.wowinterface.com/downloads/info20927-ElvUIShadowLight.html' end,
						order = 3,
					},
					curselink= {
						type = 'input',
						width = 'full',
						name = 'On Curse',
						get = function(info) return 'http://www.curse.com/addons/wow/shadow-and-light-edit' end,
						order = 4,
					},
					gitlablink = {
						type = 'input',
						width = 'full',
						name = 'GitLab Link / Report Errors',
						get = function(info) return 'http://git.tukui.org/repooc/elvui-shadowandlight' end,
						order = 5,
					},
				},
			},
		},
	}

	--Credits
	E.Options.args.sle.args.credits = {
		order = 400,
		type = 'group',
		name = L["Credits"],
		args = {
			creditheader = {
				order = 1,
				type = "header",
				name = L["Credits"],
			},
			credits = {
				order = 2,
				type = "description",
				name = L["ELVUI_SLE_CREDITS"]..'\n\n\n'..L["Submodules and Coding:"]..'\n\n'..L["ELVUI_SLE_CODERS"]..'\n\n\n'..L["Other Support:"]..'\n\n'..L["ELVUI_SLE_MISC"],
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)