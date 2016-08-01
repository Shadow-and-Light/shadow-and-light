local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_KitUI"] then return end
local ES = SLE:GetModule("EnhancedShadows")

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.shadows = {
		order = 5,
		type = "group",
		name = L["Enhanced Shadows"],
		get = function(info) return E.db.sle.shadows[info[#info]] end,
		set = function(info, value) E.db.sle.shadows[info[#info]] = value ES:UpdateShadows() end,
		args = {
			shadowcolor = {
				type = "color",
				order = 1,
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local t = E.db.sle.shadows[info[#info]]
					return t.r, t.g, t.b, t.a
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
				order = 2,
				type = 'range',
				name = L["Size"],
				min = 2, max = 10, step = 1,
			},
			frames = {
				order = 4,
				type = "group",
				name = L["Use shadows on..."],
				guiInline = true,
				get = function(info) return E.private.sle.module.shadows[info[#info]] end,
				set = function(info, value) E.private.sle.module.shadows[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					vehicle = {
						order = 1,
						type = "toggle",
						name = L["Enhanced Vehicle Bar"],
					},
					unitframes = {
						order = 2,
						type = "group",
						name = L["UnitFrames"],
						args = {
							player = {
								order = 1,
								type = "toggle",
								name = L["Player Frame"],
							},
							target = {
								order = 1,
								type = "toggle",
								name = L["Target Frame"],
							},
							targettarget = {
								order = 1,
								type = "toggle",
								name = L["TargetTarget Frame"],
							},
							focus = {
								order = 1,
								type = "toggle",
								name = L["Focus Frame"],
							},
							focustarget = {
								order = 1,
								type = "toggle",
								name = L["FocusTarget Frame"],
							},
							pet = {
								order = 1,
								type = "toggle",
								name = L["Pet Frame"],
							},
							pettarget = {
								order = 1,
								type = "toggle",
								name = L["PetTarget Frame"],
							},
							boss = {
								order = 1,
								type = "toggle",
								name = L["Boss Frames"],
							},
							arena = {
								order = 1,
								type = "toggle",
								name = L["Arena Frames"],
							},
						},
					},
					actionbars = {
						order = 10,
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
							stancebar = {
								order = 2,
								type = "toggle",
								name = L["Stance Bar"],
							},
							petbar = {
								order = 3,
								type = "toggle",
								name = L["Pet Bar"],
							},
						},
					},
				},
			},
		},
	}
	
	for i = 1, (SLE._Compatibility["ElvUI_ExtraActionBars"] and 10 or 6) do
		E.Options.args.sle.args.modules.args.shadows.args.frames.args.actionbars.args["bar"..i] = {
			order = i + 3,
			type = "toggle",
			name = L["Bar "]..i,
		}
	end
end

T.tinsert(SLE.Configs, configTable)