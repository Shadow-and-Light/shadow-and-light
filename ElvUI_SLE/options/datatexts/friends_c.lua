local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DTP = SLE.Datatexts
local DT = E.DataTexts

local friendStyleTable = {}

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slfriends = {
		type = 'group',
		name = L["S&L Friends"],
		order = 3,
		args = {
			desc = ACH:Description(L["These options are for modifying the Shadow & Light Friends datatext."], 1, 'large'),
			tooltip = {
				order = 2,
				name = L["General Settings"],
				type = 'group',
				guiInline = true,
				-- get = function(info) return E.db.sle.dt.currency.gold[ info[#info] ] end,
				-- set = function(info, value) E.db.sle.dt.currency.gold[ info[#info] ] = value end,
				args = {
					panelStyle = {
						order = 1,
						type = 'select',
						name = L["Style"],
						values = function()
							wipe(friendStyleTable)
							local color = E.db.general.valuecolor
							local hexColor = E:RGBToHex(color.r, color.g, color.b)

							for key, value in pairs(DTP.PanelStyles) do
								if key == 'DEFAULT' then
									friendStyleTable[key] = format(value, L["FRIENDS"], hexColor, '##')
								elseif key == 'DEFAULTTOTALS' then
									friendStyleTable[key] = format(value, L["FRIENDS"], hexColor, '##', '##')
								elseif key == 'ICON' then
									friendStyleTable[key] = format(value, '|TInterface\\ICONS\\Achievement_Reputation_01:12|t', hexColor, '##')
								elseif key == 'ICONTOTALS' then
									friendStyleTable[key] = format(value, '|TInterface\\ICONS\\Achievement_Reputation_01:12|t', hexColor, '##', '##')
								elseif key == 'NOTEXTTOTALS' then
									friendStyleTable[key] = format(value, hexColor, '##', '##')
								elseif key == 'NOTEXT' then
									friendStyleTable[key] = format(value, hexColor, '##')
								end
							end

							return friendStyleTable
						end,
						get = function(info) return E.db.sle.dt.friends[info[#info]]  end,
						set = function(info, value) E.db.sle.dt.friends[info[#info]] = value; DT:LoadDataTexts() end,
					},
					tooltipAutohide = {
						order = 2,
						type = 'range',
						name = L["Autohide Delay:"],
						desc = L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."],
						min = 0.1, max = 1, step = 0.1,
						get = function(_) return E.db.sle.dt.friends.tooltipAutohide end,
						set = function(_, value) E.db.sle.dt.friends.tooltipAutohide = value end,
					},
					combat = {
						order = 3,
						type = 'toggle',
						name = L["Hide In Combat"],
						desc = L["Will not show the tooltip while in combat."],
						get = function(_) return E.db.sle.dt.friends.combat end,
						set = function(_, value) E.db.sle.dt.friends.combat = value end,
					},
					hide_hintline = {
						order = 3,
						type = 'toggle',
						name = L["Hide Hints"],
						desc = L["Hide the hints in the tooltip."],
						get = function(_) return E.db.sle.dt.friends.hide_hintline end,
						set = function(_, value) E.db.sle.dt.friends.hide_hintline = value end,
					},
					hide_titleline = {
						order = 3,
						type = 'toggle',
						name = L["Hide Title"],
						get = function(_) return E.db.sle.dt.friends.hide_titleline end,
						set = function(_, value) E.db.sle.dt.friends.hide_titleline = value end,
					},
				},
			},
			hideGroup2 = {
				order = 11,
				type = 'multiselect',
				name = L["Hide by Application"],
				get = function(_, key) return E.db.sle.dt.friends['hide'..key] end,
				set = function(_, key, value) E.db.sle.dt.friends['hide'..key] = value end,
				sortByValue = true,
				values = {
					['WoW'] = 'WoW (Retail)',
					['WoWClassic'] = 'WoW (Classic)',
					['App'] = 'App',
					['BSAp'] = L["Mobile"],
					['D3'] = 'Diablo 3',
					['WTCG'] = 'Hearthstone',
					['Hero'] = 'Heroes of the Storm',
					['Pro'] = 'Overwatch',
					['S1'] = 'Starcraft',
					['S2'] = 'Starcraft 2',
					['VIPR'] = 'COD: Black Ops 4',
					['ODIN'] = 'COD: Modern Warfare',
					['LAZR'] = 'COD: Modern Warfare 2',
					ZEUS = 'COD: Cold War',
				},
			},
			hideGroup3 = {
				order = 13,
				type = 'multiselect',
				name = L["Hide by Status"],
				get = function(_, key) return E.db.sle.dt.friends[key] end,
				set = function(_, key, value) E.db.sle.dt.friends[key] = value end,
				values = {
					hideAFK = L["AFK"],
					hideDND = L["DND"],
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
