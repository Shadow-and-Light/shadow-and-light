local E, L, V, P, G, _  = unpack(ElvUI)
local AISM = _G['Armory_InspectSupportModule']
local IFO = E:NewModule('InspectFrameOptions', 'AceEvent-3.0')

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Inspect Frame like Wow-Armory					>>--
--------------------------------------------------------------------------------
local KI = CreateFrame('Frame', 'KnightInspect', E.UIParent)
local ENI = _G['EnhancedNotifyInspectFrame'] or { ['CancelInspect'] = function() end, }
local C = SLArmoryConstants

local CoreFrameLevel = 10
local SLOT_SIZE = 37
local PANEL_HEIGHT = 22
local SIDE_BUTTON_WIDTH = 16
local SPACING = 3
local INFO_TAB_SIZE = 22
local TALENT_SLOT_SIZE = 26
local GLYPH_SLOT_HEIGHT = 22

local HeadSlotItem = 1020
local BackSlotItem = 102246
local Default_NotifyInspect
local Default_InspectUnit

--<< Key Table >>--
KI.PageList = { ['Character'] = 'CHARACTER', ['Info'] = 'INFO', ['Spec'] = 'TALENTS' }
KI.InfoPageCategoryList = { 'Profession', 'PvP', 'Guild' }
KI.ModelList = {
	['Human'] = { ['RaceID'] = 1, [2] = { ['x'] = 0.02, ['y'] = -0.025, ['z'] = -0.6 }, [3] = { ['x'] = -0.01, ['y'] = -0.08, ['z'] = -0.6 } },
	['Dwarf'] = { ['RaceID'] = 3, [2] = { ['x'] = -0.01, ['y'] = -0.23, ['z'] = -0.9 }, [3] = { ['x'] = -0.03, ['y'] = -0.15, ['z'] = -0.8 } },
	['NightElf'] = { ['RaceID'] = 4, [2] = { ['z'] = -0.7 }, [3] = { ['x'] = -0.02, ['y'] = -0.04, ['z'] = -0.7 }},
	['Gnome'] = { ['RaceID'] = 7, [2] = { ['y'] = -0.2, ['z'] = -1 }, [3] = { ['x'] = -0.01, ['y'] = -0.19, ['z'] = -0.9 } },
	['Draenei'] = { ['RaceID'] = 11, [2] = { ['x'] = -0.04, ['y'] = -0.08, ['z'] = -0.7 }, [3] = { ['x'] = -0.02, ['y'] = -0.01, ['z'] = -0.6 }},
	['Worgen'] = { ['RaceID'] = 22, [2] = { ['x'] = -0.09, ['y'] = -0.1, ['z'] = -0.4 }, [3] = { ['x'] = -0.01, ['y'] = 0.01, ['z'] = 0.06 }},
	['Orc'] = { ['RaceID'] = 2, [2] = { ['y'] = -0.06, ['z'] = -1 }, [3] = { ['x'] = -0.01, ['y'] = -0.05, ['z'] = -0.7 }},
	['Scourge'] = { ['RaceID'] = 5, [2] = { ['y'] = -0.08, ['z'] = -0.7 }, [3] = { ['y'] = -0.05, ['z'] = -0.6 }},
	['Tauren'] = { ['RaceID'] = 6, [2] = { ['y'] = -0.09, ['z'] = -0.7 }, [3] = { ['y'] = -0.16, ['z'] = -0.6 } },
	['Troll'] = { ['RaceID'] = 8, [2] = { ['y'] = -0.14, ['z'] = -1.1 }, [3] = { ['y'] = -0.11, ['z'] = -0.8 }},
	['BloodElf'] = { ['RaceID'] = 10, [2] = { ['x'] = 0.02, ['y'] = -0.01, ['z'] = -0.5 }, [3] = { ['x'] = 0.04, ['y'] = -0.01, ['z'] = -0.6 }},
	['Goblin'] = { ['RaceID'] = 9, [2] = { ['y'] = -0.23, ['z'] = -1.3 }, [3] = { ['x'] = -0.01, ['y'] = -0.25, ['z'] = -1.3 } },
	['Pandaren'] = { ['RaceID'] = 24, [2] = { ['x'] = 0.02, ['y'] = 0.02, ['z'] = -0.6 }, [3] = { ['x'] = 0, ['y'] = -0.05, ['z'] = -1 } },
}
KI.CurrentInspectData = {}
KI.Default_CurrentInspectData = {
	['Gear'] = {
		['HeadSlot'] = {}, ['NeckSlot'] = {}, ['ShoulderSlot'] = {}, ['BackSlot'] = {}, ['ChestSlot'] = {},
		['ShirtSlot'] = {}, ['TabardSlot'] = {}, ['WristSlot'] = {}, ['MainHandSlot'] = {},
		
		['HandsSlot'] = {}, ['WaistSlot'] = {}, ['LegsSlot'] = {}, ['FeetSlot'] = {}, ['Finger0Slot'] = {},
		['Finger1Slot'] = {}, ['Trinket0Slot'] = {}, ['Trinket1Slot'] = {}, ['SecondaryHandSlot'] = {}
	},
	['SetItem'] = {},
	['Specialization'] = { [1] = {}, [2] = {} },
	['Glyph'] = { [1] = {}, [2] = {} },
	['Profession'] = { [1] = {}, [2] = {} }
}

local function Button_OnEnter(self)
	self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	self.text:SetText(C.Toolkit.Color_Value(self.buttonString))
end

local function Button_OnLeave(self)
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
	self.text:SetText(self.buttonString)
end

function KI:ChangePage(buttonName)
	for pageType in pairs(self.PageList) do
		if self[pageType] then
			if buttonName == pageType..'Button' then
				self[pageType]:Show()
			else
				self[pageType]:Hide()
			end
		end
	end

	self.MainHandSlot:ClearAllPoints()
	self.SecondaryHandSlot:ClearAllPoints()
	if buttonName == 'CharacterButton' then
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
end

KI.EquipmentSlot_OnEnter = function(self)
	if self.Link then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetHyperlink(self.Link)
		
		--ITEM_SOULBOUND
		
		local CurrentLineText, SetName
		for i = 1, GameTooltip:NumLines() do
			CurrentLineText = _G['GameTooltipTextLeft'..i]:GetText()

			SetName = CurrentLineText:match('^(.+) %((%d)/(%d)%)$')

			if SetName then
				local SetCount = 0

				if type(KI.SetItem[SetName]) == 'table' then
					for dataType, Data in pairs(KI.SetItem[SetName]) do
						if type(dataType) == 'string' then -- Means SetOption Data
							local CurrentLineNum = i + #KI.SetItem[SetName] + 1 + dataType:match('^.+(%d)$')
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
			end
		end

		GameTooltip:Show()
	end
end

KI.ScrollFrame_OnMouseWheel = function(self, spinning)
	local Page = self:GetScrollChild()
	local PageHeight = Page:GetHeight()
	local WindowHeight = self:GetHeight()

	self.Offset = self.Offset or 0

	if PageHeight > WindowHeight then
		self.Offset = self.Offset - spinning * 5
	
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

KI.Category_OnClick = function(self)
	self = self:GetParent()
	self.Closed = not self.Closed

	KI:ReArrangeCategory()
end

KI.GemSocket_OnEnter = function(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

	self = self:GetParent()

	if self.GemItemID then
		if type(self.GemItemID) == 'number' then
			GameTooltip:SetHyperlink(select(2, GetItemInfo(self.GemItemID)))
		else
			GameTooltip:ClearLines()
			GameTooltip:AddLine(self.GemItemID)
		end
	elseif self.GemType then
		GameTooltip:ClearLines()
		GameTooltip:AddLine(_G['EMPTY_SOCKET_'..self.GemType])
	end

	GameTooltip:Show()
end

KI.GemSocket_OnClick = function(self, button)
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

KI.OnClick = function(self)
	if self.Link then
		if HandleModifiedItemClick(self.Link) then
		elseif self.EnableAuctionSearch and BrowseName and BrowseName:IsVisible() then
			AuctionFrameBrowse_Reset(BrowseResetButton)
			BrowseName:SetText(self:GetParent().text:GetText())
			BrowseName:SetFocus()
		end
	end
end

function KI:CreateInspectFrame()
	do --<< Core >>--
		self:Size(450, 480)
		self:CreateBackdrop('Transparent')
		self:SetFrameStrata('DIALOG')
		self:SetFrameLevel(CoreFrameLevel)
		self:SetMovable(true)
		self:SetClampedToScreen(true)
		self:SetScript('OnHide', function()
			PlaySound('igCharacterInfoClose')

			if self.CurrentInspectData.Name then
				local TableIndex = self.CurrentInspectData.Name..(KI.CurrentInspectData.Realm and '-'..KI.CurrentInspectData.Realm or '')
				if AISM then
					if self.LastDataSetting then
						AISM.RegisteredFunction[TableIndex] = nil
					end
				end

				ENI.CancelInspect(TableIndex)
				KI:UnregisterEvent('INSPECT_READY', 'KnightInspect')
			end

			self.LastDataSetting = nil
			self.Model:Point('TOPRIGHT', UIParent, 'BOTTOMLEFT')
		end)
		self:SetScript('OnShow', function() self.Model:Point('TOPRIGHT', self.HandsSlot) end)
		self:SetScript('OnEvent', function(self, Event, ...) if self[Event] then self[Event](...) end end)
		UIPanelWindows['KnightInspect'] = { area = 'left', pushable = 1, }
	end

	do --<< Tab >>--
		self.Tab = CreateFrame('Frame', nil, self)
		self.Tab:Point('TOPLEFT', self, SPACING, -SPACING)
		self.Tab:Point('BOTTOMRIGHT', self, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
		self.Tab:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.Tab:SetBackdropBorderColor(unpack(E.media.bordercolor))
		C.Toolkit.TextSetting(self.Tab, ' |cff2eb7e4Knight Inspect', { ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE', }, 'LEFT', 6, 1)
		self.Tab:SetScript('OnMouseDown', function() self:StartMoving() end)
		self.Tab:SetScript('OnMouseUp', function() self:StopMovingOrSizing() end)
	end

	do --<< Close Button >>--
		self.Close = CreateFrame('Button', nil, self.Tab)
		self.Close:Size(PANEL_HEIGHT - 8)
		self.Close:SetTemplate()
		self.Close.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
		self.Close:Point('RIGHT', -4, 0)
		C.Toolkit.TextSetting(self.Close, 'X', { ['FontSize'] = 13, }, 'CENTER', 1, 0)
		self.Close:SetScript('OnEnter', Button_OnEnter)
		self.Close:SetScript('OnLeave', Button_OnLeave)
		self.Close:SetScript('OnClick', function() HideUIPanel(self) end)
		self.Close.buttonString = 'X'
	end

	do --<< Bottom Panel >>--
		self.BP = CreateFrame('Frame', nil, self)
		self.BP:Point('TOPLEFT', self, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
		self.BP:Point('BOTTOMRIGHT', self, -SPACING, SPACING)
		self.BP:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.BP:SetBackdropColor(0.09, 0.3, 0.45)
		self.BP:SetBackdropBorderColor(unpack(E.media.bordercolor))
		self.BP:SetFrameLevel(CoreFrameLevel + 2)
		C.Toolkit.TextSetting(self.BP, '', { ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE', }, 'LEFT', 4, 1)
		self.Message = self.BP.text
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
			self[buttonName]:SetBackdropBorderColor(unpack(E.media.bordercolor))
			self[buttonName]:SetFrameLevel(CoreFrameLevel + 1)
			C.Toolkit.TextSetting(self[buttonName], _G[buttonString], { ['FontSize'] = 9, ['FontOutline'] = 'OUTLINE' })
			self[buttonName]:SetScript('OnEnter', Button_OnEnter)
			self[buttonName]:SetScript('OnLeave', Button_OnLeave)
			self[buttonName]:SetScript('OnClick', function() KI:ChangePage(buttonName) end)
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
		self.Bookmark:Point('LEFT', self.Tab, 'BOTTOMLEFT', 7, -35)
	end

	do --<< Texts >>--
		C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'Name', ['FontSize'] = 22, ['FontOutline'] = 'OUTLINE', }, 'LEFT', self.Bookmark, 'RIGHT', 9, 0)
		C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'Title', ['FontSize'] = 9, ['FontOutline'] = 'OUTLINE', }, 'BOTTOMLEFT', self.Name, 'TOPLEFT', 2, 5)
		C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'LevelRace', ['FontSize'] = 10, ['directionH'] = 'LEFT', }, 'BOTTOMLEFT', self.Name, 'BOTTOMRIGHT', 5, 2)
		C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'Guild', ['FontSize'] = 10, ['directionH'] = 'LEFT', }, 'TOPLEFT', self.Name, 'BOTTOMLEFT', 4, -5)
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
		self.Model:SetFrameLevel(CoreFrameLevel + 1)
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
				KI.Model:SetScript('OnUpdate', function(self)
					endx, endy = GetCursorPosition()

					self.rotation = (endx - self.startx) / 34 + self:GetFacing()
					self:SetFacing(self.rotation)
					self.startx, self.starty = GetCursorPosition()
				end)
			elseif button == 'RightButton' then
				KI.Model:SetScript('OnUpdate', function(self)
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

			z = (spining > 0 and z + 0.1 or z - 0.1)

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
			Slot:SetFrameLevel(CoreFrameLevel + 3)
			Slot:SetScript('OnEnter', self.EquipmentSlot_OnEnter)
			Slot:SetScript('OnLeave', C.CommonScript.OnLeave)
			Slot:SetScript('OnClick', self.OnClick)
			C.Toolkit.TextSetting(Slot, '', { ['FontSize'] = 12, ['FontOutline'] = 'OUTLINE' })

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

			C.Toolkit.TextSetting(Slot, nil, { ['Tag'] = 'ItemLevel', ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE', }, 'TOP', Slot, 0, -3)

			-- Gradation
			Slot.Gradation = CreateFrame('Frame', nil, self.Character)
			Slot.Gradation:Size(130, SLOT_SIZE + 4)
			Slot.Gradation:Point(Slot.Direction, Slot, Slot.Direction == 'LEFT' and -1 or 1, 0)
			Slot.Gradation:SetFrameLevel(CoreFrameLevel + 2)
			Slot.Gradation.Texture = Slot.Gradation:CreateTexture(nil, 'OVERLAY')
			Slot.Gradation.Texture:SetInside()
			Slot.Gradation.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Gradation')
			if Slot.Direction == 'LEFT' then
				Slot.Gradation.Texture:SetTexCoord(0, .5, 0, .5)
			else
				Slot.Gradation.Texture:SetTexCoord(.5, 1, 0, .5)
			end

			if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
				-- Item Level
				C.Toolkit.TextSetting(Slot.Gradation, nil, { ['Tag'] = 'ItemLevel', ['FontSize'] = 10, ['directionH'] = Slot.Direction, }, 'TOP'..Slot.Direction, Slot, 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)

				-- Enchantment
				C.Toolkit.TextSetting(Slot.Gradation, nil, { ['Tag'] = 'ItemEnchant', ['FontSize'] = 8, ['directionH'] = Slot.Direction, }, Slot.Direction, Slot, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 2)
				Slot.EnchantWarning = CreateFrame('Button', nil, Slot.Gradation)
				Slot.EnchantWarning:Size(12)
				Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
				Slot.EnchantWarning.Texture:SetInside()
				Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
				Slot.EnchantWarning:Point(Slot.Direction, Slot.Gradation.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
				Slot.EnchantWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
				Slot.EnchantWarning:SetScript('OnLeave', C.CommonScript.OnLeave)

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
					Slot['Socket'..i]:SetFrameLevel(CoreFrameLevel + 3)

					Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
					Slot['Socket'..i].Socket:SetBackdrop({
						bgFile = E.media.blankTex,
						edgeFile = E.media.blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					Slot['Socket'..i].Socket:SetInside()
					Slot['Socket'..i].Socket:SetFrameLevel(CoreFrameLevel + 4)
					Slot['Socket'..i].Socket:SetScript('OnEnter', C.CommonScript.GemSocket_OnEnter)
					Slot['Socket'..i].Socket:SetScript('OnLeave', C.CommonScript.OnLeave)
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
				Slot.SocketWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
				Slot.SocketWarning:SetScript('OnLeave', C.CommonScript.OnLeave)
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
		C.Toolkit.TextSetting(self.Character, nil, { ['Tag'] = 'AverageItemLevel', ['FontSize'] = 12, }, 'TOP', self.Model)
	end

	self.Model:Point('TOPLEFT', self.HeadSlot)
	self.Model:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)

	do --<< Information Page >>--
		self.Info = CreateFrame('ScrollFrame', nil, self)
		self.Info:SetFrameLevel(CoreFrameLevel + 4)
		self.Info:EnableMouseWheel(1)
		self.Info:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)

		self.Info.BG = CreateFrame('Frame', nil, self.Info)
		self.Info.BG:SetFrameLevel(CoreFrameLevel + 1)
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
		self.Info.Page:SetFrameLevel(CoreFrameLevel + 2)
		self.Info.Page:Point('TOPLEFT', self.Info)
		self.Info.Page:Point('TOPRIGHT', self.Info, -1, 0)

		for _, CategoryType in pairs(KI.InfoPageCategoryList) do
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
			self.Info[CategoryType].Tooltip:SetFrameLevel(CoreFrameLevel + 4)
			self.Info[CategoryType].Tooltip:SetScript('OnClick', KI.Category_OnClick)

			C.Toolkit.TextSetting(self.Info[CategoryType].Tab, CategoryType, { ['FontSize'] = 10 }, 'LEFT', 6, 1)

			self.Info[CategoryType].Page = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType]:SetScrollChild(self.Info[CategoryType].Page)
			self.Info[CategoryType].Page:SetFrameLevel(CoreFrameLevel + 2)
			self.Info[CategoryType].Page:Point('TOPLEFT', self.Info[CategoryType].Icon, 'BOTTOMLEFT', 0, -SPACING)
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
				self.Info.Profession['Prof'..i].Icon:SetTexture(GetSpellTexture(110396))

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

				C.Toolkit.TextSetting(self.Info.Profession['Prof'..i], '257', { ['Tag'] = 'Level', ['FontSize'] = 10 }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Level:Point('RIGHT', self.Info.Profession['Prof'..i].Bar)

				C.Toolkit.TextSetting(self.Info.Profession['Prof'..i], 'JewelCrafting', { ['Tag'] = 'Name', ['FontSize'] = 10, ['directionH'] = 'LEFT' }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Name:Point('LEFT', self.Info.Profession['Prof'..i].Bar)
				self.Info.Profession['Prof'..i].Name:Point('RIGHT', self.Info.Profession['Prof'..i].Level, 'LEFT', -SPACING, 0)
			end

			self.Info.Profession.Prof1:Point('TOPLEFT', self.Info.Profession.Page, 6, -8)
			self.Info.Profession.Prof2:Point('TOPLEFT', self.Info.Profession.Page, 'TOP', 6, -8)
		end

		do -- PvP Category
			self.Info.PvP.CategoryHeight = 100
			self.Info.PvP.Icon:SetTexture('Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
		end

		do -- Guild Category
			self.Info.Guild.CategoryHeight = INFO_TAB_SIZE + 66 + SPACING * 3
			self.Info.Guild.Icon:SetTexture(GetSpellTexture(83968))

			self.Info.Guild.Banner = CreateFrame('Frame', nil, self.Info.Guild.Page)
			self.Info.Guild.Banner:SetInside()
			self.Info.Guild.Banner:SetFrameLevel(CoreFrameLevel + 3)

			self.Info.Guild.BG = self.Info.Guild.Banner:CreateTexture(nil, 'BACKGROUND')
			self.Info.Guild.BG:Size(33, 44)
			self.Info.Guild.BG:SetTexCoord(.00781250, .32812500, .01562500, .84375000)
			self.Info.Guild.BG:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.BG:Point('TOP', self.Info.Guild.Page, 0, -1)

			self.Info.Guild.Border = self.Info.Guild.Banner:CreateTexture(nil, 'ARTWORK')
			self.Info.Guild.Border:Size(33, 44)
			self.Info.Guild.Border:SetTexCoord(.34375000, .66406250, .01562500, .84375000)
			self.Info.Guild.Border:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.Border:Point('CENTER', self.Info.Guild.BG)

			self.Info.Guild.Emblem = self.Info.Guild.Banner:CreateTexture(nil, 'OVERLAY')
			self.Info.Guild.Emblem:Size(16)
			self.Info.Guild.Emblem:SetTexture('Interface\\GuildFrame\\GuildEmblems_01')
			self.Info.Guild.Emblem:Point('CENTER', self.Info.Guild.BG, 0, 2)

			C.Toolkit.TextSetting(self.Info.Guild.Banner, nil, { ['Tag'] = 'Name', ['FontSize'] = 14 }, 'TOP', self.Info.Guild.BG, 'BOTTOM', 0, 7)
			C.Toolkit.TextSetting(self.Info.Guild.Banner, nil, { ['Tag'] = 'LevelMembers', ['FontSize'] = 9 }, 'TOP', self.Info.Guild.Banner.Name, 'BOTTOM', 0, -2)
		end
	end

	do --<< Specialization Page >>--
		self.Spec = CreateFrame('ScrollFrame', nil, self)
		self.Spec:SetFrameLevel(CoreFrameLevel + 5)
		self.Spec:EnableMouseWheel(1)
		self.Spec:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)

		self.Spec.BGFrame = CreateFrame('Frame', nil, self.Spec)
		self.Spec.BGFrame:SetFrameLevel(CoreFrameLevel + 1)
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
		self.Spec.Page:SetFrameLevel(CoreFrameLevel + 2)
		self.Spec.Page:Point('TOPLEFT', self.Spec)
		self.Spec.Page:Point('TOPRIGHT', self.Spec)
		self.Spec.Page:Height((TALENT_SLOT_SIZE + SPACING * 3) * MAX_NUM_TALENT_TIERS + (SPACING + GLYPH_SLOT_HEIGHT) * 3 + 22)

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
				C.Toolkit.TextSetting(self.Spec['Spec'..i].Tab, nil, { ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE' }, 'TOPLEFT', 0, 0)
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

		for i = 1, MAX_NUM_TALENT_TIERS do
			self.Spec['TalentTier'..i] = CreateFrame('Frame', nil, self.Spec.Page)
			self.Spec['TalentTier'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['TalentTier'..i]:SetBackdropColor(.08, .08, .08)
			self.Spec['TalentTier'..i]:SetBackdropBorderColor(0, 0, 0)
			self.Spec['TalentTier'..i]:SetFrameLevel(CoreFrameLevel + 2)
			self.Spec['TalentTier'..i]:Size(352, TALENT_SLOT_SIZE + SPACING * 2)

			for k = 1, NUM_TALENT_COLUMNS do
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = CreateFrame('Frame', nil, self.Spec['TalentTier'..i])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetFrameLevel(CoreFrameLevel + 3)
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
				C.Toolkit.TextSetting(self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)], nil, { ['FontSize'] = 9, ['directionH'] = 'LEFT' }, 'TOPLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'TOPRIGHT', SPACING, SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('BOTTOMLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'BOTTOMRIGHT', SPACING, -SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('RIGHT', -SPACING, 0)

				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip = CreateFrame('Button', nil, self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetFrameLevel(CoreFrameLevel + 4)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetInside()
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnClick', self.OnClick)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnEnter', C.CommonScript.OnEnter)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnLeave', C.CommonScript.OnLeave)
			end

			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 1)]:Point('RIGHT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'LEFT', -2, 0)
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)]:Point('CENTER', self.Spec['TalentTier'..i])
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 3)]:Point('LEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'RIGHT', 2, 0)
		end

		self.Spec.TalentTier1:Point('TOP', self.Spec.Page, 0, -2)
		self.Spec.TalentTier2:Point('TOP', self.Spec.TalentTier1, 'BOTTOM', 0, -SPACING)
		self.Spec.TalentTier3:Point('TOP', self.Spec.TalentTier2, 'BOTTOM', 0, -SPACING)
		self.Spec.TalentTier4:Point('TOP', self.Spec.TalentTier3, 'BOTTOM', 0, -SPACING)
		self.Spec.TalentTier5:Point('TOP', self.Spec.TalentTier4, 'BOTTOM', 0, -SPACING)
		self.Spec.TalentTier6:Point('TOP', self.Spec.TalentTier5, 'BOTTOM', 0, -SPACING)

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
			C.Toolkit.TextSetting(self.Spec['GLYPH_'..groupName], '|cffceff00<|r '.._G[groupName]..' |cffceff00>|r', { ['FontSize'] = 10 }, 'TOP', self.Spec['GLYPH_'..groupName], 0, -5)
		end

		for i = 1, NUM_GLYPH_SLOTS do
			self.Spec['Glyph'..i] = CreateFrame('Button', nil, self.Spec.Page)
			self.Spec['Glyph'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['Glyph'..i]:SetFrameLevel(CoreFrameLevel + 2)
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
			self.Spec['Glyph'..i].Icon:SetFrameLevel(CoreFrameLevel + 3)
			self.Spec['Glyph'..i].Icon.Texture = self.Spec['Glyph'..i].Icon:CreateTexture(nil, 'OVERLAY')
			self.Spec['Glyph'..i].Icon.Texture:SetTexCoord(unpack(E.TexCoords))
			self.Spec['Glyph'..i].Icon.Texture:SetInside()
			self.Spec['Glyph'..i].Icon:Point('LEFT', self.Spec['Glyph'..i], SPACING, 0)

			self.Spec['Glyph'..i].Tooltip = CreateFrame('Button', nil, self.Spec['Glyph'..i])
			self.Spec['Glyph'..i].Tooltip:SetFrameLevel(CoreFrameLevel + 4)
			self.Spec['Glyph'..i].Tooltip:SetInside()
			self.Spec['Glyph'..i].Tooltip:SetScript('OnClick', self.OnClick)
			self.Spec['Glyph'..i].Tooltip:SetScript('OnEnter', C.CommonScript.OnEnter)
			self.Spec['Glyph'..i].Tooltip:SetScript('OnLeave', C.CommonScript.OnLeave)
			self.Spec['Glyph'..i].Tooltip.EnableAuctionSearch = true

			C.Toolkit.TextSetting(self.Spec['Glyph'..i], nil, { ['FontSize'] = 9, ['directionH'] = 'LEFT' }, 'LEFT', self.Spec['Glyph'..i].Icon, 'RIGHT', SPACING, 0)
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

		self.Spec.GLYPH_MAJOR_GLYPH:Point('TOPLEFT', self.Spec['TalentTier'..MAX_NUM_TALENT_TIERS], 'BOTTOMLEFT', 0, -SPACING)
		self.Spec.GLYPH_MAJOR_GLYPH:Point('TOPRIGHT', self.Spec['TalentTier'..MAX_NUM_TALENT_TIERS], 'BOTTOM', -2, -SPACING)
		self.Spec.GLYPH_MINOR_GLYPH:Point('TOPLEFT', self.Spec['TalentTier'..MAX_NUM_TALENT_TIERS], 'BOTTOM', 2, -SPACING)
		self.Spec.GLYPH_MINOR_GLYPH:Point('TOPRIGHT', self.Spec['TalentTier'..MAX_NUM_TALENT_TIERS], 'BOTTOMRIGHT', 0, -SPACING)
	end

	do --<< Scanning Tooltip >>--
		self.ScanTTForInspecting = CreateFrame('GameTooltip', 'KnightInspectScanTT_I', nil, 'GameTooltipTemplate')
		self.ScanTTForInspecting:SetOwner(UIParent, 'ANCHOR_NONE')
		self.ScanTT = CreateFrame('GameTooltip', 'KnightInspectScanTT', nil, 'GameTooltipTemplate')
		self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	end

	do --<< UnitPopup Setting >>--
		hooksecurefunc('UnitPopup_HideButtons', function()
			if KI.Activate then
				local Unit = UIDROPDOWNMENU_INIT_MENU.unit
				local Name = UIDROPDOWNMENU_INIT_MENU.name

				if Name then
					Name = Name..(UIDROPDOWNMENU_INIT_MENU.server and UIDROPDOWNMENU_INIT_MENU.server ~= '' and UIDROPDOWNMENU_INIT_MENU.server ~= E.myrealm and '-'..UIDROPDOWNMENU_INIT_MENU.server or '')
					Unit = UnitExists(Name) and Name or Unit

					for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE] or UnitPopupMenus[UIDROPDOWNMENU_INIT_MENU.which]) do
						if value == 'KnightInspect' then
							if not (Unit and not UnitCanAttack('player', Unit) and UnitIsConnected(Unit)) then
								if AISM then
									AISM.GroupMemberData[Name] = nil
								end

								UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
							end

							if AISM and (AISM.GroupMemberData[Name] or AISM.GuildMemberData[Name]) then
								UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 1
							end

							return
						end
					end
				end
			end
		end)

		local Count, tempCount
		hooksecurefunc('UnitPopup_OnUpdate', function()
			if not DropDownList1:IsShown() or not KI.Activate then return end

			for level, dropdownFrame in pairs(OPEN_DROPDOWNMENUS) do
				if dropdownFrame then
					Count = 0

					for index, value in ipairs(UnitPopupMenus[dropdownFrame.which]) do
						if UnitPopupShown[level][index] == 1 then
							Count = Count + 1

							if level > 1 then
								tempCount = Count
							else
								tempCount = Count + 1
							end

							if value == 'KnightInspect' then
								--local Type = dropdownFrame.which
								local Unit = UIDROPDOWNMENU_INIT_MENU.unit
								local Name = UIDROPDOWNMENU_INIT_MENU.name
								
								Name = Name..(UIDROPDOWNMENU_INIT_MENU.server and UIDROPDOWNMENU_INIT_MENU.server ~= '' and UIDROPDOWNMENU_INIT_MENU.server ~= E.myrealm and '-'..UIDROPDOWNMENU_INIT_MENU.server or '')
								Unit = UnitExists(Name) and Name or Unit
								
								if AISM and (type(AISM.GroupMemberData[Name]) == 'table' or AISM.GuildMemberData[Name]) or Unit and UnitIsVisible(Unit) then
									UIDropDownMenu_EnableButton(level, tempCount)
								else
									UIDropDownMenu_DisableButton(level, tempCount)
								end
							end
						end
					end
				end
			end
		end)
			
		hooksecurefunc('UnitPopup_OnClick', function(self)
			if KI.Activate and self.value == 'KnightInspect' then
				--local Type = UIDROPDOWNMENU_INIT_MENU.which
				local Name = UIDROPDOWNMENU_INIT_MENU.name
				local Realm = UIDROPDOWNMENU_INIT_MENU.server
				Realm = Realm ~= '' and Realm or E.myrealm

				local TableIndex = Name..(Realm ~= E.myrealm and '-'..Realm or '')
				local Unit = UnitExists(TableIndex) and TableIndex or UIDROPDOWNMENU_INIT_MENU.unit

				local SendChannel

				if AISM and AISM.GuildMemberData[TableIndex] then
					if Realm == E.myrealm then
						SendChannel = 'WHISPER'
					else
						SendChannel = 'GUILD'
					end
				elseif KI.CurrentGroupMode ~= 'NoGroup' and AISM and type(AISM.GroupMemberData[TableIndex]) == 'table' then
					if Realm == E.myrealm then
						SendChannel = 'WHISPER'
					else
						SendChannel = KI.InstanceType == 'pvp' and 'BATTLEGROUND' or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(KI.CurrentGroupMode)
					end
				end

				if AISM and SendChannel then
					AISM.CurrentInspectData[TableIndex] = {
						['UnitID'] = Unit,
					}
					AISM:RegisterInspectDataRequest(function(User, UserData)
						if User == TableIndex then
							KI.CurrentInspectData = E:CopyTable({}, KI.Default_CurrentInspectData)
							E:CopyTable(KI.CurrentInspectData, UserData)
							KI:ShowFrame(KI.CurrentInspectData)
							
							return true
						end
					end, TableIndex, true)
					SendAddonMessage('AISM_Inspect', 'AISM_DataRequestForInspecting:'..Name..'-'..Realm, SendChannel, TableIndex)
				elseif Unit then
					KI.InspectUnit(Unit)
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

KI.INSPECT_READY = function(InspectedUnitGUID)
	local UnitID = KI.CurrentInspectData.Name..(KI.CurrentInspectData.Realm and '-'..KI.CurrentInspectData.Realm or '')
	local GUIDByUnitName = UnitGUID(UnitID)
	local Name, Realm = UnitFullName(UnitID)

	if not GUIDByUnitName then
		UnitID = KI.CurrentInspectData.UnitID
		GUIDByUnitName = UnitGUID(UnitID)
		Name, Realm = UnitFullName(UnitID)
	end

	if not Name then
		_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
	end

	local TableIndex = Name..(Realm and Realm ~= '' and Realm ~= E.myrealm and '-'..E.myrealm or '')

	if InspectedUnitGUID ~= GUIDByUnitName then
		if GUIDByUnitName and KI.CurrentInspectData.Name == Name and KI.CurrentInspectData.Realm == Realm then
			KI.CurrentInspectData.UnitGUID = GUIDByUnitName
			return
		else
			ENI.CancelInspect(TableIndex)
			KI:UnregisterEvent('INSPECT_READY', 'KnightInspect')

			return
		end
	end

	_, _, KI.CurrentInspectData.Race, KI.CurrentInspectData.RaceID, KI.CurrentInspectData.GenderID = GetPlayerInfoByGUID(InspectedUnitGUID)

	local needReinspect
	local CurrentSetItem = {}
	local Slot, SlotTexture, SlotLink, CheckSpace, colorR, colorG, colorB, tooltipText, TransmogrifiedItem, SetName, SetItemCount, SetItemMax, SetOptionCount
	for _, SlotName in pairs(C.GearList) do
		Slot = KI[SlotName]
		KI.CurrentInspectData.Gear[SlotName] = {}

		SlotTexture = GetInventoryItemTexture(UnitID, Slot.ID)

		if SlotTexture and SlotTexture..'.blp' ~= Slot.EmptyTexture then
			SlotLink = GetInventoryItemLink(UnitID, Slot.ID)

			if not SlotLink then
				needReinspect = true
			else
				KI.CurrentInspectData.Gear[SlotName].ItemLink = SlotLink

				KI.ScanTTForInspecting:ClearLines()
				for i = 1, 10 do
					_G['KnightInspectScanTT_ITexture'..i]:SetTexture(nil)
				end
				KI.ScanTTForInspecting:SetInventoryItem(UnitID, Slot.ID)

				TransmogrifiedItem = nil
				checkSpace = 2
				SetOptionCount = 1

				for i = 1, KI.ScanTTForInspecting:NumLines() do
					tooltipText = _G['KnightInspectScanTT_ITextLeft'..i]:GetText()

					if not TransmogrifiedItem and tooltipText:match(C.TransmogrifiedKey) then
						if type(KI.CurrentInspectData.Gear[SlotName].Transmogrify) ~= 'number' then
							KI.CurrentInspectData.Gear[SlotName].Transmogrify = tooltipText:match(C.TransmogrifiedKey)
						end

						TransmogrifiedItem = true
					end

					SetName, SetItemCount, SetItemMax = tooltipText:match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
					if SetName then
						SetItemCount = tonumber(SetItemCount)
						SetItemMax = tonumber(SetItemMax)

						if SetItemCount > SetItemMax or SetItemMax == 1 then
							needReinspect = true
							break
						elseif CurrentSetItem[SetName] then
							break
						else
							CurrentSetItem[SetName] = {}

							for k = 1, KI.ScanTTForInspecting:NumLines() do
								tooltipText = _G['KnightInspectScanTT_ITextLeft'..(i+k)]:GetText()

								if tooltipText == ' ' then
									checkSpace = checkSpace - 1

									if checkSpace == 0 then break end
								elseif checkSpace == 2 then
									colorR, colorG, colorB = _G['KnightInspectScanTT_ITextLeft'..(i+k)]:GetTextColor()

									if colorR > LIGHTYELLOW_FONT_COLOR.r - 0.01 and colorR < LIGHTYELLOW_FONT_COLOR.r + 0.01 and colorG > LIGHTYELLOW_FONT_COLOR.g - 0.01 and colorG < LIGHTYELLOW_FONT_COLOR.g + 0.01 and colorB > LIGHTYELLOW_FONT_COLOR.b - 0.01 and colorB < LIGHTYELLOW_FONT_COLOR.b + 0.01 then
										CurrentSetItem[SetName][#CurrentSetItem[SetName] + 1] = LIGHTYELLOW_FONT_COLOR_CODE..tooltipText
									else
										CurrentSetItem[SetName][#CurrentSetItem[SetName] + 1] = GRAY_FONT_COLOR_CODE..tooltipText
									end
								elseif tooltipText:find(C.ItemSetBonusKey) then
									CurrentSetItem[SetName]['SetOption'..SetOptionCount] = tooltipText:match("^%((%d)%)%s.+:%s.+$") or true

									SetOptionCount = SetOptionCount + 1
								end
							end

							KI.CurrentInspectData.SetItem[SetName] = CurrentSetItem[SetName]

							break
						end
					end

					if checkSpace == 0 then break end
				end
			end
		end
	end

	if KI.CurrentInspectData.SetItem then
		for SetName in pairs(KI.CurrentInspectData.SetItem) do
			if not CurrentSetItem[SetName] then
				KI.CurrentInspectData.SetItem[SetName] = nil
			end
		end
	end

	-- Specialization
	KI.CurrentInspectData.Specialization[1].SpecializationID = GetInspectSpecialization(UnitID)
	for i = 1, NUM_TALENT_COLUMNS * MAX_NUM_TALENT_TIERS do
		KI.CurrentInspectData.Specialization[1]['Talent'..i] = select(5, GetTalentInfo(i, true, nil, UnitID, KI.CurrentInspectData.ClassID))
	end

	-- Glyph
	local SpellID, GlyphID
	for i = 1, NUM_GLYPH_SLOTS do
		_, _, _, SpellID, _, GlyphID = GetGlyphSocketInfo(i, nil, true, UnitID)

		KI.CurrentInspectData.Glyph[1]['Glyph'..i..'SpellID'] = SpellID or 0
		KI.CurrentInspectData.Glyph[1]['Glyph'..i..'ID'] = GlyphID or 0
	end

	-- Guild
	KI.CurrentInspectData.guildLevel, _, KI.CurrentInspectData.guildNumMembers = GetInspectGuildInfo(UnitID)
	KI.CurrentInspectData.guildEmblem = { GetGuildLogoInfo(UnitID) }

	if needReinspect then
		return
	end

	ENI.CancelInspect(TableIndex)
	KI:ShowFrame(KI.CurrentInspectData)
	KI:UnregisterEvent('INSPECT_READY')
end

KI.InspectUnit = function(UnitID)
	if not UnitExists('mouseover') and UnitExists('target') then
		UnitID = 'target'
	end

	if not UnitIsPlayer(UnitID) then
		return
	elseif UnitIsDeadOrGhost('player') then
		print('|cff2eb7e4[S&L]|r : '..L["You can't inspect while dead."])

		return
	elseif not UnitIsVisible(UnitID) then
		
		return
	else
		UnitID = NotifyInspect(UnitID, true) or UnitID

		KI.CurrentInspectData = E:CopyTable({}, KI.Default_CurrentInspectData)

		KI.CurrentInspectData.UnitID = UnitID
		KI.CurrentInspectData.UnitGUID = UnitGUID(UnitID)
		KI.CurrentInspectData.Title = UnitPVPName(UnitID)
		KI.CurrentInspectData.Level = UnitLevel(UnitID)
		KI.CurrentInspectData.Name, KI.CurrentInspectData.Realm = UnitFullName(UnitID)
		_, KI.CurrentInspectData.Class, KI.CurrentInspectData.ClassID = UnitClass(UnitID)
		KI.CurrentInspectData.guildName, KI.CurrentInspectData.guildRankName = GetGuildInfo(UnitID)

		KI.CurrentInspectData.Realm = KI.CurrentInspectData.Realm ~= '' and KI.CurrentInspectData.Realm ~= E.myrealm and KI.CurrentInspectData.Realm or nil

		KI:RegisterEvent('INSPECT_READY')
	end
end

function KI:ShowFrame(DataTable)
	local needUpdate, CheckItemInfoReceived

	for _, slotName in pairs(C.GearList) do
		if DataTable.Gear[slotName] and DataTable.Gear[slotName].ItemLink then
			_, CheckItemInfoReceived = GetItemInfo(DataTable.Gear[slotName].ItemLink)

			if not CheckItemInfoReceived then
				needUpdate = true

				if not self.GET_ITEM_INFO_RECEIVED then
					self.GET_ITEM_INFO_RECEIVED = function()
						self:ShowFrame(DataTable)
					end
					self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
				end
			end
		end
	end

	if needUpdate then
		return
	end

	self.GET_ITEM_INFO_RECEIVED = nil
	self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')

	self.Updater:Show()
	self.Updater:SetScript('OnUpdate', function()
		if not self:InspectFrame_DataSetting(DataTable) then
			self.Updater:SetScript('OnUpdate', nil)
			self.Updater:Hide()

			ShowUIPanel(KnightInspect)
		end
	end)
end

function KI:InspectFrame_DataSetting(DataTable)
	local needUpdate
	local r, g, b
	
	do --<< Equipment Slot and Enchant, Gem Setting >>--
		local ErrorDetected
		local ItemCount, ItemTotal = 0, 0
		local Slot, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, CurrentLineText, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount
		local arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6

		-- Setting except shirt and tabard
		for _, slotName in pairs(self.GearUpdated or C.GearList) do
			if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
				Slot = self[slotName]

				do --<< Clear Setting >>--
					ErrorDetected, TrueItemLevel, IsEnchanted, ItemUpgradeID, ItemTexture, r, g, b = nil, nil, nil, nil, nil, 0, 0, 0

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

						self.ScanTT:ClearLines()
						for i = 1, 10 do
							_G['KnightInspectScanTTTexture'..i]:SetTexture(nil)
						end
						self.ScanTT:SetHyperlink(format('%s:%s:%d:0:0:0:0:%s:%s:%s:%s:%s', arg1, itemID, enchantID, arg2, arg3, arg4, arg5, arg6))

						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['KnightInspectScanTTTexture'..i]:GetTexture()

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

						self.ScanTT:ClearLines()
						for i = 1, 10 do
							_G['KnightInspectScanTTTexture'..i]:SetTexture(nil)
						end
						self.ScanTT:SetHyperlink(Slot.Link)

						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['KnightInspectScanTTTexture'..i]:GetTexture()

							if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
								r, g, b = unpack(C.GemColor[Slot['Socket'..i].GemType])
								Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, 0.5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
							else
								Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, 0.5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end

							if ItemTexture then
								Slot['Socket'..i]:Show()
								GemCount_Now = GemCount_Now + 1
								Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								
								if DataTable.Gear[slotName]['Gem'..i] then
									GemCount = GemCount + 1
									Slot['Socket'..i].Texture:SetTexture(ItemTexture)
									Slot['Socket'..i].GemItemID = DataTable.Gear[slotName]['Gem'..i]
								else
									CurrentLineText = select(2, _G['KnightInspectScanTTTexture'..i]:GetPoint()):GetText()

									if not C.EmptySocketString[CurrentLineText] then
										GemCount = GemCount + 1
										Slot['Socket'..i].Texture:SetTexture(ItemTexture)
										Slot['Socket'..i].GemItemID = CurrentLineText
									end
								end
							end
						end

						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							needUpdate = needUpdate or {}
							needUpdate[#needUpdate + 1] = slotName
						end
					end
					
					_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(Slot.Link)
					r, g, b = GetItemQualityColor(ItemRarity)
					
					ItemUpgradeID = Slot.Link:match(':(%d+)\124h%[')
					
					--<< Enchant Parts >>--
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G['KnightInspectScanTTTextLeft'..i]:GetText()

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
				end

				-- Change Gradation
				if ErrorDetected then
					if Slot.Direction == 'LEFT' then
						Slot.Gradation.Texture:SetTexCoord(0, .5, .5, 1)
					else
						Slot.Gradation.Texture:SetTexCoord(.5, 1, .5, 1)
					end
				else
					if Slot.Direction == 'LEFT' then
						Slot.Gradation.Texture:SetTexCoord(0, .5, 0, .5)
					else
						Slot.Gradation.Texture:SetTexCoord(.5, 1, 0, .5)
					end
				end

				Slot.Texture:SetTexture(ItemTexture or Slot.EmptyTexture)
				Slot:SetBackdropBorderColor(r, g, b)
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

		self.SetItem = E:CopyTable({}, KI.CurrentInspectData.SetItem)
		self.Character.AverageItemLevel:SetText(C.Toolkit.Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', ItemTotal / ItemCount))
	end

	if needUpdate then
		self.GearUpdated = needUpdate

		return true
	end
	self.GearUpdated = nil

	r, g, b = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b

	do --<< Basic Information >>--
		self.Name:SetText('|c'..RAID_CLASS_COLORS[DataTable.Class].colorStr..DataTable.Name)
		self.Title:SetText((DataTable.Realm and DataTable.Realm ~= E.myrealm and DataTable.Realm..L[" Server's "] or '')..'|cff93daff'..(DataTable.Title and string.gsub(DataTable.Title, DataTable.Name, '') or ''))
		self.LevelRace:SetText(format('|cff%02x%02x%02x%s|r '..LEVEL..'|n%s', GetQuestDifficultyColor(DataTable.Level).r * 255, GetQuestDifficultyColor(DataTable.Level).g * 255, GetQuestDifficultyColor(DataTable.Level).b * 255, DataTable.Level, DataTable.Race))
		self.Guild:SetText(DataTable.guildName and '<|cff2eb7e4'..DataTable.guildName..'|r>  [|cff2eb7e4'..DataTable.guildRankName..'|r]' or '')
		self.ClassIcon:SetTexture('Interface\\ICONS\\ClassIcon_'..DataTable.Class..'.blp')
	end

	do --<< Color Setting >>--
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

	do --<< Information Page Setting >>--
		do -- Profession
			for i = 1, 2 do
				if DataTable.Profession[i].Name then
					self.Info.Profession:Show()
					self.Info.Profession['Prof'..i].Name:SetText(DataTable.Profession[i].Name)
					self.Info.Profession['Prof'..i].Level:SetText(DataTable.Profession[i].Level)
					self.Info.Profession['Prof'..i].Bar:SetValue(DataTable.Profession[i].Level)
				else
					self.Info.Profession:Hide()
					break
				end
			end
		end
			
		do -- Guild
			if DataTable.guildName and DataTable.guildLevel and DataTable.guildNumMembers then
				self.Info.Guild:Show()
				self.Info.Guild.Banner.Name:SetText('|cff2eb7e4'..DataTable.guildName)
				self.Info.Guild.Banner.LevelMembers:SetText('|cff77c0ff'..DataTable.guildLevel..'|r '..LEVEL..(DataTable.guildNumMembers > 0 and ' / '..format(INSPECT_GUILD_NUM_MEMBERS:gsub('%%d', '%%s'), '|cff77c0ff'..DataTable.guildNumMembers..'|r ') or ''))
				SetSmallGuildTabardTextures('player', self.Info.Guild.Emblem, self.Info.Guild.BG, self.Info.Guild.Border, DataTable.guildEmblem)
			else
				self.Info.Guild:Hide()
			end
		end

		KI:ReArrangeCategory()
	end

	do --<< Specialization Page Setting >>--
		local SpecGroup, Name, Color, Texture, SpecRole

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

		self.SpecIcon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark.blp')
		for i = 1, MAX_TALENT_GROUPS do
			Color = '|cff808080'

			Name = nil

			if DataTable.Specialization[i].SpecializationID then
				_, Name, _, Texture = GetSpecializationInfoByID(DataTable.Specialization[i].SpecializationID)

				if Name then
					SpecRole = C.ClassRole[DataTable.Class][Name].Role

					if i == SpecGroup then
						Color = C.ClassRole[DataTable.Class][Name].Color
						self.SpecIcon:SetTexture(Texture)
					end

					Name = (SpecRole == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:16:16:-3:0|t' or SpecRole == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:16:16:-3:-1|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:16:16:-2:-1|t')..Name
				end
			end

			if not Name then
				Texture, SpecRole = 'Interface\\ICONS\\INV_Misc_QuestionMark.blp', nil
				Name = '|cff808080'..L['No Specialization']
			end

			self.Spec['Spec'..i].Tab.text:SetText(Color..Name)
			self.Spec['Spec'..i].Texture:SetTexture(Texture)
			self.Spec['Spec'..i].Texture:SetDesaturated(i ~= SpecGroup)
		end

		-- Talents
		for i = 1, NUM_TALENT_COLUMNS * MAX_NUM_TALENT_TIERS do
			Name, Texture = GetTalentInfo(i, true, nil, nil, DataTable.ClassID)

			self.Spec['Talent'..i].Icon.Texture:SetTexture(Texture)
			self.Spec['Talent'..i].text:SetText(Name)
			self.Spec['Talent'..i].Tooltip.Link = GetTalentLink(i, true, DataTable.ClassID)
		end
	end

	do --<< Model and Frame Setting When InspectUnit Changed >>--
		if DataTable.UnitID and UnitIsVisible(DataTable.UnitID) then
			self.Model:SetUnit(DataTable.UnitID)
		else
			self.Model:SetCustomRace(self.ModelList[DataTable.RaceID].RaceID, DataTable.GenderID - 2)
			self.Model:TryOn(HeadSlotItem)
			self.Model:TryOn(BackSlotItem)
			self.Model:UndressSlot(self.HeadSlot.ID)
			self.Model:UndressSlot(self.BackSlot.ID)
			self.Model:Undress()

			for _, slotName in pairs(C.GearList) do
				if DataTable.Gear[slotName].ItemLink then
					if type(DataTable.Gear[slotName].Transmogrify) == 'number' then
						self.Model:TryOn(DataTable.Gear[slotName].Transmogrify)
					elseif not (DataTable.Gear[slotName].Transmogrify and DataTable.Gear[slotName].Transmogrify == 'NotDisplayed') then
						self.Model:TryOn(DataTable.Gear[slotName].ItemLink)
					end
				end
			end
		end

		if not (self.LastDataSetting and self.LastDataSetting == DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')) then
			self.Model:SetPosition(self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].z or 0, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].x or 0, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].y or 0)
			self.Model:SetFacing(-5.67)
			self.Model:SetPortraitZoom(1)
			self.Model:SetPortraitZoom(0)

			self:ChangePage('CharacterButton')
			self.ClassIconSlot:SetBackdropBorderColor(RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b)
			self.SpecIconSlot:SetBackdropBorderColor(RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b)

			self:ToggleSpecializationTab(DataTable.Specialization.ActiveSpec or 1, DataTable)
		elseif not (self.LastActiveSpec and self.LastActiveSpec == (DataTable.Specialization.ActiveSpec or 1)) then
			self:ToggleSpecializationTab(DataTable.Specialization.ActiveSpec or 1, DataTable)
		end
	end

	self.LastDataSetting = DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')
end

function KI:ReArrangeCategory()
	local InfoPage_Height = 0
	local PrevCategory

	for _, CategoryType in pairs(self.InfoPageCategoryList) do
		if self.Info[CategoryType]:IsShown() then
			if self.Info[CategoryType].Closed then
				InfoPage_Height = InfoPage_Height + INFO_TAB_SIZE + SPACING * 2
				self.Info[CategoryType]:Height(INFO_TAB_SIZE + SPACING * 2)
			else
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
	
	
function KI:ToggleSpecializationTab(Group, DataTable)
	local r, g, b
	self.LastActiveSpec = DataTable.Specialization.ActiveSpec or 1

	for i = 1, MAX_TALENT_GROUPS do
		if i == Group then
			self.Spec['Spec'..i].BottomLeftBorder:Show()
			self.Spec['Spec'..i].BottomRightBorder:Show()
			self.Spec['Spec'..i].Tab:SetFrameLevel(CoreFrameLevel + 3)
			self.Spec['Spec'..i].Tab.text:Point('BOTTOMRIGHT', 0, -10)
		else
			self.Spec['Spec'..i].BottomLeftBorder:Hide()
			self.Spec['Spec'..i].BottomRightBorder:Hide()
			self.Spec['Spec'..i].Tab:SetFrameLevel(CoreFrameLevel + 2)
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
	for i = 1, MAX_NUM_TALENT_TIERS do
		for k = 1, NUM_TALENT_COLUMNS do
			if DataTable.Specialization[Group]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] then
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(r, g, b, .3)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(r, g, b)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(r, g, b)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(0)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(1, 1, 1)
			else
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(.1, .1, .1)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(0, 0, 0)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(0, 0, 0)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(1)
				
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

UnitPopupButtons.KnightInspect = { ['text'] = L['KnightInspect'], ['dist'] = 0, }

function IFO:Initialize()
	-- if not E.private.sle.Armory.Inspect.Enable then return end
	
	Default_NotifyInspect = _G['NotifyInspect']
	Default_InspectUnit = _G['InspectUnit']
	
	if KI.CreateInspectFrame then
		KI:CreateInspectFrame()
	end
	
	_G['NotifyInspect'] = ENI.NotifyInspect or _G['NotifyInspect']
	_G['InspectUnit'] = KI.InspectUnit
	
	tinsert(UnitPopupMenus.FRIEND, 5, 'KnightInspect')
	tinsert(UnitPopupMenus.GUILD, 5, 'KnightInspect')
	tinsert(UnitPopupMenus.RAID, 12, 'KnightInspect')
	tinsert(UnitPopupMenus.FOCUS, 5, 'KnightInspect')
	for _, GroupType in pairs({ 'PLAYER', 'PARTY' }) do
		for Index, MenuType in pairs(UnitPopupMenus[GroupType]) do
			if MenuType == 'INSPECT' then
				UnitPopupMenus[GroupType][Index] = 'KnightInspect'
				break
			end
		end
	end
	
	KI.Activate = true
end
E:RegisterModule(IFO:GetName())