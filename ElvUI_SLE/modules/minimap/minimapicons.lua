local E, L, V, P, G = unpack(ElvUI);
local SMB = E:GetModule('SLE_SquareMinimapButtons');


local AddOnName, NS = ...
local strsub, strlen, strfind, ceil = strsub, strlen, strfind, ceil
local tinsert, pairs, unpack = tinsert, pairs, unpack

local SkinnedMinimapButtons = {}
local BorderColor = E['media'].bordercolor
local TexCoords = { 0.1, 0.9, 0.1, 0.9 }
local SquareMinimapButtonBar

if E.private.sle == nil then E.private.sle = {} end
if E.private.sle.minimap == nil then E.private.sle.minimap = {} end
if E.private.sle.minimap.mapicons == nil then E.private.sle.minimap.mapicons = {} end
if E.private.sle.minimap.mapicons.enable == nil then E.private.sle.minimap.mapicons.enable = false end
if E.private.sle.minimap.mapicons.barenable == nil then E.private.sle.minimap.mapicons.barenable = false end

if E.db.sle.minimap == nil then E.db.sle.minimap = {} end
if E.db.sle.minimap.mapicons == nil then E.db.sle.minimap.mapicons = {} end
if E.db.sle.minimap.mapicons.iconmouseover == nil then E.db.sle.minimap.mapicons.iconmouseover = false end
if E.db.sle.minimap.mapicons.iconsize == nil then E.db.sle.minimap.mapicons.iconsize = 27 end
if E.db.sle.minimap.mapicons.iconperrow == nil then E.db.sle.minimap.mapicons.iconperrow = 12 end
if E.db.sle.minimap.mapicons.skindungeon == nil then E.db.sle.minimap.mapicons.skindungeon = false end
if E.db.sle.minimap.mapicons.skinmail == nil then E.db.sle.minimap.mapicons.skinmail = false end

QueueStatusMinimapButton:SetParent(Minimap)

local function OnEnter(self)
	UIFrameFadeIn(SquareMinimapButtonBar, 0.2, SquareMinimapButtonBar:GetAlpha(), 1)
	if self:GetName() ~= 'SquareMinimapButtonBar' then
		self:SetBackdropBorderColor(.7, 0, .7)
	end
end

local function OnLeave(self)
	if E.db.sle.minimap.mapicons.iconmouseover then
		UIFrameFadeOut(SquareMinimapButtonBar, 0.2, SquareMinimapButtonBar:GetAlpha(), 0)
	end
	if self:GetName() ~= 'SquareMinimapButtonBar' then
		self:SetBackdropBorderColor(unpack(BorderColor))
	end
end

function SMB:ChangeMouseOverSetting()
	if E.db.sle.minimap.mapicons.iconmouseover then
		SquareMinimapButtonBar:SetAlpha(0)
	else
		SquareMinimapButtonBar:SetAlpha(1)
	end
end

local ignoreButtons = {
	'ElvConfigToggle',
	'GameTimeFrame',
	'HelpOpenTicketButton',
	'MiniMapTrackingButton',
	'MiniMapVoiceChatFrame',
	'TimeManagerClockButton',
}

local GenericIgnores = {
	'Archy',
	'GatherMatePin',
	'GatherNote',
	'GuildInstance',
	'HandyNotesPin',
	'MinimMap',
	'poiMinimap',
	'Spy_MapNoteList_mini',
	'ZGVMarker',
}

local PartialIgnores = {
	'Node',
	'Note',
	'Pin',
	'POI',
}

local WhiteList = {
	'LibDBIcon',
}

local AcceptedFrames = {
	'BagSync_MinimapButton',
	'VendomaticButtonFrame',
	'MiniMapMailFrame',
}

local AddButtonsToBar = {
	'SmartBuff_MiniMapButton',
	'QueueStatusMinimapButton',
	'MiniMapMailFrame',
}

local function SkinButton(Button)
	if not Button.isSkinned then
		local Name = Button:GetName()

		if Button:IsObjectType('Button') then
			local ValidIcon = false

			for i = 1, #WhiteList do
				if strsub(Name, 1, strlen(WhiteList[i])) == WhiteList[i] then ValidIcon = true break end
			end

			if not ValidIcon then
				for i = 1, #ignoreButtons do
					if Name == ignoreButtons[i] then return end
				end

				for i = 1, #GenericIgnores do
					if strsub(Name, 1, strlen(GenericIgnores[i])) == GenericIgnores[i] then return end
				end

				for i = 1, #PartialIgnores do
					if strfind(Name, PartialIgnores[i]) ~= nil then return end
				end
			end

			Button:SetPushedTexture(nil)
			Button:SetHighlightTexture(nil)
			Button:SetDisabledTexture(nil)
		end

		for i = 1, Button:GetNumRegions() do
			local Region = select(i, Button:GetRegions())
			if Region:GetObjectType() == 'Texture' then
				local Texture = Region:GetTexture()

				if Texture and (strfind(Texture, 'Border') or strfind(Texture, 'Background') or strfind(Texture, 'AlphaMask')) then
					Region:SetTexture(nil)
				else
					if Name == 'BagSync_MinimapButton' then Region:SetTexture('Interface\\AddOns\\BagSync\\media\\icon') end
					if Name == 'DBMMinimapButton' then Region:SetTexture('Interface\\Icons\\INV_Helmet_87') end
					if Name == 'SmartBuff_MiniMapButton' then Region:SetTexture(select(3, GetSpellInfo(12051))) end
					if Name == 'MiniMapMailFrame' then
						Region:ClearAllPoints()
						Region:SetPoint('CENTER', Button)
					end
					if not (Name == 'MiniMapMailFrame' or Name == 'SmartBuff_MiniMapButton') then
						Region:ClearAllPoints()
						Region:SetInside()
						Region:SetTexCoord(unpack(TexCoords))
						Button:HookScript('OnLeave', function(self) Region:SetTexCoord(unpack(TexCoords)) end)
					end
					Region:SetDrawLayer('ARTWORK')
					Region.SetPoint = function() return end
				end
			end
		end

		Button:SetFrameLevel(Minimap:GetFrameLevel() + 5)
		Button:Size(E.db.sle.minimap.mapicons.iconsize)

		if Name == 'SmartBuff_MiniMapButton' then
			Button:SetNormalTexture("Interface\\Icons\\Spell_Nature_Purge")
			Button:GetNormalTexture():SetTexCoord(unpack(TexCoords))
			Button.SetNormalTexture = function() end
			Button:SetDisabledTexture("Interface\\Icons\\Spell_Nature_Purge")
			Button:GetDisabledTexture():SetTexCoord(unpack(TexCoords))
		elseif Name == 'VendomaticButtonFrame' then
			VendomaticButton:StripTextures()
			VendomaticButton:SetInside()
			VendomaticButtonIcon:SetTexture('Interface\\Icons\\INV_Misc_Rabbit_2')
			VendomaticButtonIcon:SetTexCoord(unpack(TexCoords))
		end

		if Name == 'QueueStatusMinimapButton' then
			QueueStatusMinimapButton:HookScript('OnUpdate', function(self)
				QueueStatusMinimapButtonIcon:SetFrameLevel(QueueStatusMinimapButton:GetFrameLevel() + 1)
			end)
			local Frame = CreateFrame('Frame', QueueDummyFrame, SquareMinimapButtonBar)
			Frame:SetTemplate()
			Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
			Frame.Icon:SetInside()
			Frame.Icon:SetTexture([[Interface\LFGFrame\LFG-Eye]])
			Frame.Icon:SetTexCoord(0, 64 / 512, 0, 64 / 256)
			Frame:SetScript('OnMouseDown', function()
				if PVEFrame:IsShown() then
					HideUIPanel(PVEFrame)
				else
					ShowUIPanel(PVEFrame)
					GroupFinderFrame_ShowGroupFrame()
				end
			end)
			SquareMinimapButtonBar:HookScript('OnUpdate', function()
				if E.db.sle.minimap.mapicons.skindungeon then
					Frame:Show()
				else
					Frame:Hide()
				end
			end)
			QueueStatusMinimapButton:HookScript('OnShow', function()
				if E.db.sle.minimap.mapicons.skindungeon then
					Frame:Show()
				else
					Frame:Hide()
				end
			end)
			Frame:HookScript('OnEnter', OnEnter)
			Frame:HookScript('OnLeave', OnLeave)
			Frame:SetScript('OnUpdate', function(self)
				if QueueStatusMinimapButton:IsShown() then
					self:EnableMouse(false)
				else
					self:EnableMouse(true)
				end
				self:Size(E.db.sle.minimap.mapicons.iconsize)
				self:SetFrameStrata(QueueStatusMinimapButton:GetFrameStrata())
				self:SetFrameLevel(QueueStatusMinimapButton:GetFrameLevel())
				self:SetPoint(QueueStatusMinimapButton:GetPoint())
			end)
		elseif Name == 'MiniMapMailFrame' then
			local Frame = CreateFrame('Frame', 'MailDummyFrame', SquareMinimapButtonBar)
			Frame:Size(E.db.sle.minimap.mapicons.iconsize)
			Frame:SetTemplate()
			Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
			Frame.Icon:SetPoint('CENTER')
			Frame.Icon:Size(18)
			Frame.Icon:SetTexture(MiniMapMailIcon:GetTexture())
			Frame:SetScript('OnEnter', OnEnter)
			Frame:SetScript('OnLeave', OnLeave)
			Frame:SetScript('OnUpdate', function(self)
				if E.db.sle.minimap.mapicons.skinmail then
					Frame:Show()
					Frame:SetPoint(MiniMapMailFrame:GetPoint())
				else
					Frame:Hide()
				end
			end)
			MiniMapMailFrame:HookScript('OnShow', function(self)
				if E.db.sle.minimap.mapicons.skinmail then
					MiniMapMailIcon:SetVertexColor(0, 1, 0)
				end
			end)
			MiniMapMailFrame:HookScript('OnHide', function(self) MiniMapMailIcon:SetVertexColor(1, 1, 1) end)
		else
			Button:SetTemplate()
			Button:SetBackdropColor(0, 0, 0, 0)
		end

		Button.isSkinned = true
		tinsert(SkinnedMinimapButtons, Button)
	end
end

local function SkinMinimapButtons()
	for i = 1, Minimap:GetNumChildren() do
		local object = select(i, Minimap:GetChildren())
		if object then
			if object:IsObjectType('Button') and object:GetName() then
				SkinButton(object)
			end
			for _, frame in pairs(AcceptedFrames) do
				if object:IsObjectType('Frame') and object:GetName() == frame then
					SkinButton(object)
				end
			end
		end
	end
end

function SMB:Update()
	if not E.private.sle.minimap.mapicons.barenable then return end

	OnLeave(SquareMinimapButtonBar)
	local AnchorX, AnchorY, MaxX = 0, 1, E.db.sle.minimap.mapicons.iconperrow
	local ButtonsPerRow = E.db.sle.minimap.mapicons.iconperrow
	local NumColumns = ceil(#SkinnedMinimapButtons / ButtonsPerRow)
	local Spacing, Mult = 4, 1
	local Size = E.db.sle.minimap.mapicons.iconsize
	local ActualButtons, Maxed = 0

	if NumColumns == 1 and ButtonsPerRow > #SkinnedMinimapButtons then
		ButtonsPerRow = #SkinnedMinimapButtons
	end

	for Key, Frame in pairs(SkinnedMinimapButtons) do
		local Name = Frame:GetName()
		local Exception = false
		for _, Button in pairs(AddButtonsToBar) do
			if Name == Button then
				Exception = true
				if Name == 'SmartBuff_MiniMapButton' then
					SMARTBUFF_MinimapButton_CheckPos = function() end
					SMARTBUFF_MinimapButton_OnUpdate = function() end
				end
				if not E.db.sle.minimap.mapicons.skindungeon and Name == 'QueueStatusMinimapButton' then
					Exception = false
					QueueStatusMinimapButton:ClearAllPoints()
					QueueStatusMinimapButton:Point("BOTTOMRIGHT", Minimap, -3, 3)
				end
				if (not E.db.sle.minimap.mapicons.skinmail and Name == 'MiniMapMailFrame') then
					Exception = false
				end
			end
		end
		if Frame:IsVisible() and not (Name == 'QueueStatusMinimapButton' or Name == 'MiniMapMailFrame') or Exception then
			AnchorX = AnchorX + 1
			ActualButtons = ActualButtons + 1
			if AnchorX > MaxX then
				AnchorY = AnchorY + 1
				AnchorX = 1
				Maxed = true
			end
			local yOffset = - Spacing - ((Size + Spacing) * (AnchorY - 1))
			local xOffset = Spacing + ((Size + Spacing) * (AnchorX - 1))
			Frame:SetTemplate()
			Frame:SetBackdropColor(0, 0, 0, 0)
			Frame:SetParent(SquareMinimapButtonBar)
			Frame:ClearAllPoints()
			Frame:Point('TOPLEFT', SquareMinimapButtonBar, 'TOPLEFT', xOffset, yOffset)
			Frame:SetSize(E.db.sle.minimap.mapicons.iconsize, E.db.sle.minimap.mapicons.iconsize)
			Frame:SetFrameStrata('LOW')
			Frame:SetFrameLevel(3)
			Frame:SetScript('OnDragStart', function() end)
			Frame:SetScript('OnDragStop', function() end)
			Frame:HookScript('OnEnter', OnEnter)
			Frame:HookScript('OnLeave', OnLeave)
			if Maxed then ActualButtons = ButtonsPerRow end

			local BarWidth = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
			local BarHeight = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))
			SquareMinimapButtonBar:SetSize(BarWidth, BarHeight)
			E:CreateMover(SquareMinimapButtonBar, "SquareMinimapBar", "Square Minimap Bar", nil, nil, nil, "ALL,SOLO")
		end
	end

	SquareMinimapButtonBar:Show()
end

function SMB:Initialize()
	if not E.private.sle.minimap.mapicons.enable then return end
	SquareMinimapButtonBar = CreateFrame('Frame', 'SquareMinimapButtonBar', E.UIParent)
	SquareMinimapButtonBar:Hide()
	SquareMinimapButtonBar:SetTemplate('Transparent', true)
	SquareMinimapButtonBar:SetFrameStrata('LOW')
	SquareMinimapButtonBar:SetFrameLevel(1)
	SquareMinimapButtonBar:SetClampedToScreen(true)
	SquareMinimapButtonBar:SetPoint('RIGHT', UIParent, 'RIGHT', -45, 0)
	SquareMinimapButtonBar:SetScript('OnEnter', OnEnter)
	SquareMinimapButtonBar:SetScript('OnLeave', OnLeave)
	RegisterStateDriver(SquareMinimapButtonBar, 'visibility', '[petbattle] hide; show')
	SkinMinimapButtons()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'Update')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'Update')
	self:RegisterEvent('ADDON_LOADED', SkinMinimapButtons)
	E:Delay(5, function()
		SkinMinimapButtons()
		SMB:Update()
	end)
end