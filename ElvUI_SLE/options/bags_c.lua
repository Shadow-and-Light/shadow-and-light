local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local ARTIFACT_POWER = ARTIFACT_POWER
local AP = SLE:GetModule("ArtifactPowerBags")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.bags = {
		order = 6,
		type = "group",
		name = L["Bags"],
		disabled = function() return not E.private.bags.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Bags"],
			},
			transparentSlots = {
				order = 2,
				type = "toggle",
				name = L["Transparent Slots"],
				desc = L["Apply transparent template on bag and bank slots."],
				get = function(info) return E.private.sle.bags.transparentSlots end,
				set = function(info, value)	E.private.sle.bags.transparentSlots = value; E:StaticPopup_Show('PRIVATE_RL') end,
			},
			lootflash = {
				order = 5,
				type = "toggle",
				name = L["New Item Flash"],
				desc = L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"],
				get = function(info) return E.db.sle.bags.lootflash end,
				set = function(info, value)	E.db.sle.bags.lootflash = value end,
			},
			artefact = {
				order = 20,
				type = "group",
				guiInline = true,
				name = ARTIFACT_POWER,
				get = function(info) return E.db.sle.bags.artifactPower[ info[#info] ] end,
				set = function(info, value) E.db.sle.bags.artifactPower[ info[#info] ] = value; AP:bagUpdate() end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local t = E.db.sle.bags.artifactPower[info[#info]]
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b)
							E.db.sle.bags.artifactPower[info[#info]] = {}
							local t = E.db.sle.bags.artifactPower[info[#info]]
							t.r, t.g, t.b = r, g, b
							AP:bagUpdate()
						end,
					},
					short = {
						order = 3,
						type = "toggle",
						name = L["Short text"],
					},
					fonts = {
						order = 5,
						type = "group",
						guiInline = true,
						name = L["Fonts"],
						get = function(info) return E.db.sle.bags.artifactPower.fonts[ info[#info] ] end,
						set = function(info, value) E.db.sle.bags.artifactPower.fonts[ info[#info] ] = value; AP:bagUpdate() end,
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
								min = 6, max = 48, step = 1,
							},
							outline = {
								order = 3,
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = 'OUTLINE',
									
									["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
									["THICKOUTLINE"] = 'THICKOUTLINE',
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