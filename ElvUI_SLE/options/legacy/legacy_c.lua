local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local LFG_LIST_LEGACY = LFG_LIST_LEGACY
local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.legacy = {
		type = "group",
		name = SLE.Russian and ITEM_QUALITY7_DESC or LFG_LIST_LEGACY,
		desc = L["Modules designed for older expantions"],
		order = 11,
		childGroups = 'tab',
		args = {
		},
	}
end

T.tinsert(SLE.Configs, configTable)