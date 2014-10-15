local E, L, V, P, G = unpack(ElvUI);
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
local adapt = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\adapt:0:2|t"
local repooc = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:0:2|t"
local darth = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_LogoD:0:2|t"
local friend = "|TInterface\\Icons\\Spell_Holy_PrayerofSpirit:16:16|t"
local test = "|TInterface\\Icons\\Achievement_PVP_H_03:16:16|t"
local rpg = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_RPG:13:35|t"
local kitalie = "|TInterface\\Icons\\%s:12:12:0:0:64:64:4:60:4:60|t"
local leader = [[|TInterface\GroupFrame\UI-Group-LeaderIcon:12:12|t]]


local specialChatIcons = {
	["Spirestone"] = {
		["Sifupooc"] = repooc,
		["Dapooc"] = repooc,
		["Lapooc"] = repooc,
		["Warpooc"] = repooc,
		["Repooc"] = repooc,
		["Cursewordz"] = repooc,
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
	["Andorhal"] = {
		["Dapooc"] = repooc,
		["Rovert"] = repooc,
		["Sliceoflife"] = repooc
	},
}

SLE.SpecialChatIcons = specialChatIcons

local function Style(self, frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
local PixelOff = E.PixelMode and 31 or 27

local function Position()
	if not E.db.sle.datatext.chathandle then return end
	local BASE_OFFSET = 60
	if E.PixelMode then
		BASE_OFFSET = BASE_OFFSET - 3
	end	
	local chat, id, isDocked, point
	for i=1, CreatedFrames do
		chat = _G[format("ChatFrame%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked

		if point == "BOTTOMRIGHT" and chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == CH.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3)
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:SetPoint("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 4, 4)
			end
			if id ~= 2 then
				chat:SetSize(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - PixelOff))
			end
		elseif not isDocked and chat:IsShown() then
		
		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				if  not E.db.datatexts.leftChatPanel then
					BASE_OFFSET = BASE_OFFSET - 24
					chat:SetPoint("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 1, 4)
				end
				chat:Size(E.db.chat.panelWidth - 11, (E.db.chat.panelHeight - PixelOff))
			end
		end
	end
end

local function GetChatIcon(sender)
	local senderName, senderRealm
	if sender then
		senderName, senderRealm = string.split('-', sender)
	else
		senderName = Myname
	end
	senderRealm = senderRealm or PLAYER_REALM
	senderRealm = senderRealm:gsub(' ', '')
		
	--Disabling ALL special icons. IDK why Elv use that and why would we want to have that but whatever
	if specialChatIcons[PLAYER_REALM] and specialChatIcons[PLAYER_REALM][Myname] ~= true then
		if specialChatIcons[senderRealm] and specialChatIcons[senderRealm][senderName] then
			return specialChatIcons[senderRealm][senderName]
		end
	end
	
	if not IsInGuild() then return "" end
	if not E.db.sle.chat.guildmaster then return "" end
	if senderName == GMName and senderRealm == GMRealm then
		return leader 
	end
	
	return ""
end

function CH:GetPluginReplacementIcon(arg2, arg6, type)
	local icon = ""
	if arg6 and (strlen(arg6) > 0) then
		if ( arg6 == "GM" ) then
			--If it was a whisper, dispatch it to the GMChat addon.
			if ( type == "WHISPER" ) then
				return;
			end
			--Add Blizzard Icon, this was sent by a GM
			icon = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		elseif ( arg6 == "DEV" ) then
			--Add Blizzard Icon, this was sent by a Dev
			icon = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		elseif ( arg6 == "DND" or arg6 == "AFK") then
			icon = GetChatIcon(arg2).._G["CHAT_FLAG_"..arg6]
		else					
			icon = _G["CHAT_FLAG_"..arg6];
		end
	else
		icon = GetChatIcon(arg2)
		if(lfgRoles[arg2] and SLE:SimpleTable(lfgChannels, type)) then
			icon = lfgRoles[arg2]..icon
		end
	end
	if icon == "" then icon = nil end
	return icon, true
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
				name = (realm and realm ~= '') and name..'-'..realm or name ..'-'..PLAYER_REALM;
				lfgRoles[name] = rolePaths[role]
			end
		end
	end
end

local function GMCheck()
	local name, rank
	if GetNumGuildMembers() == 0 and IsInGuild() then E:Delay(2, GMCheck); return end
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

local function Roster(event, update)
 if update then GMCheck() end
end

function CH:GMIconUpdate()
	if E.private.chat.enable ~= true then return end
	if E.db.sle.chat.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		GMCheck()
	else
		self:UnregisterEvent('GUILD_ROSTER_UPDATE')
		GuildMaster = ""
		GMName = ''
		GMRealm = ''
	end
end

--Previously layout.lua
local LO = E:GetModule('Layout');
local PANEL_HEIGHT = 22;
local SIDE_BUTTON_WIDTH = 16;
local function ChatPanels()
	if not E.db.sle.datatext.chathandle then return end
	
	if not E:HasMoverBeenMoved("LeftChatMover") and E.db.datatexts.leftChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		if E.PixelMode then
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
		else
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
		end
		E:SetMoversPositions()
	end
	
	if not E:HasMoverBeenMoved("RightChatMover") and E.db.datatexts.rightChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		if E.PixelMode then
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
		else
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
		end
		E:SetMoversPositions()
	end

	if E.db.chat.panelBackdrop == 'SHOWBOTH' then
		LeftChatPanel.backdrop:Show()
		RightChatPanel.backdrop:Show()

		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels()
	elseif E.db.chat.panelBackdrop == 'HIDEBOTH' then
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Hide()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(true, true)
	elseif E.db.chat.panelBackdrop == 'LEFT' then
		LeftChatPanel.backdrop:Show()
		RightChatPanel.backdrop:Hide()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(true)
	else
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Show()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(nil, true)
	end
end

local function CreateChatPanels()
	--Left Chat Tab
	LeftChatTab:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', 2, -2)
	LeftChatTab:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', -2, -PANEL_HEIGHT)
	--Preventing left chat datapanel fading
	ChatFrame1EditBox:Hide()
	--Right Chat Tab
	RightChatTab:Point('TOPRIGHT', RightChatPanel, 'TOPRIGHT', -2, -2)
	RightChatTab:Point('BOTTOMLEFT', RightChatPanel, 'TOPLEFT', 2, -PANEL_HEIGHT)
end

hooksecurefunc(LO, "ToggleChatPanels", ChatPanels)
hooksecurefunc(LO, "CreateChatPanels", CreateChatPanels)
hooksecurefunc(CH, "StyleChat", Style)
hooksecurefunc(CH, "PositionChat", Position)
hooksecurefunc(CH, "Initialize", function(self)
	if E.db.sle.chat.guildmaster then
		self:RegisterEvent('GUILD_ROSTER_UPDATE', Roster)
		GMCheck()
	end
end)