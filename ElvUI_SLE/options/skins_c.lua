local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Sk = SLE.Skins
local B = SLE.Blizzard

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.skins = {
		order = 30,
		type = 'group',
		name = L["Skins"],
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["Skins"], 1),
			desc = ACH:Description(L["SLE_SKINS_DESC"], 2),
			GoToSkins = {
				order = 2,
				type = 'execute',
				name = L["ElvUI Skins"],
				func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'skins') end,
			},
			merchant = {
				order = 20,
				type = 'group',
				name = L["Merchant Frame"],
				get = function(info) return E.private.sle.skins.merchant[info[#info]] end,
				set = function(info, value) E.private.sle.skins.merchant[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
					},
					subpages = {
						order = 2,
						type = 'range',
						name = L["Subpages"],
						desc = L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."],
						min = 2, max = 5, step = 1,
						disabled = function() return not E.private.sle.skins.merchant.enable or E.private.sle.skins.merchant.style ~= 'Default' end,
					},
					style = {
						order = 3,
						type = 'select',
						name = L["Style"],
						values = {
							["Default"] = DEFAULT,
							["List"] = L["As List"],
						},
					},
					listFonts = {
						order = 4,
						type = 'group',
						name = L["List Style Fonts"],
						guiInline = true,
						disabled = function() return E.private.sle.skins.merchant.style ~= 'List' end,
						get = function(info) return E.db.sle.skins.merchant.list[info[#info]] end,
						set = function(info, value) E.db.sle.skins.merchant.list[info[#info]] = value; Sk:Media() end,
						args = {
							nameFont = {
								order = 1,
								type = 'select',
								name = L["Item Name Font"],
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
							},
							nameSize = {
								order = 2,
								type = 'range',
								name = L["Item Name Size"],
								min = 8, max = 32, step = 1,
							},
							nameOutline = ACH:FontFlags(L["Item Name Outline"], L["Set the font outline."], 3),
							subFont = {
								order = 4,
								type = 'select',
								name = L["Item Info Font"],
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
							},
							subSize = {
								order = 5,
								type = 'range',
								name = L["Item Info Size"],
								min = 8, max = 32, step = 1,
							},
							subOutline = ACH:FontFlags(L["Item Info Outline"], L["Set the font outline."], 6),
						}
					},
				},
			},
			petbattles = {
				order = 30,
				type = 'group',
				name = L["Pet Battles skinning"],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Make some elements of pet battles movable via toggle anchors."],
						get = function(info) return E.private.sle.skins.petbattles[info[#info]] end,
						set = function(info, value) E.private.sle.skins.petbattles[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
				},
			},
			blizzardframes = {
				order = 40,
				type = 'group',
				name = 'Blizzard',
				args = {
					talkinghead = {
						order = 1,
						type = 'group',
						name = L["Talking Head"],
						args = {
							hide = {
								order = 1,
								type = 'toggle',
								name = HIDE,
								desc = L["Hide the talking head frame at the top center of the screen."],
								get = function(info) return E.db.sle.skins.talkinghead[info[#info]] end,
								set = function(info, value) E.db.sle.skins.talkinghead[info[#info]] = value end,
							},
						},
					},
				},
			},
		},
	}

	if C_AddOns_IsAddOnLoaded('QuestGuru') then
		E.Options.args.sle.args.skins.args.QuestGuru = {
			order = 12,
			type = 'group',
			name = 'QuestGuru',
			get = function(info) return E.private.sle.skins.questguru[info[#info]] end,
			set = function(info, value) E.private.sle.skins.questguru[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
				},
				removeParchment = {
					order = 1,
					type = 'toggle',
					name = L["Remove Parchment"],
				},
			},
		}
	end
end

tinsert(SLE.Configs, configTable)
