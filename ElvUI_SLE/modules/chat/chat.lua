local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local CH = E:GetModule('Chat')
local LSM = LibStub("LibSharedMedia-3.0")

function CH:FadeUpdate()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
	CH:StyleChat(frame)
	end
end

CH.StyleChatRE = CH.StyleChat
function CH:StyleChat(frame)
	self:StyleChatRE(frame)
	local name = frame:GetName()
	if E.db.dpe.chat.fade then
		_G[name]:SetFading(true) --Enable chat text fading after some time
	else
		_G[name]:SetFading(false) --Disable chat text fading after some time
	end
end

function CH:ChatEdit_AddHistory(editBox, line)
	if line:find("/rl") then return; end

	if ( strlen(line) > 0 ) then
		for i, text in pairs(ElvCharacterData.ChatEditHistory) do
			if text == line then
				return
			end
		end

		table.insert(ElvCharacterData.ChatEditHistory, #ElvCharacterData.ChatEditHistory + 1, line)
		if #ElvCharacterData.ChatEditHistory > E.db.chat.editboxhistory then
			for i=1,(#ElvCharacterData.ChatEditHistory - E.db.chat.editboxhistory) do
				table.remove(ElvCharacterData.ChatEditHistory, 1)
			end
		end
	end
end

-------------------------------------------------------
-- Highlight your own name when someone mentions you
-- Credit: Hydra
-- Todo: Add some options for it later
-------------------------------------------------------
local string = string
local gsub = string.gsub
local strsub = string.sub
local strfind = string.find
local format = string.format
local strlower = string.lower
local Wrapper = "|cff71D5FF[%s]|r"
local MyName = gsub(UnitName("player"), "%u", strlower, 1)
local NameList
--Name list
function CH:NamesListUpdate()
	local name
	local names
	NameList = {MyName}
	names = {}
	if E.private.namelist == nil then return end
	for name in pairs(E.private.namelist) do
		names[name] = name
		table.insert(NameList, name)
	end
end
CH:NamesListUpdate()

--Channel list
local ChannelList
function CH:ChannelListUpdate()
	local channel
	local channels
	ChannelList = {}
	channels = {}
	if E.private.channellist == nil then return end
	for channel in pairs(E.private.channellist) do
		channels[channel] = channel
		table.insert(ChannelList, channel)
	end
end
CH:ChannelListUpdate()

-- Finding our name in a URL breaks the hyperlink, so check & exclude them
local FindURL = function(msg)
	local NewString, Found = gsub(msg, "(%a+)://(%S+)%s?", "%1://%2")
	if Found > 0 then return NewString end

	NewString, Found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", "www.%1.%2")
	if Found > 0 then return NewString end

	NewString, Found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4")
	if Found > 0 then return NewString end
end

local NormalCycleCount = 0
local CustomCycleCount = 0
local SoundPalyed = 0
function CH:SetTimer()
	if E.private.channelcheck.time == nil then
		E.private.channelcheck.time = 3
	end
end

--For finding names in regular channels
local FindMyName = function(self, event, message, author, ...)
	if not E.db.dpe.chat.namehighlight then return end
	local msg = strlower(message)
	
	for i = 1, #NameList do
		local lowName = strlower(NameList[i])
		if strfind(msg, lowName) and lowName ~= "" then
			local Start, Stop = string.find(msg, lowName)
			local Name = strsub(message, Start, Stop)
			local Link = FindURL(message)

			if (not Link) or (Link and not strfind(Link, Name)) then
				if E.db.dpe.chat.sound then
					if SoundPalyed == 0 then --Check for sound played
						PlaySoundFile(LSM:Fetch("sound", E.db.dpe.chat.warningsound));
						SoundPalyed = 1 --Setting sound as played
						frame.SoundTimer = CH:ScheduleTimer('EnableSound', E.private.channelcheck.time) --Starting Timer
					end
				end
				return false, gsub(message, Name, format(Wrapper, Name)), author, ...
			end
		end
	end
end

--For finding names in custom channels
local CustomFindMyName = function(self, event, message, author, arg1, arg2, arg3, arg4, arg5, channelNum, channelName, ...)
	if not E.db.dpe.chat.namehighlight then return end
	local msg = strlower(message)

	--Checking if the custom channel is one of Blizz's
	if (channelNum == 1 and E.private.channelcheck.general) or (channelNum == 2 and E.private.channelcheck.trade) or (channelNum == 3 and E.private.channelcheck.defense) or (channelNum == 4 and E.private.channelcheck.lfg) then
			for i = 1, #NameList do
				local lowName = strlower(NameList[i])
				if strfind(msg, lowName) and lowName ~= "" then
					local Start, Stop = string.find(msg, lowName)
					local Name = strsub(message, Start, Stop)
					local Link = FindURL(message)
		
						if (not Link) or (Link and not strfind(Link, Name)) then
						if E.db.dpe.chat.sound then
							if SoundPalyed == 0 then
								PlaySoundFile(LSM:Fetch("sound", E.db.dpe.chat.warningsound));
								SoundPalyed = 1
								frame.SoundTimer = CH:ScheduleTimer('EnableSound', E.private.channelcheck.time)
							end
						end
						return false, gsub(message, Name, format(Wrapper, Name)), author, arg1, arg2, arg3, arg4, arg5, channelNum, channelName, ...
					end
				end
			end
	else --if not then check custom channels list
		local chanMatch = 0

		if ChannelList == nil then return end
		for i = 1, #ChannelList do
			if channelName == ChannelList[i] then
				chanMatch = 1
			end
		end

		if chanMatch == 1 then
			for i = 1, #NameList do
				local lowName = strlower(NameList[i])
				if strfind(msg, lowName) and lowName ~= "" then
					local Start, Stop = string.find(msg, lowName)
					local Name = strsub(message, Start, Stop)
					local Link = FindURL(message)
		
						if (not Link) or (Link and not strfind(Link, Name)) then
						if E.db.dpe.chat.sound then
							if SoundPalyed == 0 then
								PlaySoundFile(LSM:Fetch("sound", E.db.dpe.chat.warningsound));
								SoundPalyed = 1
								frame.SoundTimer = CH:ScheduleTimer('EnableSound', E.private.channelcheck.time)
							end
						end
						return false, gsub(message, Name, format(Wrapper, Name)), author, arg1, arg2, arg3, arg4, arg5, channelNum, channelName, ...
					end
				end
			end
		end
	end
end

--Action at the end of timer
function CH:EnableSound(frame)
	SoundPalyed = 0
end

--Checking which channel to search for toon's name
function CH:SetChannelsCheck()
	if E.private.channelcheck.say then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", FindMyName)
	end
	if E.private.channelcheck.yell then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", FindMyName)
	end
	if E.private.channelcheck.party then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FindMyName)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", FindMyName)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY_LEADER", FindMyName)
	end
	if E.private.channelcheck.raid then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FindMyName)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FindMyName)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FindMyName)
	end
	if E.private.channelcheck.battleground then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", FindMyName)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BATTLEGROUND", FindMyName)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", FindMyName)
	end
	if E.private.channelcheck.guild then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", FindMyName)
	end
	if E.private.channelcheck.officer then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", FindMyName)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_OFFICER", FindMyName)
	end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CustomFindMyName) --Custom channels are always watched. their check is in other place
end

--Replacement of chat tab position and size function
function CH:PositionChat(override)
	if (InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override) then return end
	
	RightChatPanel:Size(E.db.general.panelWidth, E.db.general.panelHeight)
	LeftChatPanel:Size(E.db.general.panelWidth, E.db.general.panelHeight)	
	
	if E.private.chat.enable ~= true then return end
	
	local chat, chatbg, tab, id, point, button, isDocked, chatFound
	for _, frameName in pairs(CHAT_FRAMES) do
		chat = _G[frameName]
		id = chat:GetID()
		point = GetChatWindowSavedPosition(id)
		
		if point == "BOTTOMRIGHT" and chat:IsShown() then
			chatFound = true
			break
		end
	end	

	if chatFound then
		self.RightChatWindowID = id
	else
		self.RightChatWindowID = nil
	end
	
	CreatedFrames = id
	
	for i=1, CreatedFrames do
		chat = _G[format("ChatFrame%d", i)]
		chatbg = format("ChatFrame%dBackground", i)
		button = _G[format("ButtonCF%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		_, _, _, _, _, _, _, _, isDocked, _ = GetChatWindowInfo(id)		
		
		if id > NUM_CHAT_WINDOWS then
			if point == nil then
				point = select(1, chat:GetPoint())
			end
			if select(2, tab:GetPoint()):GetName() ~= bg then
				isDocked = true
			else
				isDocked = false
			end	
		end	
		
		if not chat.isInitialized then return end
		
		if point == "BOTTOMRIGHT" and chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == self.RightChatWindowID then
		if id ~= 2 then
			chat:ClearAllPoints()
			chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3) -- <<< Changed
			chat:SetSize(E.db.general.panelWidth - 6, (E.db.general.panelHeight - 27)) -- <<< Changed
		else
			chat:ClearAllPoints()
			chat:Point("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 1, 3)
			chat:Size(E.db.general.panelWidth - 11, (E.db.general.panelHeight - 60) - CombatLogQuickButtonFrame_Custom:GetHeight())				
		end

		FCF_SavePositionAndDimensions(chat)			
		
		tab:SetParent(RightChatPanel)
		chat:SetParent(tab)
		
		if E.db.general.panelBackdrop == 'HIDEBOTH' or E.db.general.panelBackdrop == 'LEFT' then
			CH:SetupChatTabs(tab, true)
		else
			CH:SetupChatTabs(tab, false)
		end
	elseif not isDocked and chat:IsShown() then
		tab:SetParent(E.UIParent)
		chat:SetParent(E.UIParent)
		
		CH:SetupChatTabs(tab, true)
	else
		if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
			chat:ClearAllPoints()
			chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 1, 3)
			chat:Size(E.db.general.panelWidth - 6, (E.db.general.panelHeight - 27)) -- <<< Changed
			FCF_SavePositionAndDimensions(chat)		
		end
		chat:SetParent(LeftChatPanel)
		tab:SetParent(GeneralDockManager)
		
		if E.db.general.panelBackdrop == 'HIDEBOTH' or E.db.general.panelBackdrop == 'RIGHT' then
			CH:SetupChatTabs(tab, true)
		else
			CH:SetupChatTabs(tab, false)
		end			
	end	
	end
	
	self.initialMove = true;
end