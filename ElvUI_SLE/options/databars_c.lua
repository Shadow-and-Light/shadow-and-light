local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EDB = E:GetModule('DataBars')
local DB = SLE:GetModule("DataBars")
local FACTION, REPUTATION, SCENARIO_BONUS_LABEL = FACTION, REPUTATION, SCENARIO_BONUS_LABEL

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.databars = {
		type = "group",
		name = L["DataBars"],
		childGroups = 'select',
		order = 10,
		args = {
			exp = {
				order = 1,
				type = "group",
				name = XP,
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..XPBAR_LABEL,
						func = function() SLE.ACD:SelectGroup("ElvUI", "databars", "experience") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Exp Bar"],
						desc = L["Changes the way text is shown on exp bar."],
						get = function(info) return E.db.sle.databars.exp.longtext end,
						set = function(info, value) E.db.sle.databars.exp.longtext = value; EDB:UpdateExperience() end,
					},
					chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.exp.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.exp.chatfilter[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the style of experience gain messages."],
								set = function(info, value) E.db.sle.databars.exp.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.exp.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							style = {
								order = 3,
								type = "select",
								name = L["Experience Style"],
								disabled = function() return not E.db.sle.databars.exp.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.Exp.Styles["STYLE1"]["Bonus"], 14, E.myname, 300, 150, SCENARIO_BONUS_LABEL),
									["STYLE2"] = T.format(DB.Exp.Styles["STYLE2"]["Bonus"], 14, E.myname, 300, 150, SCENARIO_BONUS_LABEL),
								},
							},
						},
					},
				},
			},
			rep = {
				order = 2,
				type = "group",
				name = REPUTATION,
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..REPUTATION,
						func = function() SLE.ACD:SelectGroup("ElvUI", "databars", "reputation") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Rep Bar"],
						desc = L["Changes the way text is shown on rep bar."],
						get = function(info) return E.db.sle.databars.rep.longtext end,
						set = function(info, value) E.db.sle.databars.rep.longtext = value; EDB:UpdateReputation() end,
					},
					autotrackrep = {
						order = 3,
						type = "toggle",
						name = L["Auto Track Reputation"],
						desc = L["Automatically sets reputation tracking to the most recent reputation change."],
						get = function(info) return E.db.sle.databars.rep.autotrack end,
						set = function(info, value) E.db.sle.databars.rep.autotrack = value; end,
					},
					chatfilters = {
						order = 4,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.rep.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.rep.chatfilter[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the style of reputation messages."],
								set = function(info, value) E.db.sle.databars.rep.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.rep.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							style = {
								order = 3,
								type = "select",
								name = L["Reputation increase Style"],
								disabled = function() return not E.db.sle.databars.rep.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.RepIncreaseStyles["STYLE1"], 14, FACTION, 300),
									["STYLE2"] = T.format(DB.RepIncreaseStyles["STYLE2"], 14, FACTION, 300),
								},
							},
							styleDec = {
								order = 4,
								type = "select",
								name = L["Reputation decrease Style"],
								disabled = function() return not E.db.sle.databars.rep.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.RepDecreaseStyles["STYLE1"], 14, FACTION, 300),
									["STYLE2"] = T.format(DB.RepDecreaseStyles["STYLE2"], 14, FACTION, 300),
								},
							},
							showAll = {
								order = 5,
								type = "toggle",
								name = L["Full List"],
								desc = L["Show all factions affected by the latest reputation change. When disabled only first (in alphabetical order) affected faction will be shown."],
								disabled = function() return not E.db.sle.databars.rep.chatfilter.enable end,
							},
							chatframe = {
								order = 6,
								type = "select",
								name = L["Output"],
								desc = L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."],
								disabled = function() return not E.db.sle.databars.rep.chatfilter.enable end,
								values = {
									["AUTO"] = L["Auto"],
									["ChatFrame1"] = L["Frame 1"],
									["ChatFrame2"] = L["Frame 2"],
									["ChatFrame3"] = L["Frame 3"],
									["ChatFrame4"] = L["Frame 4"],
									["ChatFrame5"] = L["Frame 5"],
									["ChatFrame6"] = L["Frame 6"],
									["ChatFrame7"] = L["Frame 7"],
									["ChatFrame8"] = L["Frame 8"],
									["ChatFrame9"] = L["Frame 9"],
									["ChatFrame10"] = L["Frame 10"],
								},
							},
						},
					},
				},
			},
			artifact = {
				order = 3,
				type = "group",
				name = L["Artifact Bar"],
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..L["Artifact Bar"],
						func = function() SLE.ACD:SelectGroup("ElvUI", "databars", "artifact") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Artifact Bar"],
						desc = L["Changes the way text is shown on artifact bar."],
						get = function(info) return E.db.sle.databars.artifact.longtext end,
						set = function(info, value) E.db.sle.databars.artifact.longtext = value; EDB:UpdateArtifact() end,
					},
					chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.artifact.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.artifact.chatfilter[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the style of experience gain messages."],
								set = function(info, value) E.db.sle.databars.artifact.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.artifact.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							style = {
								order = 3,
								type = "select",
								name = L["Style"],
								disabled = function() return not E.db.sle.databars.artifact.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.Art.Styles["STYLE1"], [[Interface\AddOns\ElvUI_SLE\media\textures\Skull_Event]],14, NAME, 300),
									["STYLE2"] = T.format(DB.Art.Styles["STYLE2"], [[Interface\AddOns\ElvUI_SLE\media\textures\Skull_Event]],14, NAME, 300),
								},
							},
						},
					},
				},
			},
			honor = {
				order = 4,
				type = "group",
				name = HONOR,
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..HONOR,
						func = function() SLE.ACD:SelectGroup("ElvUI", "databars", "honor") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Honor Bar"],
						desc = L["Changes the way text is shown on honor bar."],
						get = function(info) return E.db.sle.databars.honor.longtext end,
						set = function(info, value) E.db.sle.databars.honor.longtext = value; EDB:UpdateUpdateHonor() end,
					},
					chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.honor.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.honor.chatfilter[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the style of honor gain messages."],
								set = function(info, value) E.db.sle.databars.honor.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							spacer = {order = 3, type = "description", name = ""},
							style = {
								order = 4,
								type = "select",
								name = L["Honor Style"],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.Honor.Styles["STYLE1"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE2"] = T.format(DB.Honor.Styles["STYLE2"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE3"] = T.format(DB.Honor.Styles["STYLE3"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE4"] = T.format(DB.Honor.Styles["STYLE4"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE5"] = T.format(DB.Honor.Styles["STYLE5"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE6"] = T.format(DB.Honor.Styles["STYLE6"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE7"] = T.format(DB.Honor.Styles["STYLE7"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE8"] = T.format(DB.Honor.Styles["STYLE8"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE9"] = T.format(DB.Honor.Styles["STYLE9"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
								},
							},
							awardStyle = {
								order = 5,
								type = "select",
								name = L["Award Style"],
								desc = L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								values = {
									["STYLE1"] = T.format(DB.Honor.AwardStyles["STYLE1"], "3.45", DB.Honor.Icon, 12),
									["STYLE2"] = T.format(DB.Honor.AwardStyles["STYLE2"], "3.45", DB.Honor.Icon, 12),
									["STYLE3"] = T.format(DB.Honor.AwardStyles["STYLE3"], "3.45", DB.Honor.Icon, 12),
									["STYLE4"] = T.format(DB.Honor.AwardStyles["STYLE4"], "3.45", DB.Honor.Icon, 12),
									["STYLE5"] = T.format(DB.Honor.AwardStyles["STYLE5"], "3.45", DB.Honor.Icon, 12),
									["STYLE6"] = T.format(DB.Honor.AwardStyles["STYLE6"], "3.45", DB.Honor.Icon, 12),
								},
							},
						},
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)