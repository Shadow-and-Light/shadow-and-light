local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller');
local SLE = E:GetModule('SLE');

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
	Warlock = "Warlock",
}
local function buffWatch(filter)
	if filter == "AllClasses" and selectedAuthor == "Affinitii" then
		E['global']['unitframe']['buffwatch'] = {
			["PRIEST"] = {
				{["point"] = "LEFT",["displayText"] = true,["yOffset"] = 2,["style"] = "NONE",["textColor"] = {["g"] = 0,["b"] = 0,},}, -- [1]
				{["point"] = "TOPRIGHT",["style"] = "texturedIcon",}, -- [2]
				{["enabled"] = false,}, -- [3]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [4]
				nil, -- [5]
				{["enabled"] = false,}, -- [6]
				{["enabled"] = false,}, -- [7]
				{["enabled"] = false,}, -- [8]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMLEFT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 47753,}, -- [9]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 114908,}, -- [10]
			},
			["DRUID"] = {
				{["point"] = "TOPLEFT",["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["displayText"] = true,["style"] = "NONE",}, -- [2]
				{["point"] = "BOTTOMRIGHT",["displayText"] = true,["textThreshold"] = 5,["yOffset"] = 12,["style"] = "texturedIcon",}, -- [3]
				{["point"] = "TOPRIGHT",["displayText"] = true,["textThreshold"] = 3,["style"] = "texturedIcon",}, -- [4]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "LEFT",["id"] = 155777,["displayText"] = true,["style"] = "texturedIcon",["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},}, -- [5]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["id"] = 162359,["displayText"] = true,["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},}, -- [6]
			},
			["MONK"] = {
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["enabled"] = false,}, -- [2]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [3]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [4]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "TOPRIGHT",["id"] = 115175,["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = false,["style"] = "texturedIcon",["yOffset"] = 0,}, -- [5]
			},
			["SHAMAN"] = {
				{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["point"] = "BOTTOMRIGHT",["yOffset"] = 10,["style"] = "texturedIcon",}, -- [2]
				{["point"] = "TOPLEFT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",	}, -- [3]
			},
			["PALADIN"] = {
				nil, -- [1]
				{["enabled"] = false,}, -- [2]
				{["enabled"] = false,}, -- [3]
				{["enabled"] = false,}, -- [4]
				{["enabled"] = false,}, -- [5]
				nil, -- [6]
				nil, -- [7]
				{["anyUnit"] = false,["point"] = "TOPRIGHT",["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [8]
			},
		}
		ReloadUI();
	elseif selectedAuthor == "Affintii" then
		if filter == "Priest" then
			E.global.unitframe.buffwatch["PRIEST"] = {
				{["point"] = "LEFT",["displayText"] = true,["yOffset"] = 2,["style"] = "NONE",["textColor"] = {["g"] = 0,["b"] = 0,},}, -- [1]
				{["point"] = "TOPRIGHT",["style"] = "texturedIcon",}, -- [2]
				{["enabled"] = false,}, -- [3]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [4]
				nil, -- [5]
				{["enabled"] = false,}, -- [6]
				{["enabled"] = false,}, -- [7]
				{["enabled"] = false,}, -- [8]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMLEFT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 47753,}, -- [9]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["textThreshold"] = -1,["yOffset"] = 8,["style"] = "NONE",["id"] = 114908,}, -- [10]
			}
			ReloadUI();
		elseif filter == "Druid" then
			E.global.unitframe.buffwatch["DRUID"] = {
				{["point"] = "TOPLEFT",["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["displayText"] = true,["style"] = "NONE",}, -- [2]
				{["point"] = "BOTTOMRIGHT",["displayText"] = true,["textThreshold"] = 5,["yOffset"] = 12,["style"] = "texturedIcon",}, -- [3]
				{["point"] = "TOPRIGHT",["displayText"] = true,["textThreshold"] = 3,["style"] = "texturedIcon",}, -- [4]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "LEFT",["id"] = 155777,["displayText"] = true,["style"] = "texturedIcon",["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},}, -- [5]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "BOTTOMRIGHT",["id"] = 162359,["displayText"] = true,["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},}, -- [6]
			}
			ReloadUI();
		elseif filter == "Monk" then
			E.global.unitframe.buffwatch["MONK"] = {
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["enabled"] = false,}, -- [2]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [3]
				{["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [4]
				{["enabled"] = true,["anyUnit"] = false,["point"] = "TOPRIGHT",["id"] = 115175,["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = false,["style"] = "texturedIcon",["yOffset"] = 0,}, -- [5]
			}
			ReloadUI();
		elseif filter == "Shaman" then
			E.global.unitframe.buffwatch["SHAMAN"] = {
				{["color"] = {["r"] = 1,["g"] = 1,["b"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [1]
				{["point"] = "BOTTOMRIGHT",["yOffset"] = 10,["style"] = "texturedIcon",}, -- [2]
				{["point"] = "TOPLEFT",["color"] = {["b"] = 1,["g"] = 1,["r"] = 1,},["displayText"] = true,["style"] = "NONE",	}, -- [3]
			}
			ReloadUI();
		elseif filter == "Paladin" then
			E.global.unitframe.buffwatch["PALADIN"] = {
				nil, -- [1]
				{["enabled"] = false,}, -- [2]
				{["enabled"] = false,}, -- [3]
				{["enabled"] = false,}, -- [4]
				{["enabled"] = false,}, -- [5]
				nil, -- [6]
				nil, -- [7]
				{["anyUnit"] = false,["point"] = "TOPRIGHT",["color"] = {["b"] = 0,["g"] = 0,["r"] = 1,},["displayText"] = true,["style"] = "NONE",}, -- [8]
			}
			ReloadUI();
		else
			print("There is no filter for the class specified.")
		end
	elseif filter == "1Filter" then
		E['global']['unitframe']["aurafilters"]["TurtleBuffs"] = {
			["spells"] = {
				["Alter Time"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Elusive Brew"] = {
					["enable"] = false,
					["priority"] = 99,
				},
			},
		}
		E['global']['unitframe']["aurafilters"]["Blacklist"] = {
			["spells"] = {
				["Bright Light"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Keen Eyesight"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Clear Mind"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Blue Rays"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Inferno Breath"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Infrared Light"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Unleashed Anima"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Dark Winds"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Fully Mutated"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Improved Synapses"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Thick Bones"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Recently Bandaged"] = {
					["enable"] = true,
					["priority"] = 0,
				},
				["Blue Timer"] = {
					["enable"] = true,
					["priority"] = 0,
				},
			},
		},
		ReloadUI();
	else
		print("This author doesn't have a filter import for that option.")
	end
end

local function UpdateAuthor()
	if selectedAuthor == 'Affinitii' then
		if not selectedAuthor then
			E.Options.args.sle.args.importing.args.authors.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authors.args.authorGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			selectedClass = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			selectedClass = nil
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authors.args.authorGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			return
		end
	
		E.Options.args.sle.args.importing.args.authors.args.authorGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
			return
		end
		
		if selectedOption == 'Filters' then
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = nil
				return
			end
			E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.class = {
				type = 'execute',
				order = 5,
				name = L["Import"],
				func = function(info, value) buffWatch(selectedClass) end,
			}
			if selectedClass == '1Filter' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import non class specific filters from this author."],
				}
			elseif selectedClass == 'AllClasses' then
				E.Options.args.sle.args.importing.args.authors.args.optionGroup.args.filterInfo = {
					type = "description",
					order = 7,
					name = L["This will import All Class specific filters from this author."],
				}
			end
		elseif selectedOption == 'Addons' then
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = {
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
			E.Options.args.sle.args.importing.args.authors.args.authorGroup = nil
			E.Options.args.sle.args.importing.args.authors.args.optionGroup = nil
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
				name = L['Import Options'],
			},
			--[[export = {
				order = 2,
				type = 'group',
				name = L["Export / Import"],
				guiInline = true,
				args = {
					description = {
						order = 1,
						type = "description",
						name = L["SLE_EXPORTS"],
					},
					profile = {
						order = 2,
						type = "toggle",
						name = L["Profile"],
						get = function(info) return E.global.sle.export.profile end,
						set = function(info, value)	E.global.sle.export.profile = value end,
					},
					private = {
						order = 3,
						type = "toggle",
						name = L["Private"],
						get = function(info) return E.global.sle.export.private end,
						set = function(info, value)	E.global.sle.export.private = value end,
					},
					global = {
						order = 4,
						type = "toggle",
						name = L["Global"],
						get = function(info) return E.global.sle.export.global end,
						set = function(info, value)	E.global.sle.export.global = value end,
					},
					full = {
						order = 5,
						type = "toggle",
						name = L["Full tables"],
						get = function(info) return E.global.sle.export.full end,
						set = function(info, value)	E.global.sle.export.full = value end,
					},
					space = {
						order = 6,
						type = 'description',
						name = "",
					},
					export = {
						type = 'execute',
						order = 7,
						name = L["Export"],
						func = function(info, value) SLE:OpenExport() end,
					},
				},
			},]]
			authors = {
				order = 3,
				type = 'group',
				name = L["Author Specific Imports"],
				guiInline = true,
				args = {
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
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)