local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Q = SLE.Quests

local DEFAULT, MINIMIZE, HIDE = DEFAULT, MINIMIZE, HIDE
local QUESTS_LABEL = QUESTS_LABEL
local GARRISON_LOCATION_TOOLTIP = GARRISON_LOCATION_TOOLTIP
local BATTLEGROUNDS, ARENA, DUNGEONS, SCENARIOS, RAIDS = BATTLEGROUNDS, ARENA, DUNGEONS, SCENARIOS, RAIDS

local settings = {
	FULL = DEFAULT,
	COLLAPSED = MINIMIZE,
	COLLAPSED_QUESTS = MINIMIZE..' (Quests Only)',
	HIDE = HIDE,
}

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.quests = {
		type = 'group',
		name = QUESTS_LABEL,
		order = 1,
		args = {
			header = ACH:Header(QUESTS_LABEL, 1),
			autoReward = {
				order = 2,
				type = 'toggle',
				name = L["Auto Reward"],
				desc = L["Automatically selects a reward with highest selling price when quest is completed. Does not really finish the quest."],
				get = function(info) return E.db.sle.quests[info[#info]] end,
				set = function(info, value) E.db.sle.quests[info[#info]] = value end,
			},
			logState = {
				order = 10,
				type = 'group',
				name = L["Quest Log Toggle"],
				guiInline = true,
				disabled = function() return not E.db.sle.quests.visibility.enable end,
				get = function(info) return E.db.sle.quests.visibility[info[#info]] end,
				set = function(info, value) E.db.sle.quests.visibility[info[#info]] = value; Q:ChangeState() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						disabled = false,
					},
					rested = {
						order = 2,
						type = 'select',
						name = L["Rested"],
						values = settings,
					},
					garrison = {
						order = 3,
						type = 'select',
						name = GARRISON_LOCATION_TOOLTIP,
						values = settings,
					},
					orderhall = {
						order = 4,
						type = 'select',
						name = L["Class Hall"],
						values = settings,
					},
					bg = {
						order = 5,
						type = 'select',
						name = BATTLEGROUNDS,
						values = settings,
					},
					arena = {
						order = 6,
						type = 'select',
						name = ARENA,
						values = settings,
					},
					dungeon = {
						order = 7,
						type = 'select',
						name = DUNGEONS,
						values = settings,
					},
					scenario = {
						order = 8,
						type = 'select',
						name = SCENARIOS,
						values = settings,
					},
					raid = {
						order = 9,
						type = 'select',
						name = RAIDS,
						values = settings,
					},
					combat = {
						order = 10,
						type = 'select',
						name = COMBAT,
						values = {
							FULL = DEFAULT,
							COLLAPSED = MINIMIZE,
							COLLAPSED_QUESTS = MINIMIZE..' (Quests Only)',
							HIDE = HIDE,
							NONE = NONE,
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
