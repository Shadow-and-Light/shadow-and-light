local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

local _G = _G
local unpack = unpack
local format, ipairs, tonumber = format, ipairs, tonumber
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetBackpackCurrencyInfo = GetBackpackCurrencyInfo
local GetCurrencyInfo = GetCurrencyInfo
local GetMoney = GetMoney
local C_WowTokenPublic_UpdateMarketPrice = C_WowTokenPublic.UpdateMarketPrice
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice
local C_Timer_NewTicker = C_Timer.NewTicker

local BONUS_ROLL_REWARD_MONEY = BONUS_ROLL_REWARD_MONEY
local EXPANSION_NAME7 = EXPANSION_NAME7
local OTHER = OTHER
local Profit, Spent = 0, 0

local iconString = '|T%s:16:16:0:0:64:64:4:60:4:60|t'
DT.CurrencyList = { GOLD = BONUS_ROLL_REWARD_MONEY, BACKPACK = 'Backpack' }

local function OnClick()
	_G.ToggleCharacter('TokenFrame')
end

local function GetInfo(id)
	local name, num, icon = GetCurrencyInfo(id)
	return name, num, (icon and format(iconString, icon)) or '136012'
end

local function AddInfo(id)
	local name, num, icon = GetInfo(id)
	if name then
		DT.tooltip:AddDoubleLine(format('%s %s', icon, name), BreakUpLargeNumbers(num), 1, 1, 1, 1, 1, 1)
	end
end

local function sortFunction(a, b)
	return a.amount > b.amount
end

local goldText
local function OnEvent(self)
	if not IsLoggedIn() then return end

	if not Ticker then
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
	
	goldText = E:FormatMoney(ElvDB.gold[E.myrealm][E.myname], E.db.datatexts.goldFormat or 'BLIZZARD', not E.db.datatexts.goldCoins)

	local displayed = E.db.datatexts.currencies.displayedCurrency
	if displayed == 'BACKPACK' then
		local displayString = ''
		for i = 1, 3 do
			local _, num, icon = GetBackpackCurrencyInfo(i)
			if num then
				displayString = (i > 1 and displayString..' ' or displayString)..format('%s %s', format(iconString, icon), E:ShortValue(num))
			end
		end

		self.text:SetText(displayString == '' and goldText or displayString)
	elseif displayed == 'GOLD' then
		self.text:SetText(goldText)
	else
		local id = tonumber(displayed)
		if not id then return end

		local name, num, icon = GetInfo(id)
		if not name then return end

		local style = E.db.datatexts.currencies.displayStyle
		if style == 'ICON' then
			self.text:SetFormattedText('%s %s', icon, E:ShortValue(num))
		elseif style == 'ICON_TEXT' then
			self.text:SetFormattedText('%s %s %s', icon, name, E:ShortValue(num))
		else --ICON_TEXT_ABBR
			self.text:SetFormattedText('%s %s %s', icon, E:AbbreviateString(name), E:ShortValue(num))
		end
	end
end

local myGold = {}
local function OnEnter(self)
	DT:SetupTooltip(self)

	local addLine, goldSpace

	local textOnly = not E.db.datatexts.goldCoins and true or false
	local style = E.db.datatexts.goldFormat or 'BLIZZARD'

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
	for k,_ in pairs(ElvDB.gold[E.myrealm]) do
		if ElvDB.gold[E.myrealm][k] then
			local color = E:ClassColor(ElvDB.class[E.myrealm][k]) or PRIEST_COLOR
			tinsert(myGold,
				{
					name = k,
					amount = ElvDB.gold[E.myrealm][k],
					amountText = E:FormatMoney(ElvDB.gold[E.myrealm][k], style, textOnly),
					faction = ElvDB.faction[E.myrealm][k] or '',
					r = color.r, g = color.g, b = color.b,
				}
			)
		end

		if ElvDB.faction[E.myrealm][k] == 'Alliance' then
			totalAlliance = totalAlliance+ElvDB.gold[E.myrealm][k]
		elseif ElvDB.faction[E.myrealm][k] == 'Horde' then
			totalHorde = totalHorde+ElvDB.gold[E.myrealm][k]
		end

		totalGold = totalGold+ElvDB.gold[E.myrealm][k]
	end

	sort(myGold, sortFunction)

	for _, g in ipairs(myGold) do
		local nameLine = ''
		if g.faction ~= '' and g.faction ~= 'Neutral' then
			nameLine = format('|TInterface/FriendsFrame/PlusManz-%s:14|t ', g.faction)
		end

		nameLine = g.name == E.myname and nameLine..g.name..' |TInterface/COMMON/Indicator-Green:14|t' or nameLine..g.name

		DT.tooltip:AddDoubleLine(nameLine, g.amountText, g.r, g.g, g.b, 1, 1, 1)
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
	DT.tooltip:AddLine(EXPANSION_NAME7) -- BfA
	AddInfo(1710) -- SEAFARERS_DUBLOON
	AddInfo(1580) -- SEAL_OF_WARTORN_FATE
	AddInfo(1560) -- WAR_RESOURCES
	AddInfo(E.myfaction == 'Alliance' and 1717 or 1716) -- 7th Legion or Honorbound
	AddInfo(1718) -- TITAN_RESIDUUM
	AddInfo(1721) -- PRISMATIC_MANAPEARL
	AddInfo(1719) -- CORRUPTED_MEMENTOS
	AddInfo(1755) -- COALESCING_VISIONS
	AddInfo(1803) -- ECHOES_OF_NYALOTHA
	DT.tooltip:AddLine(' ')

	DT.tooltip:AddLine(OTHER)
	AddInfo(515) -- DARKMOON_PRIZE_TICKET

	DT.tooltip:AddLine(' ')
	DT.tooltip:AddDoubleLine(L["WoW Token:"], E:FormatMoney(C_WowTokenPublic_GetCurrentMarketPrice() or 0, style, textOnly), 0, .8, 1, 1, 1, 1)

	DT.tooltip:Show()
end

DT:RegisterDatatext('S&L Currencies', nil, {'PLAYER_MONEY', 'SEND_MAIL_MONEY_CHANGED', 'SEND_MAIL_COD_CHANGED', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED', 'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, OnClick, OnEnter, nil, "S&L ".._G.CURRENCY)
