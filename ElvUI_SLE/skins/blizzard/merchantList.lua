local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Sk = SLE.Skins
local S = E.Skins

-- GLOBALS: CreateFrame, hooksecurefunc, ChatFontSmall, UIParent, INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED
-- Rebuilding Merchant Frame as a scrollable list. Based on a code by Nils Ruesch (xMerchant addon)
local _G = _G
local strtrim = strtrim
local GetLocale = GetLocale
local HandleModifiedItemClick = HandleModifiedItemClick
local MerchantItemButton_OnClick = MerchantItemButton_OnClick
local BuyMerchantItem = BuyMerchantItem
local MerchantFrame_ConfirmExtendedItemCost = MerchantFrame_ConfirmExtendedItemCost
local FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll
local GetMerchantItemInfo, GetMerchantItemLink = GetMerchantItemInfo, GetMerchantItemLink
local GetMoney, GetCoinTextureString = GetMoney, GetCoinTextureString
local GetMerchantItemCostInfo, GetMerchantItemCostItem = GetMerchantItemCostInfo, GetMerchantItemCostItem
local FauxScrollFrame_GetOffset, FauxScrollFrame_Update = FauxScrollFrame_GetOffset, FauxScrollFrame_Update
local GetMerchantNumItems = GetMerchantNumItems
local IsModifiedClick = IsModifiedClick
local MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local MerchantItemButton_OnEnter = MerchantItemButton_OnEnter
local ResetCursor, ShowInspectCursor = ResetCursor, ShowInspectCursor

local C_CurrencyInfo_GetCurrencyListInfo = C_CurrencyInfo.GetCurrencyListInfo
local C_CurrencyInfo_GetCurrencyListSize = C_CurrencyInfo.GetCurrencyListSize

local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = C_Container.GetContainerItemID

local C_Item_GetItemInfo = C_Item.GetItemInfo

local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local SEARCH = SEARCH
local MAX_ITEM_COST = MAX_ITEM_COST
local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local MISCELLANEOUS, MOUNT = MISCELLANEOUS, MOUNT

local RECIPE = C_Item.GetItemClassInfo(Enum.ItemClass.Recipe)

local currencies = {}
local buttons = {}
local searching = ""
local errors = {}
local knowns = {}
local MerchantUpdating = false

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
local REQUIRES_LEVEL = locale[GetLocale()] and locale[GetLocale()].REQUIRES_LEVEL or ""
local LEVEL = locale[GetLocale()] and locale[GetLocale()].LEVEL or ""
local REQUIRES_REPUTATION = locale[GetLocale()] and locale[GetLocale()].REQUIRES_REPUTATION or ""
local REQUIRES_REPUTATION_NAME = locale[GetLocale()] and locale[GetLocale()].REQUIRES_REPUTATION_NAME or ""
local REQUIRES_SKILL = locale[GetLocale()] and locale[GetLocale()].REQUIRES_SKILL or ""
local SKILL = "%1$s (%2$d)"
local REQUIRES = locale[GetLocale()] and locale[GetLocale()].REQUIRES or ""

local function Item_OnClick(self)
	HandleModifiedItemClick(self.itemLink)
end

local function Item_OnEnter(self)
	local parent = self:GetParent()
	if ( parent.isShown and not parent.hover ) then
		parent.oldr, parent.oldg, parent.oldb, parent.olda = parent.highlight:GetVertexColor()
		parent.highlight:SetVertexColor(parent.r, parent.g, parent.b, parent.olda)
		parent.hover = 1
	else
		parent.highlight:Show()
	end

	_G["GameTooltip"]:SetOwner(self, "ANCHOR_RIGHT")
	if self.itemLink then _G["GameTooltip"]:SetHyperlink(self.itemLink) end
	if ( IsModifiedClick("DRESSUP") ) then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function Item_OnLeave(self)
	local parent = self:GetParent()
	if ( parent.isShown ) then
		parent.highlight:SetVertexColor(parent.oldr, parent.oldg, parent.oldb, parent.olda)
		parent.hover = nil
	else
		parent.highlight:Hide()
	end
	_G["GameTooltip"]:Hide()
	ResetCursor()
end

local function ListItem_OnClick(self, button)
	if ( IsModifiedClick() ) then
		MerchantItemButton_OnModifiedClick(self, button)
	else
		MerchantItemButton_OnClick(self, button)
	end
end

local function ListItem_OnEnter(self)
	if ( self.isShown and not self.hover ) then
		self.oldr, self.oldg, self.oldb, self.olda = self.highlight:GetVertexColor()
		self.highlight:SetVertexColor(self.r, self.g, self.b, self.olda)
		self.hover = 1
	else
		self.highlight:Show()
	end
	MerchantItemButton_OnEnter(self)
end

local function ListItem_OnLeave(self)
	if ( self.isShown ) then
		if (self.oldr) then
			self.highlight:SetVertexColor(self.oldr, self.oldg, self.oldb, self.olda)
		end
		self.hover = nil
	else
		self.highlight:Hide()
	end
	_G["GameTooltip"]:Hide()
	ResetCursor()
	_G["MerchantFrame"].itemHover = nil
end

local function ListItem_OnHide()
	wipe(errors)
	wipe(currencies)
end

local function List_GetError(link, itemType, itemSubType)
	if ( not link ) then
		return false
	end

	local id = link:match("item:(%d+)")

	if ( errors[id] ) then
		return errors[id]
	end
	local upperLimit
	local isMount = false
	local isRecipe = false
	if itemType == RECIPE then
		isRecipe = true
	elseif itemType == MISCELLANEOUS and itemSubType == MOUNT then
		isMount = true
	end
	local errormsg = ""

	_G["SLE_Merchant_HiddenTooltip"]:SetOwner(UIParent, "ANCHOR_NONE")
	_G["SLE_Merchant_HiddenTooltip"]:SetHyperlink(link)
	upperLimit = isRecipe and _G["SLE_Merchant_HiddenTooltip"]:NumLines() or 0

	for i=2, _G["SLE_Merchant_HiddenTooltip"]:NumLines() do
		if (isRecipe and (i <= 5 or i >= upperLimit - 3)) or isMount or not isRecipe then
			local text = _G["SLE_Merchant_HiddenTooltipTextLeft"..i]
			local r, g, b = text:GetTextColor()
			local gettext = text:GetText()
			if ( gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 and gettext ~= RETRIEVING_ITEM_INFO ) then
				if ( errormsg ~= "" ) then
					errormsg = errormsg..", "
				end

				local level = gettext:match(REQUIRES_LEVEL)
				if ( level ) then
					errormsg = errormsg..LEVEL:format(level)
				end

				local reputation, factionName = strmatch(gettext, REQUIRES_REPUTATION)
				if ( reputation ) then
					errormsg = errormsg..reputation
					if not factionName then factionName = gettext:match(REQUIRES_REPUTATION_NAME) end
					if ( factionName ) then
							errormsg = errormsg.." ("..factionName..")"
					end
				end

				local skill, slevel = gettext:match(REQUIRES_SKILL)
				if ( skill and slevel ) then
					errormsg = errormsg..SKILL:format(skill, slevel)
				end

				local requires = gettext:match(REQUIRES)
				if ( not level and not reputation and not skill and requires ) then
					errormsg = errormsg..requires
				end

				local known = gettext == ITEM_SPELL_KNOWN and true or false
				if known then
					errormsg = errormsg..ITEM_SPELL_KNOWN
				end

				if ( not level and not reputation and not skill and not requires and not known) then
					if ( errormsg ~= "" ) then
						errormsg = gettext..", "..errormsg
					else
						errormsg = errormsg..gettext
					end
				end
			end
			--  TODO: Come back to these later as they are declared 2 times in the same block
			local text = _G["SLE_Merchant_HiddenTooltipTextRight"..i]
			local r, g, b = text:GetTextColor()
			local gettext = text:GetText()
			if ( gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 ) then
				if ( errormsg ~= "" ) then
					errormsg = errormsg..", "
				end
				errormsg = errormsg..gettext
			end
		end
	end

	if ( errormsg == "" ) then
		return false
	end

	errors[id] = errormsg
	return errormsg
end

local function List_AltCurrencyFrame_Update(item, texture, cost, canAfford)
	if (canAfford == false) then
		item.count:SetTextColor(1, 0, 0)
	else
		item.count:SetTextColor(1, 1, 1)
	end

	item.count:SetText(cost)
	item.icon:SetTexture(texture)
	item.count:SetPoint("RIGHT", item.icon, "LEFT", -2, 0)
	-- item.icon:SetTexCoord(0, 1, 0, 1)
	item.icon:SetTexCoord(unpack(E.TexCoords))

	local iconWidth = 17
	item.icon:SetWidth(iconWidth)
	item.icon:SetHeight(iconWidth)
	item:SetWidth(item.count:GetWidth() + iconWidth + 4)
	item:SetHeight(item.count:GetHeight() + 4)
end

local function List_CurrencyUpdate()
	wipe(currencies)

	local limit = C_CurrencyInfo_GetCurrencyListSize()

	for i=1, limit do
		local name, isHeader, _, _, _, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, _, itemID = C_CurrencyInfo_GetCurrencyListInfo(i)
		if ( not isHeader and itemID ) then
			currencies[tonumber(itemID)] = count
			if ( not isHeader and itemID and tonumber(itemID) <= 9 ) then
				currencies[name] = count
			end
		elseif ( not isHeader and not itemID ) then
			currencies[name] = count
		end
	end

	for i=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED, 1 do
		local itemID = GetInventoryItemID("player", i)
		if ( itemID ) then
			currencies[tonumber(itemID)] = 1
		end
	end

	for bagID=0, NUM_BAG_SLOTS, 1 do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		for slotID=1, numSlots, 1 do
			local itemID = C_Container_GetContainerItemID(bagID, slotID)
			if ( itemID ) then
				local count = select(2, C_Container_GetContainerItemInfo(bagID, slotID))
				itemID = tonumber(itemID)
				local currency = currencies[itemID]
				if ( currency ) then
					currencies[itemID] = currency+count
				else
					currencies[itemID] = count
				end
			end
		end
	end
end

--  TODO: Think the i is incorrect
local function List_UpdateAltCurrency(button, index, i, canAfford)
	local currency_frames = {}
	local lastFrame
	local itemCount = GetMerchantItemCostInfo(index)

	if ( itemCount > 0 ) then
		for i = 1, MAX_ITEM_COST do
		-- for i = 1, 1 do
			local itemTexture, itemValue, itemLink = GetMerchantItemCostItem(index, i)
			local item = button.item[i]
			item.index = index
			item.item = i
			item.itemLink = itemLink
			List_AltCurrencyFrame_Update(item, itemTexture, itemValue, canAfford)

			if ( not itemTexture ) then
				item:Hide()
			else
				lastFrame = item
				lastFrame._dbg_name = "item"..i
				tinsert(currency_frames, item)
				item:Show()
			end
		end
	else
		for i = 1, MAX_ITEM_COST do
			button.item[i]:Hide()
		end
	end

	button.money._dbg_name = "money"
	tinsert(currency_frames, button.money)

	lastFrame = nil
	for i, frame in ipairs(currency_frames) do
		if i == 1 then
			frame:SetPoint("RIGHT", -2, 6)
		else
			if lastFrame then
				frame:SetPoint("RIGHT", lastFrame, "LEFT", -2, 0)
			else
				frame:SetPoint("RIGHT", -2, 0)
			end
		end
		lastFrame = frame
	end
end

local function List_MerchantUpdate()
	local self = _G["SLE_ListMerchantFrame"]
	local numMerchantItems = GetMerchantNumItems()

	FauxScrollFrame_Update(self.scrollframe, numMerchantItems, 10, 29.4, nil, nil, nil, nil, nil, nil, 1)
	for i=1, 10 do
		local offset = i+FauxScrollFrame_GetOffset(self.scrollframe)
		local button = buttons[i]
		button.hover = nil
		if ( offset <= numMerchantItems ) then
			--API name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost = GetMerchantItemInfo(index)
			local name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost = GetMerchantItemInfo(offset)
			local canAfford = CanAffordMerchantItem(offset)
			local link = GetMerchantItemLink(offset)
			local subtext = ""
			local r, g, b = 0.5, 0.5, 0.5
			local _, itemRarity, itemType, itemSubType, equipSlot
			local iLevel
			if ( link ) then
				--API name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemID) or GetItemInfo("itemName") or GetItemInfo("itemLink")
				_, _, itemRarity, iLevel, _, itemType, itemSubType, _, equipSlot = C_Item_GetItemInfo(link)
				if itemRarity then
					r, g, b = GetItemQualityColor(itemRarity)
					button.itemname:SetTextColor(r, g, b)
				end
				if itemSubType then
					subtext = itemSubType:gsub("%(OBSOLETE%)", "")
					if equipSlot and equipSlot ~= "" and equipSlot ~= "INVTYPE_TABARD" then
						subtext = _G[equipSlot].." ("..iLevel..")"
					elseif equipSlot and equipSlot == "INVTYPE_TABARD" then
						subtext = _G[equipSlot]
					end
					button.iteminfo:SetText(subtext)
				else
					button.iteminfo:SetText("")
				end

				local alpha = 0.3
				if ( searching == "" or searching == SEARCH:lower() or name:lower():match(searching)
					or ( itemRarity and ( tostring(itemRarity):lower():match(searching) or _G["ITEM_QUALITY"..tostring(itemRarity).."_DESC"]:lower():match(searching) ) )
					or ( itemType and itemType:lower():match(searching) )
					or ( itemSubType and itemSubType:lower():match(searching) )
					) then
					alpha = 1
				end
				button:SetAlpha(alpha)
			else
				button.iteminfo:SetText(subtext)
			end

			button.itemname:SetText((numAvailable >= 0 and "|cffffffff["..numAvailable.."]|r " or "")..(quantity > 1 and "|cffffffff"..quantity.."x|r " or "")..(name or "|cffff0000"..RETRIEVING_ITEM_INFO))
			button.icon:SetTexture(texture)
			button.icon:SetTexCoord(unpack(E.TexCoords))

			List_UpdateAltCurrency(button, offset, i, canAfford)
			if ( extendedCost and price <= 0 ) then
				button.price = nil
				button.extendedCost = true
				button.money:SetText("")
			elseif ( extendedCost and price > 0 ) then
				button.price = price
				button.extendedCost = true
				button.money:SetText(GetCoinTextureString(price))
			else
				button.price = price
				button.extendedCost = nil
				button.money:SetText(GetCoinTextureString(price))
			end

			if ( GetMoney() > price ) then
				button.money:SetTextColor(1, 1, 1)
			else
				button.money:SetTextColor(1, 0, 0)
			end

			local merchantItemID = GetMerchantItemID(offset)
			local isHeirloom = merchantItemID and C_Heirloom.IsItemHeirloom(merchantItemID)
			local isKnownHeirloom = isHeirloom and C_Heirloom.PlayerHasHeirloom(merchantItemID)
			local tintRed = not isPurchasable or (not isUsable and not isHeirloom) -- or (canAfford == false)

			if ( numAvailable == 0 or isKnownHeirloom ) then
				button.highlight:SetVertexColor(0.5, 0.5, 0.5, 0.5)
				button.highlight:Show()
				button.isShown = 1
			elseif tintRed then
				button.highlight:SetVertexColor(1, 0.2, 0.2, 0.5)
				button.highlight:Show()
				button.isShown = 1

				-- TODO: Check if this works as Darth had local errors but was alread declared
				local errors = List_GetError(link, itemType, itemSubType)
				if ( errors ) then
					button.iteminfo:SetText("|cffd00000"..subtext.." - "..errors.."|r")
				end
			else
				button.highlight:SetVertexColor(r, g, b, 0.5)
				button.highlight:Hide()
				button.isShown = nil

				-- TODO: Check if this works as Darth had local errors but was alread declared
				local errors = List_GetError(link, itemType, itemSubType)
				if ( errors ) then
					button.highlight:SetVertexColor(1, 0.2, 0.2, 0.5)
					button.highlight:Show()
					button.isShown = 1
					button.iteminfo:SetText("|cffd00000"..subtext.." - "..errors.."|r")
				end
			end

			button.r = r
			button.g = g
			button.b = b
			button.link = GetMerchantItemLink(offset)
			button.hasItem = true
			button.texture = texture
			button:SetID(offset)
			button:Show()
		else
			button.price = nil
			button.hasItem = nil
			button:Hide()
		end
		if ( button.hasStackSplit == 1 ) then
			_G["StackSplitFrame"]:Hide()
		end
	end
end

local function ListSearch_OnTextChanged(self)
	searching = self:GetText():trim():lower()
	List_MerchantUpdate()
end

local function ListSearch_OnShow(self)
	self:SetText(SEARCH)
	searching = ""
end

local function ListSearch_OnEnterPressed(self)
	self:ClearFocus()
end

local function ListSearch_OnEscapePressed(self)
	self:ClearFocus()
	self:SetText(SEARCH)
	searching = ""
end

local function ListSearch_OnEditFocusLost(self)
	self:HighlightText(0, 0)
	if ( strtrim(self:GetText()) == "" ) then
		self:SetText(SEARCH)
		searching = ""
	end
end

local function ListSearch_OnEditFocusGained(self)
	self:HighlightText()
	if ( self:GetText():trim():lower() == SEARCH:lower() ) then
		self:SetText("")
	end
end

local function ListStyle_Update()
	if ( _G["MerchantFrame"].selectedTab == 1 ) then
		for i=1, 12 do
			_G["MerchantItem"..i]:Hide()
		end
		_G["SLE_ListMerchantFrame"]:Show()
		-- List_CurrencyUpdate()
		List_MerchantUpdate()
	else
		_G["SLE_ListMerchantFrame"]:Hide()
		for i=1, 12 do
			_G["MerchantItem"..i]:Show()
		end
		if ( _G["StackSplitFrame"]:IsShown() ) then
			_G["StackSplitFrame"]:Hide()
		end
	end
end

local function OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, 29.4, List_MerchantUpdate)
end

local function SplitStack(button, split)
	if ( button.extendedCost ) then
		MerchantFrame_ConfirmExtendedItemCost(button, split)
	elseif ( split > 0 ) then
		BuyMerchantItem(button:GetID(), split)
	end
end

local function Create_ListButton(frame, i)
	local button = CreateFrame("Button", "SLE_ListMerchantFrame_Button"..i, frame)
	button:SetWidth(frame:GetWidth())
	button:SetHeight(29.4)
	if ( i == 1 ) then
		button:SetPoint("TOPLEFT", 0, -1)
	else
		button:SetPoint("TOP", buttons[i-1], "BOTTOM")
	end
	button:RegisterForClicks("LeftButtonUp","RightButtonUp")
	button:RegisterForDrag("LeftButton")
	button.UpdateTooltip = ListItem_OnEnter
	button.SplitStack = SplitStack
	button:SetScript("OnClick", ListItem_OnClick)
	button:SetScript("OnDragStart", MerchantItemButton_OnClick)
	button:SetScript("OnEnter", ListItem_OnEnter)
	button:SetScript("OnLeave", ListItem_OnLeave)
	button:SetScript("OnHide", ListItem_OnHide)

	local highlight = button:CreateTexture("$parentHighlight", "BACKGROUND") -- better highlight
	button.highlight = highlight
	highlight:SetAllPoints()
	highlight:SetBlendMode("ADD")
	highlight:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
	highlight:Hide()

	local icon = button:CreateTexture("$parentIcon", "BORDER")
	button.icon = icon
	icon:SetWidth(25.4)
	icon:SetHeight(25.4)
	icon:SetPoint("LEFT", 2, 0)
	icon:SetTexture("Interface\\Icons\\temp")

	local itemname = button:CreateFontString("$parentItemName", "ARTWORK")
	button.itemname = itemname
	itemname:FontTemplate(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.nameFont), E.db.sle.skins.merchant.list.nameSize, E.db.sle.skins.merchant.list.nameOutline)
	itemname:SetPoint("TOPLEFT", icon, "TOPRIGHT", 4, -3)
	itemname:SetJustifyH("LEFT")

	local iteminfo = button:CreateFontString("$parentItemInfo", "ARTWORK")
	button.iteminfo = iteminfo
	iteminfo:FontTemplate(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.subFont), E.db.sle.skins.merchant.list.subSize, E.db.sle.skins.merchant.list.subOutline)
	iteminfo:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 4, -3)
	iteminfo:SetJustifyH("LEFT")

	local money = button:CreateFontString("$parentMoney", "ARTWORK", "GameFontHighlight")
	button.money = money
	money:SetPoint("RIGHT", -2, 0)
	money:SetJustifyH("RIGHT")
	itemname:SetPoint("BOTTOMRIGHT", money, "LEFT", -2, 0)
	iteminfo:SetPoint("TOPRIGHT", money, "LEFT", -2, 0)

	button.item = {}
	for j=1, MAX_ITEM_COST do
		local item = CreateFrame("Button", "$parentItem"..j, button)
		button.item[j] = item
		item:SetWidth(17)
		item:SetHeight(17)
		if ( j == 1 ) then
			item:SetPoint("RIGHT", -2, 0)
		else
			item:SetPoint("RIGHT", button.item[j-1], "LEFT", -2, 0)
		end
		item:RegisterForClicks("LeftButtonUp","RightButtonUp")
		item:SetScript("OnClick", Item_OnClick)
		item:SetScript("OnEnter", Item_OnEnter)
		item:SetScript("OnLeave", Item_OnLeave)
		item.hasItem = true
		item.UpdateTooltip = Item_OnEnter

		local icon = item:CreateTexture("$parentIcon", "BORDER")
		item.icon = icon
		icon:SetWidth(17)
		icon:SetHeight(17)
		icon:SetPoint("RIGHT")

		local count = item:CreateFontString("$parentCount", "ARTWORK", "GameFontHighlight")
		item.count = count
		count:SetPoint("RIGHT", icon, "LEFT", -2, 0)
	end

	buttons[i] = button
end

local function MerchantListSkinInit()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.sle.skins.merchant.enable ~= true then return end
	if E.private.sle.skins.merchant.style ~= "List" then return end
	local frame = CreateFrame("Frame", "SLE_ListMerchantFrame", _G["MerchantFrame"])
	frame:SetWidth(331)
	frame:SetHeight(294)
	frame:SetPoint("TOPLEFT", 10, -65)

	frame.scrollframe = CreateFrame("ScrollFrame", "SLE_ListMerchantScrollFrame", frame, "FauxScrollFrameTemplate")
	frame.scrollframe:SetWidth(320)
	frame.scrollframe:SetHeight(298)
	frame.scrollframe:SetPoint("TOPLEFT", _G["MerchantFrame"], 22, -65)
	frame.scrollframe:SetScript("OnVerticalScroll", OnVerticalScroll)
	frame.scrollframe:CreateBackdrop("Transparent")
	S:HandleScrollBar(_G["SLE_ListMerchantScrollFrameScrollBar"])

	frame.search = CreateFrame("EditBox", "$parentSearch", frame, "InputBoxTemplate")
	frame.search:SetWidth(92)
	frame.search:SetHeight(24)
	frame.search:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 50, 9)
	frame.search:SetAutoFocus(false)
	frame.search:SetFontObject(ChatFontSmall)
	frame.search:SetScript("OnTextChanged", ListSearch_OnTextChanged)
	frame.search:SetScript("OnShow", ListSearch_OnShow)
	frame.search:SetScript("OnEnterPressed", ListSearch_OnEnterPressed)
	frame.search:SetScript("OnEscapePressed", ListSearch_OnEscapePressed)
	frame.search:SetScript("OnEditFocusLost", ListSearch_OnEditFocusLost)
	frame.search:SetScript("OnEditFocusGained", ListSearch_OnEditFocusGained)
	frame.search:SetText(SEARCH)
	S:HandleEditBox(frame.search)

	for i = 1, 10 do Create_ListButton(frame.scrollframe, i) end
	_G["MerchantFrame"]:SetWidth(_G["MerchantFrame"]:GetWidth() + 26)

	hooksecurefunc("MerchantFrame_Update", ListStyle_Update)
	hooksecurefunc("MerchantFrame_OnHide", ListItem_OnHide)
	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for index = 1, 3 do
			local tokenButton = _G["MerchantToken"..index]
			if tokenButton and not tokenButton.SLE_ListMerchantStyled then
				if tokenButton.Icon then
					tokenButton.Icon:SetTexCoord(unpack(E.TexCoords))
				else
					tokenButton.icon:SetTexCoord(unpack(E.TexCoords))
				end
				tokenButton.SLE_ListMerchantStyled = true
			end
		end
	end)

	_G["MerchantBuyBackItem"]:ClearAllPoints()
	_G["MerchantBuyBackItem"]:SetPoint("TOPRIGHT", frame.scrollframe, "BOTTOMRIGHT", 17, -12)
	local delete = { _G["MerchantNextPageButton"], _G["MerchantPrevPageButton"], _G["MerchantPageText"] }
	for i = 1, #delete do
		delete[i]:Hide()
		delete[i].Show = function() end
	end
	frame:RegisterEvent("BAG_UPDATE")
	frame:SetScript("OnEvent", function(self, event, ...)
		if not self:IsShown() or MerchantUpdating then return end
		MerchantUpdating = true
		E:Delay(0.25, function()
			-- List_CurrencyUpdate()
			List_MerchantUpdate()
			MerchantUpdating = false
		end)
	end)
	if not locale[GetLocale()] then
		SLE:Print("Your language is unavailable for selected merchant style. We would appretiate if you contact us and provide needed translations.", "warning")
	end
	CreateFrame("GameTooltip", "SLE_Merchant_HiddenTooltip", UIParent, "GameTooltipTemplate")
end

hooksecurefunc(S, "Initialize", MerchantListSkinInit)
