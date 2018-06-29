local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local ESC = SLE:GetModule("EverySecondCounts")
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.cooldowns = {
		type = "group",
		name = L["Cooldown Text"],
		order = 4,
		get = function(info) return E.db.sle.cooldowns[ info[#info] ] end,
		set = function(info, value) E.db.sle.cooldowns[ info[#info] ] = value; ESC:UpdateSettings("text") end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Cooldown Text"],
			},
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.sle.cooldowns[ info[#info] ] end,
				set = function(info, value) E.db.sle.cooldowns[ info[#info] ] = value; ESC:UpdateSettings("all") end,
			},
			mmssThreshold = {
				order = 3,
				type = 'range',
				name = L['MM:SS Threshold'],
				desc = L['Threshold (in seconds) before text is shown in the MM:SS format. Set to -1 to never change to this format.'],
				min = -1, max = 1200, step = 1,
				get = function(info) return E.db.sle.cooldowns[ info[#info] ] end,
				set = function(info, value) E.db.sle.cooldowns[ info[#info] ] = value; ESC:UpdateSettings("threshold") end,
			},
			font = {
				order = 4,
				type = 'select',
				name = L["Font"],
				dialogControl = 'LSM30_Font',
				values = AceGUIWidgetLSMlists.font,
			},
			fontOutline = {
				order = 5,
				type = "select",
				name = L["Font Outline"],
				values = {
					['NONE'] = L['None'],
					['OUTLINE'] = 'OUTLINE',
					['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
					['THICKOUTLINE'] = 'THICKOUTLINE',
				},
			},
			fontSize = {
				order = 6,
				type = 'range',
				name = L['Font Size'],
				desc = L['Sets the size of the timers.'],
				min = 10, max = 30, step = 1,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)