local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local function configTable()

E.Options.args.sle.args.auras = {
	type = "group",
	name = L["Tooltip"],
	order = 7,
	guiInline = true,
	args = {
		info = {
			order = 1,
			type = "description",
			name = L["Options for customizing auras near the minimap."],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Caster Name"],
			desc = L["Enabling this will show caster name in the buffs and debuff icons."],
			get = function(info) return E.db.sle.castername end,
			set = function(info, value) E.db.sle.castername = value; end,
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)