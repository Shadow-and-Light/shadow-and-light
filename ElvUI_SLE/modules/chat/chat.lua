local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')
local LSM = LibStub("LibSharedMedia-3.0")

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

local specialIcons = {
	["Свежеватель Душ"] = {
		["Дартпредатор"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Алея"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Ваззули"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Сиаранна"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Джатон"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Фикстер"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Киландра"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Нарджо"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Верзук"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Крениг"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t"
	},
	["Вечная Песня"] = {
		["Киландра"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Леани"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Равенор"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Налкас"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
		["Ваззули"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t"
	},
	["Illidan"] = {
		["Darthpred"] = "|TInterface\\AddOns\\ElvUI\\media\\textures\\ElvUI_Chat_Logo:13:22|t",
	},
}

CH.AddMessageSLE = CH.AddMessage
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
end