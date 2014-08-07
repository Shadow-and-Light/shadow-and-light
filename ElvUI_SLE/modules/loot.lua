local E, L, V, P, G, _ = unpack(ElvUI);
local LT = E:GetModule('SLE_Loot')
local check, ann, GrDes = false, false, false
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
local frozen, chaos = select(1, GetItemInfo(43102)), select(1, GetItemInfo(52078))

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

local function Announce(event)
	if event ~= "LOOT_OPENED" then return end
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

local function HandleRoll(event, id)
	if not GrDes then return end
	
	local name = select(2, GetLootRollItemInfo(id))
	if (name == frozen) or (name == chaos) then
		RollOnLoot(id, 2)
	end
		
	local Maxed = GetMaxPlayerLevel()
	if IsXPUserDisabled() == true then Maxed = UnitLevel("player") end
	
	if UnitLevel("player") ~= Maxed then return end
	
	if(id and select(4, GetLootRollItemInfo(id))== 2 and not (select(5, GetLootRollItemInfo(id)))) then
		if E.private.sle.loot.autodisenchant and RollOnLoot(id, 3) then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end
end

local function HandleEvent(event, ...)
	if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
		local arg1, arg2 = ...
		ConfirmLootRoll(arg1, arg2)
	elseif event == "LOOT_OPENED" or event == "LOOT_BIND_CONFIRM" then
		if ann then Announce(event) end
		count = GetNumLootItems()
		if count == 0 then CloseLoot() return end
		for slot = 1, count do
			ConfirmLootSlot(slot)
		end
	end
end

function LT:Update()
	if E.private.sle.loot.autogreed or E.private.sle.loot.autodisenchant then 
		GrDes = true
		E.db.general.autoRoll = false
	else
		GrDes = false
	end
	if IsAddOnLoaded("ElvUI_Config") then
		if GrDes then
			E.Options.args.general.args.general.args.autoRoll.disabled = true
		else
			E.Options.args.general.args.general.args.autoRoll.disabled = false
		end
	end
end

local function LoadConfig(event, addon)
	if addon ~= "ElvUI_Config" then return end
	LT:UnregisterEvent("ADDON_LOADED")
	LT:Update()
end

function LT:Initialize()
	ann = E.private.sle.loot.enable

	self:Update()
	UIParent:UnregisterEvent("LOOT_BIND_CONFIRM")
	UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
	UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL")

	self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", HandleEvent)
	self:RegisterEvent("CONFIRM_LOOT_ROLL", HandleEvent)
	self:RegisterEvent("LOOT_BIND_CONFIRM", HandleEvent)
	self:RegisterEvent("LOOT_OPENED", HandleEvent)
	
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
	
	self:RegisterEvent("START_LOOT_ROLL", HandleRoll)
	self:RegisterEvent("ADDON_LOADED", LoadConfig)
end