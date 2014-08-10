local E, L, V, P, G = unpack(ElvUI);
local F = E:GetModule('SLE_Farm')

local function configTable()
	E.Options.args.sle.args.options.args.farm = {
		type = 'group',
		order = 8,
		name = L['Farm'],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Farm Options"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["FARM_DESC"],
			},
			enable = {
				type = "toggle",
				order = 3,
				name = L['Enable'],
				get = function(info) return E.private.sle.farm.enable end,
				set = function(info, value) E.private.sle.farm.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
			},
			active = {
				order = 4,
				type = 'toggle',
				name = L['Only active buttons'],
				desc = L['Only show the buttons for the seeds, portals, tools you have in your bags.'],
				disabled = function() return not E.private.sle.farm.enable end,
				get = function(info) return E.db.sle.farm.active end,
				set = function(info, value) E.db.sle.farm.active = value; if SeedAnchor then F:UpdateLayout() end end,
			},
			size = {
				order = 5,
				type = "range",
				name = L["Button Size"],
				disabled = function() return not E.private.sle.farm.enable end,
				min = 15, max = 60, step = 1,
				get = function(info) return E.db.sle.farm.size end,
				set = function(info, value) E.db.sle.farm.size = value; F:UpdateLayout() end,
			},
			seedbar = {
				type = "group",
				order = 6,
				name = L["Seed Bars"],
				disabled = function() return not E.private.sle.farm.enable end,
				guiInline = true,
				args = {
					autotarget = {
						type = "toggle",
						order = 1,
						name = L["Auto Planting"],
						desc = L["Automatically plant seeds to the nearest tilled soil if one is not already selected."],
						get = function(info) return E.db.sle.farm.autotarget end,
						set = function(info, value) E.db.sle.farm.autotarget = value; end
					},
					trash = {
						type = "toggle",
						order = 2,
						name = L["Drop Seeds"],
						desc = L["Allow seeds to be destroyed from seed bars."],
						get = function(info) return E.private.sle.farm.seedtrash end,
						set = function(info, value) E.private.sle.farm.seedtrash = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
					quest = {
						type = "toggle",
						order = 3,
						name = L["Quest Glow"],
						desc = L["Show glowing border on seeds needed for any quest in your log."],
						get = function(info) return E.db.sle.farm.quest end,
						set = function(info, value) E.db.sle.farm.quest = value; if SeedAnchor then F:UpdateLayout() end end
					},
					growth = {
						order = 8,
						type = "select",
						name = L["Dock Buttons To"],
						desc = L["Change the position from where seed bars will grow."],
						disabled = function() return not E.private.sle.farm end,
						get = function(info) return E.db.sle.farm.seedor end,
						set = function(info, value) E.db.sle.farm.seedor = value; if SeedAnchor then F:UpdateLayout() end end,
						values = {
							['RIGHT'] = L["Right"],
							['LEFT'] = L["Left"],
							['BOTTOM'] = L["Bottom"],
							['TOP'] = L["Top"],
						},
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)