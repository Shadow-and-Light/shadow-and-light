local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local LibQTip = LibStub('LibQTip-1.0')
local DT_myrealm = gsub(E.myrealm,"[%s%-]","")

-- GLOBALS: unpack, select
local _G = _G
local format = format
local UnitInRaid, UnitInParty = UnitInRaid, UnitInParty
local IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown = IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local StaticPopup_Show = StaticPopup_Show
--[[  Might use to mimic ElvUI rep bar in tooltip
local GetGuildFactionInfo = GetGuildFactionInfo
local COMBAT_FACTION_CHANGE = COMBAT_FACTION_CHANGE
local standingString = E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b).."%s:|r |cFFFFFFFF%s/%s (%s%%)"
--]]
--local RequestInviteFromUnit = RequestInviteFromUnit --Might use for feature later on to make shortcut to request an invite

local LoadAddOn = LoadAddOn
local GUILD = GUILD
local GUILD_MOTD = GUILD_MOTD
local REMOTE_CHAT = REMOTE_CHAT
local C_GuildInfo_GuildRoster = C_GuildInfo.GuildRoster
local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local displayString = ""
local displayTotalsString = ""
local noGuildString = ""
local guildInfoString = "%s"
local guildInfoString2 = GUILD..": %d/%d"
local nameString = "|cff%02x%02x%02x%s|r"
local onoteString = "|cff%02x%02x%02x[%s]|r"
local guildTable, guildMotD, lastPanel = {}, ""
local tooltip
local LDB_ANCHOR
local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local AWAY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-Away:18|t"
local BUSY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-DnD:18|t"
local MOBILE_ICON	= "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:18|t"
local MINIMIZE		= "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"
local OnEnter

--[[  Might look into adding these from ElvUI, unsure yet
local mobilestatus = {
	[0] = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:14:14:0:0:16:16:0:16:0:16:73:177:73|t",
	[1] = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t",
	[2] = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t",
}--]]

-- Setup the Title Font. 14
local ttTitleFont = CreateFont("ttTitleFont")
ttTitleFont:SetTextColor(1,0.823529,0)

-- Setup the Header Font. 12
local ttHeaderFont = CreateFont("ttHeaderFont")
ttHeaderFont:SetTextColor(0.4,0.78,1)

-- Setup the Regular Font. 12
local ttRegFont = CreateFont("ttRegFont")
ttRegFont:SetTextColor(1,0.823529,0)

local list_sort = {
	TOONNAME = function(a, b)
		if not a.name or not b.name then return false end
		return a.name < b.name
	end,
	LEVEL =	function(a, b)
		if not a.level or not b.level then
			return false
		elseif a.level < b.level then
			return true
		elseif a.level > b.level then
			return false
		else  -- TOONNAME
			return a.name < b.name
		end
	end,
	RANKINDEX =	function(a, b)
		if not a.rankIndex or not b.rankIndex then
			return false
		elseif a.rankIndex > b.rankIndex then
			return true
		elseif a.rankIndex < b.rankIndex then
			return false
		else -- TOONNAME
			return a.name < b.name
		end
	end,
	ZONENAME = function(a, b)
		if not a.zone or not b.zone then
			return false
		elseif a.zone < b.zone then
			return true
		elseif a.zone > b.zone then
			return false
		else -- TOONNAME
			return a.name < b.name
		end
	end,
	revTOONNAME	= function(a, b)
		if a.name or not b.name then return false end
		return a.name > b.name
	end,
	revLEVEL = function(a, b)
		if not a.level or not b.level then
			return false
		elseif a.level > b.level then
			return true
		elseif a.level < b.level then
			return false
		else  -- TOONNAME
			return a.name < b.name
		end
	end,
	revRANKINDEX = function(a, b)
		if not a.rankIndex or not b.rankIndex then
			return false
		elseif a.rankIndex < b.rankIndex then
			return true
		elseif a.rankIndex > b.rankIndex then
			return false
		else -- TOONNAME
			return a.name < b.name
		end
	end,
	revZONENAME	= function(a, b)
		if not a.zone or not b.zone then
			return false
		elseif a.zone > b.zone then
			return true
		elseif a.zone < b.zone then
			return false
		else -- TOONNAME
			return a.name < b.name
		end
	end
}

local function nameShorten(name)
	local shortName, realmName = strsplit("-", name)
	realmName = gsub(realmName,"[%s%-]","")

	return shortName, realmName
end

local function inGroup(name)
	local shortName, realmName = nameShorten(name)

	if DT_myrealm == realmName then name = shortName end
	if GetNumSubgroupMembers() > 0 and UnitInParty(name) then
		return true
	elseif GetNumGroupMembers() > 0 and UnitInRaid(name) then
		return true
	end

	return false
end

local function onServer(name)
	local shortName, realmName = nameShorten(name)
	if DT_myrealm == realmName then
		return shortName
	else
		return name
	end
end

local function nametoindex(name)
	local nameFromRoster

	for i = 1, GetNumGuildMembers() do
		nameFromRoster = GetGuildRosterInfo(i)

		if name == nameFromRoster then
			return i
		end
	end
end

local function ColoredLevel(level)
	if level ~= "" then
		local color = GetQuestDifficultyColor(level)
		return format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local function Entry_OnMouseUp(_, fullName, button)
	if button == "LeftButton" then
		if IsControlKeyDown() then
			InviteUnit(fullName) --Invite Player
			return
		end
		if IsShiftKeyDown() then
			SetItemRef("player:"..fullName, "|Hplayer:"..fullName.."|h["..fullName.."|h", "LeftButton") --Who Player
			return
		end

		SetItemRef( "player:"..fullName, format("|Hplayer:%1$s|h[%1$s]|h", fullName), "LeftButton" ) --Whisper Player
	elseif button == "RightButton" then
		if IsControlKeyDown() then
			if CanEditOfficerNote() then
				SetGuildRosterSelection(nametoindex(fullName))
				StaticPopup_Show("SET_GUILDOFFICERNOTE") --Set Officer Note
			end
			return
		end
		if IsShiftKeyDown() then

		end

		if (fullName == E.mynameRealm:gsub(' ','')) or CanEditPublicNote() then
			SetGuildRosterSelection(nametoindex(fullName))
			StaticPopup_Show("SET_GUILDPLAYERNOTE") --Set Public Guild Note
			return
		end
	end
end

local function HideOnMouseUp(cell, section)
	E.db.sle.dt.guild[section] = not E.db.sle.dt.guild[section]
	OnEnter(LDB_ANCHOR)
end

local function SetGuildSort(cell, sortsection)
	if E.db.sle.dt.guild["sortGuild"] == sortsection then
		E.db.sle.dt.guild["sortGuild"] = "rev" .. sortsection
	else
		E.db.sle.dt.guild["sortGuild"] = sortsection
	end
	OnEnter(LDB_ANCHOR)
end

local function BuildGuildTable()
	wipe(guildTable)
	local statusInfo
	local totalMembers = GetNumGuildMembers()
	for i = 1, totalMembers do
		local name, rank, rankIndex, level, _, zone, note, officerNote, connected, memberstatus, className, _, _, isMobile, _, _, guid = GetGuildRosterInfo(i)
		if not name then return end

		if memberstatus == 1 then
			statusInfo = AWAY_ICON
		elseif memberstatus == 2 then
			statusInfo = BUSY_ICON
		elseif memberstatus == 0 then
			statusInfo = ''
		end

		if isMobile then
			statusInfo = MOBILE_ICON
			--zone = REMOTE_CHAT
		end

		--local statusInfo = isMobile and mobilestatus[memberstatus] or onlinestatus[memberstatus]
		zone = (isMobile and not connected) and REMOTE_CHAT or zone

		if connected or isMobile then
			guildTable[#guildTable + 1] = {
				name = name,				--1
				rank = rank,				--2
				level = level,				--3
				zone = zone,				--4
				note = note,				--5
				officerNote = officerNote,	--6
				online = connected,			--7
				status = statusInfo,		--8
				class = className,			--9
				rankIndex = rankIndex,		--10
				isMobile = isMobile,		--11
				guid = guid					--12
			}
		end
	end
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local resendRequest = false
local eventHandlers = {
	["PLAYER_GUILD_UPDATE"] = C_GuildInfo_GuildRoster,
	["CHAT_MSG_SYSTEM"] = function(_, arg1)
		if FRIEND_ONLINE ~= nil and arg1 and strfind(arg1, FRIEND_ONLINE) then
			resendRequest = true
		end
	end,
	-- when we enter the world and guildframe is not available then
	-- load guild frame, update guild message and guild xp
	["PLAYER_ENTERING_WORLD"] = function()
		if not _G.GuildFrame and IsInGuild() then
			LoadAddOn("Blizzard_GuildUI")
			C_GuildInfo_GuildRoster()
		end
	end,
	-- Guild Roster updated, so rebuild the guild table
	["GUILD_ROSTER_UPDATE"] = function(self)
		if(resendRequest) then
			resendRequest = false
			return C_GuildInfo_GuildRoster()
		else
			BuildGuildTable()
			UpdateGuildMessage()
			if GetMouseFocus() == self then
				self:GetScript("OnEnter")(self, nil, true)
			end
		end
	end,
	-- our guild message of the day changed
	["GUILD_MOTD"] = function (self, arg1)
		guildMotD = arg1
	end,
}

local function OnEvent(self, event, ...)
	lastPanel = self

	if IsInGuild() then
		-- eventHandlers[event](self, ...)
		local func = eventHandlers[event]
		if func then func(self, ...) end

		local totalMembers = GetNumGuildMembers()
		local textStyle = E.db.sle.dt.guild.textStyle == "Default" and GUILD..": " or E.db.sle.dt.guild.textStyle == "NoText" and "" or E.db.sle.dt.guild.textStyle == "Icon" and "|TInterface\\ICONS\\Achievement_Reputation_01:12|t: " or ""
		if E.db.sle.dt.guild.totals then
			self.text:SetFormattedText(displayTotalsString, textStyle, #guildTable, totalMembers)
		else
			self.text:SetFormattedText(displayString, textStyle, #guildTable)
		end
	else
		self.text:SetText(noGuildString)
	end
end

local function OnClick(self, button)
	if button == "LeftButton" then
		ToggleGuildFrame(1)
	end

	if button == "RightButton" then
		E:ToggleOptionsUI()
		E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle", "modules", "datatext", "sldatatext", "slguild")
	end
end

function OnEnter(self, _, noUpdate)
	if not IsInGuild() then return end
	if E.db.sle.dt.guild.combat and InCombatLockdown() then return end
	local hexColor = E:RGBToHex(unpack(E.media.rgbvaluecolor))

	LDB_ANCHOR = self

	if LibQTip:IsAcquired("ShadowLightGuild") then
		tooltip:Clear()
	else
		tooltip = LibQTip:Acquire("ShadowLightGuild", 8, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")

		tooltip:SetBackdropColor(0,0,0,1)

		ttHeaderFont:SetFont(GameTooltipHeaderText:GetFont())
		ttRegFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetHeaderFont(ttHeaderFont)
		tooltip:SetFont(ttRegFont)

		tooltip:SmartAnchorTo(self)
		tooltip:SetAutoHideDelay(E.db.sle.dt.guild.tooltipAutohide, self)
		tooltip:SetScript("OnShow", function(ttskinself) ttskinself:SetTemplate('Transparent') end)
	end

	local line = tooltip:AddLine()
	if not E.db.sle.dt.guild.hide_titleline then
		ttTitleFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetCell(line, 1, "Shadow & Light Guild", ttTitleFont, "CENTER", 0)
		tooltip:AddLine()
	end

	local guildName, guildRank = GetGuildInfo('player')
	local total, _, online = GetNumGuildMembers()
	if #guildTable == 0 then BuildGuildTable() end
	sort(guildTable, list_sort[E.db.sle.dt.guild["sortGuild"]])

	if guildName and guildRank then
		--Displays guild name
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, format(guildInfoString, guildName), ttHeaderFont, "LEFT", 4)
		tooltip:SetCell(line, 5, format(guildInfoString2, online, total), ttHeaderFont, "RIGHT", 4)

		--Displays guild rank
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, guildRank)
		tooltip:AddLine(" ")
	end

	if not E.db.sle.dt.guild.hide_gmotd then
		line = tooltip:AddLine()
		if not E.db.sle.dt.guild.minimize_gmotd then
			tooltip:SetCell(line, 1, "|cffffffff" .. _G.CHAT_GUILD_MOTD_SEND .. "|r", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, "|cffffffff".. MINIMIZE .. _G.CHAT_GUILD_MOTD_SEND .. "|r", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "minimize_gmotd")

		if not E.db.sle.dt.guild.minimize_gmotd then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "|cff00ff00"..GetGuildRosterMOTD().."|r", "LEFT", 0, nil, nil, nil, 100)
		end

		tooltip:AddLine(" ")
	end

	--Don't plan on using the hold shift on mouseover but i can use the function to sort the guild by rank or name most likely
	--SortGuildTable(IsShiftKeyDown())
	--[[ Maybe play with this after the rewrite
	local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
	if standingID ~= 8 then -- Not Max Rep
		--barMax = barMax - barMin
		--barValue = barValue - barMin
		--DT.tooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, E:ShortValue(barValue), E:ShortValue(barMax), ceil((barValue / barMax) * 100)))
	end
	--]]

	line = tooltip:AddHeader()
	line = tooltip:SetCell(line, 1, "  ")
	tooltip:SetCellScript(line, 1, "OnMouseUp", SetGuildSort, "LEVEL")
	line = tooltip:SetCell(line, 3, _G.NAME)
	tooltip:SetCellScript(line, 3, "OnMouseUp", SetGuildSort, "TOONNAME")
	line = tooltip:SetCell(line, 5, _G.ZONE)
	tooltip:SetCellScript(line, 5, "OnMouseUp", SetGuildSort, "ZONENAME")
	line = tooltip:SetCell(line, 6, _G.RANK)
	tooltip:SetCellScript(line, 6, "OnMouseUp", SetGuildSort, "RANKINDEX")

	if not E.db.sle.dt.guild.hide_guild_onotes then
		line = tooltip:SetCell(line, 7, _G.NOTE_COLON)
	else
		line = tooltip:SetCell(line, 7, MINIMIZE .. _G.NOTE_COLON)
	end

	tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hide_guild_onotes")
	tooltip:AddSeparator()

	for _, info in ipairs(guildTable) do
		local classc = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[info.class]) or _G.RAID_CLASS_COLORS[info.class]
		local onoteColor = E.db.sle.dt.guild.onoteColor
		local noteColor = E.db.sle.dt.guild.noteColor

		line = tooltip:AddLine()
		line = tooltip:SetCell(line, 1, ColoredLevel(info.level))
		line = tooltip:SetCell(line, 2, info.status)
		line = tooltip:SetCell(line, 3, format(nameString, classc.r*255,classc.g*255,classc.b*255, onServer(info.name)) .. (inGroup(info.name) and GROUP_CHECKMARK or ""))
		line = tooltip:SetCell(line, 5, info.zone or "???")
		line = tooltip:SetCell(line, 6, info.rank)

		if not E.db.sle.dt.guild.hide_guild_onotes then
			line = tooltip:SetCell(line, 7, format(nameString, noteColor.r*255, noteColor.g*255, noteColor.b*255, info.note or ""))
			if (info.officerNote and info.officerNote ~= "") then
				-- line = tooltip:SetCell(line, 7, info.note)
				line = tooltip:SetCell(line, 8, format(onoteString, onoteColor.r*255, onoteColor.g*255, onoteColor.b*255, info.officerNote or ""))
				-- line = tooltip:SetCell(line, 8, "[" .. info.officerNote .. "]")
			end
		end

		tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, info.name)
	end
	tooltip:AddLine(" ")

	if not E.db.sle.dt.guild.hide_hintline then
		line = tooltip:AddLine()
		if not E.db.sle.dt.guild.minimize_hintline then
			tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, MINIMIZE .. "Hint:", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "minimize_hintline")

		if not E.db.sle.dt.guild.minimize_hintline then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sLeft Click|r a person's line to whisper them."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sShift+Left Click|r a person's line to perform a lookup."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sShift+Right Click|r a line to edit public note."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sCtrl+Left Click|r a person's line to invite them."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sCtrl+Right Click|r a line to edit officer note."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sLeft Click|r datatext panel to open guild list."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sRight Click|r datatext panel to customize."]:format(hexColor), "LEFT", 3)
		end
	end

	tooltip:UpdateScrolling()
	tooltip:Show()

	if not noUpdate then
		C_GuildInfo.GuildRoster()
	end
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s", hex, "%d|r")
	displayTotalsString = strjoin("", "%s", hex, "%d/%d|r")
	noGuildString = hex..L["No Guild"]

	if lastPanel ~= nil then
		OnEvent(lastPanel, 'ELVUI_COLOR_UPDATE')
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('S&L Guild', 'S&L', {'CHAT_MSG_SYSTEM', "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_MOTD"}, OnEvent, nil, OnClick, OnEnter)
