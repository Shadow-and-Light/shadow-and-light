--Raid mark bar. Similar to quickmark which just semms to be impossible to skin
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LT = E:NewModule('SLE_Loot', 'AceHook-3.0', 'AceEvent-3.0')
local SLE = E:GetModule("SLE")
local check = false
local t = 0
local loottemp = {}
local MyName = E.myname
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local GetNumGroupMembers, GetRaidRosterInfo = GetNumGroupMembers, GetRaidRosterInfo
local GetLootSlotType = GetLootSlotType
local GetNumLootItems = GetNumLootItems
local IsLeftControlKeyDown = IsLeftControlKeyDown
local GetLootSlotLink = GetLootSlotLink
local GetLootSlotInfo = GetLootSlotInfo

local improved = {
	110, --Test
	--Thunderforged
	528,
	541,
	--Warforged
	559,
	572,
}

function LT:Check()
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

function LT:Announce()
	local name = {}
	local loot = {}
	local numbers = {}
	local m = 0
	local q = E.db.sle.loot.quality == "EPIC" and 4 or E.db.sle.loot.quality == "RARE" and 3 or E.db.sle.loot.quality == "UNCOMMON" and 2
	local n = 0

	local p, chat
	if not IsInGroup() then return end -- not in group, exit.
	if (LT:Check() and E.db.sle.loot.auto) or (IsLeftControlKeyDown() and (IsInGroup() or IsInRaid())) then
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
			for i = 1, GetNumLootItems() do
				if GetLootSlotType(i) ~= 1 then 
					m = m + 1
				else 
					local _, item, quantity, quality = GetLootSlotInfo(i)
					if quality >= q then
						name[i] = item
		
						k = 1
						while name[i] ~= name[k] do
						k = k + 1
						end
		
						if i == k then
							n = n + 1
							loot[n] = GetLootSlotLink(i)
						numbers[n] = quantity 
						else
						
						p = 1
						while GetLootSlotLink(k) ~= loot[p] do
						p = p + 1
						end
						numbers[p] = numbers[p] + quantity
						
					end
				end
			end
		end
		if n ~= 0 then 
			if E.db.sle.loot.chat == "PARTY" then
				SendChatMessage(L["Loot Dropped:"], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
			elseif E.db.sle.loot.chat == "RAID" then
				if IsInRaid() then
					SendChatMessage(L["Loot Dropped:"], IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(L["Loot Dropped:"], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
				end
			elseif E.db.sle.loot.chat == "SAY" then
				SendChatMessage(L["Loot Dropped:"], "SAY")
			end
		end
		for i = 1, n do
			if E.db.sle.loot.chat == "PARTY" then
				if numbers[i] == 1 then
					SendChatMessage(i..". "..loot[i], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
				elseif numbers[i] > 1 then
					SendChatMessage(i..". "..loot[i].."x"..numbers[i], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
				end
			elseif E.db.sle.loot.chat == "RAID" then
				if IsInRaid() then
					if numbers[i] == 1 then
						SendChatMessage(i..". "..loot[i], IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
					elseif numbers[i] > 1 then
							SendChatMessage(i..". "..loot[i].."x"..numbers[i], IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
						end	
					else
						if numbers[i] == 1 then
							SendChatMessage(i..". "..loot[i], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
						elseif numbers[i] > 1 then
							SendChatMessage(i..". "..loot[i].."x"..numbers[i], IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
						end
					end	
			elseif E.db.sle.loot.chat == "SAY" then
				if numbers[i] == 1 then
					SendChatMessage(i..". "..loot[i], "SAY")	
				elseif numbers[i] > 1 then
					SendChatMessage(i..". "..loot[i].."x"..numbers[i], "SAY")
					end
				end
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

function LT:Initialize()
	if not E.private.sle.loot.enable then return end
	self:RegisterEvent("LOOT_OPENED", "Announce")
end

E:RegisterModule(LT:GetName())