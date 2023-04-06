local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local EDB = E.DataBars
local DB = SLE.DataBars

--GLOBALS: unpack, select, format, tinsert, XP, XPBAR_LABEL, RANK, HONOR, FACTION, REPUTATION, SCENARIO_BONUS_LABEL
local format, tinsert = format, tinsert
local XP, XPBAR_LABEL, RANK, HONOR, FACTION, REPUTATION, SCENARIO_BONUS_LABEL = XP, XPBAR_LABEL, RANK, HONOR, FACTION, REPUTATION, SCENARIO_BONUS_LABEL

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.databars = {
		type = "group",
		name = L["DataBars"],
		childGroups = 'tab',
		order = 1,
		args = {
			exp = {
				order = 1,
				type = "group",
				name = L["Experience"],
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..XPBAR_LABEL,
						func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "databars", "experience") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Exp Bar"],
						get = function() return E.db.sle.databars.experience.longtext end,
						set = function(_, value) E.db.sle.databars.experience.longtext = value; EDB:ExperienceBar_Update() end,
					},
					chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.experience.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.experience.chatfilter[ info[#info] ] = value end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the message style."],
								set = function(info, value) E.db.sle.databars.experience.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.experience.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							style = {
								order = 3,
								type = "select",
								name = L["Experience Style"],
								disabled = function() return not E.db.sle.databars.experience.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.Exp.Styles["STYLE1"]["Bonus"], 11, E.myname, 300, 150, SCENARIO_BONUS_LABEL),
									["STYLE2"] = format(DB.Exp.Styles["STYLE2"]["Bonus"], 11, E.myname, 300, 150, SCENARIO_BONUS_LABEL),
								},
							},
						},
					},
				},
			},
			rep = {
				order = 1,
				type = "group",
				name = L["Reputation"],
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..L["Reputation"],
						func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "databars", "reputation") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Rep Bar"],
						get = function() return E.db.sle.databars.reputation.longtext end,
						set = function(_, value) E.db.sle.databars.reputation.longtext = value; EDB:ReputationBar_Update() end,
					},
					chatfilters = {
						order = 5,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.reputation.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.reputation.chatfilter[ info[#info] ] = value end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the message style."],
								set = function(info, value) E.db.sle.databars.reputation.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.reputation.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							increase = {
								order = 3,
								type = "select",
								name = L["Reputation increase Style"],
								disabled = function() return not E.db.sle.databars.reputation.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.RepIncreaseStyles["STYLE1"], 12, FACTION, 300),
									["STYLE2"] = format(DB.RepIncreaseStyles["STYLE2"], 12, FACTION, 300),
								},
								get = function(info) return E.db.sle.databars.reputation.chatfilter.style[ info[#info] ] end,
								set = function(info, value) E.db.sle.databars.reputation.chatfilter.style[ info[#info] ] = value end,
							},
							decrease = {
								order = 4,
								type = "select",
								name = L["Reputation decrease Style"],
								disabled = function() return not E.db.sle.databars.reputation.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.RepDecreaseStyles["STYLE1"], 12, FACTION, 300),
									["STYLE2"] = format(DB.RepDecreaseStyles["STYLE2"], 12, FACTION, 300),
								},
								get = function(info) return E.db.sle.databars.reputation.chatfilter.style[ info[#info] ] end,
								set = function(info, value) E.db.sle.databars.reputation.chatfilter.style[ info[#info] ] = value end,
							},
							chatframe = {
								order = 6,
								type = "select",
								name = L["Output"],
								desc = L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."],
								disabled = function() return not E.db.sle.databars.reputation.chatfilter.enable end,
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
			honor = {
				order = 1,
				type = "group",
				name = HONOR,
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..HONOR,
						func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "databars", "honor") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Honor Bar"],
						get = function() return E.db.sle.databars.honor.longtext end,
						set = function(_, value) E.db.sle.databars.honor.longtext = value; EDB:HonorBar_Update() end,
					},
					chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.honor.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.honor.chatfilter[ info[#info] ] = value end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Change the message style."],
								set = function(info, value) E.db.sle.databars.honor.chatfilter[ info[#info] ] = value; DB:RegisterFilters() end,
							},
							iconsize = {
								order = 2,
								type = "range",
								name = L["Icon Size"],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								min = 8, max = 32, step = 1,
							},
							spacer = ACH:Spacer(3),
							style = {
								order = 4,
								type = "select",
								name = L["Honor Style"],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.Honor.Styles["STYLE1"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE2"] = format(DB.Honor.Styles["STYLE2"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE3"] = format(DB.Honor.Styles["STYLE3"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE4"] = format(DB.Honor.Styles["STYLE4"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE5"] = format(DB.Honor.Styles["STYLE5"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE6"] = format(DB.Honor.Styles["STYLE6"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE7"] = format(DB.Honor.Styles["STYLE7"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE8"] = format(DB.Honor.Styles["STYLE8"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
									["STYLE9"] = format(DB.Honor.Styles["STYLE9"], E.myname, RANK, "3.45", DB.Honor.Icon, 16),
								},
							},
							awardStyle = {
								order = 5,
								type = "select",
								name = L["Award Style"],
								desc = L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.Honor.AwardStyles["STYLE1"], "3.45", DB.Honor.Icon, 16),
									["STYLE2"] = format(DB.Honor.AwardStyles["STYLE2"], "3.45", DB.Honor.Icon, 16),
									["STYLE3"] = format(DB.Honor.AwardStyles["STYLE3"], "3.45", DB.Honor.Icon, 16),
									["STYLE4"] = format(DB.Honor.AwardStyles["STYLE4"], "3.45", DB.Honor.Icon, 16),
									["STYLE5"] = format(DB.Honor.AwardStyles["STYLE5"], "3.45", DB.Honor.Icon, 16),
									["STYLE6"] = format(DB.Honor.AwardStyles["STYLE6"], "3.45", DB.Honor.Icon, 16),
								},
							},
						},
					},
				},
			},
			azerite = {
				order = 1,
				type = "group",
				name = L["Azerite"],
				args = {
					goElv = {
						order = 1,
						type = 'execute',
						name = "ElvUI: "..L["Azerite Bar"],
						func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "databars", "azerite") end,
					},
					longtext = {
						order = 2,
						type = "toggle",
						name = L["Full value on Azerite Bar"],
						get = function() return E.db.sle.databars.azerite.longtext end,
						set = function(_, value) E.db.sle.databars.azerite.longtext = value; EDB:AzeriteBar_Update() end,
					},
					--[[chatfilters = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Chat Filters"],
						get = function(info) return E.db.sle.databars.honor.chatfilter[ info[#info] ] end,
						set = function(info, value) E.db.sle.databars.honor.chatfilter[ info[#info] ] = value end,
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
									["STYLE1"] = format(DB.Honor.Styles["STYLE1"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE2"] = format(DB.Honor.Styles["STYLE2"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE3"] = format(DB.Honor.Styles["STYLE3"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE4"] = format(DB.Honor.Styles["STYLE4"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE5"] = format(DB.Honor.Styles["STYLE5"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE6"] = format(DB.Honor.Styles["STYLE6"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE7"] = format(DB.Honor.Styles["STYLE7"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE8"] = format(DB.Honor.Styles["STYLE8"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
									["STYLE9"] = format(DB.Honor.Styles["STYLE9"], E.myname, RANK, "3.45", DB.Honor.Icon, 12),
								},
							},
							awardStyle = {
								order = 5,
								type = "select",
								name = L["Award Style"],
								desc = L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."],
								disabled = function() return not E.db.sle.databars.honor.chatfilter.enable end,
								values = {
									["STYLE1"] = format(DB.Honor.AwardStyles["STYLE1"], "3.45", DB.Honor.Icon, 12),
									["STYLE2"] = format(DB.Honor.AwardStyles["STYLE2"], "3.45", DB.Honor.Icon, 12),
									["STYLE3"] = format(DB.Honor.AwardStyles["STYLE3"], "3.45", DB.Honor.Icon, 12),
									["STYLE4"] = format(DB.Honor.AwardStyles["STYLE4"], "3.45", DB.Honor.Icon, 12),
									["STYLE5"] = format(DB.Honor.AwardStyles["STYLE5"], "3.45", DB.Honor.Icon, 12),
									["STYLE6"] = format(DB.Honor.AwardStyles["STYLE6"], "3.45", DB.Honor.Icon, 12),
								},
							},
						},
					},]]
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
