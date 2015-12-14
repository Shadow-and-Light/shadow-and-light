local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local S = E:GetModule("SLE_ScreenSaver")
local LSM = LibStub("LibSharedMedia-3.0")
local Sk = E:GetModule("Skins")
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

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
local TipsElapsed, TipNum, TipThrottle, OldTip = 0, 1, 10, 0
local degree = 0
local fading = false

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
	SS.ExPack:SetSize(E.db.sle.media.screensaver.xpack, E.db.sle.media.screensaver.xpack/2)
	SS.Elv:SetSize(E.db.sle.media.screensaver.xpack, E.db.sle.media.screensaver.xpack/2)
	SS.sle:SetSize(E.db.sle.media.screensaver.xpack, E.db.sle.media.screensaver.xpack/2)
end

function S:Setup()
	SS.startTime = GetTime()
	--Creating stuff
	SS.Top = CreateFrame("Frame", nil, SS)
	SS.Top:SetTemplate("Transparent")
	SS.Bottom = CreateFrame("Frame", nil, SS)
	SS.Bottom:SetTemplate("Transparent")
	SS.FactCrest = SS.Top:CreateTexture(nil, 'OVERLAY')
	SS.FactCrest:SetTexture(CrestPath..FactionToken)
	SS.RaceCrest = SS.Top:CreateTexture(nil, 'ARTWORK')
	SS.RaceCrest:SetTexture(CrestPath..RaceToken)
	SS.Elv = SS.Bottom:CreateTexture(nil, 'OVERLAY')
	SS.Elv:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\logo.tga")
	SS.sle = SS.Bottom:CreateTexture(nil, 'OVERLAY')
	SS.sle:SetTexture("Interface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Banner")
	SS.ExPack = CreateFrame("Button", "SLE_SS_Expack", SS.Top)
	SS.ExPack.Texture = SS.ExPack:CreateTexture(nil, 'OVERLAY')
	SS.ExPack.Texture:SetAllPoints(SS.ExPack)
	SS.ExPack.Texture:SetTexture([[Interface\Glues\Common\Glues-WoW-WoDLogo.blp]])
	SS.ExPack:SetScript("OnClick", S.Escape)
	SS.model = CreateFrame("PlayerModel", "ScreenModel", SS)
	-- SS.model:CreateBackdrop("Transparent") --For checking size and borders
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
	-- SS.testmodel:CreateBackdrop("Transparent")
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
	SS.Top:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 0, 0)
	SS.Top:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", 0, 0)
	SS.Bottom:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, 0)
	SS.Bottom:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", 0, 0)
	SS.Top.Date:SetPoint("RIGHT", SS.Top, "RIGHT", -40, 10)
	SS.Top.Time:SetPoint("TOP", SS.Top.Date, "BOTTOM", 0, -2)
	SS.Top.PlayerInfo:SetPoint("LEFT", SS.Top, "LEFT", 50, 10)
	SS.Top.PlayerName:SetPoint("BOTTOM", SS.Top.PlayerInfo, "TOP", 0, 2)
	SS.Top.Guild:SetPoint("TOP", SS.Top.PlayerInfo, "BOTTOM", 0, -2)
	SS.Top.GuildR:SetPoint("TOP", SS.Top.Guild, "BOTTOM", 0, -2)
	SS.FactCrest:SetPoint("CENTER", SS.Top, "BOTTOM", -(GetScreenWidth()/6), 0)
	SS.RaceCrest:SetPoint("CENTER", SS.Top, "BOTTOM", (GetScreenWidth()/6), 0)
	SS.Elv:SetPoint("CENTER", SS.Bottom, "TOP", -(GetScreenWidth()/10), 0)
	SS.sle:SetPoint("CENTER", SS.Bottom, "TOP", (GetScreenWidth()/10), 0)
	SS.ExPack:SetPoint("CENTER", SS.Top, "BOTTOM", 0, 0)
	SS.Top.Title:SetPoint("TOP", SS.Top, "TOP", 0, -10)
	SS.Top.Quote:SetPoint("TOP", SS.Top.Title, "BOTTOM", 0, -2)
	SS.ScrollFrame:SetPoint("CENTER", SS.Bottom, "CENTER", 0, 0)
	
	-- SS.button:SetPoint("TOP", SS.Bottom, "TOP")

	SS.Top.Title:SetText("|cff00AAFF"..L['You Are Away From Keyboard'].."|r")
	-----
	local point = E.db.sle.media.screensaver.playermodel.position
	SS.Top:SetHeight(E.db.sle.media.screensaver.height)
	SS.Bottom:SetHeight(E.db.sle.media.screensaver.height)
	SS.model:SetWidth(E.db.sle.media.screensaver.playermodel.width)
	if point ~= "CENTER" then
		SS.model:SetPoint("TOP"..point, SS.Top,"BOTTOM"..point, 0,0)
		SS.model:SetPoint("BOTTOM"..point, SS.Bottom, "TOP"..point, 0, 0)
	else
		SS.model:SetPoint("TOP", SS.Top,"BOTTOM", 0,0)
		SS.model:SetPoint("BOTTOM", SS.Bottom, "TOP", 0, 0)
	end
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
	Level, Name, TipNum = UnitLevel("player"), UnitPVPName("player"), random(1, #L["SLE_TIPS"])
	if IsInGuild() then
		GuildName, GuildRank = GetGuildInfo("player")
	end
	self.startTime = GetTime()
	self.model:SetUnit("player")
	local x = E.db.sle.media.screensaver.playermodel.position == "RIGHT" and -1 or 1
	local point = E.db.sle.media.screensaver.playermodel.position
	self.model:SetPosition(-E.db.sle.media.screensaver.playermodel.distance, -x*E.db.sle.media.screensaver.playermodel.xaxis, E.db.sle.media.screensaver.playermodel.yaxis) --(pos/neg) first number moves closer/farther, second right/left, third up/down
	if self.model:GetFacing() ~= (E.db.sle.media.screensaver.playermodel.rotation / 60) then
		self.model:SetFacing(E.db.sle.media.screensaver.playermodel.rotation / 60)
	end
	self.model:SetAnimation(E.db.sle.media.screensaver.playermodel.anim)
	self.model:SetScript("OnAnimFinished", S.AnimFinished)

	self.Top:SetHeight(E.db.sle.media.screensaver.height)
	self.Bottom:SetHeight(E.db.sle.media.screensaver.height)
	self.ScrollFrame:SetSize(self.Bottom:GetWidth(), 24)

	--Positioning model
	SS.model:ClearAllPoints()
	SS.model:SetWidth(E.db.sle.media.screensaver.playermodel.width)
	if point ~= "CENTER" then
		SS.model:SetPoint("TOP"..point, SS.Top,"BOTTOM"..point, 0,0)
		SS.model:SetPoint("BOTTOM"..point, SS.Bottom, "TOP"..point, 0, 0)
	else
		SS.model:SetPoint("TOP", SS.Top,"BOTTOM", 0,0)
		SS.model:SetPoint("BOTTOM", SS.Bottom, "TOP", 0, 0)
	end

	self.Top.Quote:SetText(L["Take care of yourself, Master!"])

	self.Top.PlayerName:SetText(format("|c%s%s|r", Color.colorStr, Name))
	self.Top.Guild:SetText(format(GuildName and "|cff00AAFF<%s>|r" or "", GuildName))
	self.Top.GuildR:SetText(format(GuildRank and "|cff00AAFF"..RANK..": %s|r" or "", GuildRank))
	self.Top.PlayerInfo:SetText(format("|c%s%s|r, %s %s", Color.colorStr, Class, LEVEL, Level))
	
	self.ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1)
	S:UpdateTimer()
	self.timer = S:ScheduleRepeatingTimer('UpdateTimer', 1)
end

function S:UpdateCamera(elapsed)
	FlipCameraYaw(elapsed*10)
	degree = degree + elapsed*10
end

function S:UpdateTimer()
	TipsElapsed = TipsElapsed + 1
	if ru then
		month = Months[tonumber(date("%m"))]
		week = Week[tonumber(date("%w"))+1]
	else
		month = date("%B")
		week = date("%A")
	end
	SS.Top.Time:SetText(format("%s", date("%H|cff00AAFF:|r%M|cff00AAFF:|r%S")))
	SS.Top.Date:SetText(date("%d").." "..month.." |cff00AAFF"..week.."|r")

	if TipsElapsed > TipThrottle then
		TipNum = random(1, #L["SLE_TIPS"])
		if TipNum == OldTip then TipNum = random(1, #L["SLE_TIPS"]) end
		SS.ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1) 
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
		UIParent:Hide()
	else
		FlipCameraYaw(-degree)
		degree = 0
		SS:Hide()
		S:CancelTimer(SS.timer)
		TipsElapsed = 0
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

function S:UpdateConfig()
	if IsAddOnLoaded("ElvUI_Config") then
		if E.db.sle.media.screensaver.enable then
			E.Options.args.general.args.general.args.afk = {
				order = 15,
				name = L["AFK Mode"],
				desc = L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."],
				type = "execute",
				func = function() ACD:SelectGroup("ElvUI", "sle", "screensaver") end,
			}
		else
			E.Options.args.general.args.general.args.afk = {
				order = 15,
				type = 'toggle',
				name = L["AFK Mode"],
				desc = L["When you go AFK display the AFK screen."],
				get = function(info) return E.db.general.afk end,
				set = function(info, value) E.db.general.afk = value; E:GetModule('AFK'):Toggle() end
			}
		end
	end
end

local function LoadConfig(event, addon)
	if addon ~= "ElvUI_Config" then return end

	S:UpdateConfig()
	S:UnregisterEvent("ADDON_LOADED")
end

function S:Reg(opt)
	if E.db.sle.media.screensaver.enable then
		if E.db.general then E.db.general.afk = false E:GetModule("AFK"):Toggle() end
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

function S:Escape()
	if E.db.sle.media.screensaver.enable and UnitIsAFK("player") then 
		SendChatMessage("" ,"AFK" )
	end
end

function S:Initialize()
	SS = CreateFrame("Frame", "SLE_SS", WorldFrame)
	SS:Hide()
	SS:SetFrameStrata("FULLSCREEN")
	SS:SetScale(SLE:Scale(1))
	self:Setup()
	SS:SetScript("OnShow", self.Shown)
	SS:SetScript("OnUpdate", self.UpdateCamera)
	-- SS:SetScript("OnKeyDown", S.Escape)
	self:Reg()
	self:RegisterEvent("ADDON_LOADED", LoadConfig)
	self:RegisterEvent("LFG_PROPOSAL_SHOW", S.Escape)
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", S.Escape)
end