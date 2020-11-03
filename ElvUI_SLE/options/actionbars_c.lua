local SLE, _, E, L, V = unpack(select(2, ...))
local A = SLE:GetModule('Actionbars')
local AB = E:GetModule('ActionBars');
local EVB = SLE:GetModule('EnhancedVehicleBar')

--GLOBALS: unpack, select, tinsert, DEFAULT, NONE, LibStub
local tinsert = tinsert
local DEFAULT, NONE = DEFAULT, NONE

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.actionbars = {
		type = 'group',
		name = L["ActionBars"],
		order = 1,
		disabled = function() return not E.private.actionbar.enable end,
		args = {
			elvuibars = {
				type = 'group',
				name = L["ActionBars"],
				order = 10,
				guiInline = true,
				args = {
					checkedtexture = {
						order = 2,
						type = 'toggle',
						name = L["Checked Texture"],
						desc = L["Highlight the button of the spell with areal effect until the area is selected."],
						disabled = function() return not E.private.actionbar.enable or (LibStub('Masque', true) and E.private.actionbar.masque.actionbars) end,
						get = function(info) return E.private.sle.actionbars[info[#info]] end,
						set = function(info, value) E.private.sle.actionbars[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					checkedColor = {
						type = 'color',
						order = 3,
						name = L["Checked Texture Color"],
						hasAlpha = true,
						disabled = function() return not E.private.actionbar.enable or not E.private.sle.actionbars.checkedtexture or LibStub('Masque', true) end,
						get = function(info)
							local t = E.private.sle.actionbars[info[#info]]
							local d = V.sle.actionbars[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.private.sle.actionbars[info[#info]] = {}
							local t = E.private.sle.actionbars[info[#info]]
							t.r, t.g, t.b, t.a = r, g, b, a
							for i = 1, 10 do
								AB:PositionAndSizeBar('bar'..i)
							end
						end,
					},
				},
			},
			vehicle = {
				type = 'group',
				name = L["Enhanced Vehicle Bar"],
				order = 10,
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Enables a different look/feel vehicle bar."],
						get = function() return E.private.sle.vehicle.enable end,
						set = function(_, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					template = {
						order = 2,
						type = 'select',
						name = L["Template"],
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[info[#info]] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[info[#info]] = value; EVB:PositionAndSizeBar(); EVB:BarBackdrop() end,
						values = {
							Default = DEFAULT,
							Transparent = L["Transparent"],
							NoBackdrop = NONE,
						},
					},
					spacer1 = ACH:Spacer(3, 'full'),
					numButtons = {
						order = 4,
						type = 'range',
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 5, max = 7, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.private.sle.vehicle[info[#info]] end,
						set = function(info, value) E.private.sle.vehicle[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					buttonsize = {
						order = 5,
						type = 'range',
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15, max = 60, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[info[#info]] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[info[#info]] = value; EVB:PositionAndSizeBar() end,
					},
					buttonspacing = {
						order = 5,
						type = 'range',
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = -4, max = 20, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[info[#info]] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[info[#info]] = value; EVB:PositionAndSizeBar() end,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
