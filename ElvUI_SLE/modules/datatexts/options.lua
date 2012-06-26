local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local DTP = E:GetModule('DTPanels')

--Datatext panels
E.Options.args.dpe.args.datatext = {
	type = "group",
	name = L["Datatext panels"],
	order = 6,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Additional Datatext Panels"],
		},
		intro = {
			order = 2,
			type = "description",
			name = L["DP_DESC"]
		},
		top_left = {
			order = 3,
			type = "group",
			name = L["DP_1"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp1.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp1.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp1.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp1.width end,
					set = function(info, value) E.db.dpe.datatext.dp1.width = value; DTP:Resize() end,
				},
			},
		},
		top_center_left = {
			order = 4,
			type = "group",
			name = L["DP_2"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp2.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp2.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp2.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp2.width end,
					set = function(info, value) E.db.dpe.datatext.dp2.width = value; DTP:Resize() end,
				},
			},
		},
		top = {
			order = 5,
			type = "group",
			name = L["Top_Center"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					disabled = true,
					get = function(info) return E.db.dpe.datatext.top.enabled end,
					set = function(info, value) E.db.dpe.datatext.top.enabled = value; end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.top.width end,
					set = function(info, value) E.db.dpe.datatext.top.width = value; DTP:Resize() end,
				},
			},
		},
		top_center_right = {
			order = 6,
			type = "group",
			name = L["DP_3"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp3.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp3.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp3.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp3.width end,
					set = function(info, value) E.db.dpe.datatext.dp3.width = value; DTP:Resize() end,
				},
			},
		},
		top_right = {
			order = 7,
			type = "group",
			name = L["DP_4"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp4.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp4.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp4.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp4.width end,
					set = function(info, value) E.db.dpe.datatext.dp4.width = value; DTP:Resize() end,
				},
			},
		},
		bottom_left = {
			order = 8,
			type = "group",
			name = L["DP_5"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp5.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp5.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp5.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp5.width end,
					set = function(info, value) E.db.dpe.datatext.dp5.width = value; DTP:Resize() end,
				},
			},
		},
		bottom = {
			order = 9,
			type = "group",
			name = L["Bottom_Panel"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.bottom.enabled end,
					set = function(info, value) E.db.dpe.datatext.bottom.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.bottom.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.bottom.width end,
					set = function(info, value) E.db.dpe.datatext.bottom.width = value; DTP:Resize() end,
				},
			},
		},
		bottom_right = {
			order = 10,
			type = "group",
			name = L["DP_6"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					get = function(info) return E.db.dpe.datatext.dp6.enabled end,
					set = function(info, value) E.db.dpe.datatext.dp6.enabled = value; DTP:ExtraDataBarSetup() end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.dp6.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.dp6.width end,
					set = function(info, value) E.db.dpe.datatext.dp6.width = value; DTP:Resize() end,
				},
			},
		},
		chat_left = {
			order = 11,
			type = "group",
			name = L["Left Chat"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					disabled = true,
					get = function(info) return E.db.dpe.datatext.chatleft.enabled end,
					set = function(info, value) E.db.dpe.datatext.chatleft.enabled = value; end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.chatleft.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.chatleft.width end,
					set = function(info, value) E.db.dpe.datatext.chatleft.width = value; DTP:ChatResize() end,
				},
			},
		},
		chat_right = {
			order = 12,
			type = "group",
			name = L["Right Chat"],
			guiInline = true,
			args = {
				enabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L['Show/Hide this panel.'],
					disabled = true,
					get = function(info) return E.db.dpe.datatext.chatright.enabled end,
					set = function(info, value) E.db.dpe.datatext.chatright.enabled = value; end
				},
				width = {
					order = 2,
					type = "range",
					name = L['Width'],
					desc = L['Sets size of this panel'],
					disabled = function() return not E.db.dpe.datatext.chatright.enabled end,
					min = 100, max = E.screenwidth/2, step = 1,
					get = function(info) return E.db.dpe.datatext.chatright.width end,
					set = function(info, value) E.db.dpe.datatext.chatright.width = value; DTP:ChatResize() end,
				},
			},
		},
	},
}