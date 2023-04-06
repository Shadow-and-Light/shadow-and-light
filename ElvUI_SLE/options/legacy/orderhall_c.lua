local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local HallName = _G["ORDER_HALL_"..E.myclass]

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.legacy.args.orderhall = {
		type = "group",
		name = L["Class Hall"].." ("..EXPANSION_NAME6..")",
		order = 3,
		args = {
			header = ACH:Header(HallName, 1),
			autoOrder = {
				order = 2,
				type = "group",
				name = L["Auto Work Orders"],
				guiInline = true,
				get = function(info) return E.db.sle.legacy.orderhall.autoOrder[ info[#info] ] end,
				set = function(info, value) E.db.sle.legacy.orderhall.autoOrder[ info[#info] ] = value end,
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
						disabled = function() return not E.db.sle.legacy.orderhall.autoOrder.enable end,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
