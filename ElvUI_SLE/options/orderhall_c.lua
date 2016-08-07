local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local GARRISON_LOCATION_TOOLTIP = GARRISON_LOCATION_TOOLTIP
local EXPANSION_NAME5 = EXPANSION_NAME5
local HallName = _G["ORDER_HALL_"..E.myclass]
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.orderhall = {
		type = "group",
		name = L["Class Hall"],
		order = 15,
		args = {
			header = {
				order = 1,
				type = "header",
				name = HallName,
			},
			autoOrder = {
				order = 2,
				type = "group",
				name = L["Auto Work Orders"],
				guiInline = true,
				get = function(info) return E.db.sle.orderhall.autoOrder[ info[#info] ] end,
				set = function(info, value) E.db.sle.orderhall.autoOrder[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Automatically queue maximum number of work orders available when visiting respected NPC."],
					},
					autoEquip = {
						order = 2,
						type = "toggle",
						name = L["Auto Work Orders for equipment"],
						disabled = function() return not E.db.sle.orderhall.autoOrder.enable end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)