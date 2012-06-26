local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local RM = E:GetModule('RaidMarks')

--Main options group
E.Options.args.dpe.args.marks = {
	order = 5,
	type = "group",
	name = L["Raid Marks"],
	--guiInline = true,
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
			get = function(info) return E.db.dpe.marks.enabled end,
			set = function(info, value) E.db.dpe.marks.enabled = value; RM:UpdateVisibility() end
		},
		size = {
			order = 3,
			type = "range",
			name = L['Size'],
			desc = L['Sets size of buttons'],
			min = 15, max = 30, step = 1,
			get = function(info) return E.db.dpe.marks.size end,
			set = function(info, value) E.db.dpe.marks.size = value; RM:FrameButtonsGrowth(); RM:FrameButtonsSize() end,
		},
		growth = {
			order = 4,
			type = "select",
			name = L["Direction"],
			desc = L['Change the direction of buttons growth from "skull" mark'],
			get = function(info) return E.db.dpe.marks.growth end,
			set = function(info, value) E.db.dpe.marks.growth = value; RM:FrameButtonsGrowth() end,
			values = {
				['RIGHT'] = L["Right"],
				['LEFT'] = L["Left"],
				['UP'] = L["Up"],
				['DOWN'] = L["Down"],
			},
		},
	},
}