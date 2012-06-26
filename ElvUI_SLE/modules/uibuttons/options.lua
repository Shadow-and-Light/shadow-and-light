local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UB = E:GetModule('UIButtons')

--UI Buttons
E.Options.args.dpe.args.uibuttons = {
	type = "group",
	name = L["UI Buttons"],
	order = 3,
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
			get = function(info) return E.db.dpe.uibuttons.enable end,
			set = function(info, value) E.db.dpe.uibuttons.enable = value; UB:Start() end
		},
		options = {
			type = "group",
			name = L["General"],
			order = 4,
			guiInline = true,
			disabled = function() return not E.db.dpe.uibuttons.enable end,
			args = {
				size = {
					order = 1,
					type = "range",
					name = L['Size'],
					desc = L['Sets size of buttons'],
					min = 12, max = 25, step = 1,
					get = function(info) return E.db.dpe.uibuttons.size end,
					set = function(info, value) E.db.dpe.uibuttons.size = value; UB:FrameSize() end,
				},
				mouse = {
					order = 2,
					type = "toggle",
					name = L["Mouse over"],
					desc = L["Show on mouse over."],
					get = function(info) return E.db.dpe.uibuttons.mouse end,
					set = function(info, value) E.db.dpe.uibuttons.mouse = value; end
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
					get = function(info) return E.db.dpe.uibuttons.position end,
					set = function(info, value) E.db.dpe.uibuttons.position = value; UB:Positioning(); UB:MoverSize() end,
				},
			},
		},
	},
}