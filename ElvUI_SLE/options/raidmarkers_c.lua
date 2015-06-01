local E, L, V, P, G = unpack(ElvUI); 
local RM = E:GetModule('SLE_RaidMarkers')

local function configTable()
	E.Options.args.sle.args.options.args.raidmarkerbars = {
		order = 4,
		type = "group",
		name = L["Raid Markers"],
		get = function(info) return E.db.sle.raidmarkers[ info[#info] ] end,	
		set = function(info, value) E.db.sle.raidmarkers[ info[#info] ] = value; RM:ToggleSettings() end,
		args = {
			marksheader = {
				order = 1,
				type = "header",
				name = L["Raid Markers"],
			},
			info = {
				order = 2,
				type = "description",
				name = L['Options for panels providing fast access to raid markers and flares.'],
			},
			enable = {
				order = 3,
				type = "toggle",
				name = ENABLE,
				desc = L["Show/Hide raid marks."],
			},
			reset = {
				order = 4,
				type = 'execute',
				name = L['Restore Defaults'],
				desc = L["Reset these options to defaults"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				func = function() E:GetModule('SLE'):Reset("marks") end,
			},
			space1 = {
				order = 5,
				type = 'description',
				name = "",
			},
			backdrop = {
				type = 'toggle',
				order = 6,
				name = L["Backdrop"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,			
			},
			buttonSize = {
				order = 7,
				type = 'range',
				name = L['Button Size'],
				min = 16, max = 40, step = 1,
				disabled = function() return not E.db.sle.raidmarkers.enable end,
			},
			spacing = {
				order = 8,
				type = 'range',
				name = L["Button Spacing"],
				min = 0, max = 10, step = 1,
				disabled = function() return not E.db.sle.raidmarkers.enable end,
			},
			orientation = {
				order = 9,
				type = 'select',
				name = L['Orientation'],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				values = {
					['HORIZONTAL'] = L['Horizontal'],
					['VERTICAL'] = L['Vertical'],
				},
			},
			reverse = {
				type = 'toggle',
				order = 10,
				name = L["Reverse"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
			},
			modifier = {
				order = 11,
				type = 'select',
				name = L['Modifier Key'],
				desc = L['Set the modifier key for placing world markers.'],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				values = {
					['shift-'] = SHIFT_KEY,
					['ctrl-'] = CTRL_KEY,
					['alt-'] = ALT_KEY,
				},
			},
			visibility = {
				type = 'select',
				order = 12,
				name = L["Visibility"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				values = {
					DEFAULT = L['Default'],
					INPARTY = AGGRO_WARNING_IN_PARTY,
					ALWAYS = L['Always Display'],
					CUSTOM = L["Custom"],
				},
			},
			customVisibility = {
				order = 13,
				type = 'input',
				width = 'full',
				name = L["Visibility State"],
				disabled = function() return E.db.sle.raidmarkers.visibility ~= "CUSTOM" or not E.db.sle.raidmarkers.enable end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)