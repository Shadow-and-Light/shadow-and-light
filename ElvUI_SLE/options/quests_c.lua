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
		},
	}
end

tinsert(SLE.Configs, configTable)
