local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local CH, LO = E.Chat, E.Layout
local C = SLE.Chat

--GLOBALS:unpack, select, hooksecurefunc, strsplit, gsub, format, string, _G, NUM_CHAT_WINDOWS, LeftChatPanel, RightChatPanel, LeftChatToggleButton, RightChatToggleButton, IsMouseButtonDown, IsInGuild, GetNumGuildMembers, GetGuildRosterInfo, GetChatWindowSavedPosition

local _G = _G
local format = format
local IsMouseButtonDown = IsMouseButtonDown

local sub = string.sub
local leader = [[|TInterface\GroupFrame\UI-Group-LeaderIcon:12:12|t]]
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local IsMouseButtonDown = IsMouseButtonDown
local GetChatWindowSavedPosition = GetChatWindowSavedPosition
local specialChatIcons
C.GuildMaster = ''
C.GMName = ''
C.GMRealm = ''
C.PlayerRealm = gsub(E.myrealm,'[%s%-]','')
C.PlayerName = E.myname..'-'..C.PlayerRealm
C.CreatedFrames = 0

local function Style(self, frame)
	C.CreatedFrames = frame:GetID()
	-- print("style")
	local name = frame:GetName()
	local tab = _G[name..'Tab']
	tab.isTemporary = frame.isTemporary

	-- Prevent text from jumping from left to right when tab is clicked.
	hooksecurefunc(tab, 'SetWidth', function(self)
		self.Text:ClearAllPoints()
		self.Text:SetPoint('CENTER', self, 'CENTER', 0, 0)
	end)
end

local function GetChatIcon(sender)
	if not specialChatIcons then
		SLE:GetRegion()
		specialChatIcons = SLE.SpecialChatIcons[SLE.region]
	end
	local senderName, senderRealm, icon
	if not sender then icon = "" end
	if specialChatIcons and specialChatIcons[sender] then
		icon = specialChatIcons[sender]
	end

	if IsInGuild() and E.db.sle.chat.guildmaster then
		if sender == C.GuildMaster then icon = icon and (leader..icon) or leader end
	end

	return icon
end

function C:GMCheck()
	if GetNumGuildMembers() == 0 and IsInGuild() then E:Delay(2, C.GMCheck) return end
	if not IsInGuild() then C.GuildMaster = ""; C.GMName = ''; C.GMRealm = ''; return end
	for i = 1, GetNumGuildMembers() do
		local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
		if rankIndex == 0 then C.GuildMaster = guid break end
	end
end

local function Roster(event, update)
 if update then C:GMCheck() end
end

function C:GMIconUpdate()
	if E.private.chat.enable ~= true then return end
	if E.db.sle.chat.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		C:GMCheck()
	else
		self:UnregisterEvent('GUILD_ROSTER_UPDATE')
		C.GuildMaster, C.GMName, C.GMRealm = '', '', ''
	end
end

function C:Combat(event)
	--To get rid of "script ran too long" in links
	if E.db.sle.chat.combathide == 'NONE' or not E.db.sle.chat.combathide then return end
	if event == 'PLAYER_REGEN_DISABLED' then
		if E.db.sle.chat.combathide == 'BOTH' or E.db.sle.chat.combathide == 'RIGHT' then
			RightChatPanel:Hide()
			RightChatToggleButton:Hide()
		end
		if E.db.sle.chat.combathide == 'BOTH' or E.db.sle.chat.combathide == 'LEFT' then
			LeftChatPanel:Hide()
			LeftChatToggleButton:Hide()
		end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		if not RightChatPanel:IsShown() then
			RightChatPanel:Show()
			RightChatToggleButton:Show()
		end
		if not LeftChatPanel:IsShown() then
			LeftChatPanel:Show()
			LeftChatToggleButton:Show()
		end
	end
end

function C:PetBattle(event)
	if event == 'PET_BATTLE_OPENING_START' then
		if E.db.sle.chat.petbattlehide == 'BOTH' or E.db.sle.chat.petbattlehide == 'RIGHT' then
			RightChatPanel:Hide()
			RightChatToggleButton:Hide()
		end
		if E.db.sle.chat.petbattlehide == 'BOTH' or E.db.sle.chat.petbattlehide == 'LEFT' then
			LeftChatPanel:Hide()
			LeftChatToggleButton:Hide()
		end
	elseif event == 'PET_BATTLE_CLOSE' then
		if not RightChatPanel:IsShown() then
			RightChatPanel:Show()
			RightChatToggleButton:Show()
		end
		if not LeftChatPanel:IsShown() then
			LeftChatPanel:Show()
			LeftChatToggleButton:Show()
		end
	end
end

local function ChatTextures()
	if not E.db['general'] or not E.private['general'] then return end --Prevent rare nil value errors
	if not E.db.sle.chat or not E.db.sle.chat.textureAlpha or not E.db.sle.chat.textureAlpha.enable then return end --our option enable check

	if LeftChatPanel and LeftChatPanel.tex and RightChatPanel and RightChatPanel.tex then
		local a = E.db.sle.chat.textureAlpha.alpha or 0.5
		LeftChatPanel.tex:SetAlpha(a)
		RightChatPanel.tex:SetAlpha(a)
	end
end

function C:JustifyChat(i)
	local frame = _G['ChatFrame'..i]
	frame:SetJustifyH(E.db.sle.chat.justify['frame'..i] or 'LEFT')
end

function C:IdentifyChatFrames()
	for i = 1, 18 do
		local frame = _G['ChatFrame'..i]
		if frame then
			frame:AddMessage(format(L["This is %sFrame %s|r"], E['media'].hexvaluecolor, i), 1.0, 1.0, 0)
		end
	end
end

function C:Initialize()
	if not SLE.initialized or not E.private.chat.enable then return end

	function C:ForUpdateAll()
		C:GMIconUpdate()
		C:CreateInvKeys()
		C:SpamFilter()
		for i = 1, NUM_CHAT_WINDOWS do
			C:JustifyChat(i)
		end
	end

	SLE:GetRegion()
	specialChatIcons = SLE.SpecialChatIcons[SLE.region]
	-- hooksecurefunc(CH, "StyleChat", Style)
	hooksecurefunc(E, 'UpdateMedia', ChatTextures)

	if E.db.sle.chat.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		C:GMCheck()
	end

	-- The Damage meter spam handle
	C:InitLinks()

	--Combat Hide
	C:RegisterEvent('PLAYER_REGEN_ENABLED', 'Combat')
	C:RegisterEvent('PLAYER_REGEN_DISABLED', 'Combat')

	-- PetBattle Hide
	C:RegisterEvent('PET_BATTLE_OPENING_START', 'PetBattle')
	C:RegisterEvent('PET_BATTLE_CLOSE', 'PetBattle')

	--Launching stuff so hooks can work
	-- LO:ToggleChatPanels()
	local setupDelay = E.global.sle.advanced.chat.setupDelay
	E:Delay(setupDelay, function() CH:SetupChat() end) --This seems to actually fix some issues with detecting right panel chat frame
	-- Justify
	for i = 1, NUM_CHAT_WINDOWS do
		C:JustifyChat(i)
	end

	C:InitTabs()
end

CH:AddPluginIcons(GetChatIcon)

SLE:RegisterModule(C:GetName())
