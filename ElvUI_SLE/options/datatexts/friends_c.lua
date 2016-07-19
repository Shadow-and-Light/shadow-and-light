local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DTP = SLE:GetModule('Datatexts')

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slfriends = {
		type = "group",
		name = L["S&L Friends"],
		order = 3,
		args = {
			header = {
				order = 1,
				type = "description",
				name = L["These options are for modifing the Shadow & Light Friends datatext."],
			},
			combat = {
				order = 2,
				type = "toggle",
				name = L["Hide In Combat"],
				desc = L["Will not show the tooltip while in combat."],
				get = function(info) return E.db.sle.dt.friends.combat end,
				set = function(info, value) E.db.sle.dt.friends.combat = value; end,
			},
			totals = {
				order = 3,
				type = "toggle",
				name = L["Show Totals"],
				desc = L["Show total friends in the datatext."],
				get = function(info) return E.db.sle.dt.friends.totals end,
				set = function(info, value) E.db.sle.dt.friends.totals = value; DTP:update_Friends(); end,
			},
			hideFriends = {
				order = 4,
				type = "toggle",
				name = L["Hide Friends"],
				desc = L["Minimize the Friend Datatext."],
				get = function(info) return E.db.sle.dt.friends.hideFriends end,
				set = function(info, value) E.db.sle.dt.friends.hideFriends = value; end,
			},
			hide_hintline = {
				order = 5,
				type = "toggle",
				name = L["Hide Hints"],
				desc = L["Hide the hints in the tooltip."],
				get = function(info) return E.db.sle.dt.friends.hide_hintline end,
				set = function(info, value) E.db.sle.dt.friends.hide_hintline = value; end,
			},
			expandBNBroadcast = {
				order = 6,
				type = "toggle",
				name = L["Expand RealID"],
				desc = L["Display realid with two lines to view broadcasts."],
				get = function(info) return E.db.sle.dt.friends.expandBNBroadcast end,
				set = function(info, value) E.db.sle.dt.friends.expandBNBroadcast = value; end,
			},
			spacer = { order = 7, type = 'description', name = "" },
			tooltipAutohide = {
				order = 8,
				type = "range",
				name = L["Autohide Delay:"],
				desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
				min = 0.1, max = 1, step = 0.1,
				get = function(info) return E.db.sle.dt.friends.tooltipAutohide end,
				set = function(info, value) E.db.sle.dt.friends.tooltipAutohide = value; end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)