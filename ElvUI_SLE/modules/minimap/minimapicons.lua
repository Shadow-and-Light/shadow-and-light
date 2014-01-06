local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SMB = E:NewModule('SquareMinimapButtons', 'AceHook-3.0', 'AceEvent-3.0');

local strsub, strlen, strfind = strsub, strlen, strfind
local tinsert, unpack = tinsert, unpack
local TexCoords = { 0.1, 0.9, 0.1, 0.9 }

if E.private.sle == nil then E.private.sle = {} end
if E.private.sle.minimap == nil then E.private.sle.minimap = {} end
if E.private.sle.minimap.mapicons == nil then E.private.sle.minimap.mapicons = {} end
if E.db.sle.minimap == nil then E.db.sle.minimap = {} end
if E.db.sle.minimap.mapicons == nil then E.db.sle.minimap.mapicons = {} end

local ignoreButtons = {
	'AsphyxiaUIMinimapHelpButton',
	'AsphyxiaUIMinimapVersionButton',
	'ElvConfigToggle',
	'GameTimeFrame',
	'HelpOpenTicketButton',
	'MiniMapMailFrame',
	'MiniMapTrackingButton',
	'MiniMapVoiceChatFrame',
	'QueueStatusMinimapButton',
	'TimeManagerClockButton',
}

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

local SkinnedMinimapButtons = {}

local GenericIgnores = {
	'Archy',
	'GatherMatePin',
	'GatherNote',
	'GuildInstance',
	'HandyNotesPin',
	'MinimMap',
	'Spy_MapNoteList_mini',
	'ZGVMarker',
}

local PartialIgnores = {
	'Node',
	'Note',
	'Pin',
}

local WhiteList = {
	'LibDBIcon',
}

local AcceptedFrames = {
	'BagSync_MinimapButton',
}

local function SkinFrame(Frame)
	if not Frame.isSkinned then
		for i = 1, Frame:GetNumRegions() do
			local Region = select(i, Frame:GetRegions())
			if Region:GetObjectType() == 'Texture' then
				local Texture = Region:GetTexture()
				if Frame:GetName() == 'BagSync_MinimapButton' then Region:SetTexture('Interface\\AddOns\\BagSync\\media\\icon.tga') end

				if Texture and (strfind(Texture, 'Border') or strfind(Texture, 'Background') or strfind(Texture, 'AlphaMask')) then
					Region:SetTexture(nil)
				else
					Region:ClearAllPoints()
					Region:SetInside()
					Region:SetTexCoord(unpack(TexCoords))
					Region:SetDrawLayer('ARTWORK')
					Frame:HookScript('OnLeave', function(self) Region:SetTexCoord(unpack(TexCoords)) end)
					if Name == 'PS_MinimapButton' then Region.SetPoint = function() end end
				end
			end
		end

		tinsert(SkinnedMinimapButtons, Frame)

		Frame:Size(24)
		Frame:SetTemplate('Default')
		Frame.isSkinned = true
	end
end

local function SkinButton(Frame)
	if not Frame.isSkinned then
		local Name = Frame:GetName()
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

		if Name == 'DBMMinimapButton' then Frame:SetNormalTexture('Interface\\Icons\\INV_Helmet_87') end
		if Name == 'SmartBuff_MiniMapButton' then Frame:SetNormalTexture(select(3, GetSpellInfo(12051))) end

		for i = 1, Frame:GetNumRegions() do
			local Region = select(i, Frame:GetRegions())
			if Region:GetObjectType() == 'Texture' then
				local Texture = Region:GetTexture()

				if Texture and (strfind(Texture, 'Border') or strfind(Texture, 'Background') or strfind(Texture, 'AlphaMask')) then
					Region:SetTexture(nil)
				else
					Region:ClearAllPoints()
					Region:SetInside()
					Region:SetTexCoord(unpack(TexCoords))
					Region:SetDrawLayer('ARTWORK')
					Frame:HookScript('OnLeave', function(self) Region:SetTexCoord(unpack(TexCoords)) end)
					if Name == 'PS_MinimapButton' then Region.SetPoint = function() end end
				end
			end
		end

		tinsert(SkinnedMinimapButtons, Frame)

		Frame:Size(24)
		Frame:SetPushedTexture(nil)
		Frame:SetHighlightTexture(nil)
		Frame:SetDisabledTexture(nil)
		Frame:SetTemplate()
		BorderColor = { Frame:GetBackdropBorderColor() }
		Frame.isSkinned = true
	end
end

local SquareMinimapButtonBar = CreateFrame('Frame', 'SquareMinimapButtonBar', UIParent)
SquareMinimapButtonBar:RegisterEvent('ADDON_LOADED')
SquareMinimapButtonBar:RegisterEvent('PLAYER_ENTERING_WORLD')
SquareMinimapButtonBar.Skin = function()
	for i = 1, Minimap:GetNumChildren() do
		local object = select(i, Minimap:GetChildren())
		if object:GetObjectType() == 'Button' and object:GetName() then
			SkinButton(object)
		end
		for _, frame in pairs(AcceptedFrames) do
			if object:GetName() == frame then
				SkinFrame(object)
			end
		end
	end
end

function SMB:Update()
--SquareMinimapButtonBar.Update = function()
	if not E.private.sle.minimap.mapicons.enable then return end

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
		if Frame:IsVisible() then
			AnchorX = AnchorX + 1
			ActualButtons = ActualButtons + 1
			if AnchorX > MaxX then
				AnchorY = AnchorY + 1
				AnchorX = 1
				Maxed = true
			end

			local yOffset = - Spacing - ((Size + Spacing) * (AnchorY - 1))
			local xOffset = Spacing + ((Size + Spacing) * (AnchorX - 1))
			Frame:SetParent(SquareMinimapButtonBar)
			Frame:ClearAllPoints()
			Frame:Point('TOPLEFT', SquareMinimapButtonBar, 'TOPLEFT', xOffset, yOffset)
			Frame:Size(E.db.sle.minimap.mapicons.iconsize)
			Frame:SetFrameStrata('LOW')
			Frame:RegisterForDrag('LeftButton')
			Frame:SetScript('OnDragStart', function(self) self:GetParent():StartMoving() end)
			Frame:SetScript('OnDragStop', function(self) self:GetParent():StopMovingOrSizing() end)
			Frame:HookScript('OnEnter', OnEnter)
			Frame:HookScript('OnLeave', OnLeave)
		end
	end

	if Maxed then ActualButtons = ButtonsPerRow end

	local BarWidth = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))

	SquareMinimapButtonBar:Size(BarWidth, BarHeight)
	SquareMinimapButtonBar:Show()
end

SquareMinimapButtonBar:SetScript('OnEvent', function(self, event, addon)
	if addon == AddOnName then
		if E.db.sle.minimap.mapicons.iconmouseover == nil then E.db.sle.minimap.mapicons.iconmouseover = false end
		if E.private.sle.minimap.mapicons.enable == nil then E.private.sle.minimap.mapicons.enable = false end
		if E.db.sle.minimap.mapicons.iconsize == nil then E.db.sle.minimap.mapicons.iconsize = 27 end
		if E.db.sle.minimap.mapicons.iconperrow == nil then E.db.sle.minimap.mapicons.iconperrow = 12 end
		self:Hide()
		self:SetTemplate('Transparent', true)
		self:SetFrameStrata('BACKGROUND')
		self:SetClampedToScreen(true)
		self:SetMovable()
		self:SetPoint('RIGHT', UIParent, 'RIGHT', -45, 0)
		self:SetScript('OnEnter', OnEnter)
		self:SetScript('OnLeave', OnLeave)
		self:RegisterForDrag('LeftButton')
		self:SetScript('OnDragStart', self.StartMoving)
		self:SetScript('OnDragStop', self.StopMovingOrSizing)
		self:UnregisterEvent(event)
	end
	self.Skin()
	if event == 'PLAYER_ENTERING_WORLD' then ElvUI[1]:Delay(5, self.Skin) self:UnregisterEvent(event) end
	if E.private.sle.minimap.mapicons.enable then SMB:Update() end
	OnLeave(self)
end)



E:RegisterModule(SMB:GetName())