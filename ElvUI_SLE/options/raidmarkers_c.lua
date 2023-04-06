local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local RM = SLE.RaidMarkers

local SHIFT_KEY, CTRL_KEY, ALT_KEY = SHIFT_KEY, CTRL_KEY, ALT_KEY
local AGGRO_WARNING_IN_PARTY = AGGRO_WARNING_IN_PARTY
local CUSTOM = CUSTOM

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.raidmarkerbars = {
		order = 1,
		type = 'group',
		name = L["Raid Markers"],
		get = function(info) return E.db.sle.raidmarkers[info[#info]] end,
		args = {
			marksheader = ACH:Header(L["Raid Markers"], 1),
			desc = ACH:Description(L["Options for panels providing fast access to raid markers and flares."], 2),
			enable = {
				order = 3,
				type = 'toggle',
				name = L["Enable"],
				desc = L["Show/Hide raid marks."],
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:Visibility() end,
			},
			reset = {
				order = 4,
				type = 'execute',
				name = L["Restore Defaults"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				func = function() SLE:Reset('marks') end,
			},
			spacer1 = ACH:Spacer(5),
			backdrop = {
				type = 'toggle',
				order = 6,
				name = L["Backdrop"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:Backdrop() end,
			},
			buttonSize = {
				order = 7,
				type = 'range',
				name = L["Button Size"],
				min = 16, max = 40, step = 1,
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateBar() end,
			},
			spacing = {
				order = 8,
				type = 'range',
				name = L["Button Spacing"],
				min = -4, max = 10, step = 1,
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateBar() end,
			},
			orientation = {
				order = 9,
				type = 'select',
				name = L["Orientation"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateBar() end,
				values = {
					HORIZONTAL = L["Horizontal"],
					VERTICAL = L["Vertical"],
				},
			},
			reverse = {
				type = 'toggle',
				order = 10,
				name = L["Reverse"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateBar() end,
			},
			modifier = {
				order = 11,
				type = 'select',
				name = L["Modifier Key"],
				desc = L["Set the modifier key for placing world markers."],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateWorldMarkersAndTooltips() end,
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
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:Visibility() end,
				values = {
					DEFAULT = DEFAULT,
					INPARTY = AGGRO_WARNING_IN_PARTY,
					ALWAYS = L["Always Display"],
					CUSTOM = CUSTOM,
				},
			},
			customVisibility = {
				order = 13,
				type = 'input',
				width = 'full',
				name = L["Visibility State"],
				disabled = function() return E.db.sle.raidmarkers.visibility ~= 'CUSTOM' or not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:Visibility() end,
			},
			mouseover = {
				order = 14,
				type = 'toggle',
				name = L["Mouseover"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value; RM:UpdateMouseover() end,
			},
			notooltip = {
				order = 15,
				type = 'toggle',
				name = L["No tooltips"],
				disabled = function() return not E.db.sle.raidmarkers.enable end,
				set = function(info, value) E.db.sle.raidmarkers[info[#info]] = value end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
