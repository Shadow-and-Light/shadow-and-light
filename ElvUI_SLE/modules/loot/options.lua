local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LT = E:GetModule('Loot')
local function configTable()

--Main options group
E.Options.args.sle.args.loot = {
	order = 80,
	type = "group",
	name = L['Loot Announcer'],
	args = {
		marksheader = {
			order = 1,
			type = "header",
			name = L['Loot Announcer'],
		},
		info = {
			order = 2,
			type = "description",
			name = L["LOOT_DESC"],
		},
		enabled = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.private.sle.loot.enable end,
			set = function(info, value) E.private.sle.loot.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		auto = {
			order = 4,
			type = "toggle",
			name = L["Auto Announce"],
			desc = L["Automatically announce when loot window opens (Master Looter Only)."],
			disabled = function() return not E.private.sle.loot.enable end,
			get = function(info) return E.db.sle.loot.auto end,
			set = function(info, value) E.db.sle.loot.auto = value; end
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		quality = {
			order = 6,
			type = "select",
			name = L["Loot Quality"],
			desc = L["Set the minimum quality of an item to announce."],
			disabled = function() return not E.private.sle.loot.enable end,
			get = function(info) return E.db.sle.loot.quality end,
			set = function(info, value) E.db.sle.loot.quality = value;  end,
			values = {
				['EPIC'] = "|cffA335EE"..ITEM_QUALITY4_DESC.."|r",
				['RARE'] = "|cff0070DD"..ITEM_QUALITY3_DESC.."|r",
				['UNCOMMON'] = "|cff1EFF00"..ITEM_QUALITY2_DESC.."|r",
			},
		},
		chat = {
			order = 7,
			type = "select",
			name = L["Chat"],
			desc = L["Announce loot to the selected channel."],
			disabled = function() return not E.private.sle.loot.enable end,
			get = function(info) return E.db.sle.loot.chat end,
			set = function(info, value) E.db.sle.loot.chat = value;  end,
			values = {
				['RAID'] = "|cffFF7F00"..RAID.."|r",
				['PARTY'] = "|cffAAAAFF"..PARTY.."|r",
				['SAY'] = "|cffFFFFFF"..SAY.."|r",
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)