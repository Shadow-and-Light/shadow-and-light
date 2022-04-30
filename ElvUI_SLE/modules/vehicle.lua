local SLE, _, E, L = unpack(select(2, ...))
local DVB = SLE.DedicatedVehicleBar
local AB = E.ActionBars
local LAB = E.Libs.LAB
local Masque = LibStub('Masque', true)
local MasqueGroup = Masque and Masque:Group('ElvUI', 'ActionBars')

local _G = _G
local format = format
local ipairs, pairs = ipairs, pairs
local strsplit = strsplit
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local GetVehicleBarIndex, GetOverrideBarIndex = GetVehicleBarIndex, GetOverrideBarIndex
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local defaultFont, defaultFontSize, defaultFontOutline

DVB.barDefaults = {
	vehicle = {
		page = 1,
		bindButtons = 'ACTIONBUTTON',
		conditions = format('[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;', GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex()),
		position = 'BOTTOM,ElvUIParent,BOTTOM,0,34',
	}
}
DVB.handledBars = {}

function DVB:Animate(bar, x, y, duration)
	bar.anim = bar:CreateAnimationGroup('Move_In')
	bar.anim.in1 = bar.anim:CreateAnimation('Translation')
	bar.anim.in1:SetDuration(0)
	bar.anim.in1:SetOrder(1)
	bar.anim.in2 = bar.anim:CreateAnimation('Translation')
	bar.anim.in2:SetDuration(duration)
	bar.anim.in2:SetOrder(2)
	bar.anim.in2:SetSmoothing('OUT')
	bar.anim.out1 = bar:CreateAnimationGroup('Move_Out')
	bar.anim.out2 = bar.anim.out1:CreateAnimation('Translation')
	bar.anim.out2:SetDuration(duration)
	bar.anim.out2:SetOrder(1)
	bar.anim.out2:SetSmoothing('IN')
	bar.anim.in1:SetOffset(x, y)
	bar.anim.in2:SetOffset(-x, -y)
	bar.anim.out2:SetOffset(x, y)
	bar.anim.out1:SetScript('OnFinished', function() bar:Hide() end)
end

function DVB:AnimSlideIn(bar)
	if not bar.anim then
		DVB:Animate(bar)
	end

	bar.anim.out1:Stop()
	bar.anim:Play()
end

function DVB:AnimSlideOut(bar)
	if bar.anim then
		bar.anim:Finish()
	end

	bar.anim:Stop()
	bar.anim.out1:Play()
end

function DVB:PositionAndSizeBar()
	if not DVB.bar then return end
	local db = E.db.sle.actionbar.vehicle
	local bar = DVB.bar
	local buttonSpacing = db.buttonSpacing
	local backdropSpacing = db.backdropSpacing
	local buttonsPerRow = db.buttonsPerRow <= 7 and db.buttonsPerRow or 7
	local point = db.point
	local numButtons = 7
	db.buttons = numButtons --Hard code it here for AB:HandleButton() needs it

	bar.db = db
	bar.mouseover = db.mouseover

	bar:EnableMouse(bar.mouseover or not db.clickThrough)
	bar:SetAlpha(bar.mouseover and 0 or db.alpha)
	bar:SetFrameStrata(db.frameStrata or 'LOW')
	bar:SetFrameLevel(db.frameLevel)

	AB:FadeBarBlings(bar, bar.mouseover and 0 or db.alpha) --* Prob not needed/wanted tbh
	bar.backdrop:SetShown(db.backdrop)
	bar.backdrop:SetFrameStrata(db.frameStrata or 'LOW')
	bar.backdrop:SetFrameLevel(db.frameLevel - 1)
	bar.backdrop:ClearAllPoints()

	AB:MoverMagic(bar)

	local _, horizontal, anchorUp, anchorLeft = AB:GetGrowth(point)
	local button, lastButton, lastColumnButton, anchorRowButton, lastShownButton

	for i = 1, db.buttons do
		lastButton = bar.buttons[i-1]
		lastColumnButton = bar.buttons[i-buttonsPerRow]
		button = bar.buttons[i]
		button.db = db

		if i == 1 or i == buttonsPerRow then
			anchorRowButton = button
		end

		--! Dont think i need the first part of this check as 'i' should never be above db.buttons
		if i > db.buttons then
			button:Hide()
			button.handleBackdrop = nil
		else
			button:Show()
			button.handleBackdrop = true
			lastShownButton = button
		end

		AB:HandleButton(bar, button, i, lastButton, lastColumnButton)
		AB:StyleButton(button, nil, MasqueGroup and E.private.actionbar.masque.actionbars)

		--* S&L Version of AB:FixKeybindText(button)
		local hotkey = _G[bar.buttons[i]:GetName()..'HotKey']
		local hotkeytext

		local hotkeyPosition = db and db.hotkeyTextPosition or 'TOPRIGHT'
		local hotkeyXOffset = db and db.hotkeyTextXOffset or 0
		local hotkeyYOffset = db and db.hotkeyTextYOffset or -3
		local color = db and db.useHotkeyColor and db.hotkeyColor or AB.db.fontColor

		if i == 7 then
			hotkeytext = _G['ElvUI_Bar1Button12HotKey']:GetText()
		else
			hotkeytext = _G['ElvUI_Bar1Button'..i..'HotKey']:GetText()
		end

		local justify = 'RIGHT'
		if hotkeyPosition == 'TOPLEFT' or hotkeyPosition == 'BOTTOMLEFT' then
			justify = 'LEFT'
		elseif hotkeyPosition == 'TOP' or hotkeyPosition == 'BOTTOM' then
			justify = 'CENTER'
		end

		if hotkeytext then
			if hotkeytext == _G.RANGE_INDICATOR then
				hotkey:SetFont(defaultFont, defaultFontSize, defaultFontOutline)
				hotkey.SetVertexColor = nil
			else
				hotkey:FontTemplate(E.Libs.LSM:Fetch('font', db and db.hotkeyFont or AB.db.font), db and db.hotkeyFontSize or AB.db.fontSize, db and db.hotkeyFontOutline or AB.db.fontOutline)
				hotkey.SetVertexColor = E.noop
			end
			hotkey:SetText(hotkeytext)
			hotkey:SetJustifyH(justify)
		end

		hotkey:SetTextColor(color.r, color.g, color.b)

		if db and not db.hotkeytext then
			hotkey:Hide()
		else
			hotkey:Show()
		end

		if not bar.buttons[i].useMasque then
			hotkey:ClearAllPoints()
			hotkey:Point(hotkeyPosition, hotkeyXOffset, hotkeyYOffset)
		end
	end

	AB:HandleBackdropMultiplier(bar, backdropSpacing, buttonSpacing, db.widthMult, db.heightMult, anchorUp, anchorLeft, horizontal, lastShownButton, anchorRowButton)
	AB:HandleBackdropMover(bar, backdropSpacing)

	local page = format('[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;', GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())
	RegisterStateDriver(bar, 'page', page)

	if db.enable then
		E:EnableMover(bar.mover:GetName())
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide')
		bar:Show()
	else
		E:DisableMover(bar.mover:GetName())
		UnregisterStateDriver(bar, 'visibility')
		bar:Hide()
	end

	--* Not sure if we want or need the SetMoverSnapOffset
	E:SetMoverSnapOffset('SL_DedicatedVehicleBarMover', db.buttonSpacing / 2)

	--! Did not test the masque stuff tbh (Yolo)
	if MasqueGroup and E.private.actionbar.masque.actionbars then
		MasqueGroup:ReSkin()

		-- masque retrims them all so we have to too
		for btn in pairs(AB.handledbuttons) do
			AB:TrimIcon(btn, true)
		end
	end
end

function DVB:CreateBar()
	local bar = CreateFrame('Frame', 'SL_DedicatedVehicleBar', E.UIParent, 'SecureHandlerStateTemplate')
	DVB.handledBars['vehicle'] = bar
	DVB.bar = bar

	local defaults = DVB.barDefaults['vehicle']
	local elvButton = 'ElvUI_Bar1Button'
	bar.id = 1

	local point, anchor, attachTo, x, y = strsplit(',', defaults.position)
	bar:Point(point, anchor, attachTo, x, y)
	bar:HookScript('OnShow', function(frame) self:AnimSlideIn(frame) end)

	bar:CreateBackdrop(AB.db.transparent and 'Transparent', nil, nil, nil, nil, nil, nil, nil, 0)

	bar.buttons = {}

	AB:HookScript(bar, 'OnEnter', 'Bar_OnEnter')
	AB:HookScript(bar, 'OnLeave', 'Bar_OnLeave')

	for i = 1, 7 do
		bar.buttons[i] = LAB:CreateButton(i, format(bar:GetName()..'Button%d', i), bar, nil)
		bar.buttons[i]:SetState(0, 'action', i)

		for k = 1, 14 do
			bar.buttons[i]:SetState(k, 'action', (k - 1) * 12 + i)
		end

		if i == 7 then
			bar.buttons[i]:SetState(12, 'custom', AB.customExitButton)
			_G[elvButton..i].slvehiclebutton = bar.buttons[i]:GetName()
		else
			_G[elvButton..i].slvehiclebutton = bar.buttons[i]:GetName()
		end

		--Masuqe Support
		if MasqueGroup and E.private.actionbar.masque.actionbars then
			bar.buttons[i]:AddToMasque(MasqueGroup)
		end

		AB:HookScript(bar.buttons[i], 'OnEnter', 'Button_OnEnter')
		AB:HookScript(bar.buttons[i], 'OnLeave', 'Button_OnLeave')
	end

	bar:SetAttribute('_onstate-page', [[
		newstate = ((HasTempShapeshiftActionBar() and self:GetAttribute('hasTempBar')) and GetTempShapeshiftBarIndex()) or (UnitHasVehicleUI('player') and GetVehicleBarIndex()) or (HasOverrideActionBar() and GetOverrideBarIndex()) or newstate
		if not newstate then return end

		if newstate ~= 0 then
			self:SetAttribute('state', newstate)
			control:ChildUpdate('state', newstate)
		else
			local newCondition = self:GetAttribute('newCondition')
			if newCondition then
				newstate = SecureCmdOptionParse(newCondition)
				self:SetAttribute('state', newstate)
				control:ChildUpdate('state', newstate)
			end
		end
	]])

	local db = DVB.db.vehicle
	local animationDistance = db.keepSizeRatio and db.buttonSize or db.buttonHeight
	DVB:Animate(bar, 0, -(animationDistance), 1)

	E:CreateMover(bar, 'SL_DedicatedVehicleBarMover', L["Dedicated Vehicle Bar"], nil, nil, nil, 'ALL,ACTIONBARS,S&L,S&L MISC', nil, 'sle, modules, actionbars')
end

function DVB:UpdateButtonSettings()
	if not E.private.actionbar.enable then return end

	for barName, bar in pairs(DVB.handledBars) do
		DVB:UpdateButtonConfig(barName, bar.bindButtons)
		DVB:PositionAndSizeBar()
	end

	-- if AB.db.handleOverlay then
	-- 	LAB.eventFrame:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW')
	-- 	LAB.eventFrame:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_HIDE')
	-- else
	-- 	LAB.eventFrame:UnregisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW')
	-- 	LAB.eventFrame:UnregisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_HIDE')
	-- end
end

function DVB:UpdateButtonConfig(barName)
	local barDB = DVB.db[barName]
	local bar = DVB.handledBars[barName]

	if not bar.buttonConfig then bar.buttonConfig = { hideElements = {}, colors = {} } end

	bar.buttonConfig.hideElements.hotkey = not barDB.hotkeytext
	bar.buttonConfig.showGrid = barDB.showGrid
	bar.buttonConfig.clickOnDown = AB.db.keyDown
	bar.buttonConfig.outOfRangeColoring = (AB.db.useRangeColorText and 'hotkey') or 'button'
	bar.buttonConfig.colors.range = E:SetColorTable(bar.buttonConfig.colors.range, AB.db.noRangeColor)
	bar.buttonConfig.colors.mana = E:SetColorTable(bar.buttonConfig.colors.mana, AB.db.noPowerColor)
	bar.buttonConfig.colors.usable = E:SetColorTable(bar.buttonConfig.colors.usable, AB.db.usableColor)
	bar.buttonConfig.colors.notUsable = E:SetColorTable(bar.buttonConfig.colors.notUsable, AB.db.notUsableColor)
	bar.buttonConfig.useDrawBling = not AB.db.hideCooldownBling
	bar.buttonConfig.useDrawSwipeOnCharges = AB.db.useDrawSwipeOnCharges
	bar.buttonConfig.handleOverlay = AB.db.handleOverlay

	for _, button in ipairs(bar.buttons) do
		--* Don't know if needed atm, still somewhat a wip
		-- AB:ToggleCountDownNumbers(bar, button)

		button:UpdateConfig(bar.buttonConfig)
	end
end

--* Ghetto way to get the pushed texture to work
function DVB:LAB_MouseUp()
	if not E.private.actionbar.enable or not E.db.sle.actionbar.vehicle.enable then return end
	local slbutton = _G[self.slvehiclebutton]
	if slbutton and slbutton.config.clickOnDown then
		slbutton:GetPushedTexture():Hide()
	end
end
hooksecurefunc(AB, 'LAB_MouseUp', DVB.LAB_MouseUp)

function DVB:LAB_MouseDown()
	if not E.private.actionbar.enable or not E.db.sle.actionbar.vehicle.enable then return end
	local slbutton = _G[self.slvehiclebutton]
	if slbutton and slbutton.config.clickOnDown then
		slbutton:GetPushedTexture():Show()
	end
end
hooksecurefunc(AB, 'LAB_MouseDown', DVB.LAB_MouseDown)

function DVB:Initialize()
	if not SLE.initialized or not E.private.actionbar.enable then return end
	DVB.db = E.db.sle.actionbar

	if E.locale == 'koKR' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\2002.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhTW' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\arheiuhk_bd.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhCN' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\FRIZQT__.TTF]], 11, 'MONOCHROME, OUTLINE'
	else
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\ARIALN.TTF]], 12, "MONOCHROME, THICKOUTLINE"
	end

	DVB:CreateBar()
	DVB:UpdateButtonSettings()

	--! Def need some testing as I don't see why or where this is needed atm
	-- DVB.bar:Execute(DVB.bar:GetAttribute('_onstate-page'))

	-- function DVB:ForUpdateAll()
	-- 	DVB:UpdateButtonSettings()
	-- end

	hooksecurefunc(AB, 'UpdateButtonSettings', DVB.UpdateButtonSettings)
end

SLE:RegisterModule(DVB:GetName())
