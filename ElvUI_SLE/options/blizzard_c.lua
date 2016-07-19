local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = SLE:GetModule("Blizzard")
local M = SLE:GetModule("Misc")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.blizz = {
		order = 6,
		type = "group",
		name = "Blizzard",
		args = {
			header = {
				order = 1,
				type = "header",
				name = "Blizzard",
			},
			blizzmove = {
				order = 1,
				type = "toggle",
				name = L["Move Blizzard frames"],
				desc = L["Allow some Blizzard frames to be moved around."],
				get = function(info) return E.private.sle.module.blizzmove end,
				set = function(info, value) E.private.sle.module.blizzmove = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			rumouseover = {
				order = 2,
				type = "toggle",
				name = L["Raid Utility Mouse Over"],
				desc = L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."],
				get = function(info) return E.db.sle.blizzard.rumouseover end,
				set = function(info, value) E.db.sle.blizzard.rumouseover = value; M:RUReset() end,
			},
			vehicleSeatScale = {
				order = 3,
				type = 'range',
				name = L["Vehicle Seat Scale"],
				min = 0.1, max = 3, step = 0.01,
				isPercent = true,
				get = function(info) return E.db.sle.blizzard[ info[#info] ] end,
				set = function(info, value) E.db.sle.blizzard[ info[#info] ] = value; B:VehicleScale() end,
				-- disabled = function() return not E.private.sle.skins.objectiveTracker.enable or not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
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

T.tinsert(SLE.Configs, configTable)