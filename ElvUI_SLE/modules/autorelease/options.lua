local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local function configTable()
--Main options group
E.Options.args.sle.args.options.args.general.args.pvpautorelease = {
	type = "group",
    name = L["PvP Auto Release"],
    order = 4,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["PvP Auto Release"],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Automatically release body when killed inside a battleground."],
			get = function(info) return E.db.sle.pvpautorelease end,
			set = function(info, value) E.db.sle.pvpautorelease = value; end
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)