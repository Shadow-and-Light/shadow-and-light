local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE:GetModule("Misc")
local SETTINGS = SETTINGS
local LFG_LIST_LEGACY = LFG_LIST_LEGACY
local function configTable()
	if not SLE.initialized then return end

	--Main options group
	E.Options.args.sle.args.modules.args.threat = {
		type = "group",
		name = L["Threat"],
		order = 1,
		-- guiInline = true,
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.sle.misc.threat.enable end,
				set = function(info, value) E.db.sle.misc.threat.enable = value; M:Threat_UpdateConfig(); M:Threat_UpdatePosition() end,
			},
			position = {
				order = 2,
				type = 'select',
				name = L["Position"],
				desc = L["Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L."],
				disabled = function() return not E.db.sle.misc.threat.enable end,
				values = {
					["SLE_DataPanel_1"] = L["SLE_DataPanel_1"],
					["SLE_DataPanel_2"] = L["SLE_DataPanel_2"],
					["SLE_DataPanel_3"] = L["SLE_DataPanel_3"],
					["SLE_DataPanel_4"] = L["SLE_DataPanel_4"],
					["SLE_DataPanel_5"] = L["SLE_DataPanel_5"],
					["SLE_DataPanel_6"] = L["SLE_DataPanel_6"],
					["SLE_DataPanel_7"] = L["SLE_DataPanel_7"],
					["SLE_DataPanel_8"] = L["SLE_DataPanel_8"],
					["LeftChatDataPanel"] = L["Left Chat"],
					["RightChatDataPanel"] = L["Right Chat"],
				},
				get = function(info) return E.db.sle.misc.threat.position end,
				set = function(info, value) E.db.sle.misc.threat.position = value; M:UpdateThreatPosition() end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
