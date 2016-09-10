local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SMB = SLE:NewModule('SquareMinimapButtons','AceHook-3.0', 'AceEvent-3.0');

--GLOBALS: CreateFrame, UIParent
local _G = _G
local RegisterStateDriver = RegisterStateDriver

local strsub, ceil = strsub, ceil
local BorderColor = E["media"].bordercolor
local TexCoords = { 0.1, 0.9, 0.1, 0.9 }

if E.private.sle == nil then E.private.sle = {} end
if E.private.sle.minimap == nil then E.private.sle.minimap = {} end
if E.private.sle.minimap.mapicons == nil then E.private.sle.minimap.mapicons = {} end
if E.private.sle.minimap.mapicons.enable == nil then E.private.sle.minimap.mapicons.enable = false end
if E.private.sle.minimap.mapicons.barenable == nil then E.private.sle.minimap.mapicons.barenable = false end
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local GroupFinderFrame_ShowGroupFrame = GroupFinderFrame_ShowGroupFrame

local SMARTBUFF_MinimapButton_CheckPos, SMARTBUFF_MinimapButton_OnUpdate

local function OnEnter(self)
	UIFrameFadeIn(SMB.bar, 0.2, SMB.bar:GetAlpha(), 1)
	if self:GetName() ~= 'SMB.bar' then
		self:SetBackdropBorderColor(.7, 0, .7)
	end
end

local function OnLeave(self)
	if not SMB.bar then return end
	if E.db.sle.minimap.mapicons.iconmouseover then
		UIFrameFadeOut(SMB.bar, 0.2, SMB.bar:GetAlpha(), 0)
	end
	if self:GetName() ~= 'SMB.bar' then
		self:SetBackdropBorderColor(T.unpack(BorderColor))
	end
end

function SMB:ChangeMouseOverSetting()
	if E.db.sle.minimap.mapicons.iconmouseover then
		SMB.bar:SetAlpha(0)
	else
		SMB.bar:SetAlpha(1)
	end
end

SMB.SkinnedMinimapButtons = {}
SMB.ignoreButtons = {
	'ElvConfigToggle',
	'GameTimeFrame',
	'HelpOpenTicketButton',
	'HelpOpenWebTicketButton',
	'MiniMapTrackingButton',
	'MiniMapVoiceChatFrame',
	'TimeManagerClockButton',
}
SMB.GenericIgnores = {
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
SMB.PartialIgnores = {
	'Node',
	'Note',
	'Pin',
	'POI',
}
SMB.WhiteList = {
	'LibDBIcon',
}
SMB.AcceptedFrames = {
	'BagSync_MinimapButton',
	'VendomaticButtonFrame',
	'MiniMapMailFrame',
}
SMB.AddButtonsToBar = {
	'SmartBuff_MiniMapButton',
	'QueueStatusMinimapButton',
	'MiniMapMailFrame',
	"ItemRackMinimapFrame",
}

local function SkinButton(Button)
	if not Button.isSkinned then
		local Name = Button:GetName()

		if Button:IsObjectType('Button') then
			local ValidIcon = false

			for i = 1, #SMB.WhiteList do
				if strsub(Name, 1, T.strlen(SMB.WhiteList[i])) == SMB.WhiteList[i] then ValidIcon = true break end
			end

			if not ValidIcon then
				for i = 1, #SMB.ignoreButtons do
					if Name == SMB.ignoreButtons[i] then return end
				end

				for i = 1, #SMB.GenericIgnores do
					if strsub(Name, 1, T.strlen(SMB.GenericIgnores[i])) == SMB.GenericIgnores[i] then return end
				end

				for i = 1, #SMB.PartialIgnores do
					if T.find(Name, SMB.PartialIgnores[i]) ~= nil then return end
				end
			end

			Button:SetPushedTexture(nil)
			Button:SetHighlightTexture(nil)
			Button:SetDisabledTexture(nil)
		end

		for i = 1, Button:GetNumRegions() do
			local Region = T.select(i, Button:GetRegions())
			if Region:GetObjectType() == 'Texture' then
				local Texture = Region:GetTexture()

				if Texture and (T.find(Texture, 'Border') or T.find(Texture, 'Background') or T.find(Texture, 'AlphaMask')) then
					Region:SetTexture(nil)
				else
					if Name == 'BagSync_MinimapButton' then Region:SetTexture('Interface\\AddOns\\BagSync\\media\\icon') end
					if Name == 'DBMMinimapButton' then Region:SetTexture('Interface\\Icons\\INV_Helmet_87') end
					if Name == 'SmartBuff_MiniMapButton' then Region:SetTexture(T.select(3, T.GetSpellInfo(12051))) end
					if Name == 'MiniMapMailFrame' then
						Region:ClearAllPoints()
						Region:SetPoint('CENTER', Button)
					end
					if not (Name == 'MiniMapMailFrame' or Name == 'SmartBuff_MiniMapButton') then
						Region:ClearAllPoints()
						Region:SetInside()
						Region:SetTexCoord(T.unpack(TexCoords))
						Button:HookScript('OnLeave', function(self) Region:SetTexCoord(T.unpack(TexCoords)) end)
					end
					Region:SetDrawLayer('ARTWORK')
					Region.SetPoint = function() return end
				end
			end
		end

		Button:SetFrameLevel(_G["Minimap"]:GetFrameLevel() + 5)
		Button:Size(E.db.sle.minimap.mapicons.iconsize)

		if Name == 'SmartBuff_MiniMapButton' then
			Button:SetNormalTexture("Interface\\Icons\\Spell_Nature_Purge")
			Button:GetNormalTexture():SetTexCoord(T.unpack(TexCoords))
			Button.SetNormalTexture = function() end
			Button:SetDisabledTexture("Interface\\Icons\\Spell_Nature_Purge")
			Button:GetDisabledTexture():SetTexCoord(T.unpack(TexCoords))
		elseif Name == 'VendomaticButtonFrame' then
			_G["VendomaticButton"]:StripTextures()
			_G["VendomaticButton"]:SetInside()
			_G["VendomaticButtonIcon"]:SetTexture('Interface\\Icons\\INV_Misc_Rabbit_2')
			_G["VendomaticButtonIcon"]:SetTexCoord(T.unpack(TexCoords))
		end

		if Name == 'QueueStatusMinimapButton' then
			_G["QueueStatusMinimapButton"]:HookScript('OnUpdate', function(self)
				_G["QueueStatusMinimapButtonIcon"]:SetFrameLevel(_G["QueueStatusMinimapButton"]:GetFrameLevel() + 1)
			end)
			local Frame = CreateFrame('Frame', "QueueDummyFrame", E.private.sle.minimap.mapicons.barenable and SMB.bar or Minimap)
			Frame:SetTemplate()
			Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
			Frame.Icon:SetInside()
			Frame.Icon:SetTexture([[Interface\LFGFrame\LFG-Eye]])
			Frame.Icon:SetTexCoord(0, 64 / 512, 0, 64 / 256)
			Frame:SetScript('OnMouseDown', function()
				if _G["PVEFrame"]:IsShown() then
					HideUIPanel(_G["PVEFrame"])
				else
					ShowUIPanel(_G["PVEFrame"])
					GroupFinderFrame_ShowGroupFrame()
				end
			end)
			SMB.bar:HookScript('OnUpdate', function()
				if E.db.sle.minimap.mapicons.skindungeon then
					Frame:Show()
				else
					Frame:Hide()
				end
			end)
			_G["QueueStatusMinimapButton"]:HookScript('OnShow', function()
				if E.db.sle.minimap.mapicons.skindungeon then
					Frame:Show()
				else
					Frame:Hide()
				end
			end)
			Frame:HookScript('OnEnter', OnEnter)
			Frame:HookScript('OnLeave', OnLeave)
			Frame:SetScript('OnUpdate', function(self)
				if _G["QueueStatusMinimapButton"]:IsShown() then
					self:EnableMouse(false)
				else
					self:EnableMouse(true)
				end
				self:Size(E.db.sle.minimap.mapicons.iconsize)
				self:SetFrameStrata(_G["QueueStatusMinimapButton"]:GetFrameStrata())
				self:SetFrameLevel(_G["QueueStatusMinimapButton"]:GetFrameLevel())
				self:SetPoint(_G["QueueStatusMinimapButton"]:GetPoint())
			end)
		elseif Name == 'MiniMapMailFrame' then
			local Frame = CreateFrame('Frame', 'MailDummyFrame', E.private.sle.minimap.mapicons.barenable and SMB.bar or Minimap)
			Frame:Size(E.db.sle.minimap.mapicons.iconsize)
			Frame:SetTemplate(E.private.sle.minimap.mapicons.barenable and "Default" or "NoBackdrop")
			Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
			Frame.Icon:SetPoint('CENTER')
			Frame.Icon:Size(18)
			Frame.Icon:SetTexture(_G["MiniMapMailIcon"]:GetTexture())
			Frame:SetScript('OnEnter', OnEnter)
			Frame:SetScript('OnLeave', OnLeave)
			Frame:SetScript('OnUpdate', function(self)
				if E.db.sle.minimap.mapicons.skinmail then
					Frame:Show()
					Frame:SetPoint(_G["MiniMapMailFrame"]:GetPoint())
				else
					Frame:Hide()
				end
			end)
			_G["MiniMapMailFrame"]:HookScript('OnShow', function(self)
				if E.db.sle.minimap.mapicons.skinmail then
					_G["MiniMapMailIcon"]:SetVertexColor(0, 1, 0)
				end
			end)
			_G["MiniMapMailFrame"]:HookScript('OnHide', function(self) _G["MiniMapMailIcon"]:SetVertexColor(1, 1, 1) end)
		else
			Button:SetTemplate()
			Button:SetBackdropColor(0, 0, 0, 0)
		end

		Button.isSkinned = true
		T.tinsert(SMB.SkinnedMinimapButtons, Button)
	end
end

function SMB:SkinMinimapButtons()
	if not E.private.sle.minimap.mapicons.enable then return end
	for i = 1, _G["Minimap"]:GetNumChildren() do
		local object = T.select(i, _G["Minimap"]:GetChildren())
		if object then
			if object:IsObjectType('Button') and object:GetName() then
				SkinButton(object)
			end
			for _, frame in T.pairs(SMB.AcceptedFrames) do
				if object:IsObjectType('Frame') and object:GetName() == frame then
					SkinButton(object)
				end
			end
		end
	end
end

function SMB:Update()
	if not E.private.sle.minimap.mapicons.barenable then return end

	OnLeave(SMB.bar)
	local AnchorX, AnchorY, MaxX = 0, 1, E.db.sle.minimap.mapicons.iconperrow
	local ButtonsPerRow = E.db.sle.minimap.mapicons.iconperrow
	local NumColumns = ceil(#SMB.SkinnedMinimapButtons / ButtonsPerRow)
	local Spacing, Mult = E.db.sle.minimap.mapicons.spacing, 1
	local Size = E.db.sle.minimap.mapicons.iconsize
	local ActualButtons, Maxed = 0

	if NumColumns == 1 and ButtonsPerRow > #SMB.SkinnedMinimapButtons then
		ButtonsPerRow = #SMB.SkinnedMinimapButtons
	end

	for Key, Frame in T.pairs(SMB.SkinnedMinimapButtons) do
		local Name = Frame:GetName()
		local Exception = false
		for _, Button in T.pairs(SMB.AddButtonsToBar) do
			if Name == Button then
				Exception = true
				if Name == 'SmartBuff_MiniMapButton' then
					SMARTBUFF_MinimapButton_CheckPos = function() end
					SMARTBUFF_MinimapButton_OnUpdate = function() end
				elseif Name == "ItemRackMinimapFrame" then
					ItemRack.MoveMinimap = function() end
				end
				if not E.db.sle.minimap.mapicons.skindungeon and Name == 'QueueStatusMinimapButton' then
					Exception = false
					local pos = E.db.general.minimap.icons.lfgEye.position or "BOTTOMRIGHT"
					local scale = E.db.general.minimap.icons.lfgEye.scale or 1
					_G["QueueStatusMinimapButton"]:ClearAllPoints()
					_G["QueueStatusMinimapButton"]:Point(pos, _G["Minimap"], pos, E.db.general.minimap.icons.lfgEye.xOffset or 3, E.db.general.minimap.icons.lfgEye.yOffset or 0)
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
			local direction_hor = E.db.sle.minimap.mapicons.growth_hor == "Right" and 1 or -1
			local direction_vert = E.db.sle.minimap.mapicons.growth_vert == "Down" and -1 or 1
			local yOffset = (Spacing + ((Size + Spacing) * (AnchorY - 1)))*direction_vert
			local xOffset = (Spacing + ((Size + Spacing) * (AnchorX - 1)))*direction_hor
			Frame:SetTemplate()
			Frame:SetBackdropColor(0, 0, 0, 0)
			Frame:SetParent(SMB.bar)
			Frame:ClearAllPoints()
			Frame:Point('TOPLEFT', SMB.bar, 'TOPLEFT', xOffset, yOffset)
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
			SMB.bar:SetSize(BarWidth, BarHeight)
			E:CreateMover(SMB.bar, "SquareMinimapBar", "Square Minimap Bar", nil, nil, nil, "ALL,S&L,S&L MISC")
		end
	end

	SMB.bar:Show()
end

function SMB:Initialize()
	if not SLE.initialized or not E.private.general.minimap.enable then return end

	_G["QueueStatusMinimapButton"]:SetParent(_G["Minimap"])

	SMB.bar = CreateFrame('Frame', 'SLE_SquareMinimapButtonBar', E.UIParent)
	SMB.bar:Hide()
	SMB.bar:SetTemplate(E.private.sle.minimap.mapicons.template)
	SMB.bar:SetFrameStrata('LOW')
	SMB.bar:SetFrameLevel(1)
	SMB.bar:SetClampedToScreen(true)
	SMB.bar:SetPoint('RIGHT', UIParent, 'RIGHT', -45, 0)
	SMB.bar:SetScript('OnEnter', OnEnter)
	SMB.bar:SetScript('OnLeave', OnLeave)
	RegisterStateDriver(SMB.bar, 'visibility', '[petbattle] hide; show')
	self:SkinMinimapButtons()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'Update')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'Update')
	self:RegisterEvent('ADDON_LOADED', "SkinMinimapButtons")
	E:Delay(5, function()
		SMB:SkinMinimapButtons()
		SMB:Update()
	end)
	SLE.UpdateFunctions["SquareMinimapButtons"] = SMB.Update
end

SLE:RegisterModule(SMB:GetName())