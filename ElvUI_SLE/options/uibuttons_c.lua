local E, L, V, P, G = unpack(ElvUI); 
local UB = E:GetModule('SLE_UIButtons')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.uibuttons = {
		type = "group",
		name = L["UI Buttons"],
		order = 77,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["UI Buttons"],
			},
			intro = {
				order = 2,
				type = "description",
				name = L["UB_DESC"],
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				desc = L["Show/Hide UI buttons."],
				get = function(info) return E.db.sle.uibuttons.enable end,
				set = function(info, value) E.db.sle.uibuttons.enable = value; UB:Start() end
			},
			space1 = {
				order = 4,
				type = 'description',
				name = "",
			},
			space2 = {
				order = 5,
				type = 'description',
				name = "",
			},
			size = {
				order = 6,
				type = "range",
				name = L['Size'],
				desc = L["Sets size of buttons"],
				min = 12, max = 25, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.size end,
				set = function(info, value) E.db.sle.uibuttons.size = value; UB:UpdateAll() end,
			},
			spacing = {
				order = 7,
				type = "range",
				name = L['Button Spacing'],
				desc = L['The spacing between buttons.'],
				min = 1, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.spacing end,
				set = function(info, value) E.db.sle.uibuttons.spacing = value; UB:UpdateAll() end,
			},
			mouse = {
				order = 8,
				type = "toggle",
				name = L["Mouse Over"],
				desc = L["Show on mouse over."],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.mouse end,
				set = function(info, value) E.db.sle.uibuttons.mouse = value; end
			},
			position = {
				order = 10,
				name = L["Buttons position"],
				desc = L["Layout for UI buttons."],
				type = "select",
				values = {
					["uib_hor"] = L['Horizontal'],
					["uib_vert"] = L['Vertical'],
				},
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.position end,
				set = function(info, value) E.db.sle.uibuttons.position = value; UB:UpdateAll() end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)