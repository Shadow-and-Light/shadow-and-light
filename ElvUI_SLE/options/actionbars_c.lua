local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local A = SLE:GetModule("Actionbars")
local AB = E:GetModule('ActionBars');
local EVB = SLE:GetModule("EnhancedVehicleBar")

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.actionbars = {
		type = "group",
		name = L["ActionBars"],
		order = 1,
		childGroups = 'tab',
		disabled = function() return not E.private.actionbar.enable end,
		args = {
			oorBind = {
				order = 1,
				type = "toggle",
				name = L["OOR as Bind Text"],
				desc = L["Out Of Range indication will use keybind text instead of the whole icon."],
				get = function(info) return E.private.sle.actionbars.oorBind end,
				set = function(info, value) E.private.sle.actionbars.oorBind = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			checkedtexture = {
				order = 2,
				type = "toggle",
				name = L["Checked Texture"],
				desc = L["Highlight the button of the spell with areal effect until the area is selected."],
				disabled = function() return not E.private.actionbar.enable or (LibStub("Masque", true) and E.private.actionbar.masque.actionbars) end,
				get = function(info) return E.private.sle.actionbars.checkedtexture end,
				set = function(info, value) E.private.sle.actionbars.checkedtexture = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			checkedColor = {
				type = 'color',
				order = 3,
				name = L["Checked Texture Color"],
				hasAlpha = true,
				disabled = function() return not E.private.actionbar.enable or not E.private.sle.actionbars.checkedtexture or LibStub("Masque", true) end,
				get = function(info)
					local t = E.private.sle.actionbars[ info[#info] ]
					local d = V.sle.actionbars[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
				end,
				set = function(info, r, g, b, a)
					E.private.sle.actionbars[ info[#info] ] = {}
					local t = E.private.sle.actionbars[ info[#info] ]
					t.r, t.g, t.b, t.a = r, g, b, a
					for i=1, A.MaxBars do
						AB:PositionAndSizeBar('bar'..i)
					end
				end,
			},
			vehicle = {
				type = "group",
				name = L["Enhanced Vehicle Bar"],
				order = 10,
				guiInline = true,
				args = {
					info = {
						order = 2,
						type = "description",
						name = L["A different look/feel vehicle bar"],
					},
					enable = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.private.sle.vehicle.enable end,
						set = function(info, value) E.private.sle.vehicle.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					buttonsize = {
						order = 4,
						type = 'range',
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15, max = 60, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[ info[#info] ] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:ButtonsSize() end,
					},
					buttonspacing = {
						order = 5,
						type = 'range',
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = -4, max = 20, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[ info[#info] ] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:ButtonsSize() end,
					},
					template = {
						order = 6,
						type = "select",
						name = L["Template"],
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.db.sle.actionbars.vehicle[ info[#info] ] end,
						set = function(info, value) E.db.sle.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:BarBackdrop() end,
						values = {
							["Default"] = DEFAULT,
							["Transparent"] = L["Transparent"],
							["NoBackdrop"] = NONE,
						},
					},
					numButtons = {
						order = 7,
						type = 'range',
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 5, max = 7, step = 1,
						disabled = function() return not E.private.sle.vehicle.enable end,
						get = function(info) return E.private.sle.vehicle[ info[#info] ] end,
						set = function(info, value) E.private.sle.vehicle[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
