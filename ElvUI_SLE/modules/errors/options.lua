local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local function configTable()
E.Options.args.sle.args.general.args.errors = {
	order = 3,
	type = "toggle",
	name = L["Errors in combat"],
	desc = L["Show/hide error messages in combat."],
	get = function(info) return E.db.sle.errors end,
	set = function(info, value) E.db.sle.errors = value; end
}
end

table.insert(E.SLEConfigs, configTable)