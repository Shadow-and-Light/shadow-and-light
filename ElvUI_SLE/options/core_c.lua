local E, L, V, P, G = unpack(ElvUI)
local SLE = E:GetModule('SLE')
local LT = E:GetModule('SLE_Loot')
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

local function configTable()
	E.Options.args.ElvUI_Header.name = E.Options.args.ElvUI_Header.name.." + Shadow & Light"..format(": |cff99ff33%s|r",SLE.version)

	--local size = E.db.general.fontSize

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
				name = "Shadow & Light"..format(": |cff99ff33%s|r", SLE.version),
			},
			logo = {
				type = 'description',
				name = '',
				order = 2,
				image = function() return 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Title', 555, 350 end,
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
			SettingsButton = {
				order = 5,
				type = 'execute',
				name = L["General"].." "..SETTINGS,
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "general") end,
			},
			MinimapButton = {
				order = 6,
				type = 'execute',
				name = L["Minimap"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "minimap") end,
			},
			MarkersButton = {
				order = 7,
				type = 'execute',
				name = L["Raid Markers"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "raidmarkerbars") end,
			},
			EquipButton = {
				order = 8,
				type = 'execute',
				name = L['Equipment Manager'],
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "equipmanager") end,
			},
			FarmButton = {
				order = 9,
				type = 'execute',
				name = L['Farm'],
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "farm") end,
			},
			LootButton = {
				order = 10,
				type = 'execute',
				name = L['Loot'],
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "loot") end,
			},
			MediaButton = {
				order = 11,
				type = 'execute',
				name = L["Media"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "media") end,
			},
			ScreensaverButton = {
				order = 12,
				type = 'execute',
				name = L["Screensaver"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "screensaver") end,
			},
			ArmoryButton = {
				order = 13,
				type = 'execute',
				name = L["Armory Mode"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "Armory") end,
			},
			DatatextButton = {
				order = 14,
				type = 'execute',
				name = L["Panels & Dashboard"],
				func = function() ACD:SelectGroup("ElvUI", "sle", "datatext") end,
			},
			HelpButton = {
				order = 15,
				type = 'execute',
				name = L['About/Help'],
				func = function() ACD:SelectGroup("ElvUI", "sle", "help") end,
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
								func = function() SLE:Reset("all") end,
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
end

table.insert(E.SLEConfigs, configTable)