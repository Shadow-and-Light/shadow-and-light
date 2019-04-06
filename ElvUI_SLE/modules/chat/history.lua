local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local CH = E:GetModule("Chat")
local _G = _G
local F

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
	local data = _G["ElvCharacterDB"].ChatHistoryLog
	if data and T.next(data) then
		for i in T.ipairs(data) do
			if T.type(data[i]) == "table" and E.private.sle.chat.chatHistory[data[i][50]] == false then
				T.tremove(_G["ElvCharacterDB"].ChatHistoryLog, i)
			end
		end
	end
end

function C:HistorySizeCHanged()
	local data = _G["ElvCharacterDB"].ChatHistoryLog
	while #data >= E.private.sle.chat.chatHistory.size do
		T.tremove(data, 1)
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
		if not self.db.chatHistory then return end
		local data = _G["ElvCharacterDB"].ChatHistoryLog
		
		if _G["DarthUI"] then
			if not F then F = DarthUI[1]:GetModule("Darth_FuckSpammers") end
			if event == "CHAT_MSG_CHANNEL" and F.Buyers(self, event, ...) then return end
			if event == "CHAT_MSG_WHISPER_INFORM" and F.HideOutgoing(self, event, ...) then return end
			if event == "CHAT_MSG_WHISPER" and F.HideIncoming(self, event, ...) then return end
		end

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

		if #temp > 0 and not CH:MessageIsProtected(temp[1]) then
			temp[50] = event
			temp[51] = T.time()

			local coloredName, battleTag
			if temp[13] > 0 then coloredName, battleTag = CH:GetBNFriendColor(temp[2], temp[13], true) end
			if battleTag then temp[53] = battleTag end -- store the battletag so we can replace arg2 later in the function
			temp[52] = coloredName or CH:GetColoredName(event, ...)

			T.tinsert(data, temp)
			while #data >= E.private.sle.chat.chatHistory.size do
				T.tremove(data, 1)
			end
		end
		-- temp = nil -- Destory!
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
			if #(_G["ElvCharacterDB"].ChatEditHistory) > E.db.sle.chat.editboxhistory then
				T.tremove(_G["ElvCharacterDB"].ChatEditHistory, 1)
			end
		end
	end

	-- C:HystoryOverwrite()
	C:ChatHistoryToggle()
end
C:HystoryOverwrite()