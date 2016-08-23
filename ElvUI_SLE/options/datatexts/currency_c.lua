local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 

local function configTable()
	if not SLE.initialized then return end

	local function OrderedPairs(t, f)
		local function orderednext(t, n)
			local key = t[t.__next]
			if not key then return end
			t.__next = t.__next + 1
			return key, t.__source[key]
		end

		local keys, kn = {__source = t, __next = 1}, 1
		for k in pairs(t) do
			keys[kn], kn = k, kn + 1
		end
		sort(keys, f)
		return orderednext, keys
	end


	local function CreateCurrencyConfig(i, text, name)
		local config = {
			order = i, type = "toggle", name = text,
			get = function(info) return E.db.sle.dt.currency[name] end,
			set = function(info, value) E.db.sle.dt.currency[name] = value; end,
		}
		return config
	end
	
	local function CreateCustomToonList()
		local config = {
			name = CUSTOM,
			order = 3,
			type = "group",
			guiInline = true,
			hidden = function() return E.db.sle.dt.currency.gold.method ~= "order" end,
			args = {
				info = {
					order = 1,
					type = "description",
					name = L["Order of each toon. Smaller numbers will go first"],
				},
			},
		}
		for k,_ in T.pairs(ElvDB["gold"][E.myrealm]) do
			config.args[k] = {
				type = "select",
				name = k,
				order = 10,
				width = "half",
				get = function(info) return (E.private.sle.characterGoldsSorting[E.myrealm][k] or 1) end,
				set = function(info, value) E.private.sle.characterGoldsSorting[E.myrealm][k] = value end,
				values = {
					[1] = "1",
					[2] = "2",
					[3] = "3",
					[4] = "4",
					[5] = "5",
					[6] = "6",
					[7] = "7",
					[8] = "8",
					[9] = "9",
					[10] = "10",
					[11] = "11",
					[12] = "12",
				},
			}
		end
		return config
	end

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slcurrency = {
		type = "group",
		name = "S&L Currency",
		order = 2,
		args = {
			header = {
				order = 1, type = "description", name = L["ElvUI Improved Currency Options"],
			},
			arch = CreateCurrencyConfig(2, L["Show Archaeology Fragments"], 'Archaeology'),
			jewel = CreateCurrencyConfig(3, L["Show Jewelcrafting Tokens"], 'Jewelcrafting'),
			pvp = CreateCurrencyConfig(4, L["Show Player vs Player Currency"], 'PvP'),
			dungeon = CreateCurrencyConfig(5, L["Show Dungeon and Raid Currency"], 'Raid'),
			cook = CreateCurrencyConfig(6, L["Show Cooking Awards"], 'Cooking'),
			misc = CreateCurrencyConfig(7, L["Show Miscellaneous Currency"], 'Miscellaneous'),
			zero = CreateCurrencyConfig(8, L["Show Zero Currency"], 'Zero'),
			icons = CreateCurrencyConfig(9, L["Show Icons"], 'Icons'),
			faction = CreateCurrencyConfig(10, L["Show Faction Totals"], 'Faction'),
			unused = CreateCurrencyConfig(11, L["Show Unsed Currency"], 'Unused'),
			delete = {
				order = 12,
				type = "select",
				name = L["Delete character info"],
				desc = L["Remove selected character from the stored gold values"],
				values = function()
					local names = {};
					for rk,_ in OrderedPairs(ElvDB['gold']) do
						for k,_ in OrderedPairs(ElvDB['gold'][rk]) do
							if ElvDB['gold'][rk][k] then
								local name = T.format("%s-%s", k, rk);
								names[name] = name;
							end
						end
					end
					return names;
				end,
				set = function(info, value) 
					local name, realm = strsplit("-", value);
					E.PopupDialogs['SLE_CONFIRM_DELETE_CURRENCY_CHARACTER'].text = T.format(L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"], name..(realm and "-"..realm or ""))
					E:StaticPopup_Show('SLE_CONFIRM_DELETE_CURRENCY_CHARACTER', nil, nil, { ["name"] = name, ["realm"] = realm });
				end,
			},
			sortGold = {
				order = 30,
				name = L["Gold Sorting"],
				type = "group",
				guiInline = true,
				get = function(info) return E.db.sle.dt.currency.gold[ info[#info] ] end,
				set = function(info, value) E.db.sle.dt.currency.gold[ info[#info] ] = value; end,
				args = {
					direction = {
						order = 1,
						type = "select",
						name = L["Sort Direction"],
						width = "half",
						values = {
							["normal"] = L["Normal"],
							["reverced"] = L["Reverced"],
						},
					},
					method = {
						order = 2,
						type = "select",
						name = L["Sort Method"],
						width = "half",
						values = {
							["name"] = NAME,
							["amount"] = L["Amount"],
							["order"] = CUSTOM,
						},
					},
					customSort = CreateCustomToonList(),
				},
			},
			sortCurrency = {
				order = 31,
				name = L["Currency Sorting"],
				type = "group",
				guiInline = true,
				get = function(info) return E.db.sle.dt.currency.cur[ info[#info] ] end,
				set = function(info, value) E.db.sle.dt.currency.cur[ info[#info] ] = value; end,
				args = {
					direction = {
						order = 1,
						type = "select",
						name = L["Direction"],
						width = "half",
						values = {
							["normal"] = L["Normal"],
							["reverced"] = L["Reverced"],
						},
					},
					method = {
						order = 2,
						type = "select",
						name = L["Sort Method"],
						width = "half",
						values = {
							["name"] = NAME,
							["amount"] = L["Amount"],
							["r1"] = L["Tracked"],
						},
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)