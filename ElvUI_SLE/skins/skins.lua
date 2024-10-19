local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Sk = SLE.Skins
local S = E.Skins

--GLOBALS: CreateFrame
local _G = _G

Sk.additionalTextures = {}

local function GetElement(frame, element, useParent)
	if useParent then frame = frame:GetParent() end
	local child = frame[element]
	if child then return child end

	local name = frame:GetName()
	if name then return _G[name..element] end
end

local function GetButton(frame, buttons)
	for _, data in ipairs(buttons) do
		if type(data) == 'string' then
			local found = GetElement(frame, data)
			if found then return found end
		else -- has useParent
			local found = GetElement(frame, data[1], data[2])
			if found then return found end
		end
	end
end

local function ThumbStatus(frame)
	if not frame.Thumb then
		return
	elseif not frame:IsEnabled() then
		frame.Thumb.backdrop:SetBackdropColor(0.3, 0.3, 0.3)
		return
	end

	local _, max = frame:GetMinMaxValues()
	if max == 0 then
		frame.Thumb.backdrop:SetBackdropColor(0.3, 0.3, 0.3)
	else
		frame.Thumb.backdrop:SetBackdropColor(unpack(E.media.rgbvaluecolor))
	end
end

local function ThumbWatcher(frame)
	hooksecurefunc(frame, 'Enable', ThumbStatus)
	hooksecurefunc(frame, 'Disable', ThumbStatus)
	hooksecurefunc(frame, 'SetEnabled', ThumbStatus)
	hooksecurefunc(frame, 'SetMinMaxValues', ThumbStatus)
	ThumbStatus(frame)
end

local upButtons = {'ScrollUpButton', 'UpButton', 'ScrollUp', {'scrollUp', true}, 'Back'}
local downButtons = {'ScrollDownButton', 'DownButton', 'ScrollDown', {'scrollDown', true}, 'Forward'}
local thumbButtons = {'ThumbTexture', 'thumbTexture', 'Thumb'}

function Sk:CreateUnderline(frame, texture, shadow, height)
	if frame.SL_Underline then return end
	local line = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
	line:SetPoint('BOTTOM', frame, -1, 1)
	line:SetSize(frame:GetWidth(), height or 1)
	line.Texture = line:CreateTexture(nil, 'OVERLAY')
	line.Texture:SetTexture(texture)
	if shadow then
		if shadow == 'backdrop' then
			line:CreateShadow()
		else
			line:CreateBackdrop()
		end
	end
	line.Texture:SetAllPoints(line)
	frame.SL_Underline = line

	return frame.SL_Underline
end

function Sk:Media()
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.merchant and E.private.sle.skins.merchant.enable and E.private.sle.skins.merchant.style == 'List' then
		for i = 1, 10 do
			local button = _G['SLE_ListMerchantFrame_Button'..i]
			if not button then break end
			button.itemname:FontTemplate(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.nameFont), E.db.sle.skins.merchant.list.nameSize, E.db.sle.skins.merchant.list.nameOutline)
			button.iteminfo:FontTemplate(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.subFont), E.db.sle.skins.merchant.list.subSize, E.db.sle.skins.merchant.list.subOutline)
		end
	end
end

function Sk:ConvertScrollBarToThin(frame, thumbY, thumbX, template, thinWidth)
		assert(frame, 'doesnt exist!')

		if frame.backdrop then return end

		local upButton, downButton = GetButton(frame, upButtons), GetButton(frame, downButtons)
		local thumb = GetButton(frame, thumbButtons) or (frame.GetThumbTexture and frame:GetThumbTexture())

		frame:StripTextures()
		frame:CreateBackdrop(template or 'Transparent', nil, nil, nil, nil, nil, nil, nil, true)

		frame.backdrop:SetPoint('TOP', upButton or frame, upButton and 'BOTTOM' or 'TOP', 0, 0)
		frame.backdrop:SetPoint('BOTTOM', downButton or frame, upButton and 'TOP' or 'BOTTOM', 0, 0)
		frame.backdrop:SetWidth(thinWidth or 8)
		if frame.Background then frame.Background:Hide() end
		if frame.ScrollUpBorder then frame.ScrollUpBorder:Hide() end
		if frame.ScrollDownBorder then frame.ScrollDownBorder:Hide() end

		local frameLevel = frame:GetFrameLevel()
		if upButton then
			S:HandleNextPrevButton(upButton, 'up')
			upButton:SetFrameLevel(frameLevel + 2)
		end
		if downButton then
			S:HandleNextPrevButton(downButton, 'down')
			downButton:SetFrameLevel(frameLevel + 2)
		end

		if thumb and not thumb.backdrop then
			thumb:SetTexture()
			thumb:CreateBackdrop(nil, true, true, nil, nil, nil, nil, nil, frameLevel + 1)

			if not frame.Thumb then
				frame.Thumb = thumb
			end

			if thumb.backdrop then
				if not thumbX then thumbX = 0 end
				if not thumbY then thumbY = 0 end

				thumb.backdrop:Point('TOPLEFT', thumb, thumbX, -thumbY)
				thumb.backdrop:Point('BOTTOMRIGHT', thumb, -thumbX, thumbY)

				if frame.SetEnabled then
					ThumbWatcher(frame)
				else
					thumb.backdrop:SetBackdropColor(unpack(E.media.rgbvaluecolor))
				end
			end
			thumb:SetWidth(thinWidth or 8)
		end
	end

function Sk:Initialize()
	local LQT = LibStub('LibQTip-1.0', true)
	if LQT then
		hooksecurefunc(LQT, 'Acquire', function()
			for _, Tooltip in LQT:IterateTooltips() do
				if not Tooltip.isSkinned then
					Tooltip.NineSlice:Kill()
					Tooltip:CreateBackdrop('Transparent')
					Tooltip.isSkinned = true
				end
			end
		end)
	end
	function Sk:ForUpdateAll()
		Sk:Media()
	end
end

SLE:RegisterModule(Sk:GetName())
