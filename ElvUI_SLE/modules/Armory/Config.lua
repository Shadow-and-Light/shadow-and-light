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
		name = L["Armory Mode"],
		order = 6,
		childGroups = 'tab',
		args = {
			EnchantString = {
				type = 'group',
				name = L['Enchant String'],
				order = 300,
				args = {
					Space = {
						type = 'description',
						name = ' ',
						order = 1
					},
					ConfigSpace = {
						type = 'group',
						name = L['String Replacement'],
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
								name = ADD,
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
								name = L['List of Strings'],
								order = 4,
								get = function() return SelectedEnchantString end,
								set = function(_, value)
									SelectedEnchantString = value
									E.Options.args.sle.args.Armory.args.EnchantString.args.ConfigSpace.args.StringGroup.name = L['List of Strings']..":  "..value
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
										name = L['Original String'],
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
										name = L['New String'],
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
										name = DELETE,
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
			name = L['Character Armory'],
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
			name = L['Character Armory'],
			order = 400,
			args = {
				NoticeMissing = {
					type = 'toggle',
					name = L['Show Missing Enchants or Gems'],
					order = 1,
					desc = '',
					get = function() return E.db.sle.Armory.Character.NoticeMissing end,
					set = function(_, value)
						E.db.sle.Armory.Character.NoticeMissing = value
						
						CharacterArmory:Update_Gear()
						CharacterArmory:Update_Display(true)
					end,
					disabled = function() return not E.db.sle.Armory.Character.Enable end,
				},
				MissingIcon = {
					type = 'toggle',
					name = L['Show Warning Icon'],
					order = 2,
					desc = '',
					get = function() return E.db.sle.Armory.Character.MissingIcon end,
					set = function(_, value)
						E.db.sle.Armory.Character.MissingIcon = value
						
						CharacterArmory:Update_Gear()
						CharacterArmory:Update_Display(true)
					end,
					disabled = function() return not E.db.sle.Armory.Character.Enable or not E.db.sle.Armory.Character.NoticeMissing end,
				},
				Backdrop = {
					type = 'group',
					name = L['Backdrop'],
					order = 3,
					guiInline = true,
					args = {
						SelectedBG = {
							type = 'select',
							name = L['Select Image'],
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
							name = L['Custom Image Path'],
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
					name = L['Gradient'],
					order = 5,
					guiInline = true,
					args = {
						Display = {
							type = 'toggle',
							name = L['Enable'],
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
							name = L['Gradient Texture Color'],
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
					name = L['Item Level'],
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
							name = L['Visibility'],
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
							name = L['Upgrade Level'],
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
							name = L['Font'],
							order = 4,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = L['Font Size'],
							order = 5,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = L['Font Outline'],
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
					name = L['Enchant String'],
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
							name = L['Visibility'],
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
							name = L['Warning Size'],
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
							name = L['Warning Only As Icons'],
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
							name = L['Font'],
							order = 5,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = L['Font Size'],
							order = 6,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = L['Font Outline'],
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
					name = DURABILITY,
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
							name = L['Visibility'],
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
							name = L['Font'],
							order = 3,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = L['Font Size'],
							order = 4,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Character.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = L['Font Outline'],
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
					name = L['Gem Sockets'],
					order = 13,
					guiInline = true,
					get = function(Info) return E.db.sle.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
					args = {
						Display = {
							type = 'select',
							name = L['Visibility'],
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
							name = L['Socket Size'],
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
							name = L['Warning Size'],
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
			name = L['Inspect Armory'],
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
			name = L['Inspect Armory'],
			order = 500,
			args = {
				NoticeMissing = {
					type = 'toggle',
					name = L['Show Missing Enchants or Gems'],
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
					disabled = function() return not E.db.sle.Armory.Inspect.Enable end,
				},
				MissingIcon = {
					type = 'toggle',
					name = L['Show Warning Icon'],
					order = 2,
					desc = '',
					get = function() return E.db.sle.Armory.Inspect.MissingIcon end,
					set = function(_, value)
						E.db.sle.Armory.Inspect.MissingIcon = value
						
						if InspectArmory.LastDataSetting then
							InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
						end
						InspectArmory:Update_Display(true)
					end,
					disabled = function() return not E.db.sle.Armory.Inspect.Enable or not E.db.sle.Armory.Inspect.NoticeMissing end,
				},
				Backdrop = {
					type = 'group',
					name = L['Backdrop'],
					order = 3,
					guiInline = true,
					args = {
						SelectedBG = {
							type = 'select',
							name = L['Select Image'],
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
							name = L['Custom Image Path'],
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
					name = L['Gradient'],
					order = 5,
					guiInline = true,
					args = {
						Display = {
							type = 'toggle',
							name = L['Enable'],
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
							name = L['Gradient Texture Color'],
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
					name = L['Item Level'],
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
							name = L['Visibility'],
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
							name = L['Upgrade Level'],
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
							name = L['Font'],
							order = 4,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = L['Font Size'],
							order = 5,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = L['Font Outline'],
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
					name = L['Enchant String'],
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
							name = L['Visibility'],
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
							name = L['Warning Size'],
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
							name = L['Warning Only As Icons'],
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
							name = L['Font'],
							order = 5,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontSize = {
							type = 'range',
							name = L['Font Size'],
							order = 6,
							desc = '',
							min = 6,
							max = 22,
							step = 1,
							disabled = function() return E.db.sle.Armory.Inspect.Enable == false end
						},
						FontStyle = {
							type = 'select',
							name = L['Font Outline'],
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
					name = L['Gem Sockets'],
					order = 11,
					guiInline = true,
					get = function(Info) return E.db.sle.Armory.Inspect[(Info[#Info - 1])][(Info[#Info])] end,
					args = {
						Display = {
							type = 'select',
							name = L['Visibility'],
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
							name = L['Socket Size'],
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
							name = L['Warning Size'],
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