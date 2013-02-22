local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local EM = E:GetModule('EquipManager')

local function configTable()

E.Options.args.sle.args.equipmanager = {
	type = 'group',
	order = 2,
	name = L['Equipment Manager'],
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L["EM_DESC"],
		},
		enable = {
			type = "toggle",
			order = 2,
			name = L['Enable'],
			get = function(info) return E.private.sle.equip.enable end,
			set = function(info, value) E.private.sle.equip.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		spam = {
			type = "toggle",
			order = 3,
			name = L['Spam Throttling'],
			desc = L["Removes the spam from chat stating what talents were learned or unlearned during spec change."],
			disabled = function() return not E.private.sle.equip.enable end,
			get = function(info) return E.private.sle.equip.spam end,
			set = function(info, value) E.private.sle.equip.spam = value; EM:SpamThrottle() end
		},
		equipsets = {
			type = "group",
			name = PAPERDOLL_EQUIPMENTMANAGER,
			order = 4,
			disabled = function() return not E.private.sle.equip.enable end,
			guiInline = true,
			args = {
				intro = {
					order = 1,
					type = 'description',
					name = L["Here you can choose what equipment sets to use in different situations."],
				},
				primary = {
					order = 2,
					type = "select",
					name = SPECIALIZATION_PRIMARY,
					desc = L["Equip this set when switching to primary talents."],
					get = function(info) return E.private.sle.equip.primary end,
					set = function(info, value) E.private.sle.equip.primary = value; end,
					values = EM.equipSets
				},
				secondary = {
					order = 3,
					type = "select",
					name = SPECIALIZATION_SECONDARY,
					desc = L["Equip this set when switching to secondary talents."],
					get = function(info) return E.private.sle.equip.secondary end,
					set = function(info, value) E.private.sle.equip.secondary = value end,
					values = EM.equipSets
				},
				spacer = {
					type = "description",
					order = 4,
					name = "",
				},
				instance = {
					order = 5,
					type = "select",
					name = DUNGEONS,
					desc = L["Equip this set after entering dungeons or raids."],
					get = function(info) return E.private.sle.equip.instance end,
					set = function(info, value) E.private.sle.equip.instance = value end,
					values = EM.equipSets
				},
				pvp = {
					order = 6,
					type = "select",
					name = PVP,
					desc = L["Equip this set after entering battlegrounds or arens."],
					get = function(info) return E.private.sle.equip.pvp end,
					set = function(info, value) E.private.sle.equip.pvp = value end,
					values = EM.equipSets
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)