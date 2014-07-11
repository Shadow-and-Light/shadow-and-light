local E, L, V, P, G, _ = unpack(ElvUI);
local LT = E:GetModule('SLE_Loot')
local check = false
local t = 0
local loottemp = {}
local MyName = E.myname
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local GetNumGroupMembers, GetRaidRosterInfo = GetNumGroupMembers, GetRaidRosterInfo
local GetLootSlotType, GetLootSlotLink, GetLootSlotInfo = GetLootSlotType, GetLootSlotLink, GetLootSlotInfo
local GetNumLootItems, GetItemInfo = GetNumLootItems, GetItemInfo
local IsLeftControlKeyDown = IsLeftControlKeyDown
local loot = {}
local numbers = {}
local n = 0
local Tremove = table.remove

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
			Tremove(numbers, k)
			Tremove(loot, k)
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
	if E.db.sle.loot.chat ~= "SAY" and IsPartyLFG() then
		return "INSTANCE_CHAT"
	end
	if E.db.sle.loot.chat == "RAID" and not IsInRaid() then
		return "PARTY"
	end
	return E.db.sle.loot.chat
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

function LT:Announce()
	if not IsInGroup() then return end -- not in group, exit.
	local m = 0
	local q = E.db.sle.loot.quality == "EPIC" and 4 or E.db.sle.loot.quality == "RARE" and 3 or E.db.sle.loot.quality == "UNCOMMON" and 2
	
	if (Check() and E.db.sle.loot.auto) or (IsLeftControlKeyDown() and (IsInGroup() or IsInRaid())) then
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

function LT:LootShow()
	local instance = IsInInstance()
	LootHistoryFrame:SetAlpha(E.db.sle.lootalpha or 1)

	if (not instance and E.db.sle.lootwin) then
		LootHistoryFrame:Hide()
	end
end

function LT:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
	if not E.private.sle.loot.enable then return end
	self:RegisterEvent("LOOT_OPENED", "Announce")
end