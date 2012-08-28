local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RU = E:GetModule('RaidUtility')

--Raid Utility
E.Options.args.sle.args.raidutil = {
	order = 10,
	type = 'group',
	name = L["Raid Utility"],
	args = {
		raidutilheader = {
			order = 1,
			type = "header",
			name = L["Raid Utility Coordinates"],
		},
		raidutilinf = {
			order = 2,
			type = "description",
			name = L["RU_DESC"],
		},
		xpos = {
			order = 3,
			type = "range",
			name = L["X Position"],
			desc = L["Sets X position of Raid Utility button."],
			min = 0, max = E.screenwidth, step = 1,
			get = function(info) return E.db.sle.raidutil.xpos end,
			set = function(info, value) E.db.sle.raidutil.xpos = value; RU:MoveButton() end,
		},
		ypos = {
			order = 4,
			type = "range",
			name = L["Y Position"],
			desc = L["Sets Y position of Raid Utility button."],
			min = 0, max = E.screenheight, step = 1,
			get = function(info) return E.db.sle.raidutil.ypos end,
			set = function(info, value) E.db.sle.raidutil.ypos = value; RU:MoveButton() end,
		},
		show = {
		order = 5,
		type = "execute",
		name = L["Show Button"],
		desc = L["Show/hide Raid Utility button.\nThis option is not permanent. The button will act as normal when joining/leaving groups."],
		func = function() RU:ToggleButton() end,
		},	
	},
}