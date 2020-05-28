local SLE, T, E, L = unpack(select(2, ...)) 
local DTP = SLE:GetModule('Datatexts')

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
					-- header = {
					-- 	order = 1,
					-- 	type = "header",
					-- 	name = L["Datatext Options"]
					-- },
					-- intro = {
					-- 	order = 2,
					-- 	type = "description",
					-- 	name = L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."]
					-- },
					-- spacer = {
					-- 	order = 3,
					-- 	type = 'description',
					-- 	name = ""
					-- },
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)