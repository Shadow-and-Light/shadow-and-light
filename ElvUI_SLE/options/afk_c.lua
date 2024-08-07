local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local S = SLE.Screensaver
local D = E:GetModule('Distributor')

--* Export Custom Graphic Settings
if D.GeneratedKeys.profile.sle == nil then D.GeneratedKeys.profile.sle = {} end
if D.GeneratedKeys.profile.sle.afk == nil then D.GeneratedKeys.profile.sle.afk = {} end
D.GeneratedKeys.profile.sle.afk.customGraphics = true

local NAME, PLAYER, GUILD, RANK = NAME, PLAYER, GUILD, RANK
local NONE, RACE, CLASS, DELETE = NONE, RACE, CLASS, DELETE

local pairs, ceil, strtrim = pairs, ceil, strtrim
local format, floor, tinsert = format, floor, tinsert
local DEFAULT, GetScreenWidth, GetScreenHeight = DEFAULT, GetScreenWidth, GetScreenHeight

-- GLOBALS: AceGUIWidgetLSMlists

local ACH, selectedGraphic
local newGraphicInfo = {}

local function ColorizeName(name, color)
	return format('|cFF%s%s|r', color or 'ffd100', name)
end

local function defaultTextsValues(group)
	local values = {
		SL_TopPanel = 'Top Panel',
		SL_BottomPanel = 'Bottom Panel',
		SL_AFKMessage = 'AFK Message',
		SL_AFKTimePassed = 'AFK Message (Timer)',
		SL_SubText = 'SubText',
		-- SL_PlayerTitle = 'Title',
		SL_PlayerName = 'Name',
		-- SL_PlayerServer = 'Player Server',
		SL_PlayerClass = 'Player Class',
		SL_PlayerLevel = 'Player Level',
		SL_GuildName = 'Guild Name',
		SL_GuildRank = 'Guild Rank',
		SL_Date = 'Date',
		SL_Time = 'Time',
		SL_ScrollFrame = 'Scroll Frame',
	}

	if group and values[group] then
		values[group] = nil
	end

	return values
end

local function CreateDefaultTextsFont(i, title, group, inline)
	local config = {
		order = i,
		name = title,
		type = 'group',
		guiInline = inline,
		get = function(info) return E.db.sle.afk.defaultTexts[group][info[#info]] end,
		set = function(info, value) E.db.sle.afk.defaultTexts[group][info[#info]] = value; S:UpdateTextOptions() end,
		args = {
			enable = {
				order = 1,
				name = L["Display"],
				type = 'toggle',
			},
			font = {
				order = 3,
				name = L["Font"],
				type = 'select',
				dialogControl = 'LSM30_Font',
				values = AceGUIWidgetLSMlists.font,
			},
			outline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 4),
			size = {
				order = 5,
				name = L["Font Size"],
				type = 'range',
				min = 8, max = 32, step = 1,
			},
			inversePoint = {
				order = 6,
				name = L["Inverse Anchor Points"],
				type = 'toggle',
			},
			anchorPoint = {
				order = 7,
				name = L["Anchor Point"],
				type = 'select',
				values = T.Values.AllPoints,
			},
			attachTo = {
				order = 8,
				name = L["Attach To"],
				type = 'select',
				sortByValue = true,
				values = {},
			},
			xOffset = {
				order = 9,
				name = L["X-Offset"],
				type = 'range',
				min = -(floor(GetScreenWidth()/2)), max = floor(GetScreenWidth()/2), step = 1,
			},
			yOffset = {
				order = 10,
				name = L["Y-Offset"],
				type = 'range',
				min = -(floor(GetScreenHeight()/2)), max = floor(GetScreenHeight()/2), step = 1,
			},
		},
	}

	if group == 'SL_Time' then
		config.args.hour24 = {
			order = 2,
			name = L["24-Hour Time"],
			type = 'toggle',
		}
	elseif group == 'SL_AFKTimePassed' then
		config.args.countdown = {
			order = 2,
			name = L["Countdown AFK Timer"],
			type = 'toggle',
			desc = L["The AFK timer will count down from 30 mins instead of showing total time you were afk."],
		}
	end

	if group == 'SL_ScrollFrame' then
		config.args.attachTo.values = {SL_TopPanel = 'Top Panel', SL_BottomPanel = 'Bottom Panel'}
	else
		config.args.attachTo.values = defaultTextsValues(group)
	end

	return config
end

local function sharedOptions(group)
	local options = {
		enable = {
			order = 1,
			name = L["Enable"],
			type = 'toggle',
			width = 'full',
		},
		spacer1 = ACH:Spacer(5, 'full'),
		width = {
			order = 6,
			name = L["Width"],
			type = 'range',
			min = 8, max = 512, step = 1,
		},
		height = {
			order = 7,
			name = L["Height"],
			type = 'range',
			min = 8, max = 512, step = 1,
		},
		spacer2 = ACH:Spacer(8, 'full'),
		spacer3 = ACH:Spacer(14, 'full'),
		inversePoint = {
			order = 15,
			name = L["Inverse Anchor Points"],
			type = 'toggle',
		},
		anchorPoint = {
			order = 16,
			name = L["Anchor Point"],
			type = 'select',
			values = T.Values.AllPoints,
		},
		attachTo = {
			order = 17,
			name = L["Attach To"],
			type = 'select',
			values = {
				SL_TopPanel = 'Top Panel',
				SL_BottomPanel = 'Bottom Panel',
			},
		},
		spacer4 = ACH:Spacer(18, 'full'),
		xOffset = {
			order = 19,
			name = L["X-Offset"],
			type = 'range',
			min = -(floor(GetScreenWidth()/2)), max = floor(GetScreenWidth()/2), step = 1,
		},
		yOffset = {
			order = 20,
			name = L["Y-Offset"],
			type = 'range',
			min = -(floor(GetScreenWidth()/2)), max = floor(GetScreenWidth()/2), step = 1,
		},
	}

	if group == 'customGraphics' then
		options.path = {
			order = 2,
			name = L["File Path"],
			type = 'input',
			desc = '',
			width = 'full',
		}
		options.drawLayer = {
			order = 5,
			name = L["Draw Layer"],
			type = 'select',
			values = {
				ARTWORK = 'ARTWORK',
				BACKGROUND = 'BACKGROUND',
				OVERLAY = 'OVERLAY',
			},
		}
		options.drawLevel = ACH:Range(L["Draw Level"], nil, 6, {min = 1, max = 7, step = 1})
		options.alpha = {
			order = 7,
			name = L["Alpha"],
			type = 'range',
			isPercent = true,
			min = 0, max = 1, step = 0.01,
		}
		options.delete = {
			order = 99,
			name = DELETE,
			type = 'execute',
			desc = '',
			width = 'full',
			func = function()
				S:DeleteCustomGraphic(selectedGraphic)
				selectedGraphic = ''
			end,
		}
	end

	return options
end

local styles = {}
local function GetExPackStyles()
	wipe(styles)
	styles['blizzard'] = 'Blizzard'

	if E.db.sle.afk.defaultGraphics.exPack.expansion == 'sl' then
		styles['releaf-flat'] = 'Releaf-Flat'
		styles['sltheme'] = E:TextGradient('S&L', 0.33725490196078,0.7921568627451,0.12941176470588, 1,1,1, 0.81176470588235,0.98039215686275,0.011764705882353)..' Theme'
	end

	return styles
end

local function defaultGraphicsOptions(element, group, name, order)
	local options = {
		order = order,
		name = name,
		type = 'group',
		guiInline = group == 'addonLogos' and true or false,
		get = function(info) return E.db.sle.afk.defaultGraphics[element][info[#info]] end,
		set = function(info, value) E.db.sle.afk.defaultGraphics[element][info[#info]] = value S:UpdateDefaultGraphics() end,
		args = sharedOptions(),
	}
	if element ~= 'slLogo' then
		options.args.styleOptions = {
			order = 3,
			name = L["Style Options"],
			type = 'select',
			values = {},
		}
	end

	if element == 'benikuiLogo' or element == 'merauiLogo' then
		options.args.styleOptions.values = {
			['original'] = 'Original',
			['releaf-flat'] = 'Releaf-Flat',
			['sltheme'] = E:TextGradient('S&L', 0.33725490196078,0.7921568627451,0.12941176470588, 1,1,1, 0.81176470588235,0.98039215686275,0.011764705882353)..' Theme',
		}
	elseif element == 'elvuiLogo' then
		options.args.styleOptions.values = {
			['releaf-flat'] = 'Releaf-Flat',
			['sltheme'] = E:TextGradient('S&L', 0.33725490196078,0.7921568627451,0.12941176470588, 1,1,1, 0.81176470588235,0.98039215686275,0.011764705882353)..' Theme',
		}
	elseif element == 'classCrest' then
		options.args.styleOptions.values = {
			['benikui'] = 'BenikUI',
			['releaf-flat'] = 'Releaf-Flat',
			['sltheme'] = E:TextGradient('S&L', 0.33725490196078,0.7921568627451,0.12941176470588, 1,1,1, 0.81176470588235,0.98039215686275,0.011764705882353)..' Theme',
		}
	elseif element == 'factionLogo' or element == 'factionCrest' or element == 'raceCrest' then
		options.args.styleOptions.values = {
			['blizzard'] = 'Blizzard',
			['releaf-flat'] = 'Releaf-Flat',
			['sltheme'] = E:TextGradient('S&L', 0.33725490196078,0.7921568627451,0.12941176470588, 1,1,1, 0.81176470588235,0.98039215686275,0.011764705882353)..' Theme',
		}
	end

	if element == 'exPack' then
		options.args.expansion ={
			order = 2,
			name = L["Expansion"],
			type = 'select',
			values = {
				auto = L["Current Expansion"],
				classic = 'WoW Classic',
				tbc = 'Burning Crusade',
				wotlk = 'Wrath of the Lich King',
				cata = 'Cataclysm',
				mop = 'Mists of Pandaria',
				wod = 'Warlords of Draenor',
				legion = 'Legion',
				bfa = 'Battle for Azeroth',
				sl = 'Shadowlands',
				df = 'Dragonflight',
			}
		}
		options.args.styleOptions.values = function() return GetExPackStyles() end
		options.args.styleOptions.disabled = function() return E.db.sle.afk.defaultGraphics[element].expansion == 'auto' end
		options.args.styleOptions.get = function(info)
			if E.db.sle.afk.defaultGraphics.exPack.expansion ~= 'sl' and (E.db.sle.afk.defaultGraphics.exPack.styleOptions == 'releaf-flat' or E.db.sle.afk.defaultGraphics.exPack.styleOptions == 'sltheme') then
				SLE:Print('The selected expansion does not support the "'..E.db.sle.afk.defaultGraphics.exPack.styleOptions..'" style option.  Adjusting the style option that is supported which is "blizzard".', 'info')
				E.db.sle.afk.defaultGraphics.exPack.styleOptions = 'blizzard'
			end
			return E.db.sle.afk.defaultGraphics[element][info[#info]]
		end
	end

	return options
end

local function configTable()
	if not SLE.initialized then return end

	ACH = E.Libs.ACH

	local screenWidth = ceil(E.screenWidth)
	local screenHeight = ceil(E.screenHeight)
	E.Options.args.sle.args.modules.args.afk = {
		order = 1,
		name = L["AFK Mode"],
		type = 'group',
		childGroups = 'tab',
		disabled = function() return not E.db.general.afk end,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				type = 'toggle',
				get = function(info) return E.db.sle.afk[info[#info]] end,
				set = function(info, value)
					E.db.sle.afk[info[#info]] = value
					E.ShowPopup = true
					-- S:Toggle()
					-- S:Hide()
					-- S:KeyScript()
				end,
			},
			general = {
				order = 2,
				name = L["General"],
				type = 'group',
				disabled = function() return not E.db.sle.afk.enable end,
				args = {
					general = {
						order = 1,
						name = L["General"],
						type = 'group',
						args = {
							keydown = {
								order = 1,
								name = L["Button Restrictions"],
								type = 'toggle',
								desc = L["Use ElvUI's restrictions for button presses."],
								hidden = function() return not E.global.sle.advanced.general end,
								get = function() return E.db.sle.afk.keydown end,
								set = function(_, value) E.db.sle.afk.keydown = value; S:KeyScript() end,
							},
							musicSelection = {
								order = 1,
								name = L["Music Selection"],
								type = 'select',
								get = function(info) return E.db.sle.afk[info[#info]] end,
								set = function(info, value) E.db.sle.afk[info[#info]] = value end,
								values = {
									NONE = NONE,
									CLASS = CLASS,
									RACIAL = RACE,
								},
							},
						},
					},
					chat = {
						order = 10,
						name = L["Chat"],
						type = 'group',
						get = function(info) return E.db.sle.afk[info[#info-1]][info[#info]] end,
						set = function(info, value) E.db.sle.afk[info[#info-1]][info[#info]] = value end,
						args = {
							show = {
								order = 1,
								name = L["Show"],
								type = 'toggle',
								desc = L["Toggle for showing/hiding the chat panel."],
							},
						},
					},
					panels = {
						order = 10,
						name = L["Panels"],
						type = 'group',
						get = function(info) return E.db.sle.afk.panels[info[#info-1]][info[#info]] end,
						set = function(info, value) E.db.sle.afk.panels[info[#info-1]][info[#info]] = value; S:CreateUpdatePanels(); S:SetupType() end,
						args = {
							animation = {
								order = 1,
								name = L["Animation"],
								type = 'group',
								guiInline = true,
								args = {
									animBounce = {
										order = 1,
										name = L["Bouncing"],
										type = 'toggle',
										desc = L["Use bounce on fade in animations."],
										disabled = function() return E.db.sle.afk.animTime == 0 end,
										get = function(info) return E.db.sle.afk[info[#info]] end,
										set = function(info, value) E.db.sle.afk[info[#info]] = value; S:SetupAnimations() end,
									},
									animTime = {
										order = 2,
										name = L["Animation time"],
										type = 'range',
										desc = L["Time the fade in animation will take. To disable animation set to 0."],
										min = 0, max = 10, step = 0.01,
										get = function(info) return E.db.sle.afk[info[#info]] end,
										set = function(info, value) E.db.sle.afk[info[#info]] = value; S:Hide() end,
									},
									animType = {
										order = 3,
										name = L["Animation Type"],
										type = 'select',
										disabled = function() return E.db.sle.afk.animTime == 0 end,
										get = function(info) return E.db.sle.afk[info[#info]] end,
										set = function(info, value) E.db.sle.afk[info[#info]] = value; S:SetupType() end,
										values = {
											SlideIn = L["Vertical Slide In"],
											SlideSide = L["Horizontal Slide In"],
											FadeIn = L["Fade"],
										},
									},
								},
							},
							top = {
								order = 2,
								name = L["Top"],
								type = 'group',
								guiInline = true,
								args = {
									height = {
										order = 1,
										name = L["Height"],
										type = 'range',
										min = 120, max = 200, step = 1,
									},
									width = {
										order = 2,
										name = L["Width"],
										type = 'range',
										desc = L["Setting to 0 will default to the screens width value return by blizzards api. Recommended if using this profile on various monitor resolutions and want the panel to be the max width."],
										min = 0, max = ceil(GetScreenWidth()), step = 1,
										get = function(info) return ceil(E.db.sle.afk.panels.top[info[#info]]) end,
									},
									template = {
										order = 3,
										name = L["Template"],
										type = 'select',
										values = {
											Default = DEFAULT,
											Transparent = L["Transparent"],
										},
									},
								},
							},
							bottom = {
								order = 3,
								name = L["Bottom"],
								type = 'group',
								guiInline = true,
								args = {
									height = {
										order = 1,
										name = L["Height"],
										type = 'range',
										min = 120, max = 200, step = 1,
									},
									width = {
										order = 2,
										name = L["Width"],
										type = 'range',
										desc = L["Setting to 0 will default to the screens width value return by blizzards api. Recommended if using this profile on various monitor resolutions and want the panel to be the max width."],
										min = 0, max = ceil(GetScreenWidth()), step = 1,
										get = function(info) return ceil(E.db.sle.afk.panels.bottom[info[#info]]) end,
									},
									template = {
										order = 3,
										name = L["Template"],
										type = 'select',
										values = {
											Default = DEFAULT,
											Transparent = L["Transparent"],
										},
									},
								},
							},
						},
					},
					playermodel = {
						order = 10,
						name = L["Player Model"],
						type = 'group',
						args = {
							enable = {
								order = 1,
								name = L["Enable"],
								type = 'toggle',
								get = function() return E.db.sle.afk.playermodel.enable end,
								set = function(_, value) E.db.sle.afk.playermodel.enable = value end,
							},
							testmodel = {
								order = 2,
								name = L["Test"],
								type = 'execute',
								desc = L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."],
								func = function() S:TestShow() end,
							},
							general = {
								order = 99,
								name = ' ',
								type = 'group',
								guiInline = true,
								args = {
									modelanim = {
										order = 2,
										name = L["Model Animation"],
										type = 'select',
										get = function() return E.db.sle.afk.playermodel.anim end,
										set = function(_, value) E.db.sle.afk.playermodel.anim = value end,
										sortByValue = true,
										values = {
											[80] = 'Applaud',
											[79] = 'Beg', --new
											[66] = 'Bow',
											[68] = 'Cheers',
											[77] = 'Cry',
											[69] = 'Dance',
											[64] = 'Exclamation',
											[82] = 'Flex',
											[76] = 'Kiss',
											[70] = 'Laugh',
											[5] = 'Running',
											[113] = 'Salute',
											[83] = 'Shy',
											[72] = 'Sit', --new
											[71] = 'Sleep', --new
											[47] = 'Standing',
											[60] = 'Talking',
											[25] = 'Unarmed Ready',
											[4] = 'Walking',
											[13] = 'Walking (Backwards)',
											[67] = 'Wave',
										},
									},
									holderXoffset = {
										order = 6,
										name = L["X-Offset"],
										type = 'range',
										min = -screenWidth, max = screenWidth, step = 1,
										get = function() return E.db.sle.afk.playermodel.holderXoffset end,
										set = function(_, value) E.db.sle.afk.playermodel.holderXoffset = value; S:CreateUpdateModelElements(true) end,
									},
									holderYoffset = {
										order = 7,
										name = L["Y-Offset"],
										type = 'range',
										min = -screenHeight, max = screenHeight, step = 1,
										get = function() return E.db.sle.afk.playermodel.holderYoffset end,
										set = function(_, value) E.db.sle.afk.playermodel.holderYoffset = value; S:CreateUpdateModelElements(true) end,
									},
									distance = {
										order = 8,
										name = L["Camera Distance Scale"],
										type = 'range',
										min = 0, max = 10, step = 0.01,
										get = function() return E.db.sle.afk.playermodel.distance end,
										set = function(_, value) E.db.sle.afk.playermodel.distance = value end,
									},
									rotation = {
										order = 4,
										name = L["Model Rotation"],
										type = 'range',
										min = 0, max = 360, step = 1,
										get = function() return E.db.sle.afk.playermodel.rotation end,
										set = function(_, value) E.db.sle.afk.playermodel.rotation = value end,
									},
								},
							},
						},
					},
				},
			},
			graphics = {
				order = 2,
				name = L["Graphics"],
				type = 'group',
				disabled = function() return not E.db.sle.afk.enable end,
				args = {
					addGraphic = {
						order = 0,
						name = ColorizeName(L["Custom Graphics"], '33ff33'),
						type = 'group',
						-- get = function(info) return newGraphicInfo[info[#info]] end,
						-- set = function(info, value) newGraphicInfo[info[#info]] = value end,
						args = {
							name = {
								order = 1,
								name = L["New Graphic Name"],
								type = 'input',
								width = 'full',
								validate = function(_, value)
									local name = strtrim(value)

									return E.db.sle.afk.customGraphics[name] and SLE:Print(L["Name Taken"], 'error') or true
								end,
								get = function(info) return newGraphicInfo[info[#info]] end,
								set = function(info, value)
									local name = strtrim(value)
									newGraphicInfo[info[#info]] = name
								end,
							},
							add = {
								order = 3,
								name = L['Add'],
								type = 'execute',
								desc = '',
								width = 'full',
								func = function()
									local name = newGraphicInfo.name

									if E.db.sle.afk.customGraphics[name] then
										SLE:Print(L["Name Taken"])
									elseif name and name ~= '' and not E.db.sle.afk.customGraphics[name] then
										E.db.sle.afk.customGraphics[name] = E:CopyTable({}, S.CustomGraphicsDefaults)
										E.db.sle.afk.customGraphics[name].name = newGraphicInfo.name
										selectedGraphic = name

										S:CreateCustomGraphic(name)
										S:UpdateCustomGraphic(name)

										E.Options.args.sle.args.modules.args.afk.args.graphics.args.addGraphic.args.graphicOptions.name = L["Custom Graphic"]..':  '..name

										newGraphicInfo.name = ''
									end
								end,
								disabled = function()
									local name = newGraphicInfo.name

									return E.db.sle.afk.customGraphics[name] or name == '' or name == nil
								end,
							},
							-- header = ACH:Header(nil, 4),
							header = {
								order = 4,
								type = 'header',
								name = '',
							},
							graphicList = {
								order = 5,
								name = L["List of Graphics"],
								type = 'select',
								get = function() return selectedGraphic end,
								set = function(_, value)
									selectedGraphic = value
									E.Options.args.sle.args.modules.args.afk.args.graphics.args.addGraphic.args.graphicOptions.name = L["Custom Graphic"]..':  '..value
								end,
								values = function()
									local graphicsList = {}
									graphicsList[''] = NONE
									for name, _ in pairs(E.db.sle.afk.customGraphics) do
										graphicsList[name] = name
									end
									if not selectedGraphic then
										selectedGraphic = ''
									end
									return graphicsList
								end,
							},
							spacer1 = ACH:Spacer(6, 'half'),
							graphicOptions = {
								order = 8,
								name = '',
								type = 'group',
								guiInline = true,
								hidden = function()
									return selectedGraphic == ''
								end,
								get = function(info) return E.db.sle.afk.customGraphics[selectedGraphic][(info[#info])] end,
								set = function(info, value)
									E.db.sle.afk.customGraphics[selectedGraphic][(info[#info])] = value
									S:UpdateCustomGraphic(selectedGraphic)
								end,
								args = sharedOptions('customGraphics'),
								-- 	showPreview = {
								-- 		order = 10,
								-- 		type = 'execute',
								-- 		name = L["Test"],
								-- 		desc = L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."],
								-- 		func = function()
								-- 			-- -- local db = E.db.sle.afk.customGraphics[info]
								-- 			local db = E.db.sle.afk.customGraphics[selectedGraphic]
								-- 			if AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic] then
								-- 				if not db.showPreview then
								-- 					db.showPreview = true
								-- 					-- SS['SL_CustomGraphics_'..selectedGraphic]:Show()
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:ClearAllPoints()
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:SetPoint('TOP', E.UIParent, 'TOP', 0, 0)
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:SetParent(E.UIParent)
								-- 				else
								-- 					db.showPreview = false
								-- 					-- SS['SL_CustomGraphics_'..selectedGraphic]:Hide()
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:ClearAllPoints()
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:SetPoint('TOP', AFK.AFKMode.Top, 'TOP', 0, 0)
								-- 					AFK.AFKMode['SL_CustomGraphics_'..selectedGraphic]:SetParent(AFK.AFKMode)
								-- 				end
								-- 				print("i tried")
								-- 				-- SS['SL_CustomGraphics_'..selectedGraphic]:SetShown(db.showPreview)
								-- 			end


								-- 			-- -- -- E:Dump(info, true)
								-- 			-- if not db.showPreview then
								-- 			-- 	db.showPreview = true
								-- 			-- 	-- 	-- SS['SL_CustomGraphics_'..info]:Show()
								-- 			-- else
								-- 			-- 	db.showPreview = false
								-- 			-- 	-- 	-- SS['SL_CustomGraphics_'..info]:Hide()
								-- 			-- end
								-- 			-- print(selectedGraphic, db.showPreview)
								-- 			-- SS.texture:SetShown(db.showPreview)
								-- 			-- -- -- local texture = SS['SL_CustomGraphics_'..info]
								-- 			-- -- -- S:PreviewCustomGraphics(db, info[#info])
								-- 		end,
								-- 	},
							},
						},
					},
					addonLogos = {
						order = 11,
						name = L["Addon Logos"],
						type = 'group',
						args = {
							slLogo = defaultGraphicsOptions('slLogo', 'addonLogos', "S&L", 1),
							elvuiLogo = defaultGraphicsOptions('elvuiLogo', 'addonLogos', "ElvUI", 2),
							benikuiLogo = defaultGraphicsOptions('benikuiLogo', 'addonLogos', "BenikUI", 99),
							merauiLogo = defaultGraphicsOptions('merauiLogo', 'addonLogos', "MerathilisUI", 99),
						},
					},
					classCrest = defaultGraphicsOptions('classCrest', nil, L["Class Crests"], 20),
					exPack = defaultGraphicsOptions('exPack', nil, L["Expansion Icon"], 20),
					factionCrest = defaultGraphicsOptions('factionCrest', nil, L["Faction Crests"], 20),
					factionLogo = defaultGraphicsOptions('factionLogo', nil, L["Faction Logo"], 20),
					raceCrest = defaultGraphicsOptions('raceCrest', nil, L["Race Crests"], 20),
				},
			},
			text = {
				order = 2,
				name = L["Text"],
				type = 'group',
				disabled = function() return not E.db.sle.afk.enable end,
				args = {
					afk = {
						order = 1,
						type = 'group',
						name = L["AFK Message & Time"],
						args = {
							message = CreateDefaultTextsFont(1, L["Message"], 'SL_AFKMessage', true),
							time = CreateDefaultTextsFont(1, L["Time"], 'SL_AFKTimePassed', true),
						},
					},
					datetime = {
						order = 1,
						type = 'group',
						name = L["Date & Time"],
						args = {
							date = CreateDefaultTextsFont(1, L["Date"], 'SL_Date', true),
							time = CreateDefaultTextsFont(1, L["Time"], 'SL_Time', true),
						},
					},
					guild = {
						order = 1,
						type = 'group',
						name = GUILD,
						args = {
							name = CreateDefaultTextsFont(1, NAME, 'SL_GuildName', true),
							rank = CreateDefaultTextsFont(1, RANK, 'SL_GuildRank', true),
						},
					},
					player = {
						order = 1,
						type = 'group',
						name = PLAYER,
						args = {
							class = CreateDefaultTextsFont(1, L["Class"], 'SL_PlayerClass', true),
							level = CreateDefaultTextsFont(1, L["Level"], 'SL_PlayerLevel', true),
							name = CreateDefaultTextsFont(1, NAME, 'SL_PlayerName', true),
						},
					},
					subtext = CreateDefaultTextsFont(1, L["SubText"], 'SL_SubText'),
					scrollframe = {
						order = 1,
						type = 'group',
						name = L["Random Tips Scroll Frame"],
						args = {
							randomTips = CreateDefaultTextsFont(1, L["Random Tips"], 'SL_ScrollFrame', true),
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
