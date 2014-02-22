local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:NewModule('CharacterFrameOptions', 'AceEvent-3.0');

local f = CreateFrame('Frame', 'KnightArmory', PaperDollFrame)
local C = KnightFrame_Armory_Constants

local function GemSocket_OnClick(self, button)
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

local function GemSocket_OnRecieveDrag(self)
	self = self:GetParent()

	if CursorHasItem() then
		local CursorType, _, ItemLink = GetCursorInfo()

		if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
			SocketInventoryItem(GetInventorySlotInfo(self.slotName))
			ClickSocketButton(self.socketNumber)
		end
	end
end

local function CreateArmoryFrame(self)
	--<< Core >>--
	self:Point('TOPLEFT', CharacterFrameInset, 10, 20)
	self:Point('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -10, 5)

	--<< Background >>--
	self.BG = self:CreateTexture(nil, 'OVERLAY')
	self.BG:SetInside()
	self.BG:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Space.tga')

	--<< Change Model Frame's frameLevel >>--
	CharacterModelFrame:SetFrameLevel(self:GetFrameLevel() + 2)

	--<< Average Item Level >>--
	C.Toolkit.TextSetting(self, nil, { ['Tag'] = 'AverageItemLevel', ['FontSize'] = 12, }, 'BOTTOM', CharacterModelFrame, 'TOP', 0, 14)
	local function ValueColorUpdate()
		self.AverageItemLevel:SetText(C.Toolkit.Color_Value(L['Average'])..' : '..format('%.2f', select(2, GetAverageItemLevel())))
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
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Gradation.tga')

		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, .5, 0, .5)
		else
			Slot.Gradation:SetTexCoord(.5, 1, 0, .5)
		end

		if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
			-- Item Level
			C.Toolkit.TextSetting(Slot, nil, { ['Tag'] = 'ItemLevel', ['FontSize'] = 10, ['directionH'] = Slot.Direction, }, 'TOP'..Slot.Direction, _G['Character'..slotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)

			-- Enchantment Name
			C.Toolkit.TextSetting(Slot, nil, { ['Tag'] = 'ItemEnchant', ['FontSize'] = 8, ['directionH'] = Slot.Direction, }, Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(12)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small.tga')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', C.CommonScript.OnLeave)

			-- Durability
			C.Toolkit.TextSetting(Slot, nil, { ['Tag'] = 'Durability', ['FontSize'] = 10, ['directionH'] = Slot.Direction, }, 'BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)

			-- Gem Socket
			for i = 1, MAX_NUM_SOCKETS do
				Slot['Socket'..i] = CreateFrame('Frame', nil, Slot)
				Slot['Socket'..i]:Size(12)
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
				Slot['Socket'..i].Socket:SetScript('OnEnter', C.CommonScript.OnEnter)
				Slot['Socket'..i].Socket:SetScript('OnLeave', C.CommonScript.OnLeave)
				Slot['Socket'..i].Socket:SetScript('OnClick', GemSocket_OnClick)
				Slot['Socket'..i].Socket:SetScript('OnReceiveDrag', GemSocket_OnRecieveDrag)

				Slot['Socket'..i].Texture = Slot['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
				Slot['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
				Slot['Socket'..i].Texture:SetInside()
			end
			Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)

			Slot.SocketWarning = CreateFrame('Button', nil, Slot)
			Slot.SocketWarning:Size(12)
			Slot.SocketWarning:RegisterForClicks('AnyUp')
			Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
			Slot.SocketWarning.Texture:SetInside()
			Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\Warning-Small.tga')
			Slot.SocketWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
			Slot.SocketWarning:SetScript('OnLeave', C.CommonScript.OnLeave)
		end

		self[slotName] = Slot
	end

	-- GameTooltip for counting gem sockets and getting enchant effects
	self.ScanTTForEnchanting1 = CreateFrame('GameTooltip', 'KnightArmoryScanTT_E1', nil, 'GameTooltipTemplate')
	self.ScanTTForEnchanting1:SetOwner(UIParent, 'ANCHOR_NONE')

	-- GameTooltip for checking that texture in tooltip is socket texture
	self.ScanTTForEnchanting2 = CreateFrame('GameTooltip', 'KnightArmoryScanTT_E2', nil, 'GameTooltipTemplate')
	self.ScanTTForEnchanting2:SetOwner(UIParent, 'ANCHOR_NONE')

	-- For resizing paper doll frame when it toggled.
	self.ChangeCharacterFrameWidth = CreateFrame('Frame')
	self.ChangeCharacterFrameWidth:SetScript('OnShow', function() if PaperDollFrame:IsVisible() then PANEL_DEFAULT_WIDTH = 448 CFO:ArmoryFrame_DataSetting() end end)
	self.ChangeCharacterFrameWidth:SetScript('OnHide', function() PANEL_DEFAULT_WIDTH = 338 end)

	CreateArmoryFrame = nil
end

function CFO:ArmoryFrame_DataSetting()
	if not f:IsVisible() then return end

	-- Get Player Profession
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	CFO.PlayerProfession = {}

	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and C.ProfessionList[Prof1] then CFO.PlayerProfession[(C.ProfessionList[Prof1])] = Prof1_Level end
	if Prof2 and C.ProfessionList[Prof2] then CFO.PlayerProfession[(C.ProfessionList[Prof2])] = Prof2_Level end

	local ErrorDetected
	local r, g, b
	local Slot, ItemLink, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, UsableEffect, CurrentLineText, GemID, GemTotal_1, GemTotal_2, GemCount, CurrentDurability, MaxDurability
	local arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6

	for _, slotName in pairs(C.GearList) do
		if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
			Slot = f[slotName]

			do --<< Clear Setting >>--
				ErrorDetected, TrueItemLevel, IsEnchanted, UsableEffect, ItemRarity, ItemUpgradeID, ItemTexture = nil, nil, nil, nil, nil, nil, nil

				Slot.ItemLevel:SetText(nil)
				Slot.ItemEnchant:SetText(nil)
				Slot.Durability:SetText('')
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i].Texture:SetTexture(nil)
					Slot['Socket'..i].GemItemID = nil
					Slot['Socket'..i].GemType = nil
					Slot['Socket'..i]:Hide()
				end

				Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 3)
				Slot.EnchantWarning:Hide()
				Slot.EnchantWarning.Message = nil
				Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				Slot.SocketWarning:Hide()
				Slot.SocketWarning.Link = nil
				Slot.SocketWarning.Message = nil

				f.ScanTTForEnchanting1:ClearLines()
				f.ScanTTForEnchanting2:ClearLines()
				for i = 1, 10 do
					_G['KnightArmoryScanTT_E1Texture'..i]:SetTexture(nil)
					_G['KnightArmoryScanTT_E2Texture'..i]:SetTexture(nil)
				end
			end

			ItemLink = GetInventoryItemLink('player', Slot.ID)

			if ItemLink then
				do --<< Gem Parts >>--
					arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6 = strsplit(':', ItemLink)

					f.ScanTTForEnchanting1:SetInventoryItem('player', Slot.ID)
					f.ScanTTForEnchanting2:SetHyperlink(format('%s:%s:%d:0:0:0:0:%s:%s:%s:%s:%s', arg1, itemID, enchantID, arg2, arg3, arg4, arg5, arg6))

					GemTotal_1, GemTotal_2, GemCount = 0, 0, 0

					-- First, Counting default gem sockets
					for i = 1, MAX_NUM_SOCKETS do
						ItemTexture = _G['KnightArmoryScanTT_E2Texture'..i]:GetTexture()

						if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
							GemTotal_1 = GemTotal_1 + 1
							Slot['Socket'..GemTotal_1].GemType = strupper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
						end
					end

					-- Second, Check if slot's item enable to adding a socket
					if (slotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
						((slotName == 'WristSlot' or slotName == 'HandsSlot') and CFO.PlayerProfession.BlackSmithing and CFO.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith

						GemTotal_1 = GemTotal_1 + 1
						Slot['Socket'..GemTotal_1].GemType = 'PRISMATIC'
					end

					-- Apply current item's gem setting
					for i = 1, MAX_NUM_SOCKETS do
						ItemTexture = _G['KnightArmoryScanTT_E1Texture'..i]:GetTexture()
						GemID = select(i, GetInventoryItemGems(Slot.ID))
						
						if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
							r, g, b = unpack(C.GemColor[Slot['Socket'..i].GemType])
							Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, .5)
							Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
						else
							Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
							Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
						end

						if ItemTexture then
							Slot['Socket'..i]:Show()
							GemTotal_2 = GemTotal_2 + 1
							Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)

							if GemID then
								GemCount = GemCount + 1
								Slot['Socket'..i].Texture:SetTexture(ItemTexture)
								Slot['Socket'..i].GemItemID = GemID
							end
						end
					end
				end

				_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(ItemLink)
				r, g, b = GetItemQualityColor(ItemRarity)

				ItemUpgradeID = ItemLink:match(':(%d+)\124h%[')

				--<< Enchant Parts >>--
				for i = 1, f.ScanTTForEnchanting1:NumLines() do
					CurrentLineText = _G['KnightArmoryScanTT_E1TextLeft'..i]:GetText()

					if CurrentLineText:find(C.ItemLevelKey) then
						TrueItemLevel = tonumber(CurrentLineText:match(C.ItemLevelKey))
					elseif CurrentLineText:find(C.EnchantKey) then
						CurrentLineText = CurrentLineText:match(C.EnchantKey) -- Get enchant string
						CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
						CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space

						Slot.ItemEnchant:SetText('|cffceff00'..CurrentLineText)

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
							if not C.ItemUpgrade[ItemUpgradeID] then
								print('New Upgrade ID |cffceff00['..ItemUpgradeID..']|r : |cffceff00'..(TrueItemLevel - BasicItemLevel))
							end

							ItemUpgradeID = TrueItemLevel - BasicItemLevel
						end
					end

					Slot.ItemLevel:SetText((Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(C.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
				end

				--<< Durability Parts >>--
				CurrentDurability, MaxDurability = GetInventoryItemDurability(Slot.ID)
				if CurrentDurability and MaxDurability then
					r, g, b = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
					Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (CurrentDurability / MaxDurability) * 100)
					Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, -2)
				end

				-- Check Error
				if E.db.sle.KnightFrame_Armory.NoticeMissing ~= false then
					if (not IsEnchanted and C.EnchantableSlots[slotName]) or ((slotName == 'Finger0Slot' or slotName == 'Finger1Slot') and CFO.PlayerProfession.Enchanting and CFO.PlayerProfession.Enchanting >= 550 and not IsEnchanted) then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
					elseif CFO.PlayerProfession.Engineering and ((slotName == 'BackSlot' and CFO.PlayerProfession.Engineering >= 380) or (slotName == 'HandsSlot' and CFO.PlayerProfession.Engineering >= 400) or (slotName == 'WaistSlot' and CFO.PlayerProfession.Engineering >= 380)) and not UsableEffect then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
					elseif slotName == 'ShoulderSlot' and CFO.PlayerProfession.Inscription and C.ItemEnchant_Profession_Inscription and CFO.PlayerProfession.Inscription >= C.ItemEnchant_Profession_Inscription.NeedLevel and not C.ItemEnchant_Profession_Inscription[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
					elseif slotName == 'WristSlot' and CFO.PlayerProfession.LeatherWorking and C.ItemEnchant_Profession_LeatherWorking and CFO.PlayerProfession.LeatherWorking >= C.ItemEnchant_Profession_LeatherWorking.NeedLevel and not C.ItemEnchant_Profession_LeatherWorking[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
					elseif slotName == 'BackSlot' and CFO.PlayerProfession.Tailoring and C.ItemEnchant_Profession_Tailoring and CFO.PlayerProfession.Tailoring >= C.ItemEnchant_Profession_Tailoring.NeedLevel and not C.ItemEnchant_Profession_Tailoring[enchantID] then
						ErrorDetected = true
						Slot.EnchantWarning:Show()
						Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
					end

					if GemTotal_1 > GemTotal_2 or GemTotal_1 > GemCount then
						ErrorDetected = true

						Slot.SocketWarning:Show()

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
					end
				end
			end

			-- Change Gradation
			if ErrorDetected and E.db.sle.KnightFrame_Armory.NoticeMissing ~= false then
				if Slot.Direction == 'LEFT' then
					Slot.Gradation:SetTexCoord(0, .5, .5, 1)
				else
					Slot.Gradation:SetTexCoord(.5, 1, .5, 1)
				end
			else
				if Slot.Direction == 'LEFT' then
					Slot.Gradation:SetTexCoord(0, .5, 0, .5)
				else
					Slot.Gradation:SetTexCoord(.5, 1, 0, .5)
				end
			end
		end
	end

	f.AverageItemLevel:SetText(C.Toolkit.Color_Value(L['Average'])..' : '..format('%.2f', select(2, GetAverageItemLevel())))
end

function CFO:StartArmoryFrame()
	--if E.db.sle.KnightFrame_Armory.Enable then
		-- Setting frame
		CHARACTERFRAME_EXPANDED_WIDTH = 650
		CharacterFrame:SetHeight(444)
		CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
		CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', 0, 1)

		-- Move right equipment slots
		CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInsetRight, 'TOPLEFT', -4, -2)

		-- Move bottom equipment slots
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)

		-- Model Frame
		CharacterModelFrame:Size(341, 302)
		CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -90)
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()

		if CreateArmoryFrame then
			CreateArmoryFrame(KnightArmory)
		end
		CFO:ArmoryFrame_DataSetting()

		-- Run ArmoryMode
		CFO:RegisterEvent('SOCKET_INFO_SUCCESS', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('PLAYER_ENTERING_WORLD', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('EQUIPMENT_SWAP_FINISHED', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('UPDATE_INVENTORY_DURABILITY', 'ArmoryFrame_DataSetting')
		CFO:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE', 'ArmoryFrame_DataSetting')

		-- For frame resizing
		f.ChangeCharacterFrameWidth:SetParent(PaperDollFrame)
		if PaperDollFrame:IsVisible() then
			f.ChangeCharacterFrameWidth:Show()
			CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 650 or 448)
		end

		--KF_ArmoryMode.CheckButton:Show()
		KF_ArmoryMode_NoticeMissing:EnableMouse(true)
		KF_ArmoryMode_NoticeMissing.text:SetTextColor(1, 1, 1)
		KF_ArmoryMode_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
	--elseif not CreateArmoryFrame then
		-- Setting frame to default
		--PANEL_DEFAULT_WIDTH = 338
		--CHARACTERFRAME_EXPANDED_WIDTH = 540
		--CharacterFrame:SetHeight(424)
		--CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 1, 0)
		--CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInset, 'BOTTOMRIGHT', -2, -1)

		-- Move rightside equipment slots to default position
		--CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInset, 'TOPRIGHT', -4, -2)

		-- Move bottom equipment slots to default position
		--CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 130, 16)

		-- Model Frame
	--[[
		CharacterModelFrame:Size(231, 320)
		CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -66)
		CharacterModelFrame.BackgroundTopLeft:Show()
		CharacterModelFrame.BackgroundTopRight:Show()
		CharacterModelFrame.BackgroundBotLeft:Show()
		CharacterModelFrame.BackgroundBotRight:Show()
	]]
		-- Turn off ArmoryFrame
	--[[
		f:Hide()
		CFO:UnregisterEvent('SOCKET_INFO_SUCCESS', 'ArmoryFrame_DataSetting')
		CFO:UnregisterEvent('PLAYER_ENTERING_WORLD', 'ArmoryFrame_DataSetting')
		CFO:UnregisterEvent('UNIT_INVENTORY_CHANGED', 'ArmoryFrame_DataSetting')
		CFO:UnregisterEvent('EQUIPMENT_SWAP_FINISHED', 'ArmoryFrame_DataSetting')
		CFO:UnregisterEvent('UPDATE_INVENTORY_DURABILITY', 'ArmoryFrame_DataSetting')
		CFO:UnregisterEvent('ITEM_UPGRADE_MASTER_UPDATE', 'ArmoryFrame_DataSetting')
	]]
		-- Return to default size when PaperDollFrame is open
	--[[
		f.ChangeCharacterFrameWidth:SetParent(nil)
		f.ChangeCharacterFrameWidth:Hide()
		if PaperDollFrame:IsVisible() then
			CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 540 or 338)
		end
	]]
		--KF_ArmoryMode.CheckButton:Hide()
	--[[
		KF_ArmoryMode_NoticeMissing:EnableMouse(false)
		KF_ArmoryMode_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_ArmoryMode_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
	end
	]]
end

function CFO:Initialize()
	if not E.private.sle.characterframeoptions.enable then return end
	-- Create Config button in Character Frame : Enable
	--C.Toolkit.CreateWidget_CheckButton('KF_ArmoryMode', L['Armory Mode'], 20, { ['FontSize'] = 10, ['directionH'] = 'LEFT', })
	--KF_ArmoryMode:SetParent(PaperDollFrame)
	--KF_ArmoryMode:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 1)
	--KF_ArmoryMode:SetFrameStrata(PaperDollFrame:GetFrameStrata())
	--KF_ArmoryMode:Point('TOPLEFT', PaperDollFrame, 15, -20)
	--KF_ArmoryMode:SetScript('OnClick', function(self)
	--	E.db.sle.KnightFrame_Armory.Enable = not E.db.sle.KnightFrame_Armory.Enable

	--	CFO:ToggleArmoryFrame()
	--end)

	-- Create Config button in Character Frame : NoticeMissing
	C.Toolkit.CreateWidget_CheckButton('KF_ArmoryMode_NoticeMissing', L['Notice Missing'], 20, { ['FontSize'] = 10, ['directionH'] = 'LEFT', })

	if E.db.sle.KnightFrame_Armory.NoticeMissing == false then
		KF_ArmoryMode_NoticeMissing.CheckButton:Hide()
	end

	KF_ArmoryMode_NoticeMissing:SetParent(PaperDollFrame)
	KF_ArmoryMode_NoticeMissing:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 1)
	KF_ArmoryMode_NoticeMissing:SetFrameStrata(PaperDollFrame:GetFrameStrata())
	KF_ArmoryMode_NoticeMissing:Point('TOPLEFT', PaperDollFrame, 15, -20)
	KF_ArmoryMode_NoticeMissing:SetScript('OnClick', function(self)
		if E.db.sle.KnightFrame_Armory.NoticeMissing == true then
			E.db.sle.KnightFrame_Armory.NoticeMissing = false
			KF_ArmoryMode_NoticeMissing.CheckButton:Hide()
		else
			E.db.sle.KnightFrame_Armory.NoticeMissing = true
			KF_ArmoryMode_NoticeMissing.CheckButton:Show()
		end

		CFO:ArmoryFrame_DataSetting()
	end)

	if E.db.sle.KnightFrame_Armory.Enable == false then
		--KF_ArmoryMode.CheckButton:Hide()
		KF_ArmoryMode_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_ArmoryMode_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
	end
	KF_ArmoryMode_NoticeMissing:EnableMouse(E.db.sle.KnightFrame_Armory.Enable)

	--local function ValueColorUpdate()
		--KF_ArmoryMode.text:SetTextColor(unpack(E.media.rgbvaluecolor))
	--end
	--E['valueColorUpdateFuncs'][ValueColorUpdate] = true

	CFO:StartArmoryFrame()
end

E:RegisterModule(CFO:GetName())