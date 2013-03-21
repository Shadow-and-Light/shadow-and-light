local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local SLE = E:GetModule('SLE');
local LSM = LibStub("LibSharedMedia-3.0")

--Textures for chat
CHAT_FLAG_SLEAUTHOR = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
CHAT_FLAG_SLERPG = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_RPG:13:35|t"
CHAT_FLAG_SLEFRIEND = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Friend:13:13|t"
CHAT_FLAG_SLETEST = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Test:13:13|t"
--Toon table
local IconTable = {
	["Illidan"] = {
		--Darth's toon
		["Darthpred"] = "SLEAUTHOR",
		--Repooc's Toon
		["Repøøc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["СвежевательДуш"] = {
		--Darth's toons
		["Дартпредатор"] = "SLEAUTHOR",
		["Алея"] = "SLEAUTHOR",
		["Ваззули"] = "SLEAUTHOR",
		["Сиаранна"] = "SLEAUTHOR",
		["Джатон"] = "SLEAUTHOR",
		["Фикстер"] = "SLEAUTHOR",
		["Киландра"] = "SLEAUTHOR",
		["Нарджо"] = "SLEAUTHOR",
		["Верзук"] = "SLEAUTHOR",
		["Крениг"] = "SLEAUTHOR",
		["Большойгном"] = "SLETEST", --Testing toon
		--Da tester lol
		["Фергесон"] = "SLETEST" 
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Киландра"] = "SLEAUTHOR",
		["Равенор"] = "SLEAUTHOR",
		["Налкас"] = "SLEAUTHOR",
		["Ваззули"] = "SLEAUTHOR",
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
	["Korialstrasz"] = {
		["Sifupooc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR",
		["Cursewordz"] = "SLEAUTHOR"
	},
	["Andorhal"] = {
		["Dapooc"] = "SLEAUTHOR",
		["Rovert"] = "SLEAUTHOR",
		["Sliceoflife"] = "SLEAUTHOR"
	},
}

function SLE:Auth()
	local myRealm = E.myrealm
	local myName = E.myname
	myRealm = myRealm:gsub(' ', '')
	if IconTable[myRealm] then
		for character, flag in pairs(IconTable[myRealm]) do
			if character == myName and flag == "SLEAUTHOR" then
				return true
			end
		end
	end
	return false
end

function SLE:CrossAuth(sender)
	local myRealm = E.myrealm
	local myName = E.myname
	myRealm = myRealm:gsub(' ', '')
	if IconTable[myRealm] then
		for character, flag in pairs(IconTable[myRealm]) do
			if sender == character and flag == "SLEAUTHOR" and sender ~= myName then
				return true
			end							
		end
				
		for realm, _ in pairs(IconTable) do
			if realm ~= myRealm then
				for character, flag in pairs(IconTable[realm]) do
					if sender == character.."-"..realm and flag == "SLEAUTHOR" then
						return true
					end			
				end
			end
		end			
	else
		for realm, _ in pairs(IconTable) do
			for character, flag in pairs(IconTable[realm]) do
				if sender == character.."-"..realm and flag == "SLEAUTHOR" then
					return true
				end		
			end
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

	CreatedFrames = id
	
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

--Adding icons to specific toons' names
--Filter
local function SLEfilter(self, event, message, author, arg3, arg4, arg5, arg6, ...)
    local returnTex = arg6
	local myRealm = E.myrealm
	myRealm = myRealm:gsub(' ', '')
	if(strlen(arg6) > 0) then
	else
		if IconTable[myRealm] then
			for character, flag in pairs(IconTable[myRealm]) do
				if author == character and flag then
					returnTex = flag..arg6
				end							
			end
					
			for realm, _ in pairs(IconTable) do
				if realm ~= myRealm then
					for character, flag in pairs(IconTable[realm]) do
						if author == character.."-"..realm and flag then
							returnTex = flag..arg6
						end			
					end
				end
			end			
		else
			for realm, _ in pairs(IconTable) do
				for character, flag in pairs(IconTable[realm]) do
					if author == character.."-"..realm and flag then
						returnTex = flag..arg6
					end		
				end
			end		
		end
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