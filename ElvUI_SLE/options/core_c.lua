local E, L, V, P, G = unpack(ElvUI)
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
		name = "Shadow & Light",
		desc = L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."],
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
			--[[info = {
				order = 3,
				type = "description",
				name = L["SLE_DESC"],
			},]]
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
							Install = {
								order = 3,
								type = 'execute',
								name = L['Install'],
								desc = L['Run the installation process.'],
								func = function() SLE:Install(); E:ToggleConfig() end,
							},
							space1 = {
								order = 4,
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