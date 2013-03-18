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
	AllClasses = "All Classes",
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
local function buffWatch(filter)
	if filter == "AllClasses" and selectedAuthor == "Affinitii" then
		E.global.unitframe.buffwatch["PRIEST"] = {
			{["point"] = "LEFT",["displayText"] = true,["yOffset"] = 2,["style"] = "NONE",["textColor"] = {["g"] = 0,["b"] = 0,},},
			{["point"] = "TOPRIGHT",["style"] = "texturedIcon",},
			{["enabled"] = false,},{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},nil,
			{["enabled"] = false,},{["enabled"] = false,},{["enabled"] = false,},
			{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMLEFT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 47753,},
			{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 114908,},
		}
		E.global.unitframe.buffwatch["DRUID"] = {
			{["point"] = "TOPLEFT",["displayText"] = true,["style"] = "NONE",}, -- [1]
			{["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",
			},{["point"] = "BOTTOMRIGHT",["displayText"] = true,["textThreshold"] = 5,["yOffset"] = 12,["style"] = "texturedIcon",},
			{["point"] = "TOPRIGHT",["displayText"] = true,["textThreshold"] = 3,["style"] = "texturedIcon",},
		}
		E.global.unitframe.buffwatch["MONK"] = {
			{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},{["enabled"] = false,},
			{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",},
			{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",},
			{["enabled"] = true,["anyUnit"] = false,["point"] = "TOPRIGHT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,
			},["id"] = 115175,["displayText"] = false,["style"] = "texturedIcon",["yOffset"] = 0,},
		}
		E.global.unitframe.buffwatch["SHAMAN"] = {
			{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",},
			{["point"] = "BOTTOMRIGHT",["yOffset"] = 10,["style"] = "texturedIcon",},
			{["point"] = "TOPLEFT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},
		}
		ReloadUI();
	elseif selectedAuthor == "Affintii" then
		if filter == "Priest" then
			E.global.unitframe.buffwatch["PRIEST"] = {
				{["point"] = "LEFT",["displayText"] = true,["yOffset"] = 2,["style"] = "NONE",["textColor"] = {["g"] = 0,["b"] = 0,},},
				{["point"] = "TOPRIGHT",["style"] = "texturedIcon",},
				{["enabled"] = false,},{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},nil,
				{["enabled"] = false,},{["enabled"] = false,},{["enabled"] = false,},
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMLEFT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 47753,},
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 114908,},
			}
			ReloadUI();
		elseif filter == "Druid" then
			E.global.unitframe.buffwatch["DRUID"] = {
				{["point"] = "TOPLEFT",["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",
				},{["point"] = "BOTTOMRIGHT",["displayText"] = true,["textThreshold"] = 5,["yOffset"] = 12,["style"] = "texturedIcon",},
				{["point"] = "TOPRIGHT",["displayText"] = true,["textThreshold"] = 3,["style"] = "texturedIcon",},
			}
			ReloadUI();
		elseif filter == "Monk" then
			E.global.unitframe.buffwatch["MONK"] = {
				{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},{["enabled"] = false,},
				{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",},
				{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["yOffset"] = 8,["style"] = "NONE",},
				{["enabled"] = true,["anyUnit"] = false,["point"] = "TOPRIGHT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,
				},["id"] = 115175,["displayText"] = false,["style"] = "texturedIcon",["yOffset"] = 0,},
			}
			ReloadUI();
		elseif filter == "Shaman" then
			E.global.unitframe.buffwatch["SHAMAN"] = {
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",},
				{["point"] = "BOTTOMRIGHT",["yOffset"] = 10,["style"] = "texturedIcon",},
				{["point"] = "TOPLEFT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",},
			}
			ReloadUI();
		else
			print("There is no filter for the class specified.")
		end
	else
		print("This author doesn't have a filter import for that option.")
	end
end

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
			selectedClass = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					description = {
						order = 2,
						type = "description",
						name = L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."],
					},
					selectClass = {
						name = L["Select Filter"],
						type = 'select',
						order = 4,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							class['1Filter'] = "General Filters"
							for k, v in pairs(classes) do
								class[k] = v
							end

							return class
						end,
					},
					spacer = {
						order = 6,
						type = 'description',
						name = '',
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			selectedClass = nil
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					AllAddons = {
						type = 'execute',
						order = 2,
						name = L['Import All'],
						func = function(info, value) AI:LoadAddons("Affinitii, All"); ReloadUI(); end,
					},
					--BigWigs = {
					--	type = 'execute',
					--	order = 3,
					--	name = "Big Wigs",
					--	func = function(info, value) AI:LoadAddons("Affinitii, BigWigs"); ReloadUI(); end,
					--},
					--Hermes = {
					--	type = 'execute',
					--	order = 4,
					--	name = "Hermes",
					--	func = function(info, value) AI:LoadAddons("Affinitii, Hermes"); ReloadUI(); end,
					--},
					--xCT = {
					--	type = 'execute',
					--	order = 5,
					--	name = "xCT+",
					--	func = function(info, value) AI:LoadAddons("Affinitii, xCT+,"); ReloadUI(); end,
					--},
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
					description = {
						order = 2,
						type = "description",
						name = L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."],
					},
					selectClass = {
						name = L["Select Filter"],
						type = 'select',
						order = 4,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							class['1Filter'] = "General Filters"
							for k, v in pairs(classes) do
								class[k] = v
							end

							return class
						end,
					},
					spacer = {
						order = 6,
						type = 'description',
						name = '',
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					repoocinfo = {
						type = "description",
						order = 2,
						name = selectedAuthor..' '..L["has no data for this selected option."],
					},
				--[[
					BigWigs = {
						type = 'execute',
						order = 2,
						name = "Big Wigs",
						func = function(info, value) AI:LoadAddons("Affinitii, BigWigs"); end,
					},
					Hermes = {
						type = 'execute',
						order = 2,
						name = "Hermes",
						func = function(info, value) AI:LoadAddons("Affinitii, Hermes"); end,
					},
					xCT = {
						type = 'execute',
						order = 2,
						name = "xCT+",
						func = function(info, value) AI:LoadAddons("Affinitii, xCT+"); end,
					},]]
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
					description = {
						order = 2,
						type = "description",
						name = L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."],
					},
					selectClass = {
						name = L["Select Filter"],
						type = 'select',
						order = 4,
						guiInline = true,
						get = function(info) return selectedClass end,
						set = function(info, value) selectedClass = value; UpdateAuthor(); end,							
						values = function()
							local class = {}
							class[''] = NONE
							class['1Filter'] = "General Filters"
							for k, v in pairs(classes) do
								class[k] = v
							end

							return class
						end,
					},
					spacer = {
						order = 6,
						type = 'description',
						name = '',
					},
				},
			}
			if not selectedClass or selectedClass == '' then
				E.Options.args.sle.args.importing.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.optionGroup = {
				type = "group",
				name = selectedOption,
				order = 15,
				guiInline = true,
				args = {
					xCT = {
						type = 'execute',
						order = 2,
						name = "xCT+",
						func = function(info, value) AI:LoadAddons("Darth, All"); end,
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
		name = L['Import Options'],
		order = 300,
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
				get = function(info) if selectedAuthor == nil then return 'None' else return selectedAuthor end end,
				set = function(info, value) if value == '' then selectedAuthor = nil; selectedClass = nil; selectedOption = nil; else selectedAuthor = value; selectedOption = nil; selectedClass = nil; end; UpdateAuthor() end,							
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