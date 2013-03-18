local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local function configTable()

E.Options.args.sle.args.chat = {
	order = 11,
	type = "group",
	name = L["Chat"],
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Chat Options"],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				editboxhistory = {
					order = 2,
					type = "range",
					name = L["Chat Editbox History"],
					desc = L["Amount of messages to save. Set to 0 to disable."],
					min = 0, max = 20, step = 1,
					get = function(info) return E.db.chat.editboxhistory end,
					set = function(info, value)	E.db.chat.editboxhistory = value; end,
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)