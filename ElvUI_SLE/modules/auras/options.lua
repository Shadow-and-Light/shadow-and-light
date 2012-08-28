local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local A = E:GetModule('Auras');

E.Options.args.sle.args.auras = {
	type = "group",
	name = L["Auras"],
	order = 5,
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
			get = function(info) return E.private.sle.auras.castername end,
			set = function(info, value) E.private.sle.auras.castername = value; E:StaticPopup_Show("PRIVATE_RL") end,
		},
	},
}