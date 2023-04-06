local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DB = SLE.DataBars

--GLOBALS: ChatFrame_AddMessageEventFilter, ChatFrame_RemoveMessageEventFilter

DB.Icons = {
	Rep = [[Interface\Icons\Achievement_Reputation_08]],
	XP = [[Interface\Icons\XP_ICON]],
}

function DB:RegisterFilters()
	if E.db.sle.databars.reputation.chatfilter.enable then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', DB.FilterReputation)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', DB.FilterReputation)
	end
	if E.db.sle.databars.experience.chatfilter.enable then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_XP_GAIN', DB.FilterExperience)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_COMBAT_XP_GAIN', DB.FilterExperience)
	end
	if E.db.sle.databars.honor.chatfilter.enable then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_HONOR_GAIN', DB.FilterHonor)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_COMBAT_HONOR_GAIN', DB.FilterHonor)
	end
end

function DB:Initialize()
	if not SLE.initialized then return end
	DB.db = E.db.sle.databars
	DB:RegisterFilters()

	function DB:ForUpdateAll()
		DB:RegisterFilters()
	end

	DB:ExpInit()
	DB:RepInit()
	DB:AzeriteInit()
	DB:HonorInit()
	-- DB:ForUpdateAll()
end

SLE:RegisterModule(DB:GetName())
