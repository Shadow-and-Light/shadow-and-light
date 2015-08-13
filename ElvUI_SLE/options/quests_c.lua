local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.general.args.quests = {
		type = "group",
		name = OBJECTIVES_TRACKER_LABEL,
		order = 9,
		args = {
			header = {
				order = 1,
				type = "header",
				name = OBJECTIVES_TRACKER_LABEL,
			},
			rested = {
				order = 2,
				type = "select",
				name = L["Rested"],
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			garrison = {
				order = 3,
				type = "select",
				name = GARRISON_LOCATION_TOOLTIP,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			bg = {
				order = 4,
				type = "select",
				name = BATTLEGROUNDS,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			arena = {
				order = 5,
				type = "select",
				name = ARENA,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			dungeon = {
				order = 6,
				type = "select",
				name = DUNGEONS,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			scenario = {
				order = 7,
				type = "select",
				name = SCENARIOS,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
			raid = {
				order = 8,
				type = "select",
				name = RAIDS,
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; E:GetModule('SLE_Quests'):ChangeState() end,
				values = {
					["FULL"] = DEFAULT,
					["COLLAPSED"] = MINIMIZE,
					["HIDE"] = HIDE,
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)