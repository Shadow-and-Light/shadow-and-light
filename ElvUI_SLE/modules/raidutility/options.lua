local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local RU = E:GetModule('RaidUtility')

--Raid Utility
E.Options.args.dpe.args.raidutil = {
	order = 10,
	type = 'group',
	name = L["Raid Utility"],
	args = {
		raidutilheader = {
			order = 1,
			type = "header",
			name = L["Raid Utility coordinates"],
		},
		raidutilinf = {
			order = 2,
			type = "description",
			name = L["RU_DESC"],
		},
		xpos = {
			order = 3,
			type = "range",
			name = L['X Position'],
			desc = L['Sets X position of Raid Utility button.'],
			min = 0, max = E.screenwidth, step = 1,
			get = function(info) return E.db.dpe.raidutil.xpos end,
			set = function(info, value) E.db.dpe.raidutil.xpos = value; RU:MoveButton() end,
		},
		ypos = {
			order = 4,
			type = "range",
			name = L['Y Position'],
			desc = L['Sets Y position of Raid Utility button.'],
			min = 0, max = E.screenheight, step = 1,
			get = function(info) return E.db.dpe.raidutil.ypos end,
			set = function(info, value) E.db.dpe.raidutil.ypos = value; RU:MoveButton() end,
		},
	},
}