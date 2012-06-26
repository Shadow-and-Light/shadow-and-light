local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local M = E:GetModule('Misc')

--Options for Exp/Rep text
E.Options.args.dpe.args.exprep = {
	type = "group",
    name = L["Xp-Rep Text"],
    order = 2,
   	args = {
		xprepmodheader = {
		order = 1,
		type = "header",
		name = L["XP-Rep Text mod by Benik"],
		},
		xprep_top = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				xprepinfo = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L['Show/Hide XP-Rep Info.'],
				get = function(info) return E.db.dpe.xprepinfo.enabled end,
				set = function(info, value) E.db.dpe.xprepinfo.enabled = value; M:UpdateExpRepBarAnchor() end
				},
				xprepdet = {
				order = 2,
				type = "toggle",
				name = L['Detailed'],
				desc = L['More XP-Rep Info. Shown only when bars are on top.'],
				get = function(info) return E.db.dpe.xprepinfo.xprepdet end,
				set = function(info, value) E.db.dpe.xprepinfo.xprepdet = value; M:UpdateExpRepBarAnchor() end
				},
			},
		},
		detailed_opt = {
			order = 3,
			type = "group",
			name = L["Detailed options"],
			guiInline = true,
			disabled = function() return not E.db.dpe.xprepinfo.xprepdet end,
			args = {			
				repreact = {
				order = 1,
				type = "toggle",
				name = L['Reaction Name'],
				desc = L['Show/Hide Reaction status on bar.'],
				get = function(info) return E.db.dpe.xprepinfo.repreact end,
				set = function(info, value) E.db.dpe.xprepinfo.repreact = value; M:UpdateExpRepBarAnchor() end
				},
				xprest = {
				order = 2,
				type = "toggle",
				name = L['Rested Value'],
				desc = L['Show/Hide Rested value.'],
				get = function(info) return E.db.dpe.xprepinfo.xprest end,
				set = function(info, value) E.db.dpe.xprepinfo.xprest = value; M:UpdateExpRepBarAnchor() end
				},
			},
		},
	},
}