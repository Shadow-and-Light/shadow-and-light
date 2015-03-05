local E, L, V, P, G = unpack(ElvUI)
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")

local CA = CreateFrame('Frame', 'CharacterArmory', PaperDollFrame)
local IsGemType = select(8, GetAuctionItemClasses())
local SlotIDList = {}
local InsetDefaultPoint = { CharacterFrameInsetRight:GetPoint() }
local ExpandButtonDefaultPoint = { CharacterFrameExpandButton:GetPoint() }

local GetInventoryItemID, GetItemInfo = GetInventoryItemID, GetItemInfo

CA.elapsed = 0
CA.Delay_Updater = .5

local C = SLArmoryConstants
local backgrounds = {
	["SPACE"] = "Space",
	["ALLIANCE"] = "Alliance-text",
	["HORDE"] = "Horde-text",
	["EMPIRE"] = "TheEmpire",
	["CASTLE"] = "Castle",
}

do --<< Button Script >>--
	function CA:OnEnter()
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
	
	
	function CA:OnLeave()
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	
	function CA:GemSocket_OnEnter()
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if type(Parent.GemItemID) == 'number' then
				if GetItemInfo(Parent.GemItemID) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(Parent.GemItemID)))
					self:SetScript('OnUpdate', nil)
				else
					self:SetScript('OnUpdate', CA.GemSocket_OnEnter)
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
	
	
	function CA:GemSocket_OnClick(Button)
		if CursorHasItem() then
			CA.GemSocket_OnRecieveDrag(self)
			return
		else
			self = self:GetParent()
		end
		
		if self.GemItemID then
			local ItemName, ItemLink = GetItemInfo(self.GemItemID)
			
			if not IsShiftKeyDown() then
				SetItemRef(ItemLink, ItemLink, 'LeftButton')
			else
				if Button == 'RightButton' then
					SocketInventoryItem(GetInventorySlotInfo(self.SlotName))
				elseif HandleModifiedItemClick(ItemLink) then
				elseif BrowseName and BrowseName:IsVisible() then
					AuctionFrameBrowse_Reset(BrowseResetButton)
					BrowseName:SetText(ItemName)
					BrowseName:SetFocus()
				end
			end
		end
	end
	
	
	function CA:GemSocket_OnRecieveDrag()
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == IsGemType then
				SocketInventoryItem(GetInventorySlotInfo(self.SlotName))
				ClickSocketButton(self.SocketNumber)
			end
		end
	end
	
	
	function CA:Transmogrify_OnEnter()
		self.Texture:SetVertexColor(1, .8, 1)
		
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		GameTooltip:SetHyperlink(self.Link)
		GameTooltip:Show()
	end
	
	
	function CA:Transmogrify_OnLeave()
		self.Texture:SetVertexColor(1, .5, 1)
		
		GameTooltip:Hide()
	end
	
	
	function CA:Transmogrify_OnClick(Button)
		local ItemName, ItemLink = GetItemInfo(self.Link)
		
		if not IsShiftKeyDown() then
			SetItemRef(ItemLink, ItemLink, 'LeftButton')
		else
			if HandleModifiedItemClick(ItemLink) then
			elseif BrowseName and BrowseName:IsVisible() then
				AuctionFrameBrowse_Reset(BrowseResetButton)
				BrowseName:SetText(ItemName)
				BrowseName:SetFocus()
			end
		end
	end
end


function CA:Setup_CharacterArmory()
	--<< Core >>--
	self:Point('TOPLEFT', CharacterFrameInset, 10, 20)
	self:Point('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -10, 5)
	
	--<< Updater >>--
	local args
	self:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_UPDATE' or Event == 'PLAYER_ENTERING_WORLD' then
			self.GearUpdated = nil
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
			end
		elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
			args = ...
			
			self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
			self.GearUpdated[#self.GearUpdated + 1] = SlotIDList[args]
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == E.myname then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
			end
		elseif Event == 'UPDATE_INVENTORY_DURABILITY' then
			self.DurabilityUpdated = nil
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		end
	end)
	self:SetScript('OnShow', self.CharacterArmory_DataSetting)
	hooksecurefunc('CharacterFrame_Collapse', function() if PaperDollFrame:IsShown() then CharacterFrame:SetWidth(448) end end)
	hooksecurefunc('CharacterFrame_Expand', function() if PaperDollFrame:IsShown() then CharacterFrame:SetWidth(650) end end)
	hooksecurefunc('ToggleCharacter', function(frameType)
		if frameType ~= 'PaperDollFrame' and frameType ~= 'PetPaperDollFrame' then
			CharacterFrame:SetWidth(PANEL_DEFAULT_WIDTH)
		elseif frameType == 'PaperDollFrame' then
			CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
			CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', 0, 1)
		else
			CharacterFrameInsetRight:SetPoint(unpack(InsetDefaultPoint))
			CharacterFrameExpandButton:SetPoint(unpack(ExpandButtonDefaultPoint))
		end
	end)
	hooksecurefunc('PaperDollFrame_SetLevel', function()
		CharacterLevelText:SetText('|c'..RAID_CLASS_COLORS[E.myclass].colorStr..CharacterLevelText:GetText())

		--Maybe Adjust Name, Level, Avg iLvL if bliz skinning is off?
		CharacterFrameTitleText:ClearAllPoints()
		CharacterFrameTitleText:Point('TOP', self, 'TOP', 0, 0)
		CharacterFrameTitleText:SetParent(self)
		CharacterLevelText:ClearAllPoints()
		CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, 3)
		CharacterLevelText:SetParent(self)
	end)
	--hooksecurefunc('CharacterFrame_Collapse', function() if Info.CharacterArmory_Activate then CharacterFrame:SetWidth(448) end end)
	--hooksecurefunc('CharacterFrame_Expand', function() if Info.CharacterArmory_Activate then CharacterFrame:SetWidth(650) end end)
	--hooksecurefunc('PaperDollFrame_SetLevel', function()
		--if Info.CharacterArmory_Activate then 
			--CharacterLevelText:SetText('|c'..RAID_CLASS_COLORS[E.myclass].colorStr..CharacterLevelText:GetText())

			--Maybe Adjust Name, Level, Avg iLvL if bliz skinning is off?
			--CharacterFrameTitleText:ClearAllPoints()
			--CharacterFrameTitleText:Point('TOP', self, 0, 15)
			--CharacterFrameTitleText:SetParent(self)
			--CharacterLevelText:ClearAllPoints()
			--CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, -4)
			--CharacterLevelText:SetParent(self)
		--end
	--end)

	--<< Background >>--
	self.BG = self:CreateTexture(nil, 'BACKGROUND')
	--self.BG:SetInside()
	self.BG:SetPoint("TOPLEFT", self, "TOPLEFT", -7, -20)
	self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 7, 2)
	CFO:UpdateCharacterBG()

	--<< Change Model Frame's frameLevel >>--
	CharacterModelFrame:SetFrameLevel(self:GetFrameLevel() + 2)

	--<< Average Item Level >>--
	C.Toolkit.TextSetting(self, nil, { Tag = 'AverageItemLevel', FontSize = 12, }, 'TOP', CharacterLevelText, 'BOTTOM', 0, 3)
	local function ValueColorUpdate()
		self.AverageItemLevel:SetText(C.Toolkit.Color_Value(L['Average'])..': '..format('%.2f', select(2, GetAverageItemLevel())))
	end
	E.valueColorUpdateFuncs[ValueColorUpdate] = true
	
	-- Create each equipment slots gradation, text, gem socket icon.
	local Slot
	for i, SlotName in pairs(C.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = GetInventorySlotInfo(SlotName)
		Slot:Point(Slot.Direction, _G['Character'..SlotName], Slot.Direction == 'LEFT' and -1 or 1, 0)
		
		-- Grow each equipment slot's frame level
		_G['Character'..SlotName]:SetFrameLevel(Slot:GetFrameLevel() + 1)
		
		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'OVERLAY')
		Slot.Gradation:SetInside()
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Gradation')
		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Gradation:SetTexCoord(1, 0, 0, 1)
		end
		
		if SlotName ~= 'ShirtSlot' and SlotName ~= 'TabardSlot' then
			-- Item Level
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'ItemLevel', FontSize = 10, directionH = Slot.Direction }, 'TOP'..Slot.Direction, _G['Character'..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)

			-- Enchantment Name
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'ItemEnchant', FontSize = 8, directionH = Slot.Direction }, Slot.Direction, _G['Character'..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(E.db.sle.characterframeoptions.itemenchant.warningSize)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)

			-- Durability
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'Durability', FontSize = 10, directionH = Slot.Direction }, 'BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)

			-- Gem Socket
			for i = 1, MAX_NUM_SOCKETS do
				Slot['Socket'..i] = CreateFrame('Frame', nil, Slot)
				Slot['Socket'..i]:Size(E.db.sle.characterframeoptions.itemgem.socketSize)
				Slot['Socket'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
				Slot['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
				Slot['Socket'..i]:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 1)

				Slot['Socket'..i].SlotName = SlotName
				Slot['Socket'..i].SocketNumber = i

				Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
				Slot['Socket'..i].Socket:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i].Socket:SetInside()
				Slot['Socket'..i].Socket:SetFrameLevel(Slot['Socket'..i]:GetFrameLevel() + 1)
				Slot['Socket'..i].Socket:RegisterForClicks('AnyUp')
				Slot['Socket'..i].Socket:SetScript('OnEnter', self.OnEnter)
				Slot['Socket'..i].Socket:SetScript('OnLeave', self.OnLeave)
				Slot['Socket'..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
				Slot['Socket'..i].Socket:SetScript('OnReceiveDrag', self.GemSocket_OnRecieveDrag)

				Slot['Socket'..i].Texture = Slot['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
				Slot['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
				Slot['Socket'..i].Texture:SetInside()
			end

			Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)

			Slot.SocketWarning = CreateFrame('Button', nil, Slot)
			Slot.SocketWarning:Size(E.db.sle.characterframeoptions.itemgem.warningSize)
			Slot.SocketWarning:RegisterForClicks('AnyUp')
			Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
			Slot.SocketWarning.Texture:SetInside()
			Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
			Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
			Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Transmogrify
			if C.CanTransmogrifySlot[SlotName] then
				Slot.TransmogrifyAnchor = CreateFrame('Button', nil, Slot)
				Slot.TransmogrifyAnchor:Size(12)
				Slot.TransmogrifyAnchor:SetFrameLevel(Slot:GetFrameLevel() + 2)
				Slot.TransmogrifyAnchor:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
				Slot.TransmogrifyAnchor:SetScript('OnEnter', self.Transmogrify_OnEnter)
				Slot.TransmogrifyAnchor:SetScript('OnLeave', self.Transmogrify_OnLeave)
				Slot.TransmogrifyAnchor:SetScript('OnClick', self.Transmogrify_OnClick)
				
				Slot.TransmogrifyAnchor.Texture = Slot.TransmogrifyAnchor:CreateTexture(nil, 'OVERLAY')
				Slot.TransmogrifyAnchor.Texture:SetInside()
				Slot.TransmogrifyAnchor.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\anchor')
				Slot.TransmogrifyAnchor.Texture:SetVertexColor(1, .5, 1)
				
				if Slot.Direction == 'LEFT' then
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(0, 1, 0, 1)
				else
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(1, 0, 0, 1)
				end
				
				Slot.TransmogrifyAnchor:Hide()
			end
		end
		
		SlotIDList[Slot.ID] = SlotName
		self[SlotName] = Slot
	end
	
	-- GameTooltip for counting gem sockets and getting enchant effects
	self.ScanTT = CreateFrame('GameTooltip', 'SLE_CharacterArmory_ScanTT', nil, 'GameTooltipTemplate')
	self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	
	self.Setup_CharacterArmory = nil
end


function CA:CharacterArmory_DataSetting()
	self.NeedUpdate = nil
	
	if not self.DurabilityUpdated then
		self.NeedUpdate = self:Update_Durability() or self.NeedUpdate
	end
	
	if self.GearUpdated ~= true then
		self.NeedUpdate = self:Update_Gear() or self.NeedUpdate
	end
	
	if not self.NeedUpdate and self:IsShown() then
		self:SetScript('OnUpdate', nil)
	elseif self.NeedUpdate then
		self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
	end
end


function CA:Update_Durability()
	local Slot, R, G, B, CurrentDurability, MaxDurability
	
	for _, SlotName in pairs(C.GearList) do
		Slot = self[SlotName]
		CurrentDurability, MaxDurability = GetInventoryItemDurability(Slot.ID)
		
		if CurrentDurability and MaxDurability then
			if E.db.sle.characterframeoptions.itemdurability.show ~= false then
				R, G, B = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
				Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(R, G, B), (CurrentDurability / MaxDurability) * 100)
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, -2)
			end
		elseif Slot.Durability then
			Slot.Durability:SetText('')
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 3)
		end
	end
	
	self.DurabilityUpdated = true
end

function CA:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()

	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end

function CA:Update_Gear()
	--[[ Get Player Profession
	
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	self.PlayerProfession = {}
	
	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and C.ProfessionList[Prof1] then self.PlayerProfession[(C.ProfessionList[Prof1].Key)] = Prof1_Level end
	if Prof2 and C.ProfessionList[Prof2] then self.PlayerProfession[(C.ProfessionList[Prof2].Key)] = Prof2_Level end
	]]
	local ErrorDetected, NeedUpdate, NeedUpdateList, R, G, B
	local Slot, ItemLink, ItemData, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, UsableEffect, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount, IsTransmogrified, TransmogrifyItemID

	for _, SlotName in pairs(self.GearUpdated or C.GearList) do
		if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
			Slot = self[SlotName]
			ItemLink = GetInventoryItemLink('player', Slot.ID)

			do --<< Clear Setting >>--
				NeedUpdate, ErrorDetected, TrueItemLevel, IsEnchanted, UsableEffect, ItemUpgradeID, ItemTexture = nil, nil, nil, nil, nil, nil, nil

				Slot.ItemLevel:SetText(nil)
				Slot.ItemEnchant:SetText(nil)
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i].Texture:SetTexture(nil)
					Slot['Socket'..i].Socket.Link = nil
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
				if Slot.TransmogrifyAnchor then
					Slot.TransmogrifyAnchor.Link = nil
					Slot.TransmogrifyAnchor:Hide()
				end
			end

			if ItemLink then
				if not ItemLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
					do --<< Gem Parts >>--
						ItemData = { strsplit(':', ItemLink) }
						ItemData[4], ItemData[5], ItemData[6], ItemData[7] = 0, 0, 0, 0

						for i = 1, #ItemData do
							ItemData.FixedLink = (ItemData.FixedLink and ItemData.FixedLink..':' or '')..ItemData[i]
						end
					
						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(ItemData.FixedLink)

						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0

						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['SLE_CharacterArmory_ScanTTTexture'..i]:GetTexture()

							if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot['Socket'..GemCount_Default].GemType = strupper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end

						-- Second, Check if slot's item enable to adding a socket
						GemCount_Enable = GemCount_Default
						--[[
						if (SlotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
							((SlotName == 'WristSlot' or SlotName == 'HandsSlot') and self.PlayerProfession.BlackSmithing and self.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith

							GemCount_Enable = GemCount_Enable + 1
							Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
						end
						]]
						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetInventoryItem('player', Slot.ID)

						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['SLE_CharacterArmory_ScanTTTexture'..i]:GetTexture()
							GemID = select(i, GetInventoryItemGems(Slot.ID))

							if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
								R, G, B = unpack(C.GemColor[Slot['Socket'..i].GemType])
								Slot['Socket'..i].Socket:SetBackdropColor(R, G, B, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(R, G, B)
							else
								Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end

							if ItemTexture or GemID then
								if E.db.sle.characterframeoptions.itemgem.show then
									Slot['Socket'..i]:Show()
									Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								else
									Slot['Socket'..i]:Hide()
									Slot.SocketWarning:Point(Slot.Direction, Slot['Socket1'], (Slot.Direction == 'LEFT' and 'LEFT' or 'RIGHT'), 0, 0)
								end

								GemCount_Now = GemCount_Now + 1

								if GemID then
									GemCount = GemCount + 1
									Slot['Socket'..i].GemItemID = GemID
								
									_, Slot['Socket'..i].Socket.Link, _, _, _, _, _, _, _, ItemTexture = GetItemInfo(GemID)

									if ItemTexture then
										Slot['Socket'..i].Texture:SetTexture(ItemTexture)
									else
										NeedUpdate = true
									end
								end
							end
						end

						--print(SlotName..' : ', GemCount_Default, GemCount_Enable, GemCount_Now, GemCount)
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							NeedUpdate = true
						end
					end

					_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(ItemLink)
					R, G, B = GetItemQualityColor(ItemRarity)

					ItemUpgradeID = ItemLink:match(':(%d+)\124h%[')

					--<< Enchant Parts >>--
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G['SLE_CharacterArmory_ScanTTTextLeft'..i]:GetText()

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
						
							--God damn russian localization team!
							CurrentLineText = gsub(CurrentLineText, "к показателю уклонения", ITEM_MOD_DODGE_RATING_SHORT)
							CurrentLineText = gsub(CurrentLineText, "к показателю скорости", ITEM_MOD_HASTE_RATING_SHORT)
							CurrentLineText = gsub(CurrentLineText, "к показателю парирования", ITEM_MOD_PARRY_RATING_SHORT)
							CurrentLineText = gsub(CurrentLineText, "к показателю искусности", ITEM_MOD_MASTERY_RATING_SHORT)
							CurrentLineText = gsub(CurrentLineText, "к показателю критического удара", ITEM_MOD_CRIT_RATING_SHORT)
							CurrentLineText = gsub(CurrentLineText, "к показателю универсальности", "универсальности")
							CurrentLineText = gsub(CurrentLineText, "к показателю многократной атаки", "многократной атаке")
														
							CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
							CurrentLineText = gsub(CurrentLineText, "небольшое увеличение скорости передвижения", "+к бегу")
							CurrentLineText = gsub(CurrentLineText, "к скорости передвижения", "к бегу")
							
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long

							if E.db.sle.characterframeoptions.itemenchant.show then
								Slot.ItemEnchant:Show()
								if E.db.sle.characterframeoptions.itemenchant.mouseover then
									Slot.ItemEnchant:SetDrawLayer('HIGHLIGHT')
								else
									Slot.ItemEnchant:SetDrawLayer('OVERLAY')
								end
								Slot.ItemEnchant:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemenchant.font), E.db.sle.characterframeoptions.itemenchant.fontSize, E.db.sle.characterframeoptions.itemenchant.fontOutline)
								Slot.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
							else
								Slot.ItemEnchant:Hide()
							end

							IsEnchanted = true
						elseif CurrentLineText:find(ITEM_SPELL_TRIGGER_ONUSE) then
							UsableEffect = true
						end
					end

					--<< ItemLevel Parts >>--
					if BasicItemLevel then
						if ItemUpgradeID then
							if ItemUpgradeID == '0' then
								ItemUpgradeID = nil
							else
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							end
						end
						if E.db.sle.characterframeoptions.itemlevel.show ~= false then
							Slot.ItemLevel:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemlevel.font), E.db.sle.characterframeoptions.itemlevel.fontSize, E.db.sle.characterframeoptions.itemlevel.fontOutline)
							Slot.ItemLevel:SetText((not TrueItemLevel or BasicItemLevel == TrueItemLevel) and BasicItemLevel or (Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(C.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
						end
					end
					--if KF.db.Modules.Armory.Character.NoticeMissing ~= false then
						if not IsEnchanted and C.EnchantableSlots[SlotName] then
							local id = GetInventoryItemID("player", Slot.ID)
							local IType = select(9, GetItemInfo(id))
							if IType == "INVTYPE_WEAPON" then 
								ErrorDetected = true
								Slot.EnchantWarning:Show()
								Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
							end
						end
						
						if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
							ErrorDetected = true
							
							Slot.SocketWarning:Show()
							Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
						end
					--end
					
					--<< Transmogrify Parts >>--
					if Slot.TransmogrifyAnchor then
						IsTransmogrified, _, _, _, _, TransmogrifyItemID = GetTransmogrifySlotInfo(Slot.ID)
						
						if IsTransmogrified then
							_, Slot.TransmogrifyAnchor.Link = GetItemInfo(TransmogrifyItemID)
							Slot.TransmogrifyAnchor:Show()
						end
					end
					--[[ Check Error
					if DB.Modules.Armory.Character.NoticeMissing ~= false then
						if (not IsEnchanted and C.EnchantableSlots[SlotName]) or ((SlotName == 'Finger0Slot' or SlotName == 'Finger1Slot') and self.PlayerProfession.Enchanting and self.PlayerProfession.Enchanting >= 550 and not IsEnchanted) then
							ErrorDetected = true
							if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
								Slot.EnchantWarning:Show()
								Slot.ItemEnchant:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemenchant.font), E.db.sle.characterframeoptions.itemenchant.fontSize, E.db.sle.characterframeoptions.itemenchant.fontOutline)
								Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
							end
						elseif self.PlayerProfession.Engineering and ((SlotName == 'BackSlot' and self.PlayerProfession.Engineering >= 380) or (SlotName == 'HandsSlot' and self.PlayerProfession.Engineering >= 400) or (SlotName == 'WaistSlot' and self.PlayerProfession.Engineering >= 380)) and not UsableEffect then
							ErrorDetected = true
							if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
								Slot.EnchantWarning:Show()
								Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
							end
						elseif SlotName == 'ShoulderSlot' and self.PlayerProfession.Inscription and C.ItemEnchant_Profession_Inscription and self.PlayerProfession.Inscription >= C.ItemEnchant_Profession_Inscription and not C.ItemEnchant_Profession_Inscription[(ItemData[3])] then
							ErrorDetected = true
							if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
								Slot.ItemEnchant:SetDrawLayer('OVERLAY')
								Slot.EnchantWarning:Show()
								Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
							end
						elseif slotName == 'WristSlot' and self.PlayerProfession.LeatherWorking and C.ItemEnchant_Profession_LeatherWorking and self.PlayerProfession.LeatherWorking >= C.ItemEnchant_Profession_LeatherWorking.NeedLevel and not C.ItemEnchant_Profession_LeatherWorking[enchantID] then
							ErrorDetected = true
							if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
								Slot.ItemEnchant:SetDrawLayer('OVERLAY')
								Slot.EnchantWarning:Show()
								Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
							end
						elseif slotName == 'BackSlot' and self.PlayerProfession.Tailoring and C.ItemEnchant_Profession_Tailoring and CFO.PlayerProfession.Tailoring >= C.ItemEnchant_Profession_Tailoring.NeedLevel and not C.ItemEnchant_Profession_Tailoring[enchantID] then
							for EnchantID, NeedLevel in pairs(C.ItemEnchant_Profession_Tailoring) do
								if self.PlayerProfession_Tailoring >= NeedLevel then
									Slot.ItemEnchant:SetDrawLayer('OVERLAY')
									if EnchantID == ItemTable[3] then
										ErrorDetected = nil
										break
									else
										ErrorDetected = true
									end
								end
							end
							
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
						end
						
						if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
							ErrorDetected = true
							
							Slot.SocketWarning:Show()
							
							if GemCount_Enable > GemCount_Now then
								if SlotName == 'WaistSlot' then
									if TrueItemLevel < 300 then
										_, Slot.SocketWarning.Link = GetItemInfo(41611)	
									elseif TrueItemLevel < 417 then
										_, Slot.SocketWarning.Link = GetItemInfo(55054)
									else
										_, Slot.SocketWarning.Link = GetItemInfo(90046)
									end
									
									Slot.SocketWarning.Message = L['Missing Buckle']
									
									Slot.SocketWarning:SetScript('OnClick', function(self, button)
										local itemName, itemLink
										
										if TrueItemLevel < 300 then
											itemName, itemLink = GetItemInfo(41611)
										elseif TrueItemLevel < 417 then
											itemName, itemLink = GetItemInfo(55054)
										else
											itemName, itemLink = GetItemInfo(90046)
										end
										
										if HandleModifiedItemClick(itemLink) then
										elseif IsShiftKeyDown() then
											if button == 'RightButton' then
												SocketInventoryItem(Slot.ID)
											elseif BrowseName and BrowseName:IsVisible() then
												AuctionFrameBrowse_Reset(BrowseResetButton)
												BrowseName:SetText(itemName)
												BrowseName:SetFocus()
											end
										end
									end)
								elseif SlotName == 'HandsSlot' then
									Slot.SocketWarning.Link = GetSpellLink(114112)
									Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
								elseif SlotName == 'WristSlot' then
									Slot.SocketWarning.Link = GetSpellLink(113263)
									Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
								end
							else
								Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
							end
						end
					end
					]]
				else
					NeedUpdate = true
				end
			end

			-- Change Gradation
			if ErrorDetected and E.db.sle.characterframeoptions.showerrorgradient then
				Slot.Gradation:SetVertexColor(1, 0, 0)
			else
				Slot.Gradation:SetVertexColor(unpack(E.db.sle.characterframeoptions.gradientColor))
			end

			if NeedUpdate then
				NeedUpdateList = NeedUpdateList or {}
				NeedUpdateList[#NeedUpdateList + 1] = SlotName
			end
		end
	end

	self.AverageItemLevel:SetText(C.Toolkit.Color_Value(STAT_AVERAGE_ITEM_LEVEL)..': '..format('%.2f', select(2, GetAverageItemLevel())))

	if NeedUpdateList then
		self.GearUpdated = NeedUpdateList
		return true
	end

	self.GearUpdated = true
end

function CFO:UpdateCharacterBG()
	local BGdrop = E.db.sle.characterframeoptions.image.dropdown
	if E.db.sle.characterframeoptions.showimage ~= false then
		if BGdrop ~= "CUSTOM" then
			CA.BG:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\'..backgrounds[BGdrop])
		else
			CA.BG:SetTexture(E.db.sle.characterframeoptions.image.custom)
		end
	else
		CA.BG:SetTexture(nil);
	end
end

function CFO:ChangeGradiantVisibility()
	for _, slotName in pairs(C.GearList) do
		if E.db.sle.characterframeoptions.shownormalgradient ~= false then
			CA[slotName].Gradation:Show()
		else
			CA[slotName].Gradation:Hide()
		end
	end
end

function CFO:UpdateErrorGradient()

	CA:CharacterArmory_DataSetting()
end

function CFO:ResizeErrorIcon()
	for _, slotName in pairs(C.GearList) do
		if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
			CA[slotName].SocketWarning:Size(E.db.sle.characterframeoptions.itemgem.warningSize)
			CA[slotName].EnchantWarning:Size(E.db.sle.characterframeoptions.itemenchant.warningSize)
			for i = 1, MAX_NUM_SOCKETS do
				CA[slotName]['Socket'..i]:Size(E.db.sle.characterframeoptions.itemgem.socketSize)
			end
		end
	end
end

function CA:StartArmoryFrame()
	-- Setting frame
	CharacterFrame:SetHeight(444)
	CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
	CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -3, 7)

	-- Move right equipment slots
	CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInsetRight, 'TOPLEFT', -4, -2)

	-- Move bottom equipment slots
	CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 181, 14)

	-- Model Frame
	CharacterModelFrame:Size(341, 302)
	CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -90)
	CharacterModelFrame.BackgroundTopLeft:Hide()
	CharacterModelFrame.BackgroundTopRight:Hide()
	CharacterModelFrame.BackgroundBotLeft:Hide()
	CharacterModelFrame.BackgroundBotRight:Hide()
	
	-- Character Control Frame
	CharacterModelFrameControlFrame:ClearAllPoints()
	CharacterModelFrameControlFrame:SetPoint('BOTTOM', CharacterModelFrame, 'BOTTOM', -1.5, 1)

	if CA.Setup_CharacterArmory then
		CA:Setup_CharacterArmory()
	else
		CA:Show()
	end
	CA:CharacterArmory_DataSetting()

	-- Run SLE CharacterArmoryMode
	CA:RegisterEvent('SOCKET_INFO_SUCCESS')
	CA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	CA:RegisterEvent('UNIT_INVENTORY_CHANGED')
	CA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
	CA:RegisterEvent('TRANSMOGRIFY_UPDATE')
	CA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	CA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	CA:RegisterEvent('PLAYER_ENTERING_WORLD')

	-- For frame resizing
	--[[CA.ChangeCharacterFrameWidth:SetParent(PaperDollFrame)
	if PaperDollFrame:IsVisible() then
		CA.ChangeCharacterFrameWidth:Show()
		CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 650 or 448)
	end]]
end

function CFO:Initialize()
	if not E.private.sle.characterframeoptions.enable then return end

	CA:StartArmoryFrame()
end