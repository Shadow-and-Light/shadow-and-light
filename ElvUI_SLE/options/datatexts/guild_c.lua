local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slguild = {
		type = "group",
		name = L["S&L Guild"],
		order = 4,
		args = {
			desc = ACH:Description(L["These options are for modifying the Shadow & Light Guild datatext."], 1, "large"),
			combat = {
				order = 2,
				type = "toggle",
				name = L["Hide In Combat"],
				desc = L["Will not show the tooltip while in combat."],
				get = function(info) return E.db.sle.dt.guild.combat end,
				set = function(info, value) E.db.sle.dt.guild.combat = value end,
			},
			totals = {
				order = 3,
				type = "toggle",
				name = L["Show Totals"],
				desc = L["Show total guild members in the datatext."],
				get = function(info) return E.db.sle.dt.guild.totals end,
				set = function(info, value) E.db.sle.dt.guild.totals = value; E:UpdateMedia() end,
			},
			textStyle = {
				order = 4,
				type = "select",
				name = L["Style"],
				values = {
					["Default"] = DEFAULT,
					["Icon"] = L["Icon"],
					["NoText"] = NONE,
				},
				get = function(info) return E.db.sle.dt.guild.textStyle  end,
				set = function(info, value) E.db.sle.dt.guild.textStyle  = value; E:UpdateMedia() end,
			},
			hide_hintline = {
				order = 5,
				type = "toggle",
				name = L["Hide Hints"],
				desc = L["Hide the hints in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_hintline end,
				set = function(info, value) E.db.sle.dt.guild.hide_hintline = value end,
			},
			hide_titleline = {
				order = 6,
				type = "toggle",
				name = L["Hide Title"],
				desc = L["Hide the Shadow & Light title in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_titleline end,
				set = function(info, value) E.db.sle.dt.guild.hide_titleline = value end,
			},
			hide_gmotd = {
				order = 7,
				type = "toggle",
				name = L["Hide MOTD"],
				desc = L["Hide the guild's Message of the Day in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_gmotd end,
				set = function(info, value) E.db.sle.dt.guild.hide_gmotd = value end,
			},
			tooltipAutohide = {
				order = 10,
				type = "range",
				name = L["Autohide Delay:"],
				desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
				min = 0.1, max = 1, step = 0.1,
				get = function(info) return E.db.sle.dt.guild.tooltipAutohide end,
				set = function(info, value) E.db.sle.dt.guild.tooltipAutohide = value end,
			},
			noteColor = {
				type = "color",
				order = 11,
				name = L["Public Note Text Color"],
				hasAlpha = false,
				get = function(info)
					local t = E.db.sle.dt.guild[info[#info]]
					local d = P.sle.dt.guild[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
				end,
				set = function(info, r, g, b)
					E.db.sle.dt.guild[info[#info]] = {}
					local t = E.db.sle.dt.guild[info[#info]]
					t.r, t.g, t.b = r, g, b
				end,
			},
			onoteColor = {
				type = "color",
				order = 12,
				name = L["Officer Note Text Color"],
				hasAlpha = false,
				get = function(info)
					local t = E.db.sle.dt.guild[info[#info]]
					local d = P.sle.dt.guild[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
				end,
				set = function(info, r, g, b)
					E.db.sle.dt.guild[info[#info]] = {}
					local t = E.db.sle.dt.guild[info[#info]]
					t.r, t.g, t.b = r, g, b
				end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
