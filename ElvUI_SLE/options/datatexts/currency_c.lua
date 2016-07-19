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
		},
	}
end

T.tinsert(SLE.Configs, configTable)