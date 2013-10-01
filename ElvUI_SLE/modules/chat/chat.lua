local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local SLE = E:GetModule('SLE');
local LSM = LibStub("LibSharedMedia-3.0")
local CreatedFrames = 0;
local lfgRoles = {};
local lfgChannels = {
	"PARTY_LEADER",
	"PARTY",
	"RAID",
	"RAID_LEADER",
	"INSTANCE_CHAT",
	"INSTANCE_CHAT_LEADER",
}

local tinsert, tremove, tsort, twipe, tconcat = table.insert, table.remove, table.sort, table.wipe, table.concat

--Textures for chat--
do
--Normal LFG textures
CHAT_FLAG_TANK = "|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:15:15:0:0:64:64:2:56:2:56|t"
CHAT_FLAG_HEALER = "|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:15:15:0:0:64:64:2:56:2:56|t"
CHAT_FLAG_DAMAGER = "|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:15:15|t"
--Adapt
CHAT_FLAG_SLEADAPT = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\adapt.tga:0:2|t"
CHAT_FLAG_SLEADAPTTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLEADAPT
CHAT_FLAG_SLEADAPTHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLEADAPT
CHAT_FLAG_SLEADAPTDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLEADAPT
--Authors
--Repooc
CHAT_FLAG_SLEAUTHOR = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo.tga:0:2|t"
CHAT_FLAG_SLEAUTHORTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLEAUTHOR
CHAT_FLAG_SLEAUTHORHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLEAUTHOR
CHAT_FLAG_SLEAUTHORDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLEAUTHOR
--Darth
CHAT_FLAG_SLEAUTHORD = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_LogoD.tga:0:2|t"
CHAT_FLAG_SLEAUTHORDTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLEAUTHORD
CHAT_FLAG_SLEAUTHORDHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLEAUTHORD
CHAT_FLAG_SLEAUTHORDDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLEAUTHORD
--Roleplayers
CHAT_FLAG_SLERPG = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_RPG:13:35|t"
CHAT_FLAG_SLERPGTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLERPG
CHAT_FLAG_SLERPGHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLERPG
CHAT_FLAG_SLERPGDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLERPG
--Friends
CHAT_FLAG_SLEFRIEND = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Friend:13:13|t"
CHAT_FLAG_SLEFRIENDTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLEFRIEND
CHAT_FLAG_SLEFRIENDHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLEFRIEND
CHAT_FLAG_SLEFRIENDDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLEFRIEND
--Testers
CHAT_FLAG_SLETEST = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Test:13:13|t"
CHAT_FLAG_SLETESTTANK = CHAT_FLAG_TANK..CHAT_FLAG_SLETEST
CHAT_FLAG_SLETESTHEALER = CHAT_FLAG_HEALER..CHAT_FLAG_SLETEST
CHAT_FLAG_SLETESTDAMAGER = CHAT_FLAG_DAMAGER..CHAT_FLAG_SLETEST
end

--Toon table
local IconTable = {
	["Illidan"] = {
		--Darth's toon
		["Darthpred"] = "SLEAUTHORD",
		--Repooc's Toon
		["Repøøc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["СвежевательДуш"] = {
		--Darth's toons
		["Дартпредатор"] = "SLEAUTHORD",
		["Алея"] = "SLEAUTHORD",
		["Ваззули"] = "SLEAUTHORD",
		["Сиаранна"] = "SLEAUTHORD",
		["Джатон"] = "SLEAUTHORD",
		["Фикстер"] = "SLEAUTHORD",
		["Киландра"] = "SLEAUTHORD",
		["Нарджо"] = "SLEAUTHORD",
		["Верзук"] = "SLEAUTHORD",
		["Крениг"] = "SLEAUTHORD",
		["Мейжи"] = "SLEAUTHORD",
		["Большойгном"] = "SLETEST", --Testing toon
		["Фергесон"] = "SLEFRIEND"
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Дартпредатор"] = "SLEAUTHORD",
		["Алея"] = "SLEAUTHORD",
		["Ваззули"] = "SLEAUTHORD",
		["Сиаранна"] = "SLEAUTHORD",
		["Джатон"] = "SLEAUTHORD",
		["Фикстер"] = "SLEAUTHORD",
		["Киландра"] = "SLEAUTHORD",
		["Нарджо"] = "SLEAUTHORD",
		["Верзук"] = "SLEAUTHORD",
		["Крениг"] = "SLEAUTHORD",
		["Мейжи"] = "SLEAUTHORD",
		--Darth's friends
		["Леани"] = "SLEFRIEND",
		--Da tester lol
		["Харореанн"] = "SLETEST"
	},
	["Ревущийфьорд"] = {
		["Рыжая"] = "SLEFRIEND",
		["Рыжа"] = "SLEFRIEND",
				--Some people
		["Брэгар"] = "SLETEST"
	},
	["Азурегос"] = {
		["Брэгари"] = "SLETEST"
	},
	["Korialstrasz"] = {
		["Cursewordz"] = "SLEAUTHOR"
	},
	["Spirestone"] = {
		["Sifupooc"] = "SLEAUTHOR",
		["Dapooc"] = "SLEAUTHOR",
		["Lapooc"] = "SLEAUTHOR",
		["Warpooc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR",
		--Adapt Roster
		["Mobius"] = "SLEADAPT",
		["Urgfelstorm"] = "SLEADAPT",
		["Kilashandra"] = "SLEADAPT",
		["Electrro"] = "SLEADAPT",
		["Afterthot"] = "SLEADAPT",
		["Lavathing"] = "SLEADAPT",
		["Finkle"] = "SLEADAPT"
	},
	["Andorhal"] = {
		["Dapooc"] = "SLEAUTHOR",
		["Rovert"] = "SLEAUTHOR",
		["Sliceoflife"] = "SLEAUTHOR"
	},
}

function CH:CheckLFGRoles()
	local isInGroup, isInRaid = IsInGroup(), IsInRaid()
	local unit = isInRaid and "raid" or "party"
	
	twipe(lfgRoles)
	if(not isInGroup or not self.db.lfgIcons) then return end
	local role = UnitGroupRolesAssigned("player")
	if(role) then
		lfgRoles[E.myname] = role
	end
	for i=1, GetNumGroupMembers() do
		if(UnitExists(unit..i) and not UnitIsUnit(unit..i, "player")) then
			role = UnitGroupRolesAssigned(unit..i)
			local name = GetUnitName(unit..i, true)
			if(role and name) then
				lfgRoles[name] = rolePaths[role]
			end
		end
	end
end

function SLE:CheckFlag(sender, checkFlag)
	local senderName, senderRealm

	if sender then
		senderName, senderRealm = string.split('-', sender)
	else
		senderName = E.myname
	end

	senderRealm = senderRealm or E.myrealm
	senderRealm = senderRealm:gsub(' ', '')
	
	if IconTable[senderRealm] and IconTable[senderRealm][senderName] then
		if checkFlag then
			return IconTable[senderRealm][senderName] == checkFlag
		else
			return IconTable[senderRealm][senderName]
		end
	end
	
	return false
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

CH.StyleChatSLE = CH.StyleChat
function CH:StyleChat(frame)
	CH:StyleChatSLE(frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
function CH:PositionChat(override)
	if not self.db.lockPositions or ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	RightChatPanel:Size(E.db.chat.panelWidth, E.db.chat.panelHeight)
	LeftChatPanel:Size(E.db.chat.panelWidth, E.db.chat.panelHeight)	
	
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

		if point == "BOTTOMRIGHT" and chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and not isDocked and id == self.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3) -- <<< Changed
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:Point("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 4, 3)
			end
			if id ~= 2 then
				chat:SetSize(E.db.chat.panelWidth - 10, (E.db.chat.panelHeight - (E.PixelMode and 31 or 27))) -- <<< Changed
			else
				chat:Size(E.db.chat.panelWidth - 10, (E.db.chat.panelHeight - (E.PixelMode and 31 or 27)) - CombatLogQuickButtonFrame_Custom:GetHeight())	
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
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				chat:ClearAllPoints()
				if E.db.datatexts.leftChatPanel then
					chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 5, 3)
				else
					BASE_OFFSET = BASE_OFFSET - 24
					chat:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 5, 3)
				end
				chat:Size(E.db.chat.panelWidth - 6, (E.db.chat.panelHeight - (E.PixelMode and 31 or 27))) -- <<< Changed
				FCF_SavePositionAndDimensions(chat)		
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
local function SLEfilter(self, event, message, author, arg3, arg4, arg5, arg6, ...)
	local returnTex = arg6
	local type = strsub(event, 10);
	if(strlen(arg6) > 0) then
	elseif SLE:CheckFlag(author) then
		if(returnTex == ""  and lfgRoles[author] and SLE:SimpleTable(lfgChannels, type)) then
			returnTex = SLE:CheckFlag(author)..lfgRoles[author]
		else
			returnTex = SLE:CheckFlag(author)
		end
	elseif not SLE:CheckFlag(author) then
		if(returnTex == "" and lfgRoles[author] and SLE:SimpleTable(lfgChannels, type)) then
			returnTex = lfgRoles[author]
		end
	end
	if returnTex == nil then
		returnTex = arg6
	else
		returnTex = returnTex..arg6
	end
	return false, message, author, arg3, arg4, arg5, returnTex, ...
end

--Applying filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", SLEfilter)	
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", SLEfilter)	
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", SLEfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", SLEfilter)