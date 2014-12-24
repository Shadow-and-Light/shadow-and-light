local E, L, V, P, G = unpack(ElvUI); 

local function configTable()
	E.Options.args.sle.args.options.args.general.args.garrison = {
		type = "group",
		name = GARRISON_LOCATION_TOOLTIP,
		order = 53,
		args = {
			header = {
				order = 1,
				type = "header",
				name = GARRISON_LOCATION_TOOLTIP,
			},
			-- intro = {
				-- order = 2,
				-- type = "description",
				-- name = L["UB_DESC"],
			-- },
			autoOrder = {
				order = 3,
				type = "toggle",
				name = L["Auto Work Orders"],
				desc = L["Automatically queue maximum number of work orders available when visitin respected NPC."],
				get = function(info) return E.db.sle.garrison.autoOrder end,
				set = function(info, value) E.db.sle.garrison.autoOrder = value end
			},
			autoWar = {
				order = 4,
				type = "toggle",
				name = L["Auto Work Orders for Warmill"],
				desc = L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."],
				disabled = function() return not E.db.sle.garrison.autoOrder end,
				get = function(info) return E.db.sle.garrison.autoWar end,
				set = function(info, value) E.db.sle.garrison.autoWar = value end
			},
			autoTrade = {
				order = 5,
				type = "toggle",
				name = L["Auto Work Orders for Trading Post"],
				desc = L["Automatically queue maximum number of work orders available for Trading Post."],
				disabled = function() return not E.db.sle.garrison.autoOrder end,
				get = function(info) return E.db.sle.garrison.autoTrade end,
				set = function(info, value) E.db.sle.garrison.autoTrade = value end
			},
			showButton = {
				order = 6,
				type = "toggle",
				name = L["Show Max Order Button"],
				desc = L["Show the button to queue maximum number of work orders in building's UI."],
				get = function(info) return E.db.sle.garrison.showOrderButton end,
				set = function(info, value) E.db.sle.garrison.showOrderButton = value; E:GetModule('SLE_Garrison'):ShowButton() end
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)