local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local AB = E.ActionBars
local DVB = SLE.DedicatedVehicleBar

local function getCheckedColor(info)
	local t = E.private.sle.actionbars[info[#info]]
	local d = V.sle.actionbars[info[#info]]

	return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
end

local function setCheckedColor(info, r, g, b, a)
	E.private.sle.actionbars[info[#info]] = {}
	local t = E.private.sle.actionbars[info[#info]]
	t.r, t.g, t.b, t.a = r, g, b, a

	for i = 1, 10 do
		AB:PositionAndSizeBar('bar'..i)
	end

	DVB:PositionAndSizeBar()
end

local function configTable()
	if not SLE.initialized then return end
	local C = unpack(E.Config)
	local ACH = E.Libs.ACH

	local SharedBarOptions = {
		enable = ACH:Toggle(L["Enable"], nil, 0),
		-- 	-- restorePosition = ACH:Execute(L["Restore Bar"], L["Restore the actionbars default settings"], 1),
		generalOptions = ACH:MultiSelect('', nil, 3, { backdrop = L["Backdrop"], mouseover = L["Mouseover"], clickThrough = L["Click Through"], dragonRiding = L["Show Dragon Flying"], }, nil, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable end),
		buttonGroup = ACH:Group(L["Button Settings"], nil, 4, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable end),
		backdropGroup = ACH:Group(L["Backdrop Settings"], nil, 5, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable end),
		barGroup = ACH:Group(L["Bar Settings"], nil, 6, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable end),
	}

	local textAnchors = { BOTTOMRIGHT = 'BOTTOMRIGHT', BOTTOMLEFT = 'BOTTOMLEFT', TOPRIGHT = 'TOPRIGHT', TOPLEFT = 'TOPLEFT', BOTTOM = 'BOTTOM', TOP = 'TOP' }
	local getTextColor = function(info) local t = E.db.sle.actionbar[info[#info-3]][info[#info]] local d = P.sle.actionbar[info[#info-3]][info[#info]] return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a end
	local setTextColor = function(info, r, g, b, a) local t = E.db.sle.actionbar[info[#info-3]][info[#info]] t.r, t.g, t.b, t.a = r, g, b, a DVB:UpdateButtonSettings() end

	SharedBarOptions.buttonGroup.inline = true
	SharedBarOptions.buttonGroup.args.buttonsPerRow = ACH:Range(L["Buttons Per Row"], L["The amount of buttons to display per row."], 2, { min = 1, max = 7, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonSpacing = ACH:Range(L["Button Spacing"], L["The spacing between buttons."], 3, { min = -3, max = 20, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonSize = ACH:Range('', nil, 4, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })
	SharedBarOptions.buttonGroup.args.buttonHeight = ACH:Range(L["Button Height"], L["The height of the action buttons."], 5, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })

	SharedBarOptions.barGroup.inline = true
	SharedBarOptions.barGroup.args.point = ACH:Select(L["Anchor Point"], L["The first button anchors itself to this point on the bar."], 1, { TOPLEFT = 'TOPLEFT', TOPRIGHT = 'TOPRIGHT', BOTTOMLEFT = 'BOTTOMLEFT', BOTTOMRIGHT = 'BOTTOMRIGHT' })
	SharedBarOptions.barGroup.args.alpha = ACH:Range(L["Alpha"], nil, 2, { min = 0, max = 1, step = 0.01, isPercent = true })

	SharedBarOptions.barGroup.args.strataAndLevel = ACH:Group(L["Strata and Level"], nil, 30)
	SharedBarOptions.barGroup.args.strataAndLevel.args.frameStrata = ACH:Select(L["Frame Strata"], nil, 3, { BACKGROUND = 'BACKGROUND', LOW = 'LOW', MEDIUM = 'MEDIUM', HIGH = 'HIGH' })
	SharedBarOptions.barGroup.args.strataAndLevel.args.frameLevel = ACH:Range(L["Frame Level"], nil, 4, { min = 1, max = 256, step = 1 })

	SharedBarOptions.barGroup.args.macroTextGroup = ACH:Group(L["Macro Text"], nil, 40, nil, function(info) return E.db.sle.actionbar.vehicle[info[#info]] end, function(info, value) E.db.sle.actionbar.vehicle[info[#info]] = value; DVB:UpdateButtonSettings() end)
	SharedBarOptions.barGroup.args.macroTextGroup.inline = true
	SharedBarOptions.barGroup.args.macroTextGroup.args.macrotext = ACH:Toggle(L["Enable"], L["Display macro names on action buttons."], 0, nil, nil, nil, nil, nil, nil, false)
	SharedBarOptions.barGroup.args.macroTextGroup.args.useMacroColor = ACH:Toggle(L["Custom Color"], nil, 1)
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroColor = ACH:Color('', nil, 2, nil, nil, getTextColor, setTextColor, function() return not E.db.sle.actionbar.vehicle.enable or not E.db.sle.actionbar.vehicle.macrotext end, function() return not E.db.sle.actionbar.vehicle.useMacroColor end)
	SharedBarOptions.barGroup.args.macroTextGroup.args.spacer1 = ACH:Spacer(3, 'full')
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroTextPosition = ACH:Select(L["Position"], nil, 4, textAnchors, nil, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroTextXOffset = ACH:Range(L["X-Offset"], nil, 5, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroTextYOffset = ACH:Range(L["Y-Offset"], nil, 6, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.macroTextGroup.args.spacer2 = ACH:Spacer(7, 'full')
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroFont = ACH:SharedMediaFont(L["Font"], nil, 8)
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroFontOutline = ACH:FontFlags(L["Font Outline"], nil, 9)
	SharedBarOptions.barGroup.args.macroTextGroup.args.macroFontSize = ACH:Range(L["Font Size"], nil, 10, C.Values.FontSize)

	SharedBarOptions.barGroup.args.hotkeyTextGroup = ACH:Group(L["Keybind Text"], nil, 40, nil, function(info) return E.db.sle.actionbar.vehicle[info[#info]] end, function(info, value) E.db.sle.actionbar.vehicle[info[#info]] = value; DVB:UpdateButtonSettings() end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.inline = true
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeytext = ACH:Toggle(L["Enable"], L["Display bind names on action buttons."], 0, nil, nil, nil, nil, nil, nil, false)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.useHotkeyColor = ACH:Toggle(L["Custom Color"], nil, 1)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyColor = ACH:Color('', nil, 2, nil, nil, getTextColor, setTextColor, function() return not E.db.sle.actionbar.vehicle.enable or not E.db.sle.actionbar.vehicle.hotkeytext end, function() return not E.db.sle.actionbar.vehicle.useHotkeyColor end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.spacer1 = ACH:Spacer(3, 'full')
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextPosition = ACH:Select(L["Position"], nil, 4, textAnchors, nil, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextXOffset = ACH:Range(L["X-Offset"], nil, 5, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyTextYOffset = ACH:Range(L["Y-Offset"], nil, 6, { min = -24, max = 24, step = 1 }, nil, nil, nil, function() return not E.db.sle.actionbar.vehicle.enable or (E.Masque and E.private.actionbar.masque.actionbars) end)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.spacer2 = ACH:Spacer(7, 'full')
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFont = ACH:SharedMediaFont(L["Font"], nil, 8)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFontOutline = ACH:FontFlags(L["Font Outline"], nil, 9)
	SharedBarOptions.barGroup.args.hotkeyTextGroup.args.hotkeyFontSize = ACH:Range(L["Font Size"], nil, 10, C.Values.FontSize)

	SharedBarOptions.backdropGroup.inline = true
	SharedBarOptions.backdropGroup.args.backdropSpacing = ACH:Range(L["Backdrop Spacing"], L["The spacing between the backdrop and the buttons."], 1, { min = 0, max = 10, step = 1 })
	SharedBarOptions.backdropGroup.args.heightMult = ACH:Range(L["Height Multiplier"], L["Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop."], 2, { min = 1, max = 5, step = 1 })
	SharedBarOptions.backdropGroup.args.widthMult = ACH:Range(L["Width Multiplier"], L["Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop."], 2, { min = 1, max = 5, step = 1 })

	local ActionBar = ACH:Group(L["ActionBars"], nil, 1, 'tab', nil, nil, function() return not E.private.actionbar.enable end)
	E.Options.args.sle.args.modules.args.actionbars = ActionBar

	local elvuibars = ACH:Group(L["Checked Texture"], nil, 1)
	ActionBar.args.elvuibars = elvuibars

	elvuibars.guiInline = true
	elvuibars.args.checkedtexture = ACH:Toggle(L["Override"], nil, 1, nil, nil, nil, function(info) return E.private.sle.actionbars[info[#info]] end, function(info, value) E.private.sle.actionbars[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end)
	elvuibars.args.checkedColor = ACH:Color(L["Checked Texture Color"], nil, 2, true, nil, getCheckedColor, setCheckedColor)

	local vehicle = ACH:Group(L["Dedicated Vehicle Bar"], nil, 2, 'group', function(info) return E.db.sle.actionbar.vehicle[info[#info]] end, function(info, value) E.db.sle.actionbar.vehicle[info[#info]] = value; DVB:PositionAndSizeBar() end)
	ActionBar.args.vehicle = vehicle

	vehicle.args = CopyTable(SharedBarOptions)

	vehicle.args.enable.set = function(info, value) E.db.sle.actionbar.vehicle[info[#info]] = value; DVB:PositionAndSizeBar() end

	vehicle.args.generalOptions.get = function(_, key) return E.db.sle.actionbar.vehicle[key] end
	vehicle.args.generalOptions.set = function(_, key, value) E.db.sle.actionbar.vehicle[key] = value DVB:UpdateButtonSettings() end
	vehicle.args.generalOptions.values.showGrid = L["Show Empty Buttons"]
	vehicle.args.generalOptions.values.keepSizeRatio = L["Keep Size Ratio"]

	vehicle.args.buttonGroup.args.buttonSize.name = function() return E.db.sle.actionbar.vehicle.keepSizeRatio and L["Button Size"] or L["Button Width"] end
	vehicle.args.buttonGroup.args.buttonSize.desc = function() return E.db.sle.actionbar.vehicle.keepSizeRatio and L["The size of the action buttons."] or L["The width of the action buttons."] end
	vehicle.args.buttonGroup.args.buttonHeight.hidden = function() return E.db.sle.actionbar.vehicle.keepSizeRatio end

	vehicle.args.backdropGroup.hidden = function() return not E.db.sle.actionbar.vehicle.backdrop end
end

tinsert(SLE.Configs, configTable)
