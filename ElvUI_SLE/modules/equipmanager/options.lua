local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local EM = E:GetModule('EquipManager')
local function configTable()

E.Options.args.sle.args.specswitch = {
	type = 'group',
	order = 7,
	name = L['Equipment manager'],
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L["FARM_DESC"],
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)