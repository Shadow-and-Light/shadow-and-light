local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EVB = SLE.EnhancedVehicleBar
local AB = E.ActionBars
local LAB = LibStub('LibActionButton-1.0-ElvUI')
local Masque = LibStub('Masque', true)
local MasqueGroup = Masque and Masque:Group('ElvUI', 'ActionBars')

--GLOBALS: CreateFrame, hooksecurefunc, UIParent
local format = format
local RegisterStateDriver = RegisterStateDriver
local GetVehicleBarIndex, GetOverrideBarIndex = GetVehicleBarIndex, GetOverrideBarIndex
local defaultFont, defaultFontSize, defaultFontOutline

-- Regular Button for these bars are 52. 52 * .71 = ~37.. I just rounded it up to 40 and called it good.
function EVB:Animate(bar, x, y, duration)
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

function EVB:AnimSlideIn(bar)
	if not bar.anim then
		EVB:Animate(bar)
	end

	bar.anim.out1:Stop()
	bar.anim:Play()
end

function EVB:AnimSlideOut(bar)
	if bar.anim then
		bar.anim:Finish()
	end

	bar.anim:Stop()
	bar.anim.out1:Play()
end

function EVB:CreateExtraButtonSet()
	local bar = self.bar
	bar.buttons = {}
	local size = E.db.sle.actionbars.vehicle.buttonsize
	local spacing = E.db.sle.actionbars.vehicle.buttonspacing

	for i = 1, 7 do
		bar.buttons[i] = LAB:CreateButton(i, format(bar:GetName()..'Button%d', i), bar, nil)
		bar.buttons[i]:SetState(0, 'action', i)

		for k = 1, 14 do
			bar.buttons[i]:SetState(k, 'action', (k - 1) * 12 + i)
		end

		if i == 7 then
			bar.buttons[i]:SetState(12, 'custom', AB.customExitButton)
		end

		--Masuqe Support
		if MasqueGroup and E.private.actionbar.masque.actionbars then
			bar.buttons[i]:AddToMasque(MasqueGroup)
		end

		bar.buttons[i]:Size(size)

		if (i == 1) then
			bar.buttons[i]:SetPoint('BOTTOMLEFT', spacing, spacing)
		else
			bar.buttons[i]:SetPoint('LEFT', bar.buttons[i-1], 'RIGHT', spacing, 0)
		end

		AB:StyleButton(bar.buttons[i], nil, MasqueGroup and E.private.actionbar.masque.actionbars and true or nil)

		-- if E.db.actionbar.transparent then
		-- 	-- Disable this call if Masque is loaded
		-- 	if IsAddOnLoaded('Masque') then return end

		-- 	bar.buttons[i].backdrop:SetTemplate('Transparent')
		-- end

		bar.buttons[i]:SetCheckedTexture('')
		RegisterStateDriver(bar.buttons[i], 'visibility', '[vehicleui][overridebar][shapeshift][possessbar] show; hide')

		-- local elvhotkey = _G['ElvUI_Bar1Button'..i..'HotKey']
		local hotkey = _G[bar.buttons[i]:GetName()..'HotKey']
		local hotkeytext

		local hotkeyPosition = db and db.hotkeyTextPosition or 'TOPRIGHT'
		local hotkeyXOffset = db and db.hotkeyTextXOffset or 0
		local hotkeyYOffset = db and db.hotkeyTextYOffset or -3
		local color = AB.db.fontColor

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
				hotkey:FontTemplate(E.Libs.LSM:Fetch('font', AB.db.font), AB.db.fontSize, AB.db.fontOutline)
				hotkey.SetVertexColor = E.noop
			end
			hotkey:SetText(hotkeytext)
			hotkey:SetJustifyH(justify)
		end

		hotkey:SetTextColor(color.r, color.g, color.b)

		-- if db and not db.hotkeytext then
			-- hotkey:Hide()
		-- else
			hotkey:Show()
		-- end

		hotkey:ClearAllPoints()
		hotkey:Point(hotkeyPosition, hotkeyXOffset, hotkeyYOffset)
	end
end

function EVB:PositionAndSizeBar()
	if not EVB.bar then return end
	local bar = EVB.bar

	local size = E.db.sle.actionbars.vehicle.buttonsize
	local spacing = E.db.sle.actionbars.vehicle.buttonspacing
	bar:SetWidth((size * 7) + (spacing * 6) + 4)
	bar:SetHeight(size + 4)

	for i, button in ipairs(bar.buttons) do
		button:Size(size)
		if (i == 1) then
			button:SetPoint('BOTTOMLEFT', 2, 2)
		else
			button:SetPoint('LEFT', bar.buttons[i-1], 'RIGHT', spacing, 0)
		end
	end
end

function EVB:CreateBar()
	local page = format('[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;', GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())

	local bar = CreateFrame('Frame', 'ElvUISL_EnhancedVehicleBar', E.UIParent, 'SecureHandlerStateTemplate')
	bar.id = 1
	EVB.bar = bar

	EVB:CreateExtraButtonSet()
	EVB:PositionAndSizeBar()

	bar:CreateBackdrop(AB.db.transparent and 'Transparent', nil, nil, nil, nil, nil, nil, nil, 0)
	bar:SetPoint('BOTTOM', 0, 34)
	bar:HookScript('OnShow', function(frame) self:AnimSlideIn(frame) end)

	RegisterStateDriver(bar, 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide')
	RegisterStateDriver(bar, 'page', page)

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

	EVB:Animate(bar, 0, -(bar:GetHeight()), 1)

	E:CreateMover(bar, 'EnhancedVehicleBar_Mover', L["Enhanced Vehicle Bar"], nil, nil, nil, 'ALL,S&L,S&L MISC', nil, 'sle, modules, actionbars, vehicle')
	-- AB:PositionAndSizeBar('bar1')
end

function EVB:Initialize()
	if not SLE.initialized then return end
	if not E.private.sle.vehicle.enable or not E.private.actionbar.enable then return end

	if E.locale == 'koKR' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\2002.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhTW' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\arheiuhk_bd.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhCN' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\FRIZQT__.TTF]], 11, 'MONOCHROME, OUTLINE'
	else
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\ARIALN.TTF]], 12, "MONOCHROME, THICKOUTLINE"
	end

	EVB:CreateBar()

	EVB.bar:Execute(EVB.bar:GetAttribute('_onstate-page'))

	function EVB:ForUpdateAll()
		EVB:PositionAndSizeBar()
	end
end

SLE:RegisterModule(EVB:GetName())
