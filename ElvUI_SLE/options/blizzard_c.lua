local SLE, _, E, L = unpack(select(2, ...))
local B = SLE.Blizzard
local M = SLE.Misc

--GLOBALS: unpack, select, tinsert
local tinsert = tinsert

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.blizz = {
		order = 1,
		type = "group",
		name = "Blizzard",
		args = {
			header = ACH:Header("Blizzard", 1),
			blizzmove = {
				order = 12,
				type = "group",
				name = L["Move Blizzard frames"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Allow some Blizzard frames to be moved around."],
						get = function() return E.private.sle.module.blizzmove.enable end,
						set = function(_, value) E.private.sle.module.blizzmove.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					remember = {
						order = 2,
						type = "toggle",
						name = L["Remember"],
						desc = L["Remember positions of frames after moving them."],
						get = function() return E.private.sle.module.blizzmove.remember end,
						set = function(_, value) E.private.sle.module.blizzmove.remember = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.sle.module.blizzmove.enable end,
					},
				}
			},
			errorframe = {
				order = 11,
				type = "group",
				name = L["Error Frame"],
				guiInline = true,
				get = function(info) return E.db.sle.blizzard.errorframe[ info[#info] ] end,
				set = function(info, value) E.db.sle.blizzard.errorframe[ info[#info] ] = value; B:ErrorFrameSize() end,
				args = {
					width = {
						order = 1,
						name = L["Width"],
						desc = L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"],
						type = "range",
						min = 100, max = 1000, step = 1,
					},
					height = {
						order = 2,
						name = L["Height"],
						desc = L["Set the height of Error Frame. Higher frame can show more lines at once."],
						type = "range",
						min = 30, max = 300, step = 15,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)