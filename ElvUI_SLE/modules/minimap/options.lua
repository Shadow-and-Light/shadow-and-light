local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local function configTable()
	E.Options.args.sle.args.minimap = {
		type = "group",
		name = L["Minimap"],
		order = 2,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Minimap Options"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L['MINIMAP_DESC'],
			},
			enable = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable/Disable Minimap Options"],
				get = function(info) return E.db.sle.minimap.enable end,
				set = function(info, value) E.db.sle.minimap.enable = value; E:GetModule('Minimap'):UpdateSettings() end
			},
			coords = {
				type = "group",
				name = L["Minimap Coordinates"],
				order = 4,
				guiInline = true,
				disabled = function() return not E.db.sle.minimap.enable end,
				args = {
					display = {
						order = 3,
						type = 'select',
						name = L['Coords Display'],
						desc = L['Change settings for the display of the coordinates that are on the minimap.'],
						get = function(info) return E.db.sle.minimap.coords.display end,
						set = function(info, value) E.db.sle.minimap.coords.display = value; E:GetModule('Minimap'):UpdateSettings() end,
						values = {
							['MOUSEOVER'] = L['Minimap Mouseover'],
							['SHOW'] = L['Always Display'],
							['HIDE'] = L['Hide'],
						},
						--disabled = function() return not E.private.general.minimap.enable end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)