local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local LT = SLE:NewModule('Loot','AceHook-3.0', 'AceEvent-3.0')
local M = E:GetModule('Misc')
LT.PlayerLevel = 0
LT.MaxPlayerLevel = 0
LT.LootItems = 0 --To determine how many items are in our loot cache
LT.LootEvents = {
	"CONFIRM_DISENCHANT_ROLL", --Group
	"CONFIRM_LOOT_ROLL", --Group
	"LOOT_BIND_CONFIRM", --Solo
}
LT.Loot = {}
LT.LootTemp = {}
LT.Numbers = {}
local check = false
local t = 0
local QUEUED_STATUS_UNKNOWN = QUEUED_STATUS_UNKNOWN
local LOOT_ROLL_TYPE_GREED = LOOT_ROLL_TYPE_GREED
local IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown = IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local SendChatMessage = SendChatMessage
local RollOnLoot, ConfirmLootRoll, CloseLoot = RollOnLoot, ConfirmLootRoll, CloseLoot

LT.IconChannels = {
	"CHAT_MSG_BN_CONVERSATION","CHAT_MSG_BN_WHISPER","CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_CHANNEL","CHAT_MSG_EMOTE","CHAT_MSG_GUILD","CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER","CHAT_MSG_LOOT","CHAT_MSG_OFFICER","CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER","CHAT_MSG_RAID","CHAT_MSG_RAID_LEADER","CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY","CHAT_MSG_SYSTEM","CHAT_MSG_WHISPER","CHAT_MSG_WHISPER_INFORM","CHAT_MSG_YELL",
}

local function Check()
	for x = 1, T.GetNumGroupMembers() do
		local name, rank, _, _, _, _, _, _, _, _, isML = T.GetRaidRosterInfo(x)
		if name == E.myname then
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

function LT:ModifierCheck()
	local heldModifier = LT.db.announcer.override
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
	-- local checking
	for i = 1, #(LT.Loot) do
		local checking = 1
		while LT.Loot[i] ~= LT.Loot[checking] do checking = checking + 1 end
		if i ~= checking then
			LT.Numbers[i] = LT.Numbers[i] + LT.Numbers[checking]
			T.tremove(LT.Numbers, checking)
			T.tremove(LT.Loot, checking)
			LT.LootItems = LT.LootItems - 1
		end
	end
end

function LT:PopulateTable(qualityPassed)
	for i = 1, T.GetNumLootItems() do
		if T.GetLootSlotType(i) == 1 then 
			local _, item, quantity, quality = T.GetLootSlotInfo(i)
			local link, ilvl

			if quality >= qualityPassed then
				link = T.GetLootSlotLink(i)
				ilvl = T.select(4, T.GetItemInfo(link)) or QUEUED_STATUS_UNKNOWN
				
				LT.LootItems = LT.LootItems + 1
				LT.Loot[LT.LootItems] = link
				LT.Loot[LT.LootItems] = LT.Loot[LT.LootItems].." (ilvl: "..ilvl..")"
				LT.Numbers[LT.LootItems] = quantity or 1
			end
		end
	end
	Merge()
end

local function Channel()
	if LT.db.announcer.channel ~= "SAY" and T.IsPartyLFG() then
		return "INSTANCE_CHAT"
	end
	if LT.db.announcer.channel == "RAID" and not T.IsInRaid() then
		return "PARTY"
	end
	return LT.db.announcer.channel
end

function LT:AnnounceList()
	for i = 1, LT.LootItems do
		if LT.Numbers[i] == 1 then
			SendChatMessage(i..". "..LT.Loot[i], Channel())
		elseif LT.Numbers[i] > 1 then
			SendChatMessage(i..". "..LT.Numbers[i].."x"..LT.Loot[i], Channel())
		end
		if i == LT.LootItems then 
			T.twipe(LT.Loot)
			T.twipe(LT.Numbers)
			LT.LootItems = 0
		end
	end
end

function LT:Announce(event)
	if not T.IsInGroup() then return end -- not in group, exit.
	local m = 0
	local quality = LT.db.announcer.quality == "EPIC" and 4 or LT.db.announcer.quality == "RARE" and 3 or LT.db.announcer.quality == "UNCOMMON" and 2
	if (Check() and LT.db.announcer.auto) or (LT:ModifierCheck() and (T.IsInGroup() or T.IsInRaid())) then
		for i = 1, T.GetNumLootItems() do
			if T.GetLootSlotType(i) == 1 then
				for j = 1, t do
					if T.GetLootSlotLink(i) == LT.LootTemp[j] then
						check = true
					end
				end 
			end
		end

		if check == false or LT:ModifierCheck() then
			LT:PopulateTable(quality)
			if LT.LootItems ~= 0 then
				SendChatMessage(L["Loot Dropped:"], Channel())
				LT:AnnounceList()
			end
		end

		for i = 1, T.GetNumLootItems() do
			if T.GetLootSlotType(i) == 1 then
				LT.LootTemp[i] = T.GetLootSlotLink(i)
			end
		end
		t = T.GetNumLootItems()
		check = false
	end
end

function LT:HandleRoll(event, id)
	if not LT.db.autoroll.enable then return end
	if not (LT.db.autoroll.autogreed or LT.db.autoroll.autode) then return end

	local _, name, _, quality, _, _, _, disenchant = T.GetLootRollItemInfo(id)
	local link = T.GetLootRollItemLink(id)
	local itemID = T.tonumber(T.match(link, 'item:(%d+)'))

	if itemID == 43102 or itemID == 52078 then
		RollOnLoot(id, LOOT_ROLL_TYPE_GREED)
	end

	if T.IsXPUserDisabled() then LT.MaxPlayerLevel = LT.PlayerLevel end
	if (LT.db.autoroll.bylevel and LT.PlayerLevel < LT.db.autoroll.level) and LT.PlayerLevel ~= LT.MaxPlayerLevel then return end

	if LT.db.autoroll.bylevel then
		if T.IsEquippableItem(link) then
			local _, _, _, ilvl, _, _, _, _, slot = T.GetItemInfo(link)
			local itemLink = T.GetInventoryItemLink('player', slot)
			local matchItemLevel = itemLink and T.select(4, T.GetItemInfo(itemLink)) or 1
			if quality ~= 7 and matchItemLevel < ilvl then return end
		end
	end

	if quality <= LT.db.autoroll.autoqlty then
		if LT.db.autoroll.autode and disenchant then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end
end

function LT:HandleEvent(event, ...)
	if event == "LOOT_OPENED" then
		if LT.db.announcer.enable then
			LT:Announce(event)
		end
	end

	if not LT.db.autoroll.autoconfirm then return end
	if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
		local arg1, arg2 = ...
		ConfirmLootRoll(arg1, arg2)
	elseif event == "LOOT_OPENED" or event == "LOOT_BIND_CONFIRM" then
		local count = T.GetNumLootItems()
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

function LT:Toggle()
	if LT.db.enable then
		self:RegisterEvent("LOOT_OPENED", "HandleEvent")
		self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
		if not T.IsAddOnLoaded("ElvUI_Config") then
			self:RegisterEvent("ADDON_LOADED", LoadConfig)
		end
	else
		self:UnregisterEvent("LOOT_OPENED")
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function LT:AutoToggle()
	for i = 1, 3 do
		if LT.db.autoroll.autoconfirm and LT.db.enable then
			self:RegisterEvent(LT.LootEvents[i], "HandleEvent")
			UIParent:UnregisterEvent(LT.LootEvents[i])
		else
			UIParent:RegisterEvent(LT.LootEvents[i])
			self:UnregisterEvent(LT.LootEvents[i])
		end
	end
end

function LT:LootAlpha()
	LootHistoryFrame:SetAlpha(LT.db.history.alpha or 1)
end

function LT:LootShow()
	local instance = T.IsInInstance()

	if (not instance and LT.db.history.autohide) then
		LootHistoryFrame:Hide()
	end
end

function LT:Update()
	if T.IsAddOnLoaded("ElvUI_Config") then
		if LT.db.autoroll.enable then
			E.Options.args.general.args.general.args.autoRoll = {
				order = 6,
				name = L["Auto Greed/DE"],
				desc = L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."],
				type = "execute",
				func = function() SLE.ACD:SelectGroup("ElvUI", "sle", "modules", "loot") end,
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

	LT:Toggle()
	LT:AutoToggle()
	LT:LootAlpha()
end

function LT:PLAYER_LEVEL_UP(event, level)
	LT.PlayerLevel = level
end

function LT:AddLootIcons(event, message, ...)
	if LT.db.looticons.channels[event] then
		local function IconForLink(link)
			local texture = T.GetItemIcon(link)
			return (LT.db.looticons.position == "LEFT") and "\124T" .. texture .. ":" .. LT.db.looticons.size .. "\124t" .. link or link .. "\124T" .. texture .. ":" .. LT.db.looticons.size .. "\124t"
		end
		message = T.gsub(message, "(\124c%x+\124Hitem:.-\124h\124r)", IconForLink)
	end
	return false, message, ...
end

function LT:LootIconToggle()
	if LT.db.looticons.enable then
		for i = 1, #LT.IconChannels do
			ChatFrame_AddMessageEventFilter(LT.IconChannels[i], LT.AddLootIcons)
		end
	else
		for i = 1, #LT.IconChannels do
			ChatFrame_RemoveMessageEventFilter(LT.IconChannels[i], LT.AddLootIcons)
		end
	end
end

function LT:Initialize()
	if not SLE.initialized then return end
	LT.db = E.db.sle.loot
	self:RegisterEvent("PLAYER_LEVEL_UP")

	function LT:ForUpdateAll()
		LT.db = E.db.sle.loot
		LT:Update()
		LT:LootShow()
		LT:LootIconToggle()
	end

	LT.MaxPlayerLevel = T.GetMaxPlayerLevel()
	LT.PlayerLevel = T.UnitLevel('player')

	--Azil made this, blame him if something fucked up
	if E.db.general and LT.db.autoroll.enable then
		E.db.general.autoRoll = false
	end
	LT:Update()
	hooksecurefunc(M, 'START_LOOT_ROLL', function(self, event, id) LT:HandleRoll(event, id) end)
	-- hooksecurefunc("LootHistoryFrame_FullUpdate", )
	LT:LootIconToggle()
end

SLE:RegisterModule(LT:GetName())