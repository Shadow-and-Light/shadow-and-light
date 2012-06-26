local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB

E.Options.args.dpe.args.skins = {
	order = 7,
	type = "group",
	name = L["Skins"],
	args = {
		dbm = {
			order = 1,
			type = "group",
			name = "DBM",
			guiInline = true,
			args = {		
				fontsize = {
					order = 2,
					type = "range",
					name = L['Font Size'],
					desc = L["Sets font size on DBM bars"],
					min = 8, max = 14, step = 1,
					get = function(info) return E.private.dpe.dbm.size end,
					set = function(info, value) E.private.dpe.dbm.size = value; StaticPopup_Show("PRIVATE_RL") end,
				},
			},
		},
		skada = {
			order = 2,
			type = "group",
			name = "Skada",
			guiInline = true,
			args = {
				skadaback = {
					order = 4,
					type = "toggle",
					name = L["Skada Backdrop"],
					desc = L['Show/Hide Skada backdrop.'],
					get = function(info) return E.private.dpe.skadaback end,
					set = function(info, value) E.private.dpe.skadaback = value; StaticPopup_Show("PRIVATE_RL") end
				},
			},
		},
	},
}