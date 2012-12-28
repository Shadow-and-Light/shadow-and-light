local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local LSM = LibStub("LibSharedMedia-3.0")

local specialChatIcons = {
	["Kil'jaeden"] = {
		["Elvz"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t"
	},
	["Illidan"] = {
		["Affinichi"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\Bathrobe_Chat_Logo.blp:15:15|t",
		["Uplift"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\Bathrobe_Chat_Logo.blp:15:15|t",
		["Affinitii"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\Bathrobe_Chat_Logo.blp:15:15|t",
		["Affinity"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\Bathrobe_Chat_Logo.blp:15:15|t",
		--Darth's toon
		["Darthpred"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		--Repooc's Toon
		["Repooc"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
	},
	["Свежеватель Душ"] = {
		--Darth's toons
		["Дартпредатор"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Алея"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Ваззули"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Сиаранна"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Джатон"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Фикстер"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Киландра"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Нарджо"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Верзук"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Большойгном"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Крениг"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
	},
	["Вечная Песня"] = {
		--Darth's toons
		["Киландра"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Равенор"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Налкас"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Ваззули"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		--Darth's friends
		["Леани"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
	},
	["Korialstrasz"] = {
		["Sifupooc"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Repooc"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Cursewordz"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
	},
	["Andorhal"] = {
		["Dapooc"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Rovert"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t",
		["Sliceoflife"] = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:13:22|t"
	},
}

function CH:ChatEdit_AddHistory(editBox, line)
	if line:find("/rl") then return; end

	if ( strlen(line) > 0 ) then
		for i, text in pairs(ElvCharacterDB.ChatEditHistory) do
			if text == line then
				return
			end
		end

		table.insert(ElvCharacterDB.ChatEditHistory, #ElvCharacterDB.ChatEditHistory + 1, line)
		if #ElvCharacterDB.ChatEditHistory > E.db.chat.editboxhistory then
			for i=1,(#ElvCharacterDB.ChatEditHistory - E.db.chat.editboxhistory) do
				table.remove(ElvCharacterDB.ChatEditHistory, 1)
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

function CH:AddMessage(text, ...)
	if type(text) == "string" then		
		if CH.db.shortChannels then
			text = text:gsub("|Hchannel:(.-)|h%[(.-)%]|h", CH.ShortChannel)
			text = text:gsub('CHANNEL:', '')
			text = text:gsub("^(.-|h) "..L['whispers'], "%1")
			text = text:gsub("^(.-|h) "..L['says'], "%1")
			text = text:gsub("^(.-|h) "..L['yells'], "%1")
			text = text:gsub("<"..AFK..">", "[|cffFF0000"..L['AFK'].."|r] ")
			text = text:gsub("<"..DND..">", "[|cffE7E716"..L['DND'].."|r] ")
			text = text:gsub("^%["..RAID_WARNING.."%]", '['..L['RW']..']')	
			text = text:gsub("%[BN_CONVERSATION:", '%['..L["BN:"])
		end

		local timeStamp
		if CHAT_TIMESTAMP_FORMAT ~= nil then
			timeStamp = BetterDate(CHAT_TIMESTAMP_FORMAT, time());
			text = text:gsub(timeStamp, '')
		end
		
		--Add Timestamps
		if ( CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE' ) then
			timeStamp = BetterDate(CH.db.timeStampFormat, CH.timeOverride or time());
			timeStamp = timeStamp:gsub(' ', '')
			timeStamp = timeStamp:gsub('AM', ' AM')
			timeStamp = timeStamp:gsub('PM', ' PM')
			text = '|cffB3B3B3['..timeStamp..'] |r'..text
		end
		
		if specialChatIcons[E.myrealm] then
			for character, texture in pairs(specialChatIcons[E.myrealm]) do
				text = text:gsub('|Hplayer:'..character..':', texture..'|Hplayer:'..character..':')
			end
			
			for realm, _ in pairs(specialChatIcons) do
				if realm ~= E.myrealm then
					for character, texture in pairs(specialChatIcons[realm]) do
						text = text:gsub("|Hplayer:"..character.."%-"..realm, texture.."|Hplayer:"..character.."%-"..realm)
					end
				end
			end			
		else
			for realm, _ in pairs(specialChatIcons) do
				for character, texture in pairs(specialChatIcons[realm]) do
					text = text:gsub("|Hplayer:"..character.."%-"..realm, texture.."|Hplayer:"..character.."%-"..realm)
				end
			end		
		end
		
		CH.timeOverride = nil;
	end

	self.OldAddMessage(self, text, ...)
end

--[[CH.AddMessageSLE = CH.AddMessage
function CH:AddMessage()
	CH.AddMessageSLE(self)
	
	for i=1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == "FontString" and not region.hooked then
			local text = region:GetText();
			if specialIcons[E.myrealm] then
				for character, texture in pairs(specialIcons[E.myrealm]) do
					text = text:gsub('|Hplayer:'..character..':', texture..'|Hplayer:'..character..':')
				end
				
				for realm, _ in pairs(specialIcons) do
					if realm ~= E.myrealm then
						for character, texture in pairs(specialIcons[realm]) do
							text = text:gsub("|Hplayer:"..character.."%-"..realm, texture.."|Hplayer:"..character.."%-"..realm)
						end
					end
				end			
			else
				for realm, _ in pairs(specialIcons) do
					for character, texture in pairs(specialIcons[realm]) do
						text = text:gsub("|Hplayer:"..character.."%-"..realm, texture.."|Hplayer:"..character.."%-"..realm)
					end
				end		
			end
			
			region:SetText(text)
			CH.timeOverride = nil;
		end
	end
end]]