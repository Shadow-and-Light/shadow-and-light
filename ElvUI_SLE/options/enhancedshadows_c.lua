local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_NihilistUI"] then return end
local ES = SLE:GetModule("EnhancedShadows")

local format = format

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.shadows = {
		order = 1,
		type = "group",
		name = L["Enhanced Shadows"],
		childGroups = "tab",
		get = function(info) return E.db.sle.shadows[info[#info]] end,
		set = function(info, value) E.db.sle.shadows[info[#info]] = value ES:UpdateShadows() end,
		args = {
			shadowcolor = {
				type = "color",
				order = 1,
				name = COLOR,
				get = function(info)
					local t = E.db.sle.shadows[info[#info]]
					local d = P.sle.shadows[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					E.db.sle.shadows[info[#info]] = {}
					local t = E.db.sle.shadows[info[#info]]
					t.r, t.g, t.b = r, g, b
					ES:UpdateShadows()
				end,
			},
			classcolor = {
				type = 'toggle',
				order = 2,
				name = L["Use Class Color"],
			},
			size = {
				order = 3,
				type = 'range',
				name = L["Size"],
				min = 2, max = 10, step = 1,
			},
			general = {
				order = 4,
				type = "group",
				name = L["General"],
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					vehicle = {
						order = 1,
						type = "toggle",
						name = L["Enhanced Vehicle Bar"],
						-- desc = "Testing inline desc here.",
						descStyle = "inline",
					},
					spacer = ACH:Spacer(2),
					minimap = {
						order = 3,
						type = "toggle",
						name = L["Minimap"],
					},
				},
			},
			actionbars = {
				order = 5,
				type = "group",
				name = L["ActionBars"],
				get = function(info) return E.private.sle.module.shadows.actionbars[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows.actionbars[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					microbar = {
						order = 1,
						type = "toggle",
						name = L["Micro Bar"],
					},
					microbarbuttons = {
						order = 2,
						type = "toggle",
						name = L["SLE_EnhShadows_MicroButtons_Option"],
					},
					stancebar = {
						order = 3,
						type = "toggle",
						name = L["Stance Bar"],
					},
					stancebarbuttons = {
						order = 4,
						type = "toggle",
						name = L["SLE_EnhShadows_StanceButtons_Option"],
					},
					petbar = {
						order = 5,
						type = "toggle",
						name = L["Pet Bar"],
					},
					petbarbuttons = {
						order = 6,
						type = "toggle",
						name = L["SLE_EnhShadows_PetButtons_Option"],
					},
					spacer = ACH:Spacer(7),
				},
			},
			chat = {
				order = 5,
				type = "group",
				name = L["Chat"],
				get = function(info) return E.private.sle.module.shadows.chat[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows.chat[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					left = {
						order = 1,
						type = "toggle",
						name = L["Left Chat"],
					},
					right = {
						order = 2,
						type = "toggle",
						name = L["Right Chat"],
					},
				},
			},
			datatexts = {
				order = 5,
				type = "group",
				name = L["DataTexts"],
				get = function(info) return E.private.sle.module.shadows.datatexts[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows.datatexts[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					leftchat = {
						order = 1,
						type = "toggle",
						name = L["Left Chat"],
					},
					rightchat = {
						order = 2,
						type = "toggle",
						name = L["Right Chat"],
					},
				},
			},
			databars = {
				order = 5,
				type = "group",
				name = L["DataBars"],
				get = function(info) return E.private.sle.module.shadows.databars[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows.databars[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					honorbar = {
						order = 1,
						type = "toggle",
						name = L["HONOR"],
					},
					expbar = {
						order = 1,
						type = "toggle",
						name = L["XPBAR_LABEL"],
					},
					repbar = {
						order = 1,
						type = "toggle",
						name = L["REPUTATION"],
					},
					azeritebar = {
						order = 1,
						type = "toggle",
						name = L["Azerite Bar"],
					},
				},
			},
			unitframes = {
				order = 5,
				type = "group",
				name = L["UnitFrames"],
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					player = {
						order = 1,
						type = "toggle",
						name = L["Player Frame"],
					},
					playerLegacy = {
						order = 2,
						type = "toggle",
						name = L["Player Frame Classic"],
					},
					spacer1 = ACH:Description("", 3, nil, "full"),
					target = {
						order = 4,
						type = "toggle",
						name = L["Target Frame"],
					},
					targetLegacy = {
						order = 5,
						type = "toggle",
						name = L["Target Frame Classic"],
					},
					spacer2 = ACH:Spacer(6),
					targettarget = {
						order = 10,
						type = "toggle",
						name = L["TargetTarget Frame"],
					},
					targettargetLegacy = {
						order = 11,
						type = "toggle",
						name = L["TargetTarget Frame Classic"],
					},
					focus = {
						order = 15,
						type = "toggle",
						name = L["Focus Frame"],
					},
					focusLegacy = {
						order = 16,
						type = "toggle",
						name = L["Focus Frame Classic"],
					},
					focustarget = {
						order = 20,
						type = "toggle",
						name = L["FocusTarget Frame"],
					},
					focustargetLegacy = {
						order = 21,
						type = "toggle",
						name = L["FocusTarget Frame Classic"],
					},
					party = {
						order = 22,
						type = "toggle",
						name = L["Party Frame"],
					},
					partyLegacy = {
						order = 23,
						type = "toggle",
						name = L["Party Frame Classic"],
					},
					raid = {
						order = 24,
						type = "toggle",
						name = L["Raid Frame"],
					},
					raidLegacy = {
						order = 25,
						type = "toggle",
						name = L["Raid Frame Classic"],
					},
					raid40 = {
						order = 26,
						type = "toggle",
						name = L["Raid40 Frame"],
					},
					raid40Legacy = {
						order = 27,
						type = "toggle",
						name = L["Raid40 Frame Classic"],
					},
					pet = {
						order = 28,
						type = "toggle",
						name = L["Pet Frame"],
					},
					petLegacy = {
						order = 29,
						type = "toggle",
						name = L["Pet Frame Classic"],
					},
					pettarget = {
						order = 30,
						type = "toggle",
						name = L["PetTarget Frame"],
					},
					pettargetLegacy = {
						order = 31,
						type = "toggle",
						name = L["PetTarget Frame Classic"],
					},
					boss = {
						order = 35,
						type = "toggle",
						name = L["Boss Frames"],
					},
					bossLegacy = {
						order = 36,
						type = "toggle",
						name = L["Boss Frames Classic"],
					},
					arena = {
						order = 40,
						type = "toggle",
						name = L["Arena Frames"],
					},
					arenaLegacy = {
						order = 41,
						type = "toggle",
						name = L["Arena Frames Classic"],
					},
				},
			},
			-- frames = {
			-- 	order = 4,
			-- 	type = "group",
			-- 	name = L["Shadows"],
			-- 	get = function(info) return E.private.sle.module.shadows[info[#info]] end,
			-- 	set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			-- 	args = {


			-- 	},
		},
	}

	for i = 1, 10 do
		E.Options.args.sle.args.modules.args.shadows.args.actionbars.args["bar"..i] = {
			order = i + 7,
			type = "toggle",
			name = L["Bar "]..i,
		}
		E.Options.args.sle.args.modules.args.shadows.args.actionbars.args["bar"..i.."buttons"] = {
			order = i + 7,
			type = "toggle",
			name = format(L["SLE_EnhShadows_BarButtons_Option"], i),
		}
	end
end

tinsert(SLE.Configs, configTable)
