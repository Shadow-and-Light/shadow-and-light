local SLE, _, E, L = unpack(select(2, ...))
local M = SLE:GetModule('Misc')

local function configTable()
	E.Options.args.sle.args.modules.args.viewport = {
		type = 'group',
		name = L["Viewport"],
		order = 1,
		hidden = function() return not E.global.sle.advanced.general end,
		get = function(info) return E.db.sle.misc.viewport[info[#info]] end,
		set = function(info, value) E.db.sle.misc.viewport[info[#info]] = value; M:SetViewport() end,
		args = {
			left = {
				order = 1,
				type = 'range',
				name = L["Left Offset"],
				desc = L["Set the offset from the left border of the screen."],
				min = 0, max = E.screenwidth/2, step = 1,
			},
			right = {
				order = 2,
				type = 'range',
				name = L["Right Offset"],
				desc = L["Set the offset from the right border of the screen."],
				min = 0, max = E.screenwidth/2, step = 1,
			},
			top = {
				order = 3,
				type = 'range',
				name = L["Top Offset"],
				desc = L["Set the offset from the top border of the screen."],
				min = 0, max = E.screenheight/2, step = 1,
			},
			bottom = {
				order = 4,
				type = 'range',
				name = L["Bottom Offset"],
				desc = L["Set the offset from the bottom border of the screen."],
				min = 0, max = E.screenheight/2, step = 1,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
