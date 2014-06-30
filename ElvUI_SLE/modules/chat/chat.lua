local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local SLE = E:GetModule('SLE');
local LSM = LibStub("LibSharedMedia-3.0")
local CreatedFrames = 0;
local lfgRoles = {};
local chatFilters = {};
local lfgChannels = {
	"PARTY_LEADER",
	"PARTY",
	"RAID",
	"RAID_LEADER",
	"INSTANCE_CHAT",
	"INSTANCE_CHAT_LEADER",
}

local Myname = E.myname
local GetGuildRosterInfo = GetGuildRosterInfo
local IsInGuild = IsInGuild
local GuildMaster = ""
local GMName, GMRealm

local len, gsub, find, sub, gmatch, format, random = string.len, string.gsub, string.find, string.sub, string.gmatch, string.format, math.random
local tinsert, tremove, tsort, twipe, tconcat = table.insert, table.remove, table.sort, table.wipe, table.concat

local PLAYER_REALM = gsub(E.myrealm,'[%s%-]','')
local PLAYER_NAME = Myname.."-"..PLAYER_REALM

local rolePaths = {
	TANK = [[|TInterface\AddOns\ElvUI\media\textures\tank:15:15:0:0:64:64:2:56:2:56|t]],
	HEALER = [[|TInterface\AddOns\ElvUI\media\textures\healer:15:15:0:0:64:64:2:56:2:56|t]],
	DAMAGER = [[|TInterface\AddOns\ElvUI\media\textures\dps:15:15|t]]
}

--Chat icon paths
local elvui = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t"
local affinity = "|TInterface\\AddOns\\ElvUI\\media\\textures\\Bathrobe_Chat_Logo:15:15|t"
local adapt = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\adapt:0:2|t"
local repooc = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:0:2|t"
local darth = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_LogoD:0:2|t"
local friend = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Friend:13:13|t"
local test = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Test:13:13|t"
local rpg = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_RPG:13:35|t"
local tyrone = "|TInterface\\AddOns\\ElvUI\\media\\textures\\tyrone_biggums_chat_logo:16:18|t"
local hulkhead = "|TInterface\\AddOns\\ElvUI\\media\\textures\\hulk_head:18:22|t"
local hellokitty = "|TInterface\\AddOns\\ElvUI\\media\\textures\\helloKittyChatLogo:18:20|t"
local shortbus = "|TInterface\\AddOns\\ElvUI\\media\\textures\\short_bus:16:16|t"
local kitalie = "|TInterface\\Icons\\%s:12:12:0:0:64:64:4:60:4:60|t"
local leader = [[|TInterface\GroupFrame\UI-Group-LeaderIcon:12:12|t]]


local specialChatIcons = {
	["BleedingHollow"] = {
		["Tirain"] = tyrone
	},
	["Spirestone"] = {
		["Aeriane"] = true,
		["Sinth"] = tyrone,
		["Elvz"] = elvui,
		["Sarah"] = hellokitty,
		["Sara"] = hellokitty,
		["Sarâh"] = hellokitty,
		["Itzjonny"] = hulkhead,
		["Elv"] = elvui,
		["Incision"] = shortbus,
		--SLE stuff
		["Sifupooc"] = repooc,
		["Dapooc"] = repooc,
		["Lapooc"] = repooc,
		["Warpooc"] = repooc,
		["Repooc"] = repooc,
		--Adapt Roster
		["Mobius"] = adapt,
		["Urgfelstorm"] = adapt,
		["Kilashandra"] = adapt,
		["Electrro"] = adapt,
		["Afterthot"] = adapt,
		["Lavathing"] = adapt,
		["Finkle"] = adapt,
		["Chopsti"] = adapt,
		["Taiin"] = adapt
	},
	["Illidan"] = {
		--Original Stuff
		["Affinichi"] = affinity,
		["Uplift"] = affinity,
		["Affinitii"] = affinity,
		["Affinity"] = affinity,
		--Darth's toon
		["Darthpred"] = darth,
		--Repooc's Toon
		["Repøøc"] = repooc,
		["Repooc"] = repooc
	},
	["WyrmrestAccord"] = {
		["Kìtalie"] = kitalie:format("inv_cloth_challengewarlock_d_01helm"),
		["Sagome"] = kitalie:format("inv_helm_leather_challengemonk_d_01"),
		["Ainy"] = kitalie:format("inv_helm_plate_challengedeathknight_d_01"),
		["Norinael"] = kitalie:format("inv_helmet_plate_challengepaladin_d_01"),
		["Tritalie"] = kitalie:format("inv_helm_cloth_challengemage_d_01"),
		["Myùn"] = kitalie:format("inv_helmet_mail_challengeshaman_d_01"),
		["Nevaleigh"] = kitalie:format("inv_helmet_leather_challengerogue_d_01"),
		["Celenii"] = kitalie:format("inv_helmet_cloth_challengepriest_d_01"),
		["Varysa"] = kitalie:format("inv_helmet_mail_challengehunter_d_01"),
		["Caylasena"] = kitalie:format("inv_helm_plate_challengewarrior_d_01"),
		["Arillora"] = kitalie:format("inv_helmet_challengedruid_d_01"),
		["Dapooc"] = repooc,
	},
	["СвежевательДуш"] = {
		--Darth's toons
		["Большойгном"] = test, --Testing toon
		["Фергесон"] = friend
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Дартпредатор"] = darth,
		["Алея"] = darth,
		["Ваззули"] = darth,
		["Сиаранна"] = darth,
		["Джатон"] = darth,
		["Фикстер"] = darth,
		["Киландра"] = darth,
		["Нарджо"] = darth,
		["Келинира"] = darth,
		["Крениг"] = darth,
		["Мейжи"] = darth,
		--Darth's friends
		["Леани"] = friend,
		--Da tester lol
		["Харореанн"] = test,
		["Нерререанн"] = test
	},
	["Ревущийфьорд"] = {
		["Рыжая"] = friend,
		["Рыжа"] = friend,
				--Some people
		["Брэгар"] = test
	},
	["Азурегос"] = {
		["Брэгари"] = test
	},
	["Korialstrasz"] = {
		["Cursewordz"] = repooc
	},
	["Andorhal"] = {
		["Dapooc"] = repooc,
		["Rovert"] = repooc,
		["Sliceoflife"] = repooc
	},
}

SLE.SpecialChatIcons = specialChatIcons;

CH.StyleChatSLE = CH.StyleChat
function CH:StyleChat(frame)
	CH:StyleChatSLE(frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
local PixelOff = E.PixelMode and 31 or 27

function CH:PositionChat(override)
	if not self.db.lockPositions or ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	RightChatPanel:SetSize(E.db.chat.panelWidth, E.db.chat.panelHeight)
	LeftChatPanel:SetSize(E.db.chat.panelWidth, E.db.chat.panelHeight)	
	
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

	for i=1, CreatedFrames do
		local BASE_OFFSET = 60
		if E.PixelMode then
			BASE_OFFSET = BASE_OFFSET - 3
		end	
		chat = _G[format("ChatFrame%d", i)]
		chatbg = format("ChatFrame%dBackground", i)
		button = _G[format("ButtonCF%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		tab.isDocked = chat.isDocked
		tab.owner = chat
		if id > NUM_CHAT_WINDOWS then
			point = point or select(1, chat:GetPoint());
			if select(2, tab:GetPoint()):GetName() ~= bg then
				isDocked = true
			else
				isDocked = false
			end	
		end	

		
		if point == "BOTTOMRIGHT" and chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == self.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.sle.datatext.chathandle then
				if E.db.datatexts.rightChatPanel then
					chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3) -- <<< Changed
				else
					BASE_OFFSET = BASE_OFFSET - 24
					chat:Point("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 4, 4)
				end
				if id ~= 2 then
					chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - PixelOff)) -- <<< Changed
				else
					chat:Size(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - PixelOff) - CombatLogQuickButtonFrame_Custom:GetHeight())	
				end
			else
				if E.db.datatexts.rightChatPanel then
					chat:SetPoint("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 1, 3)
				else
					BASE_OFFSET = BASE_OFFSET - 24
					chat:SetPoint("BOTTOMLEFT", RightChatDataPanel, "BOTTOMLEFT", 1, 1)
				end
				if id ~= 2 then
					chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET))
				else
					chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET) - CombatLogQuickButtonFrame_Custom:GetHeight())				
				end
			end
			
			
			
			FCF_SavePositionAndDimensions(chat)			
			
			tab:SetParent(RightChatPanel)
			chat:SetParent(RightChatPanel)
			
			if chat:IsMovable() then
				chat:SetUserPlaced(true)
			end
			if E.db.chat.panelBackdrop == 'HIDEBOTH' or E.db.chat.panelBackdrop == 'LEFT' then
				CH:SetupChatTabs(tab, true)
			else
				CH:SetupChatTabs(tab, false)
			end
		elseif not isDocked and chat:IsShown() then
			tab:SetParent(UIParent)
			chat:SetParent(UIParent)
			
			CH:SetupChatTabs(tab, true)
		else
			if E.db.sle.datatext.chathandle then
				if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
					chat:ClearAllPoints()
					if E.db.datatexts.leftChatPanel then
						chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 5, 3)
					else
						BASE_OFFSET = BASE_OFFSET - 24
						chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 5, 3)
					end
					chat:Size(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - PixelOff)) -- <<< Changed
					FCF_SavePositionAndDimensions(chat)		
				end
			else
				if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
					chat:ClearAllPoints()
					if E.db.datatexts.leftChatPanel then
						chat:SetPoint("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 1, 3)
					else
						BASE_OFFSET = BASE_OFFSET - 24
						chat:SetPoint("BOTTOMLEFT", LeftChatToggleButton, "BOTTOMLEFT", 1, 1)
					end
					chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - BASE_OFFSET))
					FCF_SavePositionAndDimensions(chat)		
				end
			end
			chat:SetParent(LeftChatPanel)
			if i > 2 then
				tab:SetParent(GeneralDockManagerScrollFrameChild)
			else
				tab:SetParent(GeneralDockManager)
			end
			if chat:IsMovable() then
				chat:SetUserPlaced(true)
			end
			
			if E.db.chat.panelBackdrop == 'HIDEBOTH' or E.db.chat.panelBackdrop == 'RIGHT' then
				CH:SetupChatTabs(tab, true)
			else
				CH:SetupChatTabs(tab, false)
			end			
		end		
	end
	
	self.initialMove = true;
end

local function GetBNFriendColor(name, id)
	local _, _, game, _, _, _, _, class = BNGetToonInfo(id)

	if game ~= BNET_CLIENT_WOW or not class then
		return name
	else
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end

		if RAID_CLASS_COLORS[class] then
			return "|c"..RAID_CLASS_COLORS[class].colorStr..name.."|r"
		else
			return name
		end
	end
end

E.NameReplacements = {}
function CH:ChatFrame_MessageEventHandler(event, ...)
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];

		local filter = false;
		if ( chatFilters[event] ) then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
			for _, filterFunc in next, chatFilters[event] do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
				if ( filter ) then
					return true;
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
				end
			end
		end
		
		arg2 = E.NameReplacements[arg2] or arg2
		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
		
		local channelLength = strlen(arg4);
		local infoType = type;
		if ( (strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER")) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""];
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
					return;
				end
			end
			
			local found = 0;
			for index, value in pairs(self.channelList) do
				if ( channelLength > strlen(value) ) then
					-- arg9 is the channel name without the number in front...
					if ( ((arg7 > 0) and (self.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
						found = 1;
						infoType = "CHANNEL"..arg8;
						info = ChatTypeInfo[infoType];
						if ( (type == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") ) then
							self.channelList[index] = nil;
							self.zoneChannelList[index] = nil;
						end
						break;
					end
				end
			end
			if ( (found == 0) or not info ) then
				return true;
			end
		end

		local chatGroup = Chat_GetChatCategory(type);
		local chatTarget;
		if ( chatGroup == "CHANNEL" or chatGroup == "BN_CONVERSATION" ) then
			chatTarget = tostring(arg8);
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2);
			else
				chatTarget = arg2;
			end
		end
		
		if ( FCFManager_ShouldSuppressMessage(self, chatGroup, chatTarget) ) then
			return true;
		end
			
		if ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if ( self.privateMessageList and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			elseif ( self.excludePrivateMessageList and self.excludePrivateMessageList[strlower(arg2)] 
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("bnWhisperMode") ~= "popout_and_inline") ) ) then
				return true;
			end
		elseif ( chatGroup == "BN_CONVERSATION" ) then
			if ( self.bnConversationList and not self.bnConversationList[arg8] ) then
				return true;
			elseif ( self.excludeBNConversationList and self.excludeBNConversationList[arg8] and GetCVar("conversationMode") ~= "popout_and_inline") then
				return true;
			end
		end
		
		if (self.privateMessageList) then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if ( (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			end
			
			-- HACK to put certain system messages into dedicated whisper windows
			if ( chatGroup == "SYSTEM") then
				local matchFound = false;
				local message = strlower(arg1);
				for playerName, _ in pairs(self.privateMessageList) do
					local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, playerName));
					local charOnlineMsg = strlower(format(ERR_FRIEND_ONLINE_SS, playerName, playerName));
					local charOfflineMsg = strlower(format(ERR_FRIEND_OFFLINE_S, playerName));
					if ( message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg) then
						matchFound = true;
						break;
					end
				end

				if (not matchFound) then
					return true;
				end
			end
		end
	
		if ( type == "SYSTEM" or type == "SKILL" or type == "LOOT" or type == "CURRENCY" or type == "MONEY" or
		     type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
			self:AddMessage(CH:ConcatenateTimeStamp(arg1), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(CH:ConcatenateTimeStamp(arg1), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(CH:ConcatenateTimeStamp(arg1), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(CH:ConcatenateTimeStamp(arg1), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			self:AddMessage(format(CH:ConcatenateTimeStamp(arg1), "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h"), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			self:AddMessage(format(CH:ConcatenateTimeStamp(arg1), "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h"), info.r, info.g, info.b, info.id);
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(CH:ConcatenateTimeStamp(CHAT_IGNORED), arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(CH:ConcatenateTimeStamp(CHAT_FILTERED), arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(CH:ConcatenateTimeStamp(CHAT_RESTRICTED), info.r, info.g, info.b, info.id);
		elseif ( type == "CHANNEL_LIST") then
			if(channelLength > 0) then
				self:AddMessage(format(CH:ConcatenateTimeStamp(_G["CHAT_"..type.."_GET"]..arg1), tonumber(arg8), arg4), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(CH:ConcatenateTimeStamp(arg1), info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"];
			end
			
			globalString = CH:ConcatenateTimeStamp(globalstring);
			
			if(strlen(arg5) > 0) then
				-- TWO users in this notice (E.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id);
			elseif ( arg1 == "INVITE" ) then
				self:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"];
			end
			if ( arg10 > 0 ) then
				arg4 = arg4.." "..arg10;
			end
			
			globalString = CH:ConcatenateTimeStamp(globalstring);
			
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8);
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12);
			self:AddMessage(format(globalstring, arg8, arg4), info.r, info.g, info.b, info.id, false, accessID, typeID);
		elseif ( type == "BN_CONVERSATION_NOTICE" ) then
			local channelLink = format(CHAT_BN_CONVERSATION_GET_LINK, arg8, MAX_WOW_CHAT_CHANNELS + arg8);
			local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), arg8, arg2);
			local message = format(_G["CHAT_CONVERSATION_"..arg1.."_NOTICE"], channelLink, playerLink)
			
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8);
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12);
			self:AddMessage(CH:ConcatenateTimeStamp(message), info.r, info.g, info.b, info.id, false, accessID, typeID);
		elseif ( type == "BN_CONVERSATION_LIST" ) then
			local channelLink = format(CHAT_BN_CONVERSATION_GET_LINK, arg8, MAX_WOW_CHAT_CHANNELS + arg8);
			local message = format(CHAT_BN_CONVERSATION_LIST, channelLink, arg1);
			self:AddMessage(CH:ConcatenateTimeStamp(message), info.r, info.g, info.b, info.id, false, accessID, typeID);
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then	
			if ( arg1 == "FRIEND_OFFLINE" and not BNet_ShouldProcessOfflineEvents() ) then
				return true;
			end
			local globalstring = _G["BN_INLINE_TOAST_"..arg1];
			local message;
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring;
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites());
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2);
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE") then
				local hasFocus, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(arg13);
				if (toonName and toonName ~= "" and client and client ~= "") then
					local toonNameText = BNet_GetClientEmbeddedTexture(client, 14)..toonName;
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s] (%s)|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2, toonNameText);
					message = format(globalstring, playerLink);
				else
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
					message = format(globalstring, playerLink);
				end
			else
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
				message = format(globalstring, playerLink);
			end
			self:AddMessage(CH:ConcatenateTimeStamp(message), info.r, info.g, info.b, info.id);
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
				self:AddMessage(format(CH:ConcatenateTimeStamp(BN_INLINE_TOAST_BROADCAST), playerLink, arg1), info.r, info.g, info.b, info.id);
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				self:AddMessage(CH:ConcatenateTimeStamp(BN_INLINE_TOAST_BROADCAST_INFORM), info.r, info.g, info.b, info.id);
			end
		elseif ( type == "BN_INLINE_TOAST_CONVERSATION" ) then
			self:AddMessage(format(CH:ConcatenateTimeStamp(BN_INLINE_TOAST_CONVERSATION), arg1), info.r, info.g, info.b, info.id);
		else
			local body;

			local _, fontHeight = FCF_GetChatWindowInfo(self:GetID());
			
			if ( fontHeight == 0 ) then
				--fontHeight will be 0 if it's still at the default (14)
				fontHeight = 14;
			end
			
			-- Add AFK/DND flags
			local pflag = "";
			if(strlen(arg6) > 0) then
				if ( arg6 == "GM" ) then
					--If it was a whisper, dispatch it to the GMChat addon.
					if ( type == "WHISPER" ) then
						return;
					end
					--Add Blizzard Icon, this was sent by a GM
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				elseif ( arg6 == "DEV" ) then
					--Add Blizzard Icon, this was sent by a Dev
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				elseif ( arg6 == "DND" or arg6 == "AFK") then
					pflag = SLE:GetChatIcon(arg2).._G["CHAT_FLAG_"..arg6]
				else					
					pflag = _G["CHAT_FLAG_"..arg6];
				end
			else
				pflag = SLE:GetChatIcon(arg2)
				
				if(pflag == true) then
					pflag = ""
				end
				
				if(lfgRoles[arg2] and SLE:SimpleTable(lfgChannels, type)) then
					pflag = lfgRoles[arg2]..pflag
				end
				
				pflag = pflag or ""
			end
			
			if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
				return;
			end

			local showLink = 1;
			if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil;
			else
				arg1 = gsub(arg1, "%%", "%%%%");
			end
			
			-- Search for icon links and replace them with texture links.
			for tag in gmatch(arg1, "%b{}") do
				local term = strlower(gsub(tag, "[{}]", ""));
				if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
					arg1 = gsub(arg1, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
				elseif ( GROUP_TAG_LIST[term] ) then
					local groupIndex = GROUP_TAG_LIST[term];
					local groupList = "[";
					for i=1, GetNumGroupMembers() do
						local name, rank, subgroup, level, class, classFileName = GetRaidRosterInfo(i);
						if ( name and subgroup == groupIndex ) then
							local classColorTable = RAID_CLASS_COLORS[classFileName];
							if ( classColorTable ) then
								name = format("\124cff%.2x%.2x%.2x%s\124r", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, name);
							end
							groupList = groupList..(groupList == "[" and "" or PLAYER_LIST_DELIMITER)..name;
						end
					end
					groupList = groupList.."]";
					arg1 = gsub(arg1, tag, groupList);
				end
			end
			
			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1);
			
			local playerLink;

			if ( type ~= "BN_WHISPER" and type ~= "BN_WHISPER_INFORM" and type ~= "BN_CONVERSATION" ) then
				playerLink = "|Hplayer:"..arg2..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h";
			else
				coloredName = GetBNFriendColor(arg2, arg13)
				playerLink = "|HBNplayer:"..arg2..":"..arg13..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h";
			end
			
			local message = arg1;
			if ( arg14 ) then	--isMobile
				message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message;
			end
			
			if ( (strlen(arg3) > 0) and (arg3 ~= self.defaultLanguage) ) then
				local languageHeader = "["..arg3.."] ";
				if ( showLink and (strlen(arg2) > 0) ) then
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink.."["..coloredName.."]".."|h");
				else
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2);
				end
			else
				if ( not showLink or strlen(arg2) == 0 ) then
					if ( type == "TEXT_EMOTE" ) then
						body = message;
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2);
					end
				else
					if ( type == "EMOTE" ) then
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink..coloredName.."|h");
					elseif ( type == "TEXT_EMOTE") then
						body = gsub(message, arg2, pflag..playerLink..coloredName.."|h", 1);
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink.."["..coloredName.."]".."|h");
					end
				end
			end

			-- Add Channel
			arg4 = gsub(arg4, "%s%-%s.*", "");
			if( chatGroup  == "BN_CONVERSATION" ) then
				body = format(CHAT_BN_CONVERSATION_GET_LINK, MAX_WOW_CHAT_CHANNELS + arg8, MAX_WOW_CHAT_CHANNELS + arg8)..body;
			elseif(channelLength > 0) then
				body = "|Hchannel:channel:"..arg8.."|h["..arg4.."]|h "..body;
			end
			
			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget);
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 == "" and arg13 or arg12);
			if CH.db.shortChannels then
				body = body:gsub("|Hchannel:(.-)|h%[(.-)%]|h", CH.ShortChannel)
				body = body:gsub('CHANNEL:', '')
				body = body:gsub("^(.-|h) "..L['whispers'], "%1")
				body = body:gsub("^(.-|h) "..L['says'], "%1")
				body = body:gsub("^(.-|h) "..L['yells'], "%1")
				body = body:gsub("<"..AFK..">", "[|cffFF0000"..L['AFK'].."|r] ")
				body = body:gsub("<"..DND..">", "[|cffE7E716"..L['DND'].."|r] ")
				body = body:gsub("%[BN_CONVERSATION:", '%['.."")			
				body = body:gsub("^%["..RAID_WARNING.."%]", '['..L['RW']..']')	
			end
			self:AddMessage(CH:ConcatenateTimeStamp(body), info.r, info.g, info.b, info.id, false, accessID, typeID);
		end
 
		if ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type);
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				PlaySound("TellMessage");
			end
			self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
			--FCF_FlashTab(self);
		end
		
		if ( not self:IsShown() ) then
			if ( (self == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (self ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
				if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then	--BN_WHISPER FIXME
					if (not (type == "BN_CONVERSATION" and BNIsSelf(arg13))) then
						if (not FCFManager_ShouldSuppressMessageFlash(self, chatGroup, chatTarget) ) then
							--FCF_StartAlertFlash(self); THIS TAINTS<<<<<<<
							_G[self:GetName().."Tab"].glow:Show()
							_G[self:GetName().."Tab"]:SetScript("OnUpdate", CH.ChatTab_OnUpdate)
						end
					end
				end
			end
		end
		return true;
	end
end

function CH:ChatEdit_AddHistory(editBox, line)
	if line:find("/rl") then return; end

	if ( strlen(line) > 0 ) then
		for i, text in pairs(ElvCharacterDB.ChatEditHistory) do
			if text == line then
				return
			end
		end

		tinsert(ElvCharacterDB.ChatEditHistory, #ElvCharacterDB.ChatEditHistory + 1, line)
		if #ElvCharacterDB.ChatEditHistory > E.db.chat.editboxhistory then
			for i=1,(#ElvCharacterDB.ChatEditHistory - E.db.chat.editboxhistory) do
				tremove(ElvCharacterDB.ChatEditHistory, 1)
			end
		end
	end
end

function SLE:GetChatIcon(sender)
	local senderName, senderRealm
	if sender then
		senderName, senderRealm = string.split('-', sender)
	else
		senderName = Myname
	end
	senderRealm = senderRealm or PLAYER_REALM
	senderRealm = senderRealm:gsub(' ', '')
		
	--Disabling ALL special icons. IDK why Elv use that and why would we want to have that but whatever
	if(specialChatIcons[PLAYER_REALM] == nil or (specialChatIcons[PLAYER_REALM] and specialChatIcons[PLAYER_REALM][Myname] ~= true)) then
		if specialChatIcons[senderRealm] and specialChatIcons[senderRealm][senderName] then
			return specialChatIcons[senderRealm][senderName]
		end
	end
	
	if not IsInGuild() then return "" end
	if not E.private.sle.guildmaster then return "" end
	if senderName == GMName and senderRealm == GMRealm then
		return leader 
	end
	
	return ""
end

function CH:ChatFrame_AddMessageEventFilter (event, filter)
	assert(event and filter);
	
	if ( chatFilters[event] ) then
		-- Only allow a filter to be added once
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				return;
			end
		end
	else
		chatFilters[event] = {};
	end
	
	tinsert(chatFilters[event], filter);
end

function CH:ChatFrame_RemoveMessageEventFilter (event, filter)
	assert(event and filter);
	
	if ( chatFilters[event] ) then
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				tremove(chatFilters[event], index);
			end
		end
		
		if ( #chatFilters[event] == 0 ) then
			chatFilters[event] = nil;
		end
	end
end

function CH:CheckLFGRoles()
	local isInGroup, isInRaid = IsInGroup(), IsInRaid()
	local unit = isInRaid and "raid" or "party"
	local name, realm
	twipe(lfgRoles)

	if(not isInGroup or not self.db.lfgIcons) then return end

	local role = UnitGroupRolesAssigned("player")
	if(role) then
		lfgRoles[PLAYER_NAME] = rolePaths[role]
	end

	for i=1, GetNumGroupMembers() do
		if(UnitExists(unit..i) and not UnitIsUnit(unit..i, "player")) then
			role = UnitGroupRolesAssigned(unit..i)
			local name, realm = UnitName(unit..i)

			if(role and name) then
				name = realm and name..'-'..realm or name..'-'..PLAYER_REALM;
				lfgRoles[name] = rolePaths[role]
			end
		end
	end
end

function CH:GMCheck()
	local name, rank
	if GetNumGuildMembers() == 0 and IsInGuild() then E:Delay(2, CH.GMCheck); return end
	if not IsInGuild() then GuildMaster = ""; GMName = ''; GMRealm = ''; return end
	for i = 1, GetNumGuildMembers() do
		name, _, rank = GetGuildRosterInfo(i)
		if rank == 0 then
			break
		end
	end
	
	GuildMaster = name
	if GuildMaster then
		GMName, GMRealm = string.split('-', GuildMaster)
	end
	GMRealm = GMRealm or PLAYER_REALM
	GMRealm = GMRealm:gsub(' ', '')
end

function CH:GMIconUpdate()
	if E.private.chat.enable ~= true then return end
	if E.private.sle.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', 'Roster')
		CH:GMCheck()
	else
		self:UnregisterEvent('GUILD_ROSTER_UPDATE')
		GuildMaster = ""
		GMName = ''
		GMRealm = ''
	end
end

function CH:Roster(event, update)
 if update then CH:GMCheck() end
end

function CH:Initialize()
	if ElvCharacterDB.ChatHistory then
		ElvCharacterDB.ChatHistory = nil --Depreciated
	end
	
	self.db = E.db.chat

	if E.private.chat.enable ~= true then 
		stopScript = true
		DEFAULT_CHAT_FRAME:RegisterEvent("GUILD_MOTD")

		local msg = GetGuildRosterMOTD()
		if msg == "" then msg = nil end		
		if msg then
			ChatFrame_SystemEventHandler(DEFAULT_CHAT_FRAME, "GUILD_MOTD", msg)
		end

		return 
	end


	if not ElvCharacterDB.ChatEditHistory then
		ElvCharacterDB.ChatEditHistory = {};
	end
	
	if not ElvCharacterDB.ChatLog or not self.db.chatHistory then
		ElvCharacterDB.ChatLog = {};
	end
	
	self:UpdateChatKeywords()
	
	self:UpdateFading()
	E.Chat = self
	self:SecureHook('ChatEdit_OnEnterPressed')
	FriendsMicroButton:Kill()
	ChatFrameMenuButton:Kill()

		
    if WIM then
      WIM.RegisterWidgetTrigger("chat_display", "whisper,chat,w2w,demo", "OnHyperlinkClick", function(self) CH.clickedframe = self end);
	  WIM.RegisterItemRefHandler('url', WIM_URLLink)
    end

	self:SecureHook('FCF_SetChatWindowFontSize', 'SetChatFont')
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'DelayGMOTD')
	self:RegisterEvent('UPDATE_CHAT_WINDOWS', 'SetupChat')
	self:RegisterEvent('UPDATE_FLOATING_CHAT_WINDOWS', 'SetupChat')
	self:RegisterEvent('PET_BATTLE_CLOSE')
	if E.private.sle.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', 'Roster')
		CH:GMCheck()
	end

	self:SetupChat()
	self:UpdateAnchors()
	
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckLFGRoles")

	self:RegisterEvent('CHAT_MSG_INSTANCE_CHAT', 'SaveChatHistory')
	self:RegisterEvent('CHAT_MSG_INSTANCE_CHAT_LEADER', 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_BN_WHISPER", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_CHANNEL", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_EMOTE", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_GUILD", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_OFFICER", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_PARTY", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_RAID", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_RAID_LEADER", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_RAID_WARNING", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_SAY", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_WHISPER", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM", 'SaveChatHistory')
	self:RegisterEvent("CHAT_MSG_YELL", 'SaveChatHistory')
	
	--First get all pre-existing filters and copy them to our version of chatFilters using ChatFrame_GetMessageEventFilters
	for name, _ in pairs(ChatTypeGroup) do
		for i=1, #ChatTypeGroup[name] do
			local filterFuncTable = ChatFrame_GetMessageEventFilters(ChatTypeGroup[name][i])
			if filterFuncTable then
				chatFilters[ChatTypeGroup[name][i]] = {};

				for j=1, #filterFuncTable do
					local filterFunc = filterFuncTable[j]
					tinsert(chatFilters[ChatTypeGroup[name][i]], filterFunc);
				end
			end
		end
	end
	
	--CHAT_MSG_CHANNEL isn't located inside ChatTypeGroup
	local filterFuncTable = ChatFrame_GetMessageEventFilters("CHAT_MSG_CHANNEL")
	if filterFuncTable then
		chatFilters["CHAT_MSG_CHANNEL"] = {};

		for j=1, #filterFuncTable do
			local filterFunc = filterFuncTable[j]
			tinsert(chatFilters["CHAT_MSG_CHANNEL"], filterFunc);
		end
	end
			
	--Now hook onto Blizzards functions for other addons
	self:SecureHook("ChatFrame_AddMessageEventFilter");
	self:SecureHook("ChatFrame_RemoveMessageEventFilter");
	
	self:SecureHook("FCF_SetWindowAlpha")
	
	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CH.CHAT_MSG_CHANNEL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CH.CHAT_MSG_YELL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CH.CHAT_MSG_SAY)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CH.FindURL)	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", CH.FindURL)	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", CH.FindURL)
	

	GeneralDockManagerOverflowButton:ClearAllPoints()
	GeneralDockManagerOverflowButton:Point('BOTTOMRIGHT', LeftChatTab, 'BOTTOMRIGHT', -2, 2)
	GeneralDockManagerOverflowButtonList:SetTemplate('Transparent')
	hooksecurefunc(GeneralDockManagerScrollFrame, 'SetPoint', function(self, point, anchor, attachTo, x, y)
		if anchor == GeneralDockManagerOverflowButton and x == 0 and y == 0 then
			self:SetPoint(point, anchor, attachTo, -2, -6)
		end
	end)	
	
	if self.db.chatHistory then
		self.SoundPlayed = true;
		self:DisplayChatHistory()
		self.SoundPlayed = nil;
	end
		
	
	local S = E:GetModule('Skins')
	S:HandleNextPrevButton(CombatLogQuickButtonFrame_CustomAdditionalFilterButton, true)
	local frame = CreateFrame("Frame", "CopyChatFrame", E.UIParent)
	tinsert(UISpecialFrames, "CopyChatFrame")
	frame:SetTemplate('Transparent')
	frame:Size(700, 200)
	frame:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 3)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")


	local scrollArea = CreateFrame("ScrollFrame", "CopyChatScrollFrame", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	S:HandleScrollBar(CopyChatScrollFrameScrollBar)

	local editBox = CreateFrame("EditBox", "CopyChatFrameEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:Width(scrollArea:GetWidth())
	editBox:Height(200)
	editBox:SetScript("OnEscapePressed", function() CopyChatFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	CopyChatFrameEditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then return end
		local _, max = CopyChatScrollFrameScrollBar:GetMinMaxValues()
		for i=1, max do
			ScrollFrameTemplate_OnMouseWheel(CopyChatScrollFrame, -1)
		end
	end)		

	local close = CreateFrame("Button", "CopyChatFrameCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT")
	close:SetFrameLevel(close:GetFrameLevel() + 1)
	close:EnableMouse(true)
	
	S:HandleCloseButton(close)	

	--Disable Blizzard
	InterfaceOptionsSocialPanelTimestampsButton:SetAlpha(0)
	InterfaceOptionsSocialPanelTimestampsButton:SetScale(0.000001)
	InterfaceOptionsSocialPanelTimestamps:SetAlpha(0)
	InterfaceOptionsSocialPanelTimestamps:SetScale(0.000001)
	
	InterfaceOptionsSocialPanelChatStyle:EnableMouse(false)
	InterfaceOptionsSocialPanelChatStyleButton:Hide()
	InterfaceOptionsSocialPanelChatStyle:SetAlpha(0)

 	CombatLogQuickButtonFrame_CustomAdditionalFilterButton:Size(20, 22)
 	CombatLogQuickButtonFrame_CustomAdditionalFilterButton:Point("TOPRIGHT", CombatLogQuickButtonFrame_Custom, "TOPRIGHT", 0, -1)
end

