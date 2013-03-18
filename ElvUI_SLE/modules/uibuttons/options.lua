local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UB = E:GetModule('UIButtons')
local function configTable()

--UI Buttons
E.Options.args.sle.args.uibuttons = {
	type = "group",
	name = L["UI Buttons"],
	order = 99,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Additional menu with useful buttons"],
		},
		enabled = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			desc = L["Show/Hide UI buttons."],
			get = function(info) return E.db.sle.uibuttons.enable end,
			set = function(info, value) E.db.sle.uibuttons.enable = value; UB:Start() end
		},
		options = {
			type = "group",
			name = L["General"],
			order = 4,
			guiInline = true,
			disabled = function() return not E.db.sle.uibuttons.enable end,
			args = {
				size = {
					order = 1,
					type = "range",
					name = L['Size'],
					desc = L["Sets size of buttons"],
					min = 12, max = 25, step = 1,
					get = function(info) return E.db.sle.uibuttons.size end,
					set = function(info, value) E.db.sle.uibuttons.size = value; UB:FrameSize() end,
				},
				mouse = {
					order = 2,
					type = "toggle",
					name = L["Mouse over"],
					desc = L["Show on mouse over."],
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
					get = function(info) return E.db.sle.uibuttons.position end,
					set = function(info, value) E.db.sle.uibuttons.position = value; UB:Positioning(); UB:MoverSize() end,
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)