local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = SLE:GetModule("BlizzRaid")
local RAID_CONTROL = RAID_CONTROL
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.raidmanager = {
		type = "group",
		name = RAID_CONTROL,
		order = 19,
		disabled = function() return SLE._Compatibility["oRA3"] end,
		get = function(info) return E.db.sle.raidmanager[ info[#info] ] end,
		set = function(info, value) E.db.sle.raidmanager[ info[#info] ] = value; B:CreateAndUpdateIcons() end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = RAID_CONTROL,
			},
			info = {
				order = 2,
				type = "description",
				name = L["Options for customizing Blizzard Raid Manager \"O - > Raid\""],
			},
			roles = {
				order = 3,
				type = "toggle",
				name = L["Show role icons"],
			},
			level = {
				order = 4,
				type = "toggle",
				name = L["Show level"],
			},
		},
	}
end
T.tinsert(SLE.Configs, configTable)