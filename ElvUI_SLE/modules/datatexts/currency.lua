local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DT = E.DataTexts
local B = E.Bags

local _G = _G
local type, tonumber, wipe, pairs, ipairs, sort = type, tonumber, wipe, pairs, ipairs, sort
local format, strjoin, tostring, tinsert = format, strjoin, tostring, tinsert

local GetMoney = GetMoney
local IsControlKeyDown, IsShiftKeyDown = IsControlKeyDown, IsShiftKeyDown
local IsLoggedIn = IsLoggedIn
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_WowTokenPublic_UpdateMarketPrice = C_WowTokenPublic.UpdateMarketPrice
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice
local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetBagName = C_Container.GetBagName
local C_Item_IsAnimaItemByID = C_Item.IsAnimaItemByID
local C_Timer_NewTicker = C_Timer.NewTicker
local GetItemSpell = GetItemSpell

local FetchDepositedMoney = C_Bank and C_Bank.FetchDepositedMoney
local WARBANDBANK_TYPE = (Enum.BankType and Enum.BankType.Account) or 2

local BONUS_ROLL_REWARD_MONEY = BONUS_ROLL_REWARD_MONEY
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS or 3
local CURRENCY = CURRENCY
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

local Profit, Spent, Ticker, goldText = 0, 0
local resetCountersFormatter = strjoin('', '|cffaaaaaa', L["Reset Session Data: Hold Ctrl + Right Click"], '|r')
local resetInfoFormatter = strjoin('', '|cffaaaaaa', L["Reset Character Data: Hold Shift + Right Click"], '|r')

local menuList, myGold = {}, {}
local animaSpellID = { [347555] = 3, [345706] = 5, [336327] = 35, [336456] = 250 }
local warbandGold, totalGold, totalHorde, totalAlliance = 0, 0, 0, 0
local iconString = '|T%s:16:16:0:0:64:64:4:60:4:60|t'
DT.CurrencyList = { GOLD = BONUS_ROLL_REWARD_MONEY, BACKPACK = 'Backpack' }

local function deleteCharacter(_, realm, name)
	ElvDB.gold[realm][name] = nil
	ElvDB.class[realm][name] = nil
	ElvDB.faction[realm][name] = nil

	DT:ForceUpdate_DataText('S&L Currencies')
end

local function OnClick(self, btn)
	if btn == 'RightButton' then
		if IsShiftKeyDown() then
			E:SetEasyMenuAnchor(E.EasyMenu, self)
			E:ComplicatedMenu(menuList, E.EasyMenu, nil, nil, nil, 'MENU')
		elseif IsControlKeyDown() then
			Profit = 0
			Spent = 0
		end
	else
		_G.ToggleCharacter('TokenFrame')
	end
end

local function AddInfo(id)
	local info, name, icon = DT:CurrencyInfo(id)
	if name then
		local textRight = '%s'
		if E.global.datatexts.settings.Currencies.maxCurrency and info.maxQuantity and info.maxQuantity > 0 then
			textRight = '%s / '..BreakUpLargeNumbers(info.maxQuantity)
		end

		DT.tooltip:AddDoubleLine(format('%s %s', icon, name), format(textRight, BreakUpLargeNumbers(info.quantity)), 1, 1, 1, 1, 1, 1)
	end
end

local shownHeaders = {}
local function AddHeader(id, addLine)
	if (not E.global.datatexts.settings.Currencies.headers) or shownHeaders[id] then return end

	if addLine then
		DT.tooltip:AddLine(' ')
	end

	DT.tooltip:AddLine(E.global.datatexts.settings.Currencies.tooltipData[id][1])
	shownHeaders[id] = true
end

local function sortFunction(a, b)
	return a.amount > b.amount
end

local function updateTotal(faction, change)
	if faction == 'Alliance' then
		totalAlliance = totalAlliance + change
	elseif faction == 'Horde' then
		totalHorde = totalHorde + change
	end

	totalGold = totalGold + change
end

local function updateGold(self, updateAll, goldChange)
	local textOnly = not E.global.datatexts.settings.Gold.goldCoins and true or false
	local style = E.global.datatexts.settings.Gold.goldFormat or 'BLIZZARD'

	if updateAll then
		wipe(myGold)
		wipe(menuList)

		totalGold, totalHorde, totalAlliance = 0, 0, 0

		tinsert(menuList, { text = '', isTitle = true, notCheckable = true })
		tinsert(menuList, { text = 'Delete Character', isTitle = true, notCheckable = true })

		local realmN = 1
		for realm in pairs(ElvDB.serverID[E.serverID]) do
			tinsert(menuList, realmN, { text = 'Delete All - '..realm, notCheckable = true, func = function() ElvDB.gold[realm] = {} DT:ForceUpdate_DataText('S&L Currencies') end })
			realmN = realmN + 1
			for name in pairs(ElvDB.gold[realm]) do
				local faction = ElvDB.faction[realm][name]
				local gold = ElvDB.gold[realm][name]

				if gold then
					local color = E:ClassColor(ElvDB.class[realm][name]) or PRIEST_COLOR

					tinsert(myGold, {
							name = name,
							realm = realm,
							amount = gold,
							amountText = E:FormatMoney(gold, style, textOnly),
							faction = faction or '',
							r = color.r, g = color.g, b = color.b,
					})

					tinsert(menuList, {
						text = format('%s - %s', name, realm),
						notCheckable = true,
						func = function() deleteCharacter(self, realm, name) end
					})

					updateTotal(faction, gold)
				end
			end
		end
	else
		for _, info in ipairs(myGold) do
			if info.name == E.myname and info.realm == E.myrealm then
				info.amount = ElvDB.gold[E.myrealm][E.myname]
				info.amountText = E:FormatMoney(ElvDB.gold[E.myrealm][E.myname], style, textOnly)

				break
			end
		end

		if goldChange then
			updateTotal(E.myfaction, goldChange)
		end
	end
end

local function UpdateWarbandGold()
	warbandGold = FetchDepositedMoney(WARBANDBANK_TYPE)
end

local function UpdateMarketPrice()
	return C_WowTokenPublic_UpdateMarketPrice()
end

local function OnEvent(self, event)
	if not IsLoggedIn() then return end

	if E.Retail then
		UpdateWarbandGold()

		if not Ticker then
			C_WowTokenPublic_UpdateMarketPrice()
			Ticker = C_Timer_NewTicker(60, UpdateMarketPrice)
		end
	end

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

	updateGold(self, event == 'ELVUI_FORCE_UPDATE', Change)

	goldText = E:FormatMoney(GetMoney(), E.global.datatexts.settings.Currencies.goldFormat or 'BLIZZARD', not E.global.datatexts.settings.Currencies.goldCoins)

	local displayed = E.global.datatexts.settings.Currencies.displayedCurrency
	if displayed == 'BACKPACK' then
		local displayString
		for i = 1, 3 do
			local info = DT:BackpackCurrencyInfo(i)
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

		local info, name, icon = DT:CurrencyInfo(id)
		if not name then return end

		local style = E.global.datatexts.settings.Currencies.displayStyle
		if style == 'ICON' then
			self.text:SetFormattedText('%s %s', icon, E:ShortValue(info.quantity))
		elseif style == 'ICON_TEXT' then
			self.text:SetFormattedText('%s %s %s', icon, name, E:ShortValue(info.quantity))
		else --ICON_TEXT_ABBR
			self.text:SetFormattedText('%s %s %s', icon, E:AbbreviateString(name), E:ShortValue(info.quantity))
		end
	end
end

local function OnEnter()
	DT.tooltip:ClearLines()

	local textOnly = not E.global.datatexts.settings.Gold.goldCoins and true or false
	local style = E.global.datatexts.settings.Gold.goldFormat or 'BLIZZARD'

	DT.tooltip:AddLine(L["Session:"])
	DT.tooltip:AddDoubleLine(L["Earned:"], E:FormatMoney(Profit, style, textOnly), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Spent:"], E:FormatMoney(Spent, style, textOnly), 1, 1, 1, 1, 1, 1)

	if Spent ~= 0 then
		local gained = Profit > Spent
		DT.tooltip:AddDoubleLine(gained and L["Profit:"] or L["Deficit:"], E:FormatMoney(Profit-Spent, style, textOnly), gained and 0 or 1, gained and 1 or 0, 0, 1, 1, 1)
	end

	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(L["Character: "])

	sort(myGold, sortFunction)

	local maxLimit = E.global.datatexts.settings.Gold.maxLimit

	local total, limit = #myGold, maxLimit
	local useLimit = limit > 0
	for i, g in ipairs(myGold) do
		if useLimit and i > limit then
			local count = total - limit
			if count > 1 then
				DT.tooltip:AddLine(format('+%d %s', count, L["Hidden Characters"]), 0.75, 0.9, 1)
			end

			break
		end

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

	for id, info in pairs(E.global.datatexts.customCurrencies) do
		if info and not DT.CurrencyList[tostring(id)] and info.currencyTooltip then
			AddInfo(id)
			addLine2 = true
		end
	end

	if addLine2 then
		DT.tooltip:AddLine(' ')
	end

	if E.Retail then
		DT.tooltip:AddDoubleLine(L["Warband:"], E:FormatMoney(warbandGold or 0, style, textOnly), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["WoW Token:"], E:FormatMoney(C_WowTokenPublic_GetCurrentMarketPrice() or 0, style, textOnly), 0, .8, 1, 1, 1, 1)
	end

	if E.Retail or E.Wrath then
		for i = 1, MAX_WATCHED_TOKENS do
			local info, name = DT:BackpackCurrencyInfo(i)
			if not name then break end

			if i == 1 then
				DT.tooltip:AddLine(' ')
				DT.tooltip:AddLine(CURRENCY)
			end

			if info.quantity then
				DT.tooltip:AddDoubleLine(format(iconString, info.iconFileID, name), info.quantity, 1, 1, 1, 1, 1, 1)
			end
		end
	end

	local grayValue = B:GetGraysValue()
	if grayValue > 0 then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Grays"], E:FormatMoney(grayValue, style, textOnly), nil, nil, nil, 1, 1, 1)
	end

	DT.tooltip:AddLine(' ')
	DT.tooltip:AddDoubleLine(L["Gold"]..':', goldText, nil, nil, nil, 1, 1, 1)
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
