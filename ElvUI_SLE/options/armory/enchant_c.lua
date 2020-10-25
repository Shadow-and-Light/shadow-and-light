local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Misc')

local EnchantStringName, EnchantString_Old, EnchantString_New = '', '', ''
local SelectedEnchantString

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory.args.enchantString = {
		type = 'group',
		name = L["Enchant String"],
		order = 40,
		disabled = function() return not (E.db.sle.armory.character.enable and E.db.sle.armory.inspect.enable) end,
		hidden = function() return not E.private.skins.blizzard.enable or (not E.private.skins.blizzard.character and not E.private.skins.blizzard.inspect) end,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				type = 'toggle',
				get = function(info) return E.db.sle.armory.enchantString[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.enchantString[(info[#info])] = value; M:UpdateCharacterInfo(); M:UpdateInspectInfo() end,
			},
			replacement = {
				order = 2,
				name = L["String Replacement"],
				type = 'toggle',
				get = function(info) return E.db.sle.armory.enchantString[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.enchantString[(info[#info])] = value; M:UpdateCharacterInfo(); M:UpdateInspectInfo() end,
			},
			spacer1 = ACH:Spacer(9),
			ConfigSpace = {
				type = 'group',
				name = L["String Replacement"],
				order = 10,
				guiInline = true,
				args = {
					createString = {
						order = 1,
						name = L["Create Filter"],
						type = 'input',
						width = 'full',
						get = function() return EnchantStringName end,
						set = function(_, value)
							EnchantStringName = value
						end,
						disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end
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
								EnchantStringName = ''
							end
						end,
						disabled = function()
							return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) or EnchantStringName == ''
						end
					},
					List = {
						type = 'select',
						name = L["List of Strings"],
						order = 4,
						get = function() return SelectedEnchantString end,
						set = function(_, value)
							SelectedEnchantString = value
							E.Options.args.sle.args.modules.args.armory.args.enchantString.args.ConfigSpace.args.StringGroup.name = L["List of Strings"]..':  '..value
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
						disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end
					},
					spacer1 = ACH:Spacer(5, 'half'),
					StringGroup = {
						type = 'group',
						name = '',
						order = 8,
						guiInline = true,
						hidden = function()
							return SelectedEnchantString == ''
						end,
						args = {
							TargetString = {
								type = 'input',
								name = L["Original String"],
								order = 1,
								desc = '',
								width = 'full',
								get = function() return SLE_ArmoryDB.EnchantString[SelectedEnchantString]['original'] end,
								set = function(_, value)
									SLE_ArmoryDB.EnchantString[SelectedEnchantString]['original'] = value

									if _G.CharacterArmory then
										_G.CharacterArmory:Update_Gear()
									end

									if _G.InspectArmory and _G.InspectArmory.LastDataSetting then
										_G.InspectArmory:InspectFrame_DataSetting(_G.InspectArmory.CurrentInspectData)
									end
								end,
								disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end
							},
							NewString = {
								type = 'input',
								name = L["New String"],
								order = 2,
								desc = '',
								width = 'full',
								get = function() return SLE_ArmoryDB.EnchantString[SelectedEnchantString]['new'] end,
								set = function(_, value)
									SLE_ArmoryDB.EnchantString[SelectedEnchantString]['new'] = value

									if _G.CharacterArmory then
										_G.CharacterArmory:Update_Gear()
									end

									if _G.InspectArmory and _G.InspectArmory.LastDataSetting then
										_G.InspectArmory:InspectFrame_DataSetting(_G.InspectArmory.CurrentInspectData)
									end
								end,
								disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end
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
										if _G.CharacterArmory then
											_G.CharacterArmory:Update_Gear()
										end

										if _G.InspectArmory and _G.InspectArmory.LastDataSetting then
											_G.InspectArmory:InspectFrame_DataSetting(_G.InspectArmory.CurrentInspectData)
										end
									end
								end,
								disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end,
							},
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
