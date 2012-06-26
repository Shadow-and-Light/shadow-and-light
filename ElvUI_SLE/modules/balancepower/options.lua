local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
		
--Adds a new option group is character is a druid.
if E.myclass == "DRUID" then
E.Options.args.dpe.args.druid = {
	order = 15,
	type = 'group',
	name = L["Druid"],
	args = {
		druidheader = {
			order = 1,
			type = "header",
			name = L["Druid spesific options"],
		},
		general = {
			order = 2,
			type = "group",
			name = '',
			guiInline = true,
			args = {
				bpenable = { --Frame with sol/lun energy count
					order = 1,
					type = "toggle",
					name = L["Balance Power Frame"],
					desc = L["Show/hide the frame with exact number of your Solar/Lunar energy."],
					get = function(info) return E.db.general.bpenable end,
					set = function(info, value) E.db.general.bpenable = value; E:GetModule('DPE'):BPUpdate() end
				},
			},
		},
	},
}
end