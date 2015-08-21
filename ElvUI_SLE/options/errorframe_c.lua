local E, L, V, P, G = unpack(ElvUI); 
local F = E:GetModule('SLE_ErrorFrame');
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

local function configTable()
	E.Options.args.sle.args.options.args.general.args.errorframe = {
		type = "group",
		name = L["Error Frame"],
		order = 75,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Error Frame"],
			},
			hideErrorFrame = {
				order = 2,
				name = L["Hide Error Text"],
				desc = L["Hides the red error text at the top of the screen while in combat."],
				type = "toggle",
				get = function(info) return E.db.general[ info[#info] ] end,
				set = function(info, value) E.db.general[ info[#info] ] = value end,
			},
			space = {
				type = "description",
				order = 3,
				name = '',
			},
			width = {
				order = 4,
				name = L["Width"],
				desc = L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"],
				type = "range",
				min = 100, max = 1000, step = 1,
				get = function(info) return E.db.sle.errorframe.width end,
				set = function(info, value) E.db.sle.errorframe.width = value; F:SetSize() end
			},
			height = {
				order = 5,
				name = L["Height"],
				desc = L["Set the height of Error Frame. Higher frame can show more lines at once."],
				type = "range",
				min = 30, max = 300, step = 15,
				get = function(info) return E.db.sle.errorframe.height end,
				set = function(info, value) E.db.sle.errorframe.height = value; F:SetSize() end
			},
		},
	}
	
	E.Options.args.general.args.general.args.hideErrorFrame = {
		order = 13,
		name = L["Hide Error Text"],
		desc = L["This option have been moved by Shadow & Light. Click to access it's new place."],
		type = "execute",
		func = function() ACD:SelectGroup("ElvUI", "sle", "options", "general", "errorframe") end,
	}
end

table.insert(E.SLEConfigs, configTable)