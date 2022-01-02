local _, _, E, L = unpack(select(2, ...))
local DT = E.DataTexts
local B = E.Bags

local _G = _G
local type, wipe, pairs, ipairs, sort = type, wipe, pairs, ipairs, sort
local format, strjoin, tinsert = format, strjoin, tinsert
local tonumber, unpack = tonumber, unpack

local GetMoney = GetMoney
local IsControlKeyDown = IsControlKeyDown
local IsLoggedIn = IsLoggedIn
local IsShiftKeyDown = IsShiftKeyDown
local C_WowTokenPublic_UpdateMarketPrice = C_WowTokenPublic.UpdateMarketPrice
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice
local C_Timer_NewTicker = C_Timer.NewTicker
local BreakUpLargeNumbers = BreakUpLargeNumbers

local Ticker
-- local CURRENCY = CURRENCY --Needed if I decide to add watched currency from backpack
-- local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS --Needed if I decide to add watched currency from backpack
local Profit, Spent = 0, 0
local resetCountersFormatter = strjoin('', '|cffaaaaaa', L["Reset Session Data: Hold Ctrl + Right Click"], '|r')
local resetInfoFormatter = strjoin('', '|cffaaaaaa', L["Reset Character Data: Hold Shift + Right Click"], '|r')
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local BONUS_ROLL_REWARD_MONEY = BONUS_ROLL_REWARD_MONEY
local iconString = '|T%s:16:16:0:0:64:64:4:60:4:60|t'
local C_Item_IsAnimaItemByID = C_Item.IsAnimaItemByID
local GetContainerNumSlots, GetContainerItemLink, GetContainerItemInfo = GetContainerNumSlots, GetContainerItemLink, GetContainerItemInfo
local GetItemSpell = GetItemSpell

local menuList = {}

DT.CurrencyList = { GOLD = BONUS_ROLL_REWARD_MONEY, BACKPACK = 'Backpack' }
local animaSpellID = { [347555] = 3, [345706] = 5, [336327] = 35, [336456] = 250 }

local function sortFunction(a, b)
	return a.amount > b.amount
end

local function deleteCharacter(self, realm, name)
	ElvDB.gold[realm][name] = nil
	ElvDB.class[realm][name] = nil
	ElvDB.faction[realm][name] = nil

	if name == E.myname and realm == E.myrealm then
		OnEvent(self)
	end
end

local function OnClick(self, btn)
	if btn == 'RightButton' then
		if IsShiftKeyDown() then
			wipe(menuList)
			tinsert(menuList, { text = 'Delete Character', isTitle = true, notCheckable = true })
			for realm in pairs(ElvDB.serverID[E.serverID]) do
				for name in pairs(ElvDB.gold[realm]) do
					tinsert(menuList, {
						text = format('%s - %s', name, realm),
						notCheckable = true,
						func = function()
							deleteCharacter(self, realm, name)
						end
					})
				end
			end

			DT:SetEasyMenuAnchor(DT.EasyMenu, self)
			_G.EasyMenu(menuList, DT.EasyMenu, nil, nil, nil, 'MENU')
		elseif IsControlKeyDown() then
			Profit = 0
			Spent = 0
		end
	else
		_G.ToggleCharacter('TokenFrame')
	end
end

local function GetInfo(id)
	local info = C_CurrencyInfo_GetCurrencyInfo(id)
	if info then
		return info.name, info.quantity, info.maxQuantity, (info.iconFileID and format(iconString, info.iconFileID)) or '136012'
	end
end

local function AddInfo(id)
	local name, num, max, icon = GetInfo(id)
	if name then
		local textRight = '%s'
		if E.global.datatexts.settings.Currencies.maxCurrency and max and max > 0 then
			textRight = '%s / '..BreakUpLargeNumbers(max)
		end
		DT.tooltip:AddDoubleLine(format('%s %s', icon, name), format(textRight, BreakUpLargeNumbers(num)), 1, 1, 1, 1, 1, 1)
	end
end

-- ElvUI Currencies Function
local shownHeaders = {}
local function AddHeader(id, addLine)
	if (not E.global.datatexts.settings.Currencies.headers) or shownHeaders[id] then return end

	if addLine then
		DT.tooltip:AddLine(' ')
	end

	DT.tooltip:AddLine(E.global.datatexts.settings.Currencies.tooltipData[id][1])
	shownHeaders[id] = true
end

local goldText
local function OnEvent(self)
	if not IsLoggedIn() then return end

	if E.Retail and not Ticker then
		C_WowTokenPublic_UpdateMarketPrice()
		Ticker = C_Timer_NewTicker(60, C_WowTokenPublic_UpdateMarketPrice)
	end

	ElvDB = ElvDB or {}

	ElvDB.gold = ElvDB.gold or {}
	ElvDB.gold[E.myrealm] = ElvDB.gold[E.myrealm] or {}

	ElvDB.class = ElvDB.class or {}
	ElvDB.class[E.myrealm] = ElvDB.class[E.myrealm] or {}
	ElvDB.class[E.myrealm][E.myname] = E.myclass

	ElvDB.faction = ElvDB.faction or {}
	ElvDB.faction[E.myrealm] = ElvDB.faction[E.myrealm] or {}
	ElvDB.faction[E.myrealm][E.myname] = E.myfaction

	ElvDB.serverID = ElvDB.serverID or {}
	ElvDB.serverID[E.serverID] = ElvDB.serverID[E.serverID] or {}
	ElvDB.serverID[E.serverID][E.myrealm] = true

	--prevent an error possibly from really old profiles
	local oldMoney = ElvDB.gold[E.myrealm][E.myname]
	if oldMoney and type(oldMoney) ~= 'number' then
		ElvDB.gold[E.myrealm][E.myname] = nil
		oldMoney = nil
	end

	local NewMoney = GetMoney()
	ElvDB.gold[E.myrealm][E.myname] = NewMoney

	local OldMoney = oldMoney or NewMoney
	local Change = NewMoney-OldMoney -- Positive if we gain money
	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	goldText = E:FormatMoney(GetMoney(), E.global.datatexts.settings.Currencies.goldFormat or 'BLIZZARD', not E.global.datatexts.settings.Currencies.goldCoins)

	local displayed = E.global.datatexts.settings.Currencies.displayedCurrency
	if displayed == 'BACKPACK' then
		local displayString
		for i = 1, 3 do
			local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
			if info and info.quantity then
				displayString = (i > 1 and displayString..' ' or '')..format('%s %s', format(iconString, info.iconFileID), E:ShortValue(info.quantity))
			end
		end

		self.text:SetText(displayString or goldText)
	elseif displayed == 'GOLD' then
		self.text:SetText(goldText)
	else
		local id = tonumber(displayed)
		if not id then return end

		local name, num, _, icon = GetInfo(id)
		if not name then return end

		local style = E.global.datatexts.settings.Currencies.displayStyle
		if style == 'ICON' then
			self.text:SetFormattedText('%s %s', icon, E:ShortValue(num))
		elseif style == 'ICON_TEXT' then
			self.text:SetFormattedText('%s %s %s', icon, name, E:ShortValue(num))
		else --ICON_TEXT_ABBR
			self.text:SetFormattedText('%s %s %s', icon, E:AbbreviateString(name), E:ShortValue(num))
		end
	end
end

local function getTotalAnima()
	local total = 0

	for i = 0, NUM_BAG_SLOTS do
		local bagName = GetBagName(i)
		if bagName then
			for slotID = 1, GetContainerNumSlots(i) do
				local link = GetContainerItemLink(i, slotID)
				local count = select(2, GetContainerItemInfo(i, slotID))

				if link and C_Item_IsAnimaItemByID(link) then
					local _, spellID = GetItemSpell(link)
					total = total + animaSpellID[spellID] * count
				end
			end
		end
	end

	return total
end

local myGold = {}
local function OnEnter()
	DT.tooltip:ClearLines()

	local textOnly = not E.global.datatexts.settings.Gold.goldCoins and true or false
	local style = E.global.datatexts.settings.Gold.goldFormat or 'BLIZZARD'

	DT.tooltip:AddLine(L["Session:"])
	DT.tooltip:AddDoubleLine(L["Earned:"], E:FormatMoney(Profit, style, textOnly), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Spent:"], E:FormatMoney(Spent, style, textOnly), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		DT.tooltip:AddDoubleLine(L["Deficit:"], E:FormatMoney(Profit-Spent, style, textOnly), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		DT.tooltip:AddDoubleLine(L["Profit:"], E:FormatMoney(Profit-Spent, style, textOnly), 0, 1, 0, 1, 1, 1)
	end
	DT.tooltip:AddLine(' ')

	local totalGold, totalHorde, totalAlliance = 0, 0, 0
	DT.tooltip:AddLine(L["Character: "])

	wipe(myGold)
	for realm in pairs(ElvDB.serverID[E.serverID]) do
		for k, _ in pairs(ElvDB.gold[realm]) do
			if ElvDB.gold[realm][k] then
				local color = E:ClassColor(ElvDB.class[realm][k]) or PRIEST_COLOR
				tinsert(myGold,
					{
						name = k,
						realm = realm,
						amount = ElvDB.gold[realm][k],
						amountText = E:FormatMoney(ElvDB.gold[realm][k], style, textOnly),
						faction = ElvDB.faction[realm][k] or '',
						r = color.r, g = color.g, b = color.b,
					}
				)
			end

			if ElvDB.faction[realm][k] == 'Alliance' then
				totalAlliance = totalAlliance+ElvDB.gold[realm][k]
			elseif ElvDB.faction[realm][k] == 'Horde' then
				totalHorde = totalHorde+ElvDB.gold[realm][k]
			end

			totalGold = totalGold+ElvDB.gold[realm][k]
		end
	end

	sort(myGold, sortFunction)

	for _, g in ipairs(myGold) do
		local nameLine = ''
		if g.faction ~= '' and g.faction ~= 'Neutral' then
			nameLine = format('|TInterface/FriendsFrame/PlusManz-%s:14|t ', g.faction)
		end

		local toonName = format('%s%s%s', nameLine, g.name, (g.realm and g.realm ~= E.myrealm and ' - '..g.realm) or '')
		DT.tooltip:AddDoubleLine((g.name == E.myname and toonName..' |TInterface/COMMON/Indicator-Green:14|t') or toonName, g.amountText, g.r, g.g, g.b, 1, 1, 1)
	end

	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(L["Server: "])
	if totalAlliance > 0 and totalHorde > 0 then
		if totalAlliance ~= 0 then DT.tooltip:AddDoubleLine(L["Alliance: "], E:FormatMoney(totalAlliance, style, textOnly), 0, .376, 1, 1, 1, 1) end
		if totalHorde ~= 0 then DT.tooltip:AddDoubleLine(L["Horde: "], E:FormatMoney(totalHorde, style, textOnly), 1, .2, .2, 1, 1, 1) end
		DT.tooltip:AddLine(' ')
	end
	DT.tooltip:AddDoubleLine(L["Total: "], E:FormatMoney(totalGold, style, textOnly), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddLine(' ')

	wipe(shownHeaders)
	local addLine, addLine2
	for _, info in ipairs(E.global.datatexts.settings.Currencies.tooltipData) do
		local _, id, header = unpack(info)
		if id and E.global.datatexts.settings.Currencies.idEnable[id] then
			AddHeader(header, addLine)
			AddInfo(id)
			addLine = true
		end
	end

	if addLine then
		DT.tooltip:AddLine(' ')
	end

	for _, info in pairs(E.global.datatexts.customCurrencies) do
		if info and not DT.CurrencyList[tostring(info.ID)] and info.DISPLAY_IN_MAIN_TOOLTIP then
			AddInfo(info.ID)
			addLine2 = true
		end
	end

	if addLine2 then
		DT.tooltip:AddLine(' ')
	end

	local anima = getTotalAnima()
	if anima > 0 then
		DT.tooltip:AddDoubleLine(L["Anima:"], anima, 0, .8, 1, 1, 1, 1)

		DT.tooltip:AddLine(' ')
	end

	DT.tooltip:AddDoubleLine(L["WoW Token:"], E:FormatMoney(C_WowTokenPublic_GetCurrentMarketPrice() or 0, style, textOnly), 0, .8, 1, 1, 1, 1)

	-- ElvUI Gold DT -> Watched Backpack Currencies
	-- for i = 1, MAX_WATCHED_TOKENS do
	-- 	local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
	-- 	if info then
	-- 		if i == 1 then
	-- 			DT.tooltip:AddLine(' ')
	-- 			DT.tooltip:AddLine(CURRENCY)
	-- 		end
	-- 		if info.quantity then
	-- 			DT.tooltip:AddDoubleLine(format('%s %s', format(iconString, info.iconFileID), info.name), BreakUpLargeNumbers(info.quantity), 1, 1, 1, 1, 1, 1)
	-- 		end
	-- 	end
	-- end
	local grayValue = B:GetGraysValue()
	if grayValue > 0 then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Grays"], E:FormatMoney(grayValue, style, textOnly), nil, nil, nil, 1, 1, 1)
	end

	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(resetCountersFormatter)
	DT.tooltip:AddLine(resetInfoFormatter)
	DT.tooltip:Show()
end

hooksecurefunc(DT, 'ForceUpdate_DataText', function(_, name)
	if name and name == 'Currencies' then
		for dtSlot, dtName in pairs(DT.AssignedDatatexts) do
			if dtName.name == 'S&L Currencies' then
				if dtName.colorUpdate then
					dtName.colorUpdate(E.media.hexvaluecolor)
				end
				if dtName.eventFunc then
					dtName.eventFunc(dtSlot, 'ELVUI_FORCE_UPDATE')
				end
			end
		end
	end
end)

DT:RegisterDatatext('S&L Currencies', nil, {'PLAYER_MONEY', 'SEND_MAIL_MONEY_CHANGED', 'SEND_MAIL_COD_CHANGED', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED', 'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, OnClick, OnEnter, nil, 'S&L '.._G.CURRENCY)
