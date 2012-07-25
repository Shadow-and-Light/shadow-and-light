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
	if E.db.sle.chat.fade then
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
			chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3)
			chat:Size(E.db.general.panelWidth - 6, (E.db.general.panelHeight - 27) - CombatLogQuickButtonFrame_Custom:GetHeight())				
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