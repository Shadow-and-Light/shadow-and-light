local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local S = E:GetModule("SLE_ScreenSaver")
local LSM = LibStub("LibSharedMedia-3.0")
local SS
local ru = false
local Months = {}
local Week = {}

if GetLocale() == "ruRU" then 
	ru = true 
	Months = {
		"Января",
		"Февраля",
		"Марта",
		"Апреля",
		"Мая",
		"Июня",
		"Июля",
		"Августа",
		"Сентября",
		"Октября",
		"Ноября",
		"Декабря",
	}

	Week = {
		"Воскресенье",
		"Понедельник",
		"Вторник",
		"Среда",
		"Четверг",
		"Пятница",
		"Суббота",
	}
end

-- Blizzard Unit Functions - OnShow / OnEvent
local UnitLevel, IsInGuild, GetGuildInfo, UnitPVPName, UnitIsAFK = UnitLevel, IsInGuild, GetGuildInfo, UnitPVPName, UnitIsAFK
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local FlipCameraYaw = FlipCameraYaw

-- Blizzard Lua Helpers - OnUpdate
local format, random, date = format, random, date

local Name, Level, GuildName, GuildRank
local Class, ClassToken = UnitClass("player")
local Race, RaceToken = UnitRace("player")
local FactionToken, Faction = UnitFactionGroup("player")
local Color = RAID_CLASS_COLORS[ClassToken]
local CrestPath = [[Interface\AddOns\ElvUI_SLE\media\textures\crests\]]
local crestSize, month, week
local UpdateElapsed, TipsElapsed, TipNum, TipThrottle, OldTip = 0, 0, 1, 10, 0
local degree = 0
local fading = false

local Tips = {
	"Не стой в огне!",
	"Спать вредно! Пока ты спишь, враг качается!",
	"|cffFF4040Алгалон кричит: Я покараю вас анально, бичи со Свежевателя!|r",
	"Сделал дейлик - спас китайца!",
	"Lord Wert: Воронка, как ультимативное оружие, крайне сомнительна!",
	"Иди паси ёжиков! (С) Горыныч",
	"‹Elv›: I just utilized my degree in afro engineering and fixed it",
	"Ragenvald: да вы ****ец че за сильные духом и закаленные травой",
	"Варлоки пришли к нам из сказочного мира, где их любят и уважают. Поэтому они ненавидят наш мир лютой ненавистью.",
}

function S:Media()
	local db = E.db.sle.media.screensaver
	SS.Top.Title:SetFont(LSM:Fetch('font', db.title.font), db.title.size, db.title.outline)
	SS.Top.Quote:SetFont(LSM:Fetch('font', db.subtitle.font), db.subtitle.size, db.subtitle.outline)
	SS.Top.Date:SetFont(LSM:Fetch('font', db.date.font), db.date.size, db.date.outline)
	SS.Top.Time:SetFont(LSM:Fetch('font', db.date.font), db.date.size, db.date.outline)
	SS.Top.PlayerName:SetFont(LSM:Fetch('font', db.player.font), db.player.size, db.player.outline)
	SS.Top.PlayerInfo:SetFont(LSM:Fetch('font', db.player.font), db.player.size, db.player.outline)
	SS.Top.GuildR:SetFont(LSM:Fetch('font', db.player.font), db.player.size, db.player.outline)
	SS.Top.Guild:SetFont(LSM:Fetch('font', db.player.font), db.player.size, db.player.outline)
	SS.ScrollFrame:SetFont(LSM:Fetch('font', db.tips.font), db.tips.size, db.tips.outline)
	
	SS.FactCrest:SetSize(db.crest, db.crest)
	SS.RaceCrest:SetSize(db.crest, db.crest)

end

function S:Setup()
	--Creating stuff
	SS.Top = CreateFrame("Frame", nil, SS)
	SS.Top:SetTemplate("Transparent")
	SS.Bottom = CreateFrame("Frame", nil, SS)
	SS.Bottom:SetTemplate("Transparent")
	SS.FactCrest = SS.Top:CreateTexture(nil, 'OVERLAY')
	SS.FactCrest:SetTexture(CrestPath..FactionToken)
	SS.RaceCrest = SS.Top:CreateTexture(nil, 'ARTWORK')
	SS.RaceCrest:SetTexture(CrestPath..RaceToken)
	SS.ExPack = SS.Top:CreateTexture(nil, 'OVERLAY')
	SS.ExPack:SetTexture([[Interface\Glues\Common\Glues-WoW-WoDLogo.blp]])
	SS.ExPack:SetSize(150, 75)
	SS.model = CreateFrame("PlayerModel", "ScreenModel", SS)
	SS.model:CreateBackdrop("Transparent") --For checking size and borders
	SS.Top.Title = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.Quote = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.Quote:SetJustifyH("LEFT")
	SS.Top.Date = SS.Top:CreateFontString(nil, "OVERAY")
	SS.Top.Time = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.PlayerName = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.PlayerInfo = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.Guild = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.Top.GuildR = SS.Top:CreateFontString(nil, "OVERLAY")
	SS.ScrollFrame = CreateFrame("ScrollingMessageFrame", nil, SS)
	
	SS.testmodel = CreateFrame("PlayerModel", "ScreenTestModel", E.UIParent)
	SS.testmodel:SetPoint("RIGHT", E.UIParent, "RIGHT", -5, 0)
	SS.testmodel:CreateBackdrop("Transparent")
	SS.testmodel:Hide()
	
	-- SS.ScrollFrame:SetShadowColor(0, 0, 0, 0)
	SS.ScrollFrame:SetFading(false)
	SS.ScrollFrame:SetFadeDuration(0)
	SS.ScrollFrame:SetTimeVisible(1)
	SS.ScrollFrame:SetMaxLines(1)
	SS.ScrollFrame:SetSpacing(2)
	
	--Calling for fonts and shit updating
	self:Media()
	
	--Positioning stuff
	SS.Top:SetPoint("TOP", UIParent, "TOP", 0, 0)
	SS.Bottom:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	SS.Top.Date:SetPoint("RIGHT", SS.Top, "RIGHT", -40, 10)
	SS.Top.Time:SetPoint("TOP", SS.Top.Date, "BOTTOM", 0, -2)
	SS.Top.PlayerInfo:SetPoint("LEFT", SS.Top, "LEFT", 50, 10)
	SS.Top.PlayerName:SetPoint("BOTTOM", SS.Top.PlayerInfo, "TOP", 0, 2)
	SS.Top.Guild:SetPoint("TOP", SS.Top.PlayerInfo, "BOTTOM", 0, -2)
	SS.Top.GuildR:SetPoint("TOP", SS.Top.Guild, "BOTTOM", 0, -2)
	SS.FactCrest:SetPoint("CENTER", SS.Top, "BOTTOM", -(GetScreenWidth()/6), 0)
	SS.RaceCrest:SetPoint("CENTER", SS.Top, "BOTTOM", (GetScreenWidth()/6), 0)
	SS.ExPack:SetPoint("CENTER", SS.Top, "BOTTOM", 0, 0)
	SS.Top.Title:SetPoint("TOP", SS.Top, "TOP", 0, -10)
	SS.Top.Quote:SetPoint("TOP", SS.Top.Title, "BOTTOM", 0, -2)
	SS.ScrollFrame:SetPoint("CENTER", SS.Bottom, "CENTER", 0, 0)

	SS.Top.Title:SetText("|cff00AAFF"..L['You Are Away From Keyboard'].."|r")
	-----
	local Width, Height = GetScreenWidth(), E.db.sle.media.screensaver.height 
	local point = E.db.sle.media.screensaver.playermodel.position
	SS.Top:SetSize(Width, Height)
	SS.Bottom:SetSize(Width, Height)
	SS.model:SetWidth(E.db.sle.media.screensaver.playermodel.width)
	SS.model:SetPoint("TOP"..point, SS.Top,"BOTTOM"..point, 0,0)
	SS.model:SetPoint("BOTTOM"..point, SS.Bottom, "TOP"..point, 0, 0)
end

local AnimTime, testM

function S:TestShow()
	if AnimTime then AnimTime:Cancel() end
	testM = E.db.sle.media.screensaver.playermodel.anim
	SS.testmodel:Show()
	SS.testmodel:SetUnit("player")
	SS.testmodel:SetSize(SS.model:GetWidth(), SS.model:GetHeight())
	SS.testmodel:SetPosition(-E.db.sle.media.screensaver.playermodel.distance, E.db.sle.media.screensaver.playermodel.xaxis, E.db.sle.media.screensaver.playermodel.yaxis)
	if SS.testmodel:GetFacing() ~= (E.db.sle.media.screensaver.playermodel.rotation / 60) then
		SS.testmodel:SetFacing(E.db.sle.media.screensaver.playermodel.rotation / 60)
	end
	SS.testmodel:SetAnimation(testM)
	SS.testmodel:SetScript("OnAnimFinished", S.AnimTestFinished)

	AnimTime = C_Timer.NewTimer(10, S.TestHide)
end

function S:TestHide()
	SS.testmodel:Hide()
end

function S:AnimFinished()
	SS.model:SetAnimation(E.db.sle.media.screensaver.playermodel.anim)
end

function S:AnimTestFinished()
	SS.testmodel:SetAnimation(testM)
end

function S:Shown()
	Level, Name, TipNum = UnitLevel("player"), UnitPVPName("player"), random(1, #Tips)
	if IsInGuild() then
		GuildName, GuildRank = GetGuildInfo("player")
	end
	local Width, Height = GetScreenWidth(), E.db.sle.media.screensaver.height 
	self.model:SetUnit("player")
	local x = E.db.sle.media.screensaver.playermodel.position == "RIGHT" and -1 or 1
	local point = E.db.sle.media.screensaver.playermodel.position
	self.model:SetPosition(-E.db.sle.media.screensaver.playermodel.distance, -x*E.db.sle.media.screensaver.playermodel.xaxis, E.db.sle.media.screensaver.playermodel.yaxis) --(pos/neg) first number moves closer/farther, second right/left, third up/down
	if self.model:GetFacing() ~= (E.db.sle.media.screensaver.playermodel.rotation / 60) then
		self.model:SetFacing(E.db.sle.media.screensaver.playermodel.rotation / 60)
	end
	self.model:SetAnimation(E.db.sle.media.screensaver.playermodel.anim)
	self.model:SetScript("OnAnimFinished", S.AnimFinished)
	
	self.Top:SetSize(Width, Height)
	self.Bottom:SetSize(Width, Height)
	self.ScrollFrame:SetSize(Width, 24)
	
	--Positioning model
	SS.model:ClearAllPoints()
	SS.model:SetWidth(E.db.sle.media.screensaver.playermodel.width)
	SS.model:SetPoint("TOP"..point, SS.Top,"BOTTOM"..point, 0,0)
	SS.model:SetPoint("BOTTOM"..point, SS.Bottom, "TOP"..point, 0, 0)

	self.Top.Quote:SetText(L["Take care of yourself, Master!"])

	self.Top.PlayerName:SetText(format("|c%s%s|r", Color.colorStr, Name))
	self.Top.Guild:SetText(format(GuildName and "|cff00AAFF<%s>|r" or "", GuildName))
	self.Top.GuildR:SetText(format(GuildRank and "|cff00AAFF"..RANK..": %s|r" or "", GuildRank))
	self.Top.PlayerInfo:SetText(format("|c%s%s|r, %s %s", Color.colorStr, Class, LEVEL, Level))

	

	self.ScrollFrame:AddMessage(Tips[TipNum], 1, 1, 1)
end

function S:Update(elapsed)
	UpdateElapsed = UpdateElapsed + elapsed
	TipsElapsed = TipsElapsed + elapsed
	if ru then
		month = Months[tonumber(date("%m"))]
		week = Week[tonumber(date("%w"))+1]
	else
		month = date("%B")
		week = date("%A")
	end
	FlipCameraYaw(elapsed*10)
	degree = degree + elapsed*10
	if UpdateElapsed > 0.5 then
		self.Top.Time:SetText(format("%s", date("%H|cff00AAFF:|r%M|cff00AAFF:|r%S")))
		self.Top.Date:SetText(date("%d").." "..month.." |cff00AAFF"..week.."|r")
		UpdateElapsed = 0
	end
	if TipsElapsed > TipThrottle then
		TipNum = random(1, #Tips)
		if TipNum == OldTip then TipNum = random(1, #Tips) end
		self.ScrollFrame:AddMessage(Tips[TipNum], 1, 1, 1) 
		OldTip = TipNum
		TipsElapsed = 0
	end
end

function S:Event(event, unit)
	if event == "PLAYER_FLAGS_CHANGED" and unit ~= "player" then return end
	if UnitIsAFK("player") then
		SS:Show()
		Minimap:Hide()
		if not fading then
			fading = true
			UIFrameFadeIn(UIParent, 0.5, 1, 0)
		end
	else
		FlipCameraYaw(-degree)
		degree = 0
		SS:Hide()
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "Event")
		else
			Minimap:Show()
		end
		if fading then
			fading = false
			UIFrameFadeIn(UIParent, 0.5, 0, 1)
		end
	end
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent(event) end
	if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent(event) end
end

function S:Reg(opt)
	if E.db.sle.media.screensaver.enable then 
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "Event")
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", "Event")
		self:RegisterEvent("PLAYER_LOGIN", "Event")
	else
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
		self:UnregisterEvent("PLAYER_LOGIN")
	end
	if opt then self:Media() end
end

function S:Initialize()
	SS = CreateFrame("Frame", "SLE_SS", WorldFrame)
	SS:Hide()
	SS:SetFrameStrata("FULLSCREEN")
	SS:SetScale(SLE:Scale(1))
	self:Setup()
	SS:SetScript("OnShow", self.Shown)
	SS:SetScript("OnUpdate", self.Update)
	self:Reg()
end