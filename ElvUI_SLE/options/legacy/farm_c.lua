local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Tools = SLE:GetModule("Toolbars")
local EXPANSION_NAME4 = EXPANSION_NAME4

local function configTable()
	if not SLE.initialized then return end
	local db = E.db.sle.legacy.farm
	E.Options.args.sle.args.modules.args.legacy.args.farm = {
		type = 'group',
		order = 1,
		name = L["Farm"].." ("..EXPANSION_NAME4..")",
		get = function(info) return db[ info[#info] ] end,
		set = function(info, value) db[ info[#info] ] = value; Tools:UpdateLayout() end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Farm"],
			},
			enable = {
				type = "toggle",
				order = 2,
				name = L["Enable"],
			},
			active = {
				order = 3,
				type = 'toggle',
				name = L["Only active buttons"],
				desc = L["Only show the buttons for the seeds, portals, tools you have in your bags."],
				disabled = function() return not db.enable end,
			},
			buttonsize = {
				order = 4,
				type = "range",
				name = L["Button Size"],
				disabled = function() return not db.enable end,
				min = 15, max = 60, step = 1,
			},
			autotarget = {
				type = "toggle",
				order = 5,
				name = L["Auto Planting"],
				desc = L["Automatically plant seeds to the nearest tilled soil if one is not already selected."],
				disabled = function() return not db.enable end,
			},
			quest = {
				type = "toggle",
				order = 6,
				name = L["Quest Glow"],
				desc = L["Show glowing border on seeds needed for any quest in your log."],
				disabled = function() return not db.enable end,
			},
			seedor = {
				order = 7,
				type = "select",
				name = L["Dock Buttons To"],
				desc = L["Change the position from where seed bars will grow."],
				disabled = function() return not db.enable end,
				values = {
					["RIGHT"] = L["Right"],
					["LEFT"] = L["Left"],
					["BOTTOM"] = L["Bottom"],
					["TOP"] = L["Top"],
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)