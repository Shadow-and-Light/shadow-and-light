local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Misc

local ceil = ceil
local function configTable()
	local width = ceil(E.screenWidth)/2
	local height = ceil(E.screenHeight)/2
	E.Options.args.sle.args.modules.args.viewport = {
		type = 'group',
		name = L["Viewport"],
		order = 1,
		hidden = function() return not E.global.sle.advanced.general end,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				type = 'toggle',
				get = function(info) return E.private.sle.viewport[info[#info]] end,
				set = function(info, value) E.private.sle.viewport[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				disabled = function() return SLE._Compatibility['SunnArt'] end,
			},
			viewport = {
				order = 1,
				type = 'group',
				name = L["Viewport"],
				guiInline = true,
				get = function(info) return E.db.sle.misc.viewport[info[#info]] end,
				set = function(info, value)
					E.db.sle.misc.viewport[info[#info]] = value
					M:SetViewport()
				end,
				disabled = function() return SLE._Compatibility['SunnArt'] or not M.ViewportInitialized or not E.private.sle.viewport.enable end,
				args = {
					left = {
						order = 1,
						type = 'range',
						name = L["Left Offset"],
						desc = L["Set the offset from the left border of the screen."],
						min = 0, max = width, step = 1,
					},
					right = {
						order = 2,
						type = 'range',
						name = L["Right Offset"],
						desc = L["Set the offset from the right border of the screen."],
						min = 0, max = width, step = 1,
					},
					top = {
						order = 3,
						type = 'range',
						name = L["Top Offset"],
						desc = L["Set the offset from the top border of the screen."],
						min = 0, max = height, step = 1,
					},
					bottom = {
						order = 4,
						type = 'range',
						name = L["Bottom Offset"],
						desc = L["Set the offset from the bottom border of the screen."],
						min = 0, max = height, step = 1,
					},
				}
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
