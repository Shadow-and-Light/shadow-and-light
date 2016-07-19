local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local M = SLE:GetModule('Misc');

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.options.args.general.args.misc = {
		type = "group",
		name = L["Misc"],
		order = 75,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Misc"],
			},
			vehicle = {
				type = "group",
				name = L["Enhanced Vehicle Bar"],
				order = 5,
				guiInline = true,
				args = {
					info = {
						order = 2,
						type = "description",
						name = L["A different look/feel vehicle bar"],
					},
					enable = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.private.sle.vehicle.enable end,
						set = function(info, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
			viewport = {
				type = "group",
				name = L["Viewport"],
				order = 6,
				guiInline = true,
				get = function(info) return E.db.sle.misc.viewport[ info[#info] ] end,
				set = function(info, value) E.db.sle.misc.viewport[ info[#info] ] = value; M:SetViewport() end,
				args = {
					left = {
						order = 1,
						name = L["Left Offset"],
						desc = L["Set the offset from the left border of the screen."],
						type = "range",
						min = 0, max = E.screenwidth/2, step = 1,
					},
					right = {
						order = 2,
						name = L["Right Offset"],
						desc = L["Set the offset from the right border of the screen."],
						type = "range",
						min = 0, max = E.screenwidth/2, step = 1,
					},
					top = {
						order = 3,
						name = L["Top Offset"],
						desc = L["Set the offset from the top border of the screen."],
						type = "range",
						min = 0, max = E.screenheight /2 , step = 1,
					},
					bottom = {
						order = 4,
						name = L["Bottom Offset"],
						desc = L["Set the offset from the bottom border of the screen."],
						type = "range",
						min = 0, max = E.screenheight /2 , step = 1,
					},
				},
			},
		},
	}
end

-- T.tinsert(SLE.Configs, configTable)