local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')
local SLE = E:GetModule('SLE')

local format, floor, abs, mod, pairs, tinsert = format, floor, abs, mod, pairs, tinsert
local GetMoney, GetCurrencyInfo, GetNumWatchedTokens, GetBackpackCurrencyInfo, UnitLevel, GetCurrencyListInfo = GetMoney, GetCurrencyInfo, GetNumWatchedTokens, GetBackpackCurrencyInfo, UnitLevel, GetCurrencyListInfo

local join = string.join

local defaultColor = { 1, 1, 1 }
local Profit	= 0
local Spent		= 0
local copperFormatter = join("", "%d", L.copperabbrev)
local silverFormatter = join("", "%d", L.silverabbrev, " %.2d", L.copperabbrev)
local goldFormatter =  join("", "%s", L.goldabbrev, " %.2d", L.silverabbrev, " %.2d", L.copperabbrev)
local resetInfoFormatter = join("", "|cffaaaaaa", L["Reset Data: Hold Shift + Right Click"], "|r")
local JEWELCRAFTING, COOKING, ARCHAEOLOGY

local ArchaeologyFragments = { 398, 384, 393, 677, 400, 394, 397, 676, 401, 385, 399 }
local CookingAwards = { 81, 402 }
local JewelcraftingTokens = { 61, 361, 698 }
local DungeonRaid = { 776, 752, 697, 738, 615, 614, 395, 396 }
local PvPPoints = { 390, 392, 391 }
local MiscellaneousCurrency = { 241, 416, 515, 777 }

local _, Faction = UnitFactionGroup('player')
local HordeColor = RAID_CLASS_COLORS['DEATHKNIGHT']
local AllianceColor = RAID_CLASS_COLORS['SHAMAN']

local function OrderedPairs(t, f)
	local function orderednext(t, n)
		local key = t[t.__next]
		if not key then return end
		t.__next = t.__next + 1
		return key, t.__source[key]
	end

	local keys, kn = {__source = t, __next = 1}, 1
	for k in pairs(t) do
		keys[kn], kn = k, kn + 1
	end
	sort(keys, f)
	return orderednext, keys
end

V['ElvUI_Currency'] = {
	['Archaeology'] = true,
	['Jewelcrafting'] = true,
	['PvP'] = true,
	['Raid'] = true,
	['Cooking'] = true,
	['Miscellaneous'] = true,
	['Zero'] = true,
	['Icons'] = true,
	['Faction'] = true,
	['Unused'] = true,
}

local function ToggleOption(name)
	if E.private['ElvUI_Currency'][name] then
		E.private['ElvUI_Currency'][name] = false
	else
		E.private['ElvUI_Currency'][name] = true
	end
end

local function GetOption(name)
	return E.private['ElvUI_Currency'][name]
end

local menu = {
	{ text = L['ElvUI Improved Currency Options'], isTitle = true , notCheckable = true },
	{ text = L['Show Archaeology Fragments'], checked = function() return GetOption('Archaeology') end, func = function() ToggleOption('Archaeology') end },
	{ text = L['Show Jewelcrafting Tokens'], checked = function()  return GetOption('Jewelcrafting') end, func = function() ToggleOption('Jewelcrafting') end },
	{ text = L['Show Player vs Player Currency'], checked = function() return GetOption('PvP') end, func = function() ToggleOption('PvP') end },
	{ text = L['Show Dungeon and Raid Currency'], checked = function() return GetOption('Raid') end, func = function() ToggleOption('Raid') end },
	{ text = L['Show Cooking Awards'], checked = function() return GetOption('Cooking') end, func = function() ToggleOption('Cooking') end },
	{ text = L['Show Miscellaneous Currency'], checked = function() return GetOption('Miscellaneous') end, func = function() ToggleOption('Miscellaneous') end },
	{ text = L['Show Zero Currency'], checked = function() return GetOption('Zero') end, func = function() ToggleOption('Zero') end },
	{ text = L['Show Icons'], checked = function() return GetOption('Icons') end, func = function() ToggleOption('Icons') end },
	{ text = L['Show Faction Totals'], checked = function() return GetOption('Faction') end, func = function() ToggleOption('Faction') end },
	{ text = L['Show Unsed Currency'], checked = function() return GetOption('Unused') end, func = function() ToggleOption('Unused') end },
}

local HiddenCurrency = {}

local function UnusedCheck()
	if GetOption('Unused') then HiddenCurrency = {}; return end
	for i = 1, GetCurrencyListSize() do
		local name, _, _, isUnused = GetCurrencyListInfo(i)
		if isUnused then
			if not SLE:SimpleTable(HiddenCurrency, name) then
				table.insert(HiddenCurrency,#(HiddenCurrency)+1, name)
			end
		else
			if SLE:SimpleTable(HiddenCurrency, name) then
				HiddenCurrency[i] = nil
			end
		end
	end
end

local menuFrame = CreateFrame("Frame", "ElvUI_CurrencyMenuFrame", UIParent, 'UIDropDownMenuTemplate')

local function GetCurrency(CurrencyTable, Text)
	local Seperator = false
	UnusedCheck()
	for key, id in pairs(CurrencyTable) do
		local name, amount, texture, week, weekmax, maxed, discovered = GetCurrencyInfo(id)
		local LeftString = GetOption('Icons') and format('%s %s', format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture), name) or name
		local RightString = amount
		local unused = SLE:SimpleTable(HiddenCurrency, name) or nil
		
		if id == 392 or id == 395 then
			maxed = 4000
		elseif id == 396 then
			maxed = 3000
		end

		if id == 390 then
			discovered = UnitLevel('player') >= SHOW_CONQUEST_LEVEL
			RightString = format('%s %s | %s %s / %s', L['Current:'], amount, L['Weekly:'], week, weekmax)
		elseif maxed <= 4000 and maxed > 0 then
			RightString = format('%s / %s', amount, maxed)
		end

		local r1, g1, b1 = 1, 1, 1
		for i = 1, GetNumWatchedTokens() do
			local _, _, _, itemID = GetBackpackCurrencyInfo(i)
			if id == itemID then
				r1, g1, b1 = .24, .54, .78
			end
		end
		local r2, g2, b2 = r1, g1, b1
		if maxed > 0 and (amount == maxed) or weekmax > 0 and (week == weekmax) then r2, g2, b2 = .77, .12, .23 end
		if not (amount == 0 and not GetOption('Zero') and r1 == 1) and discovered and not unused then
			if not Seperator then
				DT.tooltip:AddLine(' ')
				DT.tooltip:AddLine(Text)
				Seperator = true
			end
			DT.tooltip:AddDoubleLine(LeftString, RightString, r1, g1, b1, r2, g2, b2)
		end
	end
end

local function FormatMoney(money)
	local gold, silver, copper = floor(abs(money / 10000)), abs(mod(money / 100, 100)), abs(mod(money, 100))
	if gold ~= 0 then
		return format(goldFormatter, BreakUpLargeNumbers(gold), silver, copper)
	elseif silver ~= 0 then
		return format(silverFormatter, silver, copper)
	else
		return format(copperFormatter, copper)
	end
end

local function FormatTooltipMoney(money)
	if not money then return end
	local gold, silver, copper = floor(abs(money / 10000)), abs(mod(money / 100, 100)), abs(mod(money, 100))
	return format(goldFormatter, BreakUpLargeNumbers(gold), silver, copper)
end

local function OnEvent(self, event, ...)
	if not IsLoggedIn() then return end
	local NewMoney = GetMoney();
	ElvDB = ElvDB or { };
	ElvDB['gold'] = ElvDB['gold'] or {};
	ElvDB['gold'][E.myrealm] = ElvDB['gold'][E.myrealm] or {};
	ElvDB['gold'][E.myrealm][E.myname] = ElvDB['gold'][E.myrealm][E.myname] or NewMoney;
	ElvDB['class'] = ElvDB['class'] or {};
	ElvDB['class'][E.myrealm] = ElvDB['class'][E.myrealm] or {};
	ElvDB['class'][E.myrealm][E.myname] = select(2, UnitClass('player'))
	ElvDB['faction'] = ElvDB['faction'] or {};
	ElvDB['faction'][E.myrealm] = ElvDB['faction'][E.myrealm] or {};
	ElvDB['faction'][E.myrealm][FACTION_HORDE] = ElvDB['faction'][E.myrealm][FACTION_HORDE] or {};
	ElvDB['faction'][E.myrealm][FACTION_ALLIANCE] = ElvDB['faction'][E.myrealm][FACTION_ALLIANCE] or {};

	local OldMoney = ElvDB['gold'][E.myrealm][E.myname] or NewMoney

	local Change = NewMoney-OldMoney -- Positive if we gain money
	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	self.text:SetText(FormatMoney(NewMoney))
	
	ElvDB['gold'][E.myrealm][E.myname] = NewMoney
	ElvDB['faction'][E.myrealm][Faction][E.myname] = NewMoney
	if event == 'PLAYER_ENTERING_WORLD' or event == 'SPELLS_CHANGED' then
		JEWELCRAFTING = nil
		for k, v in pairs({GetProfessions()}) do
			if v then
				local name, _, _, _, _, _, skillid = GetProfessionInfo(v)
				if skillid == 755 then
					JEWELCRAFTING = name
				elseif skillid == 185 then
					COOKING = name
				elseif skillid == 794 then
					ARCHAEOLOGY = name
				end
			end
		end
	end
end

local function Click(self, btn)
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			ElvDB.gold = nil;
			OnEvent(self)
			DT.tooltip:Hide();
		else
			EasyMenu(menu, menuFrame, 'cursor', 0, 0, 'MENU', 2)
			--[[
			menuFrame.point = 'CENTER'
			menuFrame.relativePoint = 'CENTER'
			E:DropDown(menu, menuFrame);]]
		end
	else
		ToggleAllBags()
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddLine(L['Session:'])
	DT.tooltip:AddDoubleLine(L["Earned:"], FormatMoney(Profit), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Spent:"], FormatMoney(Spent), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		DT.tooltip:AddDoubleLine(L["Deficit:"], FormatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		DT.tooltip:AddDoubleLine(L["Profit:"], FormatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
	end
	DT.tooltip:AddLine' '

	local totalGold, AllianceGold, HordeGold = 0, 0, 0
	DT.tooltip:AddLine(L["Character: "])
	for k,_ in OrderedPairs(ElvDB['gold'][E.myrealm]) do
		if ElvDB['gold'][E.myrealm][k] then
			local class = ElvDB['class'][E.myrealm][k]
			local color = RAID_CLASS_COLORS[class or 'PRIEST']
			DT.tooltip:AddDoubleLine(k, FormatTooltipMoney(ElvDB['gold'][E.myrealm][k]), color.r, color.g, color.b, 1, 1, 1)
			if ElvDB['faction'][E.myrealm][FACTION_ALLIANCE][k] then
				AllianceGold = AllianceGold + ElvDB['gold'][E.myrealm][k]
			end
			if ElvDB['faction'][E.myrealm][FACTION_HORDE][k] then
				HordeGold = HordeGold + ElvDB['gold'][E.myrealm][k]
			end
			totalGold = totalGold + ElvDB['gold'][E.myrealm][k]
		end
	end

	DT.tooltip:AddLine' '
	DT.tooltip:AddLine(L["Server: "])
	if GetOption('Faction') then
		DT.tooltip:AddDoubleLine(format('%s: ', FACTION_HORDE), FormatTooltipMoney(HordeGold), HordeColor.r, HordeColor.g, HordeColor.b, 1, 1, 1)
		DT.tooltip:AddDoubleLine(format('%s: ', FACTION_ALLIANCE), FormatTooltipMoney(AllianceGold), AllianceColor.r, AllianceColor.g, AllianceColor.b, 1, 1, 1)
	end
	DT.tooltip:AddDoubleLine(L["Total: "], FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

	if ARCHAEOLOGY ~= nil and GetOption('Archaeology') then
		GetCurrency(ArchaeologyFragments, format('%s %s:', ARCHAEOLOGY, ARCHAEOLOGY_RUNE_STONES))
	end
	if COOKING ~= nil and GetOption('Cooking') then
		GetCurrency(CookingAwards, format("%s:", COOKING))
	end
	if JEWELCRAFTING ~= nil and GetOption('Jewelcrafting') then
		GetCurrency(JewelcraftingTokens, format("%s:", JEWELCRAFTING))
	end
	if GetOption('Raid') then
		GetCurrency(DungeonRaid, format('%s & %s:', CALENDAR_TYPE_DUNGEON, CALENDAR_TYPE_RAID))
	end
	if GetOption('PvP') then
		GetCurrency(PvPPoints, format("%s:", PLAYER_V_PLAYER))
	end
	if GetOption('Miscellaneous') then
		GetCurrency(MiscellaneousCurrency, format("%s:", MISCELLANEOUS))
	end
	
	DT.tooltip:AddLine' '
	DT.tooltip:AddLine(resetInfoFormatter)

	DT.tooltip:Show()
end

DT:RegisterDatatext('S&L '..CURRENCY, {'PLAYER_ENTERING_WORLD', 'PLAYER_MONEY', 'SEND_MAIL_MONEY_CHANGED', 'SEND_MAIL_COD_CHANGED', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED', 'SPELLS_CHANGED'}, OnEvent, nil, Click, OnEnter)