local E, L, V, P, G = unpack(ElvUI); 
local M = E:GetModule('Misc')

local function configTable()
	--Options for Exp/Rep text
	E.Options.args.sle.args.options.args.general.args.exprep = {
		type = "group",
		name = L["Xp-Rep Text"],
		order = 99,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Xp-Rep Text"],
			},
			explong = {
				order = 2,
				type = "toggle",
				name = L["Full value on Exp Bar"],
				desc = L["Changes the way text is shown on exp bar."],
				get = function(info) return E.db.sle.exprep.explong end,
				set = function(info, value) E.db.sle.exprep.explong = value; M:UpdateExperience() end
			},
			replong = {
				order = 3,
				type = "toggle",
				name = L["Full value on Rep Bar"],
				desc = L["Changes the way text is shown on rep bar."],
				get = function(info) return E.db.sle.exprep.replong end,
				set = function(info, value) E.db.sle.exprep.replong = value; M:UpdateReputation() end
			},
			autotrackrep = {
				order = 4,
				type = "toggle",
				name = L["Auto Track Reputation"],
				desc = L["Automatically sets reputation tracking to the most recent reputation change."],
				get = function(info) return E.private.sle.exprep.autotrack end,
				set = function(info, value) E.private.sle.exprep.autotrack = value; end
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)