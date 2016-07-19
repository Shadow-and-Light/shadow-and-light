local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local RAID_FINDER = RAID_FINDER
local RAIDS = RAIDS
local EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6 = EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6


local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.timedt = {
		type = "group",
		name = RAID_FINDER,
		order = 1,
		args = {
			lfrshow = {
				order = 1, type = "toggle",
				name = L["LFR Lockout"],
				desc = L["Show/Hide LFR lockout info in time datatext's tooltip."],
				get = function(info) return E.db.sle.lfr.enabled end,
				set = function(info, value) E.db.sle.lfr.enabled = value; end
			},
			raids = {
				order = 2, type = "group",
				name = RAIDS,
				guiInline = true,
				get = function(info) return E.db.sle.lfr[ info[#info] ] end,
				set = function(info, value) E.db.sle.lfr[ info[#info] ] = value; end,
				args = {
					Cata = {
						order = 1, type = "group",
						name = EXPANSION_NAME3,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.cata[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.cata[ info[#info] ] = value; end,
						args = {
							ds = { order = 1, type = "toggle", name = T.GetMapNameByID(824) },
						},
					},
					MoP = {
						order = 2, type = "group",
						name = EXPANSION_NAME4,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.mop[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.mop[ info[#info] ] = value; end,
						args = {
							mv = { order = 1, type = "toggle", name = T.GetMapNameByID(896) },
							hof = { order = 2, type = "toggle", name = T.GetMapNameByID(897) },
							toes = { order = 3, type = "toggle", name = T.GetMapNameByID(886) },
							tot = { order = 4, type = "toggle", name = T.GetMapNameByID(930) },
							soo = { order = 5, type = "toggle", name = T.GetMapNameByID(953) },
						},
					},
					WoD = {
						order = 3, type = "group",
						name = EXPANSION_NAME5,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.wod[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.wod[ info[#info] ] = value; end,
						args = {
							hm = { order = 1, type = "toggle", name = T.GetMapNameByID(994) },
							brf = { order = 2, type = "toggle", name = T.GetMapNameByID(988) },
							hfc = { order = 3, type = "toggle", name = T.GetMapNameByID(1026) },
						},
					},
					Legion = {
						order = 4, type = "group",
						name = EXPANSION_NAME6,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.legion[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.legion[ info[#info] ] = value; end,
						args = {
							nightmare = { order = 1, type = "toggle", name = T.GetMapNameByID(1094) },
							palace = { order = 2, type = "toggle", name = T.GetMapNameByID(1088) },
						},
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)