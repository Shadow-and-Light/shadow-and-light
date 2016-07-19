local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local CH, LO = SLE:GetElvModules("Chat", "Layout")
local C = SLE:NewModule("Chat",  'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local LSM = LibStub("LibSharedMedia-3.0")
--GLOBALS:  UIParent, LeftChatPanel, LeftChatDataPanel, LeftChatToggleButton, LeftChatTab, RightChatPanel,
--GLOBALS:  RightChatDataPanel, RightChatToggleButton, RightChatTab, hooksecurefunc

local _G = _G
local _
local sub = string.sub
local leader = [[|TInterface\GroupFrame\UI-Group-LeaderIcon:12:12|t]]
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local IsMouseButtonDown = IsMouseButtonDown
local GetChatWindowSavedPosition = GetChatWindowSavedPosition
local specialChatIcons
C.GuildMaster = ""
C.GMName = ""
C.GMRealm = ""
C.PlayerRealm = T.gsub(E.myrealm,'[%s%-]','')
C.PlayerName = E.myname.."-"..C.PlayerRealm
C.CreatedFrames = 0;

local function Style(self, frame)
	C.CreatedFrames = frame:GetID()

	local name = frame:GetName()
	local tab = _G[name..'Tab']
	tab.isTemporary = frame.isTemporary
	tab:HookScript("OnClick", function()
		C:SetSelectedTab()
	end)
end

local function PositionChat(self, override)
	if C.CreatedFrames == 0 then return end
	if ((T.InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	if not self.db.lockPositions or E.private.chat.enable ~= true then return end
	if not E.db.sle.datatexts.chathandle then return end
	local chat, id, tab, isDocked, point
	for i=1, C.CreatedFrames do
		local BASE_OFFSET = 57 + E.Spacing*3
		chat = _G[T.format("ChatFrame%d", i)]
		id = chat:GetID()
		tab = _G[T.format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		if chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == CH.RightChatWindowID then
			BASE_OFFSET = BASE_OFFSET - (24 + E.Spacing*2)
			chat:ClearAllPoints()
			chat:SetPoint("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 4, 7)
			if id ~= 2 then
				chat:Size(
					(E.db.chat.separateSizes and E.db.chat.panelWidthRight or E.db.chat.panelWidth) - 10,
					((E.db.chat.separateSizes and E.db.chat.panelHeightRight or E.db.chat.panelHeight) - BASE_OFFSET)
				)
			end
		elseif not isDocked and chat:IsShown() then
		--Do Nothing
		else --Left Chat
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				BASE_OFFSET = BASE_OFFSET - (24 + E.Spacing*4)
				chat:SetPoint("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 4, 7)
				chat:Size(E.db.chat.panelWidth - 10, E.db.chat.panelHeight - BASE_OFFSET)
			end
		end
	end
end

local function GetChatIcon(sender)
	if not C.db then C.db = E.db.sle.chat end
	if not specialChatIcons then 
		SLE:GetRegion()
		specialChatIcons = SLE.SpecialChatIcons[SLE.region]
	end
	local senderName, senderRealm
	if sender then
		senderName, senderRealm = T.split('-', sender)
	else
		senderName = E.myname
	end
	senderRealm = senderRealm or C.PlayerRealm
	senderRealm = T.gsub(senderRealm, ' ', '')

	if specialChatIcons[senderRealm] and specialChatIcons[senderRealm][senderName] then
		return specialChatIcons[senderRealm][senderName]
	end

	if not T.IsInGuild() then return "" end
	if not C.db.guildmaster then return "" end
	if senderName == C.GMName and senderRealm == C.GMRealm then
		return leader 
	end
	return nil
end

function C:GMCheck()
	local name, rank
	if T.GetNumGuildMembers() == 0 and T.IsInGuild() then E:Delay(2, C.GMCheck); return end
	if not T.IsInGuild() then C.GuildMaster = ""; C.GMName = ''; C.GMRealm = ''; return end
	for i = 1, T.GetNumGuildMembers() do
		name, _, rank = T.GetGuildRosterInfo(i)
		if rank == 0 then break end
	end
	C.GuildMaster = name
	if C.GuildMaster then C.GMName, C.GMRealm = T.split('-', C.GuildMaster) end
	C.GMRealm = C.GMRealm or C.PlayerRealm
	C.GMRealm = T.gsub(C.GMRealm, ' ', '')
end

local function Roster(event, update)
 if update then C:GMCheck() end
end

function C:GMIconUpdate()
	if E.private.chat.enable ~= true then return end
	if C.db.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		C:GMCheck()
	else
		self:UnregisterEvent('GUILD_ROSTER_UPDATE')
		C.GuildMaster, C.GMName, C.GMRealm = "", "", ""
	end
end

function C:Combat(event)
	if C.db.combathide == "NONE" or not C.db.combathide then return end
	if event == "PLAYER_REGEN_DISABLED" then
		if C.db.combathide == "BOTH" or C.db.combathide == "RIGHT" then
			RightChatPanel:Hide()
			RightChatToggleButton:Hide()
		end
		if C.db.combathide == "BOTH" or C.db.combathide == "LEFT" then
			LeftChatPanel:Hide()
			LeftChatToggleButton:Hide()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
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

--Previously layout.lua
local PANEL_HEIGHT = 22;
local function ChatPanels()
	local HEIGHT = E.db.sle.datatexts.chathandle and (PANEL_HEIGHT - 2) or PANEL_HEIGHT
	LeftChatToggleButton:Size(16, HEIGHT)
	RightChatToggleButton:Size(16, HEIGHT)
	if not E.db.sle.datatexts.chathandle then return end

	if not E:HasMoverBeenMoved("LeftChatMover") and E.db.datatexts.leftChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		SLE:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 19 + E.Spacing*2)
		E:SetMoversPositions()
	end
	
	if not E:HasMoverBeenMoved("RightChatMover") and E.db.datatexts.rightChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		SLE:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 19 + E.Spacing*2)
		E:SetMoversPositions()
	end
	LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -(19 + E.Spacing*2))
	RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -(19 + E.Spacing*2))

	LeftChatDataPanel:ClearAllPoints()
	LeftChatDataPanel:Point("TOPLEFT", LeftChatToggleButton, "TOPRIGHT", -1 + E.Spacing*2, 0)
	LeftChatDataPanel:Point("BOTTOMLEFT", LeftChatToggleButton, "BOTTOMRIGHT", -1 + E.Spacing*2, 0)
	LeftChatDataPanel:Height(20)

	RightChatDataPanel:ClearAllPoints()
	RightChatDataPanel:Point("TOPRIGHT", RightChatToggleButton, "TOPLEFT", 1 - E.Spacing*2, 0)
	RightChatDataPanel:Point("BOTTOMRIGHT", RightChatToggleButton, "BOTTOMLEFT", 1 - E.Spacing*2, 0)
	RightChatDataPanel:Height(20)
end

local function CreateChatPanels()
	local SPACING = E.Border*3 - E.Spacing
	--Left Chat
	LeftChatTab:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', 2, -2)
	LeftChatTab:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', -2, -PANEL_HEIGHT)

	LeftChatToggleButton:ClearAllPoints()
	LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
	LeftChatToggleButton:Size(16, PANEL_HEIGHT)

	LeftChatDataPanel:ClearAllPoints()
	LeftChatDataPanel:Point("TOPLEFT", LeftChatToggleButton, "TOPRIGHT", -1 + E.Spacing*2, 0)
	LeftChatDataPanel:Point("BOTTOMLEFT", LeftChatToggleButton, "BOTTOMRIGHT", -1 + E.Spacing*2, 0)
	LeftChatDataPanel:Size(E.db.sle.datatexts.leftchat.width, PANEL_HEIGHT)
	--Right Chat
	RightChatTab:Point('TOPRIGHT', RightChatPanel, 'TOPRIGHT', -2, -2)
	RightChatTab:Point('BOTTOMLEFT', RightChatPanel, 'TOPLEFT', 2, -PANEL_HEIGHT)

	RightChatToggleButton:ClearAllPoints()
	RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SPACING, SPACING)
	RightChatToggleButton:Size(16, PANEL_HEIGHT)

	RightChatDataPanel:ClearAllPoints()
	RightChatDataPanel:Point("TOPRIGHT", RightChatToggleButton, "TOPLEFT", 1 - E.Spacing*2, 0)
	RightChatDataPanel:Point("BOTTOMRIGHT", RightChatToggleButton, "BOTTOMLEFT", 1 - E.Spacing*2, 0)
	RightChatDataPanel:Size(E.db.sle.datatexts.rightchat.width, PANEL_HEIGHT)
end

local function ChatTextures()
	if not E.db["general"] or not E.private["general"] then return end --Prevent rare nil value errors
	if not C.db or not C.db.textureAlpha or not C.db.textureAlpha.enable then return end --our option enable check

	if LeftChatPanel and LeftChatPanel.tex and RightChatPanel and RightChatPanel.tex then
		local a = C.db.textureAlpha.alpha or 0.5
		LeftChatPanel.tex:SetAlpha(a)
		RightChatPanel.tex:SetAlpha(a)
	end
end

function C:JustifyChat(i)
	local frame = _G["ChatFrame"..i]
	frame:SetJustifyH(C.db.justify["frame"..i] or "LEFT")
end

function C:IdentifyChatFrames()
	for i = 1, 18 do
		local frame = _G["ChatFrame"..i]
		if frame then
			frame:AddMessage(T.format(L["This is %sFrame %s|r"], E["media"].hexvaluecolor, i), 1.0, 1.0, 0)
		end
	end
end

function C:UpdateChatMax()
	if SLE._Compatibility["ElvUI_CustomTweaks"] then return end
	for _, frameName in T.pairs(_G["CHAT_FRAMES"]) do
		local frame = _G[frameName]
		frame:SetMaxLines(E.private.sle.chat.chatMax)
	end
	CH:DisplayChatHistory()
end
hooksecurefunc(CH, "Initialize", C.UpdateChatMax)

function C:Initialize()
	if not SLE.initialized then return end
	if not E.private.chat.enable then return end
	C.db = E.db.sle.chat

	function C:ForUpdateAll()
		C.db = E.db.sle.chat
		C:GMIconUpdate()
		for i = 1, NUM_CHAT_WINDOWS do
			C:JustifyChat(i)
		end
	end

	hooksecurefunc(LO, "ToggleChatPanels", ChatPanels)
	hooksecurefunc(CH, "PositionChat", PositionChat)
	hooksecurefunc(CH, "StyleChat", Style)
	hooksecurefunc(E, "UpdateMedia", ChatTextures)

	if C.db.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		C:GMCheck()
	end

	--Teh Damage meter spam handle
	C:InitDamageSpam()

	--Combat Hide
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "Combat")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "Combat")

	--Launching stuff so hooks can work
	LO:ToggleChatPanels()
	CH:SetupChat()
	--Justify
	for i = 1, NUM_CHAT_WINDOWS do
		C:JustifyChat(i)
	end

	C:InitHistory()

	C:InitTabs()
end
hooksecurefunc(LO, "CreateChatPanels", CreateChatPanels)
CH:AddPluginIcons(GetChatIcon)

SLE:RegisterModule(C:GetName())