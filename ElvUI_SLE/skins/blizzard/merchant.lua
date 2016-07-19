local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Sk = SLE:GetModule("Skins")
local S = E:GetModule('Skins')
--GLOBALS: CreateFrame, MERCHANT_ITEMS_PER_PAGE, BUYBACK_ITEMS_PER_PAGE, hooksecurefunc, MERCHANT_PAGE_NUMBER
local _G = _G
local ItemsPerSubpage, SubpagesPerPage
local math_max, math_ceil = math.max, math.ceil
local MerchantFrame_UpdateAltCurrency, MoneyFrame_Update = MerchantFrame_UpdateAltCurrency, MoneyFrame_Update
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemInfo, GetMerchantItemLink = GetMerchantItemInfo, GetMerchantItemLink
local SetItemButtonCount, SetItemButtonStock, SetItemButtonTexture = SetItemButtonCount, SetItemButtonStock, SetItemButtonTexture
local SetItemButtonNameFrameVertexColor, SetItemButtonSlotVertexColor, SetItemButtonTextureVertexColor, SetItemButtonNormalTextureVertexColor = SetItemButtonNameFrameVertexColor, SetItemButtonSlotVertexColor, SetItemButtonTextureVertexColor, SetItemButtonNormalTextureVertexColor

local IgnoreCurrency = {
	[T.GetCurrencyInfo(994)] = true,
}

local function SkinVendorItems(i)
	local b = _G["MerchantItem"..i.."ItemButton"]
	local t = _G["MerchantItem"..i.."ItemButtonIconTexture"]
	local item_bar = _G["MerchantItem"..i]
	item_bar:StripTextures(true)
	item_bar:CreateBackdrop("Default")

	b:StripTextures()
	b:StyleButton(false)
	b:SetTemplate("Default", true)
	b:Point("TOPLEFT", item_bar, "TOPLEFT", 4, -4)
	t:SetTexCoord(T.unpack(E.TexCoords))
	t:SetInside()

	_G["MerchantItem"..i.."MoneyFrame"]:ClearAllPoints()
	_G["MerchantItem"..i.."MoneyFrame"]:Point("BOTTOMLEFT", b, "BOTTOMRIGHT", 3, 0)
end

local function UpdateButtonsPositions(isBuyBack)
	local btn;
	local vertSpacing, horizSpacing

	if (isBuyBack) then
		vertSpacing = -30
		horizSpacing = 50
	else
		vertSpacing = -16
		horizSpacing = 12
	end
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		btn = _G["MerchantItem" .. i]
		if (isBuyBack) then
			if (i > BUYBACK_ITEMS_PER_PAGE) then
				btn:Hide()
			else
				if (i == 1) then
					btn:SetPoint("TOPLEFT", _G["MerchantFrame"], "TOPLEFT", 64, -105)
				else
					if ((i % 3) == 1) then
						btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-3)], "BOTTOMLEFT", 0, vertSpacing)
					else
						btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-1)], "TOPRIGHT", horizSpacing, 0)
					end
				end
			end
		else
			btn:Show()
			if ((i % ItemsPerSubpage) == 1) then
				if (i == 1) then
					btn:SetPoint("TOPLEFT", _G["MerchantFrame"], "TOPLEFT", 24, -70)
				else
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-(ItemsPerSubpage - 1))], "TOPRIGHT", 12, 0)
				end
			else
				if ((i % 2) == 1) then
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-2)], "BOTTOMLEFT", 0, vertSpacing)
				else
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-1)], "TOPRIGHT", horizSpacing, 0)
				end
			end
		end
	end
end

local function UpdateBuybackInfo()
	UpdateButtonsPositions(true)
	-- apply coloring
	local btn, link, quality, r, g, b, _;
	for i = 1, BUYBACK_ITEMS_PER_PAGE, 1 do
		btn = _G["MerchantItem" .. i];
		if (btn) then
			link = GetBuybackItemLink(i);
			if (link) then
				_, _, quality = GetItemInfo(link);
				r, g, b = GetItemQualityColor(quality);
				_G["MerchantItem" .. i .. "Name"]:SetTextColor(r, g, b);
			end
		end
	end
end

local function UpdateMerchantInfo()
	UpdateButtonsPositions()

	local totalMerchantItems = GetMerchantNumItems();
	local visibleMerchantItems = 0
	local indexes = {}
	local _, name, texture, price, quantity, numAvailable, isUsable, extendedCost, r, g, b, notOptimal;
	local link, quality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemSellPrice, itemId;
	
	for i = 1, totalMerchantItems do
		T.tinsert(indexes, i);
		visibleMerchantItems = visibleMerchantItems + 1;
	end
	
	 -- validate current page shown
	if (_G["MerchantFrame"].page > math_max(1, math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE))) then
		_G["MerchantFrame"].page = math_max(1, math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE));
	end

	-- Show correct page count based on number of items shown
	_G["MerchantPageText"]:SetFormattedText(MERCHANT_PAGE_NUMBER, _G["MerchantFrame"].page, math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE));
	
	--Display shit
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		 local index = ((_G["MerchantFrame"].page - 1) * MERCHANT_ITEMS_PER_PAGE) + i;
		local itemButton = _G["MerchantItem" .. i .. "ItemButton"];
		itemButton.link = nil;
		local merchantButton = _G["MerchantItem" .. i];
		local merchantMoney = _G["MerchantItem" .. i .. "MoneyFrame"];
		local merchantAltCurrency = _G["MerchantItem" .. i .. "AltCurrencyFrame"];
		if (index <= visibleMerchantItems) then
			name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(indexes[index]);
			if (name ~= nil) then
				_G["MerchantItem"..i.."Name"]:SetText(name);
				SetItemButtonCount(itemButton, quantity);
				SetItemButtonStock(itemButton, numAvailable);
				SetItemButtonTexture(itemButton, texture);

				-- update item's currency info
				if ( extendedCost and (price <= 0) ) then
					itemButton.price = nil;
					itemButton.extendedCost = true;
					itemButton.link = GetMerchantItemLink(indexes[index]);
					itemButton.texture = texture;
					MerchantFrame_UpdateAltCurrency(indexes[index], i);
					merchantAltCurrency:ClearAllPoints();
					merchantAltCurrency:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 31);
					merchantMoney:Hide();
					merchantAltCurrency:Show();
				elseif ( extendedCost and (price > 0) ) then
					itemButton.price = price;
					itemButton.extendedCost = true;
					itemButton.link = GetMerchantItemLink(indexes[index]);
					itemButton.texture = texture;
					MerchantFrame_UpdateAltCurrency(indexes[index], i);
					MoneyFrame_Update(merchantMoney:GetName(), price);
					merchantAltCurrency:ClearAllPoints();
					merchantAltCurrency:SetPoint("LEFT", merchantMoney:GetName(), "RIGHT", -14, 0);
					merchantAltCurrency:Show();
					merchantMoney:Show();
				else
					itemButton.price = price;
					itemButton.extendedCost = nil;
					itemButton.link = GetMerchantItemLink(indexes[index]);
					itemButton.texture = texture;
					MoneyFrame_Update(merchantMoney:GetName(), price);
					merchantAltCurrency:Hide();
					merchantMoney:Show();
				end

				quality = 1;
				if (itemButton.link) and not IgnoreCurrency[name] then
					_, _, quality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, _, itemSellPrice = T.GetItemInfo(itemButton.link);
				end

				-- set color
				r, g, b = T.GetItemQualityColor(quality);
				_G["MerchantItem" .. i .. "Name"]:SetTextColor(r, g, b);

				itemButton.hasItem = true;
				itemButton:SetID(indexes[index]);
				itemButton:Show();
				local colorMult = 1.0;
				local detailColor = {};
				local slotColor = {};
				-- unavailable items (limited stock, bought out) are darkened
				if ( numAvailable == 0 ) then
					colorMult = 0.5;
				end
				if ( not isUsable ) then
					slotColor = {r = 1.0, g = 0, b = 0};
					detailColor = {r = 1.0, g = 0, b = 0};
				else
					slotColor = {r = 1.0, g = 1.0, b = 1.0};
					detailColor = {r = 0.5, g = 0.5, b = 0.5};
				end
				SetItemButtonNameFrameVertexColor(merchantButton, detailColor.r * colorMult, detailColor.g * colorMult, detailColor.b * colorMult);
				SetItemButtonSlotVertexColor(merchantButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult);
				SetItemButtonTextureVertexColor(itemButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult);
				SetItemButtonNormalTextureVertexColor(itemButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult);
			end
		else
			itemButton.price = nil;
			itemButton.hasItem = nil;
			itemButton:Hide();
			SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0.5, 0.5);
			SetItemButtonSlotVertexColor(merchantButton,0.4, 0.4, 0.4);
			_G["MerchantItem"..i.."Name"]:SetText("");
			_G["MerchantItem"..i.."MoneyFrame"]:Hide();
			_G["MerchantItem"..i.."AltCurrencyFrame"]:Hide();
		end
	end
end

local function RebuildMerchantFrame()
	ItemsPerSubpage = MERCHANT_ITEMS_PER_PAGE
	SubpagesPerPage = E.private.sle.skins.merchant.subpages
	MERCHANT_ITEMS_PER_PAGE = SubpagesPerPage * 10 --Haven't seen this causing any taints so I asume it's ok
	-- _G["MerchantFrame"]:SetWidth(60 + 330 * SubpagesPerPage)
	_G["MerchantFrame"]:SetWidth(42 + (318 * SubpagesPerPage) + (12 * (SubpagesPerPage - 1)))
	-- _G["MerchantFrame"]:SetWidth(690)

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		if (not _G["MerchantItem" .. i]) then
			CreateFrame("Frame", "MerchantItem" .. i, _G["MerchantFrame"], "MerchantItemTemplate")
			SkinVendorItems(i)
		end
	end
	 -- alter the position of the buyback item slot on the merchant tab
	_G["MerchantBuyBackItem"]:ClearAllPoints()
	_G["MerchantBuyBackItem"]:SetPoint("TOPLEFT", _G["MerchantItem10"], "BOTTOMLEFT", -14, -20)
	
	-- move the next/previous page buttons
	_G["MerchantPrevPageButton"]:ClearAllPoints();
	_G["MerchantPrevPageButton"]:SetPoint("CENTER", _G["MerchantFrame"], "BOTTOM", 50, 70);
	_G["MerchantPageText"]:ClearAllPoints();
	_G["MerchantPageText"]:SetPoint("BOTTOM", _G["MerchantFrame"], "BOTTOM", 160, 65);
	_G["MerchantNextPageButton"]:ClearAllPoints();
	_G["MerchantNextPageButton"]:SetPoint("CENTER", _G["MerchantFrame"], "BOTTOM", 270, 70);

	-- currency insets
	_G["MerchantExtraCurrencyInset"]:ClearAllPoints();
	_G["MerchantExtraCurrencyInset"]:SetPoint("BOTTOMRIGHT", _G["MerchantMoneyInset"], "BOTTOMLEFT", 0, 0);
	_G["MerchantExtraCurrencyInset"]:SetPoint("TOPLEFT", _G["MerchantMoneyInset"], "TOPLEFT", -165, 0);
	_G["MerchantExtraCurrencyBg"]:ClearAllPoints();
	_G["MerchantExtraCurrencyBg"]:SetPoint("TOPLEFT", _G["MerchantExtraCurrencyInset"], "TOPLEFT", 3, -2);
	_G["MerchantExtraCurrencyBg"]:SetPoint("BOTTOMRIGHT", _G["MerchantExtraCurrencyInset"], "BOTTOMRIGHT", -3, 2);
end

local function MerchantSkinInit()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.sle.skins.merchant.enable ~= true then return end
	RebuildMerchantFrame()
	UpdateButtonsPositions()

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", UpdateMerchantInfo)
	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", UpdateBuybackInfo)
end

hooksecurefunc(S, "Initialize", MerchantSkinInit)