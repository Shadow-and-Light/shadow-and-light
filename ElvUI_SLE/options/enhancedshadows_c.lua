local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_NihilistUI"] then return end
local ES = SLE:GetModule("EnhancedShadows")
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames')
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
		set = function(info, value) E.db.sle.shadows[info[#info]] = value; SUF:UpdateUnitFrames(); ES:UpdateShadows(); end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				hidden = true, -- TODO: Hidden until I implement this feature
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			shadowcolor = {
				order = 2,
				type = "color",
				hasAlpha = false,
				name = COLOR,
				disabled = function() return not E.private.sle.module.shadows.enable end,
				get = function(info)
					local t = E.db.sle.shadows[info[#info]]
					local d = P.sle.shadows[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = E.db.sle.shadows[info[#info]]
					t.r, t.g, t.b = r, g, b
					SLE:UpdateMedia()
					ES:UpdateShadows()
					SUF:UpdateUnitFrames()
				end,
			},
			size = {
				order = 3,
				type = 'range',
				name = L["Size"],
				min = 2, max = 10, step = 1,
				disabled = function() return not E.private.sle.module.shadows.enable end,
			},
			general = {
				order = 4,
				type = "group",
				name = L["General"],
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					general = {
						order = 1,
						type = 'group',
						name = L["General"],
						guiInline = true,
						args = {
							minimap = {
								order = 3,
								type = "toggle",
								name = L["Minimap"],
								disabled = function() return not E.private.general.minimap.enable or not E.private.sle.module.shadows.enable end,
							},
						},
					},
					chat = {
						order = 2,
						type = "group",
						name = L["Chat"],
						guiInline = true,
						get = function(info) return E.private.sle.module.shadows.chat[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.chat[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							left = {
								order = 1,
								type = "toggle",
								name = L["Left Chat"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
							right = {
								order = 2,
								type = "toggle",
								name = L["Right Chat"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
						},
					},
					databars = {
						order = 2,
						type = "group",
						name = L["DataBars"],
						guiInline = true,
						get = function(info) return E.private.sle.module.shadows.databars[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.databars[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							honorbar = {
								order = 1,
								type = "toggle",
								name = L["HONOR"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
							expbar = {
								order = 1,
								type = "toggle",
								name = L["XPBAR_LABEL"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
							repbar = {
								order = 1,
								type = "toggle",
								name = L["REPUTATION"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
							azeritebar = {
								order = 1,
								type = "toggle",
								name = L["Azerite Bar"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
						},
					},
					datatexts = {
						order = 2,
						type = "group",
						name = L["DataTexts"],
						guiInline = true,
						get = function(info) return E.private.sle.module.shadows.datatexts[info[#info]] end,
						set = function(info, value) E.private.sle.module.shadows.datatexts[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							leftchat = {
								order = 1,
								type = "toggle",
								name = L["Left Chat"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
							rightchat = {
								order = 2,
								type = "toggle",
								name = L["Right Chat"],
								disabled = function() return not E.private.sle.module.shadows.enable end,
							},
						},
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
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					microbarbuttons = {
						order = 2,
						type = "toggle",
						name = L["SLE_EnhShadows_MicroButtons_Option"],
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					stancebar = {
						order = 3,
						type = "toggle",
						name = L["Stance Bar"],
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					stancebarbuttons = {
						order = 4,
						type = "toggle",
						name = L["SLE_EnhShadows_StanceButtons_Option"],
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					petbar = {
						order = 5,
						type = "toggle",
						name = L["Pet Bar"],
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					petbarbuttons = {
						order = 6,
						type = "toggle",
						name = L["SLE_EnhShadows_PetButtons_Option"],
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.module.shadows.enable end,
					},
					spacer = ACH:Spacer(7),
				},
			},
			unitframes = {
				order = 5,
				type = "group",
				name = L["UnitFrames"],
				get = function(info)
					local unitframe, option = info[#info-1], info[#info]
					if unitframe and option then return E.db.sle.shadows.unitframes[unitframe][option] end
				end,
				set = function(info, value)
					local unitframe, option = info[#info-1], info[#info]
					local ufname = E:StringTitle(unitframe)

					E.db.sle.shadows.unitframes[unitframe][option] = value;
					ufname = ufname:gsub("t(arget)", "T%1")

					SUF['Arrange'..ufname]()
				end,
				args = {
					player = {
						order = 1,
						type = 'group',
						name = PLAYER,
						args = {},
					},
					target = {
						order = 2,
						type = 'group',
						name = TARGET,
						args = {},
					},
					targettarget = {
						order = 3,
						type = 'group',
						name = TARGET..TARGET,
						args = {},
					},
					targettargettarget = {
						order = 4,
						type = 'group',
						name = TARGET..TARGET..TARGET,
						args = {},
					},
					focus = {
						order = 5,
						type = 'group',
						name = FOCUS,
						args = {},
					},
					focustarget = {
						order = 6,
						type = 'group',
						name = FOCUS..TARGET,
						args = {},
					},
					pet = {
						order = 7,
						type = 'group',
						name = PET,
						args = {},
					},
					pettarget = {
						order = 8,
						type = 'group',
						name = PET..TARGET,
						args = {},
					},
					boss = {
						order = 9,
						type = 'group',
						name = BOSS,
						args = {},
					},
					arena = {
						order = 10,
						type = 'group',
						name = ARENA,
						args = {},
					},
					party = {
						order = 11,
						type = 'group',
						name = PARTY,
						args = {},
					},
					raid = {
						order = 12,
						type = 'group',
						name = RAID,
						args = {},
					},
					raid40 = {
						order = 13,
						type = 'group',
						name = RAID..'40',
						args = {},
					},
				},
			},
		},
	}

	--! Need simpy or azil majic on how to sort a bit
	--* Using hard coded above until then
	-- for unit in next, UF.units do
	-- 	E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit] = {
	-- 		order = 1,
	-- 		type = 'group',
	-- 		name = gsub(E:StringTitle(unit), 't(arget)', 'T%1'),
	-- 		args = {},
	-- 	}
	-- end

	for unit in next, E.Options.args.sle.args.modules.args.shadows.args.unitframes.args do
		E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].disabled = function() return not E.private.sle.module.shadows.enable or not E.db.unitframe.units[unit].enable end

		if UF.units[unit] then
			E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.configplayer = {
				order = 0,
				type = 'execute',
				name = gsub('ElvUI: '..E:StringTitle(unit)..' '..L["Frame"], 't(arget)', 'T%1'),
				width = 'full',
				func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "unitframe", "individualUnits", unit, "generalGroup") end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return true end
					return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			}
			if unit == 'player' then
				E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.classbar = {
					order = 4,
					type = 'toggle',
					name = L["Classbar"],
					disabled = function() return not E.db.unitframe.units.player.enable or not E.db.unitframe.units.player.classbar.enable or not E.db.unitframe.units.player.classbar.detachFromFrame end,
				}
			end
		end

		if unit == 'boss' or unit == 'arena' or UF.headers[unit] then
			E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.configplayer = {
				order = 0,
				type = 'execute',
				name = 'ElvUI: '..E:StringTitle(unit)..' '..L["Frame"],
				width = 'full',
				func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "unitframe", "groupUnits", unit, "generalGroup") end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return true end
					return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			}

			-- TODO: Adds a section for a button (to return to S&L enhshadows) or to mirror shadow options (WIP)
			--* The idea is to make options we have more known
			-- E.Options.args.unitframe.args.groupUnits.args[unit].args.generalGroup.args.slshadow = {
			-- 	order = -1,
			-- 	name = 'S&L Shadows',
			-- 	type = 'group',
			-- 	inline = true,
			-- 	args = {
			-- 		configplayer = {
			-- 			order = 0,
			-- 			type = 'execute',
			-- 			name = 'S&L: '..E:StringTitle(unit)..' Shadows',
			-- 			width = 'full',
			-- 			func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle", 'modules', "shadows", "unitframes", unit) end,
			-- 			hidden = function()
			-- 				if not E.private.skins.blizzard.enable then return true end
			-- 				return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
			-- 			end,
			-- 		}
			-- 	}
			-- }
		end
		E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.legacy = {
			order = 1,
			type = 'toggle',
			name = L["Legacy Shadows"],
			desc = L["Tries to place a shadow around the health, power, and classbars as one frame instead of individual frames."],
		}
		E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.health = {
			order = 2,
			type = 'toggle',
			name = L["Health"],
		}
		E.Options.args.sle.args.modules.args.shadows.args.unitframes.args[unit].args.power = {
			order = 3,
			type = 'toggle',
			name = L["Power"],
		}
	end

	for i = 1, 10 do
		E.Options.args.sle.args.modules.args.shadows.args.actionbars.args["bar"..i] = {
			order = i + 7,
			type = "toggle",
			name = L["Bar "]..i,
			disabled = function() return not E.private.actionbar.enable or not E.db.actionbar['bar'..i].enabled or not E.private.sle.module.shadows.enable end,
		}
		E.Options.args.sle.args.modules.args.shadows.args.actionbars.args["bar"..i.."buttons"] = {
			order = i + 7,
			type = "toggle",
			name = format(L["SLE_EnhShadows_BarButtons_Option"], i),
			disabled = function() return not E.private.actionbar.enable or not E.db.actionbar['bar'..i].enabled or not E.private.sle.module.shadows.enable end,
		}
	end
end

tinsert(SLE.Configs, configTable)
