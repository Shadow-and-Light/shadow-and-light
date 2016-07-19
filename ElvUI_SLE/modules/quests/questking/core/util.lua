local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local function Replace()
local QuestKing = _G["QuestKing"]

local knownTypesTag = {
	[0] = "",     -- Normal
	[1] = "G",    -- Group
	[21] = "C",	  -- Class
	[41] = "P",   -- PVP
	[62] = "R",   -- Raid
	[81] = "D",   -- Dungeon
	[82] = "V",   -- World Event (?)
	[83] = "L",   -- Legendary
	[84] = "E",   -- Escort (?)
	[85] = "H",   -- Heroic
	[88] = "R10", -- 10 Player (?)
	[89] = "R25", -- 25 Player (?)
	[98] = "S",   -- Scenario
	[102] = "A",  -- Account
	-- Y = Daily
	-- W = Weekly
	-- F = Faction (Alliance/Horde)
	-- e = Starts event
	-- a = Autocomplete
}

local knownTypesTagFull = {
	[0] = "",     -- Normal
	[1] = GROUP,    -- Group
	[21] = CLASS,  -- Class
	[41] = "PvP",   -- PVP
	[62] = RAID,   -- Raid
	[81] = TRACKER_HEADER_DUNGEON,   -- Dungeon
	[82] = "V",   -- World Event (?)
	[83] = ITEM_QUALITY5_DESC,   -- Legendary
	[84] = "E",   -- Escort (?)
	[85] = PLAYER_DIFFICULTY2,   -- Heroic
	[88] = RAID.."10", -- 10 Player (?)
	[89] = RAID.."25", -- 25 Player (?)
	[98] = TRACKER_HEADER_SCENARIO,   -- Scenario
	[102] = "A",  -- Account
	-- Y = Daily
	-- W = Weekly
	-- F = Faction (Alliance/Horde)
	-- e = Starts event
	-- a = Autocomplete
}

function QuestKing.GetQuestTaggedTitle (questIndex, isBonus)
	local questTitle, level, suggestedGroup, _, _, _, frequency, questID, startEvent = GetQuestLogTitle(questIndex)
	local questType = GetQuestLogQuestType(questIndex)
	-- local questTagID, questTag = GetQuestTagInfo(questID)

	local levelString
	local typeTag = knownTypesTag[questType]
	local typeTagFull = knownTypesTagFull[questType]

	if (typeTag == nil) then
		typeTag = format("|cffff00ff(%d)|r", questType) -- Alert user to unknown tags
	end

	-- Add primary tags
	if (questType == 1) and (suggestedGroup) and (suggestedGroup > 1) then
		-- Group
		if E.private.sle.skins.QuestKing.questTypes.group == "DEFAULT" then
			levelString = format("%d%s%d", level, typeTag, suggestedGroup)
		else
			levelString = format("%d %s(%d)", level, typeTagFull, suggestedGroup)
		end
	elseif (questType == 1) and (suggestedGroup) and (suggestedGroup == 0) then
		-- Group
		if E.private.sle.skins.QuestKing.questTypes.group == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType == 102) then
		-- Account
		local factionGroup = GetQuestFactionGroup(questID)
		if (factionGroup) then
			levelString = format("%d%s", level, "F")
		else
			levelString = format("%d %s", level, typeTag)
		end
	elseif (questType == 62) or (questType == 88) or (questType == 89) then
		if E.private.sle.skins.QuestKing.questTypes.raid == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType == 81) then
		if E.private.sle.skins.QuestKing.questTypes.dungeon == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType == 85) then
		if E.private.sle.skins.QuestKing.questTypes.heroic == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType == 83) then
		if E.private.sle.skins.QuestKing.questTypes.legend == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType == 98) then
		if E.private.sle.skins.QuestKing.questTypes.scenario == "DEFAULT" then
			levelString = format("%d%s", level, typeTag)
		else
			levelString = format("%d %s", level, typeTagFull)
		end
	elseif (questType > 0) then
		-- Other types
		levelString = format("%d%s", level, typeTag)
	else
		-- Normal
		levelString = tostring(level)
	end

	-- Extra tags
	local hasIcon = false
	local icon = ""
	if (frequency == LE_QUEST_FREQUENCY_DAILY) then
		if E.private.sle.skins.QuestKing.questTypes.daily == "DEFAULT" then
			levelString = format("%sY", levelString)
		elseif E.private.sle.skins.QuestKing.questTypes.daily == "FULL" then
			levelString = format("%s "..DAILY, levelString)
		else
			hasIcon = true
			icon = "|T"..QK.Icons["Daily"]..":14|t"
		end
	elseif (frequency == LE_QUEST_FREQUENCY_WEEKLY) then
		if E.private.sle.skins.QuestKing.questTypes.weekly == "DEFAULT" then
			levelString = format("%sW", levelString)
		elseif E.private.sle.skins.QuestKing.questTypes.weekly == "FULL" then
			levelString = format("%s "..WEEKLY, levelString)
		else
			hasIcon = true
			icon = "|T"..QK.Icons["Weekly"]..":14|t"
		end
		-- levelString = format("%s Weekly", levelString)
	end

	if (startEvent) then
		levelString = format("%se", levelString)
	end

	if (GetQuestLogIsAutoComplete(questIndex)) and (not isBonus) then
		levelString = format("%sa", levelString)
	end

	-- Return
	if (isBonus) then
		questTitle = gsub(questTitle, BONUS_OBJECTIVE_BANNER..": ", "")
		if hasIcon then
			return format("%s[%s] %s", icon,  levelString, questTitle), level
		else
			return format("[%s] %s", levelString, questTitle), level
		end
	else
		if hasIcon then
			return format("%s[%s] %s", icon,  levelString, questTitle)
		else
			return format("[%s] %s", levelString, questTitle)
		end
	end
end

end

T.tinsert(QK.Replaces, Replace)