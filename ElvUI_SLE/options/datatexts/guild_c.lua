local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DTP = SLE:GetModule('Datatexts')

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slguild = {
		type = "group",
		name = L["S&L Guild"],
		order = 4,
		args = {
			header = {
				order = 1,
				type = "description",
				name = L["These options are for modifing the Shadow & Light Guild datatext."],
			},
			combat = {
				order = 2,
				type = "toggle",
				name = L["Hide In Combat"],
				desc = L["Will not show the tooltip while in combat."],
				get = function(info) return E.db.sle.dt.guild.combat end,
				set = function(info, value) E.db.sle.dt.guild.combat = value; end,
			},
			totals = {
				order = 3,
				type = "toggle",
				name = L["Show Totals"],
				desc = L["Show total guild members in the datatext."],
				get = function(info) return E.db.sle.dt.guild.totals end,
				set = function(info, value) E.db.sle.dt.guild.totals = value; DTP:update_Guild(); end,
			},
			hide_hintline = {
				order = 4,
				type = "toggle",
				name = L["Hide Hints"],
				desc = L["Hide the hints in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_hintline end,
				set = function(info, value) E.db.sle.dt.guild.hide_hintline = value; end,
			},
			hide_gmotd = {
				order = 5,
				type = "toggle",
				name = L["Hide MOTD"],
				desc = L["Hide the guild's Message of the Day in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_gmotd end,
				set = function(info, value) E.db.sle.dt.guild.hide_gmotd = value; end,
			},
			hideGuild = {
				order = 6,
				type = "toggle",
				name = L["Hide Guild"],
				desc = L["Minimize the Guild Datatext."],
				get = function(info) return E.db.sle.dt.guild.hideGuild end,
				set = function(info, value) E.db.sle.dt.guild.hideGuild = value; end,
			},
			hide_guildname = {
				order = 7,
				type = "toggle",
				name = L["Hide Guild Name"],
				desc = L["Hide the guild's name in the tooltip."],
				get = function(info) return E.db.sle.dt.guild.hide_guildname end,
				set = function(info, value) E.db.sle.dt.guild.hide_guildname = value; end,
			},
			spacer = {
				order = 8,
				type = 'description',
				name = "",
			},
			tooltipAutohide = {
				order = 9,
				type = "range",
				name = L["Autohide Delay:"],
				desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
				min = 0.1, max = 1, step = 0.1,
				get = function(info) return E.db.sle.dt.guild.tooltipAutohide end,
				set = function(info, value) E.db.sle.dt.guild.tooltipAutohide = value; end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)