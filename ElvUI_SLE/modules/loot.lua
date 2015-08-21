local E, L, V, P, G = unpack(ElvUI);
local LT = E:GetModule('SLE_Loot')
local M = E:GetModule('Misc')
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

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
		if name == MyName then
			if isML then
				return true
			elseif rank == 1 then
				return true
			elseif rank == 2 then
				return true
			end
		end
	end
	return false
end

local function ModifierCheck()
	local heldModifier = E.db.sle.loot.announcer.override
	local shiftDown = IsShiftKeyDown();
	local ctrlDown = IsControlKeyDown();
	local altDown = IsAltKeyDown();

	if heldModifier == '3' and shiftDown then
		return true
	elseif heldModifier == '5' and ctrlDown then
		return true
	elseif heldModifier == '4' and altDown then
		return true
	elseif heldModifier == '2' then
		return true
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
				ilvl = select(4, GetItemInfo(link)) or QUEUED_STATUS_UNKNOWN
				
				n = n + 1
				loot[n] = link
				loot[n] = loot[n].." (ilvl: "..ilvl..")"
				numbers[n] = quantity or 1
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
	if (Check() and E.db.sle.loot.announcer.auto) or (ModifierCheck() and (IsInGroup() or IsInRaid())) then
		for i = 1, GetNumLootItems() do
			if GetLootSlotType(i) == 1 then
				for j = 1, t do
					if GetLootSlotLink(i) == loottemp[j] then
						check = true
					end
				end 
			end
		end

		if check == false or ModifierCheck() then
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
	if not E.db.sle.loot.autoroll.enable then return end
	if not (E.db.sle.loot.autoroll.autogreed or E.db.sle.loot.autoroll.autode) then return end

	local _, name, _, quality, _, _, _, disenchant = GetLootRollItemInfo(id)
	local link = GetLootRollItemLink(id)
	local itemID = tonumber(strmatch(link, 'item:(%d+)'))

	if itemID == 43102 or itemID == 52078 then
		RollOnLoot(id, LOOT_ROLL_TYPE_GREED)
	end

	if IsXPUserDisabled() then MaxPlayerLevel = PlayerLevel end
	if (E.db.sle.loot.autoroll.bylevel and PlayerLevel < E.db.sle.loot.autoroll.level) and PlayerLevel ~= MaxPlayerLevel then return end

	if E.db.sle.loot.autoroll.bylevel then
		if IsEquippableItem(link) then
			local _, _, _, ilvl, _, _, _, _, slot = GetItemInfo(link)
			local itemLink = GetInventoryItemLink('player', slot)
			local matchItemLevel = itemLink and select(4, GetItemInfo(itemLink)) or 1
			if quality ~= 7 and matchItemLevel < ilvl then return end
		end
	end

	if quality <= E.db.sle.loot.autoroll.autoqlty then
		if E.db.sle.loot.autoroll.autode and disenchant then
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

	if not E.db.sle.loot.autoroll.autoconfirm then return end
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

	LT:Update()
	LT:UnregisterEvent("ADDON_LOADED")
end

function LT:LoadLoot()
	MaxPlayerLevel = GetMaxPlayerLevel()
	PlayerLevel = UnitLevel('player')

	--Azil made this, blame him if something fucked up
	if E.db.general and E.db.sle.loot.autoroll.enable then
		E.db.general.autoRoll = false
	end

	if E.db.sle.loot.enable then
		self:RegisterEvent("LOOT_OPENED", HandleEvent)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
		self:RegisterEvent("ADDON_LOADED", LoadConfig)
		if E.db.sle.loot.autoroll.autoconfirm then
			self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", HandleEvent)
			self:RegisterEvent("CONFIRM_LOOT_ROLL", HandleEvent)
			self:RegisterEvent("LOOT_BIND_CONFIRM", HandleEvent)
			UIParent:UnregisterEvent("LOOT_BIND_CONFIRM") --Solo
			UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL") --Group
			UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL") --Group
		else
			self:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
			self:UnregisterEvent("CONFIRM_LOOT_ROLL")
			self:UnregisterEvent("LOOT_BIND_CONFIRM")
			UIParent:RegisterEvent("LOOT_BIND_CONFIRM") --Solo
			UIParent:RegisterEvent("CONFIRM_DISENCHANT_ROLL") --Group
			UIParent:RegisterEvent("CONFIRM_LOOT_ROLL") --Group
		end
	else
		self:UnregisterEvent("LOOT_OPENED")
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function LT:LootShow()
	local instance = IsInInstance()

	if (not instance and E.db.sle.loot.history.autohide) then
		LootHistoryFrame:Hide()
	end
end

function LT:Update()
	if IsAddOnLoaded("ElvUI_Config") then
		if E.db.sle.loot.autoroll.enable then
			E.Options.args.general.args.general.args.autoRoll = {
				order = 6,
				name = L["Auto Greed/DE"],
				desc = L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."],
				type = "execute",
				func = function() ACD:SelectGroup("ElvUI", "sle", "options", "loot") end,
			}
		else
			E.Options.args.general.args.general.args.autoRoll = {
				order = 6,
				name = L["Auto Greed/DE"],
				desc = L["Automatically select greed or disenchant (when available) on green quality items. This will only work if you are the max level."],
				type = 'toggle',
				disabled = function() return not E.private.general.lootRoll end
			}
		end
	end

	if E.db.sle.loot.autoroll.autoconfirm then
		self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", HandleEvent)
		self:RegisterEvent("CONFIRM_LOOT_ROLL", HandleEvent)
		self:RegisterEvent("LOOT_BIND_CONFIRM", HandleEvent)
		UIParent:UnregisterEvent("LOOT_BIND_CONFIRM") --Solo
		UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL") --Group
		UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL") --Group
	else
		self:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
		self:UnregisterEvent("CONFIRM_LOOT_ROLL")
		self:UnregisterEvent("LOOT_BIND_CONFIRM")
		UIParent:RegisterEvent("LOOT_BIND_CONFIRM") --Solo
		UIParent:RegisterEvent("CONFIRM_DISENCHANT_ROLL") --Group
		UIParent:RegisterEvent("CONFIRM_LOOT_ROLL") --Group
	end

	LootHistoryFrame:SetAlpha(E.db.sle.loot.history.alpha or 1)
end


function LT:PLAYER_LEVEL_UP(event, level)
	PlayerLevel = level
end

function LT:Initialize()
	if not E.db.sle.loot.enable then return end
	--self:RegisterEvent("START_LOOT_ROLL", HandleRoll)
	self:RegisterEvent("PLAYER_LEVEL_UP")

	LT:LoadLoot()
	LT:Update()
	hooksecurefunc(M, 'START_LOOT_ROLL', function(self, event, id) HandleRoll(event, id) end)
end