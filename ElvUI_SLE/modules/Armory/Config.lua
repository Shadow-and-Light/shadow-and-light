if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

if not (KF and KF.Modules and (KF.Modules.CharacterArmory or KF.Modules.InspectArmory)) then return end

local function Color(TrueColor, FalseColor)
	return (E.db.sle.Armory.Character.Enable ~= false or E.db.sle.Armory.Inspect.Enable ~= false) and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end

local EnchantStringName, EnchantString_Old, EnchantString_New = '', '', ''
local SelectedEnchantString

local function LoadArmoryConfigTable()
	E.Options.args.sle.args.Armory = {
		type = 'group',
		name = function() return KF:Color_Value(L["Armory Mode"]) end,
		order = 6,
		childGroups = 'tab',
		args = {
			EnchantString = {
				type = 'group',
				name = function() return Color('', 'ff787878')..L['Enchant String'] end,
				order = 300,
				args = {
					Space = {
						type = 'description',
						name = ' ',
						order = 1
					},
					ConfigSpace = {
						type = 'group',
						name = function() return Color('ffffffff', 'ff787878')..L['String Replacement'] end,
						order = 2,
						guiInline = true,
						args = {
							CreateString = {
								order = 1,
								name = L["Create Filter"],
								type = 'input',
								width = "full",
								get = function() return EnchantStringName end,
								set = function(_, value)
									EnchantStringName = value
								end,
								disabled = function() return E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false end
							},
							AddButton = {
								type = 'execute',
								name = function() return (((E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false) or EnchantStringName == '') and '|cff787878' or KF:Color_Value())..ADD end, --L['Create Replacement'] end,
								order = 3,
								desc = '',
								func = function()
									if EnchantStringName ~= '' and not SLE_ArmoryDB.EnchantString[EnchantStringName] then
										SLE_ArmoryDB.EnchantString[EnchantStringName] = {}
										SelectedEnchantString = EnchantStringName
										EnchantStringName = ""
									end
								end,
								disabled = function()
									return (E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false) or EnchantStringName == ''
								end
							},
							List = {
								type = 'select',
								name = function() return ' '..Color()..L['List of Strings'] end,
								order = 4,
								get = function() return SelectedEnchantString end,
								set = function(_, value)
									SelectedEnchantString = value
									E.Options.args.sle.args.Armory.args.EnchantString.args.ConfigSpace.args.StringGroup.name = L['List of Strings']..": "..value
								end,
								values = function()
									local List = {}
									List[''] = NONE
									for Name, _ in pairs(SLE_ArmoryDB.EnchantString) do
										List[Name] = Name
									end
									if not SelectedEnchantString then
											SelectedEnchantString = ''
										end
									return List
								end,
								disabled = function() return E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false end
							},
							Space2 = {
								type = 'description',
								name = ' ',
								order = 5,
								width = 'half'
							},
							StringGroup = {
								type = 'group',
								name = "",
								order = 8,
								guiInline = true,
								hidden = function()
									return SelectedEnchantString == ''
								end,
								args = {
									TargetString = {
										type = 'input',
										name = function() return ' '..Color()..L['Original String'] end,
										order = 1,
										desc = '',
										width = "full",
										get = function() return SLE_ArmoryDB.EnchantString[SelectedEnchantString]["original"] end,
										set = function(_, value)
											SLE_ArmoryDB.EnchantString[SelectedEnchantString]["original"] = value
											
											if CharacterArmory then
												CharacterArmory:Update_Gear()
											end
											
											if InspectArmory and InspectArmory.LastDataSetting then
												InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
											end
										end,
										disabled = function() return E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false end
									},
									NewString = {
										type = 'input',
										name = function() return ' '..Color()..L['New String'] end,
										order = 2,
										desc = '',
										width = "full",
										get = function() return SLE_ArmoryDB.EnchantString[SelectedEnchantString]["new"] end,
										set = function(_, value)
											SLE_ArmoryDB.EnchantString[SelectedEnchantString]["new"] = value
											
											if CharacterArmory then
												CharacterArmory:Update_Gear()
											end
											
											if InspectArmory and InspectArmory.LastDataSetting then
												InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
											end
										end,
										disabled = function() return E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false end
									},
									DeleteButton = {
										type = 'execute',
										name = function() return Color(nil, 'ff787878')..DELETE end,
										order = 8,
										desc = '',
										func = function()
											if SLE_ArmoryDB.EnchantString[SelectedEnchantString] then
												SLE_ArmoryDB.EnchantString[SelectedEnchantString] = nil
												SelectedEnchantString = ''
												
												if CharacterArmory then
													CharacterArmory:Update_Gear()
												end
												
												if InspectArmory and InspectArmory.LastDataSetting then
													InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
												end
											end
										end,
										disabled = function() return E.db.sle.Armory.Character.Enable == false and E.db.sle.Armory.Inspect.Enable == false end,	
									},
								},
							},
						},
					},
					Space2 = {
						type = 'description',
						name = ' ',
						order = 3
					},
					CreditSpace = {
						type = 'description',
						name = ' ',
						order = 998
					},
					Credit = {
						type = 'header',
						name = KF.Credit,
						order = 999
					}
				}
			}
		}
	}


	local BackdropKeyTable = {
		['0'] = 'HIDE',
		['1'] = 'CUSTOM',
		['2'] = 'Space',
		['3'] = 'TheEmpire',
		['4'] = 'Castle',
		['5'] = 'Alliance-text',
		['6'] = 'Horde-text',
		['7'] = 'Alliance-bliz',
		['8'] = 'Horde-bliz',
		['9'] = 'Arena-bliz'
	}

	local BackgroundList = {
		['0'] = HIDE,
		['1'] = L['Custom'],
		['2'] = "Space",
		['3'] = "The Empire",
		['4'] = "Castle",
		['5'] = FACTION_ALLIANCE,
		['6'] = FACTION_HORDE,
		['7'] = FACTION_ALLIANCE..' 2',
		['8'] = FACTION_HORDE..' 2',
		['9'] = ARENA
	}

	local DisplayMethodList = {
		Always = L['Always Display'],
		MouseoverOnly = L['Mouseover'],
		Hide = HIDE
	}

	local FontStyleList = {
		NONE = NONE,
		OUTLINE = 'OUTLINE',
		
		MONOCHROMEOUTLINE = 'MONOCROMEOUTLINE',
		THICKOUTLINE = 'THICKOUTLINE'
	}

	if KF.Modules.CharacterArmory then
		local function CA_Color(TrueColor, FalseColor)
			return E.db.sle.Armory.Character.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
		end
		
		E.Options.args.sle.args.Armory.args.CAEnable = {
			type = 'toggle',
			name = function() return KF:Color_Value()..L['Character Armory'] end,
			order = 1,
			desc = '',
			get = function() return E.db.sle.Armory.Character.Enable end,
			set = function(_, value)
				E.db.sle.Armory.Character.Enable = value
				
				KF.Modules.CharacterArmory()
			end
		}
		
		local SelectedCABG
		E.Options.args.sle.args.Armory.args.Character = {
			type = 'group',
			name = function() return CA_Color('', 'ff787878')..L['Character Armory'] end,
			order = 400,
			args = {
				NoticeMissing = {
					type = 'toggle',
					name = function() return ' '..CA_Color()..L['Show Missing Enchants or Gems'] end,
					order = 1,
					desc = '',
					get = function() return E.db.sle.Armory.Character.NoticeMissing end,
					set = function(_, value)
						E.db.sle.Armory.Character.NoticeMissing = value
						
						CharacterArmory:Update_Gear()
						CharacterArmory:Update_Display(true)
					end,
					disabled = function() return E.db.sle.Armory.Character.Enable == false end,
					width = 'full'
				},
				Space1 = {
					type = 'description',
					name = ' ',
					order = 2
				},
				Backdrop = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..L['Backdrop'] end,
					order = 3,
					guiInline = true,
					args = {
						SelectedBG = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Select Image'] end,
							order = 1,
							get = function()
								for Index, Key in pairs(BackdropKeyTable) do
									if Key == E.db.sle.Armory.Character.Backdrop.SelectedBG then
										return Index
									end
								end
								
								return '1'
							end,
							set = function(_, value)
								E.db.sle.Armory.Character.Backdrop.SelectedBG = BackdropKeyTable[value]
								
								CharacterArmory:Update_BG()
							end,
							values = function() return BackgroundList end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						CustomAddress = {
							type = 'input',
							name = function() return ' '..CA_Color()..L['Custom Image Path'] end,
							order = 2,
							desc = '',
							get = function() return E.db.sle.Armory.Character.Backdrop.CustomAddress end,
							set = function(_, value)
								E.db.sle.Armory.Character.Backdrop.CustomAddress = value
								
								CharacterArmory:Update_BG()
							end,
							width = 'double',
							disabled = function() return E.db.sle.Armory.Character.Enable == false end,
							hidden = function() return E.db.sle.Armory.Character.Backdrop.SelectedBG ~= 'CUSTOM' end
						},
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 4
				},
				Gradation = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..L['Gradient'] end,
					order = 5,
					guiInline = true,
					args = {
						Display = {
							type = 'toggle',
							name = function() return ' '..CA_Color()..L['Enable'] end,
							order = 1,
							get = function() return E.db.sle.Armory.Character.Gradation.Display end,
							set = function(_, value)
								E.db.sle.Armory.Character.Gradation.Display = value
								
								CharacterArmory:Update_Gear()
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						Color = {
							type = 'color',
							name = function() return ' '..(E.db.sle.Armory.Character.Enable == true and E.db.sle.Armory.Character.Gradation.Display == true and KF:Color_Value() or '')..L['Gradient Texture Color'] end,
							order = 2,
							get = function() 
								return E.db.sle.Armory.Character.Gradation.Color[1],
									   E.db.sle.Armory.Character.Gradation.Color[2],
									   E.db.sle.Armory.Character.Gradation.Color[3],
									   E.db.sle.Armory.Character.Gradation.Color[4]
							end,
							set = function(Info, r, g, b, a)
								E.db.sle.Armory.Character.Gradation.Color = { r, g, b, a }
								
								CharacterArmory:Update_Gear()
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false or E.db.sle.Armory.Character.Gradation.Display == false end
						},
					}
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 6
				},
				Level = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..L['Item Level'] end,
					order = 7,
					guiInline = true,
					get = function(info) return E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
						
						for _, SlotName in pairs(Info.Armory_Constants.GearList) do
							if CharacterArmory[SlotName] and CharacterArmory[SlotName].ItemLevel then
								CharacterArmory[SlotName].ItemLevel:FontTemplate(
									E.LSM:Fetch('font', E.db.sle.Armory.Character.Level.Font)
									,
									E.db.sle.Armory.Character.Level.FontSize
									,
									E.db.sle.Armory.Character.Level.FontStyle
								)
							end
						end
					end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Visibility'] end,
							order = 1,
							set = function(info, value)
								E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
								
								CharacterArmory:Update_Gear()
								CharacterArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						ShowUpgradeLevel = {
							type = 'toggle',
							name = function() return ' '..CA_Color()..L['Upgrade Level'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Character.Level.ShowUpgradeLevel = value
								
								CharacterArmory:Update_Gear()
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..CA_Color()..L['Font'] end,
							order = 4,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Font Size'] end,
							order = 5,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Font Outline'] end,
							order = 6,
							desc = '',
							values = FontStyleList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						}
					}
				},
				Space4 = {
					type = 'description',
					name = ' ',
					order = 8
				},
				Enchant = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..L['Enchant String'] end,
					order = 9,
					guiInline = true,
					get = function(info) return E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
						
						for _, SlotName in pairs(Info.Armory_Constants.GearList) do
							if CharacterArmory[SlotName] and CharacterArmory[SlotName].ItemEnchant then
								CharacterArmory[SlotName].ItemEnchant:FontTemplate(
									E.LSM:Fetch('font', E.db.sle.Armory.Character.Enchant.Font)
									,
									E.db.sle.Armory.Character.Enchant.FontSize
									,
									E.db.sle.Armory.Character.Enchant.FontStyle
								)
							end
						end
					end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Visibility'] end,
							order = 1,
							set = function(info, value)
								E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
								
								CharacterArmory:Update_Gear()
								CharacterArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						WarningSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Warning Size'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Character.Enchant.WarningSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									if CharacterArmory[SlotName] and CharacterArmory[SlotName].EnchantWarning then
										CharacterArmory[SlotName].EnchantWarning:Size(value)
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						WarningIconOnly = {
							type = 'toggle',
							name = function() return ' '..CA_Color()..L['Warning Only As Icons'] end,
							order = 3,
							set = function(_, value)
								E.db.sle.Armory.Character.Enchant.WarningIconOnly = value
								
								CharacterArmory:Update_Gear()
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end,
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 4
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..CA_Color()..L['Font'] end,
							order = 5,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Font Size'] end,
							order = 6,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Font Outline'] end,
							order = 7,
							desc = '',
							values = FontStyleList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						}
					}
				},
				Space5 = {
					type = 'description',
					name = ' ',
					order = 10
				},
				Durability = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..DURABILITY end,
					order = 11,
					guiInline = true,
					get = function(info) return E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
						
						for _, SlotName in pairs(Info.Armory_Constants.GearList) do
							if CharacterArmory[SlotName] and CharacterArmory[SlotName].Durability then
								CharacterArmory[SlotName].Durability:FontTemplate(
									E.LSM:Fetch('font', E.db.sle.Armory.Character.Durability.Font)
									,
									E.db.sle.Armory.Character.Durability.FontSize
									,
									E.db.sle.Armory.Character.Durability.FontStyle
								)
							end
						end
					end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Visibility'] end,
							order = 1,
							set = function(info, value)
								E.db.sle.Armory.Character[(info[#info - 1])][(info[#info])] = value
								
								CharacterArmory:Update_Durability()
								CharacterArmory:Update_Display(true)
							end,
							values = {
								Always = L['Always Display'],
								DamagedOnly = L['Only Damaged'],
								MouseoverOnly = L['Mouseover'],
								Hide = HIDE
							},
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 2
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..CA_Color()..L['Font'] end,
							order = 3,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Font Size'] end,
							order = 4,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Font Outline'] end,
							order = 5,
							desc = '',
							values = FontStyleList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						}
					}
				},
				Space6 = {
					type = 'description',
					name = ' ',
					order = 12
				},
				Gem = {
					type = 'group',
					name = function() return CA_Color('ffffffff', 'ff787878')..L['Gem Sockets'] end,
					order = 13,
					guiInline = true,
					get = function(Info) return E.db.sle.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..CA_Color()..L['Visibility'] end,
							order = 1,
							set = function(Info, value)
								E.db.sle.Armory.Character[(Info[#Info - 1])][(Info[#Info])] = value
								
								CharacterArmory:Update_Gear()
								CharacterArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						SocketSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Socket Size'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Character.Gem.SocketSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									for i = 1, MAX_NUM_SOCKETS do
										if CharacterArmory[SlotName] and CharacterArmory[SlotName]['Socket'..i] then
											CharacterArmory[SlotName]['Socket'..i]:Size(value)
										else
											break
										end
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						WarningSize = {
							type = 'range',
							name = function() return ' '..CA_Color()..L['Warning Size'] end,
							order = 3,
							set = function(_, value)
								E.db.sle.Armory.Character.Gem.WarningSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									if CharacterArmory[SlotName] and CharacterArmory[SlotName].SocketWarning then
										CharacterArmory[SlotName].SocketWarning:Size(value)
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
					}
				},
				CreditSpace = {
					type = 'description',
					name = ' ',
					order = 998
				},
				Credit = {
					type = 'header',
					name = KF.Credit,
					order = 999
				}
			}
		}
	end


	if KF.Modules.InspectArmory then
		local function IA_Color(TrueColor, FalseColor)
			return E.db.sle.Armory.Inspect.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
		end
		
		E.Options.args.sle.args.Armory.args.IAEnable = {
			type = 'toggle',
			name = function() return KF:Color_Value()..L['Inspect Armory'] end,
			order = 2,
			desc = '',
			get = function() return E.db.sle.Armory.Inspect.Enable end,
			set = function(_, value)
				E.db.sle.Armory.Inspect.Enable = value
				
				KF.Modules.InspectArmory()
			end
		}
		
		E.Options.args.sle.args.Armory.args.Inspect = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Inspect Armory'] end,
			order = 500,
			args = {
				NoticeMissing = {
					type = 'toggle',
					name = function() return ' '..IA_Color()..L['Show Missing Enchants or Gems'] end,
					order = 1,
					desc = '',
					get = function() return E.db.sle.Armory.Inspect.NoticeMissing end,
					set = function(_, value)
						E.db.sle.Armory.Inspect.NoticeMissing = value
						
						if InspectArmory.LastDataSetting then
							InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
						end
						InspectArmory:Update_Display(true)
					end,
					disabled = function() return E.db.sle.Armory.Inspect.Enable == false end,
					width = 'full'
				},
				Space1 = {
					type = 'description',
					name = ' ',
					order = 2
				},
				Backdrop = {
					type = 'group',
					name = function() return IA_Color('ffffffff', 'ff787878')..L['Backdrop'] end,
					order = 3,
					guiInline = true,
					args = {
						SelectedBG = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Select Image'] end,
							order = 1,
							get = function()
								for Index, Key in pairs(BackdropKeyTable) do
									if Key == E.db.sle.Armory.Inspect.Backdrop.SelectedBG then
										return Index
									end
								end
								
								return '1'
							end,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Backdrop.SelectedBG = BackdropKeyTable[value]
								
								InspectArmory:Update_BG()
							end,
							values = function() return BackgroundList end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						CustomAddress = {
							type = 'input',
							name = function() return ' '..IA_Color()..L['Custom Image Path'] end,
							order = 2,
							desc = '',
							get = function() return E.db.sle.Armory.Inspect.Backdrop.CustomAddress end,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Backdrop.CustomAddress = value
								
								InspectArmory:Update_BG()
							end,
							width = 'double',
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end,
							hidden = function() return E.db.sle.Armory.Inspect.Backdrop.SelectedBG ~= 'CUSTOM' end
						},
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 4
				},
				Gradation = {
					type = 'group',
					name = function() return IA_Color('ffffffff', 'ff787878')..L['Gradient'] end,
					order = 5,
					guiInline = true,
					args = {
						Display = {
							type = 'toggle',
							name = function() return ' '..IA_Color()..L['Enable'] end,
							order = 1,
							get = function() return E.db.sle.Armory.Inspect.Gradation.Display end,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Gradation.Display = value
								
								if InspectArmory and InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						Color = {
							type = 'color',
							name = function() return ' '..(E.db.sle.Armory.Inspect.Enable == true and E.db.sle.Armory.Inspect.Gradation.Display == true and KF:Color_Value() or '')..L['Gradient Texture Color'] end,
							order = 2,
							get = function() 
								return E.db.sle.Armory.Inspect.Gradation.Color[1],
									   E.db.sle.Armory.Inspect.Gradation.Color[2],
									   E.db.sle.Armory.Inspect.Gradation.Color[3],
									   E.db.sle.Armory.Inspect.Gradation.Color[4]
							end,
							set = function(Info, r, g, b, a)
								E.db.sle.Armory.Inspect.Gradation.Color = { r, g, b, a }
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false or E.db.sle.Armory.Inspect.Gradation.Display == false end
						},
					}
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 6
				},
				Level = {
					type = 'group',
					name = function() return IA_Color('ffffffff', 'ff787878')..L['Item Level'] end,
					order = 7,
					guiInline = true,
					get = function(info) return E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
						
						for _, SlotName in pairs(Info.Armory_Constants.GearList) do
							if InspectArmory[SlotName] and InspectArmory[SlotName].Gradation and InspectArmory[SlotName].Gradation.ItemLevel then
								InspectArmory[SlotName].Gradation.ItemLevel:FontTemplate(
									E.LSM:Fetch('font', E.db.sle.Armory.Inspect.Level.Font)
									,
									E.db.sle.Armory.Inspect.Level.FontSize
									,
									E.db.sle.Armory.Inspect.Level.FontStyle
								)
							end
						end
					end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Visibility'] end,
							order = 1,
							set = function(info, value)
								E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
								InspectArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						ShowUpgradeLevel = {
							type = 'toggle',
							name = function() return ' '..IA_Color()..L['Upgrade Level'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Level.ShowUpgradeLevel = value
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..IA_Color()..L['Font'] end,
							order = 4,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..IA_Color()..L['Font Size'] end,
							order = 5,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Font Outline'] end,
							order = 6,
							desc = '',
							values = FontStyleList,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						}
					}
				},
				Space4 = {
					type = 'description',
					name = ' ',
					order = 8
				},
				Enchant = {
					type = 'group',
					name = function() return IA_Color('ffffffff', 'ff787878')..L['Enchant String'] end,
					order = 9,
					guiInline = true,
					get = function(info) return E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
						
						for _, SlotName in pairs(Info.Armory_Constants.GearList) do
							if InspectArmory[SlotName] and InspectArmory[SlotName].Gradation and InspectArmory[SlotName].Gradation.ItemEnchant then
								InspectArmory[SlotName].Gradation.ItemEnchant:FontTemplate(
									E.LSM:Fetch('font', E.db.sle.Armory.Inspect.Enchant.Font)
									,
									E.db.sle.Armory.Inspect.Enchant.FontSize
									,
									E.db.sle.Armory.Inspect.Enchant.FontStyle
								)
							end
						end
					end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Visibility'] end,
							order = 1,
							set = function(info, value)
								E.db.sle.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
								InspectArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						WarningSize = {
							type = 'range',
							name = function() return ' '..IA_Color()..L['Warning Size'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Enchant.WarningSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									if InspectArmory[SlotName] and InspectArmory[SlotName].EnchantWarning then
										InspectArmory[SlotName].EnchantWarning:Size(value)
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						WarningIconOnly = {
							type = 'toggle',
							name = function() return ' '..IA_Color()..L['Warning Only As Icons'] end,
							order = 3,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Enchant.WarningIconOnly = value
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end,
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 4
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..IA_Color()..L['Font'] end,
							order = 5,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..IA_Color()..L['Font Size'] end,
							order = 6,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Font Outline'] end,
							order = 7,
							desc = '',
							values = FontStyleList,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						}
					}
				},
				Space5 = {
					type = 'description',
					name = ' ',
					order = 10
				},
				Gem = {
					type = 'group',
					name = function() return IA_Color('ffffffff', 'ff787878')..L['Gem Sockets'] end,
					order = 11,
					guiInline = true,
					get = function(Info) return E.db.sle.Armory.Inspect[(Info[#Info - 1])][(Info[#Info])] end,
					args = {
						Display = {
							type = 'select',
							name = function() return ' '..IA_Color()..L['Visibility'] end,
							order = 1,
							set = function(Info, value)
								E.db.sle.Armory.Inspect[(Info[#Info - 1])][(Info[#Info])] = value
								
								if InspectArmory.LastDataSetting then
									InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
								end
								InspectArmory:Update_Display(true)
							end,
							values = DisplayMethodList,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						SocketSize = {
							type = 'range',
							name = function() return ' '..IA_Color()..L['Socket Size'] end,
							order = 2,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Gem.SocketSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									for i = 1, MAX_NUM_SOCKETS do
										if InspectArmory[SlotName] and InspectArmory[SlotName]['Socket'..i] then
											InspectArmory[SlotName]['Socket'..i]:Size(value)
										else
											break
										end
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						WarningSize = {
							type = 'range',
							name = function() return ' '..IA_Color()..L['Warning Size'] end,
							order = 3,
							set = function(_, value)
								E.db.sle.Armory.Inspect.Gem.WarningSize = value
								
								for _, SlotName in pairs(Info.Armory_Constants.GearList) do
									if InspectArmory[SlotName] and InspectArmory[SlotName].SocketWarning then
										InspectArmory[SlotName].SocketWarning:Size(value)
									end
								end
							end,
							min = 6,
							max = 50,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
					}
				},
				CreditSpace = {
					type = 'description',
					name = ' ',
					order = 998
				},
				Credit = {
					type = 'header',
					name = KF.Credit,
					order = 999
				}
			}
		}
	end
end

table.insert(E.SLEConfigs, 9, LoadArmoryConfigTable)