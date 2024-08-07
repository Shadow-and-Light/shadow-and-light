local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DD = SLE.Dropdowns

DD.RegisteredMenus = {}

--Cache global variables
local tinsert, format = tinsert, format
local GetTime = GetTime

--WoW API / Variables
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local GetCursorPosition = GetCursorPosition
local C_Spell_GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local C_Item_GetItemCooldown = C_Item and C_Item.GetItemCooldown or GetItemCooldown
local C_Spell_GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local C_Item_GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, UISpecialFrames
local _G = _G

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local TITLE_OFFSET = 10

local function OnMouseUp(btn)
	if btn.func then btn.func() end

	E:Delay(.1, function() btn:GetParent():Hide() end)
end

local function OnEnter(btn)
	if not btn.nohighlight then btn.hoverTex:Show() end
	if btn.UseTooltip then
		_G['GameTooltip']:SetOwner(btn, 'ANCHOR_BOTTOMLEFT', -9)
		if btn.TooltipText then
			_G['GameTooltip']:SetText(btn.TooltipText)
		elseif btn.secure.isToy then
			_G['GameTooltip']:SetToyByItemID(btn.secure.ID)
		elseif btn.secure.buttonType == 'item' then
			_G['GameTooltip']:SetItemByID(btn.secure.ID)
		elseif btn.secure.buttonType == 'spell' then
			_G['GameTooltip']:SetSpellByID(btn.secure.ID)
		end
		_G['GameTooltip']:Show()
	end
end

local function OnLeave(btn)
	_G['GameTooltip']:Hide()
	btn.hoverTex:Hide()
end

local function CreateListButton(frame)
	local button = CreateFrame('Button', nil, frame, 'SecureActionButtonTemplate')

	button:RegisterForClicks('LeftButtonUp', 'LeftButtonDown')
	button.hoverTex = button:CreateTexture(nil, 'OVERLAY')
	button.hoverTex:SetAllPoints()
	button.hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
	button.hoverTex:SetBlendMode('ADD')
	button.hoverTex:Hide()

	button.text = button:CreateFontString(nil, 'BORDER')
	button.text:SetAllPoints()
	button.text:FontTemplate()

	button:EnableMouse(true)
	button:SetScript('OnEnter', OnEnter)
	button:SetScript('OnLeave', OnLeave)
	DD:SecureHookScript(button, 'OnMouseUp', OnMouseUp)

	return button
end

function SLE:DropdownList(list, frame, customWidth, justify)
	for i=1, #list do
		frame.buttons[i] = frame.buttons[i] or CreateListButton(frame)
		local btn = frame.buttons[i]

		btn.func = list[i].func or nil
		btn.nohighlight = list[i].nohighlight
		btn.text:SetJustifyH(justify or 'LEFT')
		btn:Show()
		btn:Height(BUTTON_HEIGHT)

		local icon = ''
		if list[i].icon then
			icon = '|T'..list[i].icon..':14:14:0:0:64:64:4:60:4:60|t '
		end

		btn.text:SetText(icon..list[i].text)
		if list[i].title then
			frame.TitleCount = frame.TitleCount + 1
			btn.text:SetTextColor(0.98, 0.95, 0.05)
			if list[i].ending or i == 1 or list[i-1].title then
				frame.AddOffset = frame.AddOffset + 1
			end
		else
			btn.text:SetTextColor(1, 1, 1)
		end

		if customWidth and customWidth == 'auto' then
			if frame.maxWidth < btn.text:GetStringWidth() then
				frame.maxWidth = btn.text:GetStringWidth()
				frame.TitleCount = 0
				frame.AddOffset = 0
				SLE:DropdownList(list, frame, customWidth, justify)
				return
			end
			btn:Width(frame.maxWidth)
		else
			btn:Width(customWidth or BUTTON_WIDTH)
		end

		if list[i].secure then
			btn:SetAttribute('type', nil)
			-- btn:SetAttribute('item', nil)
			-- btn:SetAttribute('spell', nil)
			-- btn:SetAttribute('macrotext', nil)
			btn.secure = list[i].secure
			btn:SetAttribute('type', btn.secure.buttonType)
			if btn.secure.buttonType == 'item' then
				local name = C_Item_GetItemInfo(btn.secure.ID)
				btn:SetAttribute('item', name)
			elseif btn.secure.buttonType == 'spell' then
				btn:SetAttribute('spell', C_Spell_GetSpellInfo(btn.secure.ID).name)
			elseif btn.secure.buttonType == 'macro' then
				btn:SetAttribute('macrotext', btn.secure.ID)
			else
				SLE:Print('Wrong argument for button type: '..btn.secure.buttonType, 'error')
			end
		end
		btn.UseTooltip = list[i].UseTooltip
		if list[i].TooltipText then btn.TooltipText = list[i].TooltipText end

		local MARGIN = 10
		if justify then
			if justify == 'RIGHT' then MARGIN = -10 end
			if justify == 'CENTER' then MARGIN = 0 end
		end

		if i == 1 then
			btn:Point('TOPLEFT', frame, 'TOPLEFT', MARGIN, -PADDING)
		else
			btn:Point('TOPLEFT', frame.buttons[i-1], 'BOTTOMLEFT', 0, -((list[i-1].title or list[i].title) and TITLE_OFFSET or 0))
		end
	end
end

function SLE:DropDown(list, frame, MenuAnchor, FramePoint, xOffset, yOffset, parent, customWidth, justify)
	if InCombatLockdown() then return end
	frame.maxWidth = BUTTON_WIDTH
	frame.TitleCount = 0
	frame.AddOffset = 0
	if not frame.buttons then
		frame.buttons = {}
		frame:SetFrameStrata('DIALOG')
		frame:SetClampedToScreen(true)
		tinsert(UISpecialFrames, frame:GetName())
		frame:Hide()
	end
	for i=1, #frame.buttons do
		local btn = frame.buttons[i]
		btn.UseTooltip = false
		btn.func = nil
		btn.secure = nil
		btn.TooltipText = nil
		btn.text:SetText('')
		btn:Hide()
	end
	if not frame:IsShown() then
		xOffset = xOffset or 0
		yOffset = yOffset or 0

		if not parent then FramePoint = 'CURSOR' end
		SLE:DropdownList(list, frame, customWidth, justify)

		frame:Height((#list * BUTTON_HEIGHT) + PADDING * 2 + frame.TitleCount * (2 * TITLE_OFFSET) - frame.AddOffset * TITLE_OFFSET)
		if customWidth and customWidth == 'auto' then
			frame:Width(frame.maxWidth + PADDING * 2)
		else
			frame:Width(customWidth or (BUTTON_WIDTH + PADDING * 2))
		end

		frame:ClearAllPoints()
		if FramePoint == 'CURSOR' then
			local UIScale = UIParent:GetScale()
			local x, y = GetCursorPosition()
			x = x/UIScale
			y = y/UIScale
			frame:Point(MenuAnchor, UIParent, 'BOTTOMLEFT', x + xOffset, y + yOffset)
		else
			frame:Point(MenuAnchor, parent, FramePoint, xOffset, yOffset)
		end
	end
	ToggleFrame(frame)
end

function DD:GetCooldown(CDtype, id)
	local cd, formatID
	local start, duration
	-- local start, duration = _G['Get'..CDtype..'Cooldown'](id)
	if CDtype == "Item" then
		start, duration = C_Item_GetItemCooldown(id)
	elseif CDtype == "Spell" then
		local data = C_Spell_GetSpellCooldown(id)
		start, duration = data.startTime, data.duration
	end
	if start ~= nil and start > 0 then
		cd = duration - (GetTime() - start)
		cd, formatID = E:GetTimeInfo(cd, 0)
		cd = format(E.TimeFormats[formatID][3], cd)
		return cd
	end
	return nil
end

function DD:HideMenus(event)
	if event == 'PLAYER_ENTERING_WORLD' then self:UnregisterEvent(event) end
	for _, menu in pairs(DD.RegisteredMenus) do
		menu:Hide()
	end
end

function DD:RegisterMenu(menu)
	local name = menu:GetName()
	if name then
		DD.RegisteredMenus[name] = menu
	else
		SLE:Print('Dropdown not registered. Please check if it has a name.')
	end
end

function DD:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'HideMenus')
	self:RegisterEvent('LOADING_SCREEN_DISABLED', 'HideMenus')
	self:RegisterEvent('PLAYER_REGEN_DISABLED', 'HideMenus')
end

SLE:RegisterModule(DD:GetName())
