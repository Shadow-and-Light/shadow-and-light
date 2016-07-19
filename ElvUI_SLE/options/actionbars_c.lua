local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local A = SLE:GetModule("Actionbars")
local AB = E:GetModule('ActionBars');

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
				desc = L["Highlight the button of the spell with areal effect untill the area is selected."],
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
			transparentBackdrop = {
				order = 4,
				type = "toggle",
				name = L["Transparent Backdrop"],
				desc = L["Sets actiobars' backgrounds to transparent template."],
				get = function(info) return E.private.sle.actionbars.transparentBackdrop end,
				set = function(info, value) E.private.sle.actionbars.transparentBackdrop = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			transparentButtons = {
				order = 5,
				type = "toggle",
				name = L["Transparent Buttons"],
				desc = L["Sets actiobars buttons' backgrounds to transparent template."],
				get = function(info) return E.private.sle.actionbars.transparentButtons end,
				set = function(info, value) E.private.sle.actionbars.transparentButtons = value; E:StaticPopup_Show('PRIVATE_RL'); end,
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
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)