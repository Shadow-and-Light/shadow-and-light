local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = E.Misc
local Armory = SLE.Armory_Core

local EnchantStringName = ''
local SelectedEnchantString

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory.args.enchantString = {
		order = 40,
		type = 'group',
		name = L["Enchant String"],
		disabled = function() return not (E.db.sle.armory.character.enable and E.db.sle.armory.inspect.enable) end,
		hidden = function() return not E.private.skins.blizzard.enable or (not E.private.skins.blizzard.character and not E.private.skins.blizzard.inspect) end,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"],
				get = function(info) return E.db.sle.armory.enchantString[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.enchantString[(info[#info])] = value; M:UpdateCharacterInfo(); M:UpdateInspectInfo() end,
			},
			replacement = {
				order = 2,
				type = 'toggle',
				name = L["String Replacement"],
				get = function(info) return E.db.sle.armory.enchantString[(info[#info])] end,
				set = function(info, value) E.db.sle.armory.enchantString[(info[#info])] = value; M:UpdateCharacterInfo(); M:UpdateInspectInfo() end,
			},
			strict = {
				order = 3,
				type = 'toggle',
				name = L["Strict String Replacement"],
				desc = L["This will make it so that the \"Original String\" needs to match the whole enchant string you want to replace."],
				get = function(info) return E.db.sle.armory.enchantString[(info[#info])] end,
				set = function(info, value)
					E.db.sle.armory.enchantString[(info[#info])] = value
					Armory:UpdateInspectInfo()
					Armory:UpdateCharacterInfo()
				end,
			},
			spacer1 = ACH:Spacer(9),
			ConfigSpace = {
				order = 10,
				type = 'group',
				name = L["String Replacement"],
				guiInline = true,
				args = {
					createString = {
						order = 1,
						type = 'input',
						name = L["Create Filter"],
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
								E.Options.args.sle.args.modules.args.armory.args.enchantString.args.ConfigSpace.args.StringGroup.name = L["List of Strings"]..':  '..SelectedEnchantString
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
						disabled = function() return (E.db.sle.armory.enchantString.enable == false or E.db.sle.armory.enchantString.replacement == false) or (E.db.sle.armory.character.enable == false and E.db.sle.armory.inspect.enable == false) end,
						get = function(info) return SLE_ArmoryDB.EnchantString[SelectedEnchantString][(info[#info])] end,
						set = function(info, value)
							SLE_ArmoryDB.EnchantString[SelectedEnchantString][(info[#info])] = value
							Armory:UpdateInspectInfo()
							Armory:UpdateCharacterInfo()
						end,
						args = {
							original = {
								type = 'input',
								name = L["Original String"],
								order = 1,
								desc = '',
								width = 'full',
							},
							new = {
								type = 'input',
								name = L["New String"],
								order = 2,
								desc = '',
								width = 'full',
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
										Armory:UpdateInspectInfo()
										Armory:UpdateCharacterInfo()
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
