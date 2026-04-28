local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local S = E.Skins

local _G = _G
local CreateFrame = CreateFrame
local GetLocale = GetLocale
local GetMoney = GetMoney
local GetItemInfo = GetItemInfo
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemInfo = GetMerchantItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemID = GetMerchantItemID
local GetMerchantItemCostInfo = GetMerchantItemCostInfo
local GetMerchantItemCostItem = GetMerchantItemCostItem
local GetCoinTextureString = GetCoinTextureString
local CanAffordMerchantItem = CanAffordMerchantItem
local HandleModifiedItemClick = HandleModifiedItemClick
local BuyMerchantItem = BuyMerchantItem
local MerchantFrame_ConfirmExtendedItemCost = MerchantFrame_ConfirmExtendedItemCost
local MerchantItemButton_OnClick = MerchantItemButton_OnClick
local MerchantItemButton_OnEnter = MerchantItemButton_OnEnter
local MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll
local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local FauxScrollFrame_Update = FauxScrollFrame_Update
local IsModifiedClick = IsModifiedClick
local ResetCursor = ResetCursor
local ShowInspectCursor = ShowInspectCursor
local tinsert = tinsert
local unpack = unpack
local wipe = wipe

local C_MerchantFrame = C_MerchantFrame
local C_Item = C_Item
local C_Heirloom = C_Heirloom

local SEARCH = SEARCH
local MAX_ITEM_COST = MAX_ITEM_COST
local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local MISCELLANEOUS = MISCELLANEOUS
local MOUNT = MOUNT

local ITEM_ROWS = 10
local ROW_HEIGHT = 29.4

local buttons = {}
local searchText = ""
local merchantUpdating = false
local hiddenTooltipName = "SLE_Merchant_HiddenTooltip"

local locale = {
	enUS = {
		REQUIRES_LEVEL = "Requires Level (%d+)",
		LEVEL = "Level %d",
		REQUIRES_REPUTATION = "Requires .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "Requires (.+) %- .+",
		REQUIRES_SKILL = "Requires (.+) %((%d+)%)",
		REQUIRES = "Requires (.+)",
	},
	deDE = {
		REQUIRES_LEVEL = "Benötigt Stufe (%d+)",
		LEVEL = "Stufe %d",
		REQUIRES_REPUTATION = "Benötigt .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "Benötigt (.+) %- .+",
		REQUIRES_SKILL = "Benötigt (.+) %((%d+)%)",
		REQUIRES = "Benötigt (.+)",
	},
	frFR = {
		REQUIRES_LEVEL = "Niveau (%d+) requis",
		LEVEL = "Niveau %d",
		REQUIRES_REPUTATION = "Requiert .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "Requiert (.+) %- .+",
		REQUIRES_SKILL = "(.+) %((%d+)%) requis",
		REQUIRES = "Requiert (.+)",
	},
	esES = {
		REQUIRES_LEVEL = "Necesitas ser de nivel (%d+)",
		LEVEL = "Nivel %d",
		REQUIRES_REPUTATION = "Requiere .+: (.+)",
		REQUIRES_REPUTATION_NAME = "Requiere (.+): .+",
		REQUIRES_SKILL = "Requiere (.+) %((%d+)%)",
		REQUIRES = "Requiere (.+)",
	},
	esMX = {
		REQUIRES_LEVEL = "Necesitas ser de nivel (%d+)",
		LEVEL = "Nivel %d",
		REQUIRES_REPUTATION = "Requiere .+: (.+)",
		REQUIRES_REPUTATION_NAME = "Requiere (.+): .+",
		REQUIRES_SKILL = "Requiere (.+) %((%d+)%)",
		REQUIRES = "Requiere (.+)",
	},
	koKR = {
		REQUIRES_LEVEL = "최소 레벨 (%d+)",
		LEVEL = "레벨 %d",
		REQUIRES_REPUTATION = "필수 평판 .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "필수 평판 (.+) %- .+",
		REQUIRES_SKILL = "필수 스킬 (.+) %((%d+)%)",
		REQUIRES = "필수 (.+)",
	},
	ruRU = {
		REQUIRES_LEVEL = "Требуется уровень: (%d+)",
		LEVEL = "Уровень %d",
		REQUIRES_REPUTATION = "Требуется: (.+) со стороны (.+)",
		REQUIRES_SKILL = "Требуется: (.+) %((%d+)%)",
		REQUIRES = "Требуется (.+)",
	},
	zhCN = {
		REQUIRES_LEVEL = "需要等级 (%d+)",
		LEVEL = "等级 %d",
		REQUIRES_REPUTATION = "需要 .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "需要 (.+) %- .+",
		REQUIRES_SKILL = "需要(.+)%((%d+)%)",
		REQUIRES = "需要(.+)",
	},
	zhTW = {
		REQUIRES_LEVEL = "需要等级 (%d+)",
		LEVEL = "等级 %d",
		REQUIRES_REPUTATION = "需要 .+ %- (.+)",
		REQUIRES_REPUTATION_NAME = "需要 (.+) %- .+",
		REQUIRES_SKILL = "需要(.+)%((%d+)%)",
		REQUIRES = "需要(.+)",
	},
}

local localeStrings = locale[GetLocale()] or {}
local REQUIRES_LEVEL = localeStrings.REQUIRES_LEVEL or ""
local LEVEL = localeStrings.LEVEL or ""
local REQUIRES_REPUTATION = localeStrings.REQUIRES_REPUTATION or ""
local REQUIRES_REPUTATION_NAME = localeStrings.REQUIRES_REPUTATION_NAME or ""
local REQUIRES_SKILL = localeStrings.REQUIRES_SKILL or ""
local REQUIRES = localeStrings.REQUIRES or ""
local SKILL = "%1$s (%2$d)"
local RECIPE = (C_Item and C_Item.GetItemClassInfo and Enum and Enum.ItemClass and C_Item.GetItemClassInfo(Enum.ItemClass.Recipe)) or _G["AUCTION_CATEGORY_RECIPES"] or "Recipe"

local function GetItemInfoSafe(linkOrItemID)
	if C_Item and C_Item.GetItemInfo then
		return C_Item.GetItemInfo(linkOrItemID)
	end
	return GetItemInfo(linkOrItemID)
end

local function GetQualityColor(quality)
	local color = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
	if color then
		return color.r or 1, color.g or 1, color.b or 1
	end
	if _G.GetItemQualityColor then
		return _G.GetItemQualityColor(quality)
	end
	return 1, 1, 1
end

local function GetMerchantInfoModern(index)
	if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
		local info = C_MerchantFrame.GetItemInfo(index)
		if info then
			return {
				name = info.name,
				texture = info.iconFileID or info.texture,
				price = info.price or 0,
				quantity = info.stackCount or info.quantity or 1,
				numAvailable = info.numAvailable or -1,
				isPurchasable = info.isPurchasable,
				isUsable = info.isUsable,
				extendedCost = info.hasExtendedCost or info.extendedCost,
				itemID = info.itemID,
				link = (C_MerchantFrame.GetItemLink and C_MerchantFrame.GetItemLink(index)) or nil,
			}
		end
	end
end

local function GetMerchantInfoClassic(index)
	if not GetMerchantItemInfo then
		return nil
	end

	local name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost = GetMerchantItemInfo(index)
	if not name and not texture and not price then
		return nil
	end

	return {
		name = name,
		texture = texture,
		price = price or 0,
		quantity = quantity or 1,
		numAvailable = numAvailable or -1,
		isPurchasable = isPurchasable,
		isUsable = isUsable,
		extendedCost = extendedCost,
		itemID = GetMerchantItemID and GetMerchantItemID(index) or nil,
		link = GetMerchantItemLink and GetMerchantItemLink(index) or nil,
	}
end

local function GetMerchantItemData(index)
	return GetMerchantInfoModern(index) or GetMerchantInfoClassic(index)
end

local function GetMerchantCostItemData(index, costIndex)
	if GetMerchantItemCostItem then
		local texture, value, link = GetMerchantItemCostItem(index, costIndex)
		if texture then
			return texture, value, link
		end
	end

	if C_MerchantFrame and C_MerchantFrame.GetItemCostInfo then
		local info = C_MerchantFrame.GetItemCostInfo(index, costIndex)
		if info then
			return info.iconFileID or info.texture, info.amount or info.cost, info.itemLink or info.link
		end
	end
end

local function GetMerchantCostCount(index)
	if GetMerchantItemCostInfo then
		return GetMerchantItemCostInfo(index) or 0
	end

	if C_MerchantFrame and C_MerchantFrame.GetNumItemCosts then
		return C_MerchantFrame.GetNumItemCosts(index) or 0
	end

	return 0
end

local function CanAffordMerchantItemSafe(index)
	if CanAffordMerchantItem then
		return CanAffordMerchantItem(index)
	end

	if C_MerchantFrame and C_MerchantFrame.CanAffordItem then
		return C_MerchantFrame.CanAffordItem(index)
	end

	return true
end

local function SetButtonHighlight(button, r, g, b, show)
	button.highlight:SetVertexColor(r, g, b, 0.5)
	if show then
		button.highlight:Show()
	else
		button.highlight:Hide()
	end
end

local function AppendError(buffer, text)
	if not text or text == "" then
		return buffer
	end
	if buffer ~= "" then
		return buffer .. ", " .. text
	end
	return text
end

local function GetMerchantRequirementText(link, itemType, itemSubType)
	if not link then
		return nil
	end

	local tooltip = _G[hiddenTooltipName]
	if not tooltip then
		return nil
	end

	local isRecipe = itemType == RECIPE
	local isMount = itemType == MISCELLANEOUS and itemSubType == MOUNT
	local errorText = ""

	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:SetHyperlink(link)

	local totalLines = tooltip:NumLines()
	for lineIndex = 2, totalLines do
		if (isRecipe and (lineIndex <= 5 or lineIndex >= totalLines - 3)) or isMount or not isRecipe then
			local leftLine = _G[hiddenTooltipName .. "TextLeft" .. lineIndex]
			if leftLine then
				local r, g, b = leftLine:GetTextColor()
				local text = leftLine:GetText()
				if text and r >= 0.9 and g <= 0.2 and b <= 0.2 and text ~= RETRIEVING_ITEM_INFO then
					local level = REQUIRES_LEVEL ~= "" and text:match(REQUIRES_LEVEL) or nil
					local reputation, factionName = REQUIRES_REPUTATION ~= "" and string.match(text, REQUIRES_REPUTATION) or nil, nil
					if REQUIRES_REPUTATION ~= "" then
						reputation, factionName = string.match(text, REQUIRES_REPUTATION)
					end
					local skill, skillLevel = REQUIRES_SKILL ~= "" and text:match(REQUIRES_SKILL) or nil, nil
					if REQUIRES_SKILL ~= "" then
						skill, skillLevel = text:match(REQUIRES_SKILL)
					end
					local requires = REQUIRES ~= "" and text:match(REQUIRES) or nil
					local known = text == ITEM_SPELL_KNOWN

					if level then
						errorText = AppendError(errorText, LEVEL:format(level))
					end
					if reputation then
						if not factionName and REQUIRES_REPUTATION_NAME ~= "" then
							factionName = text:match(REQUIRES_REPUTATION_NAME)
						end
						errorText = AppendError(errorText, factionName and (reputation .. " (" .. factionName .. ")") or reputation)
					end
					if skill and skillLevel then
						errorText = AppendError(errorText, SKILL:format(skill, skillLevel))
					end
					if not level and not reputation and not skill and requires then
						errorText = AppendError(errorText, requires)
					end
					if known then
						errorText = AppendError(errorText, ITEM_SPELL_KNOWN)
					end
					if not level and not reputation and not skill and not requires and not known then
						errorText = AppendError(errorText, text)
					end
				end
			end

			local rightLine = _G[hiddenTooltipName .. "TextRight" .. lineIndex]
			if rightLine then
				local r, g, b = rightLine:GetTextColor()
				local text = rightLine:GetText()
				if text and r >= 0.9 and g <= 0.2 and b <= 0.2 then
					errorText = AppendError(errorText, text)
				end
			end
		end
	end

	return errorText ~= "" and errorText or nil
end

local function AltCurrency_OnClick(self)
	if self.itemLink then
		HandleModifiedItemClick(self.itemLink)
	end
end

local function AltCurrency_OnEnter(self)
	local parent = self:GetParent()
	if parent.isShown and not parent.hover then
		parent.oldr, parent.oldg, parent.oldb, parent.olda = parent.highlight:GetVertexColor()
		parent.highlight:SetVertexColor(parent.r or 1, parent.g or 1, parent.b or 1, parent.olda)
		parent.hover = true
	else
		parent.highlight:Show()
	end

	local tooltip = _G.GameTooltip
	tooltip:SetOwner(self, "ANCHOR_RIGHT")
	if self.itemLink then
		tooltip:SetHyperlink(self.itemLink)
	end

	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function AltCurrency_OnLeave(self)
	local parent = self:GetParent()
	if parent.isShown then
		parent.highlight:SetVertexColor(parent.oldr or 1, parent.oldg or 1, parent.oldb or 1, parent.olda or 1)
		parent.hover = nil
	else
		parent.highlight:Hide()
	end
	_G.GameTooltip:Hide()
	ResetCursor()
end

local function Row_OnClick(self, button)
	if IsModifiedClick() then
		MerchantItemButton_OnModifiedClick(self, button)
	else
		MerchantItemButton_OnClick(self, button)
	end
end

local function Row_OnEnter(self)
	if self.isShown and not self.hover then
		self.oldr, self.oldg, self.oldb, self.olda = self.highlight:GetVertexColor()
		self.highlight:SetVertexColor(self.r or 1, self.g or 1, self.b or 1, self.olda)
		self.hover = true
	else
		self.highlight:Show()
	end
	MerchantItemButton_OnEnter(self)
end

local function Row_OnLeave(self)
	if self.isShown then
		if self.oldr then
			self.highlight:SetVertexColor(self.oldr, self.oldg, self.oldb, self.olda)
		end
		self.hover = nil
	else
		self.highlight:Hide()
	end
	_G.GameTooltip:Hide()
	ResetCursor()
	_G.MerchantFrame.itemHover = nil
end

local function Row_OnHide()
	merchantUpdating = false
end

local function UpdateAltCurrencyFrame(frame, texture, cost, canAfford)
	if canAfford == false then
		frame.count:SetTextColor(1, 0, 0)
	else
		frame.count:SetTextColor(1, 1, 1)
	end
	frame.count:SetText(cost)
	frame.icon:SetTexture(texture)
	frame.icon:SetTexCoord(unpack(E.TexCoords))
	frame.icon:SetSize(17, 17)
	frame.count:SetPoint("RIGHT", frame.icon, "LEFT", -2, 0)
	frame:SetSize(frame.count:GetWidth() + 21, frame.count:GetHeight() + 4)
end

local function UpdateAltCost(button, merchantIndex, canAfford)
	local frames = {}
	local costCount = GetMerchantCostCount(merchantIndex)

	if costCount > 0 then
		for costIndex = 1, MAX_ITEM_COST do
			local itemButton = button.item[costIndex]
			local texture, amount, link = GetMerchantCostItemData(merchantIndex, costIndex)
			itemButton.index = merchantIndex
			itemButton.item = costIndex
			itemButton.itemLink = link

			if texture then
				UpdateAltCurrencyFrame(itemButton, texture, amount, canAfford)
				itemButton:Show()
				tinsert(frames, itemButton)
			else
				itemButton:Hide()
			end
		end
	else
		for costIndex = 1, MAX_ITEM_COST do
			button.item[costIndex]:Hide()
		end
	end

	tinsert(frames, button.money)

	local lastFrame
	for frameIndex, frame in ipairs(frames) do
		frame:ClearAllPoints()
		if frameIndex == 1 then
			frame:SetPoint("RIGHT", -2, 6)
		else
			frame:SetPoint("RIGHT", lastFrame, "LEFT", -2, 0)
		end
		lastFrame = frame
	end
end

local function UpdateMerchantList()
	local frame = _G.SLE_ListMerchantFrame
	if not frame or not frame.scrollframe then
		return
	end

	local totalItems = GetMerchantNumItems()
	FauxScrollFrame_Update(frame.scrollframe, totalItems, ITEM_ROWS, ROW_HEIGHT, nil, nil, nil, nil, nil, nil, 1)

	for rowIndex = 1, ITEM_ROWS do
		local merchantIndex = rowIndex + FauxScrollFrame_GetOffset(frame.scrollframe)
		local button = buttons[rowIndex]
		button.hover = nil

		if merchantIndex <= totalItems then
			local merchantItem = GetMerchantItemData(merchantIndex)
			if merchantItem then
				local name = merchantItem.name
				local texture = merchantItem.texture
				local price = merchantItem.price or 0
				local quantity = merchantItem.quantity or 1
				local numAvailable = merchantItem.numAvailable or -1
				local isPurchasable = merchantItem.isPurchasable
				local isUsable = merchantItem.isUsable
				local extendedCost = merchantItem.extendedCost
				local link = merchantItem.link
				local itemID = merchantItem.itemID
				local canAfford = CanAffordMerchantItemSafe(merchantIndex)

				local subtext = ""
				local itemRarity, itemType, itemSubType, equipSlot, itemLevel
				local r, g, b = 0.5, 0.5, 0.5

				if link or itemID then
					local _, _, quality, iLevel, _, className, subClassName, _, slotName = GetItemInfoSafe(link or itemID)
					itemRarity = quality
					itemLevel = iLevel
					itemType = className
					itemSubType = subClassName
					equipSlot = slotName
					r, g, b = GetQualityColor(itemRarity)
					button.itemname:SetTextColor(r, g, b)

					if itemSubType then
						subtext = itemSubType:gsub("%(OBSOLETE%)", "")
						if equipSlot and equipSlot ~= "" and equipSlot ~= "INVTYPE_TABARD" then
							subtext = (_G[equipSlot] or equipSlot) .. " (" .. (itemLevel or "?") .. ")"
						elseif equipSlot == "INVTYPE_TABARD" then
							subtext = _G[equipSlot] or equipSlot
						end
					end
				else
					button.itemname:SetTextColor(1, 1, 1)
				end

				button.iteminfo:SetText(subtext)
				button.itemname:SetText((numAvailable >= 0 and "|cffffffff[" .. numAvailable .. "]|r " or "") .. (quantity > 1 and "|cffffffff" .. quantity .. "x|r " or "") .. (name or "|cffff0000" .. RETRIEVING_ITEM_INFO))
				button.icon:SetTexture(texture)
				button.icon:SetTexCoord(unpack(E.TexCoords))

				local qualityDesc = itemRarity and _G["ITEM_QUALITY" .. tostring(itemRarity) .. "_DESC"]
				local alpha = 0.3
				if searchText == "" or searchText == SEARCH:lower() or (name and name:lower():match(searchText)) or (qualityDesc and qualityDesc:lower():match(searchText)) or (itemType and itemType:lower():match(searchText)) or (itemSubType and itemSubType:lower():match(searchText)) then
					alpha = 1
				end
				button:SetAlpha(alpha)

				UpdateAltCost(button, merchantIndex, canAfford)
				if extendedCost and price <= 0 then
					button.price = nil
					button.extendedCost = true
					button.money:SetText("")
				else
					button.price = price
					button.extendedCost = extendedCost or nil
					button.money:SetText(GetCoinTextureString(price))
				end

				if GetMoney() >= price then
					button.money:SetTextColor(1, 1, 1)
				else
					button.money:SetTextColor(1, 0, 0)
				end

				local isHeirloom = itemID and C_Heirloom and C_Heirloom.IsItemHeirloom and C_Heirloom.IsItemHeirloom(itemID)
				local isKnownHeirloom = isHeirloom and C_Heirloom and C_Heirloom.PlayerHasHeirloom and C_Heirloom.PlayerHasHeirloom(itemID)
				local tintRed = not isPurchasable or (not isUsable and not isHeirloom)
				local errorText = GetMerchantRequirementText(link, itemType, itemSubType)

				if numAvailable == 0 or isKnownHeirloom then
					SetButtonHighlight(button, 0.5, 0.5, 0.5, true)
					button.isShown = true
				elseif tintRed or errorText then
					SetButtonHighlight(button, 1, 0.2, 0.2, true)
					button.isShown = true
					if errorText then
						button.iteminfo:SetText("|cffd00000" .. subtext .. " - " .. errorText .. "|r")
					end
				else
					SetButtonHighlight(button, r, g, b, false)
					button.isShown = nil
				end

				button.r = r
				button.g = g
				button.b = b
				button.link = link
				button.hasItem = true
				button.texture = texture
				button:SetID(merchantIndex)
				button:Show()
			else
				button.hasItem = nil
				button:Hide()
			end
		else
			button.hasItem = nil
			button:Hide()
		end

		if button.hasStackSplit == 1 then
			_G.StackSplitFrame:Hide()
		end
	end
end

local function Search_OnTextChanged(self)
	searchText = self:GetText():trim():lower()
	UpdateMerchantList()
end

local function Search_OnShow(self)
	self:SetText(SEARCH)
	searchText = ""
end

local function Search_OnEnterPressed(self)
	self:ClearFocus()
end

local function Search_OnEscapePressed(self)
	self:ClearFocus()
	self:SetText(SEARCH)
	searchText = ""
end

local function Search_OnEditFocusLost(self)
	self:HighlightText(0, 0)
	if self:GetText():trim() == "" then
		self:SetText(SEARCH)
		searchText = ""
	end
end

local function Search_OnEditFocusGained(self)
	self:HighlightText()
	if self:GetText():trim():lower() == SEARCH:lower() then
		self:SetText("")
	end
end

local function SplitStack(button, split)
	if button.extendedCost then
		MerchantFrame_ConfirmExtendedItemCost(button, split)
	elseif split > 0 then
		BuyMerchantItem(button:GetID(), split)
	end
end

local function OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, UpdateMerchantList)
end

local function UpdateListVisibility()
	if _G.MerchantFrame.selectedTab == 1 then
		for index = 1, 12 do
			_G["MerchantItem" .. index]:Hide()
		end
		_G.SLE_ListMerchantFrame:Show()
		UpdateMerchantList()
	else
		_G.SLE_ListMerchantFrame:Hide()
		for index = 1, 12 do
			_G["MerchantItem" .. index]:Show()
		end
		if _G.StackSplitFrame:IsShown() then
			_G.StackSplitFrame:Hide()
		end
	end
end

local function CreateAltCostButton(parent, index)
	local button = CreateFrame("Button", "$parentItem" .. index, parent)
	button:SetSize(17, 17)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnClick", AltCurrency_OnClick)
	button:SetScript("OnEnter", AltCurrency_OnEnter)
	button:SetScript("OnLeave", AltCurrency_OnLeave)
	button.hasItem = true
	button.UpdateTooltip = AltCurrency_OnEnter

	local icon = button:CreateTexture("$parentIcon", "BORDER")
	button.icon = icon
	icon:SetSize(17, 17)
	icon:SetPoint("RIGHT")

	local count = button:CreateFontString("$parentCount", "ARTWORK", "GameFontHighlight")
	button.count = count
	count:SetPoint("RIGHT", icon, "LEFT", -2, 0)

	return button
end

local function CreateListRow(parent, index)
	local button = CreateFrame("Button", "SLE_ListMerchantFrame_Button" .. index, parent)
	button:SetSize(parent:GetWidth(), ROW_HEIGHT)
	if index == 1 then
		button:SetPoint("TOPLEFT", 0, -1)
	else
		button:SetPoint("TOP", buttons[index - 1], "BOTTOM")
	end
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:RegisterForDrag("LeftButton")
	button.UpdateTooltip = Row_OnEnter
	button.SplitStack = SplitStack
	button:SetScript("OnClick", Row_OnClick)
	button:SetScript("OnDragStart", MerchantItemButton_OnClick)
	button:SetScript("OnEnter", Row_OnEnter)
	button:SetScript("OnLeave", Row_OnLeave)
	button:SetScript("OnHide", Row_OnHide)

	local highlight = button:CreateTexture("$parentHighlight", "BACKGROUND")
	button.highlight = highlight
	highlight:SetAllPoints()
	highlight:SetBlendMode("ADD")
	highlight:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
	highlight:Hide()

	local icon = button:CreateTexture("$parentIcon", "BORDER")
	button.icon = icon
	icon:SetSize(25.4, 25.4)
	icon:SetPoint("LEFT", 2, 0)
	icon:SetTexture("Interface\\Icons\\temp")

	local itemName = button:CreateFontString("$parentItemName", "ARTWORK")
	button.itemname = itemName
	itemName:FontTemplate(E.LSM:Fetch("font", E.db.sle.skins.merchant.list.nameFont), E.db.sle.skins.merchant.list.nameSize, E.db.sle.skins.merchant.list.nameOutline)
	itemName:SetPoint("TOPLEFT", icon, "TOPRIGHT", 4, -3)
	itemName:SetJustifyH("LEFT")

	local itemInfo = button:CreateFontString("$parentItemInfo", "ARTWORK")
	button.iteminfo = itemInfo
	itemInfo:FontTemplate(E.LSM:Fetch("font", E.db.sle.skins.merchant.list.subFont), E.db.sle.skins.merchant.list.subSize, E.db.sle.skins.merchant.list.subOutline)
	itemInfo:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 4, -3)
	itemInfo:SetJustifyH("LEFT")

	local money = button:CreateFontString("$parentMoney", "ARTWORK", "GameFontHighlight")
	button.money = money
	money:SetPoint("RIGHT", -2, 0)
	money:SetJustifyH("RIGHT")
	itemName:SetPoint("BOTTOMRIGHT", money, "LEFT", -2, 0)
	itemInfo:SetPoint("TOPRIGHT", money, "LEFT", -2, 0)

	button.item = {}
	for costIndex = 1, MAX_ITEM_COST do
		button.item[costIndex] = CreateAltCostButton(button, costIndex)
		if costIndex == 1 then
			button.item[costIndex]:SetPoint("RIGHT", -2, 0)
		else
			button.item[costIndex]:SetPoint("RIGHT", button.item[costIndex - 1], "LEFT", -2, 0)
		end
	end

	buttons[index] = button
end

local function MerchantListSkinInit()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.sle.skins.merchant.enable ~= true then return end
	if E.private.sle.skins.merchant.style ~= "List" then return end

	local frame = CreateFrame("Frame", "SLE_ListMerchantFrame", _G.MerchantFrame)
	frame:SetSize(331, 294)
	frame:SetPoint("TOPLEFT", 10, -65)

	frame.scrollframe = CreateFrame("ScrollFrame", "SLE_ListMerchantScrollFrame", frame, "FauxScrollFrameTemplate")
	frame.scrollframe:SetSize(320, 298)
	frame.scrollframe:SetPoint("TOPLEFT", _G.MerchantFrame, 22, -65)
	frame.scrollframe:SetScript("OnVerticalScroll", OnVerticalScroll)
	frame.scrollframe:CreateBackdrop("Transparent")
	S:HandleScrollBar(_G.SLE_ListMerchantScrollFrameScrollBar)

	frame.search = CreateFrame("EditBox", "$parentSearch", frame, "InputBoxTemplate")
	frame.search:SetSize(92, 24)
	frame.search:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 50, 9)
	frame.search:SetAutoFocus(false)
	frame.search:SetFontObject(ChatFontSmall)
	frame.search:SetScript("OnTextChanged", Search_OnTextChanged)
	frame.search:SetScript("OnShow", Search_OnShow)
	frame.search:SetScript("OnEnterPressed", Search_OnEnterPressed)
	frame.search:SetScript("OnEscapePressed", Search_OnEscapePressed)
	frame.search:SetScript("OnEditFocusLost", Search_OnEditFocusLost)
	frame.search:SetScript("OnEditFocusGained", Search_OnEditFocusGained)
	frame.search:SetText(SEARCH)
	S:HandleEditBox(frame.search)

	for index = 1, ITEM_ROWS do
		CreateListRow(frame.scrollframe, index)
	end

	_G.MerchantFrame:SetWidth(_G.MerchantFrame:GetWidth() + 26)

	hooksecurefunc("MerchantFrame_Update", UpdateListVisibility)
	hooksecurefunc("MerchantFrame_OnHide", function()
		merchantUpdating = false
	end)
	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for index = 1, 3 do
			local tokenButton = _G["MerchantToken" .. index]
			if tokenButton and not tokenButton.SLE_ListMerchantStyled then
				if tokenButton.Icon then
					tokenButton.Icon:SetTexCoord(unpack(E.TexCoords))
				elseif tokenButton.icon then
					tokenButton.icon:SetTexCoord(unpack(E.TexCoords))
				end
				tokenButton.SLE_ListMerchantStyled = true
			end
		end
	end)

	_G.MerchantBuyBackItem:ClearAllPoints()
	_G.MerchantBuyBackItem:SetPoint("TOPRIGHT", frame.scrollframe, "BOTTOMRIGHT", 17, -12)

	for _, object in ipairs({ _G.MerchantNextPageButton, _G.MerchantPrevPageButton, _G.MerchantPageText }) do
		object:Hide()
		object.Show = function() end
	end

	frame:RegisterEvent("BAG_UPDATE")
	frame:SetScript("OnEvent", function(self)
		if not self:IsShown() or merchantUpdating then return end
		merchantUpdating = true
		E:Delay(0.15, function()
			UpdateMerchantList()
			merchantUpdating = false
		end)
	end)

	if not locale[GetLocale()] then
		SLE:Print("Your language is unavailable for selected merchant style. We would appreciate it if you contact us and provide needed translations.", "warning")
	end

	if not _G[hiddenTooltipName] then
		CreateFrame("GameTooltip", hiddenTooltipName, UIParent, "GameTooltipTemplate")
	end
end

hooksecurefunc(S, "Initialize", MerchantListSkinInit)
