local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local function configTable()
	E.Options.args.sle.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 81,
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
			coords = {
				type = "group",
				name = L["Minimap Coordinates"],
				order = 4,
				guiInline = true,
				disabled = function() return not E.private.general.minimap.enable end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.sle.minimap.enable end,
						set = function(info, value) E.db.sle.minimap.enable = value; E:GetModule('Minimap'):UpdateSettings() end,
					},
					display = {
						order = 2,
						type = 'select',
						name = L['Coords Display'],
						desc = L['Change settings for the display of the coordinates that are on the minimap.'],
						get = function(info) return E.db.sle.minimap.coords.display end,
						set = function(info, value) E.db.sle.minimap.coords.display = value; E:GetModule('Minimap'):UpdateSettings() end,
						values = {
							['MOUSEOVER'] = L['Minimap Mouseover'],
							['SHOW'] = L['Always Display'],
						},
						disabled = function() return not E.db.sle.minimap.enable end,
					},
					middle = {
						order = 3,
						type = "select",
						name = L["Coords Location"],
						desc = L['This will determine where the coords are shown on the minimap.'],
						get = function(info) return E.db.sle.minimap.coords.middle end,
						set = function(info, value) E.db.sle.minimap.coords.middle = value; E:GetModule('Minimap'):UpdateSettings() end,
						values = {
							['CORNERS'] = L['Bottom Corners'],
							['CENTER'] = L['Bottom Center'],
						},
						disabled = function() return not E.db.sle.minimap.enable end,
					},
					--[[middle = {
						order = 3,
						type = "toggle",
						name = L["Coords in the middle"],
						desc = L['If enabled will show coordinates in the center of minimaps lower border. Otherwise in the lower corners.'],
						disabled = function() return not E.db.sle.minimap.enable end,
						get = function(info) return E.db.sle.minimap.middle end,
						set = function(info, value) E.db.sle.minimap.middle = value; E:GetModule('Minimap'):UpdateSettings() end,
					},]]
				},
			},
			mapicons = {
				type = "group",
				name = L["Minimap Buttons"],
				order = 5,
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Enable/Disable Square Minimap Bar.'],
						get = function(info) return E.private.sle.minimap.mapicons.enable end,
						set = function(info, value) E.private.sle.minimap.mapicons.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					skindungeon = {
						order = 2,
						type = 'toggle',
						name = L['Skin Dungeon'],
						desc = L['Skin dungeon icon.'],
						get = function(info) return E.db.sle.minimap.mapicons.skindungeon end,
						set = function(info, value) E.db.sle.minimap.mapicons.skindungeon = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					skinmail = {
						order = 3,
						type = 'toggle',
						name = L['Skin Mail'],
						desc = L['Skin mail icon.'],
						get = function(info) return E.db.sle.minimap.mapicons.skinmail end,
						set = function(info, value) E.db.sle.minimap.mapicons.skinmail = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconsize = {
						order = 4,
						type = 'range',
						name = L['Button Size'],
						desc = L['The size of the minimap buttons when not anchored to the minimap.'],
						min = 16, max = 40, step = 1,
						get = function(info) return E.db.sle.minimap.mapicons.iconsize end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconsize = value; E:GetModule('SquareMinimapButtons'):Update(SquareMinimapButtonBar) end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconperrow = {
						order = 5,
						type = 'range',
						name = L['Icons Per Row'],
						desc = L['Anchor mode for displaying the minimap buttons are skinned.'],
						min = 1, max = 12, step = 1,
						get = function(info) return E.db.sle.minimap.mapicons.iconperrow end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconperrow = value; E:GetModule('SquareMinimapButtons'):Update(SquareMinimapButtonBar) end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
					iconmouseover = {
						order = 6,
						name = L['Mouse Over'],
						desc = L['Show minimap buttons on mouseover.'],
						type = "toggle",
						get = function(info) return E.db.sle.minimap.mapicons.iconmouseover end,
						set = function(info, value) E.db.sle.minimap.mapicons.iconmouseover = value; E:GetModule('SquareMinimapButtons'):ChangeMouseOverSetting() end,
						disabled = function() return not E.private.sle.minimap.mapicons.enable end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)