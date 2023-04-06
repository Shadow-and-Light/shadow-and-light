local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local C = SLE.Chat

local format = format
local GetTime = GetTime
local ItemRefTooltip = ItemRefTooltip
local ShowUIPanel = ShowUIPanel

C.Meterspam = false
C.invLinksInit = false
C.ChannelEvents = {
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_GUILD',
	'CHAT_MSG_OFFICER',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_PARTY_LEADER',
	'CHAT_MSG_INSTANCE_CHAT',
	'CHAT_MSG_INSTANCE_CHAT_LEADER',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_SAY',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_WHISPER_INFORM',
	'CHAT_MSG_YELL',
	'CHAT_MSG_BN_WHISPER',
	'CHAT_MSG_BN_WHISPER_INFORM',
}
C.InvLinkEvents = {
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_GUILD',
	'CHAT_MSG_OFFICER',
	'CHAT_MSG_SAY',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_WHISPER_INFORM',
	'CHAT_MSG_YELL',
	'CHAT_MSG_BN_WHISPER',
	'CHAT_MSG_BN_WHISPER_INFORM',
}

C.spamFirstLines = {
	'^Recount - (.*)$', --Recount
	'^Skada: (.*) for (.*):$', -- Skada enUS
	'^Skada: (.*) por (.*):$', -- Skada esES/ptBR
	'^Skada: (.*) fur (.*):$', -- Skada deDE
	'^Skada: (.*) pour (.*):$', -- Skada frFR
	'^Skada: (.*) per (.*):$', -- Skada itIT
	'^(.*) ? Skada ?? (.*):$', -- Skada koKR
	'^Отчёт Skada: (.*), с (.*):$', -- Skada ruRU
	'^Skada??(.*)?(.*):$', -- Skada zhCN
	'^Skada:(.*)??(.*):$', -- Skada zhTW
	'^(.*) Done for (.*)$', -- TinyDPS
	'^Numeration: (.*)$', -- Numeration
	'^Details!:(.*)$' -- Details!
}
C.spamNextLines = {
	'^(%d+)%. (.*)$', --Recount, Details! and Skada
	'^(.*)   (.*)$', --Additional Skada
	'^Numeration: (.*)$', -- Numeration
	'^[+-]%d+.%d', -- Numeration Deathlog Details
	'^(%d+). (.*):(.*)(%d+)(.*)(%d+)%%(.*)%((%d+)%)$', -- TinyDPS
	'^(.+) (%d-%.%d-%w)$', -- Skada 2
	'|c%x-|H.-|h(%[.-%])|h|r (%d-%.%d-%w %(%d-%.%d-%%%))', --Skada 3
}
C.Meters = {}

local invKeys = {}
function C:CreateInvKeys()
	local db = E.db.sle.chat.invite.keys

	wipe(invKeys)
	db = gsub(db, ',%s', ',') --remove spaces that follow a comma

	for index = 1, select('#', strsplit(',', db)) do
		local key = select(index, strsplit(',', db))

		if key then
			invKeys[key] = true
		end
	end
end

function C:filterLine(event, source, msg)
	for _, line in ipairs(C.spamNextLines) do
		if msg:match(line) then
			local curTime = GetTime()

			for _, meter in ipairs(C.Meters) do
				local elapsed = curTime - meter.time

				if meter.src == source and meter.evt == event and elapsed < 1 then
					-- found the meter, now check wheter this line is already in there
					local toInsert = true

					for _, b in ipairs(meter.data) do
						if b == msg then
							toInsert = false
						end
					end

					if toInsert then tinsert(meter.data, msg) end
					return true, false, nil
				end
			end
		end
	end

	for _, line in ipairs(C.spamFirstLines) do
		local newID = 0

		if msg:match(line) then
			local curTime = GetTime()

			if strfind(msg, '|cff(.+)|r') then
				msg = gsub(msg, '|cff%w%w%w%w%w%w', '')
				msg = gsub(msg, '|r', '')
			end

			for id,meter in ipairs(C.Meters) do
				local elapsed = curTime - meter.time

				if meter.src == source and meter.evt == event and elapsed < 1 then
					newID = id

					return true, true, format('|HSLD:%1$d|h|cFFFFFF00[%2$s]|r|h', newID or 0, msg or 'nil')
				end
			end

			local newMeter = {src = source, evt = event, time = curTime, data = {}, title = msg}
			tinsert(C.Meters, newMeter)

			for id,meter in ipairs(C.Meters) do
				if meter.src == source and meter.evt == event and meter.time == curTime then
					newID = id
				end
			end

			return true, true, format('|HSLD:%1$d|h|cFFFFFF00[%2$s]|r|h', newID or 0, msg or 'nil')
		end
	end

	return false, false, nil
end

function C:ParseChatEvent(event, msg, sender, ...)
	local hide = false

	for _,allevents in ipairs(C.ChannelEvents) do
		if event == allevents then
			local isRecount, isFirstLine, newMessage = C:filterLine(event, sender, msg)

			if isRecount then
				if isFirstLine then
					msg = newMessage
				else
					hide = true
				end
			end
		end
	end

	if not hide then
		return false, msg, sender, ...
	end

	return true
end

function C:ParseChatEventInv(event, msg, sender, ...)
	local hex = E:RGBToHex(E.db.sle.chat.invite.color.r,E.db.sle.chat.invite.color.g,E.db.sle.chat.invite.color.b)

	for _, allevents in ipairs(C.InvLinkEvents) do
		if event == allevents then
			for key, _ in pairs(invKeys) do
				if strfind(msg, key) then
					msg = gsub(msg, key, format('|Hinvite:'..sender..'|h'..hex..'[%s]|r|h', key))

					break
				end
			end
		end
	end

	return false, msg, sender, ...
end

local function SetItemRef(link)
	local linktype, id = strsplit(':', link)

	if E.db.sle.chat.dpsSpam then
		if linktype == 'SLD' then
			local meterID = tonumber(id)

			-- put stuff in the ItemRefTooltip from FrameXML
			ShowUIPanel(ItemRefTooltip)

			if not ItemRefTooltip:IsShown() then
				ItemRefTooltip:SetOwner(_G.UIParent, 'ANCHOR_PRESERVE')
			end

			ItemRefTooltip:ClearLines()
			ItemRefTooltip:AddLine(C.Meters[meterID].title)
			ItemRefTooltip:AddLine(format(L["Reported by %s"], C.Meters[meterID].src))

			for _, message in ipairs(C.Meters[meterID].data) do
				ItemRefTooltip:AddLine(message, 1, 1, 1)
			end
			ItemRefTooltip:Show()

			return
		end
	end

	if IsAltKeyDown() and linktype == 'player' and E.db.sle.chat.invite.altInv then
		C_PartyInfo.InviteUnit(id)

		return
	elseif linktype == 'invite' then
		if strfind(id, '|K') then --Bnet whisper
			local bnetID = strmatch(id, '|K%w(%d+)')

			FriendsFrame_BattlenetInvite(nil, bnetID)
		else
			C_PartyInfo.InviteUnit(id)
		end

		return
	end
end

function C:SpamFilter()
	if E.db.sle.chat.dpsSpam then
		for _,event in ipairs(C.ChannelEvents) do
			ChatFrame_AddMessageEventFilter(event, self.ParseChatEvent)
		end

		C.Meterspam = true
	else
		if C.Meterspam then
			for _,event in ipairs(C.ChannelEvents) do
				ChatFrame_RemoveMessageEventFilter(event, self.ParseChatEvent)
			end

			C.Meterspam = false
		end
	end
	if E.db.sle.chat.invite.invLinks then
		for _,event in ipairs(C.InvLinkEvents) do
			ChatFrame_AddMessageEventFilter(event, self.ParseChatEventInv)
		end

		C.invLinksInit = true
	else
		if C.invLinksInit then
			for _,event in ipairs(C.InvLinkEvents) do
				ChatFrame_RemoveMessageEventFilter(event, self.ParseChatEventInv)
			end

			C.invLinksInit = false
		end
	end
end

function C:InitLinks()
	C:SpamFilter()
	C:CreateInvKeys()

	hooksecurefunc('SetItemRef', SetItemRef)
	-- Borrowed from Deadly Boss Mods

	do
		local old = ItemRefTooltip.SetHyperlink -- we have to hook this function since the default ChatFrame code assumes that all links except for player and channel links are valid arguments for this function
		function ItemRefTooltip:SetHyperlink(link, ...)
			if link:sub(0, 4) == 'SLD:' then return end
			if link:sub(0, 6) == 'invite' then return end

			return old(self, link, ...)
		end
	end
end
