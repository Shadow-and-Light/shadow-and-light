local SLE, T, E, L = unpack(select(2, ...))

local function configTable()
	if not SLE.initialized then return end

	--Datatext panels
	E.Options.args.sle.args.modules.args.datatext = {
		order = 1,
		type = "group",
		name = L["DataTexts"],
		childGroups = "tab",
		args = {
			sldatatext = {
				type = "group",
				name = L["S&L Datatexts"],
				order = 1,
				args = {
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)