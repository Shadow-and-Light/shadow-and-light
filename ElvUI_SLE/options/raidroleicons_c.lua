local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local B = E:GetModule("SLE_BlizzRaid")

local function configTable()
	E.Options.args.sle.args.options.args.general.args.raidmanager = {
		type = "group",
		name = RAID,
		order = 80,
		disabled = function() return SLE.oraenabled end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = RAID,
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
				get = function(info) return E.db.sle.raidmanager.roles end,
				set = function(info, value) E.db.sle.raidmanager.roles = value; E:GetModule("SLE_BlizzRaid"):CreateAndUpdateIcons() end,
			},
			level = {
				order = 4,
				type = "toggle",
				name = L["Show level"],
				get = function(info) return E.db.sle.raidmanager.level end,
				set = function(info, value) E.db.sle.raidmanager.level = value; E:GetModule("SLE_BlizzRaid"):CreateAndUpdateIcons() end,
			},
		},
	}
end
table.insert(E.SLEConfigs, configTable)