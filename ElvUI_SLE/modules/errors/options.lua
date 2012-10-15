local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

E.Options.args.sle.args.general.args.errors = {
	order = 3,
	type = "toggle",
	name = L["Errors in combat"],
	desc = L["Show/hide error messages in combat."],
	get = function(info) return E.private.sle.errors end,
	set = function(info, value) E.private.sle.errors = value; E:StaticPopup_Show("PRIVATE_RL") end
}