local E, L, V, P, G = unpack(ElvUI); 
local UB = E:GetModule('SLE_UIButtons')

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
};

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
				set = function(info, value) E.db.sle.uibuttons.enable = value; UB:Toggle() end
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
				set = function(info, value) E.db.sle.uibuttons.size = value; UB:FrameSize() end,
			},
			spacing = {
				order = 7,
				type = "range",
				name = L['Button Spacing'],
				desc = L['The spacing between buttons.'],
				min = 1, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.spacing end,
				set = function(info, value) E.db.sle.uibuttons.spacing = value; UB:FrameSize() end,
			},
			mouse = {
				order = 8,
				type = "toggle",
				name = L["Mouse Over"],
				desc = L["Show on mouse over."],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.mouse end,
				set = function(info, value) E.db.sle.uibuttons.mouse = value; UB:UpdateMouseOverSetting() end
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
				set = function(info, value) E.db.sle.uibuttons.position = value; UB:FrameSize() end,
			},
			point = {
				type = 'select',
				order = 13,
				name = L['Anchor Point'],
				desc = L['What point of dropdown will be attached to the toggle button.'],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.point end,
				set = function(info, value) E.db.sle.uibuttons.point = value; UB:FrameSize() end,
				values = positionValues,				
			},
			anchor = {
				type = 'select',
				order = 14,
				name = L['Attach To'],
				desc = L['What point to anchor dropdown on the toggle button.'],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.anchor end,
				set = function(info, value) E.db.sle.uibuttons.anchor = value; UB:FrameSize() end,
				values = positionValues,				
			},
			xoffset = {
				order = 15,
				type = "range",
				name = L['X-Offset'],
				desc = L["Horizontal offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.xoffset end,
				set = function(info, value) E.db.sle.uibuttons.xoffset = value; UB:FrameSize() end,
			},
			yoffset = {
				order = 16,
				type = "range",
				name = L['Y-Offset'],
				desc = L["Vertical offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.yoffset end,
				set = function(info, value) E.db.sle.uibuttons.yoffset = value; UB:FrameSize() end,
			},
			minroll = {
				order = 17,
				type = 'input',
				name = L["Minimum Roll Value"],
				desc = L["The lower limit for custom roll button."],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.roll.min end,
				set = function(info, value) E.db.sle.uibuttons.roll.min = value; end,
			},
			maxroll = {
				order = 18,
				type = 'input',
				name = L["Maximum Roll Value"],
				desc = L["The higher limit for custom roll button."],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons.roll.max end,
				set = function(info, value) E.db.sle.uibuttons.roll.max = value; end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)