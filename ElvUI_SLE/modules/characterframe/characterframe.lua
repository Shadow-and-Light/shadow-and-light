local E, L, V, P, G = unpack(ElvUI)
local CFO = E:GetModule('CharacterFrameOptions')
local LSM = LibStub("LibSharedMedia-3.0")

local CA = CreateFrame('Frame', 'CharacterArmory', PaperDollFrame)
local SlotIDList = {}
local C = SLArmoryConstants
local backgrounds = {
	["SPACE"] = "Space",
	["ALLIANCE"] = "Alliance-text",
	["HORDE"] = "Horde-text",
	["EMPIRE"] = "TheEmpire",
	["CASTLE"] = "Castle",
}

do --<< Button Script >>--
	CA.OnEnter = function(self)
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
	
	CA.OnLeave = function(self)
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	CA.GemSocket_OnEnter = function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if type(Parent.GemItemID) == 'number' then
				if GetItemInfo(Parent.GemItemID) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(Parent.GemItemID)))
				else
					self:SetScript('OnUpdate', function()
						if GetItemInfo(Parent.GemItemID) then
							CA.GemSocket_OnEnter(self)
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
	
	CA.GemSocket_OnClick = function(self, button)
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			-- Check cursor item is gem type
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
				SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				ClickSocketButton(self.socketNumber)
				
				return
			end
		end
		
		if self.GemItemID then
			local itemName, itemLink = GetItemInfo(self.GemItemID)
			
			if not IsShiftKeyDown() then
				SetItemRef(itemLink, itemLink, 'LeftButton')
			else
				if button == 'RightButton' then
					SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				elseif HandleModifiedItemClick(itemLink) then
				elseif BrowseName and BrowseName:IsVisible() then
					AuctionFrameBrowse_Reset(BrowseResetButton)
					BrowseName:SetText(itemName)
					BrowseName:SetFocus()
				end
			end
		end
	end
	
	CA.GemSocket_OnRecieveDrag = function(self)
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
				SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				ClickSocketButton(self.socketNumber)
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
			if Event == 'TRANSMOGRIFY_UPDATE' then
				print(...)
			end
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
	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrame:SetWidth(448);
	end)
	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrame:SetWidth(650);
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
	for i, slotName in pairs(C.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = GetInventorySlotInfo(slotName)
		Slot:Point(Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and -1 or 1, 0)

		-- Grow each equipment slot's frame level
		_G['Character'..slotName]:SetFrameLevel(Slot:GetFrameLevel() + 1)

		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'OVERLAY')
		Slot.Gradation:SetInside()
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Gradation')

		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Gradation:SetTexCoord(1, 0, 0, 1)
		end

		if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
			-- Item Level
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'ItemLevel', FontSize = 10, directionH = Slot.Direction, }, 'TOP'..Slot.Direction, _G['Character'..slotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)

			-- Enchantment Name
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'ItemEnchant', FontSize = 8, directionH = Slot.Direction, }, Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(E.db.sle.characterframeoptions.itemenchant.warningSize)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)

			-- Durability
			C.Toolkit.TextSetting(Slot, nil, { Tag = 'Durability', FontSize = 10, directionH = Slot.Direction, }, 'BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)

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

				Slot['Socket'..i].slotName = slotName
				Slot['Socket'..i].socketNumber = i

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
		end

		SlotIDList[Slot.ID] = slotName
		self[slotName] = Slot
	end

	-- GameTooltip for counting gem sockets and getting enchant effects
	self.ScanTT = CreateFrame('GameTooltip', 'SLE_CharacterArmory_ScanTT', nil, 'GameTooltipTemplate')
	self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')

	-- For resizing paper doll frame when it toggled.
	self.ChangeCharacterFrameWidth = CreateFrame('Frame')
	self.ChangeCharacterFrameWidth:SetScript('OnShow', function()
		if PaperDollFrame:IsVisible() then
			self:CharacterArmory_DataSetting()
		end
	end)

	self.Setup_CharacterArmory = nil
end

local needUpdate
function CA:CharacterArmory_DataSetting()
	if not self:IsVisible() then return end

	needUpdate = nil

	if not self.DurabilityUpdated then
		needUpdate = self:Update_Durability() or needUpdate
	end

	if self.GearUpdated ~= true then
		needUpdate = self:Update_Gear() or needUpdate
	end

	if not needUpdate then
		self:SetScript('OnUpdate', nil)
	end
end

function CA:Update_Durability()
	local Slot, r, g, b, CurrentDurability, MaxDurability

	for _, slotName in pairs(C.GearList) do
		Slot = self[slotName]
		CurrentDurability, MaxDurability = GetInventoryItemDurability(Slot.ID)

		if CurrentDurability and MaxDurability then
			if E.db.sle.characterframeoptions.itemdurability.show ~= false then
				r, g, b = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
				Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (CurrentDurability / MaxDurability) * 100)
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, -2)
			end
		elseif Slot.Durability then
			Slot.Durability:SetText('')
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 3)
		end
	end

	self.DurabilityUpdated = true
end

function CA:ClearTooltip(tooltip)
	local tooltipName = tooltip:GetName()

	tooltip:ClearLines()
	for i = 1, 10 do
		_G[tooltipName..'Texture'..i]:SetTexture(nil)
		_G[tooltipName..'Texture'..i]:ClearAllPoints()
		_G[tooltipName..'Texture'..i]:Point('TOPLEFT', tooltip)
	end
end

function CA:Update_Gear()
	--if not CA:IsVisible() then return end
	print("yep")
	-- Get Player Profession
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	self.PlayerProfession = {}

	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and C.ProfessionList[Prof1] then self.PlayerProfession[(C.ProfessionList[Prof1].Key)] = Prof1_Level end
	if Prof2 and C.ProfessionList[Prof2] then self.PlayerProfession[(C.ProfessionList[Prof2].Key)] = Prof2_Level end

	local ErrorDetected, needUpdate, needUpdateList
	local r, g, b
	local Slot, ItemLink, ItemData, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, UsableEffect, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount

	for _, slotName in pairs(self.GearUpdated or C.GearList) do
		if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
			Slot = self[slotName]
			ItemLink = GetInventoryItemLink('player', Slot.ID)
			--Slot:EnableMouse(true)

			do --<< Clear Setting >>--
				needUpdate, ErrorDetected, TrueItemLevel, IsEnchanted, UsableEffect, ItemUpgradeID, ItemTexture = nil, nil, nil, nil, nil, nil, nil

				Slot.ItemLevel:SetText(nil)
				Slot.ItemEnchant:SetText(nil)
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i].Texture:SetTexture(nil)
					Slot['Socket'..i].Socket.Link = nil
					Slot['Socket'..i].GemItemID = nil
					Slot['Socket'..i].GemType = nil
					Slot['Socket'..i]:Hide()
				end

				--Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
				Slot.EnchantWarning:Hide()
				Slot.EnchantWarning.Message = nil
				Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				Slot.SocketWarning:Hide()
				Slot.SocketWarning.Link = nil
				Slot.SocketWarning.Message = nil
			end

			if ItemLink then
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
					if (slotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
						((slotName == 'WristSlot' or slotName == 'HandsSlot') and self.PlayerProfession.BlackSmithing and self.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith

						GemCount_Enable = GemCount_Enable + 1
						Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
					end

					self:ClearTooltip(self.ScanTT)
					self.ScanTT:SetInventoryItem('player', Slot.ID)

					-- Apply current item's gem setting
					for i = 1, MAX_NUM_SOCKETS do
						ItemTexture = _G['SLE_CharacterArmory_ScanTTTexture'..i]:GetTexture()
						GemID = select(i, GetInventoryItemGems(Slot.ID))

						if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
							r, g, b = unpack(C.GemColor[Slot['Socket'..i].GemType])
							Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, .5)
							Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
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
									needUpdate = true
								end
							end
						end
					end

					--print(slotName..' : ', GemCount_Default, GemCount_Enable, GemCount_Now, GemCount)
					if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
						needUpdate = true
					end
				end

				_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(ItemLink)
				r, g, b = GetItemQualityColor(ItemRarity)

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
						CurrentLineText = gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT) --Intellect is to long for darth
						CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
						--God damn russian localization team!
						CurrentLineText = gsub(CurrentLineText, "к показателю уклонения", ITEM_MOD_DODGE_RATING_SHORT)
						CurrentLineText = gsub(CurrentLineText, "к показателю скорости", ITEM_MOD_HASTE_RATING_SHORT)
						CurrentLineText = gsub(CurrentLineText, "к показателю парирования", ITEM_MOD_PARRY_RATING_SHORT)
						CurrentLineText = gsub(CurrentLineText, "к показателю искусности", ITEM_MOD_MASTERY_RATING_SHORT)
						CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
						CurrentLineText = gsub(CurrentLineText, "небольшое увеличение скорости бега", "+к скорости бега")

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
							--if not C.ItemUpgrade[ItemUpgradeID] then
								--print('New Upgrade ID |cffceff00['..ItemUpgradeID..']|r : |cffceff00'..(TrueItemLevel - BasicItemLevel))
							--end

							ItemUpgradeID = TrueItemLevel - BasicItemLevel
						end
					end
					if E.db.sle.characterframeoptions.itemlevel.show ~= false then
						Slot.ItemLevel:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemlevel.font), E.db.sle.characterframeoptions.itemlevel.fontSize, E.db.sle.characterframeoptions.itemlevel.fontOutline)
						Slot.ItemLevel:SetText((Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(C.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
					end
				end

				--[[ Check Error
				if (not IsEnchanted and C.EnchantableSlots[slotName]) or ((slotName == 'Finger0Slot' or slotName == 'Finger1Slot') and CFO.PlayerProfession.Enchanting and CFO.PlayerProfession.Enchanting >= 550 and not IsEnchanted) then
					ErrorDetected = true
					if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
						Slot.EnchantWarning:Show()
						Slot.ItemEnchant:FontTemplate(LSM:Fetch("font", E.db.sle.characterframeoptions.itemenchant.font), E.db.sle.characterframeoptions.itemenchant.fontSize, E.db.sle.characterframeoptions.itemenchant.fontOutline)
						Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
					end
				elseif CFO.PlayerProfession.Engineering and ((slotName == 'BackSlot' and CFO.PlayerProfession.Engineering >= 380) or (slotName == 'HandsSlot' and CFO.PlayerProfession.Engineering >= 400) or (slotName == 'WaistSlot' and CFO.PlayerProfession.Engineering >= 380)) and not UsableEffect then
					ErrorDetected = true
					if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
					end
				elseif slotName == 'ShoulderSlot' and CFO.PlayerProfession.Inscription and C.ItemEnchant_Profession_Inscription and CFO.PlayerProfession.Inscription >= C.ItemEnchant_Profession_Inscription.NeedLevel and not C.ItemEnchant_Profession_Inscription[enchantID] then
					ErrorDetected = true
					if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
						Slot.ItemEnchant:SetDrawLayer('OVERLAY')
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
					end
				elseif slotName == 'WristSlot' and CFO.PlayerProfession.LeatherWorking and C.ItemEnchant_Profession_LeatherWorking and CFO.PlayerProfession.LeatherWorking >= C.ItemEnchant_Profession_LeatherWorking.NeedLevel and not C.ItemEnchant_Profession_LeatherWorking[enchantID] then
					ErrorDetected = true
					if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
						Slot.ItemEnchant:SetDrawLayer('OVERLAY')
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
					end
				elseif slotName == 'BackSlot' and CFO.PlayerProfession.Tailoring and C.ItemEnchant_Profession_Tailoring and CFO.PlayerProfession.Tailoring >= C.ItemEnchant_Profession_Tailoring.NeedLevel and not C.ItemEnchant_Profession_Tailoring[enchantID] then
					ErrorDetected = true
					if E.db.sle.characterframeoptions.itemenchant.showwarning ~= false then
						Slot.ItemEnchant:SetDrawLayer('OVERLAY')
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
					end
				end

				if GemTotal_1 > GemTotal_2 or GemTotal_1 > GemCount then
					ErrorDetected = true

					if E.db.sle.characterframeoptions.itemgem.showwarning ~= false then
						Slot.SocketWarning:Show()
					end

					if GemTotal_1 > GemTotal_2 then
						if slotName == 'WaistSlot' then
							if TrueItemLevel < 300 then
								_, Slot.SocketWarning.Link = GetItemInfo(41611)	
							elseif TrueItemLevel < 417 then
								_, Slot.SocketWarning.Link = GetItemInfo(55054)
							else
								_, Slot.SocketWarning.Link = GetItemInfo(90046)
							end
						elseif slotName == 'HandsSlot' then
							Slot.SocketWarning.Link = GetSpellLink(114112)
						elseif slotName == 'WristSlot' then
							Slot.SocketWarning.Link = GetSpellLink(113263)
						end

							if slotName == 'WaistSlot' then
							Slot.SocketWarning.Message = L['Missing Buckle']
						elseif slotName == 'WristSlot' or slotName == 'HandsSlot' then
							Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
						end
					else
						Slot.SocketWarning.Message = '|cffff5678'..(GemTotal_1 - GemCount)..'|r '..L['Empty Socket']
					end

					if GemTotal_1 ~= GemTotal_2 and slotName == 'WaistSlot' then
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
					end
				end]]
			end

			-- Change Gradation
			if ErrorDetected and E.db.sle.characterframeoptions.showerrorgradient then
				Slot.Gradation:SetVertexColor(1, 0, 0)
			else
				Slot.Gradation:SetVertexColor(unpack(E.db.sle.characterframeoptions.gradientColor))
			end

			if needUpdate then
				needUpdateList = needUpdateList or {}
				needUpdateList[#needUpdateList + 1] = slotName
			end
		end
	end

	self.AverageItemLevel:SetText(C.Toolkit.Color_Value(STAT_AVERAGE_ITEM_LEVEL)..': '..format('%.2f', select(2, GetAverageItemLevel())))

	if needUpdateList then
		self.GearUpdated = needUpdateList
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
	--[[CFO:RegisterEvent('SOCKET_INFO_SUCCESS', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('PLAYER_ENTERING_WORLD', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('EQUIPMENT_SWAP_FINISHED', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('UPDATE_INVENTORY_DURABILITY', 'ArmoryFrame_DataSetting')
	CFO:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE', 'ArmoryFrame_DataSetting')
	]]
	CA:RegisterEvent('SOCKET_INFO_SUCCESS')
	CA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	CA:RegisterEvent('UNIT_INVENTORY_CHANGED')
	CA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
	CA:RegisterEvent('TRANSMOGRIFY_UPDATE')
	CA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	CA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	CA:RegisterEvent('PLAYER_ENTERING_WORLD')

	-- For frame resizing
	CA.ChangeCharacterFrameWidth:SetParent(PaperDollFrame)
	if PaperDollFrame:IsVisible() then
		CA.ChangeCharacterFrameWidth:Show()
		CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 650 or 448)
	end
end

function CFO:Initialize()
	if not E.private.sle.characterframeoptions.enable then return end



	CA:StartArmoryFrame()
end