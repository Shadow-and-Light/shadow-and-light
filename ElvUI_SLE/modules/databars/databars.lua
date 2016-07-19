local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:NewModule("DataBars","AceHook-3.0", "AceEvent-3.0")

DB.Icons = {
	Rep = [[Interface\Icons\Achievement_Reputation_08]],
	XP = [[Interface\Icons\XP_ICON]],
}

function DB:RegisterFilters()
	if E.db.sle.databars.rep.chatfilter.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", self.FilterReputation)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", self.FilterReputation)
	end
	if E.db.sle.databars.exp.chatfilter.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", self.FilterExperience)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", self.FilterExperience)
	end
	if E.db.sle.databars.artifact.chatfilter.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.FilterArtExperience)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.FilterArtExperience)
	end
	if E.db.sle.databars.honor.chatfilter.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_HONOR_GAIN", self.FilterHonor)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_COMBAT_HONOR_GAIN", self.FilterHonor)
	end
end

function DB:Initialize()
	if not SLE.initialized then return end

	function DB:ForUpdateAll()
		DB.db = E.db.sle.databars
		DB:RegisterFilters()
	end

	DB:ExpInit()
	DB:RepInit()
	DB:ArtInit()
	DB:HonorInit()
	DB:ForUpdateAll()

	self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", "ChatMsgCombat")
	self:RegisterEvent("COMBAT_TEXT_UPDATE", "CombatTextUpdate")
	self:RegisterEvent("CHAT_MSG_SYSTEM", "ChatMsgSys")
	self:RegisterEvent("PLAYER_LOGIN", "PlayerRepLogin")
	self:RegisterEvent("PLAYER_GUILD_UPDATE", "PlayerGuildRepUdate")
	self:RegisterEvent("UPDATE_FACTION", "NewRepString")
	DB:NewRepString()
end

SLE:RegisterModule(DB:GetName())