-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator and Allaidia
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
-- Allaidia - Cenarion Circle US
--
-------------------------------------------------
--
-- Thanks to / Благодарности:
-- Elv and ElvUI community
-- Slipslop for scale option
-- Blazeflack for helping with option storage and profile changing
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, V, P, G =  unpack(ElvUI);
local MB = E:NewModule('Microbar', 'AceHook-3.0', 'AceEvent-3.0');
local AB = E:GetModule('ActionBars'); --Added as your menu creation method uses it.

--Setting all variables as locals to avoid possible conflicts with other addons
local microbar
local microbarcontrol
local CharB
local SpellB
local TalentB
local AchievB
local QuestB
local GuildB
local PVPB
local LFDB
local RaidB
local EJB
local MenuB
local HelpB
local CharBS

--A table of names. Used for buttons creating.
local microbuttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"QuestLogMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"RaidMicroButton",
	"HelpMicroButton",
	"MainMenuMicroButton",
	"AchievementMicroButton"
}

--Setting loacle shortnames and on update script for mouseover/alpha (can't get rid of using it at the moment)
function MB:SetNames()
	microbar = CreateFrame('Frame', "MicroParent", E.UIParent); --Setting a main frame for Menu
	microbarcontrol = CreateFrame('Frame', "MicroControl", E.UIParent); --Setting Control Frame to handle events
	microbarS = CreateFrame('Frame', "MicroParentS", E.UIParent); --Setting a main frame for Menu with letters
	
	CharB = CharacterMicroButton
	SpellB = SpellbookMicroButton
	TalentB = TalentMicroButton
	AchievB = AchievementMicroButton
	QuestB = QuestLogMicroButton
	GuildB = GuildMicroButton
	PVPB = PVPMicroButton
	LFDB = LFDMicroButton
	RaidB = RaidMicroButton
	EJB = EJMicroButton
	MenuB = MainMenuMicroButton
	HelpB = HelpMicroButton
	
	CharBS = CreateFrame("Button", "CharacterBS", microbarS)
	SpellBS = CreateFrame("Button", "SpellbookBS", microbarS)
	TalentBS = CreateFrame("Button", "TalentsBS", microbarS)
	AchievBS = CreateFrame("Button", "AchievementBS", microbarS)
	QuestBS = CreateFrame("Button", "QuestBS", microbarS)
	GuildBS = CreateFrame("Button", "GuildBS", microbarS)
	PVPBS = CreateFrame("Button", "PvpBS", microbarS)
	LFDBS = CreateFrame("Button", "LFDBS", microbarS)
	RaidBS = CreateFrame("Button", "RaidFinderBS", microbarS)
	EJBS = CreateFrame("Button", "JournalBS", microbarS)
	MenuBS = CreateFrame("Button", "MenuSysBS", microbarS)
	HelpBS = CreateFrame("Button", "TicketBS", microbarS)
	
	--On update functions
	microbarcontrol:SetScript("OnUpdate", function(self,event,...)
		MB:Mouseover()
	end)
end

--Creating buttons
function AB:CreateMicroBar()
	microbar:Point("BOTTOMRIGHT", RightChatTab, "TOPRIGHT", 2, 4);
	microbar:Hide()
	
	--Backdrop creation
	microbar:CreateBackdrop('Default');
	microbar.backdrop:SetFrameStrata("BACKGROUND") --Without this backdrop causes a significant visual taint
	microbar.backdrop:SetAllPoints();
	microbar.backdrop:Point("BOTTOMLEFT", microbar, "BOTTOMLEFT", 0,  -1);
	
	microbarcontrol:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	
	MicroParent.shown = false
	microbar:SetScript("OnUpdate", CheckFade)
	
	for i, button in pairs(microbuttons) do
		local m = _G[button]
		local pushed = m:GetPushedTexture()
		local normal = m:GetNormalTexture()
		local disabled = m:GetDisabledTexture()
		
		m:SetParent(MicroParent)
		m.SetParent = E.noop
		_G[button.."Flash"]:SetTexture("")
		m:SetHighlightTexture("")
		m.SetHighlightTexture = E.noop

		local f = CreateFrame("Frame", nil, m)
		f:SetFrameLevel(1)
		f:SetFrameStrata("BACKGROUND")
		f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 0)
		f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -28)
		f:SetTemplate("Default", true)
		m.frame = f
		
		pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		pushed:ClearAllPoints()
		pushed:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		pushed:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		normal:ClearAllPoints()
		normal:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		normal:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		if disabled then
			disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
			disabled:ClearAllPoints()
			disabled:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
			disabled:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		end
			

		m.mouseover = false
		m:HookScript("OnEnter", function(self) 
			self.frame:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor)) 
			self.mouseover = true 
		end)
		m:HookScript("OnLeave", function(self) 
			local color = RAID_CLASS_COLORS[E.myclass] 
			self.frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			self.mouseover = false 
		end)
	end
	
	local x = CreateFrame("Frame", "MicroPlaceHolder", MicroParent)
	x:SetPoint("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT")
	x:SetPoint("BOTTOMRIGHT", HelpMicroButton.frame, "BOTTOMRIGHT")
	x:EnableMouse(true)
	x.mouseover = false
	--x:CreateShadow("Default")
	x:SetScript("OnEnter", function(self) self.mouseover = true end)
	x:SetScript("OnLeave", function(self) self.mouseover = false end)
	
	--Fix/Create textures for buttons
	do
		MicroButtonPortrait:ClearAllPoints()
		MicroButtonPortrait:Point("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT", 2, -2)
		MicroButtonPortrait:Point("BOTTOMRIGHT", CharacterMicroButton.frame, "BOTTOMRIGHT", -2, 2)
		
		GuildMicroButtonTabard:ClearAllPoints()
		GuildMicroButtonTabard:SetPoint("TOP", GuildMicroButton.frame, "TOP", 0, 25)
		GuildMicroButtonTabard.SetPoint = E.noop
		GuildMicroButtonTabard.ClearAllPoints = E.noop
	end
	
	--MicroParent:SetPoint("BOTTOMRIGHT", RightChatTab, "TOPRIGHT", 2, 3) --Default microbar position

	MicroParent:SetWidth(((CharacterMicroButton:GetWidth() + 4) * 9) + 12)
	MicroParent:SetHeight(CharacterMicroButton:GetHeight() - 28)

	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  25)
	CharacterMicroButton.SetPoint = E.noop
	CharacterMicroButton.ClearAllPoints = E.noop

	MB:SymbolsCreateFrame()
	MB:UpdateMicroSettings()
end

--Backdrop show/hide
function MB:Backdrop()
	if E.db.microbar.backdrop then
		microbar.backdrop:Show();
		microbarS.backdrop:Show();
	else
		microbar.backdrop:Hide();
		microbarS.backdrop:Hide();
	end
end

--Mouseover and Alpha function
function MB:Mouseover()
	if E.db.microbar.mouse then
		if (MouseIsOver(MicroParent)) then
			MicroParent:SetAlpha(E.db.microbar.alpha)
			microbarS:SetAlpha(E.db.microbar.alpha)
		else	
			MicroParent:SetAlpha(0)
			microbarS:SetAlpha(0)
		end
	else
		MicroParent:SetAlpha(E.db.microbar.alpha)
		microbarS:SetAlpha(E.db.microbar.alpha)
	end
end

--Set Scale
function MB:Scale()
	microbar:SetScale(E.db.microbar.scale)
	microbarS:SetScale(E.db.microbar.scale)
end

--Show/Hide in combat
function MB:EnterCombat()
	if E.db.microbar.combat then
		microbar:Hide()
		microbarS:Hide()
	else
		if E.db.microbar.symbolic then
			microbarS:Show()
		else
			microbar:Show()
		end
	end	
end

--Show after leaving combat
function MB:LeaveCombat()
	if E.db.microbar.enable then
		if E.db.microbar.symbolic then
			microbarS:Show()
		else
			microbar:Show()
		end
	end
end

--Sets mover size based on the frame layout
function MB:MicroMoverSize()
	microbar.mover:SetWidth(E.db.microbar.scale * MicroParent:GetWidth())
	microbar.mover:SetHeight(E.db.microbar.scale * MicroParent:GetHeight() + 1);
end

--Positioning of buttons
function MB:MicroButtonsPositioning()
	if E.db.microbar.layout == "Micro_Hor" then --Horizontal
		CharB:SetPoint("BOTTOMLEFT", microbar, "BOTTOMLEFT", 1, 1)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentBS:SetPoint("TOPLEFT", SpellBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestBS:SetPoint("TOPLEFT", AchievBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPBS:SetPoint("TOPLEFT", GuildBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidBS:SetPoint("TOPLEFT", LFDBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuBS:SetPoint("TOPLEFT", EJBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
	elseif E.db.microbar.layout == "Micro_Ver" then --Vertical
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		TalentBS:SetPoint("TOPLEFT", SpellBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		AchievBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		QuestBS:SetPoint("TOPLEFT", AchievBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		PVPBS:SetPoint("TOPLEFT", GuildBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		RaidBS:SetPoint("TOPLEFT", LFDBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		MenuBS:SetPoint("TOPLEFT", EJBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
	elseif E.db.microbar.layout == "Micro_26" then --2 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		TalentB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		QuestB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		PVPB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		RaidB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		MenuB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		TalentBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		AchievBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		QuestBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		PVPBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		RaidBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
		MenuBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 25 + E.db.microbar.xoffset, 0)
	elseif E.db.microbar.layout == "Micro_34" then --3 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentBS:SetPoint("TOPLEFT", SpellBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		QuestBS:SetPoint("TOPLEFT", AchievBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPBS:SetPoint("TOPLEFT", AchievBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidBS:SetPoint("TOPLEFT", LFDBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		MenuBS:SetPoint("TOPLEFT", EJBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
	elseif E.db.microbar.layout == "Micro_43" then --4 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentBS:SetPoint("TOPLEFT", SpellBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPBS:SetPoint("TOPLEFT", GuildBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		EJBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuBS:SetPoint("TOPLEFT", EJBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
	elseif E.db.microbar.layout == "Micro_62" then --6 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 0,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		--Symbolic
		CharBS:SetPoint("CENTER", CharB, "CENTER", 0, -14)
		SpellBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		TalentBS:SetPoint("TOPLEFT", SpellBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		AchievBS:SetPoint("TOPLEFT", TalentBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		QuestBS:SetPoint("TOPLEFT", AchievBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		GuildBS:SetPoint("TOPLEFT", QuestBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		PVPBS:SetPoint("TOPLEFT", CharBS, "TOPLEFT", 0, -33 - E.db.microbar.yoffset)
		LFDBS:SetPoint("TOPLEFT", PVPBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		RaidBS:SetPoint("TOPLEFT", LFDBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		EJBS:SetPoint("TOPLEFT", RaidBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		MenuBS:SetPoint("TOPLEFT", EJBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
		HelpBS:SetPoint("TOPLEFT", MenuBS, "TOPLEFT", 25 + E.db.microbar.xoffset,  0)
	end
	
end

--Setting frame size to change view of backdrop
function MB:MicroFrameSize()
	if E.db.microbar.layout == "Micro_Hor" then
		microbar:Size(305 + (E.db.microbar.xoffset * 11), 35)
		microbarS:Size(305 + (E.db.microbar.xoffset * 11), 35)
	elseif E.db.microbar.layout == "Micro_Ver" then
		microbar:Size(30, 398 + (E.db.microbar.yoffset * 11))
		microbarS:Size(30, 398 + (E.db.microbar.yoffset * 11))
	elseif E.db.microbar.layout == "Micro_26" then
		microbar:Size(55 + E.db.microbar.xoffset, 200 + (E.db.microbar.yoffset * 5))
		microbarS:Size(55 + E.db.microbar.xoffset, 200 + (E.db.microbar.yoffset * 5))
	elseif E.db.microbar.layout == "Micro_34" then
		microbar:Size(80 + (E.db.microbar.xoffset * 2), 134 + (E.db.microbar.yoffset * 3))
		microbarS:Size(80 + (E.db.microbar.xoffset * 2), 134 + (E.db.microbar.yoffset * 3))
	elseif E.db.microbar.layout == "Micro_43" then
		microbar:Size(105 + (E.db.microbar.xoffset * 3), 101 + (E.db.microbar.yoffset * 2))
		microbarS:Size(105 + (E.db.microbar.xoffset * 3), 101 + (E.db.microbar.yoffset * 2))
	elseif E.db.microbar.layout == "Micro_62" then
		microbar:Size(155 + (E.db.microbar.xoffset * 5), 68 + E.db.microbar.yoffset)
		microbarS:Size(155 + (E.db.microbar.xoffset * 5), 68 + E.db.microbar.yoffset)
	else
		microbar:Size(305, 36)
		microbarS:Size(305, 36)
	end
end

--Buttons points clear
function MB:ButtonsSetup()
	CharB:ClearAllPoints()
	SpellB:ClearAllPoints()	
	TalentB:ClearAllPoints()	
	AchievB:ClearAllPoints()
	QuestB:ClearAllPoints()
	GuildB:ClearAllPoints()
	PVPB:ClearAllPoints()
	LFDB:ClearAllPoints()
	RaidB:ClearAllPoints()
	EJB:ClearAllPoints()
	MenuB:ClearAllPoints()
	HelpB:ClearAllPoints()
end

--Forcing buttons to show up even when thet shouldn't e.g. in vehicles
function MB:ShowMicroButtons()
	CharB:Show()
	SpellB:Show()
	TalentB:Show()
	QuestB:Show()
	PVPB:Show()
	GuildB:Show()
	LFDB:Show()
	EJB:Show()
	RaidB:Show()
	HelpB:Show()
	MenuB:Show()
	AchievB:Show()
end

--For recreate after portals and so on
function MB:MenuShow()
	if E.db.microbar.symbolic then
		microbarS:Show()
	else
		microbarS:Hide()
	end
	if E.db.microbar.enable then
		if E.db.microbar.symbolic then
			microbarS:Show()
			microbar:Hide()
		else
			microbar:Show()
		end
	else
		microbar:Hide()
		microbarS:Hide()
	end
	
	MB:ButtonsSetup();
	MB:MicroButtonsPositioning();
	MB:ShowMicroButtons();
end

--Hooking to Elv's UpdateAll function. Thanks to Blazeflack for making it smaller and other stuff
E.UpdateAllMicro = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllMicro(self)
   	MB:UpdateMicroSettings()
	MB:MicroMoverSize()
end

--Update settings after profile change
function MB:UpdateMicroSettings()
    MB:Backdrop();
    MB:Scale();
    MB:MicroButtonsPositioning();
    MB:MicroFrameSize();
end

function MB:SymbolsCreateFrame()
	microbarS:Point("CENTER", microbar, "CENTER", 0, 0)
	microbarS:CreateBackdrop('Default');
	microbarS.backdrop:SetFrameStrata("BACKGROUND") --Without this backdrop causes a significant visual taint
	microbarS.backdrop:SetAllPoints();
	microbarS.backdrop:Point("BOTTOMLEFT", microbarS, "BOTTOMLEFT", 0,  -1);
	
	MB:SymbolsCreateButtons()
end

function MB:SymbolsCreateButtons() --Creating and setting properties to second bar
	--Character
	CharBS:Size(20, 28)
	CharBS:CreateBackdrop()
	
	local CharBS_text = CharBS:CreateFontString(nil, 'OVERLAY')
	CharBS_text:SetFont(E["media"].normFont, 10)
	CharBS_text:SetText("C")
	CharBS_text:SetPoint("CENTER", CharBS, "CENTER")
	
	CharBS:SetScript("OnClick", function(self)
		if CharacterFrame:IsShown() then
			HideUIPanel(CharacterFrame)
		else
			ShowUIPanel(CharacterFrame)
		end
	end)
	
	CharBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(CharBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(CHARACTER_BUTTON)
		GameTooltip:Show()
	end)
	
	CharBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Spellbook
	SpellBS:Size(20, 28)
	SpellBS:CreateBackdrop()
	
	local SpellBS_text = SpellBS:CreateFontString(nil, 'OVERLAY')
	SpellBS_text:SetFont(E["media"].normFont, 10)
	SpellBS_text:SetText("S")
	SpellBS_text:SetPoint("CENTER", SpellBS, "CENTER")
	
	SpellBS:SetScript("OnClick", function(self)
		if SpellBookFrame:IsShown() then
			HideUIPanel(SpellBookFrame)
		else
			ShowUIPanel(SpellBookFrame)
		end
	end)
	
	SpellBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(SpellBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(SPELLBOOK_ABILITIES_BUTTON)
		GameTooltip:Show()
	end)
	
	SpellBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Talents
	TalentBS:Size(20, 28)
	TalentBS:CreateBackdrop()
	
	local TalentBS_text = TalentBS:CreateFontString(nil, 'OVERLAY')
	TalentBS_text:SetFont(E["media"].normFont, 10)
	TalentBS_text:SetText("T")
	TalentBS_text:SetPoint("CENTER", TalentBS, "CENTER")
	
	TalentBS:SetScript("OnClick", function(self)
		if UnitLevel("player") >= 10 then
			if PlayerTalentFrame then
				if PlayerTalentFrame:IsShown() then
					HideUIPanel(PlayerTalentFrame)
				else
					ShowUIPanel(PlayerTalentFrame)
				end
			else
				LoadAddOn("Blizzard_TalentUI")
			
				ShowUIPanel(PlayerTalentFrame)
			end
		end
	end)
	
	TalentBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(TalentBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(TALENTS_BUTTON)
		GameTooltip:Show()
	end)
	
	TalentBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Achievements
	AchievBS:Size(20, 28)
	AchievBS:CreateBackdrop()
	
	local AchievBS_text = AchievBS:CreateFontString(nil, 'OVERLAY')
	AchievBS_text:SetFont(E["media"].normFont, 10)
	AchievBS_text:SetText("A")
	AchievBS_text:SetPoint("CENTER", AchievBS, "CENTER")
	
	AchievBS:SetScript("OnClick", function(self)
		ToggleAchievementFrame()
	end)
	
	AchievBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(AchievBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(ACHIEVEMENT_BUTTON)
		GameTooltip:Show()
	end)
	
	AchievBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Quests
	QuestBS:Size(20, 28)
	QuestBS:CreateBackdrop()
	
	local QuestBS_text = QuestBS:CreateFontString(nil, 'OVERLAY')
	QuestBS_text:SetFont(E["media"].normFont, 10)
	QuestBS_text:SetText("Q")
	QuestBS_text:SetPoint("CENTER", QuestBS, "CENTER")
	
	QuestBS:SetScript("OnClick", function(self)
		if QuestLogFrame:IsShown() then
			HideUIPanel(QuestLogFrame)
		else
			ShowUIPanel(QuestLogFrame)
		end
	end)
	
	QuestBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(QuestBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(QUESTLOG_BUTTON)
		GameTooltip:Show()
	end)
	
	QuestBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Guild
	GuildBS:Size(20, 28)
	GuildBS:CreateBackdrop()
	
	local GuildBS_text = GuildBS:CreateFontString(nil, 'OVERLAY')
	GuildBS_text:SetFont(E["media"].normFont, 10)
	GuildBS_text:SetText("G")
	GuildBS_text:SetPoint("CENTER", GuildBS, "CENTER")
	
	GuildBS:SetScript("OnClick", function(self)
		if GuildFrame then
			if GuildFrame:IsShown() or (LookingForGuildFrame and LookingForGuildFrame:IsShown()) then
					if IsInGuild() then HideUIPanel(GuildFrame) else HideUIPanel(LookingForGuildFrame) end
				else
					if IsInGuild() then ShowUIPanel(GuildFrame) else ShowUIPanel(LookingForGuildFrame) end
			end
		else
			LoadAddOn("Blizzard_GuildUI")
			
			ShowUIPanel(EncounterJournal)
		end
	end)
	
	GuildBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(GuildBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(GUILD)
		GameTooltip:Show()
	end)
	
	GuildBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--PvP
	PVPBS:Size(20, 28)
	PVPBS:CreateBackdrop()
	
	local PVPBS_text = PVPBS:CreateFontString(nil, 'OVERLAY')
	PVPBS_text:SetFont(E["media"].normFont, 10)
	PVPBS_text:SetText("P")
	PVPBS_text:SetPoint("CENTER", PVPBS, "CENTER")
	
	PVPBS:SetScript("OnClick", function(self)
		if UnitLevel("player") >= 10 then
			if PVPFrame:IsShown() then
				HideUIPanel(PVPFrame)
			else
				ShowUIPanel(PVPFrame)
			end
		end
	end)
	
	PVPBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(PVPBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(PVP_OPTIONS)
		GameTooltip:Show()
	end)
	
	PVPBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--LFD
	LFDBS:Size(20, 28)
	LFDBS:CreateBackdrop()
	
	local LFDBS_text = LFDBS:CreateFontString(nil, 'OVERLAY')
	LFDBS_text:SetFont(E["media"].normFont, 10)
	LFDBS_text:SetText("D")
	LFDBS_text:SetPoint("CENTER", LFDBS, "CENTER")
	
	LFDBS:SetScript("OnClick", function(self)
		ToggleFrame(LFDParentFrame)
	end)
	
	LFDBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(LFDBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(DUNGEONS_BUTTON)
		GameTooltip:Show()
	end)
	
	LFDBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--LFR
	RaidBS:Size(20, 28)
	RaidBS:CreateBackdrop()
	
	local RaidBS_text = RaidBS:CreateFontString(nil, 'OVERLAY')
	RaidBS_text:SetFont(E["media"].normFont, 10)
	RaidBS_text:SetText("R")
	RaidBS_text:SetPoint("CENTER", RaidBS, "CENTER")
	
	RaidBS:SetScript("OnClick", function(self)
		ToggleFrame(RaidParentFrame)
	end)
	
	RaidBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(RaidBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(RAID_FINDER)
		GameTooltip:Show()
	end)
	
	RaidBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Journal
	EJBS:Size(20, 28)
	EJBS:CreateBackdrop()
	
	local EJBS_text = EJBS:CreateFontString(nil, 'OVERLAY')
	EJBS_text:SetFont(E["media"].normFont, 10)
	EJBS_text:SetText("J")
	EJBS_text:SetPoint("CENTER", EJBS, "CENTER")
	
	EJBS:SetScript("OnClick", function(self)
		if EncounterJournal then
			if EncounterJournal:IsShown() then
				HideUIPanel(EncounterJournal)
			else
				ShowUIPanel(EncounterJournal)
			end
		else
			LoadAddOn("Blizzard_EncounterJournal")
			
			ShowUIPanel(EncounterJournal)
		end
	end)
	
	EJBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(EJBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(ENCOUNTER_JOURNAL)
		GameTooltip:Show()
	end)
	
	EJBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Menu
	MenuBS:Size(20, 28)
	MenuBS:CreateBackdrop()
	
	local MenuBS_text = MenuBS:CreateFontString(nil, 'OVERLAY')
	MenuBS_text:SetFont(E["media"].normFont, 10)
	MenuBS_text:SetText("M")
	MenuBS_text:SetPoint("CENTER", MenuBS, "CENTER")
	
	MenuBS:SetScript("OnClick", function(self)
		if GameMenuFrame:IsShown() then
				HideUIPanel(GameMenuFrame)
			else
				ShowUIPanel(GameMenuFrame)
			end
	end)
	
	MenuBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(MenuBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(MAINMENU_BUTTON)
		GameTooltip:Show()
	end)
	
	MenuBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	--Help
	HelpBS:Size(20, 28)
	HelpBS:CreateBackdrop()
	
	local HelpBS_text = HelpBS:CreateFontString(nil, 'OVERLAY')
	HelpBS_text:SetFont(E["media"].normFont, 10)
	HelpBS_text:SetText("?")
	HelpBS_text:SetPoint("CENTER", HelpBS, "CENTER")
	
	HelpBS:SetScript("OnClick", function(self)
		ToggleHelpFrame()
	end)
	
	HelpBS:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(HelpBS, "ANCHOR_RIGHT", 0, 29)
		GameTooltip:SetText(HELP_BUTTON)
		GameTooltip:Show()
	end)
	
	HelpBS:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end


--Initialization
function MB:Initialize()
	MB:SetNames()
	AB:CreateMicroBar()
	MB:Backdrop();
	MB:MicroFrameSize();
	MB:Scale();
	E:CreateMover(microbar, "MicroMover", L['Microbar'])
	MB:MicroMoverSize()
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "MenuShow");
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "MenuShow");	
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "MenuShow");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeaveCombat");
end

E:RegisterModule(MB:GetName())