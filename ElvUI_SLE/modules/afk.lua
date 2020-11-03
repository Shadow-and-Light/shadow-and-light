local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule('AFK')
local S = SLE:NewModule('Screensaver', 'AceHook-3.0', 'AceEvent-3.0')

--GLOBALS: unpack, select, format, random, date, tinsert, type, tonumber, hooksecurefunc, UnitPVPName, UnitLevel, UnitClass, UnitRace, UnitIsAFK, RANK, LEVEL, CreateFrame, CreateAnimationGroup, C_Timer, SendChatMessage, RAID_CLASS_COLORS, GetScreenWidth, GetScreenHeight, IsInGuild, GetGuildInfo, FlipCameraYaw

local format, random, date, tinsert, type, tonumber = format, random, date, tinsert, type, tonumber
local CreateFrame, SendChatMessage = CreateFrame, SendChatMessage

local UnitPVPName, UnitLevel, UnitClass, UnitRace, UnitIsAFK = UnitPVPName, UnitLevel, UnitClass, UnitRace, UnitIsAFK
local RANK, LEVEL = RANK, LEVEL
local C_Timer, CreateAnimationGroup = C_Timer, CreateAnimationGroup
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

local Class, ClassToken = UnitClass('player')
local RaceToken = select(2, UnitRace('player'))
local Color = E:ClassColor(ClassToken) or PRIEST_COLOR

local SS
local Name, Level, GuildName, GuildRank, month, week, AnimTime, testM
local CrestPath = [[Interface\AddOns\ElvUI_SLE\media\textures\crests\]]
local TipsElapsed, TipNum, OldTip, degree = 0, 1, 0, 0

S.Animations = {}
S.Fading = {}

function S:Media()
	--Updating all the shits!
	SS.AFKtitle:SetFont(E.LSM:Fetch('font', S.db.title.font), S.db.title.size, S.db.title.outline)
	SS.timePassed:SetFont(E.LSM:Fetch('font', S.db.title.font), S.db.title.size, S.db.title.outline)
	SS.Subtitle:SetFont(E.LSM:Fetch('font', S.db.subtitle.font), S.db.subtitle.size, S.db.subtitle.outline)
	SS.Date:SetFont(E.LSM:Fetch('font', S.db.date.font), S.db.date.size, S.db.date.outline)
	SS.Time:SetFont(E.LSM:Fetch('font', S.db.date.font), S.db.date.size, S.db.date.outline)
	SS.PlayerName:SetFont(E.LSM:Fetch('font', S.db.player.font), S.db.player.size, S.db.player.outline)
	SS.PlayerInfo:SetFont(E.LSM:Fetch('font', S.db.player.font), S.db.player.size, S.db.player.outline)
	SS.GuildRank:SetFont(E.LSM:Fetch('font', S.db.player.font), S.db.player.size, S.db.player.outline)
	SS.Guild:SetFont(E.LSM:Fetch('font', S.db.player.font), S.db.player.size, S.db.player.outline)
	SS.ScrollFrame:SetFont(E.LSM:Fetch('font', S.db.tips.font), S.db.tips.size, S.db.tips.outline)

	SS.timePassed:SetTextColor(1, 1, 1)

	SS.ExPack:SetSize(S.db.xpack, S.db.xpack/2)
	SS.FactCrest:SetSize(S.db.crest.size, S.db.crest.size)
	SS.RaceCrest:SetSize(S.db.crest.size, S.db.crest.size)
	SS.ElvTop:SetSize(S.db.xpack, S.db.xpack/2)
	SS.ElvBottom:SetSize(S.db.xpack, S.db.xpack/2)
	SS.sle:SetSize(2*S.db.xpack, S.db.xpack/2)
end

function S:Setup()
	--Creating top panel
	SS.Top = CreateFrame('Frame', nil, SS, 'BackdropTemplate')
	SS.Top:SetFrameLevel(0)
	SS.Top:SetWidth(GetScreenWidth() + (E.Border*2))

	--Creating additional strings
	SS.AFKtitle = SS.Top:CreateFontString(nil, 'OVERLAY')
	SS.Subtitle = SS.Top:CreateFontString(nil, 'OVERLAY')
	SS.Subtitle:SetJustifyH('LEFT')
	SS.PlayerInfo = SS.Top:CreateFontString(nil, 'OVERLAY')
	SS.Date = SS.Top:CreateFontString(nil, 'OVERAY')
	SS.Time = SS.Top:CreateFontString(nil, 'OVERLAY')

	--Changing Elv's strings
	SS.GuildRank = SS.Bottom:CreateFontString(nil, 'OVERLAY')
	SS.GuildRank:FontTemplate(nil, 20)
	SS.GuildRank:SetText('Stuff')
	SS.GuildRank:SetPoint('TOP', SS.Bottom.guild, 'BOTTOM', 0, -2)
	SS.GuildRank:SetTextColor(0.7, 0.7, 0.7)

	--Frame for tips
	SS.ScrollFrame = CreateFrame('ScrollingMessageFrame', nil, SS)
	SS.ScrollFrame:SetFading(false)
	SS.ScrollFrame:SetFadeDuration(0)
	SS.ScrollFrame:SetTimeVisible(1)
	SS.ScrollFrame:SetMaxLines(1)
	SS.ScrollFrame:SetSpacing(2)
	SS.ScrollFrame:SetWidth(SS.Bottom:GetWidth()/2)
	SS.ScrollFrame:LevelUpBG() --Creating neat stuff for teh tips

	--Crests, emblems and stuff
	SS.ExPack = CreateFrame('Button', nil, SS.Top)
	SS.ExPack:SetScript('OnClick', S.AbortAFK) --Allow to exit afk screen by clicking on the crest
	SS.ExPack.texture = SS:CreateTexture(nil, 'OVERLAY')
	SS.ExPack.texture:SetAllPoints(SS.ExPack)
	SS.ExPack.texture:SetTexture(GetExpansionDisplayInfo(GetClientDisplayExpansionLevel()).logo)
	-- SS.ExPack.texture:SetTexture([[Interface\Glues\Common\Glues-WoW-BattleforAzerothLogo.blp]])
	-- SS.ExPack.texture:SetTexCoord(0, 1, 0, 0.25) --this was for legion logo
	SS.FactCrest:SetTexture(CrestPath..E.myfaction)
	SS.RaceCrest = SS:CreateTexture(nil, 'ARTWORK')
	SS.RaceCrest:SetTexture(CrestPath..RaceToken)
	SLE:TextureExists(CrestPath..RaceToken, SS.RaceCrest, CrestPath..E.myfaction)
	SS.sle = SS:CreateTexture(nil, 'OVERLAY')
	SS.sle:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\SLE_Banner]])

	--Slightly moving chat
	SS.chat:ClearAllPoints()
	SS.chat:SetPoint('TOPLEFT', SS.Top, 'TOPLEFT', 0, 0)

	--Test model
	SS.testmodel = CreateFrame('PlayerModel', 'SLE_ScreenTestModel', E.UIParent)
	SS.testmodel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --Like in the original model
	SS.testmodel:SetPoint('CENTER', SS.Model)
	SS.testmodel:Hide()

	--Calling for fonts and shit updating
	self:Media()

	--Setting text for tite string. Here casue fonts were not set before
	SS.AFKtitle:SetText('|cff00AAFF'..L["You Are Away From Keyboard for"]..'|r')

	--Positioning
	SS.AFKtitle:Point('TOP', SS.Top, 'TOP', -25, -10)
	SS.Subtitle:Point('TOP', SS.AFKtitle, 'BOTTOM', 25, -2)
	SS.timePassed:ClearAllPoints()
	SS.timePassed:Point('LEFT', SS.AFKtitle, 'RIGHT', 4, -1)
	SS.ExPack:Point('CENTER', SS.Top, 'BOTTOM', 0, 0)
	SS.Time:Point('TOP', SS.Date, 'BOTTOM', 0, -2)
	SS.ElvTop:SetPoint('CENTER', SS.Bottom, 'TOP', -(GetScreenWidth()/10), 0)
	SS.ElvBottom:SetPoint('CENTER', SS.Bottom, 'CENTER', -(GetScreenWidth()/10), 68)
	SS.sle:SetPoint('CENTER', SS.Bottom, 'TOP', (GetScreenWidth()/10), 0)
	SS.PlayerName:ClearAllPoints()
	SS.Guild:ClearAllPoints()
	SS.GuildRank:ClearAllPoints()
	SS.PlayerName:Point('BOTTOM', SS.PlayerInfo, 'TOP', 0, 2)
	SS.Guild:SetPoint('TOP', SS.PlayerInfo, 'BOTTOM', 0, -2)
	SS.GuildRank:SetPoint('TOP', SS.Guild, 'BOTTOM', 0, -2)
	SS.ScrollFrame:SetPoint('CENTER', SS.Bottom, 'CENTER', 0, 0)
	S:SetPanelTemplate()
end

--Setting the template for top/bottom bars
function S:SetPanelTemplate()
	SS.Top:SetTemplate(S.db.panelTemplate, true)
	SS.Bottom:SetTemplate(S.db.panelTemplate, true)
end

--Template functons for animation types
function S:SlideIn(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.SlideIn then
		frame.anim.SlideIn = frame.anim:CreateAnimation('Move')
		frame.anim.SlideIn:SetRounded(false)
		tinsert(S.Animations, frame.anim.SlideIn)
	end
end
function S:SlideSide(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.SlideSide then
		frame.anim.SlideSide = frame.anim:CreateAnimation('Move')
		frame.anim.SlideSide:SetRounded(false)
		tinsert(S.Animations, frame.anim.SlideSide)
	end
end
function S:FadeIn(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.FadeIn then
		frame.anim.FadeIn = frame.anim:CreateAnimation('Fade')
		frame.anim.FadeIn:SetChange(1)
		tinsert(S.Animations, frame.anim.FadeIn)
		if frame ~= SS.Top or frame ~= SS.Bottom then
			tinsert(S.Fading, frame.anim.FadeIn)
		end
	end
end
--Creating and updating animations
function S:SetupAnimations()
	if not SS.Top.anim then --If no animation groups exist, create those
		S:SlideIn(SS.Top)
		S:SlideSide(SS.Top)
		S:FadeIn(SS.Top)

		S:SlideIn(SS.Bottom)
		S:SlideSide(SS.Bottom)
		S:FadeIn(SS.Bottom)

		if S.db.playermodel.enable then S:FadeIn(SS.Model) end

		S:FadeIn(SS.ExPack)
		S:FadeIn(SS.FactCrest)
		S:FadeIn(SS.RaceCrest)
		S:FadeIn(SS.sle)
		S:FadeIn(SS.ElvTop)
		S:FadeIn(SS.ElvBottom)

		S:FadeIn(SS.ScrollFrame)
	end

	SS.Top.anim.SlideIn:SetSmoothing(S.db.animBounce and 'Bounce' or 'None')
	SS.Bottom.anim.SlideIn:SetSmoothing(S.db.animBounce and 'Bounce' or 'None')
	SS.Top.anim.SlideSide:SetSmoothing(S.db.animBounce and 'Bounce' or 'None')
	SS.Bottom.anim.SlideSide:SetSmoothing(S.db.animBounce and 'Bounce' or 'None')
	S:SetupType()
end
--For model positioning
function S:ModelHolderPos()
	SS.Bottom.modelHolder:ClearAllPoints()
	SS.Bottom.modelHolder:SetPoint('BOTTOMRIGHT', SS.Bottom, 'BOTTOMRIGHT', -200+S.db.playermodel.holderXoffset, (220 + S.db.playermodel.holderYoffset))
end

function S:Show()
	Level, Name, TipNum = UnitLevel('player'), UnitPVPName('player'), random(1, #L["SLE_TIPS"])

	--Resizings
	SS.Top:SetHeight(S.db.height)
	SS.Bottom:SetHeight(S.db.height)
	SS.ScrollFrame:SetHeight(S.db.tips.size+4)
	SS.ScrollFrame.bg:SetHeight(S.db.tips.size+20)

	--Elements
	SS.FactCrest:ClearAllPoints()
	SS.RaceCrest:ClearAllPoints()
	SS.Date:ClearAllPoints()
	SS.PlayerInfo:ClearAllPoints()
	SS.FactCrest:Point('CENTER', SS.Top, 'BOTTOM', -(GetScreenWidth()/6) + S.db.crest.xOffset_faction, 0 + S.db.crest.yOffset_faction)
	SS.RaceCrest:Point('CENTER', SS.Top, 'BOTTOM', (GetScreenWidth()/6) + S.db.crest.xOffset_race, 0 + S.db.crest.yOffset_race)
	SS.Date:Point('RIGHT', SS.Top, 'RIGHT', -40 + S.db.date.xOffset, 10 + S.db.date.yOffset)
	SS.PlayerInfo:Point('RIGHT', SS.Top, 'RIGHT', -(GetScreenWidth()/6) + S.db.player.xOffset, 0 + S.db.player.yOffset)

	--Resizing chat
	SS.chat:SetHeight(SS.Top:GetHeight())

	--Setting texts
	if IsInGuild() then
		GuildName, GuildRank = GetGuildInfo('player')
	end
	SS.PlayerName:SetText(format('|c%s%s|r', Color.colorStr, Name))
	SS.GuildRank:SetText(format(GuildRank and '|cff00AAFF'..RANK..': %s|r' or '', GuildRank))
	SS.Subtitle:SetText(L["Take care of yourself, Master!"])
	SS.PlayerInfo:SetText(format('%s\n|c%s%s|r, %s %s', E.myrealm, Color.colorStr, Class, LEVEL, Level))

	--Positioning model
	if S.db.playermodel.enable then
		SS.Model:Show()
		SS.Model:SetAnimation(S.db.playermodel.anim)
		SS.Model:SetScript('OnAnimFinished', S.AnimFinished)
	else
		SS.Model:Hide()
		SS.Model:SetScript('OnAnimFinished', nil)
	end
	SS.Model:SetCamDistanceScale(S.db.playermodel.distance)
	if SS.Model:GetFacing() ~= (S.db.playermodel.rotation / 60) then
		SS.Model:SetFacing(S.db.playermodel.rotation / 60)
	end

	--Animations
	if S.db.animTime > 0 then
		if S.db.animType == 'SlideIn' then
			SS.Top.anim.SlideIn:SetOffset(0, -S.db.height)
			SS.Bottom.anim.SlideIn:SetOffset(0, S.db.height)
		elseif S.db.animType == 'SlideSide' then
			SS.Top.anim.SlideSide:SetOffset(E.screenwidth, 0)
			SS.Bottom.anim.SlideSide:SetOffset(-E.screenwidth, 0)
		end

		SS.Top.anim[S.db.animType]:SetDuration(S.db.animTime)
		SS.Bottom.anim[S.db.animType]:SetDuration(S.db.animTime)
		for i = 1, #(S.Fading) do
			S.Fading[i]:SetDuration(S.db.animTime)
		end

		SS.Top.anim[S.db.animType]:Play()
		SS.Bottom.anim[S.db.animType]:Play()
		for i = 1, #(S.Fading) do
			S.Fading[i]:Play()
		end
	end

	--Tip message
	SS.ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1)
	S:UpdateTimer()
end

function S:Hide()
	for i = 1, #(S.Animations) do --To avoid weird shit like S:SetupType was ignored when animations were interrupted in the go
		S.Animations[i]:Stop()
	end
	SS.ExPack:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.FactCrest:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.RaceCrest:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.sle:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.ElvTop:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.ElvBottom:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.Model:SetAlpha((S.db.animTime > 0 and 0) or 1)
	SS.ScrollFrame:SetAlpha((S.db.animTime > 0 and 0) or 1)
	S:SetupType()
	TipsElapsed = 0
end

function S:SetupType()
	SS.Top:ClearAllPoints()
	SS.Bottom:ClearAllPoints()
	if S.db.animTime > 0 then
		if S.db.animType == 'SlideIn' then
			SS.Top:Point('BOTTOM', SS, 'TOP', 0, E.Border)
			SS.Bottom:Point('TOP', SS, 'BOTTOM', 0, - E.Border)
			SS.Top:SetAlpha(1)
			SS.Bottom:SetAlpha(1)
		elseif S.db.animType == 'SlideSide' then
			SS.Top:Point('TOPRIGHT', SS, 'TOPLEFT', 0, E.Border)
			SS.Bottom:Point('BOTTOMLEFT', SS, 'BOTTOMRIGHT', 0, - E.Border)
			SS.Top:SetAlpha(1)
			SS.Bottom:SetAlpha(1)
		else
			SS.Top:Point('TOP', SS, 'TOP', 0, E.Border)
			SS.Bottom:Point('BOTTOM', SS, 'BOTTOM', 0, - E.Border)
			SS.Top:SetAlpha(0)
			SS.Bottom:SetAlpha(0)
		end
	else
		SS.Top:Point('TOP', SS, 'TOP', 0, E.Border)
		SS.Bottom:Point('BOTTOM', SS, 'BOTTOM', 0, - E.Border)
		SS.Top:SetAlpha(1)
		SS.Bottom:SetAlpha(1)
	end
end

--Testing model positioning
function S:TestShow()
	if AnimTime then AnimTime:Cancel() end
	testM = S.db.playermodel.anim
	SS.testmodel:Show()
	SS.testmodel:SetUnit('player')
	SS.testmodel:SetCamDistanceScale(S.db.playermodel.distance)
	if SS.testmodel:GetFacing() ~= (S.db.playermodel.rotation / 60) then
		SS.testmodel:SetFacing(S.db.playermodel.rotation / 60)
	end
	SS.testmodel:SetAnimation(testM)
	SS.testmodel:SetScript('OnAnimFinished', S.AnimTestFinished)

	AnimTime = C_Timer.NewTimer(10, S.TestHide)
end

function S:TestHide()
	SS.testmodel:Hide()
end

function S:AnimTestFinished()
	SS.testmodel:SetAnimation(testM)
end

--Updating date/time texts
function S:UpdateTimer()
	TipsElapsed = TipsElapsed + 1
	month = SLE.Russian and SLE.RuMonths[tonumber(date('%m'))] or date('%B')
	week = SLE.Russian and SLE.RuWeek[tonumber(date('%w'))+1] or date('%A')
	if S.db.date.hour24 then
		SS.Time:SetText(format('%s', date('%H|cff00AAFF:|r%M|cff00AAFF:|r%S')))
	else
		SS.Time:SetText(format('%s', date('%I|cff00AAFF:|r%M|cff00AAFF:|r%S %p')))
	end
	SS.Date:SetText(date('%d')..' '..month..', |cff00AAFF'..week..'|r')

	if TipsElapsed and TipsElapsed > S.db.tipThrottle then
		TipNum = random(1, #L["SLE_TIPS"])
		while TipNum == OldTip do TipNum = random(1, #L["SLE_TIPS"]) end
		SS.ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1)
		OldTip = TipNum
		TipsElapsed = 0
	end
end

local degreeMultyplier = 10
--Camera rotation script when entering or leaving afk
function S:Event(event, unit)
	if not E.db.general.afk then return end
	if event == 'PLAYER_REGEN_DISABLED' then
		SS:SetScript('OnUpdate', nil)
		FlipCameraYaw(-degree)
		degree = 0
		TipsElapsed = 0
		SS.timePassed:SetFormattedText('00:00')
		return
	end
	if (event == 'PLAYER_FLAGS_CHANGED' and unit ~= 'player') or event ~= 'PLAYER_FLAGS_CHANGED' then return end
	if (InCombatLockdown() or CinematicFrame:IsShown() or MovieFrame:IsShown()) then return; end
	--Don't activate afk if player is crafting stuff
	if (UnitCastingInfo('player') ~= nil) then return end
	if UnitIsAFK('player') then
		if not SS:GetScript('OnUpdate') then
			SS:SetScript('OnUpdate', function(_, elapsed)
				FlipCameraYaw(elapsed*degreeMultyplier)
				degree = degree + elapsed*degreeMultyplier
			end)
		end
	else
		SS:SetScript('OnUpdate', nil)
		FlipCameraYaw(-degree)
		degree = 0
		TipsElapsed = 0
		SS.timePassed:SetFormattedText('00:00')
	end
end

function S:AnimFinished()
	SS.Model:SetAnimation(S.db.playermodel.anim)
end

function S:KeyScript()--Dealing with on key down script
	if S.db.keydown then
		--Default script for key detection. Ignores modifires and screenshot button
		SS:SetScript('OnKeyDown', S.OnKeyDown)
	else
		SS:SetScript('OnKeyDown', nil)
	end
end

function S:AbortAFK()
	if UnitIsAFK('player') then SendChatMessage('' ,'AFK' ) end
end

--Hook to Elv's set afk
function S:SetAFK_Hook(status)
	if not E.db.general.afk then return end -- To prevent bs from happening
	if status then
		MoveViewLeftStop() --Stop Elv's stupid camera
		if(IsInGuild()) then GuildName, GuildRank = GetGuildInfo('player') end
		SS.Guild:SetText(format(GuildName and '|cff00AAFF<%s>|r' or L["No Guild"], GuildName)) --Setting good looking guild name line
		--Own model animation
		SS.Model:SetUnit('player')
		SS.Model:SetAnimation(S.db.playermodel.anim)
	end
end

function S:Initialize()
	if not SLE.initialized then return end
	SS = AFK.AFKMode
	if type(E.db.sle.screensaver.crest) == 'number' then
		E.db.sle.screensaver.crest = nil
		E.db.sle.screensaver.crest = P.sle.screensaver.crest
	end
	S.db = E.db.sle.screensaver
	S.OnKeyDown = SS:GetScript('OnKeyDown')
	if not E.private.sle.module.screensaver then return end
	S:KeyScript()

	--Hooking to Elv's stuff to get rid of his camera rotation, cause turns out it is shit
	hooksecurefunc(AFK, 'SetAFK', S.SetAFK_Hook)

	hooksecurefunc(AFK, 'OnEvent', S.Event)
	hooksecurefunc(AFK, 'UpdateTimer', S.UpdateTimer)
	SS.Bottom = SS.bottom
	SS.ElvTop = SS.Bottom.LogoTop
	SS.ElvBottom = SS.Bottom.LogoBottom
	SS.FactCrest = SS.Bottom.faction
	SS.PlayerName = SS.Bottom.name
	SS.Guild = SS.Bottom.guild
	SS.timePassed = SS.Bottom.time
	SS.Model = SS.Bottom.model

	S:Setup()
	S:ModelHolderPos()

	function S:ForUpdateAll()
		S.db = E.db.sle.screensaver
		S:SetupAnimations()
		S:Hide()
		S:KeyScript()
	end

	S:ForUpdateAll()

	SS:HookScript('OnShow', S.Show)
	SS:HookScript('OnHide', S.Hide)
	SS.Model:SetScript('OnUpdate', nil)

	AFK:OnEvent()
end

SLE:RegisterModule(S:GetName())
