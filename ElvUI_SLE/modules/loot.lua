local E, L, V, P, G = unpack(ElvUI);
local LT = E:GetModule('SLE_Loot')
local M = E:GetModule('Misc')

local check = false
local t = 0
local n = 0
local loot, loottemp, numbers = {}, {}, {}
local MyName, UnitLevel = E.myname, UnitLevel
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local GetNumGroupMembers, GetRaidRosterInfo = GetNumGroupMembers, GetRaidRosterInfo
local GetLootSlotType, GetLootSlotLink, GetLootSlotInfo, GetLootRollItemInfo = GetLootSlotType, GetLootSlotLink, GetLootSlotInfo, GetLootRollItemInfo
local GetNumLootItems, GetItemInfo = GetNumLootItems, GetItemInfo
local IsLeftControlKeyDown = IsLeftControlKeyDown
local tremove = table.remove
local PlayerLevel, MaxPlayerLevel

local function Check()
	local name, rank, isML
	for x = 1, GetNumGroupMembers() do
		name, rank, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(x)
		if name == MyName and isML then
			return true
		elseif name == MyName and rank == 1 then
			return true
		elseif name == MyName and rank == 2 then
			return true
		end
	end
	return false
end

local function Merge()
	local p, k
	for i = 1, #loot do
		k = 1
		while loot[i] ~= loot[k] do k = k + 1 end
		if i ~= k then
			numbers[i] = numbers[i] + numbers[k]
			tremove(numbers, k)
			tremove(loot, k)
			n = n - 1
		end
	end
end

local function PopulateTable(q)
	local p, k
	for i = 1, GetNumLootItems() do
		if GetLootSlotType(i) == 1 then 
			local _, item, quantity, quality = GetLootSlotInfo(i)
			local link, ilvl

			if quality >= q then
				link = GetLootSlotLink(i)
				ilvl = select(4, GetItemInfo(link))
				
				n = n + 1
				loot[n] = link
				loot[n] = loot[n].." (ilvl: "..ilvl..")"
				numbers[n] = quantity
			end
		end
	end
	Merge()
end

local function Channel()
	local channel
	if E.db.sle.loot.announcer.channel ~= "SAY" and IsPartyLFG() then
		return "INSTANCE_CHAT"
	end
	if E.db.sle.loot.announcer.channel == "RAID" and not IsInRaid() then
		return "PARTY"
	end
	return E.db.sle.loot.announcer.channel
end

local function List()
	for i = 1, n do
		if numbers[i] == 1 then
			SendChatMessage(i..". "..loot[i], Channel())
		elseif numbers[i] > 1 then
			SendChatMessage(i..". "..numbers[i].."x"..loot[i], Channel())
		end
		if i == n then 
			loot = {}
			numbers = {}
			n = 0
		end
	end
end

local function Announce(event)
	if not IsInGroup() then return end -- not in group, exit.
	local m = 0
	local q = E.db.sle.loot.announcer.quality == "EPIC" and 4 or E.db.sle.loot.announcer.quality == "RARE" and 3 or E.db.sle.loot.announcer.quality == "UNCOMMON" and 2
	
	if (Check() and E.db.sle.loot.announcer.auto) or (IsLeftControlKeyDown() and (IsInGroup() or IsInRaid())) then
		for i = 1, GetNumLootItems() do
			if GetLootSlotType(i) == 1 then
				for j = 1, t do
					if GetLootSlotLink(i) == loottemp[j] then
						check = true
					end
				end 
			end
		end

		if check == false or IsLeftControlKeyDown() then
			PopulateTable(q)
			if n ~= 0 then
				SendChatMessage(L["Loot Dropped:"], Channel())
				List()
			end
		end

		for i = 1, GetNumLootItems() do
			if GetLootSlotType(i) == 1 then
				loottemp[i] = GetLootSlotLink(i)
			end
		end
		t = GetNumLootItems()
		check = false
	end
end

local function HandleRoll(event, id)
	if not E.db.sle.loot.enable then return end
	if not (E.db.sle.loot.autogreed or E.db.sle.loot.autode) then return end

	local _, name, _, quality, _, _, _, disenchant = GetLootRollItemInfo(id)
	local link = GetLootRollItemLink(id)
	local itemID = tonumber(strmatch(link, 'item:(%d+)'))

	if itemID == 43102 or itemID == 52078 then
		RollOnLoot(id, LOOT_ROLL_TYPE_GREED)
	end

	if IsXPUserDisabled() then MaxPlayerLevel = PlayerLevel end
	if (E.db.sle.loot.bylevel and PlayerLevel < E.db.sle.loot.level) and PlayerLevel ~= MaxPlayerLevel then return end

	if E.db.sle.loot.bylevel then
		if IsEquippableItem(link) then
			local _, _, _, ilvl, _, _, _, _, slot = GetItemInfo(link)
			local itemLink = GetInventoryItemLink('player', slot)
			local matchItemLevel = itemLink and select(4, GetItemInfo(itemLink)) or 1
			if quality ~= 7 and matchItemLevel < ilvl then return end
		end
	end

	if quality <= E.db.sle.loot.autoqlty then
		if E.db.sle.loot.autode and disenchant then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end
end

local function HandleEvent(event, ...)
	if event == "LOOT_OPENED" then
		if E.db.sle.loot.announcer.enable then
			Announce(event)
		end
	end

	if not E.db.sle.loot.autoconfirm then return end
	if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
		local arg1, arg2 = ...
		ConfirmLootRoll(arg1, arg2)
	elseif event == "LOOT_OPENED" or event == "LOOT_BIND_CONFIRM" then
		local count = GetNumLootItems()
		if count == 0 then CloseLoot() return end
		for numslot = 1, count do
			ConfirmLootSlot(numslot)
		end
	end
end

local function LoadConfig(event, addon)
	if addon ~= "ElvUI_Config" then return end

	E.Options.args.general.args.general.args.autoRoll.disabled = function() return true end

	LT:UnregisterEvent("ADDON_LOADED")
end

function LT:Update()
	MaxPlayerLevel = GetMaxPlayerLevel()
	PlayerLevel = UnitLevel('player')

	if E.db.general then
		E.db.general.autoRoll= false
	end

	--Azil made this, blame him if something fucked up
	UIParent:UnregisterEvent("LOOT_BIND_CONFIRM") --Solo
	UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL") --Group
	UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL") --Group
	
	if E.db.sle.loot.enable then
		self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", HandleEvent)
		self:RegisterEvent("CONFIRM_LOOT_ROLL", HandleEvent)
		self:RegisterEvent("LOOT_BIND_CONFIRM", HandleEvent)
		self:RegisterEvent("LOOT_OPENED", HandleEvent)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
		self:RegisterEvent("ADDON_LOADED", LoadConfig)
	else
		self:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
		self:UnregisterEvent("CONFIRM_LOOT_ROLL")
		self:UnregisterEvent("LOOT_BIND_CONFIRM")
		self:UnregisterEvent("LOOT_OPENED")
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		self:UnregisterEvent("ADDON_LOADED")
	end
	
end

function LT:LootShow()
	local instance = IsInInstance()
	LootHistoryFrame:SetAlpha(E.db.sle.loot.history.alpha or 1)

	if (not instance and E.db.sle.loot.history.autohide) then
		LootHistoryFrame:Hide()
	end
end

function LT:PLAYER_LEVEL_UP(event, level)
	PlayerLevel = level
end

function LT:Initialize()
	hooksecurefunc(M, 'START_LOOT_ROLL', function(self, event, id) HandleRoll(event, id) end)
	if not E.db.sle.loot.enable then return end
	LT:Update()
end