local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RM = E:GetModule('RaidMarks')

--Main options group
E.Options.args.sle.args.marks = {
	order = 5,
	type = "group",
	name = L["Raid Marks"],
	args = {
		marksheader = {
			order = 1,
			type = "header",
			name = L["Raid Marks"],
		},
		enabled = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Show/Hide raid marks."],
			get = function(info) return E.db.sle.marks.enabled end,
			set = function(info, value) E.db.sle.marks.enabled = value; RM:UpdateVisibility() end
		},
		Reset = {
			order = 3,
			type = 'execute',
			name = L['Restore Defaults'],
			desc = L["Reset these options to defaults"],
			func = function() E:GetModule('SLE'):Reset(nil, nil, nil, nil, true) end,
		},
		spacer = {
			order = 4,
			type = 'description',
			name = "",
		},
		showinside = {
			order = 5,
			type = "toggle",
			name = L["Show only in instances"],
			desc = L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."],
			get = function(info) return E.db.sle.marks.showinside end,
			set = function(info, value) E.db.sle.marks.showinside = value; RM:UpdateVisibility() end
		},
		size = {
			order = 6,
			type = "range",
			name = L['Size'],
			desc = L["Sets size of buttons"],
			min = 15, max = 30, step = 1,
			get = function(info) return E.db.sle.marks.size end,
			set = function(info, value) E.db.sle.marks.size = value; RM:FrameButtonsGrowth(); RM:FrameButtonsSize() end,
		},
		growth = {
			order = 7,
			type = "select",
			name = L["Direction"],
			desc = L["Change the direction of buttons growth from the skull marker"],
			get = function(info) return E.db.sle.marks.growth end,
			set = function(info, value) E.db.sle.marks.growth = value; RM:FrameButtonsGrowth() end,
			values = {
				['RIGHT'] = L["Right"],
				['LEFT'] = L["Left"],
				['UP'] = L["Up"],
				['DOWN'] = L["Down"],
			},
		},
	},
}