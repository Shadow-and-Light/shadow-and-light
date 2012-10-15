local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames')
local AB = E:GetModule('ActionBars')
local CH = E:GetModule('Chat')
local A = E:GetModule('Auras')
local SLE = E:GetModule('SLE')

--Main options group
E.Options.args.sle = {
	type = "group",
	name = L["Shadow & Light Edit"],
    order = 50,
   	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Shadow & Light Edit of ElvUI"],
		},
		info = {
			order = 2,
			type = "description",
			name = L["SLE_DESC"],
		},
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				lfrshow = {
					order = 1,
					type = "toggle",
					name = L["LFR Lockdown"],
					desc = L["Show/Hide LFR lockdown info in time datatext's tooltip."],
					get = function(info) return E.db.datatexts.lfrshow end,
					set = function(info, value) E.db.datatexts.lfrshow = value; end
				},
			},
		},
		lootwindow = {
			order = 4,
			type = "group",
			name = L["Loot History"],
			guiInline = true,
			args = {
				window = {
					order = 1,
					type = "toggle",
					name = L["Auto show/hide"],
					desc = L["Automaticaly show Blizzard loot histroy frame when in instance and hide it when out"],
					get = function(info) return E.db.sle.lootwin end,
					set = function(info, value) E.db.sle.lootwin = value; SLE:LootShow() end
				},
				alpha = {
					order = 2,
					type = "range",
					name = L['Alpha'],
					desc = L["Sets alpha of loot histroy frame."],
					min = 0.2, max = 1, step = 0.1,
					get = function(info) return E.db.sle.lootalpha end,
					set = function(info, value) E.db.sle.lootalpha = value; SLE:LootShow() end,
				},
			},
		},
	},
}
--[[
E.Options.args.sle.args.general.args.autoloot = {
	order = 2,
	type = "toggle",
	name = "Autoloot",
	desc = "Enable/Disable Autoloot window",
	get = function(info) return E.db.sle.autoloot end,
	set = function(info, value) E.db.sle.autoloot = value; end
}
]]
--Credits
E.Options.args.sle.args.credits = {
	order = 200,
	type = 'group',
	name = L["Credits"],
	args = {
		creditheader = {
			order = 1,
			type = "header",
			name = L["Credits"],
		},
		credits = {
			order = 2,
			type = "description",
			name = L["ELVUI_SLE_CREDITS"]..'\n\n\n'..L["Submodules and Coding:"]..'\n\n'..L["ELVUI_SLE_CODERS"]..'\n\n\n'..L["Other Support:"]..'\n\n'..L["ELVUI_SLE_MISC"],
		},
	},
}