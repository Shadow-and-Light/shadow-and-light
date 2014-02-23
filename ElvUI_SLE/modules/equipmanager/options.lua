local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local EM = E:GetModule('EquipManager')
local BI = E:GetModule('BagInfo')

local function configTable()

E.Options.args.sle.args.equipmanager = {
	type = 'group',
	order = 13,
	name = L['Equipment Manager'],
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Equipment Manager"],
		},
		intro = {
			order = 2,
			type = 'description',
			name = L["EM_DESC"],
		},
		enable = {
			type = "toggle",
			order = 3,
			name = L['Enable'],
			get = function(info) return E.private.sle.equip.enable end,
			set = function(info, value) E.private.sle.equip.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		spam = {
			type = "toggle",
			order = 4,
			name = L['Spam Throttling'],
			desc = L["Removes the spam from chat stating what talents were learned or unlearned during spec change."],
			get = function(info) return E.private.sle.equip.spam end,
			set = function(info, value) E.private.sle.equip.spam = value; EM:SpamThrottle() end
		},
		setoverlay = {
			type = "toggle",
			order = 5,
			name = L['Equipment Set Overlay'],	
			desc = L['Show the associated equipment sets for the items in your bags (or bank).'],
			get = function(info) return E.private.sle.equip.setoverlay end,
			set = function(info, value) E.private.sle.equip.setoverlay = value; BI:ToggleSettings(); end,
		},
		equipsets = {
			type = "group",
			name = PAPERDOLL_EQUIPMENTMANAGER,
			order = 6,
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