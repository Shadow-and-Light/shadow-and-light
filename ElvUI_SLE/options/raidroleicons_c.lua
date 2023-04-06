local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.BlizzRaid

local RAID_CONTROL = RAID_CONTROL

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.raidmanager = {
		order = 1,
		type = 'group',
		name = RAID_CONTROL,
		disabled = function() return SLE._Compatibility['oRA3'] end,
		get = function(info) return E.db.sle.raidmanager[info[#info]] end,
		set = function(info, value) E.db.sle.raidmanager[info[#info]] = value; B:CreateAndUpdateIcons() end,
		args = {
			header = ACH:Header(RAID_CONTROL, 1),
			desc = ACH:Description(L["Options for customizing Blizzard Raid Manager \"O - > Raid\""], 2),
			roles = {
				order = 3,
				type = 'toggle',
				name = L["Show role icons"],
			},
			level = {
				order = 4,
				type = 'toggle',
				name = L["Show level"],
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
