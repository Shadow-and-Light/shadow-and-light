local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local UB = SLE.UIButtons

--  GLOBALS: unpack, select, tinsert, pairs, type, ADDONS, DEFAULT, NONE, CUSTOM
local CUSTOM, NONE, DEFAULT = CUSTOM, NONE, DEFAULT
local ADDONS = ADDONS

local stratas = {
	BACKGROUND = '1. Background',
	LOW = '2. Low',
	MEDIUM = '3. Medium',
	HIGH = '4. High',
	DIALOG = '5. Dialog',
	FULLSCREEN = '6. Fullscreen',
	FULLSCREEN_DIALOG = '7. Fullscreen Dialog',
	TOOLTIP = '8. Tooltip',
}

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH
	local Bar = UB.Holder

	E.Options.args.sle.args.modules.args.uibuttons = {
		order = 1,
		type = 'group',
		name = L["UI Buttons"],
		args = {
			header = ACH:Header(L["UI Buttons"], 1),
			desc = ACH:Description(L["UB_DESC"], 2),
			enable = {
				order = 3,
				type = 'toggle',
				name = L["Enable"],
				desc = L["Show/Hide UI buttons."],
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:ToggleShow() end
			},
			style = {
				order = 4,
				type = 'select',
				name = L["UI Buttons Style"],
				values = {
					["classic"] = L["Classic"],
					["dropdown"] = L["Dropdown"],
				},
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.private.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.private.sle.uibuttons[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
			},
			advanced = {
				order = 5,
				type = 'group',
				name = L["Advanced Options"],
				guiInline = true,
				get = function(info) return E.private.sle.uibuttons[ info[#info] ]  end,
				set = function(info, value) E.private.sle.uibuttons[ info[#info] ]  = value; E:StaticPopup_Show('PRIVATE_RL') end,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				hidden = function() return not E.global.sle.advanced.general end,
				args = {
					strata = {
						order = 1,
						type = 'select',
						name = L["UI Buttons Strata"],
						values = stratas,
					},
					level = {
						order = 2,
						type = 'range',
						name = L["Frame Level"],
						min = 1, max = 250, step = 1,
					},
					transparent = {
						order = 3,
						type = 'select',
						name = L["Backdrop Template"],
						values = {
							['NO'] = NONE,
							['Default'] = DEFAULT,
							['Transparent'] = L["Transparent"],
						},
					},
				},
			},
			spacer1 = ACH:Spacer(6),
			size = {
				order = 7,
				type = 'range',
				name = L["Size"],
				desc = L["Sets size of buttons"],
				min = 12, max = 25, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			spacing = {
				order = 8,
				type = 'range',
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = -4, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			mouse = {
				order = 9,
				type = 'toggle',
				name = L["Mouseover"],
				desc = L["Show on mouse over."],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:UpdateMouseOverSetting() end,
			},
			menuBackdrop = {
				order = 10,
				type = 'toggle',
				name = L["Backdrop"],
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:UpdateBackdrop() end,
			},
			dropdownBackdrop = {
				order = 11,
				type = 'toggle',
				name = L["Dropdown Backdrop"],
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			orientation = {
				order = 12,
				type = 'select',
				name = L["Buttons position"],
				desc = L["Layout for UI buttons."],
				values = {
					["horizontal"] = L["Horizontal"],
					["vertical"] = L["Vertical"],
				},
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			point = {
				order = 13,
				type = 'select',
				name = L["Anchor Point"],
				desc = L["What point of dropdown will be attached to the toggle button."],
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
				values = T.Values.positionValues,
			},
			anchor = {
				order = 14,
				type = 'select',
				name = L["Attach To"],
				desc = L["What point to anchor dropdown on the toggle button."],
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
				values = T.Values.positionValues,
			},
			xoffset = {
				order = 15,
				type = 'range',
				name = L["X-Offset"],
				desc = L["Horizontal offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			yoffset = {
				order = 16,
				type = 'range',
				name = L["Y-Offset"],
				desc = L["Vertical offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:FrameSize() end,
			},
			minroll = {
				order = 17,
				type = 'input',
				name = L["Minimum Roll Value"],
				desc = L["The lower limit for custom roll button."],
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(_) return E.db.sle.uibuttons.customroll.min end,
				set = function(_, value) E.db.sle.uibuttons.customroll.min = value end,
			},
			maxroll = {
				order = 18,
				type = 'input',
				name = L["Maximum Roll Value"],
				desc = L["The higher limit for custom roll button."],
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				get = function(_) return E.db.sle.uibuttons.customroll.max end,
				set = function(_, value) E.db.sle.uibuttons.customroll.max = value end,
			},
			visibility = {
				order = 19,
				type = 'input',
				name = L["Visibility State"],
				width = 'full',
				disabled = function() return not E.db.sle.uibuttons.enable end,
				get = function(info) return E.db.sle.uibuttons[info[#info]] end,
				set = function(info, value) E.db.sle.uibuttons[info[#info]] = value; Bar:ToggleShow() end,
			},
			Config = {
				order = 30,
				type = 'group',
				name = '\"C\" '..L["Quick Action"],
				guiInline = true,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.sle.uibuttons.Config[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Config[info[#info]] = value end
					},
					called = {
						order = 2,
						type = 'select',
						name = L["Function"],
						desc = L["Function called by quick access."],
						values = {
							["Elv"] = L["ElvUI Config"],
							["SLE"] = L["S&L Config"],
							["Reload"] = L["Reload UI"],
							["MoveUI"] = L["Move UI"],
						},
						get = function(info) return E.db.sle.uibuttons.Config[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Config[info[#info]] = value end,
					},
				},
			},
			Addon = {
				order = 31,
				type = 'group',
				name = '\"A\" '..L["Quick Action"],
				guiInline = true,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.sle.uibuttons.Addon[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Addon[info[#info]] = value end
					},
					called = {
						order = 2,
						type = 'select',
						name = L["Function"],
						desc = L["Function called by quick access."],
						values = {
							["Manager"] = ADDONS,
						},
						get = function(info) return E.db.sle.uibuttons.Addon[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Addon[info[#info]] = value end,
					},
				},
			},
			Status = {
				order = 32,
				type = 'group',
				name = '\"S\" '..L["Quick Action"],
				guiInline = true,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.sle.uibuttons.Status[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Status[info[#info]] = value end
					},
					called = {
						order = 2,
						type = 'select',
						name = L["Function"],
						desc = L["Function called by quick access."],
						values = {
							AFK = L["AFK"],
							DND = L["DND"],
						},
						get = function(info) return E.db.sle.uibuttons.Status[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Status[info[#info]] = value end,
					},
				},
			},
			Roll = {
				order = 33,
				type = 'group',
				name = '\"R\" '..L["Quick Action"],
				guiInline = true,
				disabled = function() return not E.db.sle.uibuttons.enable or E.private.sle.uibuttons.style == 'classic' end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.sle.uibuttons.Roll[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Roll[info[#info]] = value end
					},
					called = {
						order = 2,
						type = 'select',
						name = L["Function"],
						desc = L["Function called by quick access."],
						values = {
							["Ten"] = "1-10",
							["Twenty"] = "1-20",
							["Thirty"] = "1-30",
							["Forty"] = "1-40",
							["Hundred"] = "1-100",
							["Custom"] = CUSTOM,

						},
						get = function(info) return E.db.sle.uibuttons.Roll[info[#info]] end,
						set = function(info, value) E.db.sle.uibuttons.Roll[info[#info]] = value end,
					},
				},
			},
		},
	}
	if E.private.sle.uibuttons.style == 'dropdown' then
		for k, v in pairs(UB.Holder.Addon) do
			if k ~= 'Toggle' and type(v) == 'table' and (v.HasScript and v:HasScript('OnClick')) then
				E.Options.args.sle.args.modules.args.uibuttons.args.Addon.args.called.values[k] = k
			end
		end
	end
end

tinsert(SLE.Configs, configTable)
