local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local LibQTip = LibStub('LibQTip-1.0')
local DTP = SLE:GetModule('Datatexts')
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("S&L Friends",
{
	type	= "data source",
	icon	= "Interface\\Icons\\INV_Drink_08.png",
	label	= "S&L Friends",
	text	= "S&L Friends"
})
local _G = _G
local ONE_MINUTE = 60;
local ONE_HOUR = 60 * ONE_MINUTE;
local ONE_DAY = 24 * ONE_HOUR;
local ONE_MONTH = 30 * ONE_DAY;
local ONE_YEAR = 12 * ONE_MONTH;

local MINIMIZE = MINIMIZE
local BNET_BROADCAST_SENT_TIME = BNET_BROADCAST_SENT_TIME
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE
local CHAT_FLAG_AFK = CHAT_FLAG_AFK
local CHAT_FLAG_DND = CHAT_FLAG_DND
local LASTONLINE_SECS, LASTONLINE_MINUTES, LASTONLINE_HOURS, LASTONLINE_DAYS, LASTONLINE_MONTHS, LASTONLINE_YEARS = LASTONLINE_SECS, LASTONLINE_MINUTES, LASTONLINE_HOURS, LASTONLINE_DAYS, LASTONLINE_MONTHS, LASTONLINE_YEARS

local ShowFriends = ShowFriends
local IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown = IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local SetItemRef = SetItemRef
local StaticPopup_Show = StaticPopup_Show

local realid_table = {}

local function sletime_Conversion(timeDifference, isAbsolute)
   if ( not isAbsolute ) then
      timeDifference = T.time() - timeDifference;
   end
   local year, month, day, hour, minute;
   
   if ( timeDifference < ONE_MINUTE ) then
      return LASTONLINE_SECS;
   elseif ( timeDifference >= ONE_MINUTE and timeDifference < ONE_HOUR ) then
      return T.format(LASTONLINE_MINUTES, T.floor(timeDifference / ONE_MINUTE));
   elseif ( timeDifference >= ONE_HOUR and timeDifference < ONE_DAY ) then
      return T.format(LASTONLINE_HOURS, T.floor(timeDifference / ONE_HOUR));
   elseif ( timeDifference >= ONE_DAY and timeDifference < ONE_MONTH ) then
      return T.format(LASTONLINE_DAYS, T.floor(timeDifference / ONE_DAY));
   elseif ( timeDifference >= ONE_MONTH and timeDifference < ONE_YEAR ) then
      return T.format(LASTONLINE_MONTHS, T.floor(timeDifference / ONE_MONTH));
   else
      return T.format(LASTONLINE_YEARS, T.floor(timeDifference / ONE_YEAR));
   end
end

local frame = CreateFrame("frame")
local tooltip
local LDB_ANCHOR
local wtcgString = BNET_CLIENT_WTCG
local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local AWAY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-Away:18|t"
local BUSY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-DnD:18|t"
local MOBILE_ICON	= "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:18|t"
local MINIMIZE		= "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"
local BROADCAST_ICON = "|TInterface\\FriendsFrame\\BroadcastIcon:0|t"

-- Setup the Title Font. 14
local ssTitleFont = CreateFont("ssTitleFont")
ssTitleFont:SetTextColor(1,0.823529,0)
ssTitleFont:SetFont(GameTooltipText:GetFont(), 14)

-- Setup the Header Font. 12
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)
ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont(), 12)

-- Setup the Regular Font. 12
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)
ssRegFont:SetFont(GameTooltipText:GetFont(), 12)

local list_sort = {
	TOONNAME = function(a, b)
		return a["TOONNAME"] < b["TOONNAME"]
	end,
	LEVEL =	function(a, b)
		if a["LEVEL"] < b["LEVEL"] then
			return true
		elseif a["LEVEL"] > b["LEVEL"] then
			return false
		else  -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	RANKINDEX =	function(a, b)
		if a["RANKINDEX"] > b["RANKINDEX"] then
			return true
		elseif a["RANKINDEX"] < b["RANKINDEX"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	ZONENAME = function(a, b)
		if a["ZONENAME"] < b["ZONENAME"] then
			return true
		elseif a["ZONENAME"] > b["ZONENAME"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	REALMNAME = function(a, b)
		if a["REALMNAME"] < b["REALMNAME"] then
			return true
		elseif a["REALMNAME"] > b["REALMNAME"] then
			return false
		else -- TOONNAME
			return a["ZONENAME"] < b["ZONENAME"]
		end
	end,
	revTOONNAME	= function(a, b)
		return a["TOONNAME"] > b["TOONNAME"]
	end,
	revLEVEL = function(a, b)
		if a["LEVEL"] > b["LEVEL"] then
			return true
		elseif a["LEVEL"] < b["LEVEL"] then
			return false
		else  -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revRANKINDEX = function(a, b)
		if a["RANKINDEX"] < b["RANKINDEX"] then
			return true
		elseif a["RANKINDEX"] > b["RANKINDEX"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revZONENAME	= function(a, b)
		if a["ZONENAME"] > b["ZONENAME"] then
			return true
		elseif a["ZONENAME"] < b["ZONENAME"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revREALMNAME = function(a, b)
		if a["REALMNAME"] > b["REALMNAME"] then
			return true
		elseif a["REALMNAME"] < b["REALMNAME"] then
			return false
		else -- TOONNAME
			return a["ZONENAME"] < b["ZONENAME"]
		end
	end
}

local function inGroup(name)
	if T.GetNumSubgroupMembers() > 0 and T.UnitInParty(name) then
		return true
	elseif T.GetNumGroupMembers() > 0 and T.UnitInRaid(name) then
		return true
	end

	return false
end

local function nameIndex(name)
	local lookupname

	for i = 1, T.GetNumFriends() do
		lookupname = T.GetFriendInfo(i)
		if lookupname == name then
			return i
		end
	end
end

local function ColoredLevel(level)
	if level ~= "" then
		local color = T.GetQuestDifficultyColor(level)
		return T.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local CLASS_COLORS, color = {}
local classes_female, classes_male = {}, {}

FillLocalizedClassList(classes_female, true)
FillLocalizedClassList(classes_male, false)

for token, localizedName in T.pairs(classes_female) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = T.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

for token, localizedName in T.pairs(classes_male) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = T.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

local function valueColor(totals)
	if totals ~= "" then
		local color = E.db.general.valuecolor
		return T.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, totals)
	end
end

function DTP:update_Friends()
	ShowFriends()
	local friendsTotal, friendsOnline = T.GetNumFriends()
	local bnTotal, bnOnline = T.BNGetNumFriends()
	local totalOnline = friendsOnline + bnOnline
	local totalFriends = friendsTotal + bnTotal

	if E.db.sle.dt.friends.totals then
		LDB.text = "|cffffffff"..L["Friends"]..": |r"..valueColor(totalOnline).."/"..valueColor(totalFriends)
	else
		LDB.text = "|cffffffff"..L["Friends"]..": |r"..valueColor(totalOnline)
	end
end

local function Entry_OnMouseUp(frame, info, button)
	local i_type, toon_name, full_name, presence_id = T.split(":", info)

	if button == "LeftButton" then
		if IsAltKeyDown() then
			if i_type == "realid" then
				local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID = T.BNGetFriendInfo(T.BNGetFriendIndex(presence_id))
				local _, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = T.BNGetGameAccountInfo(toonID or 0)
				if E.myrealm == realmName then
					T.InviteUnit(toon_name)
				else
					T.InviteUnit(toon_name.."-"..realmName)
				end
				return
			else
				T.InviteUnit(toon_name)
				return
			end
		end

		if IsShiftKeyDown() then
			SetItemRef("player:"..toon_name, "|Hplayer:"..toon_name.."|h["..toon_name.."|h", "LeftButton")
			return
		end

		if IsControlKeyDown() then
			if i_type == "friends" then
				FriendsFrame.NotesID = nameIndex(toon_name)
 				StaticPopup_Show("SET_FRIENDNOTE", T.GetFriendInfo(FriendsFrame.NotesID))
 				return
			end

			if i_type == "realid" then
				FriendsFrame.NotesID = presence_id
				StaticPopup_Show("SET_BNFRIENDNOTE", full_name)
				return
			end
		end

		if i_type == "realid" then
			local name
			for _, player in T.ipairs(realid_table) do
				if player["GIVENNAME"] == presence_id and player["CLIENT"] == "Hero" then
					name = presence_id..":"..player["PRESENCEID"]
					break
				end
			end
			if not name then name = full_name..":"..presence_id end
			SetItemRef( "BNplayer:"..name, T.format("|HBNplayer:%1$s|h[%1$s]|h", name), "LeftButton" )     
		else
			SetItemRef( "player:"..full_name, T.format("|Hplayer:%1$s|h[%1$s]|h", full_name), "LeftButton" )
		end
	elseif button == "RightButton" then
		if IsControlKeyDown() then
			--Possibly Set BNetBroadcast
			--	E:StaticPopup_Show("SET_BN_BROADCAST")
		end
	elseif button == "MiddleButton" then
		E.db.sle.dt.friends.expandBNBroadcast = not E.db.sle.dt.friends.expandBNBroadcast
		LDB.OnEnter(LDB_ANCHOR)
	end
end

local function HideOnMouseUp(cell, section)
	E.db.sle.dt.friends[section] = not E.db.sle.dt.friends[section]
	LDB.OnEnter(LDB_ANCHOR)
end

local function SetRealIDSort(cell, sortsection)
	if E.db.sle.dt.friends["sortBN"] == sortsection then
		E.db.sle.dt.friends["sortBN"] = "rev" .. sortsection
	else
		E.db.sle.dt.friends["sortBN"] = sortsection
	end
	LDB.OnEnter(LDB_ANCHOR)
end

function LDB:OnClick(button)
	if button == "LeftButton" then
		ToggleFriendsFrame()
	end

	if button == "RightButton" then
		ElvConfigToggle:Click();
		SLE.ACD:SelectGroup("ElvUI", "sle", "modules", "datatext", "sldatatext", "slfriends")
	end
end

function LDB.OnLeave() end

function LDB.OnEnter(self)
	if E.db.sle.dt.friends.combat and T.InCombatLockdown() then return end
	LDB_ANCHOR = self

	if LibQTip:IsAcquired("ShadowLightFriends") then
		tooltip:Clear()
	else
		tooltip = LibQTip:Acquire("ShadowLightFriends", 8, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")

		tooltip:SetBackdropColor(0,0,0,1)

		tooltip:SetHeaderFont(ssHeaderFont)
		tooltip:SetFont(ssRegFont)

		tooltip:SmartAnchorTo(self)
		tooltip:SetAutoHideDelay(E.db.sle.dt.friends.tooltipAutohide, self)
		tooltip:SetScript("OnShow", function(ttskinself) ttskinself:SetTemplate('Transparent') end)
	end

	local line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "Shadow & Light Friends", ssTitleFont, "CENTER", 0)
	tooltip:AddLine(" ")

	local _, numBNOnline = T.BNGetNumFriends()
	local _, numFriendsOnline = T.GetNumFriends()

	if (numBNOnline > 0) or (numFriendsOnline > 0) then
		line = tooltip:AddLine()
		if not E.db.sle.dt.friends.hideFriends then
			tooltip:SetCell(line, 1, "|cffffffff" .. _G.FRIENDS .. "|r", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, "|cffffffff" .. MINIMIZE .. _G.FRIENDS .. "|r", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "hideFriends")

		if not E.db.sle.dt.friends.hideFriends then
			line = tooltip:AddHeader()
			line = tooltip:SetCell(line, 1, "  ")
			tooltip:SetCellScript(line, 1, "OnMouseUp", SetRealIDSort, "LEVEL")
			line = tooltip:SetCell(line, 3, _G.NAME)
			tooltip:SetCellScript(line, 3, "OnMouseUp", SetRealIDSort, "TOONNAME")
			line = tooltip:SetCell(line, 4, _G.BATTLENET_FRIEND)
			tooltip:SetCellScript(line, 4, "OnMouseUp", SetRealIDSort, "REALID")
			line = tooltip:SetCell(line, 5, _G.LOCATION_COLON)
			tooltip:SetCellScript(line, 5, "OnMouseUp", SetRealIDSort, "ZONENAME")
			line = tooltip:SetCell(line, 6, _G.FRIENDS_LIST_REALM)
			tooltip:SetCellScript(line, 6, "OnMouseUp", SetRealIDSort, "REALMNAME")
			if not E.db.sle.dt.friends.hideFriendsNotes then
				line = tooltip:SetCell(line, 7, _G.NOTE_COLON)
			else
				line = tooltip:SetCell(line, 7, MINIMIZE .. _G.NOTE_COLON)
			end
			tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hideFriendsNotes")

			tooltip:AddSeparator()

			if numBNOnline > 0 then
				T.twipe(realid_table)
				for i = 1, numBNOnline do
					local presenceID, givenName, bTag, _, _, toonID, gameClient, isOnline, lastOnline, isAFK, isDND, broadcast, note, _, castTime = T.BNGetFriendInfo(i)
					local _, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = T.BNGetGameAccountInfo(toonID or 0)
					local broadcastTime = ""
					if castTime then
						broadcastTime = T.format(BNET_BROADCAST_SENT_TIME, sletime_Conversion(castTime));
					end
					
					local fcolor
					local status = ""
					if toonName then
						if faction then
							if faction == "Horde" then
								fcolor = RED_FONT_COLOR_CODE
							else
								fcolor = "|cff0070dd"
							end
						end
						if isAFK then
							status = AWAY_ICON
						end
						if isDND then
							status = BUSY_ICON
						end
						if note and note ~= "" then note = "|cffff8800{"..note.."}|r" end
							
						T.tinsert(realid_table, {
							GIVENNAME = givenName,
							SURNAME = bTag or "",
							LEVEL = level,
							CLASS = class,
							FCOLOR = fcolor,
							STATUS = status,
							BROADCAST_TEXT = broadcast or "",
							BROADCAST_TIME = broadcastTime or "",
							TOONNAME = toonName,
							CLIENT = client,
							ZONENAME = zoneName,
							REALMNAME = realmName,
							GAMETEXT = gameText,
							NOTE = note,
							PRESENCEID = presenceID
							})
					end
				end

				if (E.db.sle.dt.friends["sortBN"] ~= "REALID") and (E.db.sle.dt.friends["sortBN"] ~= "revREALID") then
					T.sort(realid_table, list_sort[E.db.sle.dt.friends["sortBN"]])
				end

				for _, player in T.ipairs(realid_table) do
					local broadcast_flag
					if not E.db.sle.dt.friends.expandBNBroadcast and player["BROADCAST_TEXT"] ~= "" then
						broadcast_flag = " " .. BROADCAST_ICON
					else
						broadcast_flag = ""
					end

					line = tooltip:AddLine()
					line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
					line = tooltip:SetCell(line, 2, player["STATUS"])
					if player["CLIENT"] ~= "Hero" then
						line = tooltip:SetCell(line, 3,
						T.format("|cff%s%s",CLASS_COLORS[player["CLASS"]] or "B8B8B8", player["TOONNAME"] .. "|r")..
						(inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""))
					else
						line = tooltip:SetCell(line, 3, T.format(""))
					end
					line = tooltip:SetCell(line, 4,
						"|cff82c5ff" .. player["GIVENNAME"] .. "|r" .. broadcast_flag)

					if player["CLIENT"] == "WoW" then
						line = tooltip:SetCell(line, 5, player["ZONENAME"])
						line = tooltip:SetCell(line, 6, player["FCOLOR"] .. player["REALMNAME"] .. "|r")
					elseif player["CLIENT"] == "App" then
							line = tooltip:SetCell(line, 5, "|cff82c5ffDesktop Application|r")
							line = tooltip:SetCell(line, 6, "|cff01b2f1Battle.net|r")
					else
						line = tooltip:SetCell(line, 5, player["GAMETEXT"])
						if player["CLIENT"] == "S2" then
							line = tooltip:SetCell(line, 6, "|cff82c5ffStarCraft 2|r")
						end

						if player["CLIENT"] == "D3" then
							line = tooltip:SetCell(line, 6, "|cffad835aDiablo 3|r")
						end
						
						if player["CLIENT"] == wtcgString then
							line = tooltip:SetCell(line, 6, "|cff82c5ffHearthstone|r")
						end
						if player["CLIENT"] == "Hero" then
							line = tooltip:SetCell(line, 6, "|cff82c5ffHeroes of The Storm|r")
						end
						if player["CLIENT"] == "Pro" then
							line = tooltip:SetCell(line, 6, "|cff82c5ffOverwatch|r")
						end
					end

					if not E.db.sle.dt.friends.hideFriendsNotes then
						line = tooltip:SetCell(line, 7, player["NOTE"])
					end

					tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, T.format("realid:%s:%s:%d", player["TOONNAME"], player["GIVENNAME"], player["PRESENCEID"]))

					if E.db.sle.dt.friends.expandBNBroadcast and player["BROADCAST_TEXT"] ~= "" then
						line = tooltip:AddLine()
						line = tooltip:SetCell(line, 1, BROADCAST_ICON .. " |cff7b8489" .. player["BROADCAST_TEXT"] .. "|r "..player["BROADCAST_TIME"], "LEFT", 0)
						tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, T.format("realid:%s:%s:%d", player["TOONNAME"], player["GIVENNAME"], player["PRESENCEID"]))
					end
				end
				tooltip:AddLine(" ")
			end

			if numFriendsOnline > 0 then
				local friend_table = {}
				for i = 1,numFriendsOnline do
					local toonName, level, class, zoneName, connected, status, note = T.GetFriendInfo(i)
					note = note and "|cffff8800{"..note.."}|r" or ""

					if status == CHAT_FLAG_AFK then
						status = AWAY_ICON
					elseif status == CHAT_FLAG_DND then
						status = BUSY_ICON
					end

					T.tinsert(friend_table, {
						TOONNAME = toonName,
						LEVEL = level,
						CLASS = class,
						ZONENAME = zoneName,
						REALMNAME = "",
						STATUS = status,
						NOTE = note
						})
				end

				if (E.db.sle.dt.friends["sortBN"] ~= "REALID") and (E.db.sle.dt.friends["sortBN"] ~= "revREALID") then
					T.sort(friend_table, list_sort[E.db.sle.dt.friends["sortBN"]])
				else
					T.sort(friend_table, list_sort["TOONNAME"])
				end

				for _, player in T.ipairs(friend_table) do
					line = tooltip:AddLine()
					line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
					line = tooltip:SetCell(line, 2, player["STATUS"])
					line = tooltip:SetCell(line, 3,
						T.format("|cff%s%s", CLASS_COLORS[player["CLASS"]] or "ffffff", player["TOONNAME"] .. "|r") .. (inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""));
					line = tooltip:SetCell(line, 5, player["ZONENAME"])
					if not E.db.sle.dt.friends.hideFriendsNotes then
						line = tooltip:SetCell(line, 7, player["NOTE"])
					end
					tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, T.format("friends:%s:%s", player["TOONNAME"], player["TOONNAME"]))
				end
			end
		end
		tooltip:AddLine(" ")
	end

	if not E.db.sle.dt.friends.hide_hintline then
		line = tooltip:AddLine()
		if not E.db.sle.dt.friends.minimize_hintline then
			tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, MINIMIZE .. "Hint:", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "minimize_hintline")

		if not E.db.sle.dt.friends.minimize_hintline then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fLeft Click|r to open the friends panel."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fRight Click|r to open configuration panel."], "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fLeft Click|r a line to whisper a player."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fShift+Left Click|r a line to lookup a player."], "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fCtrl+Left Click|r a line to edit a note."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fMiddleClick|r a line to expand RealID."], "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fAlt+Left Click|r a line to invite."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fLeft Click|r a Header to hide it or sort it."], "LEFT", 3)
		end
	end

	tooltip:UpdateScrolling()
	tooltip:Show()
end

frame:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		return self[event](self, event, ...) 
	end 
end)

function frame:PLAYER_LOGIN()
	local _, numBNOnline = T.BNGetNumFriends()
	local _, numFriendsOnline = T.GetNumFriends()

	if (numBNOnline > 0) or (numFriendsOnline > 0) then
		if numBNOnline > 0 then
			for i = 1, numBNOnline do
					local presenceID, givenName, bTag, _, _, toonID, gameClient, isOnline, lastOnline, isAFK, isDND, broadcast, note, _, castTime = T.BNGetFriendInfo(i)
					local _, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = T.BNGetGameAccountInfo(toonID or 0)
			end
		end
	end
end

local DELAY = 15  --  Update every 15 seconds
local elapsed = DELAY - 5

frame:SetScript("OnUpdate", function (self, elapse)
	elapsed = elapsed + elapse

	if elapsed >= DELAY then
		elapsed = 0
		DTP:update_Friends()
	end
end)

frame:RegisterEvent("PLAYER_LOGIN")