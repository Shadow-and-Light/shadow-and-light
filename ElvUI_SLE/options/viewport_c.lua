local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local M = SLE:GetModule("Misc")

local function configTable()
	E.Options.args.sle.args.modules.args.viewport = {
		type = "group",
		name = L["Viewport"],
		order = 22,
		hidden = function() return not E.global.sle.advanced.general end,
		get = function(info) return E.db.sle.misc.viewport[ info[#info] ] end,
		set = function(info, value) E.db.sle.misc.viewport[ info[#info] ] = value; M:SetViewport() end,
		args = {
			left = {
				order = 1,
				name = L["Left Offset"],
				desc = L["Set the offset from the left border of the screen."],
				type = "range", min = 0, max = E.screenwidth/2, step = 1,
			},
			right = {
				order = 2,
				name = L["Right Offset"],
				desc = L["Set the offset from the right border of the screen."],
				type = "range", min = 0, max = E.screenwidth/2, step = 1,
			},
			top = {
				order = 3,
				name = L["Top Offset"],
				desc = L["Set the offset from the top border of the screen."],
				type = "range", min = 0, max = E.screenheight /2 , step = 1,
			},
			bottom = {
				order = 4,
				name = L["Bottom Offset"],
				desc = L["Set the offset from the bottom border of the screen."],
				type = "range", min = 0, max = E.screenheight /2 , step = 1,
			},
		},
	}
end
T.tinsert(SLE.Configs, configTable)