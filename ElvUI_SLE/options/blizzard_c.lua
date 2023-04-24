local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.Blizzard

--GLOBALS: unpack, tinsert
local tinsert = tinsert

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.blizz = {
		order = 1,
		type = 'group',
		name = 'Blizzard',
		args = {
			header = ACH:Header('Blizzard', 1),
			errorframe = {
				order = 11,
				type = 'group',
				name = L["Error Frame"],
				guiInline = true,
				get = function(info) return E.db.sle.blizzard.errorframe[info[#info]] end,
				set = function(info, value) E.db.sle.blizzard.errorframe[info[#info]] = value B:ErrorFrameSize() end,
				args = {
					width = {
						order = 1,
						name = L["Width"],
						desc = L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"],
						type = 'range',
						min = 100, max = 1000, step = 1,
					},
					height = {
						order = 2,
						name = L["Height"],
						desc = L["Set the height of Error Frame. Higher frame can show more lines at once."],
						type = 'range',
						min = 30, max = 300, step = 15,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
