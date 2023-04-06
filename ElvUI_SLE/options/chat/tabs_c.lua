local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.chat.args.tabs = {
		order = 15,
		type = "group",
		name = L["Tabs"],
		get = function(info) return E.db.sle.chat.tab[ info[#info] ] end,
		set = function(info, value) E.db.sle.chat.tab[ info[#info] ] = value; FCF_DockUpdate() end,
		args = {
			resize = {
				order = 1,
				type = "select",
				name = L["Automatic Width"],
				-- desc = L["Attempt to resize chat tabs to stop title throttling. This may cause unwanted results with many tabs."],
				values = {
					["None"] = NONE,
					["Blizzard"] = "Blizzard",
					["Title"] = L["Title Width"],
					["Custom"] = CUSTOM,
				}
			},
			customWidth = {
				order = 2,
				type = "range",
				name = L["Width"],
				disabled = function() return E.db.sle.chat.tab.resize ~= "Custom" end,
				min = 45, max = 100, step = 1,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
