local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local function configTable()
E.Options.args.sle.args.skins = {
	order = 8,
	type = "group",
	name = L["Skins"],
	guiInline = true,
	args = {
		info = {
			order = 1,
			type = "description",
			name = L["This options require ElvUI AddOnSkins pack to work."],
		},
		dbm = {
			order = 2,
			type = "group",
			name = "DBM",
			guiInline = true,
			args = {		
				fontsize = {
					order = 1,
					disabled = function() return not IsAddOnLoaded('DBM-Core') end,
					type = "range",
					name = L['Font Size'],
					desc = L["Sets font size on DBM bars"],
					min = 8, max = 14, step = 1,
					get = function(info) return E.private.sle.dbm.size end,
					set = function(info, value) E.private.sle.dbm.size = value; E:StaticPopup_Show("PRIVATE_RL") end,
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)