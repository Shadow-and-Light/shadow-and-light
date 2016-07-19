local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Q = SLE:GetModule("Quests")
local DEFAULT, MINIMIZE, HIDE = DEFAULT, MINIMIZE, HIDE
local QUESTS_LABEL = QUESTS_LABEL
local GARRISON_LOCATION_TOOLTIP = GARRISON_LOCATION_TOOLTIP
local BATTLEGROUNDS = BATTLEGROUNDS
local ARENA = ARENA
local DUNGEONS = DUNGEONS
local SCENARIOS = SCENARIOS
local RAIDS = RAIDS
local function configTable()
	if not SLE.initialized then return end
	local settings = {
		["FULL"] = DEFAULT,
		["COLLAPSED"] = MINIMIZE,
		["HIDE"] = HIDE,
	}
	E.Options.args.sle.args.modules.args.quests = {
		type = "group",
		name = QUESTS_LABEL,
		order = 17,
		args = {
			header = {
				order = 1,
				type = "header",
				name = QUESTS_LABEL,
			},
			autoReward = {
				type = "toggle",
				order = 2,
				name = L["Auto Reward"],
				desc = L["Automatically selects areward with higherst selling price when quest is completed. Does not really finish the quest."],
				get = function(info) return E.db.sle.quests.autoReward end,
				set = function(info, value) E.db.sle.quests.autoReward = value; end,
			},
			logState = {
				type = "group",
				order = 10,
				guiInline = true,
				name = L["Quest Log Toggle"],
				get = function(info) return E.db.sle.quests.visibility[ info[#info] ] end,
				set = function(info, value) E.db.sle.quests.visibility[ info[#info] ] = value; Q:ChangeState() end,
				args = {
					rested = {
						order = 2,
						type = "select",
						name = L["Rested"],
						values = settings,
					},
					garrison = {
						order = 3,
						type = "select",
						name = GARRISON_LOCATION_TOOLTIP,
						values = settings,
					},
					bg = {
						order = 4,
						type = "select",
						name = BATTLEGROUNDS,
						values = settings,
					},
					arena = {
						order = 5,
						type = "select",
						name = ARENA,
						values = settings,
					},
					dungeon = {
						order = 6,
						type = "select",
						name = DUNGEONS,
						values = settings,
					},
					scenario = {
						order = 7,
						type = "select",
						name = SCENARIOS,
						values = settings,
					},
					raid = {
						order = 8,
						type = "select",
						name = RAIDS,
						values = settings,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)