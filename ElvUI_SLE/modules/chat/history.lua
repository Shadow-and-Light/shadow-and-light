local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local CH = E:GetModule("Chat")
local _G = _G
local random = random

local historyEvents = {
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_GUILD_ACHIEVEMENT",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_YELL",
}
local function PrepareMessage(author, message)
	return author:upper() .. message
end
local function GetTimeForSavedMessage()
	local randomTime = T.select(2, ("."):split(T.GetTime() or "0."..random(1, 999), 2)) or 0
	return T.time().."."..randomTime
end
local msgList, msgCount, msgTime = {}, {}, {}

function C:ChatHistoryToggle(option)
	for i = 1, #historyEvents do
		CH:UnregisterEvent(historyEvents[i])
		if E.private.sle.chat.chatHistory[historyEvents[i]] then
			CH:RegisterEvent(historyEvents[i], "SaveChatHistory")
		end
	end
	if option then C:ClearUnusedHistory() end
end

function C:ClearUnusedHistory()
	for id, data in T.pairs(_G["ElvCharacterDB"].ChatLog) do
		if T.type(data) == "table" and E.private.sle.chat.chatHistory[data[20]] == false then
			_G["ElvCharacterDB"].ChatLog[id] = nil
		end
	end
end

--Replacing stuff needed for functioning of the module
function C:HystoryOverwrite()
	function CH:CHAT_MSG_YELL(event, message, author, ...)
		local blockFlag = false
		local msg = PrepareMessage(author, message)

		if msg == nil then return CH.FindURL(self, event, message, author, ...) end

		-- ignore player messages
		if author == C.PlayerName then return CH.FindURL(self, event, message, author, ...) end
		if msgList[msg] and msgCount[msg] > 1 and CH.db.throttleInterval ~= 0 then
			if T.difftime(T.time(), msgTime[msg]) <= CH.db.throttleInterval then
				blockFlag = true
			end
		end

		if blockFlag then
			return true;
		else
			if CH.db.throttleInterval ~= 0 then
				msgTime[msg] = T.time()
			end

			return CH.FindURL(self, event, message, author, ...)
		end
	end

	function CH:DisableChatThrottle()
		T.twipe(msgList); T.twipe(msgCount); T.twipe(msgTime)
	end

	function CH:ChatThrottleHandler(event, ...)
		local arg1, arg2 = ...

		if arg2 ~= "" then
			local message = PrepareMessage(arg2, arg1)
			if msgList[message] == nil then
				msgList[message] = true
				msgCount[message] = 1
				msgTime[message] = T.time()
			else
				msgCount[message] = msgCount[message] + 1
			end
		end
	end

	function CH:CHAT_MSG_CHANNEL(event, message, author, ...)
		local blockFlag = false
		local msg = PrepareMessage(author, message)

		-- ignore player messages
		if author == C.PlayerName then return CH.FindURL(self, event, message, author, ...) end
		if msgList[msg] and CH.db.throttleInterval ~= 0 then
			if T.difftime(T.time(), msgTime[msg]) <= CH.db.throttleInterval then
				blockFlag = true
			end
		end

		if blockFlag then
			return true;
		else
			if CH.db.throttleInterval ~= 0 then
				msgTime[msg] = T.time()
			end

			return CH.FindURL(self, event, message, author, ...)
		end
	end

	function CH:SaveChatHistory(event, ...)
		if self.db.throttleInterval ~= 0 and (event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' or event == 'CHAT_MSG_CHANNEL') then
			self:ChatThrottleHandler(event, ...)

			local message, author = ...
			local msg = PrepareMessage(author, message)
			if author ~= C.PlayerName and msgList[msg] then
				if T.difftime(T.time(), msgTime[msg]) <= CH.db.throttleInterval then
					return;
				end
			end
		end

		local temp = {}
		for i = 1, T.select('#', ...) do
			temp[i] = T.select(i, ...) or false
		end

		if #temp > 0 then
			temp[20] = event
			local timeForMessage = GetTimeForSavedMessage()
			_G["ElvCharacterDB"].ChatLog[timeForMessage] = temp

			local c, k = 0
			for id, data in T.pairs(_G["ElvCharacterDB"].ChatLog) do
				c = c + 1
				if (not k) or k > id then
					k = id
				end
			end

			if c > E.private.sle.chat.chatHistory.size then
				_G["ElvCharacterDB"].ChatLog[k] = nil
			end
		end
	end
end

function C:InitHistory()
	--Overwriting stuff cause fuck this shit
	function CH:ChatEdit_AddHistory(editBox, line)
		if T.find(line, "/rl") then return; end
		if ( T.strlen(line) > 0 ) then
			for i, text in T.pairs(_G["ElvCharacterDB"].ChatEditHistory) do
				if text == line then
					return
				end
			end
			T.tinsert(_G["ElvCharacterDB"].ChatEditHistory, #(_G["ElvCharacterDB"].ChatEditHistory) + 1, line)
			if #(_G["ElvCharacterDB"].ChatEditHistory) > C.db.editboxhistory then
				T.tremove(_G["ElvCharacterDB"].ChatEditHistory, 1)
			end
		end
	end

	C:HystoryOverwrite()
	C:ChatHistoryToggle()
end