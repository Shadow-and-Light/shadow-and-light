local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local LibQTip = LibStub('LibQTip-1.0')
local DT = E.DataTexts
local DTP = SLE.Datatexts

local _G = _G
local type, ipairs, pairs = type, ipairs, pairs
local sort, next, wipe, tremove, tinsert = sort, next, wipe, tremove, tinsert
local format, gsub, strfind, strmatch = format, gsub, strfind, strmatch

local BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
local BNGetNumFriends = BNGetNumFriends
local BNInviteFriend = BNInviteFriend
local BNRequestInviteFriend = BNRequestInviteFriend
local GetDisplayedInviteType = GetDisplayedInviteType
local GetQuestDifficultyColor = GetQuestDifficultyColor
local IsShiftKeyDown, IsAltKeyDown, IsControlKeyDown = IsShiftKeyDown, IsAltKeyDown, IsControlKeyDown
local SetItemRef = SetItemRef
local ToggleFriendsFrame = ToggleFriendsFrame
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_FriendList_GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local ChatFrame_SendBNetTell = ChatFrame_SendBNetTell
local InCombatLockdown = InCombatLockdown
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_PartyInfo_RequestInviteFromUnit = C_PartyInfo.RequestInviteFromUnit
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

local characterFriend = _G.CHARACTER_FRIEND
local battleNetString = _G.BATTLENET_OPTIONS_LABEL
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local friendTable, BNTable, tableList = {}, {}, {}
local friendOnline, friendOffline = gsub(_G.ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(_G.ERR_FRIEND_OFFLINE_S,"%%s","")
local wowString = BNET_CLIENT_WOW
local classicID = WOW_PROJECT_CLASSIC
local dataValid = false
local minbutton = "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"
local BROADCAST_ICON = "|TInterface\\FriendsFrame\\BroadcastIcon:0|t"
local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local onlineicon = "|TInterface\\ICONS\\Achievement_Reputation_01:12|t"
local BNET_BROADCAST_SENT_TIME = BNET_BROADCAST_SENT_TIME
local StaticPopup_Show = StaticPopup_Show
local displayhex = ''
local tooltip
local OnEnter
local broadcast_flag
local line

-- TODO: Maybe customize statusTable later
local statusTable = {
	AFK = " |cffFFFFFF[|r|cffFF9900"..L["AFK"].."|r|cffFFFFFF]|r",
	DND = " |cffFFFFFF[|r|cffFF3333"..L["DND"].."|r|cffFFFFFF]|r"
}

local function sletime_Conversion(timeDifference, isAbsolute)
	if ( not isAbsolute ) then
		timeDifference = time() - timeDifference
	end
	local ONE_MINUTE = 60
	local ONE_HOUR = 60 * ONE_MINUTE
	local ONE_DAY = 24 * ONE_HOUR
	local ONE_MONTH = 30 * ONE_DAY
	local ONE_YEAR = 12 * ONE_MONTH

	if ( timeDifference < ONE_MINUTE ) then
		return LASTONLINE_SECS
	elseif ( timeDifference >= ONE_MINUTE and timeDifference < ONE_HOUR ) then
		return format(LASTONLINE_MINUTES, floor(timeDifference / ONE_MINUTE))
	elseif ( timeDifference >= ONE_HOUR and timeDifference < ONE_DAY ) then
		return format(LASTONLINE_HOURS, floor(timeDifference / ONE_HOUR))
	elseif ( timeDifference >= ONE_DAY and timeDifference < ONE_MONTH ) then
		return format(LASTONLINE_DAYS, floor(timeDifference / ONE_DAY))
	elseif ( timeDifference >= ONE_MONTH and timeDifference < ONE_YEAR ) then
		return format(LASTONLINE_MONTHS, floor(timeDifference / ONE_MONTH))
	else
		return format(LASTONLINE_YEARS, floor(timeDifference / ONE_YEAR))
	end
 end

local clientSorted = {}
local clientsToShow = {
	{ client = "BNET_CLIENT_WOW", name = "WoW", index = 1 },
	{ client = "BNET_CLIENT_HEROES", name = "HotS", index = 10 },
	{ client = "BNET_CLIENT_ARCADE", name = "Arcade", index = 7 },
	{ client = "BNET_CLIENT_D1", name = "D1", index = 4 },
	{ client = "BNET_CLIENT_D2", name = "D2", index = 3 },
	{ client = "BNET_CLIENT_D3", name = "D3", index = 2 },
	{ client = "BNET_CLIENT_WTCG", name = "HS", index = 6 },
	{ client = "BNET_CLIENT_OVERWATCH", name = "WoW", index = 5 },
	{ client = "BNET_CLIENT_WC3", name = "WC3", index = 8 },
	{ client = "BNET_CLIENT_SC", name = "SC", index = 21 },
	{ client = "BNET_CLIENT_SC2", name = "SC2", index = 20 },
	{ client = "BNET_CLIENT_COD", name = "WoW", index = 30 },
	{ client = "BNET_CLIENT_COD_MW", name = "MW", index = 31 },
	{ client = "BNET_CLIENT_COD_MW2", name = "MW2", index = 32 },
	{ client = "BNET_CLIENT_COD_VANGUARD", name = "Vanguard", index = 33 },
}

local clientTags = {
	BSAp = L["Mobile"],
}

local clientIndex = {
	App = 11,
	BSAp = 12,
}

for _, data in pairs(clientsToShow) do
	if _G[data.client] then
		clientTags[data.client] = data.name
		clientIndex[data.client] = data.index
	end
end

local function inGroup(name, realmName)
	if realmName and realmName ~= "" and realmName ~= E.myrealm then
		name = name.."-"..realmName
	end

	return (UnitInParty(name) or UnitInRaid(name)) and GROUP_CHECKMARK or ""
end

local function SortAlphabeticName(a, b)
	if a.characterName and b.characterName then
		return a.characterName < b.characterName
	end
end

--Sort: client-> (WoW: project-> faction-> name) ELSE:btag
local function Sort(a, b)
	if a.client and b.client then
		if (a.client == b.client) then
			if (a.client == wowString) and a.wowProjectID and b.wowProjectID then
				if (a.wowProjectID == b.wowProjectID) and a.faction and b.faction then
					if (a.faction == b.faction) and a.characterName and b.characterName then
						return a.characterName < b.characterName
					end
					return a.faction < b.faction
				end
				return a.wowProjectID < b.wowProjectID
			elseif (a.battleTag and b.battleTag) then
				return a.battleTag < b.battleTag
			end
		end
		return a.client < b.client
	end
end

--Sort client by statically given index (this is a `pairs by keys` sorting method)
local function clientSort(a, b)
	if a and b then
		if clientIndex[a] and clientIndex[b] then
			return clientIndex[a] < clientIndex[b]
		end
		return a < b
	end
end

local function BuildFriendTable(total)
	wipe(friendTable)
	for i = 1, total do
		local info = C_FriendList_GetFriendInfoByIndex(i)
		if info and info.connected then
			local className = E:UnlocalizedClassName(info.className) or ""
			local status = (info.afk and statusTable.AFK) or (info.dnd and statusTable.DND) or ""

			friendTable[i] = {
				characterName = info.name,			--1
				level = info.level,			--2
				class = className,			--3
				zone = info.area,			--4
				online = info.connected,	--5
				status = status,			--6
				notes = info.notes,			--7
				guid = info.guid			--8
			}
		end
	end
	if next(friendTable) then
		sort(friendTable, SortAlphabeticName)
	end
end

local function AddToBNTable(bnIndex, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isBnetAFK, isBnetDND, noteText, wowProjectID, realmName, faction, race, className, zoneName, level, guid, gameText, customMessage, customMessageTime)
	className = E:UnlocalizedClassName(className) or ""
	characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or ""

	if wowProjectID == classicID then
		gameText, realmName = strmatch(gameText, '(.-)%s%-%s(.+)')
	end

	if customMessageTime then
		customMessageTime = format(BNET_BROADCAST_SENT_TIME, sletime_Conversion(customMessageTime))
	end

	BNTable[bnIndex] = {
		accountID = bnetIDAccount,		--1
		accountName = accountName,		--2
		battleTag = battleTag,			--3
		characterName = characterName,	--4
		gameID = bnetIDGameAccount,		--5
		client = client,				--6
		isOnline = isOnline,			--7
		isBnetAFK = isBnetAFK,			--8
		isBnetDND = isBnetDND,			--9
		noteText = noteText,			--10
		wowProjectID = wowProjectID,	--11
		realmName = realmName,			--12
		faction = faction,				--13
		race = race,					--14
		className = className,			--15
		zoneName = zoneName,			--16
		level = level,					--17
		guid = guid,					--18
		gameText = gameText,			--19
		customMessage = customMessage or "",
		customMessageTime =customMessageTime or ""
	}

	if tableList[client] then
		tableList[client][#tableList[client]+1] = BNTable[bnIndex]
	else
		tableList[client] = {}
		tableList[client][1] = BNTable[bnIndex]
	end
end

local function PopulateBNTable(bnIndex, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isBnetAFK, isBnetDND, noteText, wowProjectID, realmName, faction, race, class, zoneName, level, guid, gameText, hasFocus, customMessage, customMessageTime)
	-- `hasFocus` is not added to BNTable[i]; we only need this to keep our friends datatext in sync with the friends list
	for i = 1, bnIndex do
		local isAdded, bnInfo = 0, BNTable[i]
		if bnInfo and (bnInfo.accountID == bnetIDAccount) then
			if bnInfo.client == "BSAp" then
				if client == "BSAp" then -- unlikely to happen
					isAdded = 1
				elseif client == "App" then
					isAdded = (hasFocus and 2) or 1
				else -- Mobile -> Game
					isAdded = 2 --swap data
				end
			elseif bnInfo.client == "App" then
				if client == "App" then -- unlikely to happen
					isAdded = 1
				elseif client == "BSAp" then
					isAdded = (hasFocus and 2) or 1
				else -- App -> Game
					isAdded = 2 --swap data
				end
			elseif bnInfo.client then -- Game
				if client == "BSAp" or client == "App" then -- ignore Mobile and App
					isAdded = 1
				end
			end
		end
		if isAdded == 2 then -- swap data
			if bnInfo.client and tableList[bnInfo.client] then
				for n, y in ipairs(tableList[bnInfo.client]) do
					if y == bnInfo then
						tremove(tableList[bnInfo.client], n)
						break -- remove the old one from tableList
					end
				end
			end
			AddToBNTable(i, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isBnetAFK, isBnetDND, noteText, wowProjectID, realmName, faction, race, class, zoneName, level, guid, gameText, customMessage, customMessageTime)
		end
		if isAdded ~= 0 then
			return bnIndex
		end
	end

	bnIndex = bnIndex + 1 --bump the index one for a new addition
	AddToBNTable(bnIndex, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isBnetAFK, isBnetDND, noteText, wowProjectID, realmName, faction, race, class, zoneName, level, guid, gameText, customMessage, customMessageTime)

	return bnIndex
end

local function BuildBNTable(total)
	for _, v in pairs(tableList) do wipe(v) end
	wipe(BNTable)
	wipe(clientSorted)

	local bnIndex = 0

	for i = 1, total do
		local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
		-- local presenceID, givenName, bTag, _, _, toonID, gameClient, isOnline, lastOnline, isAFK, isDND, broadcast, note, _, castTime = BNGetFriendInfo(i)
		if accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isOnline then
			local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
			if numGameAccounts and numGameAccounts > 0 then
				for y = 1, numGameAccounts do
					local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(i, y)
					bnIndex = PopulateBNTable(bnIndex, accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, gameAccountInfo.characterName, gameAccountInfo.gameAccountID, gameAccountInfo.clientProgram, gameAccountInfo.isOnline, accountInfo.isAFK or gameAccountInfo.isGameAFK, accountInfo.isDND or gameAccountInfo.isGameBusy, accountInfo.note, accountInfo.gameAccountInfo.wowProjectID, gameAccountInfo.realmName, gameAccountInfo.factionName, gameAccountInfo.raceName, gameAccountInfo.className, gameAccountInfo.areaName, gameAccountInfo.characterLevel, gameAccountInfo.playerGuid, gameAccountInfo.richPresence, gameAccountInfo.hasFocus, accountInfo.customMessage, accountInfo.customMessageTime)
				end
			else
				bnIndex = PopulateBNTable(bnIndex, accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.gameAccountID, accountInfo.gameAccountInfo.clientProgram, accountInfo.gameAccountInfo.isOnline, accountInfo.isAFK, accountInfo.isDND, accountInfo.note, accountInfo.gameAccountInfo.wowProjectID, accountInfo.customMessage, accountInfo.customMessageTime)
			end
		end
	end

	if next(BNTable) then
		sort(BNTable, Sort)
	end
	for c, v in pairs(tableList) do
		if next(v) then
			sort(v, Sort)
		end
		tinsert(clientSorted, c)
	end
	if next(clientSorted) then
		sort(clientSorted, clientSort)
	end
end

local function Entry_OnMouseUp(self, info, button)
	local i_type, name, realmName, accountName, accountID = strsplit(":", info)
	if not (name and name ~= "") then return end

	if button == "LeftButton" then
		if IsControlKeyDown() then
			if i_type == "realid" then

				if E.myrealm == realmName then
					C_PartyInfo.InviteUnit(name)
				else
					C_PartyInfo.InviteUnit(name.."-"..realmName)
				end
				return
			else
				C_PartyInfo.InviteUnit(name)
				return
			end
		end

		if IsShiftKeyDown() then
			SetItemRef("player:"..name, "|Hplayer:"..name.."|h["..name.."|h", "LeftButton")
			return
		end

		if i_type == "realid" then
			ChatFrame_SendBNetTell(accountName)
		else
			SetItemRef( "player:"..name, format("|Hplayer:%1$s|h[%1$s]|h",name), "LeftButton" )
		end
	end

	if button == "RightButton" then
		if IsShiftKeyDown() then
			if i_type == "friends" then
				_G["FriendsFrame"].NotesID = name
				StaticPopup_Show("SET_FRIENDNOTE", _G["FriendsFrame"].NotesID)
				return
			end
			if i_type == "realid" then
				_G["FriendsFrame"].NotesID = accountID
				StaticPopup_Show("SET_BNFRIENDNOTE", accountName)
				return
			end
		end

		ElvDB.SLEMinimize["expandBNBroadcast"..accountName] = not ElvDB.SLEMinimize["expandBNBroadcast"..accountName]
		OnEnter(self)
	end
end

local function OnEvent(self, event, message)
	local db = E.db.sle.dt.friends
	local onlineFriends = C_FriendList_GetNumOnlineFriends()
	local friendsTotal = C_FriendList_GetNumFriends()
	local numBNetTotal, numBNetOnline = BNGetNumFriends()

	local totalOnline = onlineFriends + numBNetOnline
	local totalFriends = friendsTotal + numBNetTotal

	-- special handler to detect friend coming online or going offline
	-- when this is the case, we invalidate our buffered table and update the
	-- datatext information
	if event == 'CHAT_MSG_SYSTEM' then
		if not (strfind(message, friendOnline) or strfind(message, friendOffline)) then return end
	end

	if event == 'MODIFIER_STATE_CHANGED' then
		if not IsAltKeyDown() and GetMouseFoci()[1] == self then
			OnEnter(self)
		elseif IsAltKeyDown and GetMouseFoci()[1] == self then
			tooltip:Hide()
		end
	end

	-- force update when showing tooltip
	dataValid = false

	if db.panelStyle == 'DEFAULT' or db.panelStyle == 'ICON' then
		self.text:SetFormattedText(DTP.PanelStyles[db.panelStyle], db.panelStyle == 'DEFAULT' and FRIENDS or onlineicon, displayhex, totalOnline)
	elseif db.panelStyle == 'DEFAULTTOTALS' or db.panelStyle == 'ICONTOTALS' then
		self.text:SetFormattedText(DTP.PanelStyles[db.panelStyle], db.panelStyle == 'DEFAULTTOTALS' and FRIENDS or onlineicon, displayhex, totalOnline, totalFriends)
	elseif db.panelStyle == 'NOTEXT' then
		self.text:SetFormattedText(DTP.PanelStyles[db.panelStyle], displayhex, totalOnline)
	else
		self.text:SetFormattedText(DTP.PanelStyles[db.panelStyle], displayhex, totalOnline, totalFriends)
	end
end

local function HideOnMouseUp(self, info, button)
	local action, section = strsplit(":", info)

	if action == "hide" then
		E.db.sle.dt.friends[section] = not E.db.sle.dt.friends[section]
	end

	if action == "client" then
		if button == "LeftButton" then
			ElvDB.SLEMinimize[section] = not ElvDB.SLEMinimize[section]
		end
		if button == "RightButton" then
			E:StaticPopup_Show("SET_BN_BROADCAST")
		end
	end

	OnEnter(self)
end

local function OnClick(_, btn)
	if btn == "LeftButton" then
		ToggleFriendsFrame()
	end

	if btn == "RightButton" then
		E:ToggleOptions()
		E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle", "modules", "datatext", "sldatatext", "slfriends")
	end
end

local lastTooltipXLineHeader
local function TooltipAddXLine(tooltip, header, client, wowver, level, status, classc, characterName, accountName, customMessage, customMessageTime, zoneName, fcolor, realmName, guid, noteText, accountID, gameText)
	local minimizeclient = (wowver and wowver) or client
	if lastTooltipXLineHeader ~= header then
		line = tooltip:AddLine(" ")
		line = tooltip:AddLine(" ")

		if not ElvDB.SLEMinimize[minimizeclient] then
			tooltip:SetCell(line, 1, header, "CENTER", 0)
		else
			tooltip:SetCell(line, 1, minbutton .. header, "CENTER", 0)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "client:"..minimizeclient)

		if not ElvDB.SLEMinimize[minimizeclient] then
			line = tooltip:AddHeader()

			line = tooltip:SetCell(line, 3, _G.NAME)  --!  Name
			line = tooltip:SetCell(line, 4, _G.BATTLENET_FRIEND)  --!  RealID
			if client and client == "App" or client == "BSAp" then
				if not E.db.sle.dt.friends.hideFriendsNotes then
					line = tooltip:SetCell(line, 6, L["Note"], "LEFT")  --! Note
				else
					line = tooltip:SetCell(line, 6, minbutton .. L["Note"], "LEFT")  --! +Note
				end
				tooltip:SetCellScript(line, 6, "OnMouseUp", HideOnMouseUp, "hide:hideFriendsNotes")
			elseif client == "WoW" then
				line = tooltip:SetCell(line, 5, _G.ZONE)  --!  Location or (Zone)
				line = tooltip:SetCell(line, 6, _G.FRIENDS_LIST_REALM)  --!  Realm
				if not E.db.sle.dt.friends.hideFriendsNotes then
					line = tooltip:SetCell(line, 7, L["Note"], "LEFT")  --! Note
				else
					line = tooltip:SetCell(line, 7, minbutton .. L["Note"], "LEFT")  --! +Note
				end
				tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hide:hideFriendsNotes")
			else
				line = tooltip:SetCell(line, 5, L["Location"])  --!  (Location) or Zone

				if not E.db.sle.dt.friends.hideFriendsNotes then
					line = tooltip:SetCell(line, 7, L["Note"], "LEFT")  --! Note
				else
					line = tooltip:SetCell(line, 7, minbutton .. L["Note"], "LEFT")  --! +Note
				end
				tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hide:hideFriendsNotes")
			end

			tooltip:AddSeparator()
		end

		lastTooltipXLineHeader = header
	end

	if not ElvDB.SLEMinimize[minimizeclient] then
		line = tooltip:AddLine()
		if not ElvDB.SLEMinimize["expandBNBroadcast"..accountName] and customMessage ~= "" then
			broadcast_flag = " " .. BROADCAST_ICON
		else
			broadcast_flag = ""
		end

		line = tooltip:SetCell(line, 2, status)
		line = tooltip:SetCell(line, 4, "|cff82c5ff" .. accountName .. "|r" .. broadcast_flag)
		if client and client == "App" or client == "BSAp" then
			line = tooltip:SetCell(line, 3, characterName)

			if not E.db.sle.dt.friends.hideFriendsNotes then
				line = tooltip:SetCell(line, 6, noteText, "LEFT")
			end
		elseif client == "WoW" then
			line = tooltip:SetCell(line, 1, level)
			line = tooltip:SetCell(line, 3, format("|cff%02x%02x%02x%s|r", classc.r * 255, classc.g * 255, classc.b * 255, characterName) .. (inGroup(characterName, realmName)))
			line = tooltip:SetCell(line, 5, zoneName or gameText)
			line = tooltip:SetCell(line, 6, format("|cff%s%s|r", fcolor or "ffffff", realmName or ""))
			if not E.db.sle.dt.friends.hideFriendsNotes then
				line = tooltip:SetCell(line, 7, noteText, "LEFT")
			end
		else
			line = tooltip:SetCell(line, 3, characterName)
			line = tooltip:SetCell(line, 5, zoneName or gameText)
			line = tooltip:SetCell(line, 6, format("|cff%s%s|r", fcolor or "ffffff", realmName or ""))

			if not E.db.sle.dt.friends.hideFriendsNotes then
				line = tooltip:SetCell(line, 7, noteText, "LEFT")
			end
		end


		tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("realid:%s:%s:%s:%s", characterName, realmName or "", accountName, accountID))
		if ElvDB.SLEMinimize["expandBNBroadcast"..accountName] and customMessage ~= "" then
			line = tooltip:AddLine()
			line = tooltip:SetCell(line, 1, BROADCAST_ICON .. " |cff7b8489" .. customMessage .. "|r "..customMessageTime, "LEFT", 0)
			tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("realid:%s:%s:%s:%s", characterName, realmName or "", accountName, accountID))
		end
	end
end

function OnEnter(self)
	DT.tooltip:ClearLines()

	lastTooltipXLineHeader = nil

	local onlineFriends = C_FriendList_GetNumOnlineFriends()
	local numberOfFriends = C_FriendList_GetNumFriends()
	local totalBNet, numBNetOnline = BNGetNumFriends()
	local totalonline = onlineFriends + numBNetOnline
	local zonec, classc, levelc
	local valuec = E.db.general.valuecolor
	local hexColor = E:RGBToHex(valuec.r, valuec.g, valuec.b)

	-- Exit if no one online
	if totalonline == 0 then return end

	if not dataValid then
		-- only retrieve information for all on-line members when we actually view the tooltip
		if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
		if totalBNet > 0 then BuildBNTable(totalBNet) end
		dataValid = true
	end

	if E.db.sle.dt.friends.combat and InCombatLockdown() then return end

	if LibQTip:IsAcquired("ShadowLightFriendss") then
		tooltip:Clear()
	else
		tooltip = LibQTip:Acquire("ShadowLightFriendss", 8, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")

		local ssHeaderFont = CreateFont("ssHeaderFont")
		ssHeaderFont:SetTextColor(1,0.823529,0)
		ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont())
		tooltip:SetHeaderFont(ssHeaderFont)

		local ssRegFont = CreateFont("ssRegFont")
		ssRegFont:SetTextColor(1,0.823529,0)
		ssRegFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetFont(ssRegFont)

		tooltip:SmartAnchorTo(self)
		tooltip:SetAutoHideDelay(E.db.sle.dt.friends.tooltipAutohide, self)
	end

	line = tooltip:AddLine()
	if not E.db.sle.dt.friends.hide_titleline then
		local ssTitleFont = CreateFont("ssTitleFont")
		ssTitleFont:SetTextColor(1,0.823529,0)
		ssTitleFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetCell(line, 1, "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner:50:200|t", ssTitleFont, "CENTER", 0)
		-- tooltip:SetCell(line, 1, E:TextGradient("Shadow & Light", 1.0,0.6,0.4, 1.0,0.4,0.6, 0.6,0.4,1.0, 0.4,0.6,1.0, 0.4,1.0,0.6).."|r".." Friends", ssTitleFont, "CENTER", 0)
		tooltip:AddLine(" ")
	end

	if onlineFriends > 0 then
		line = tooltip:AddLine()
		if not ElvDB.SLEMinimize.minimizeCharacterFriends then
			tooltip:SetCell(line, 1, characterFriend, "CENTER", 0)
		else
			tooltip:SetCell(line, 1, minbutton .. characterFriend, "CENTER", 0)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "client:minimizeCharacterFriends")

		if not ElvDB.SLEMinimize.minimizeCharacterFriends then
			line = tooltip:AddHeader()
			line = tooltip:SetCell(line, 1, "  ")  -- !Level Column
			line = tooltip:SetCell(line, 3, _G.NAME)  -- !Name Column
			line = tooltip:SetCell(line, 5, _G.ZONE)  -- !Location Column

			if not E.db.sle.dt.friends.hideFriendsNotes then
				line = tooltip:SetCell(line, 7, L["Note"], "LEFT")  --!Note Column
			else
				line = tooltip:SetCell(line, 7, minbutton .. L["Note"], "LEFT")
			end

			tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hide:hideFriendsNotes")
			tooltip:AddSeparator()

			for _, info in ipairs(friendTable) do
				if info.online then
					local shouldSkip = false

					if (info.status == statusTable.AFK) and E.db.sle.dt.friends.hideAFK then
						shouldSkip = true
					elseif (info.status == statusTable.DND) and E.db.sle.dt.friends.hideDND then
						shouldSkip = true
					end

					if not shouldSkip then
						if E.MapInfo.zoneText and (E.MapInfo.zoneText == info.zone) then
							zonec = activezone
						else
							zonec = inactivezone
						end

						classc, levelc = E:ClassColor(info.class), GetQuestDifficultyColor(info.level)

						if not classc then
							classc = levelc
						end

						line = tooltip:AddLine()
						line = tooltip:SetCell(line, 1, format("|cff%02x%02x%02x%d|r", levelc.r * 255, levelc.g * 255, levelc.b * 255, info.level))
						line = tooltip:SetCell(line, 2, info.status)
						line = tooltip:SetCell(line, 3, format("|cff%02x%02x%02x%s|r", classc.r * 255, classc.g * 255, classc.b * 255, info.characterName) .. inGroup(info.characterName))
						line = tooltip:SetCell(line, 5, format("|cff%02x%02x%02x%s|r", zonec.r * 255, zonec.g * 255, zonec.b * 255, info.zone), "CENTER")

						if not E.db.sle.dt.friends.hideFriendsNotes then
							line = tooltip:SetCell(line, 7, info.notes, "LEFT")
						end

						tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("friends:%s", info.characterName))
					end
				end
			end
		end
	end

	if numBNetOnline > 0 then
		local status, fcolor
		for _, client in ipairs(clientSorted) do
			local Table = tableList[client]
			for _, info in ipairs(Table) do
				local sepclient = (info.wowProjectID == classicID and info.gameText) or client
				sepclient = sepclient:gsub(' ', '')
				local shouldSkip = E.db.sle.dt.friends['hide'..sepclient]
				if not shouldSkip then
					if info.isOnline then
						shouldSkip = false
						if info.isBnetAFK == true then
							if E.db.sle.dt.friends.hideAFK then
								shouldSkip = true
							end
							status = statusTable.AFK
						elseif info.isBnetDND == true then
							if E.db.sle.dt.friends.hideDND then
								shouldSkip = true
							end
							status = statusTable.DND
						else
							status = ""
						end

						if not shouldSkip then
							local header = format("%s (%s%s|r)", battleNetString, hexColor, (info.wowProjectID == classicID and info.gameText) or clientTags[client] or client)

							if info.client and info.client == wowString then
								classc = E:ClassColor(info.className)

								if info.level and info.level ~= '' then
									levelc = GetQuestDifficultyColor(info.level)
								else
									classc, levelc = PRIEST_COLOR, PRIEST_COLOR
								end

								if info.faction and info.faction == "Horde" then
									fcolor = "ff2020"
								else
									fcolor = "0070dd"
								end

								if E.MapInfo.zoneText and (E.MapInfo.zoneText == info.zoneName) then
									zonec = activezone
								else
									zonec = inactivezone
								end

								--Sometimes the friend list is fubar with level 0 unknown friends
								if not classc then classc = PRIEST_COLOR end

								TooltipAddXLine(tooltip, header, info.client, sepclient, format("|cff%02x%02x%02x%d|r", levelc.r * 255, levelc.g * 255, levelc.b * 255, info.level), status, classc, info.characterName, info.accountName, info.customMessage, info.customMessageTime, format("|cff%02x%02x%02x%s|r", zonec.r * 255, zonec.g * 255, zonec.b * 255, info.zoneName or UNKNOWN), fcolor, info.realmName, info.guid, info.noteText, info.accountID, info.gameText)
							else
								if not classc then
									classc = {r = "0.51",g = ".77",b = "1"}
								end
								TooltipAddXLine(tooltip, header, info.client, nil, nil, status, classc, info.characterName, info.accountName, info.customMessage, info.customMessageTime, nil, fcolor, info.realmName, info.guid, info.noteText, info.accountID, info.gameText)
							end
						end
					end
				end
			end
		end
		tooltip:AddLine(" ")
	end

	if not E.db.sle.dt.friends.hide_hintline then
		line = tooltip:AddLine()
		if not ElvDB.SLEMinimize.minimize_hintline then
			tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, minbutton .. "Hint:", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "client:minimize_hintline")

		if not ElvDB.SLEMinimize.minimize_hintline then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sLeft Click|r a person's line to whisper them."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sRight Click|r a person's line that has a bnet broadcast icon to expand it."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sShift+Left Click|r a person's line to perform a lookup."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sShift+Right Click|r a person's line to set a note for them."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sCtrl+Left Click|r a person's line to invite them."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sLeft Click|r a client service to hide it."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sRight Click|r a client service to set your BNet Broadcast."]:format(hexColor), "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 2, L["%sLeft Click|r datatext panel to open friends list."]:format(hexColor), "LEFT", 3)
			tooltip:SetCell(line, 5, L["%sRight Click|r datatext panel to customize."]:format(hexColor), "LEFT", 3)
		end
	end

	tooltip:UpdateScrolling()
	tooltip:Show()
end

local function ValueColorUpdate(self, hex)
	displayhex = hex
	OnEvent(self)
end

DT:RegisterDatatext('S&L Friends', 'S&L', {'BN_FRIEND_ACCOUNT_ONLINE', 'BN_FRIEND_ACCOUNT_OFFLINE', 'BN_FRIEND_INFO_CHANGED', 'FRIENDLIST_UPDATE', 'CHAT_MSG_SYSTEM', 'MODIFIER_STATE_CHANGED'}, OnEvent, nil, OnClick, OnEnter, nil, 'S&L Friends', nil, ValueColorUpdate)
