local E, L, V, P, G = unpack(ElvUI)
local IFO = E:GetModule('InspectFrameOptions')
local SLE = E:GetModule('SLE');
local S = E:GetModule('Skins')

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Inspect Frame like Wow-Armory					>>--
--------------------------------------------------------------------------------
local IA = CreateFrame('Frame', 'InspectArmory', E.UIParent)
local ENI = _G['EnhancedNotifyInspect'] or { CancelInspect = function() end }
local AISM = _G['Armory_InspectSupportModule']
local ButtonName = INSPECT

local C = SLArmoryConstants

local CORE_FRAME_LEVEL = 10
local SLOT_SIZE = 37
local TAB_HEIGHT = 22
local SIDE_BUTTON_WIDTH = 16
local SPACING = 3
local INFO_TAB_SIZE = 22
local TALENT_SLOT_SIZE = 26
local GLYPH_SLOT_HEIGHT = 22

local HeadSlotItem = 1020
local BackSlotItem = 102246
local Default_NotifyInspect, Default_InspectUnit

--<< Key Table >>--
IA.PageList = { Character = 'CHARACTER', Info = 'INFO', Spec = 'TALENTS' }
IA.InfoPageCategoryList = { 'Profession', 'PvP', 'Guild' }
IA.UnitPopupList = { FRIEND = true, GUILD = true, RAID = true, FOCUS = true, PLAYER = true, PARTY = true, RAID_PLAYER = true }
IA.ModelList = {
	Human = { RaceID = 1, [2] = { x = 0.02, y = -0.025, z = -0.6 }, [3] = { x = -0.01, y = -0.08, z = -0.6 } },
	Dwarf = { RaceID = 3, [2] = { x = -0.01, y = -0.23, z = -0.9 }, [3] = { x = -0.03, y = -0.15, z = -0.8 } },
	NightElf = { RaceID = 4, [2] = { z = -0.7 }, [3] = { x = -0.02, y = -0.04, z = -0.7 }},
	Gnome = { RaceID = 7, [2] = { y = -0.2, z = -1 }, [3] = { x = -0.01, y = -0.19, z = -0.9 } },
	Draenei = { RaceID = 11, [2] = { x = -0.04, y = -0.08, z = -0.7 }, [3] = { x = -0.02, y = -0.01, z = -0.6 }},
	Worgen = { RaceID = 22, [2] = { x = -0.09, y = -0.1, z = -0.4 }, [3] = { x = -0.01, y = 0.01, z = 0.06 }},
	Orc = { RaceID = 2, [2] = { y = -0.06, z = -1 }, [3] = { x = -0.01, y = -0.05, z = -0.7 }},
	Scourge = { RaceID = 5, [2] = { y = -0.08, z = -0.7 }, [3] = { y = -0.05, z = -0.6 }},
	Tauren = { RaceID = 6, [2] = { y = -0.09, z = -0.7 }, [3] = { y = -0.16, z = -0.6 } },
	Troll = { RaceID = 8, [2] = { y = -0.14, z = -1.1 }, [3] = { y = -0.11, z = -0.8 }},
	BloodElf = { RaceID = 10, [2] = { x = 0.02, y = -0.01, z = -0.5 }, [3] = { x = 0.04, y = -0.01, z = -0.6 }},
	Goblin = { RaceID = 9, [2] = { y = -0.23, z = -1.3 }, [3] = { x = -0.01, y = -0.25, z = -1.3 } },
	Pandaren = { RaceID = 24, [2] = { x = 0.02, y = 0.02, z = -0.6 }, [3] = { x = 0, y = -0.05, z = -1 } },
}
IA.CurrentInspectData = {}
IA.Default_CurrentInspectData = {
	Gear = {
		HeadSlot = {}, NeckSlot = {}, ShoulderSlot = {}, BackSlot = {}, ChestSlot = {},
		ShirtSlot = {}, TabardSlot = {}, WristSlot = {}, MainHandSlot = {},
		
		HandsSlot = {}, WaistSlot = {}, LegsSlot = {}, FeetSlot = {}, Finger0Slot = {},
		Finger1Slot = {}, Trinket0Slot = {}, Trinket1Slot = {}, SecondaryHandSlot = {}
	},
	SetItem = {},
	Specialization = { [1] = {}, [2] = {} },
	Glyph = { [1] = {}, [2] = {} },
	Profession = { [1] = {}, [2] = {} },
	PvP = {}
}


do --<< Button Script >>--
	IA.OnEnter = function(self)
		if self.Link or self.Message then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			
			self:SetScript('OnUpdate', function()
				GameTooltip:ClearLines()
				
				if self.Link then
					GameTooltip:SetHyperlink(self.Link)
				end
				
				if self.Link and self.Message then GameTooltip:AddLine(' ') end -- Line space
				
				if self.Message then
					GameTooltip:AddLine(self.Message, 1, 1, 1)
				end
				
				GameTooltip:Show()
			end)
		end
	end
	
	IA.OnLeave = function(self)
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	IA.OnClick = function(self)
		if self.Link then
			if HandleModifiedItemClick(self.Link) then
			elseif self.EnableAuctionSearch and BrowseName and BrowseName:IsVisible() then
				AuctionFrameBrowse_Reset(BrowseResetButton)
				BrowseName:SetText(self:GetParent().text:GetText())
				BrowseName:SetFocus()
			end
		end
	end
	
	IA.Button_OnEnter = function(self)
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		self.text:SetText(C.Toolkit.Color_Value(self.buttonString))
	end

	IA.Button_OnLeave = function(self)
		self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		self.text:SetText(self.buttonString)
	end

	IA.EquipmentSlot_OnEnter = function(self)
		if C.CanTransmogrifySlot[self.SlotName] and type(self.TransmogrifyLink) == 'number' and not GetItemInfo(self.TransmogrifyLink) then
			self:SetScript('OnUpdate', function()
				if GetItemInfo(self.TransmogrifyLink) then
					IA.EquipmentSlot_OnEnter(self)
					self:SetScript('OnUpdate', nil)
				end
			end)
			return
		end
		
		if self.Link then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			GameTooltip:SetHyperlink(self.Link)
			
			local CurrentLineText, SetName
			for i = 1, GameTooltip:NumLines() do
				CurrentLineText = _G['GameTooltipTextLeft'..i]:GetText()
				
				SetName = CurrentLineText:match('^(.+) %((%d)/(%d)%)$')
				
				if SetName then
					local SetCount = 0
					
					if type(IA.SetItem[SetName]) == 'table' then
						for dataType, Data in pairs(IA.SetItem[SetName]) do
							if type(dataType) == 'string' then -- Means SetOption Data
								local CurrentLineNum = i + #IA.SetItem[SetName] + 1 + dataType:match('^.+(%d)$')
								local CurrentText = _G['GameTooltipTextLeft'..CurrentLineNum]:GetText()
								local CurrentTextType = CurrentText:match("^%((%d)%)%s.+:%s.+$") or true
								
								if Data ~= CurrentTextType then
									if Data == true and CurrentTextType ~= true then
										_G['GameTooltipTextLeft'..CurrentLineNum]:SetText(GREEN_FONT_COLOR_CODE..(strsub(CurrentText, (strlen(CurrentTextType) + 4))))
									else
										_G['GameTooltipTextLeft'..CurrentLineNum]:SetText(GRAY_FONT_COLOR_CODE..'('..Data..') '..CurrentText)
									end
								end
							else
								if Data:find(LIGHTYELLOW_FONT_COLOR_CODE) then
									SetCount = SetCount + 1
								end
								
								_G['GameTooltipTextLeft'..(i + dataType)]:SetText(Data)
							end
						end
						
						_G['GameTooltipTextLeft'..i]:SetText(string.gsub(CurrentLineText, ' %(%d/', ' %('..SetCount..'/', 1))
					end
					
					break
				elseif C.CanTransmogrifySlot[self.SlotName] and C.ItemBindString[CurrentLineText] and self.TransmogrifyAnchor.Link then
					_G['GameTooltipTextLeft'..i]:SetText(E:RGBToHex(1, .5, 1)..format(TRANSMOGRIFIED, GetItemInfo(self.TransmogrifyAnchor.Link) or self.TransmogrifyAnchor.Link)..'|r|n'..CurrentLineText)
				end
			end
			
			GameTooltip:Show()
		end
	end
	
	IA.ScrollFrame_OnMouseWheel = function(self, spinning)
		local Page = self:GetScrollChild()
		local PageHeight = Page:GetHeight()
		local WindowHeight = self:GetHeight()
		
		if PageHeight > WindowHeight then
			self.Offset = (self.Offset or 0) - spinning * 5
			
			Page:ClearAllPoints()
			if self.Offset > PageHeight - WindowHeight then
				self.Offset = PageHeight - WindowHeight
				
				Page:Point('BOTTOMLEFT', self)
				Page:Point('BOTTOMRIGHT', self)
				return
			elseif self.Offset < 0 then
				self.Offset = 0
			end
		else
			self.Offset = 0
		end
		
		Page:Point('TOPLEFT', self, 0, self.Offset)
		Page:Point('TOPRIGHT', self, 0, self.Offset)
	end
	
	IA.Category_OnClick = function(self)
		self = self:GetParent()
		
		self.Closed = not self.Closed
		
		IA:ReArrangeCategory()
	end
	
	IA.GemSocket_OnEnter = function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if type(Parent.GemItemID) == 'number' then
				if GetItemInfo(Parent.GemItemID) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(Parent.GemItemID)))
				else
					self:SetScript('OnUpdate', function()
						if GetItemInfo(Parent.GemItemID) then
							IA.GemSocket_OnEnter(self)
							self:SetScript('OnUpdate', nil)
						end
					end)
					return
				end
			else
				GameTooltip:ClearLines()
				GameTooltip:AddLine('|cffffffff'..Parent.GemItemID)
			end
		elseif Parent.GemType then
			GameTooltip:ClearLines()
			GameTooltip:AddLine('|cffffffff'.._G['EMPTY_SOCKET_'..Parent.GemType])
		end
		
		GameTooltip:Show()
	end
	
	IA.GemSocket_OnClick = function(self, button)
		self = self:GetParent()
		
		if self.GemItemID and type(self.GemItemID) == 'number' then
			local itemName, itemLink = GetItemInfo(self.GemItemID)
			
			if not IsShiftKeyDown() then
				SetItemRef(itemLink, itemLink, 'LeftButton')
			else
				if HandleModifiedItemClick(itemLink) then
				elseif BrowseName and BrowseName:IsVisible() then
					AuctionFrameBrowse_Reset(BrowseResetButton)
					BrowseName:SetText(itemName)
					BrowseName:SetFocus()
				end
			end
		end
	end
	
	IA.Transmogrify_OnEnter = function(self)
		self.Texture:SetVertexColor(1, .8, 1)
		
		if self.Link then
			if GetItemInfo(self.Link) then
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
				GameTooltip:SetHyperlink(select(2, GetItemInfo(self.Link)))
				GameTooltip:Show()
			else
				self:SetScript('OnUpdate', function()
					if GetItemInfo(self.Link) then
						IA.Transmogrify_OnEnter(self)
						self:SetScript('OnUpdate', nil)
					end
				end)
			end
		end
	end
	
	IA.Transmogrify_OnLeave = function(self)
		self:SetScript('OnUpdate', nil)
		self.Texture:SetVertexColor(1, .5, 1)
		
		GameTooltip:Hide()
	end
end
SLI.CurrentGroupMode = 'NoGroup'
local function CheckGroupMode()
	local Check
	if not (IsInGroup() or IsInRaid()) or GetNumGroupMembers() == 1 then
		Check = 'NoGroup'
	else
		if IsInRaid() then
			Check = 'raid'
		else
			Check = 'party'
		end
	end
	if SLI.CurrentGroupMode ~= Check then
		SLI.CurrentGroupMode = Check
	end
end
IFO:RegisterEvent('GROUP_ROSTER_UPDATE', CheckGroupMode)
IFO:RegisterEvent('PLAYER_ENTERING_WORLD', CheckGroupMode)

function IA:ChangePage(Type)
	for pageType in pairs(self.PageList) do
		if self[pageType] then
			if Type == pageType..'Button' then
				Type = pageType
				self[pageType]:Show()
			else
				self[pageType]:Hide()
			end
		end
	end
	
	self.MainHandSlot:ClearAllPoints()
	self.SecondaryHandSlot:ClearAllPoints()
	if Type == 'Character' then
		for _, slotName in pairs(C.GearList) do
			self[slotName].ItemLevel:Hide()
		end
		self.Model:Point('TOPRIGHT', self.HandsSlot)
		self.MainHandSlot:Point('BOTTOMRIGHT', self.BP, 'TOP', -2, SPACING)
		self.SecondaryHandSlot:Point('BOTTOMLEFT', self.BP, 'TOP', 2, SPACING)
	else
		for _, slotName in pairs(C.GearList) do
			self[slotName].ItemLevel:Show()
		end
		self.Model:Point('TOPRIGHT', UIParent, 'BOTTOMLEFT')
		self.MainHandSlot:Point('BOTTOMLEFT', self.BP, 'TOPLEFT', 1, SPACING)
		self.SecondaryHandSlot:Point('BOTTOMRIGHT', self.BP, 'TOPRIGHT', -1, SPACING)
	end
	
	if self[Type].Message then
		self.Message:SetText(self[Type].Message)
		self.MessageFrame.Page:Width(self.Message:GetWidth())
		self.MessageFrame.UpdatedTime = nil
		self.MessageFrame.Offset = 0
		self.MessageFrame.Page:ClearAllPoints()
		self.MessageFrame.Page:Point('TOPLEFT', self.MessageFrame)
		self.MessageFrame.Page:Point('BOTTOMLEFT', self.MessageFrame)
		self.MessageFrame:Show()
	else
		self.MessageFrame:Hide()
	end
end


function IA:CreateInspectFrame()
	do --<< Core >>--
		self:Size(450, 480)
		self:CreateBackdrop('Transparent')
		self:SetFrameStrata('DIALOG')
		self:SetFrameLevel(CORE_FRAME_LEVEL)
		self:SetMovable(true)
		self:SetClampedToScreen(true)
		self:SetScript('OnHide', function()
			PlaySound('igCharacterInfoClose')
			
			if self.CurrentInspectData.Name then
				local TableIndex = self.CurrentInspectData.Name..(IA.CurrentInspectData.Realm and '-'..IA.CurrentInspectData.Realm or '')
				
				if AISM then
					AISM.RegisteredFunction.InspectArmory = nil
				end
				
				ENI.CancelInspect(TableIndex)
				IA:UnregisterEvent('INSPECT_READY')
				IA:UnregisterEvent('INSPECT_HONOR_UPDATE')
			end
			
			self.LastDataSetting = nil
			self.Model:Point('TOPRIGHT', UIParent, 'BOTTOMLEFT')
		end)
		self:SetScript('OnShow', function() self.Model:Point('TOPRIGHT', self.HandsSlot) end)
		self:SetScript('OnEvent', function(self, Event, ...) if self[Event] then self[Event](Event, ...) end end)
		UIPanelWindows.InspectArmory = { area = 'left', pushable = 1, whileDead = 1 }
	end
	
	do --<< Tab >>--
		self.Tab = CreateFrame('Frame', nil, self)
		self.Tab:Point('TOPLEFT', self, SPACING, -SPACING)
		self.Tab:Point('BOTTOMRIGHT', self, 'TOPRIGHT', -SPACING, -(SPACING + TAB_HEIGHT))
		self.Tab:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.Tab:SetBackdropBorderColor(0, 0, 0)
		C.Toolkit.TextSetting(self.Tab, ' |cff2eb7e4S&L Inspect', { FontSize = 10, FontOutline = 'OUTLINE' }, 'LEFT', 6, 1)
		self.Tab:SetScript('OnMouseDown', function() self:StartMoving() end)
		self.Tab:SetScript('OnMouseUp', function() self:StopMovingOrSizing() end)
	end
	
	do --<< Close Button >>--
		self.Close = CreateFrame('Button', nil, self.Tab)
		self.Close:Size(TAB_HEIGHT - 8)
		self.Close:SetTemplate()
		self.Close.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
		self.Close:Point('RIGHT', -4, 0)
		C.Toolkit.TextSetting(self.Close, 'X', { FontSize = 13, }, 'CENTER', 1, 0)
		self.Close:SetScript('OnEnter', self.Button_OnEnter)
		self.Close:SetScript('OnLeave', self.Button_OnLeave)
		self.Close:SetScript('OnClick', function() HideUIPanel(self) end)
		self.Close.buttonString = 'X'
	end
	
	do --<< Bottom Panel >>--
		self.BP = CreateFrame('Frame', nil, self)
		self.BP:Point('TOPLEFT', self, 'BOTTOMLEFT', SPACING, SPACING + TAB_HEIGHT)
		self.BP:Point('BOTTOMRIGHT', self, -SPACING, SPACING)
		self.BP:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.BP:SetBackdropColor(0.09, 0.3, 0.45)
		self.BP:SetBackdropBorderColor(0, 0, 0)
		self.BP:SetFrameLevel(CORE_FRAME_LEVEL + 2)
		
		self.MessageFrame = CreateFrame('ScrollFrame', nil, self.BP)
		self.MessageFrame:Point('TOPLEFT', self.BP, SPACING * 2 + TAB_HEIGHT, 0)
		self.MessageFrame:Point('BOTTOMRIGHT', self.BP, -10, 1)
		self.MessageFrame.UpdateInterval = 3
		self.MessageFrame.ScrollSpeed = 1
		
		local PageWidth
		local VisibleWidth
		self.MessageFrame:SetScript('OnUpdate', function(self, elapsed)
			PageWidth = self.Page:GetWidth()
			VisibleWidth = self:GetWidth()
			
			if PageWidth > VisibleWidth then
				self.UpdatedTime = (self.UpdatedTime or -self.UpdateInterval) + elapsed
				
				if self.UpdatedTime > 0 then
					if self.Offset then
						self.Offset = self.Offset - self.ScrollSpeed
					else
						self.UpdatedTime = nil
						self.Offset = 0
					end
					
					self.Page:ClearAllPoints()
					if self.Offset < VisibleWidth - PageWidth then
						self.UpdatedTime = -self.UpdateInterval - 2
						self.Offset = nil
						self.Page:Point('TOPRIGHT', self)
						self.Page:Point('BOTTOMRIGHT', self)
					else
						self.Page:Point('TOPLEFT', self, self.Offset, 0)
						self.Page:Point('BOTTOMLEFT', self, self.Offset, 0)
					end
				end
			end
		end)
		
		self.MessageFrame.Icon = self.MessageFrame:CreateTexture(nil, 'OVERLAY')
		self.MessageFrame.Icon:Size(TAB_HEIGHT)
		self.MessageFrame.Icon:Point('TOPLEFT', self.BP, 'TOPLEFT', SPACING * 2, -1)
		self.MessageFrame.Icon:SetTexture('Interface\\HELPFRAME\\HelpIcon-ReportAbuse')
		
		self.MessageFrame.Page = CreateFrame('Frame', nil, self.MessageFrame)
		self.MessageFrame:SetScrollChild(self.MessageFrame.Page)
		self.MessageFrame.Page:Point('TOPLEFT', self.MessageFrame)
		self.MessageFrame.Page:Point('BOTTOMLEFT', self.MessageFrame)
		C.Toolkit.TextSetting(self.MessageFrame.Page, '', { FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', self.MessageFrame.Page)
		
		self.Message = self.MessageFrame.Page.text
	end
	
	do --<< Background >>--
		self.BG = self:CreateTexture(nil, 'OVERLAY')
		self.BG:Point('TOPLEFT', self.Tab, 'BOTTOMLEFT', 0, -38)
		self.BG:Point('BOTTOMRIGHT', self.BP, 'TOPRIGHT')
		self.BG:SetTexture('Interface\\AddOns\\ElvUI_SLE\\Media\\textures\\Space')
	end
	
	do --<< Buttons >>--
		for buttonName, buttonString in pairs(self.PageList) do
			buttonName = buttonName..'Button'
			
			self[buttonName] = CreateFrame('Button', nil, self.BP)
			self[buttonName]:Size(70, 20)
			self[buttonName]:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self[buttonName]:SetBackdropBorderColor(0, 0, 0)
			self[buttonName]:SetFrameLevel(CORE_FRAME_LEVEL + 1)
			C.Toolkit.TextSetting(self[buttonName], _G[buttonString], { FontSize = 9, FontOutline = 'OUTLINE' })
			self[buttonName]:SetScript('OnEnter', self.Button_OnEnter)
			self[buttonName]:SetScript('OnLeave', self.Button_OnLeave)
			self[buttonName]:SetScript('OnClick', function() IA:ChangePage(buttonName) end)
			self[buttonName]['buttonString'] = _G[buttonString]
		end
		self.CharacterButton:Point('TOPLEFT', self.BP, 'BOTTOMLEFT', SPACING + 1, 2)
		self.InfoButton:Point('TOPLEFT', self.CharacterButton, 'TOPRIGHT', SPACING, 0)
		self.SpecButton:Point('TOPLEFT', self.InfoButton, 'TOPRIGHT', SPACING, 0)
	end
	
	do --<< Bookmark Star >>--
		self.Bookmark = CreateFrame('CheckButton', nil, self)
		self.Bookmark:Size(24)
		self.Bookmark:EnableMouse(true)
		self.Bookmark.NormalTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.NormalTexture:SetTexCoord(0.5, 1, 0, 0.5)
		self.Bookmark.NormalTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.NormalTexture:SetInside()
		self.Bookmark:SetNormalTexture(self.Bookmark.NormalTexture)
		self.Bookmark.HighlightTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.HighlightTexture:SetTexCoord(0, 0.5, 0.5, 1)
		self.Bookmark.HighlightTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.HighlightTexture:SetInside()
		self.Bookmark:SetHighlightTexture(self.Bookmark.HighlightTexture)
		self.Bookmark.CheckedTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.CheckedTexture:SetTexCoord(0, 0.5, 0, 0.5)
		self.Bookmark.CheckedTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.CheckedTexture:SetInside()
		self.Bookmark:SetCheckedTexture(self.Bookmark.CheckedTexture)
		self.Bookmark:Point('LEFT', self.Tab, 'BOTTOMLEFT', 7, -34)
		self.Bookmark:Hide()
	end
	
	do --<< Texts >>--
		C.Toolkit.TextSetting(self, nil, { Tag = 'Name', FontSize = 22, FontOutline = 'OUTLINE', }, 'LEFT', self.Bookmark, 'RIGHT', 9, 0)
		C.Toolkit.TextSetting(self, nil, { Tag = 'Title', FontSize = 12, FontOutline = 'OUTLINE', }, 'BOTTOMLEFT', self.Name, 'TOPLEFT', 0, 3)
		C.Toolkit.TextSetting(self, nil, { Tag = 'TitleR', FontSize = 12, FontOutline = 'OUTLINE', }, 'LEFT', self.Name, 'RIGHT', -2, 7)
		C.Toolkit.TextSetting(self, nil, { Tag = 'LevelRace', FontSize = 10, directionH = 'LEFT', }, 'BOTTOMLEFT', self.Name, 'BOTTOMRIGHT', -2, 2)
		C.Toolkit.TextSetting(self, nil, { Tag = 'Guild', FontSize = 10, directionH = 'LEFT', }, 'TOPLEFT', self.Name, 'BOTTOMLEFT', 4, -5)
		--C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'Realm', ['FontSize'] = 10, ['directionH'] = 'LEFT', }, 'BOTTOMLEFT', self.Name, 'TOPLEFT', 2, 14)
		self.Guild:Point('RIGHT', self, -44, 0)
	end
	
	do --<< Class, Specialization Icon >>--
		for _, frameName in pairs({ 'SpecIcon', 'ClassIcon', }) do
			self[frameName..'Slot'] = CreateFrame('Frame', nil, self)
			self[frameName..'Slot']:Size(24)
			self[frameName..'Slot']:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self[frameName] = self[frameName..'Slot']:CreateTexture(nil, 'OVERLAY')
			self[frameName]:SetTexCoord(unpack(E.TexCoords))
			self[frameName]:SetInside()
		end
		self.ClassIconSlot:Point('RIGHT', self.Tab, 'BOTTOMRIGHT', -44, -35)
		self.SpecIconSlot:Point('RIGHT', self.ClassIconSlot, 'LEFT', -SPACING, 0)
	end
	
	do --<< Player Model >>--
		self.Model = CreateFrame('DressUpModel', nil, UIParent)
		self.Model:SetFrameStrata('DIALOG')
		self.Model:SetFrameLevel(CORE_FRAME_LEVEL + 1)
		self.Model:EnableMouse(1)
		self.Model:EnableMouseWheel(1)
		self.Model:SetUnit('player')
		self.Model:TryOn(HeadSlotItem)
		self.Model:TryOn(BackSlotItem)
		self.Model:Undress()
		self.Model:SetScript('OnMouseDown', function(self, button)
			self.startx, self.starty = GetCursorPosition()
			
			local endx, endy, z, x, y
			if button == 'LeftButton' then
				IA.Model:SetScript('OnUpdate', function(self)
					endx, endy = GetCursorPosition()
					
					self.rotation = (endx - self.startx) / 34 + self:GetFacing()
					self:SetFacing(self.rotation)
					self.startx, self.starty = GetCursorPosition()
				end)
			elseif button == 'RightButton' then
				IA.Model:SetScript('OnUpdate', function(self)
					endx, endy = GetCursorPosition()
					
					z, x, y = self:GetPosition(z, x, y)
					x = (endx - self.startx) / 45 + x
					y = (endy - self.starty) / 45 + y
					
					self:SetPosition(z, x, y)
					self.startx, self.starty = GetCursorPosition()
				end)
			end
		end)
		self.Model:SetScript('OnMouseUp', function(self)
			self:SetScript('OnUpdate', nil)
		end)
		self.Model:SetScript('OnMouseWheel', function(self, spining)
			local z, x, y = self:GetPosition()
			
			z = (spining > 0 and z + 0.5 or z - 0.5)
			
			self:SetPosition(z, x, y)
		end)
	end
	
	do --<< Equipment Slots >>--
		self.Character = CreateFrame('Frame', nil, self)
		
		local Slot
		for i, slotName in pairs(C.GearList) do
			-- Slot
			Slot = CreateFrame('Button', nil, self)
			Slot:Size(SLOT_SIZE)
			Slot:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			Slot:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			Slot:SetScript('OnEnter', self.EquipmentSlot_OnEnter)
			Slot:SetScript('OnLeave', self.OnLeave)
			Slot:SetScript('OnClick', self.OnClick)
			C.Toolkit.TextSetting(Slot, '', { FontSize = 12, FontOutline = 'OUTLINE' })
			
			Slot.SlotName = slotName
			Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
			Slot.ID, Slot.EmptyTexture = GetInventorySlotInfo(slotName)
			
			Slot.Texture = Slot:CreateTexture(nil, 'OVERLAY')
			Slot.Texture:SetTexCoord(unpack(E.TexCoords))
			Slot.Texture:SetInside()
			Slot.Texture:SetTexture(Slot.EmptyTexture)
			
			Slot.Highlight = Slot:CreateTexture('Frame', nil, self)
			Slot.Highlight:SetInside()
			Slot.Highlight:SetTexture(1, 1, 1, 0.3)
			Slot:SetHighlightTexture(Slot.Highlight)
			
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'ItemLevel', FontSize = 10, FontOutline = 'OUTLINE', }, 'TOP', Slot, 0, -3)
			
			-- Gradation
			Slot.Gradation = CreateFrame('Frame', nil, self.Character)
			Slot.Gradation:Size(130, SLOT_SIZE + 4)
			Slot.Gradation:SetFrameLevel(CORE_FRAME_LEVEL + 2)
			Slot.Gradation:Point(Slot.Direction, Slot, Slot.Direction == 'LEFT' and -1 or 1, 0)
			Slot.Gradation.Texture = Slot.Gradation:CreateTexture(nil, 'OVERLAY')
			Slot.Gradation.Texture:SetInside()
			Slot.Gradation.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Gradation')
			if Slot.Direction == 'LEFT' then
				Slot.Gradation.Texture:SetTexCoord(0, 1, 0, 1)
			else
				Slot.Gradation.Texture:SetTexCoord(1, 0, 0, 1)
			end
			
			if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
				-- Item Level
				C.Toolkit.TextSetting(Slot.Gradation, nil, { Tag = 'ItemLevel', FontSize = 10, directionH = Slot.Direction, }, 'TOP'..Slot.Direction, Slot, 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)

				-- Enchantment
				C.Toolkit.TextSetting(Slot.Gradation, nil, { Tag = 'ItemEnchant', FontSize = 8, directionH = Slot.Direction, }, Slot.Direction, Slot, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 2)
				Slot.EnchantWarning = CreateFrame('Button', nil, Slot.Gradation)
				Slot.EnchantWarning:Size(12)
				Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
				Slot.EnchantWarning.Texture:SetInside()
				Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
				Slot.EnchantWarning:Point(Slot.Direction, Slot.Gradation.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
				Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
				Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)
				
				-- Gem Socket
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i] = CreateFrame('Frame', nil, Slot.Gradation)
					Slot['Socket'..i]:Size(12)
					Slot['Socket'..i]:SetBackdrop({
						bgFile = E.media.blankTex,
						edgeFile = E.media.blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					Slot['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
					Slot['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
					Slot['Socket'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 3)
					
					Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
					Slot['Socket'..i].Socket:SetBackdrop({
						bgFile = E.media.blankTex,
						edgeFile = E.media.blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					Slot['Socket'..i].Socket:SetInside()
					Slot['Socket'..i].Socket:SetFrameLevel(CORE_FRAME_LEVEL + 4)
					Slot['Socket'..i].Socket:SetScript('OnEnter', self.GemSocket_OnEnter)
					Slot['Socket'..i].Socket:SetScript('OnLeave', self.OnLeave)
					Slot['Socket'..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
					
					Slot['Socket'..i].Texture = Slot['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
					Slot['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
					Slot['Socket'..i].Texture:SetInside()
				end
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 2)
				Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
				Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
				
				Slot.SocketWarning = CreateFrame('Button', nil, Slot.Gradation)
				Slot.SocketWarning:Size(12)
				Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
				Slot.SocketWarning.Texture:SetInside()
				Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
				Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
				Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
				
				if C.CanTransmogrifySlot[slotName] then
					Slot.TransmogrifyAnchor = CreateFrame('Button', nil, Slot.Gradation)
					Slot.TransmogrifyAnchor:Size(12)
					Slot.TransmogrifyAnchor:SetFrameLevel(CORE_FRAME_LEVEL + 4)
					Slot.TransmogrifyAnchor:Point('BOTTOM'..Slot.Direction, Slot)
					Slot.TransmogrifyAnchor:SetScript('OnEnter', self.Transmogrify_OnEnter)
					Slot.TransmogrifyAnchor:SetScript('OnLeave', self.Transmogrify_OnLeave)
					
					Slot.TransmogrifyAnchor.Texture = Slot.TransmogrifyAnchor:CreateTexture(nil, 'OVERLAY')
					Slot.TransmogrifyAnchor.Texture:SetInside()
					Slot.TransmogrifyAnchor.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\anchor')
					Slot.TransmogrifyAnchor.Texture:SetVertexColor(1, .5, 1)
					
					if Slot.Direction == 'LEFT' then
						Slot.TransmogrifyAnchor.Texture:SetTexCoord(0, 1, 0, 1)
					else
						Slot.TransmogrifyAnchor.Texture:SetTexCoord(1, 0, 0, 1)
					end
				end
			end
			
			self[slotName] = Slot
		end
		
		-- Slot Location : Left
		self.HeadSlot:Point('BOTTOMLEFT', self.NeckSlot, 'TOPLEFT', 0, SPACING)
		self.NeckSlot:Point('BOTTOMLEFT', self.ShoulderSlot, 'TOPLEFT', 0, SPACING)
		self.ShoulderSlot:Point('BOTTOMLEFT', self.BackSlot, 'TOPLEFT', 0, SPACING)
		self.BackSlot:Point('BOTTOMLEFT', self.ChestSlot, 'TOPLEFT', 0, SPACING)
		self.ChestSlot:Point('BOTTOMLEFT', self.ShirtSlot, 'TOPLEFT', 0, SPACING)
		self.ShirtSlot:Point('BOTTOMLEFT', self.TabardSlot, 'TOPLEFT', 0, SPACING)
		self.TabardSlot:Point('BOTTOMLEFT', self.WristSlot, 'TOPLEFT', 0, SPACING)
		self.WristSlot:Point('LEFT', self.BP, 1, 0)
		self.WristSlot:Point('BOTTOM', self.MainHandSlot, 'TOP', 0, SPACING)
		
		-- Slot Location : Right
		self.HandsSlot:Point('BOTTOMRIGHT', self.WaistSlot, 'TOPRIGHT', 0, SPACING)
		self.WaistSlot:Point('BOTTOMRIGHT', self.LegsSlot, 'TOPRIGHT', 0, SPACING)
		self.LegsSlot:Point('BOTTOMRIGHT', self.FeetSlot, 'TOPRIGHT', 0, SPACING)
		self.FeetSlot:Point('BOTTOMRIGHT', self.Finger0Slot, 'TOPRIGHT', 0, SPACING)
		self.Finger0Slot:Point('BOTTOMRIGHT', self.Finger1Slot, 'TOPRIGHT', 0, SPACING)
		self.Finger1Slot:Point('BOTTOMRIGHT', self.Trinket0Slot, 'TOPRIGHT', 0, SPACING)
		self.Trinket0Slot:Point('BOTTOMRIGHT', self.Trinket1Slot, 'TOPRIGHT', 0, SPACING)
		self.Trinket1Slot:Point('RIGHT', self.BP, -1, 0)
		self.Trinket1Slot:Point('BOTTOM', self.SecondaryHandSlot, 'TOP', 0, SPACING)
		
		-- ItemLevel
		C.Toolkit.TextSetting(self.Character, nil, { Tag = 'AverageItemLevel', FontSize = 12, }, 'TOP', self.Model)
	end
	
	self.Model:Point('TOPLEFT', self.HeadSlot)
	self.Model:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)
	
	do --<< Information Page >>--
		self.Info = CreateFrame('ScrollFrame', nil, self)
		self.Info:SetFrameLevel(CORE_FRAME_LEVEL + 5)
		self.Info:EnableMouseWheel(1)
		self.Info:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)
		
		self.Info.BG = CreateFrame('Frame', nil, self.Info)
		self.Info.BG:SetFrameLevel(CORE_FRAME_LEVEL + 1)
		self.Info.BG:Point('TOPLEFT', self.HeadSlot, 'TOPRIGHT', SPACING, 0)
		self.Info.BG:Point('RIGHT', self.Trinket1Slot, 'BOTTOMLEFT', -SPACING, 0)
		self.Info.BG:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)
		self.Info.BG:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.Info.BG:SetBackdropColor(0, 0, 0, .7)
		
		self.Info:Point('TOPLEFT', self.Info.BG, 4, -7)
		self.Info:Point('BOTTOMRIGHT', self.Info.BG, -4, 7)
		
		self.Info.Page = CreateFrame('Frame', nil, self.Info)
		self.Info:SetScrollChild(self.Info.Page)
		self.Info.Page:SetFrameLevel(CORE_FRAME_LEVEL + 2)
		self.Info.Page:Point('TOPLEFT', self.Info)
		self.Info.Page:Point('TOPRIGHT', self.Info, -1, 0)
		
		for _, CategoryType in pairs(IA.InfoPageCategoryList) do
			self.Info[CategoryType] = CreateFrame('ScrollFrame', nil, self.Info.Page)
			self.Info[CategoryType]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Info[CategoryType]:SetBackdropColor(.08, .08, .08, .8)
			self.Info[CategoryType]:SetBackdropBorderColor(0, 0, 0)
			self.Info[CategoryType]:Point('LEFT', self.Info.Page)
			self.Info[CategoryType]:Point('RIGHT', self.Info.Page)
			self.Info[CategoryType]:Height(INFO_TAB_SIZE + SPACING * 2)
			
			self.Info[CategoryType].IconSlot = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType].IconSlot:Size(INFO_TAB_SIZE)
			self.Info[CategoryType].IconSlot:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Info[CategoryType].IconSlot:Point('TOPLEFT', self.Info[CategoryType], SPACING, -SPACING)
			self.Info[CategoryType].Icon = self.Info[CategoryType].IconSlot:CreateTexture(nil, 'OVERLAY')
			self.Info[CategoryType].Icon:SetTexCoord(unpack(E.TexCoords))
			self.Info[CategoryType].Icon:SetInside()
			
			self.Info[CategoryType].Tab = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType].Tab:Point('TOPLEFT', self.Info[CategoryType].IconSlot, 'TOPRIGHT', 1, 0)
			self.Info[CategoryType].Tab:Point('BOTTOMRIGHT', self.Info[CategoryType], 'TOPRIGHT', -SPACING, -(SPACING + INFO_TAB_SIZE))
			self.Info[CategoryType].Tab:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			
			self.Info[CategoryType].Tooltip = CreateFrame('Button', nil, self.Info[CategoryType])
			self.Info[CategoryType].Tooltip:Point('TOPLEFT', self.Info[CategoryType].Icon)
			self.Info[CategoryType].Tooltip:Point('BOTTOMRIGHT', self.Info[CategoryType].Tab)
			self.Info[CategoryType].Tooltip:SetFrameLevel(CORE_FRAME_LEVEL + 4)
			self.Info[CategoryType].Tooltip:SetScript('OnClick', IA.Category_OnClick)
			
			C.Toolkit.TextSetting(self.Info[CategoryType].Tab, CategoryType, { FontSize = 10 }, 'LEFT', 6, 1)
			
			self.Info[CategoryType].Page = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType]:SetScrollChild(self.Info[CategoryType].Page)
			self.Info[CategoryType].Page:SetFrameLevel(CORE_FRAME_LEVEL + 2)
			self.Info[CategoryType].Page:Point('TOPLEFT', self.Info[CategoryType].IconSlot, 'BOTTOMLEFT', 0, -SPACING)
			self.Info[CategoryType].Page:Point('BOTTOMRIGHT', self.Info[CategoryType], -SPACING, SPACING)
		end
		
		do -- Profession Part
			self.Info.Profession.CategoryHeight = INFO_TAB_SIZE + 34 + SPACING * 3
			self.Info.Profession.Icon:SetTexture(GetSpellTexture(110396))
			
			for i = 1, 2 do
				self.Info.Profession['Prof'..i] = CreateFrame('Frame', nil, self.Info.Profession.Page)
				self.Info.Profession['Prof'..i]:Size(20)
				self.Info.Profession['Prof'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Info.Profession['Prof'..i]:SetBackdropBorderColor(0, 0, 0)
				
				self.Info.Profession['Prof'..i].Icon = self.Info.Profession['Prof'..i]:CreateTexture(nil, 'OVERLAY')
				self.Info.Profession['Prof'..i].Icon:SetTexCoord(unpack(E.TexCoords))
				self.Info.Profession['Prof'..i].Icon:SetInside()
				
				self.Info.Profession['Prof'..i].BarFrame = CreateFrame('Frame', nil, self.Info.Profession['Prof'..i])
				self.Info.Profession['Prof'..i].BarFrame:Size(136, 5)
				self.Info.Profession['Prof'..i].BarFrame:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Info.Profession['Prof'..i].BarFrame:SetBackdropColor(0, 0, 0)
				self.Info.Profession['Prof'..i].BarFrame:SetBackdropBorderColor(0, 0, 0)
				self.Info.Profession['Prof'..i].BarFrame:Point('BOTTOMLEFT', self.Info.Profession['Prof'..i], 'BOTTOMRIGHT', SPACING, 0)
				
				self.Info.Profession['Prof'..i].Bar = CreateFrame('StatusBar', nil, self.Info.Profession['Prof'..i].BarFrame)
				self.Info.Profession['Prof'..i].Bar:SetInside()
				self.Info.Profession['Prof'..i].Bar:SetStatusBarTexture(E.media.normTex)
				self.Info.Profession['Prof'..i].Bar:SetMinMaxValues(0, 600)
				
				C.Toolkit.TextSetting(self.Info.Profession['Prof'..i], nil, { Tag = 'Level', FontSize = 10 }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Level:Point('RIGHT', self.Info.Profession['Prof'..i].Bar)
				
				C.Toolkit.TextSetting(self.Info.Profession['Prof'..i], nil, { Tag = 'Name', FontSize = 10, directionH = 'LEFT' }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Name:Point('LEFT', self.Info.Profession['Prof'..i].Bar)
				self.Info.Profession['Prof'..i].Name:Point('RIGHT', self.Info.Profession['Prof'..i].Level, 'LEFT', -SPACING, 0)
			end
			
			self.Info.Profession.Prof1:Point('TOPLEFT', self.Info.Profession.Page, 6, -7)
			self.Info.Profession.Prof2:Point('TOPLEFT', self.Info.Profession.Page, 'TOP', 6, -7)
		end
		
		do -- PvP Category
			self.Info.PvP.CategoryHeight = 90
			self.Info.PvP.Icon:SetTexture('Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
			
			self.Info.PvP.PageLeft = CreateFrame('Frame', nil, self.Info.PvP.Page)
			self.Info.PvP.PageLeft:Point('TOP', self.Info.PvP.Page)
			self.Info.PvP.PageLeft:Point('LEFT', self.Info.PvP.Page)
			self.Info.PvP.PageLeft:Point('BOTTOMRIGHT', self.Info.PvP.Page, 'BOTTOM')
			self.Info.PvP.PageLeft:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			self.Info.PvP.PageRight = CreateFrame('Frame', nil, self.Info.PvP.Page)
			self.Info.PvP.PageRight:Point('TOP', self.Info.PvP.Page)
			self.Info.PvP.PageRight:Point('RIGHT', self.Info.PvP.Page)
			self.Info.PvP.PageRight:Point('BOTTOMLEFT', self.Info.PvP.Page, 'BOTTOM')
			self.Info.PvP.PageRight:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			
			for i = 1, 3 do
				self.Info.PvP['Bar'..i] = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP['Bar'..i]:SetTexture(0, 0, 0)
				self.Info.PvP['Bar'..i]:Width(2)
			end
			self.Info.PvP.Bar1:Point('TOP', self.Info.PvP.PageLeft, 0, -SPACING * 2)
			self.Info.PvP.Bar1:Point('BOTTOM', self.Info.PvP.PageLeft, 0, SPACING * 2)
			self.Info.PvP.Bar2:Point('TOP', self.Info.PvP.Page, 0, -SPACING * 2)
			self.Info.PvP.Bar2:Point('BOTTOM', self.Info.PvP.Page, 0, SPACING * 2)
			self.Info.PvP.Bar3:Point('TOP', self.Info.PvP.PageRight, 0, -SPACING * 2)
			self.Info.PvP.Bar3:Point('BOTTOM', self.Info.PvP.PageRight, 0, SPACING * 2)
			
			for _, Type in pairs({ '2vs2', '3vs3', '5vs5', 'RB' }) do
				self.Info.PvP[Type] = CreateFrame('Frame', nil, self.Info.PvP.Page)
				self.Info.PvP[Type]:SetFrameLevel(CORE_FRAME_LEVEL + 4)
				
				self.Info.PvP[Type].Rank = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].Rank:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-ACHIEVEMENT-SHIELDS')
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:Size(83, 57)
				self.Info.PvP[Type].Rank:Point('TOP', self.Info.PvP[Type], 0, -10)
				self.Info.PvP[Type].Rank:Hide()
				self.Info.PvP[Type].RankGlow = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].RankGlow:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-ACHIEVEMENT-SHIELDS')
				self.Info.PvP[Type].RankGlow:SetBlendMode('ADD')
				self.Info.PvP[Type].RankGlow:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].RankGlow:Point('TOPLEFT', self.Info.PvP[Type].Rank)
				self.Info.PvP[Type].RankGlow:Point('BOTTOMRIGHT', self.Info.PvP[Type].Rank)
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].RankNoLeaf:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Progressive-Shield')
				self.Info.PvP[Type].RankNoLeaf:SetTexCoord(0, .66, 0, .77)
				self.Info.PvP[Type].RankNoLeaf:Point('CENTER', self.Info.PvP[Type].Rank, 0, 2)
				self.Info.PvP[Type].RankNoLeaf:SetVertexColor(.2, .4, 1)
				self.Info.PvP[Type].RankNoLeaf:Size(80, 65)
				
				C.Toolkit.TextSetting(self.Info.PvP[Type], nil, { Tag = 'Type', FontSize = 10, FontOutline = 'OUTLINE' }, 'TOPLEFT', self.Info.PvP[Type])
				self.Info.PvP[Type].Type:Point('TOPRIGHT', self.Info.PvP[Type])
				self.Info.PvP[Type].Type:SetHeight(22)
				C.Toolkit.TextSetting(self.Info.PvP[Type], nil, { Tag = 'Rating', FontSize = 22, FontOutline = 'OUTLINE' }, 'CENTER', self.Info.PvP[Type].Rank, 0, 3)
				C.Toolkit.TextSetting(self.Info.PvP[Type], nil, { Tag = 'Record', FontSize = 10, FontOutline = 'OUTLINE' }, 'TOP', self.Info.PvP[Type].Rank, 'BOTTOM', 0, 12)
			end
			self.Info.PvP['2vs2']:Point('TOP', self.Info.PvP.Bar1)
			self.Info.PvP['2vs2']:Point('LEFT', self.Info.PvP.Page)
			self.Info.PvP['2vs2']:Point('BOTTOMRIGHT', self.Info.PvP.Bar1, 'BOTTOMLEFT', -SPACING, 0)
			self.Info.PvP['2vs2'].Type:SetText(ARENA_2V2)
			
			self.Info.PvP['3vs3']:Point('TOPLEFT', self.Info.PvP.Bar1, 'TOPRIGHT', SPACING, 0)
			self.Info.PvP['3vs3']:Point('BOTTOMRIGHT', self.Info.PvP.Bar2, 'BOTTOMLEFT', -SPACING, 0)
			self.Info.PvP['3vs3'].Type:SetText(ARENA_3V3)
			
			self.Info.PvP['5vs5']:Point('TOPLEFT', self.Info.PvP.Bar2, 'TOPRIGHT', SPACING, 0)
			self.Info.PvP['5vs5']:Point('BOTTOMRIGHT', self.Info.PvP.Bar3, 'BOTTOMLEFT', -SPACING, 0)
			self.Info.PvP['5vs5'].Type:SetText(ARENA_5V5)
			
			self.Info.PvP.RB:Point('TOP', self.Info.PvP.Bar3)
			self.Info.PvP.RB:Point('RIGHT', self.Info.PvP.Page)
			self.Info.PvP.RB:Point('BOTTOMLEFT', self.Info.PvP.Bar3, 'BOTTOMRIGHT', SPACING, 0)
			self.Info.PvP.RB.Type:SetText(PVP_RATED_BATTLEGROUNDS)
		end
		
		do -- Guild Category
			self.Info.Guild.CategoryHeight = INFO_TAB_SIZE + 66 + SPACING * 3
			self.Info.Guild.Icon:SetTexture(GetSpellTexture(83968))
			
			self.Info.Guild.Banner = CreateFrame('Frame', nil, self.Info.Guild.Page)
			self.Info.Guild.Banner:SetInside()
			self.Info.Guild.Banner:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			
			self.Info.Guild.BG = self.Info.Guild.Banner:CreateTexture(nil, 'BACKGROUND')
			self.Info.Guild.BG:Size(33, 44)
			self.Info.Guild.BG:SetTexCoord(.00781250, .32812500, .01562500, .84375000)
			self.Info.Guild.BG:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.BG:Point('TOP', self.Info.Guild.Page)
			
			self.Info.Guild.Border = self.Info.Guild.Banner:CreateTexture(nil, 'ARTWORK')
			self.Info.Guild.Border:Size(33, 44)
			self.Info.Guild.Border:SetTexCoord(.34375000, .66406250, .01562500, .84375000)
			self.Info.Guild.Border:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.Border:Point('CENTER', self.Info.Guild.BG)
			
			self.Info.Guild.Emblem = self.Info.Guild.Banner:CreateTexture(nil, 'OVERLAY')
			self.Info.Guild.Emblem:Size(16)
			self.Info.Guild.Emblem:SetTexture('Interface\\GuildFrame\\GuildEmblems_01')
			self.Info.Guild.Emblem:Point('CENTER', self.Info.Guild.BG, 0, 2)
			
			C.Toolkit.TextSetting(self.Info.Guild.Banner, nil, { Tag = 'Name', FontSize = 14 }, 'TOP', self.Info.Guild.BG, 'BOTTOM', 0, 7)
			C.Toolkit.TextSetting(self.Info.Guild.Banner, nil, { Tag = 'LevelMembers', FontSize = 9 }, 'TOP', self.Info.Guild.Banner.Name, 'BOTTOM', 0, -2)
		end
	end
	
	do --<< Specialization Page >>--
		self.Spec = CreateFrame('ScrollFrame', nil, self)
		self.Spec:SetFrameLevel(CORE_FRAME_LEVEL + 5)
		self.Spec:EnableMouseWheel(1)
		self.Spec:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)
		
		self.Spec.BGFrame = CreateFrame('Frame', nil, self.Spec)
		self.Spec.BGFrame:SetFrameLevel(CORE_FRAME_LEVEL + 1)
		self.Spec.BG = self.Spec.BGFrame:CreateTexture(nil, 'BACKGROUND')
		self.Spec.BG:Point('TOP', self.HeadSlot, 'TOPRIGHT', 0, -30)
		self.Spec.BG:Point('LEFT', self.WristSlot, 'TOPRIGHT', SPACING, 0)
		self.Spec.BG:Point('RIGHT', self.Trinket1Slot, 'BOTTOMLEFT', -SPACING, 0)
		self.Spec.BG:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)
		self.Spec.BG:SetTexture(0, 0, 0, .7)
		
		self.Spec:Point('TOPLEFT', self.Spec.BG, 4, -7)
		self.Spec:Point('BOTTOMRIGHT', self.Spec.BG, -4, 7)
		
		self.Spec.Page = CreateFrame('Frame', nil, self.Spec)
		self.Spec:SetScrollChild(self.Spec.Page)
		self.Spec.Page:SetFrameLevel(CORE_FRAME_LEVEL + 2)
		self.Spec.Page:Point('TOPLEFT', self.Spec)
		self.Spec.Page:Point('TOPRIGHT', self.Spec)
		self.Spec.Page:Height((TALENT_SLOT_SIZE + SPACING * 3) * MAX_TALENT_TIERS + (SPACING + GLYPH_SLOT_HEIGHT) * 3 + 22)
		
		self.Spec.BottomBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.BottomBorder:Point('TOPLEFT', self.Spec.BG, 'BOTTOMLEFT', 0, E.mult)
		self.Spec.BottomBorder:Point('BOTTOMRIGHT', self.Spec.BG)
		self.Spec.LeftBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.LeftBorder:Point('TOPLEFT', self.Spec.BG)
		self.Spec.LeftBorder:Point('BOTTOMLEFT', self.Spec.BottomBorder, 'TOPLEFT')
		self.Spec.LeftBorder:Width(E.mult)
		self.Spec.RightBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.RightBorder:Point('TOPRIGHT', self.Spec.BG)
		self.Spec.RightBorder:Point('BOTTOMRIGHT', self.Spec.BottomBorder, 'TOPRIGHT')
		self.Spec.RightBorder:Width(E.mult)
		
		do -- Specialization Tab
			for i = 1, MAX_TALENT_GROUPS do
				self.Spec['Spec'..i] = CreateFrame('Button', nil, self.Spec)
				self.Spec['Spec'..i]:Size(150, 30)
				self.Spec['Spec'..i]:SetScript('OnClick', function() self:ToggleSpecializationTab(i, self.CurrentInspectData) end)
				
				self.Spec['Spec'..i].Tab = CreateFrame('Frame', nil, self.Spec['Spec'..i])
				self.Spec['Spec'..i].Tab:Size(120, 30)
				self.Spec['Spec'..i].Tab:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = 0,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Spec'..i].Tab:SetBackdropColor(0, 0, 0, .7)
				self.Spec['Spec'..i].Tab:SetBackdropBorderColor(0, 0, 0, 0)
				self.Spec['Spec'..i].Tab:Point('TOPRIGHT', self.Spec['Spec'..i])
				C.Toolkit.TextSetting(self.Spec['Spec'..i].Tab, nil, { FontSize = 10, FontOutline = 'OUTLINE' }, 'TOPLEFT', 0, 0)
				self.Spec['Spec'..i].Tab.text:Point('BOTTOMRIGHT', 0, -4)
				
				self.Spec['Spec'..i].Icon = CreateFrame('Frame', nil, self.Spec['Spec'..i].Tab)
				self.Spec['Spec'..i].Icon:Size(27, 26)
				self.Spec['Spec'..i].Icon:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Spec'..i].Icon:SetBackdropColor(0, 0, 0, .7)
				self.Spec['Spec'..i].Icon:Point('TOPLEFT', self.Spec['Spec'..i])
				
				self.Spec['Spec'..i].Texture = self.Spec['Spec'..i].Icon:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].Texture:SetTexCoord(unpack(E.TexCoords))
				self.Spec['Spec'..i].Texture:SetInside()
				
				self.Spec['Spec'..i].TopBorder = self.Spec['Spec'..i].Tab:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].TopBorder:Point('TOPLEFT', self.Spec['Spec'..i].Tab)
				self.Spec['Spec'..i].TopBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i].Tab, 'TOPRIGHT', 0, -E.mult)
				
				self.Spec['Spec'..i].LeftBorder = self.Spec['Spec'..i].Tab:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].LeftBorder:Point('TOPLEFT', self.Spec['Spec'..i].TopBorder, 'BOTTOMLEFT')
				self.Spec['Spec'..i].LeftBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i].Tab, 'BOTTOMLEFT', E.mult, 0)
				
				self.Spec['Spec'..i].RightBorder = self.Spec['Spec'..i].Tab:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].RightBorder:Point('TOPLEFT', self.Spec['Spec'..i].TopBorder, 'BOTTOMRIGHT', -E.mult, 0)
				self.Spec['Spec'..i].RightBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i].Tab)
				
				self.Spec['Spec'..i].BottomLeftBorder = self.Spec['Spec'..i].Tab:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].BottomLeftBorder:Point('TOPLEFT', self.Spec.BG, 0, E.mult)
				self.Spec['Spec'..i].BottomLeftBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i].LeftBorder, 'BOTTOMLEFT')
				
				self.Spec['Spec'..i].BottomRightBorder = self.Spec['Spec'..i].Tab:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].BottomRightBorder:Point('TOPRIGHT', self.Spec.BG, 0, E.mult)
				self.Spec['Spec'..i].BottomRightBorder:Point('BOTTOMLEFT', self.Spec['Spec'..i].RightBorder, 'BOTTOMRIGHT')
			end
			self.Spec.Spec1:Point('BOTTOMLEFT', self.Spec.BG, 'TOPLEFT', 20, 0)
			self.Spec.Spec2:Point('BOTTOMRIGHT', self.Spec.BG, 'TOPRIGHT', -20, 0)
		end
		
		for i = 1, MAX_TALENT_TIERS do
			self.Spec['TalentTier'..i] = CreateFrame('Frame', nil, self.Spec.Page)
			self.Spec['TalentTier'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['TalentTier'..i]:SetBackdropColor(.08, .08, .08)
			self.Spec['TalentTier'..i]:SetBackdropBorderColor(0, 0, 0)
			self.Spec['TalentTier'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 2)
			self.Spec['TalentTier'..i]:Size(352, TALENT_SLOT_SIZE + SPACING * 2)
			
			for k = 1, NUM_TALENT_COLUMNS do
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = CreateFrame('Frame', nil, self.Spec['TalentTier'..i])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetFrameLevel(CORE_FRAME_LEVEL + 3)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:Size(114, TALENT_SLOT_SIZE)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon = CreateFrame('Frame', nil, self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:Size(20)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture = self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:CreateTexture(nil, 'OVERLAY')
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetTexCoord(unpack(E.TexCoords))
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetInside()
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:Point('LEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)], SPACING, 0)
				C.Toolkit.TextSetting(self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)], nil, { FontSize = 9, directionH = 'LEFT' }, 'TOPLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'TOPRIGHT', SPACING, SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('BOTTOMLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'BOTTOMRIGHT', SPACING, -SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('RIGHT', -SPACING, 0)
				
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip = CreateFrame('Button', nil, self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetFrameLevel(CORE_FRAME_LEVEL + 4)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetInside()
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnClick', self.OnClick)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnEnter', self.OnEnter)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnLeave', self.OnLeave)
			end
			
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 1)]:Point('RIGHT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'LEFT', -2, 0)
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)]:Point('CENTER', self.Spec['TalentTier'..i])
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 3)]:Point('LEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'RIGHT', 2, 0)
			
			if i > 1 then
				self.Spec['TalentTier'..i]:Point('TOP', self.Spec['TalentTier'..(i - 1)], 'BOTTOM', 0, -SPACING)
			end
		end
		
		self.Spec.TalentTier1:Point('TOP', self.Spec.Page, 0, -2)
		
		for _, groupName in pairs({ 'MAJOR_GLYPH', 'MINOR_GLYPH' }) do
			self.Spec['GLYPH_'..groupName] = CreateFrame('Frame', nil, self.Spec.Page)
			self.Spec['GLYPH_'..groupName]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['GLYPH_'..groupName]:SetBackdropColor(.08, .08, .08)
			self.Spec['GLYPH_'..groupName]:SetBackdropBorderColor(0, 0, 0)
			self.Spec['GLYPH_'..groupName]:Height(GLYPH_SLOT_HEIGHT * 3 + SPACING * 3 + 22)
			C.Toolkit.TextSetting(self.Spec['GLYPH_'..groupName], '|cffceff00<|r '.._G[groupName]..' |cffceff00>|r', { FontSize = 10 }, 'TOP', self.Spec['GLYPH_'..groupName], 0, -5)
		end
		
		for i = 1, NUM_GLYPH_SLOTS do
			self.Spec['Glyph'..i] = CreateFrame('Button', nil, self.Spec.Page)
			self.Spec['Glyph'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['Glyph'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			self.Spec['Glyph'..i]:Height(GLYPH_SLOT_HEIGHT)
			
			self.Spec['Glyph'..i].NeedLevel = (i == 1 or i == 2) and 25 or (i == 3 or i == 4) and 50 or 75
			
			self.Spec['Glyph'..i].Icon = CreateFrame('Frame', nil, self.Spec['Glyph'..i])
			self.Spec['Glyph'..i].Icon:Size(16)
			self.Spec['Glyph'..i].Icon:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['Glyph'..i].Icon:SetBackdropColor(.15, .15, .15)
			self.Spec['Glyph'..i].Icon:SetFrameLevel(CORE_FRAME_LEVEL + 4)
			self.Spec['Glyph'..i].Icon.Texture = self.Spec['Glyph'..i].Icon:CreateTexture(nil, 'OVERLAY')
			self.Spec['Glyph'..i].Icon.Texture:SetTexCoord(unpack(E.TexCoords))
			self.Spec['Glyph'..i].Icon.Texture:SetInside()
			self.Spec['Glyph'..i].Icon:Point('LEFT', self.Spec['Glyph'..i], SPACING, 0)
			
			self.Spec['Glyph'..i].Tooltip = CreateFrame('Button', nil, self.Spec['Glyph'..i])
			self.Spec['Glyph'..i].Tooltip:SetFrameLevel(CORE_FRAME_LEVEL + 5)
			self.Spec['Glyph'..i].Tooltip:SetInside()
			self.Spec['Glyph'..i].Tooltip:SetScript('OnClick', self.OnClick)
			self.Spec['Glyph'..i].Tooltip:SetScript('OnEnter', self.OnEnter)
			self.Spec['Glyph'..i].Tooltip:SetScript('OnLeave', self.OnLeave)
			self.Spec['Glyph'..i].Tooltip.EnableAuctionSearch = true
			
			C.Toolkit.TextSetting(self.Spec['Glyph'..i], nil, { FontSize = 9, directionH = 'LEFT' }, 'LEFT', self.Spec['Glyph'..i].Icon, 'RIGHT', SPACING, 0)
			self.Spec['Glyph'..i].text:Point('RIGHT', self.Spec['Glyph'..i], -SPACING, 0)
		end
		
		self.Spec.Glyph2:Point('TOP', self.Spec.GLYPH_MAJOR_GLYPH.text, 'BOTTOM', 0, -7)
		self.Spec.Glyph2:Point('LEFT', self.Spec.GLYPH_MAJOR_GLYPH, SPACING, 0)
		self.Spec.Glyph2:Point('RIGHT', self.Spec.GLYPH_MAJOR_GLYPH, -SPACING, 0)
		self.Spec.Glyph4:Point('TOPLEFT', self.Spec.Glyph2, 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.Glyph4:Point('TOPRIGHT', self.Spec.Glyph2, 'BOTTOMRIGHT', 0, -SPACING)
		self.Spec.Glyph6:Point('TOPLEFT', self.Spec.Glyph4, 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.Glyph6:Point('TOPRIGHT', self.Spec.Glyph4, 'BOTTOMRIGHT', 0, -SPACING)
		
		self.Spec.Glyph1:Point('TOP', self.Spec.GLYPH_MINOR_GLYPH.text, 'BOTTOM', 0, -7)
		self.Spec.Glyph1:Point('LEFT', self.Spec.GLYPH_MINOR_GLYPH, SPACING, 0)
		self.Spec.Glyph1:Point('RIGHT', self.Spec.GLYPH_MINOR_GLYPH, -SPACING, 0)
		self.Spec.Glyph3:Point('TOPLEFT', self.Spec.Glyph1, 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.Glyph3:Point('TOPRIGHT', self.Spec.Glyph1, 'BOTTOMRIGHT', 0, -SPACING)
		self.Spec.Glyph5:Point('TOPLEFT', self.Spec.Glyph3, 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.Glyph5:Point('TOPRIGHT', self.Spec.Glyph3, 'BOTTOMRIGHT', 0, -SPACING)
		
		self.Spec.GLYPH_MAJOR_GLYPH:Point('TOPLEFT', self.Spec['TalentTier'..MAX_TALENT_TIERS], 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.GLYPH_MAJOR_GLYPH:Point('TOPRIGHT', self.Spec['TalentTier'..MAX_TALENT_TIERS], 'BOTTOM', -2, -SPACING)
		self.Spec.GLYPH_MINOR_GLYPH:Point('TOPLEFT', self.Spec['TalentTier'..MAX_TALENT_TIERS], 'BOTTOM', 2, -SPACING)
		self.Spec.GLYPH_MINOR_GLYPH:Point('TOPRIGHT', self.Spec['TalentTier'..MAX_TALENT_TIERS], 'BOTTOMRIGHT', 0, -SPACING)
	end
	
	do --<< Scanning Tooltip >>--
		self.ScanTTForInspecting = CreateFrame('GameTooltip', 'InspectArmoryScanTT_I', nil, 'GameTooltipTemplate')
		self.ScanTTForInspecting:SetOwner(UIParent, 'ANCHOR_NONE')
		self.ScanTT = CreateFrame('GameTooltip', 'InspectArmoryScanTT', nil, 'GameTooltipTemplate')
		self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	end
	
	do --<< UnitPopup Setting >>--
		InspectArmory_UnitPopup.Highlight = InspectArmory_UnitPopup:CreateTexture(nil, 'BACKGROUND')
		InspectArmory_UnitPopup.Highlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
		InspectArmory_UnitPopup.Highlight:SetBlendMode('ADD')
		InspectArmory_UnitPopup.Highlight:SetAllPoints()
		InspectArmory_UnitPopup:SetHighlightTexture(InspectArmory_UnitPopup.Highlight)
		
		InspectArmory_UnitPopup:SetScript('OnEnter', function()
			UIDropDownMenu_StopCounting(DropDownList1)
		end)
		InspectArmory_UnitPopup:SetScript('OnLeave', function()
			UIDropDownMenu_StartCounting(DropDownList1)
		end)
		InspectArmory_UnitPopup:SetScript('OnHide', function(self)
			if self.Anchored then
				self.Anchored = nil
				self.Data = nil
				self:SetParent(nil)
				self:ClearAllPoints()
				self:Hide()
			end
		end)
		InspectArmory_UnitPopup:SetScript('OnClick', function(self)
			local SendChannel
			
			if AISM and AISM.AISMUserList[self.Data.TableIndex] then
				if self.Data.Realm == E.myrealm then
					SendChannel = 'WHISPER'
				elseif AISM.AISMUserList[self.Data.TableIndex] == 'GUILD' then
					SendChannel = 'GUILD'
				elseif Info.CurrentGroupMode ~= 'NoGroup' then
					SendChannel = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(Info.CurrentGroupMode)
				end
			end
			
			if AISM and SendChannel then
				ENI.CancelInspect(self.Data.TableIndex)
				IA:UnregisterEvent('INSPECT_READY')
				
				IA.NeedModelSetting = true
				IA.CurrentInspectData = E:CopyTable({}, IA.Default_CurrentInspectData)
				AISM.CurrentInspectData[self.Data.TableIndex] = {
					['UnitID'] = self.Data.Unit,
				}
				
				local TableIndex = self.Data.TableIndex
				AISM:RegisterInspectDataRequest(function(User, UserData)
					if User == TableIndex then
						E:CopyTable(IA.CurrentInspectData, UserData)
						IA:ShowFrame(IA.CurrentInspectData)
						
						return true
					end
				end, 'InspectArmory', true)
				SendAddonMessage('AISM_Inspect', 'AISM_DataRequestForInspecting:'..self.Data.Name..'-'..self.Data.Realm, SendChannel, self.Data.TableIndex)
			elseif self.Data.Unit then
				IA.InspectUnit(self.Data.Unit)
			end
			
			DropDownList1:Hide()
		end)
		InspectArmory_UnitPopup:SetScript('OnUpdate', function(self)
			if not (self:GetPoint() and self:GetParent()) then
				self:Hide()
				return
			end
			
			if AISM and (type(AISM.GroupMemberData[self.Data.TableIndex]) == 'table' or AISM.AISMUserList[self.Data.TableIndex]) or self.Data.Unit and UnitIsVisible(self.Data.Unit) and UnitIsConnected(self.Data.Unit) and not UnitIsDeadOrGhost('player') then
				self:SetText(C.Toolkit.Color_Value(ButtonName))
				self:Enable()
			else
				self:SetText(ButtonName)
				self:Disable()
			end
		end)
		
		InspectArmory_UnitPopup.CreateDropDownButton = function(Button, DataTable)
			if not Button then
				Button = UIDropDownMenu_CreateInfo()
				Button.notCheckable = 1
				UIDropDownMenu_AddButton(Button)
				
				Button = _G['DropDownList1Button'..DropDownList1.numButtons]
			end
			
			Button.value = 'InspectArmory'
			Button:SetText((' '):rep(strlen(ButtonName)))
			
			InspectArmory_UnitPopup:Show()
			InspectArmory_UnitPopup:SetParent('DropDownList1')
			InspectArmory_UnitPopup:SetFrameStrata(Button:GetFrameStrata())
			InspectArmory_UnitPopup:SetFrameLevel(Button:GetFrameLevel() + 1)
			InspectArmory_UnitPopup:ClearAllPoints()
			InspectArmory_UnitPopup:Point('TOPLEFT', Button)
			InspectArmory_UnitPopup:Point('BOTTOMRIGHT', Button)
			InspectArmory_UnitPopup.Anchored = true
			InspectArmory_UnitPopup.Data = DataTable
		end
		
		hooksecurefunc('UnitPopup_ShowMenu', function(Menu, Type, Unit, Name)
			if Info.InspectArmory_Activate and UIDROPDOWNMENU_MENU_LEVEL == 1 and IA.UnitPopupList[Type] then
				local Button
				local DataTable = {
					Name = Menu.name or Name,
					Unit = UnitExists(Menu.name) and Menu.name or Unit,
					Realm = Menu.server ~= '' and Menu.server or E.myrealm
				}
				DataTable.TableIndex = DataTable.Unit and GetUnitName(DataTable.Unit, 1) or DataTable.Name..(DataTable.Realm ~= E.myrealm and '-'..DataTable.Realm or '')
				
				if DataTable.Name == E.myname or DataTable.Unit and (UnitCanAttack('player', DataTable.Unit) or not UnitIsConnected(DataTable.Unit) or not UnitIsPlayer(DataTable.Unit)) then
					if AISM then
						AISM.AISMUserList[DataTable.TableIndex] = nil
						AISM.GroupMemberData[DataTable.TableIndex] = nil
					end
					
					return
				end
				
				for i = 1, DropDownList1.numButtons do
					if _G['DropDownList1Button'..i].value == 'INSPECT' then
						Button = _G['DropDownList1Button'..i]
						break
					end
				end
				
				if AISM and not (AISM.AISMUserList[DataTable.TableIndex] or AISM.GroupMemberData[DataTable.TableIndex]) then
					local isSending
					print('전송준비')
					if DataTable.Unit and not (UnitCanAttack('player', DataTable.Unit) or not UnitIsConnected(DataTable.Unit) or not UnitIsPlayer(DataTable.Unit)) then
						if DataTable.Realm == E.myrealm or KF.CurrentGroupMode ~= 'NoGroup' then
							isSending = 'AISM_CheckResponse'
							SendAddonMessage('AISM', 'AISM_Check', DataTable.Realm == E.myrealm and 'WHISPER' or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(KF.CurrentGroupMode), DataTable.Name)
						end
					elseif Menu.which == 'GUILD' then
						isSending = 'AISM_GUILD_CheckResponse'
						SendAddonMessage('AISM', 'AISM_GUILD_Check', DataTable.Realm == E.myrealm and 'WHISPER' or 'GUILD', DataTable.Name)
					end
					
					print(isSending)
					if isSending then
						AISM:RegisterInspectDataRequest(function(User, Message)
							if User == DataTable.TableIndex and Message == isSending then
								InspectArmory_UnitPopup.CreateDropDownButton(nil, DataTable)
								
								return true
							end
						end, 'InspectArmory_Checking')
					end
				end
				
				if DataTable.Unit or Button or (AISM and (AISM.AISMUserList[DataTable.TableIndex] or AISM.GroupMemberData[DataTable.TableIndex]))then
					InspectArmory_UnitPopup.CreateDropDownButton(Button, DataTable)
				end
			end
		end)
	end
	
	do --<< Updater >>--
		self.Updater = CreateFrame('Frame')
		self.Updater:Hide()
	end
	
	HideUIPanel(self)
	
	self.CreateInspectFrame = nil
end



function IA:ClearTooltip(tooltip)
	local tooltipName = tooltip:GetName()
	
	tooltip:ClearLines()
	for i = 1, 10 do
		_G[tooltipName..'Texture'..i]:SetTexture(nil)
		_G[tooltipName..'Texture'..i]:ClearAllPoints()
		_G[tooltipName..'Texture'..i]:Point('TOPLEFT', tooltip)
	end
end


IA.INSPECT_HONOR_UPDATE = function(Event)
	if Event or HasInspectHonorData() then
		for i, Type in pairs({ '2vs2', '3vs3', '5vs5' }) do
			IA.CurrentInspectData.PvP[Type] = { GetInspectArenaData(i) }
			for i = 4, #IA.CurrentInspectData.PvP[Type] do
				IA.CurrentInspectData.PvP[Type][i] = nil
			end
		end
		IA.CurrentInspectData.PvP.RB = { GetInspectRatedBGData() }
		IA.CurrentInspectData.PvP.Honor = select(5, GetInspectHonorData())
	end
	
	if not IA.ForbidUpdatePvPInformation then
		IA:InspectFrame_PvPSetting(IA.CurrentInspectData)
	end
end


IA.INSPECT_READY = function(Event, InspectedUnitGUID)
	local TableIndex = IA.CurrentInspectData.Name..(IA.CurrentInspectData.Realm and '-'..IA.CurrentInspectData.Realm or '')
	local UnitID = TableIndex
	local Name, Realm = UnitFullName(UnitID)
	
	if not Name then
		UnitID = IA.CurrentInspectData.UnitID
		Name, Realm = UnitFullName(UnitID)
	end
	
	if not Name then
		_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
	end
	
	if not (IA.CurrentInspectData.Name == Name and IA.CurrentInspectData.Realm == Realm and IA.CurrentInspectData.UnitGUID == InspectedUnitGUID) then
		if UnitGUID(UnitID) ~= IA.CurrentInspectData.UnitGUID then
			ENI.CancelInspect(TableIndex)
			IA:UnregisterEvent('INSPECT_READY')
			IA:UnregisterEvent('INSPECT_HONOR_UPDATE')
		end
		return
	elseif HasInspectHonorData() then
		IA.INSPECT_HONOR_UPDATE()
	end
	
	_, _, IA.CurrentInspectData.Race, IA.CurrentInspectData.RaceID, IA.CurrentInspectData.GenderID = GetPlayerInfoByGUID(InspectedUnitGUID)
	
	local needReinspect
	local CurrentSetItem = {}
	local Slot, SlotTexture, SlotLink, CheckSpace, colorR, colorG, colorB, tooltipText, TransmogrifiedItem, SetName, SetItemCount, SetItemMax, SetOptionCount
	for _, SlotName in pairs(C.GearList) do
		Slot = IA[SlotName]
		IA.CurrentInspectData.Gear[SlotName] = {}
		
		SlotTexture = GetInventoryItemTexture(UnitID, Slot.ID)
		
		if SlotTexture and SlotTexture..'.blp' ~= Slot.EmptyTexture then
			SlotLink = GetInventoryItemLink(UnitID, Slot.ID)
			
			if not SlotLink then
				needReinspect = true
			else
				IA.CurrentInspectData.Gear[SlotName].ItemLink = SlotLink
				
				IA:ClearTooltip(IA.ScanTTForInspecting)
				IA.ScanTTForInspecting:SetInventoryItem(UnitID, Slot.ID)
				
				TransmogrifiedItem = nil
				checkSpace = 2
				SetOptionCount = 1
				
				for i = 1, IA.ScanTTForInspecting:NumLines() do
					tooltipText = _G['InspectArmoryScanTT_ITextLeft'..i]:GetText()
					
					if not TransmogrifiedItem and tooltipText:match(C.TransmogrifiedKey) then
						if type(IA.CurrentInspectData.Gear[SlotName].Transmogrify) ~= 'number' then
							IA.CurrentInspectData.Gear[SlotName].Transmogrify = tooltipText:match(C.TransmogrifiedKey)
						end
						
						TransmogrifiedItem = true
					end
					
					SetName, SetItemCount, SetItemMax = tooltipText:match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
					if SetName then
						SetItemCount = tonumber(SetItemCount)
						SetItemMax = tonumber(SetItemMax)
						
						if (SetItemCount > SetItemMax or SetItemMax == 1) then
							needReinspect = true
							
							break
						else
							if not (CurrentSetItem[SetName] or IA.CurrentInspectData.SetItem[SetName]) then
								needReinspect = true
							end
							
							CurrentSetItem[SetName] = CurrentSetItem[SetName] or {}
							
							for k = 1, IA.ScanTTForInspecting:NumLines() do
								tooltipText = _G['InspectArmoryScanTT_ITextLeft'..(i+k)]:GetText()
								
								if tooltipText == ' ' then
									checkSpace = checkSpace - 1
									
									if checkSpace == 0 then break end
								elseif checkSpace == 2 then
									colorR, colorG, colorB = _G['InspectArmoryScanTT_ITextLeft'..(i+k)]:GetTextColor()
									
									if colorR > LIGHTYELLOW_FONT_COLOR.r - 0.01 and colorR < LIGHTYELLOW_FONT_COLOR.r + 0.01 and colorG > LIGHTYELLOW_FONT_COLOR.g - 0.01 and colorG < LIGHTYELLOW_FONT_COLOR.g + 0.01 and colorB > LIGHTYELLOW_FONT_COLOR.b - 0.01 and colorB < LIGHTYELLOW_FONT_COLOR.b + 0.01 then
										tooltipText = LIGHTYELLOW_FONT_COLOR_CODE..tooltipText
									else
										tooltipText = GRAY_FONT_COLOR_CODE..tooltipText
									end
									
									if CurrentSetItem[SetName][k] and CurrentSetItem[SetName][k] ~= tooltipText then
										needReinspect = true
									end
									
									CurrentSetItem[SetName][k] = tooltipText
								elseif tooltipText:find(C.ItemSetBonusKey) then
									tooltipText = tooltipText:match("^%((%d)%)%s.+:%s.+$") or true
									
									if CurrentSetItem[SetName]['SetOption'..SetOptionCount] and CurrentSetItem[SetName]['SetOption'..SetOptionCount] ~= tooltipText then
										needReinspect = true
									end
									
									CurrentSetItem[SetName]['SetOption'..SetOptionCount] = tooltipText
									SetOptionCount = SetOptionCount + 1
								end
							end
							IA.CurrentInspectData.SetItem[SetName] = CurrentSetItem[SetName]
							
							break
						end
					end
					
					if checkSpace == 0 then break end
				end
			end
		end
	end
	
	if IA.CurrentInspectData.SetItem then
		for SetName in pairs(IA.CurrentInspectData.SetItem) do
			if not CurrentSetItem[SetName] then
				IA.CurrentInspectData.SetItem[SetName] = nil
			end
		end
	end
	
	-- Specialization
	IA.CurrentInspectData.Specialization[1].SpecializationID = GetInspectSpecialization(UnitID)
	local TalentID, isSelected
	for i = 1, MAX_TALENT_TIERS do
		for k = 1, NUM_TALENT_COLUMNS do
			TalentID, _, _, isSelected = GetTalentInfo(i, k, 1, true, UnitID)
			
			IA.CurrentInspectData.Specialization[1]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = { TalentID, isSelected }
		end
	end
	
	-- Glyph
	local SpellID, GlyphID
	for i = 1, NUM_GLYPH_SLOTS do
		_, _, _, SpellID, _, GlyphID = GetGlyphSocketInfo(i, nil, true, UnitID)

		IA.CurrentInspectData.Glyph[1]['Glyph'..i..'SpellID'] = SpellID or 0
		IA.CurrentInspectData.Glyph[1]['Glyph'..i..'ID'] = GlyphID or 0
	end
	
	-- Guild
	IA.CurrentInspectData.guildPoint, IA.CurrentInspectData.guildNumMembers = GetInspectGuildInfo(UnitID)
	IA.CurrentInspectData.guildEmblem = { GetGuildLogoInfo(UnitID) }
	
	if needReinspect then
		return
	end
	
	IA.ForbidUpdatePvPInformation = nil
	IA:ShowFrame(IA.CurrentInspectData)
	
	if IA.ReinspectCount > 0 then
		IA.ReinspectCount = IA.ReinspectCount - 1
	else
		ENI.CancelInspect(TableIndex)
		IA:UnregisterEvent('INSPECT_READY')
	end
end


IA.InspectUnit = function(UnitID)
	if UnitID == 'mouseover' and not UnitExists('mouseover') and UnitExists('target') then
		UnitID = 'target'
	end
	
	if not UnitIsPlayer(UnitID) then
		return
	elseif UnitIsDeadOrGhost('player') then
		SLE:Print(L["You can't inspect while dead."]) --print('|cff2eb7e4[S&L]|r : '..L["You can't inspect while dead."])
		return
	elseif not UnitIsVisible(UnitID) then
		
		return
	else
		UnitID = NotifyInspect(UnitID, true) or UnitID
		
		IA.CurrentInspectData = E:CopyTable({}, IA.Default_CurrentInspectData)
		
		IA.CurrentInspectData.UnitID = UnitID
		IA.CurrentInspectData.UnitGUID = UnitGUID(UnitID)
		IA.CurrentInspectData.Title = UnitPVPName(UnitID)
		IA.CurrentInspectData.Level = UnitLevel(UnitID)
		IA.CurrentInspectData.Name, IA.CurrentInspectData.Realm = UnitFullName(UnitID)
		_, IA.CurrentInspectData.Class, IA.CurrentInspectData.ClassID = UnitClass(UnitID)
		IA.CurrentInspectData.guildName, IA.CurrentInspectData.guildRankName = GetGuildInfo(UnitID)
		
		IA.CurrentInspectData.Realm = IA.CurrentInspectData.Realm ~= '' and IA.CurrentInspectData.Realm ~= E.myrealm and IA.CurrentInspectData.Realm or nil
		
		IA.ReinspectCount = 1
		IA.NeedModelSetting = true
		IA.ForbidUpdatePvPInformation = true
		IA:RegisterEvent('INSPECT_READY')
		IA:RegisterEvent('INSPECT_HONOR_UPDATE')
	end
end


function IA:ShowFrame(DataTable)
	self.GET_ITEM_INFO_RECEIVED = nil
	self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')
	
	for _, slotName in pairs(C.GearList) do
		if DataTable.Gear[slotName] and DataTable.Gear[slotName].ItemLink and not GetItemInfo(DataTable.Gear[slotName].ItemLink) then
			self.GET_ITEM_INFO_RECEIVED = function() self:ShowFrame(DataTable) end
		end
	end
	
	if self.GET_ITEM_INFO_RECEIVED then
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
		return
	end
	
	self.Updater:Show()
	self.Updater:SetScript('OnUpdate', function()
		if not self:InspectFrame_DataSetting(DataTable) then
			self.Updater:SetScript('OnUpdate', nil)
			self.Updater:Hide()
			
			self:InspectFrame_PvPSetting(DataTable)
			ShowUIPanel(InspectArmory)
		end
	end)
end


function IA:InspectFrame_DataSetting(DataTable)
	local needUpdate, needUpdateList
	local r, g, b
	
	do --<< Equipment Slot and Enchant, Gem Setting >>--
		local ErrorDetected
		local ItemCount, ItemTotal = 0, 0
		local Slot, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, CurrentLineText, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount
		local arg1, itemID, enchantID, arg2, arg3, arg4, arg5, arg6
		
		-- Setting except shirt and tabard
		for _, slotName in pairs(self.GearUpdated or C.GearList) do
			if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
				Slot = self[slotName]
				
				do --<< Clear Setting >>--
					needUpdate, ErrorDetected, TrueItemLevel, IsEnchanted, ItemUpgradeID, ItemTexture, r, g, b = nil, nil, nil, nil, nil, nil, 0, 0, 0
					
					Slot.Link = nil
					Slot.ItemLevel:SetText(nil)
					Slot.Gradation.ItemLevel:SetText(nil)
					Slot.Gradation.ItemEnchant:SetText(nil)
					for i = 1, MAX_NUM_SOCKETS do
						Slot['Socket'..i].Texture:SetTexture(nil)
						Slot['Socket'..i].GemItemID = nil
						Slot['Socket'..i].GemType = nil
						Slot['Socket'..i]:Hide()
					end
					Slot.EnchantWarning:Hide()
					Slot.EnchantWarning.Message = nil
					Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
					Slot.SocketWarning:Hide()
					Slot.SocketWarning.Link = nil
					Slot.SocketWarning.Message = nil
				end
				
				if DataTable.Gear[slotName].ItemLink then
					_, Slot.Link = GetItemInfo(DataTable.Gear[slotName].ItemLink)
					
					do --<< Gem Parts >>--
						arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6 = strsplit(':', Slot.Link)
						
						IA:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(format('%s:%s:%d:0:0:0:0:%s:%s:%s:%s:%s', arg1, itemID, enchantID, arg2, arg3, arg4, arg5, arg6))
						
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['InspectArmoryScanTTTexture'..i]:GetTexture()
							
							if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot['Socket'..GemCount_Default].GemType = strupper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end
						
						-- Second, Check if slot's item enable to adding a socket
						GemCount_Enable = GemCount_Default
						if (slotName == 'WaistSlot' and DataTable.Level >= 70) or -- buckle
							((slotName == 'WristSlot' or slotName == 'HandsSlot') and (DataTable.Profession[1].Name == GetSpellInfo(110396) and DataTable.Profession[1].Level >= 550 or DataTable.Profession[2].Name == GetSpellInfo(110396) and DataTable.Profession[2].Level >= 550)) then -- BlackSmith
							
							GemCount_Enable = GemCount_Enable + 1
							Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
						end
						
						IA:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(Slot.Link)
						
						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['InspectArmoryScanTTTexture'..i]:GetTexture()
							
							if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
								r, g, b = unpack(C.GemColor[Slot['Socket'..i].GemType])
								Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, 0.5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
							else
								Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, 0.5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end
							
							CurrentLineText = select(2, _G['InspectArmoryScanTTTexture'..i]:GetPoint())
							CurrentLineText = DataTable.Gear[slotName]['Gem'..i] or CurrentLineText ~= self.ScanTT and CurrentLineText.GetText and CurrentLineText:GetText():gsub('|cff......', ''):gsub('|r', '') or nil
							
							if CurrentLineText then
								Slot['Socket'..i]:Show()
								GemCount_Now = GemCount_Now + 1
								Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								
								ItemTexture = ItemTexture or DataTable.Gear[slotName]['Gem'..i] and select(10, GetItemInfo(DataTable.Gear[slotName]['Gem'..i])) or nil
								
								if not ItemTexture then
									needUpdate = true
								elseif not C.EmptySocketString[CurrentLineText] then
									GemCount = GemCount + 1
									Slot['Socket'..i].GemItemID = CurrentLineText
									Slot['Socket'..i].Texture:SetTexture(ItemTexture)
								end
							end
						end
						
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							needUpdate = true
						end
					end
					
					_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(Slot.Link)
					r, g, b = GetItemQualityColor(ItemRarity)
					
					ItemUpgradeID = Slot.Link:match(':(%d+)\124h%[')
					
					--<< Enchant Parts >>--
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G['InspectArmoryScanTTTextLeft'..i]:GetText()
						
						if CurrentLineText:find(C.ItemLevelKey_Alt) then
							TrueItemLevel = tonumber(CurrentLineText:match(C.ItemLevelKey_Alt))
						elseif CurrentLineText:find(C.ItemLevelKey) then
							TrueItemLevel = tonumber(CurrentLineText:match(C.ItemLevelKey))
						elseif CurrentLineText:find(C.EnchantKey) then
							CurrentLineText = CurrentLineText:match(C.EnchantKey) -- Get enchant string
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_AGILITY_SHORT, AGI)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_SPIRIT_SHORT, SPI)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STAMINA_SHORT, STA)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STRENGTH_SHORT, STR)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
							CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
							
							Slot.Gradation.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
							
							IsEnchanted = true
						end
					end
					
					--<< ItemLevel Parts >>--
					if BasicItemLevel then
						ItemCount = ItemCount + 1
						
						if ItemUpgradeID then
							if ItemUpgradeID == '0' then
								ItemUpgradeID = nil
							else
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							end
						end
						
						ItemTotal = ItemTotal + TrueItemLevel
						
						Slot.ItemLevel:SetText((ItemUpgradeID and (C.UpgradeColor[ItemUpgradeID] or '|cffffffff') or '')..TrueItemLevel)
						Slot.Gradation.ItemLevel:SetText((Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(C.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
					end
					
					--[[
					-- Check Error
					if (not IsEnchanted and C.EnchantableSlots[slotName]) or ((slotName == 'Finger0Slot' or slotName == 'Finger1Slot') and (DataTable.Profession[1].Name == GetSpellInfo(110400) and DataTable.Profession[1].Level >= 550 or DataTable.Profession[2].Name == GetSpellInfo(110400) and DataTable.Profession[2].Level >= 550) and not IsEnchanted) then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.Gradation.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
					elseif slotName == 'ShoulderSlot' and C.ItemEnchant_Profession_Inscription and (DataTable.Profession[1].Name == GetSpellInfo(110417) and DataTable.Profession[1].Level >= C.ItemEnchant_Profession_Inscription.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110417) and DataTable.Profession[2].Level >= C.ItemEnchant_Profession_Inscription.NeedLevel) and not C.ItemEnchant_Profession_Inscription[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
					elseif slotName == 'WristSlot' and C.ItemEnchant_Profession_LeatherWorking and (DataTable.Profession[1].Name == GetSpellInfo(110423) and DataTable.Profession[1].Level >= C.ItemEnchant_Profession_LeatherWorking.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110423) and DataTable.Profession[2].Level >= C.ItemEnchant_Profession_LeatherWorking.NeedLevel) and not C.ItemEnchant_Profession_LeatherWorking[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
					elseif slotName == 'BackSlot' and C.ItemEnchant_Profession_Tailoring and (DataTable.Profession[1].Name == GetSpellInfo(110426) and DataTable.Profession[1].Level >= C.ItemEnchant_Profession_Tailoring.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110426) and DataTable.Profession[2].Level >= C.ItemEnchant_Profession_Tailoring.NeedLevel) and not C.ItemEnchant_Profession_Tailoring[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
					end
					
					if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
						ErrorDetected = true
						
						Slot.SocketWarning:Show()
						
						if GemCount_Enable > GemCount_Now then
							if slotName == 'WaistSlot' then
								if TrueItemLevel < 300 then
									_, Slot.SocketWarning.Link = GetItemInfo(41611)	
								elseif TrueItemLevel < 417 then
									_, Slot.SocketWarning.Link = GetItemInfo(55054)
								else
									_, Slot.SocketWarning.Link = GetItemInfo(90046)
								end
								
								Slot.SocketWarning.Message = L['Missing Buckle']
								
								Slot.SocketWarning:SetScript('OnClick', function(self)
									local itemName, itemLink
									
									if TrueItemLevel < 300 then
										itemName, itemLink = GetItemInfo(41611)
									elseif TrueItemLevel < 417 then
										itemName, itemLink = GetItemInfo(55054)
									else
										itemName, itemLink = GetItemInfo(90046)
									end
									
									if HandleModifiedItemClick(itemLink) then
									elseif IsShiftKeyDown() and BrowseName and BrowseName:IsVisible() then
										AuctionFrameBrowse_Reset(BrowseResetButton)
										BrowseName:SetText(itemName)
										BrowseName:SetFocus()
									end
								end)
							elseif slotName == 'HandsSlot' then
								Slot.SocketWarning.Link = GetSpellLink(114112)
								Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
							elseif slotName == 'WristSlot' then
								Slot.SocketWarning.Link = GetSpellLink(113263)
								Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
							end
						else
							Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
						end
					end
					]]
				end
				
				if Slot.TransmogrifyAnchor then --<< Transmogrify Parts >>--
					Slot.TransmogrifyAnchor.Link = DataTable.Gear[slotName].Transmogrify ~= 'NotDisplayed' and DataTable.Gear[slotName].Transmogrify
					
					if type(Slot.TransmogrifyAnchor.Link) == 'number' then
						Slot.TransmogrifyAnchor:Show()
					else
						Slot.TransmogrifyAnchor:Hide()
					end
				end
				
				-- Change Gradation
				if ErrorDetected then
					Slot.Gradation.Texture:SetVertexColor(1, 0, 0)
				else
					Slot.Gradation.Texture:SetVertexColor(unpack(E.db.sle.armory.inspect.gradientColor))
				end
				
				Slot.Texture:SetTexture(ItemTexture or Slot.EmptyTexture)
				Slot:SetBackdropBorderColor(r, g, b)
				
				if needUpdate then
					needUpdateList = needUpdateList or {}
					needUpdateList[#needUpdateList + 1] = slotName
				end
			end
		end
		
		for _, slotName in pairs({ 'ShirtSlot', 'TabardSlot' }) do
			Slot = self[slotName]
			ItemRarity, ItemTexture, r, g, b = nil, nil, 0, 0, 0
			
			Slot.Link = DataTable.Gear[slotName].ItemLink
			
			if Slot.Link then
				_, _, ItemRarity, _, _, _, _, _, _, ItemTexture = GetItemInfo(Slot.Link)
				r, g, b = GetItemQualityColor(ItemRarity)
			end
			
			Slot.Texture:SetTexture(ItemTexture or self[slotName].EmptyTexture)
			Slot:SetBackdropBorderColor(r, g, b)
		end
		
		self.SetItem = E:CopyTable({}, IA.CurrentInspectData.SetItem)
		self.Character.AverageItemLevel:SetText('|c'..RAID_CLASS_COLORS[DataTable.Class].colorStr..STAT_AVERAGE_ITEM_LEVEL..'|r: '..format('%.2f', ItemTotal / ItemCount))
	end
	
	if needUpdateList then
		self.GearUpdated = needUpdateList
		
		return true
	end
	self.GearUpdated = nil
	
	r, g, b = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
	
	do --<< Basic Information >>--
		local iTitle = string.find(DataTable.Title, DataTable.Name)
		if iTitle == 1 then
			self.Title:SetText('')
			self.TitleR:SetText('|cff93daff'..(DataTable.Title and string.gsub(DataTable.Title, DataTable.Name, '') or ''))
		else
			self.Title:SetText('|cff93daff'..(DataTable.Title and string.gsub(DataTable.Title, DataTable.Name, '') or ''))
			self.TitleR:SetText('')
		end
		--self.Title:SetText((DataTable.Realm and DataTable.Realm ~= E.myrealm and DataTable.Realm..L[" Server "] or '')..'|cff93daff'..(DataTable.Title and string.gsub(DataTable.Title, DataTable.Name, '') or ''))		
		self.Guild:SetText(DataTable.guildName and '<|cff2eb7e4'..DataTable.guildName..'|r>  [|cff2eb7e4'..DataTable.guildRankName..'|r]' or '')
	end
	
	do --<< Information Page Setting >>--
		do -- Profession
			for i = 1, 2 do
				if DataTable.Profession[i].Name then
					self.Info.Profession:Show()
					self.Info.Profession['Prof'..i].Bar:SetValue(DataTable.Profession[i].Level)
					
					if C.ProfessionList[DataTable.Profession[i].Name] then
						self.Info.Profession['Prof'..i].Name:SetText('|cff77c0ff'..DataTable.Profession[i].Name)
						self.Info.Profession['Prof'..i].Icon:SetTexture(C.ProfessionList[DataTable.Profession[i].Name].Texture)
						self.Info.Profession['Prof'..i].Level:SetText(DataTable.Profession[i].Level)
					else
						self.Info.Profession['Prof'..i].Name:SetText('|cff808080'..DataTable.Profession[i].Name)
						self.Info.Profession['Prof'..i].Icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
						self.Info.Profession['Prof'..i].Level:SetText(nil)
					end
				else
					self.Info.Profession:Hide()
					break
				end
			end
		end
		
		do -- Guild
			if DataTable.guildName and DataTable.guildPoint and DataTable.guildNumMembers then
				self.Info.Guild:Show()
				self.Info.Guild.Banner.Name:SetText('|cff2eb7e4'..DataTable.guildName)
				self.Info.Guild.Banner.LevelMembers:SetText('|cff77c0ff'..DataTable.guildPoint..'|r Points'..(DataTable.guildNumMembers > 0 and ' / '..format(INSPECT_GUILD_NUM_MEMBERS:gsub('%%d', '%%s'), '|cff77c0ff'..DataTable.guildNumMembers..'|r ') or ''))
				SetSmallGuildTabardTextures('player', self.Info.Guild.Emblem, self.Info.Guild.BG, self.Info.Guild.Border, DataTable.guildEmblem)
			else
				self.Info.Guild:Hide()
			end
		end
		
		IA:ReArrangeCategory()
	end
	
	do --<< Specialization Page Setting >>--
		local SpecGroup, TalentID, Name, Color, Texture, SpecRole
		
		if DataTable.Specialization.ActiveSpec then
			SpecGroup = DataTable.Specialization.ActiveSpec
			
			for i = 2, MAX_TALENT_GROUPS do
				self.Spec['Spec'..i]:Show()
			end
		else
			SpecGroup = 1
			
			for i = 2, MAX_TALENT_GROUPS do
				self.Spec['Spec'..i]:Hide()
			end
		end
		
		self.SpecIcon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
		for groupNum = 1, MAX_TALENT_GROUPS do
			Color = '|cff808080'
			
			Name = nil
			
			if DataTable.Specialization[groupNum].SpecializationID and DataTable.Specialization[groupNum].SpecializationID ~= 0 then
				_, Name, _, Texture = GetSpecializationInfoByID(DataTable.Specialization[groupNum].SpecializationID)
				
				if Name then
					if C.ClassRole[DataTable.Class][Name] then
						
						SpecRole = C.ClassRole[DataTable.Class][Name].Role
						
						if groupNum == SpecGroup then
							Color = C.ClassRole[DataTable.Class][Name].Color
							self.SpecIcon:SetTexture(Texture)
						end
						
						Name = (SpecRole == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:16:16:-3:0|t' or SpecRole == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:16:16:-3:-1|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:16:16:-2:-1|t')..Name
					else
						self.Spec.Message = L['Specialization data seems to be corrupt.  Please inspect again.']
					end
				end
			end
			
			if not Name then
				Texture, SpecRole = 'Interface\\ICONS\\INV_Misc_QuestionMark.blp', nil
				Name = '|cff808080'..L['No Specialization']
			end
			
			self.Spec['Spec'..groupNum].Tab.text:SetText(Color..Name)
			self.Spec['Spec'..groupNum].Texture:SetTexture(Texture)
			self.Spec['Spec'..groupNum].Texture:SetDesaturated(groupNum ~= SpecGroup)
			
			-- Talents
			for i = 1, MAX_TALENT_TIERS do
				for k = 1, NUM_TALENT_COLUMNS do
					if DataTable.Specialization[groupNum]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] and DataTable.Specialization[groupNum]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)][1] then
						TalentID, Name, Texture = GetTalentInfoByID(DataTable.Specialization[groupNum]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)][1])
						
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetTexture(Texture)
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetText(Name)
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Link = GetTalentLink(TalentID)
					end
				end
			end
		end
	end
	
	do --<< Model and Frame Setting When InspectUnit Changed >>--
		if DataTable.UnitID and UnitIsVisible(DataTable.UnitID) and IA.NeedModelSetting then
			self.Model:SetUnit(DataTable.UnitID)
			
			self.Character.Message = nil
			--self.Character.Message = 'This is a test string. When contained string is too long then string will scrolling. If you check this scrolling ingame then erase this string part and make a nil. Like this : "self.Character.Message = nil". Congratulation your birthday Trevor :D'
		elseif IA.NeedModelSetting then
			self.Model:SetUnit('player')
			self.Model:SetCustomRace(self.ModelList[DataTable.RaceID].RaceID, DataTable.GenderID - 2)
			self.Model:TryOn(HeadSlotItem)
			self.Model:TryOn(BackSlotItem)
			self.Model:Undress()
			
			for _, slotName in pairs(C.GearList) do
				if type(DataTable.Gear[slotName].Transmogrify) == 'number' then
					self.Model:TryOn(DataTable.Gear[slotName].Transmogrify)
				elseif DataTable.Gear[slotName].ItemLink and not (DataTable.Gear[slotName].Transmogrify and DataTable.Gear[slotName].Transmogrify == 'NotDisplayed') then
					self.Model:TryOn(DataTable.Gear[slotName].ItemLink)
				else
					self.Model:UndressSlot(self[slotName].ID)
				end
			end
			
			self.Character.Message = L['Character model may differ because it was constructed by the inspect data.']
		end
		IA.NeedModelSetting = nil
		
		if not (self.LastDataSetting and self.LastDataSetting == DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')) then
			--<< Initialize Inspect Page >>--
			self.Name:SetText('|c'..RAID_CLASS_COLORS[DataTable.Class].colorStr..DataTable.Name)
			self.LevelRace:SetText(format('|cff%02x%02x%02x%s|r %s'..(DataTable.Realm and DataTable.Realm ~= E.myrealm and ' | '..L["Server: "]..DataTable.Realm or ''), GetQuestDifficultyColor(DataTable.Level).r * 255, GetQuestDifficultyColor(DataTable.Level).g * 255, GetQuestDifficultyColor(DataTable.Level).b * 255, DataTable.Level, DataTable.Race))
			self.ClassIcon:SetTexture('Interface\\ICONS\\ClassIcon_'..DataTable.Class)
			
			self.Model:SetPosition(self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].z or 0, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].x or 0, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].y or 0)
			self.Model:SetFacing(-5.67)
			self.Model:SetPortraitZoom(1)
			self.Model:SetPortraitZoom(0)
			
			self:ChangePage('CharacterButton')
			
			do --<< Color Setting >>--
				self.ClassIconSlot:SetBackdropBorderColor(r, g, b)
				self.SpecIconSlot:SetBackdropBorderColor(r, g, b)
				
				self.Info.BG:SetBackdropBorderColor(r, g, b)
				
				self.Info.Profession.IconSlot:SetBackdropBorderColor(r, g, b)
				self.Info.Profession.Tab:SetBackdropColor(r, g, b, .3)
				self.Info.Profession.Tab:SetBackdropBorderColor(r, g, b)
				self.Info.Profession.Prof1.Bar:SetStatusBarColor(r, g, b)
				self.Info.Profession.Prof2.Bar:SetStatusBarColor(r, g, b)
				
				self.Info.Guild.IconSlot:SetBackdropBorderColor(r, g, b)
				self.Info.Guild.Tab:SetBackdropColor(r, g, b, .3)
				self.Info.Guild.Tab:SetBackdropBorderColor(r, g, b)
				
				self.Info.PvP.IconSlot:SetBackdropBorderColor(r, g, b)
				self.Info.PvP.Tab:SetBackdropColor(r, g, b, .3)
				self.Info.PvP.Tab:SetBackdropBorderColor(r, g, b)
			end
			
			self:ToggleSpecializationTab(DataTable.Specialization.ActiveSpec or 1, DataTable)
		elseif not (self.LastActiveSpec and self.LastActiveSpec == (DataTable.Specialization.ActiveSpec or 1)) then
			self:ToggleSpecializationTab(DataTable.Specialization.ActiveSpec or 1, DataTable)
		end
	end
	
	self.LastDataSetting = DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')
end


function IA:InspectFrame_PvPSetting(DataTable)
	local Rating, Played, Won
	local needExpand = 0
	
	for _, Type in pairs({ '2vs2', '3vs3', '5vs5', 'RB' }) do
		if DataTable.PvP[Type] and DataTable.PvP[Type][2] > 0 then
			Rating = DataTable.PvP[Type][1] or 0
			Played = DataTable.PvP[Type][2] or 0
			Won = DataTable.PvP[Type][3] or 0
			
			if Rating >= 2000 then
				Rating = '|cffffe65a'..Rating
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('ADD')
				self.Info.PvP[Type].Rank:SetVertexColor(1, 1, 1)
				self.Info.PvP[Type].RankGlow:Show()
				self.Info.PvP[Type].RankGlow:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].RankNoLeaf:Hide()
			elseif Rating >= 1750 then
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(.5, 1, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('ADD')
				self.Info.PvP[Type].Rank:SetVertexColor(1, 1, 1)
				self.Info.PvP[Type].RankGlow:Show()
				self.Info.PvP[Type].RankGlow:SetTexCoord(.5, 1, 0, .5)
				self.Info.PvP[Type].RankNoLeaf:Hide()
			elseif Rating >= 1550 then
				Rating = '|cffc17611'..Rating
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('BLEND')
				self.Info.PvP[Type].Rank:SetVertexColor(.6, .5, 0)
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf:Hide()
			else
				Rating = '|cff2eb7e4'..Rating
				self.Info.PvP[Type].Rank:Hide()
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf:Show()
			end
			needExpand = needExpand < 106 and 106 or needExpand
			
			self.Info.PvP[Type].Rating:SetText(Rating)
			self.Info.PvP[Type].Record:SetText('|cff77c0ff'..Won..'|r / |cffB24C4C'..(Played - Won))
		else
			needExpand = needExpand < 88 and 88 or needExpand
			
			self.Info.PvP[Type].Rank:Hide()
			self.Info.PvP[Type].RankGlow:Hide()
			self.Info.PvP[Type].RankNoLeaf:Hide()
			
			self.Info.PvP[Type].Rating:SetText('|cff8080800')
			self.Info.PvP[Type].Record:SetText(nil)
		end
	end
	
	self.Info.PvP.CategoryHeight = needExpand > 0 and needExpand or INFO_TAB_SIZE + SPACING * 2
	self:ReArrangeCategory()
end


function IA:ReArrangeCategory()
	local InfoPage_Height = 0
	local PrevCategory
	
	for _, CategoryType in pairs(self.InfoPageCategoryList) do
		if self.Info[CategoryType]:IsShown() then
			if self.Info[CategoryType].Closed then
				self.Info[CategoryType].Page:Hide()
				InfoPage_Height = InfoPage_Height + INFO_TAB_SIZE + SPACING * 2
				self.Info[CategoryType]:Height(INFO_TAB_SIZE + SPACING * 2)
			else
				self.Info[CategoryType].Page:Show()
				InfoPage_Height = InfoPage_Height + self.Info[CategoryType].CategoryHeight
				self.Info[CategoryType]:Height(self.Info[CategoryType].CategoryHeight)
			end
			
			if PrevCategory then
				InfoPage_Height = InfoPage_Height + SPACING * 2
				self.Info[CategoryType]:Point('TOP', PrevCategory, 'BOTTOM', 0, -SPACING * 2)
			else
				self.Info[CategoryType]:Point('TOP', self.Info.Page)
			end
			
			PrevCategory = self.Info[CategoryType]
		end
	end
	
	self.Info.Page:Height(InfoPage_Height)
	self.ScrollFrame_OnMouseWheel(self.Info, 0)
end


function IA:ToggleSpecializationTab(Group, DataTable)
	local r, g, b
	self.LastActiveSpec = DataTable.Specialization.ActiveSpec or 1
	
	for i = 1, MAX_TALENT_GROUPS do
		if i == Group then
			self.Spec['Spec'..i].BottomLeftBorder:Show()
			self.Spec['Spec'..i].BottomRightBorder:Show()
			self.Spec['Spec'..i].Tab:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			self.Spec['Spec'..i].Tab.text:Point('BOTTOMRIGHT', 0, -10)
		else
			self.Spec['Spec'..i].BottomLeftBorder:Hide()
			self.Spec['Spec'..i].BottomRightBorder:Hide()
			self.Spec['Spec'..i].Tab:SetFrameLevel(CORE_FRAME_LEVEL + 2)
			self.Spec['Spec'..i].Tab.text:Point('BOTTOMRIGHT', 0, 0)
		end
	end
	
	if Group == self.LastActiveSpec then
		r, g, b = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
	else
		r, g, b = .4, .4, .4	
	end
	
	self.Spec.BottomBorder:SetTexture(r, g, b)
	self.Spec.LeftBorder:SetTexture(r, g, b)
	self.Spec.RightBorder:SetTexture(r, g, b)
	
	local LevelTable = CLASS_TALENT_LEVELS[DataTable.Class] or CLASS_TALENT_LEVELS.DEFAULT
	for i = 1, MAX_TALENT_TIERS do
		for k = 1, NUM_TALENT_COLUMNS do
			if DataTable.Specialization[Group]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)][2] == true then
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(r, g, b, .3)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(r, g, b)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(r, g, b)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(false)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(1, 1, 1)
			else
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(.1, .1, .1)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(0, 0, 0)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(0, 0, 0)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(true)
				
				if DataTable.Level < LevelTable[i] then
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(.7, .3, .3)
				else
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(.5, .5, .5)
				end
			end
		end
	end
	
	local Name, Texture
	for i = 1, NUM_GLYPH_SLOTS do
		Name, _, Texture = GetSpellInfo(DataTable.Glyph[Group]['Glyph'..i..'SpellID'])
		
		self.Spec['Glyph'..i].text:SetJustifyH('LEFT')
		self.Spec['Glyph'..i].text:SetText(Name)
		self.Spec['Glyph'..i].Icon.Texture:SetTexture(Texture)
		self.Spec['Glyph'..i].Tooltip.Link = DataTable.Glyph[Group]['Glyph'..i..'ID'] ~= 0 and GetGlyphLinkByID(DataTable.Glyph[Group]['Glyph'..i..'ID'])
		
		if DataTable.Glyph[Group]['Glyph'..i..'SpellID'] ~= 0 then
			self.Spec['Glyph'..i]:SetBackdropColor(r, g, b, .3)
			self.Spec['Glyph'..i]:SetBackdropBorderColor(r, g, b)
			self.Spec['Glyph'..i].Icon:SetBackdropBorderColor(r, g, b)
		else
			self.Spec['Glyph'..i]:SetBackdropColor(.1, .1, .1)
			self.Spec['Glyph'..i]:SetBackdropBorderColor(0, 0, 0)
			self.Spec['Glyph'..i].Icon:SetBackdropBorderColor(0, 0, 0)
			
			if self.Spec['Glyph'..i].NeedLevel > DataTable.Level then
				self.Spec['Glyph'..i].text:SetJustifyH('CENTER')
				self.Spec['Glyph'..i].text:SetText(E:RGBToHex(.7, .3, .3)..self.Spec['Glyph'..i].NeedLevel..' '..LEVEL)
			end
		end
	end
	
	for i = 1, MAX_TALENT_GROUPS do
		if i == self.LastActiveSpec then
			r, g, b = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
		else
			r, g, b = .3, .3, .3
		end
		
		self.Spec['Spec'..i].TopBorder:SetTexture(r, g, b)
		self.Spec['Spec'..i].LeftBorder:SetTexture(r, g, b)
		self.Spec['Spec'..i].RightBorder:SetTexture(r, g, b)
		self.Spec['Spec'..i].BottomLeftBorder:SetTexture(r, g, b)
		self.Spec['Spec'..i].BottomRightBorder:SetTexture(r, g, b)
		self.Spec['Spec'..i].Icon:SetBackdropBorderColor(r, g, b)
	end
end

function IFO:Initialize()
	if not E.private.sle.inspectframeoptions.enable then return end
	
	Default_NotifyInspect = _G['NotifyInspect']
	Default_InspectUnit = _G['InspectUnit']
	
		if IA.CreateInspectFrame then
			IA:CreateInspectFrame()
		end
	

		NotifyInspect = ENI.NotifyInspect or NotifyInspect
		InspectUnit = IA.InspectUnit

	
	SLI.Activate = true
end