local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local GARRISON_LOCATION_TOOLTIP = GARRISON_LOCATION_TOOLTIP
local EXPANSION_NAME5 = EXPANSION_NAME5
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.legacy.args.garrison = {
		type = "group",
		name = GARRISON_LOCATION_TOOLTIP.." ("..EXPANSION_NAME5..")",
		order = 1,
		args = {
			header = {
				order = 1,
				type = "header",
				name = GARRISON_LOCATION_TOOLTIP,
			},
			toolbar = {
				order = 1,
				type = "group",
				name = L["Toolbar"],
				guiInline = true,
				get = function(info) return E.db.sle.legacy.garrison.toolbar[ info[#info] ] end,
				set = function(info, value) E.db.sle.legacy.garrison.toolbar[ info[#info] ] = value; SLE:GetModule("Toolbars"):UpdateLayout() end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					active = {
						order = 2,
						type = 'toggle',
						name = L["Only active buttons"],
						disabled = function() return not E.db.sle.legacy.garrison.toolbar.enable end,
					},
					buttonsize = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						disabled = function() return not E.db.sle.legacy.garrison.toolbar.enable end,
						min = 15, max = 60, step = 1,
					},
				},
			},
			autoOrder = {
				order = 2,
				type = "group",
				name = L["Auto Work Orders"],
				guiInline = true,
				get = function(info) return E.db.sle.legacy.garrison.autoOrder[ info[#info] ] end,
				set = function(info, value) E.db.sle.legacy.garrison.autoOrder[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Automatically queue maximum number of work orders available when visiting respected NPC."],
					},
					autoWar = {
						order = 2,
						type = "toggle",
						name = L["Auto Work Orders for Warmill"],
						desc = L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."],
						disabled = function() return not E.db.sle.legacy.garrison.autoOrder.enable end,
					},
					autoTrade = {
						order = 3,
						type = "toggle",
						name = L["Auto Work Orders for Trading Post"],
						desc = L["Automatically queue maximum number of work orders available for Trading Post."],
						disabled = function() return not E.db.sle.legacy.garrison.autoOrder.enable end,
					},
					autoShip = {
						order = 4,
						type = "toggle",
						name = L["Auto Work Orders for Shipyard"],
						desc = L["Automatically queue maximum number of work orders available for Shipyard."],
						disabled = function() return not E.db.sle.legacy.garrison.autoOrder.enable end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)