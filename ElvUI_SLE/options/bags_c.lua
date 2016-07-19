local SLE, T, E, L, V, P, G = unpack(select(2, ...))

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.bags = {
		order = 6,
		type = "group",
		name = L["Bags"],
		disabled = function() return not E.private.bags.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Bags"],
			},
			transparentSlots = {
				order = 2,
				type = "toggle",
				name = L["Transparent Slots"],
				desc = L["Apply transparent template on bag and bank slots."],
				get = function(info) return E.private.sle.bags.transparentSlots end,
				set = function(info, value)	E.private.sle.bags.transparentSlots = value; E:StaticPopup_Show('PRIVATE_RL') end,
			},
			lootflash = {
				order = 5,
				type = "toggle",
				name = L["New Item Flash"],
				desc = L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"],
				get = function(info) return E.db.sle.bags.lootflash end,
				set = function(info, value)	E.db.sle.bags.lootflash = value end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)