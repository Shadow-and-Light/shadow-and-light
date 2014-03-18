local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local gsub, upper = string.gsub, string.upper
local menuFrame = CreateFrame("Frame", "ElvUI_SLE_MainMenuFrame", E.UIParent)
menuFrame:SetTemplate("Transparent", true)

local calendar_string = gsub(SLASH_CALENDAR1, "/", "")
calendar_string = gsub(calendar_string, "^%l", upper)

local menu = {
	{ text = L['Main Menu'], func = function()
		if not GameMenuFrame:IsShown() then
			ShowUIPanel(GameMenuFrame);
		else
			HideUIPanel(GameMenuFrame);
		end
	end },
	{ text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end },
	{ text = SPELLBOOK_ABILITIES_BUTTON, func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end },
	{ text = MOUNTS_AND_PETS, func = function() TogglePetJournal() end },
	{ text = TALENTS_BUTTON, func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end },
	{ text = TIMEMANAGER_TITLE, func = function() ToggleFrame(TimeManagerFrame) end },
	{ text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end },
	{ text = QUESTLOG_BUTTON, func = function() ToggleFrame(QuestLogFrame) end },
	{ text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame() end },
	{ text = calendar_string, func = function() GameTimeFrame:Click() end },
	{ text = PLAYER_V_PLAYER, func = function()
		if not PVPUIFrame then
			PVP_LoadUI()
		end
		ToggleFrame(PVPUIFrame)
	end },
	{ text = ACHIEVEMENTS_GUILD_TAB, func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end },
	{ text = LFG_TITLE, func = function() PVEFrame_ToggleFrame(); end },
	{ text = L["Raid Browser"], func = function() ToggleFrame(RaidBrowserFrame) end },
	{ text = ENCOUNTER_JOURNAL, func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end },
	{ text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end },
	{ text = HELP_BUTTON, func = function() ToggleHelpFrame() end },
}

local function OnClick(self)
	E:DropDown(menu, menuFrame)
end

local function OnEvent(self, event, ...)
	self.text:SetText(L['Main Menu'])
end

DT:RegisterDatatext('S&L MicroMenu', {'PLAYER_LOGIN'}, OnEvent, nil, OnClick, nil)