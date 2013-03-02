local E, L, V, P, G, _ = unpack(ElvUI);
local AI = E:GetModule('AddonInstaller');

local selectedAuthor
local selectedClass
local selectedOption
local authors
local options = {
	Filters = "Filters",
	Addons = "Addons",
}
local classes = {
	Priest = "Priest",
	Druid = "Druid",
	Paladin = "Paladin",
	Shaman = "Shaman",
	Monk = "Monk",
	Rogue = "Rogue",
	Mage = "Mage",
	Warrior = "Warrior",
	Deathknight = "Deathknight",
}
local addons = {
	
}

local function UpdateAuthor()
	if selectedAuthor == 'Affinitii' then
		if not selectedAuthor then
			E.Options.args.sle.args.importing.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authorGroup = {
			type = 'group',
			name = selectedAuthor,
			guiInline = true,
			order = 10,
			args = {
				importOptions = {
					name = L["Import Options"],
					type = 'select',
					order = 1,
					guiInline = true,
					get = function(info) return selectedOption end,
					set = function(info, value) selectedOption = value; UpdateAuthor(); end,							
					values = function()
						local option = {}
						option[''] = NONE
						for k in pairs(options) do
							option[k] = k
						end

						return option
					end,
				},		
			},	
		}
		if not selectedOption or selectedOption == '' then
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					selectClass = {
						name = L["Select Class"],
						type = 'select',
						order = 1,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							for k in pairs(classes) do
								class[k] = k
							end

							return class
						end,
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 2,
				name = L["Import"]..' '..selectedClass,
				func = function(info, value)
				if selectedClass == "Monk" then
					E.global.unitframe.buffwatch.MONK = {
						{
							["color"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["displayText"] = true,
							["style"] = "NONE",
						}, -- [1]
						{
							["enabled"] = false,
						}, -- [2]
						{
							["color"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["displayText"] = true,
							["yOffset"] = 8,
							["style"] = "NONE",
						}, -- [3]
						{
							["color"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["displayText"] = true,
							["yOffset"] = 8,
							["style"] = "NONE",
						}, -- [4]
						{
							["enabled"] = true,
							["anyUnit"] = false,
							["point"] = "TOPRIGHT",
							["color"] = {
								["b"] = 1,
								["g"] = 1,
								["r"] = 1,
							},
							["id"] = 115175,
							["displayText"] = false,
							["style"] = "texturedIcon",
							["yOffset"] = 0,
						}, -- [5]
					}
					else
						print("class not monk")
					end
				end,
			}
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					BigWigs = {
						type = 'execute',
						order = 2,
						name = L['Big Wigs'],
						func = function(info, value) AI:LoadAddons("Affinitii, BigWigs"); end,
					},
					Hermes = {
						type = 'execute',
						order = 2,
						name = L['Hermes'],
						func = function(info, value) AI:LoadAddons("Affinitii, Hermes"); end,
					},
					xCT = {
						type = 'execute',
						order = 2,
						name = L['xCT+'],
						func = function(info, value) AI:LoadAddons("Affinitii, xCT+"); end,
					},
				},
			}
		end
	elseif selectedAuthor == 'Repooc' then
		if not selectedAuthor then
			E.Options.args.sle.args.importing.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authorGroup = {
			type = 'group',
			name = selectedAuthor,
			guiInline = true,
			order = 10,
			args = {
				importOptions = {
					name = L["Import Options"],
					type = 'select',
					order = 1,
					guiInline = true,
					get = function(info) return selectedOption end,
					set = function(info, value) selectedOption = value; UpdateAuthor(); end,							
					values = function()
						local option = {}
						option[''] = NONE
						for k in pairs(options) do
							option[k] = k
						end

						return option
					end,
				},		
			},	
		}
		if not selectedOption or selectedOption == '' then
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					selectClass = {
						name = L["Select Class"],
						type = 'select',
						order = 1,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							for k in pairs(classes) do
								class[k] = k
							end

							return class
						end,
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 2,
				name = L["Import"]..' '..selectedClass,
				func = function(info, value) --[[UF:Update_AllFrames()]] end,
			}
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					BigWigs = {
						type = 'execute',
						order = 2,
						name = L['Big Wigs'],
						func = function(info, value) AI:LoadAddons("Affinitii, BigWigs"); end,
					},
					Hermes = {
						type = 'execute',
						order = 2,
						name = L['Hermes'],
						func = function(info, value) AI:LoadAddons("Affinitii, Hermes"); end,
					},
					xCT = {
						type = 'execute',
						order = 2,
						name = L['xCT+'],
						func = function(info, value) AI:LoadAddons("Affinitii, xCT+"); end,
					},
				},
			}
		end
	elseif selectedAuthor == 'Darth' then
		if not selectedAuthor then
			E.Options.args.sle.args.importing.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authorGroup = {
			type = 'group',
			name = selectedAuthor,
			guiInline = true,
			order = 10,
			args = {
				importOptions = {
					name = L["Import Options"],
					type = 'select',
					order = 1,
					guiInline = true,
					get = function(info) return selectedOption end,
					set = function(info, value) selectedOption = value; UpdateAuthor(); end,							
					values = function()
						local option = {}
						option[''] = NONE
						for k in pairs(options) do
							option[k] = k
						end

						return option
					end,
				},		
			},	
		}
		if not selectedOption or selectedOption == '' then
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					selectClass = {
						name = L["Select Class"],
						type = 'select',
						order = 1,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							for k in pairs(classes) do
								class[k] = k
							end

							return class
						end,
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 2,
				name = L["Import"]..' '..selectedClass,
				func = function(info, value) --[[UF:Update_AllFrames()]] end,
			}
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					BigWigs = {
						type = 'execute',
						order = 2,
						name = L['Big Wigs'],
						func = function(info, value) AI:LoadAddons("Affinitii, BigWigs"); end,
					},
					Hermes = {
						type = 'execute',
						order = 2,
						name = L['Hermes'],
						func = function(info, value) AI:LoadAddons("Affinitii, Hermes"); end,
					},
					xCT = {
						type = 'execute',
						order = 2,
						name = L['xCT+'],
						func = function(info, value) AI:LoadAddons("Affinitii, xCT+"); end,
					},
				},
			}
		end
	else
		if not selectedAuthor or selectedAuthor == "" then
			E.Options.args.sle.args.importing.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.optionGroup = nil
			return
		end	
	end
end

local function configTable()
	E.Options.args.sle.args.importing = {
		type = 'group',
		name = L['Extra Importing'],
		order = 199,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Author Specific Imports"],
			},
			description = {
				order = 2,
				type = "description",
				name = L["SLE_IMPORTS"],
			},
			selectAuthor = {
				order = 3,
				type = 'select',
				name = L['Select Author'],
				get = function(info) return selectedAuthor end,
				set = function(info, value) if value == '' then selectedAuthor = value; selectedClass = nil; selectedOption = nil; else selectedAuthor = value end; UpdateAuthor() end,							
				values = function()
					local authors = {}
					authors[''] = NONE
					
					authors['Affinitii'] = 'Affinitii'
					authors['Repooc'] = 'Repooc'
					authors['Darth'] = 'Darth'
					return authors
				end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)