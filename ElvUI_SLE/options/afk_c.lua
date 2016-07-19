local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = SLE:GetModule("Screensaver")

local function configTable()
	if not SLE.initialized then return end

	local function CreateFont(i, title, group)
		local config = {
			order = i,
			type = "group",
			name = title,
			get = function(info) return E.db.sle.screensaver[group][ info[#info] ] end,
			set = function(info, value) E.db.sle.screensaver[group][ info[#info] ] = value S:Media() end,
			args = {
				font = {
					type = "select", dialogControl = 'LSM30_Font',
					order = 1,
					name = L["Font"],
					values = AceGUIWidgetLSMlists.font,	
				},
				size = {
					order = 2,
					name = L["Font Size"],
					type = "range",
					min = 8, max = 32, step = 1,
				},
				outline = {
					order = 3,
					name = L["Font Outline"],
					type = "select",
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = 'OUTLINE',
						["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
						["THICKOUTLINE"] = 'THICKOUTLINE',
					},
				},
			},
		}
		return config
	end
	E.Options.args.sle.args.modules.args.screensaver = {
		type = "group",
		name = L["AFK Mode"],
		order = 2,
		childGroups = 'tab',
		disabled = function() return not E.db.general.afk end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable S&L's additional features for AFK screen."],
				get = function(info) return E.private.sle.module.screensaver end,
				set = function(info, value) E.private.sle.module.screensaver = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			keydown = {
				order = 2,
				type = "toggle",
				name = L["Button restrictions"],
				desc = L["Use ElvUI's restrictions for button presses."],
				hidden = function() return not E.global.sle.advanced.general end,
				get = function(info) return E.db.sle.screensaver.keydown end,
				set = function(info, value) E.db.sle.screensaver.keydown = value; S:KeyScript() end,
			},
			fonts = {
				order = 3,
				type = "group",
				name = L["Fonts"],
				disabled = function() return not E.private.sle.module.screensaver end,
				args = {
					title = CreateFont(1, L["Title font"], "title"),
					subtitle = CreateFont(2, L["Subitle font"], "subtitle"),
					date = CreateFont(3,L["Date font"], "date"),
					player = CreateFont(4,L["Player info font"], "player"),
					tips = CreateFont(5,L["Tips font"], "tips"),
				},
			},
			graphics = {
				type = "group",
				name = L["Graphics"],
				order = 4,
				disabled = function() return not E.private.sle.module.screensaver end,
				args = {
					general = {
						type = "group",
						name = L["General"],
						order = 1,
						args = {
							crest = {
								order = 1,
								name = L["Crest Size"],
								type = "range",
								min = 84, max = 256, step = 1,
								get = function(info) return E.db.sle.screensaver.crest end,
								set = function(info, value) E.db.sle.screensaver.crest = value; S:Media() end,
							},
							xpack = {
								order = 2,
								name = L["X-Pack Logo Size"],
								type = "range",
								min = 100, max = 256, step = 1,
								get = function(info) return E.db.sle.screensaver.xpack end,
								set = function(info, value) E.db.sle.screensaver.xpack = value; S:Media() end,
							},
							height = {
								order = 3,
								name = L["Panel Height"],
								type = "range",
								min = 120, max = 200, step = 1,
								get = function(info) return E.db.sle.screensaver.height end,
								set = function(info, value) E.db.sle.screensaver.height = value end,
							},
							animType = {
								order = 4,
								name = L["Template"],
								type = "select",
								disabled = function() return E.db.sle.screensaver.panelTemplate == 0 end,
								get = function(info) return E.db.sle.screensaver.panelTemplate end,
								set = function(info, value) E.db.sle.screensaver.panelTemplate = value; S:SetPanelTemplate() end,
								values = {
									["Default"] = DEFAULT,
									["Transparent"] = L["Transparent"],
								},
							},
						},
					},
					model = {
						type = "group",
						name = L["Player Model"],
						order = 2,
						args = {
							modelanim = {
								order = 1,
								name = L["Model Animation"],
								type = "select",
								get = function(info) return E.db.sle.screensaver.playermodel.anim end,
								set = function(info, value) E.db.sle.screensaver.playermodel.anim = value end,
								values = {
									[47] = "Standing",
									[4] = "Walking",
									[5] = "Running",
									[13] = "Walking backwards",
									[25] = 'Unarmed Ready',
									[60] = "Talking",
									[64] = 'Exclmation',
									[66] = 'Bow',
									[67] = 'Wave',
									[68] = 'Ceers',
									[69] = 'Dance',
									[70] = 'Laugh',
									[76] = 'Kiss',
									[77] = 'Cry',
									[80] = 'Applaud',
									[82] = 'Flex',
									[83] = 'Shy',
									[113] = 'Salute',
								},
							},
							holderXoffset = {
								order = 6,
								name = L["X-Offset"],
								type = "range",
								min = -E.screenwidth, max = E.screenwidth, step = 1,
								get = function(info) return E.db.sle.screensaver.playermodel.holderXoffset end,
								set = function(info, value) E.db.sle.screensaver.playermodel.holderXoffset = value; S:ModelHolderPos() end,
							},
							holderYoffset = {
								order = 7,
								name = L["Y-Offset"],
								type = "range",
								min = -E.screenheight, max = E.screenheight, step = 1,
								get = function(info) return E.db.sle.screensaver.playermodel.holderYoffset end,
								set = function(info, value) E.db.sle.screensaver.playermodel.holderYoffset = value; S:ModelHolderPos() end,
							},
							distance = {
								order = 8,
								name = L["Camera Distance Scale"],
								type = "range",
								min = 0, max = 10, step = 0.01,
								get = function(info) return E.db.sle.screensaver.playermodel.distance end,
								set = function(info, value) E.db.sle.screensaver.playermodel.distance = value end,
							},
							rotation = {
								type = 'range',
								name = L["Model Rotation"],
								order = 4,
								min = 0, max = 360, step = 1,
								get = function(info) return E.db.sle.screensaver.playermodel.rotation end,
								set = function(info, value) E.db.sle.screensaver.playermodel.rotation = value end,
							},
							testmodel = {
								order = 10,
								type = 'execute',
								name = L["Test"],
								desc = L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."],
								func = function() S:TestShow() end,
							},
						},
					},
				},
			},
			misc = {
				type = "group",
				name = L["Misc"],
				order = 5,
				disabled = function() return not E.private.sle.module.screensaver end,
				args = {
					animBounce = {
						order = 1,
						type = "toggle",
						name = L["Bouncing"],
						desc = L["Use bounce on fade in animations."],
						disabled = function() return E.db.sle.screensaver.animTime == 0 end,
						get = function(info) return E.db.sle.screensaver.animBounce end,
						set = function(info, value) E.db.sle.screensaver.animBounce = value; S:SetupAnimations() end,
					},
					animTime = {
						order = 2,
						type = "range",
						name = L["Animation time"],
						desc = L["Time the fade in animation will take. To disable animation set to 0."],
						min = 0, max = 10, step = 0.01,
						get = function(info) return E.db.sle.screensaver.animTime end,
						set = function(info, value) E.db.sle.screensaver.animTime = value; S:Hide() end,
					},
					animType = {
						order = 3,
						name = L["Animation Type"],
						type = "select",
						disabled = function() return E.db.sle.screensaver.animTime == 0 end,
						get = function(info) return E.db.sle.screensaver.animType end,
						set = function(info, value) E.db.sle.screensaver.animType = value; S:SetupType() end,
						values = {
							["SlideIn"] = L["Slide"],
							["SlideSide"] = L["Slide Sideways"],
							["FadeIn"] = L["Fade"],
						},
					},
					tipThrottle = {
						order = 4,
						name = L["Tip time"],
						desc = L["Number of seconds tip will be shown before changed to another."],
						type = "range",
						min = 5, max = 120, step = 1,
						get = function(info) return E.db.sle.screensaver.tipThrottle end,
						set = function(info, value) E.db.sle.screensaver.tipThrottle = value end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)