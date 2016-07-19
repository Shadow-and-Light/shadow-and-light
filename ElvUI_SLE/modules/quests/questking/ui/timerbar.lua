local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local LSM = LibStub("LibSharedMedia-3.0")
local classColor = RAID_CLASS_COLORS[E.myclass]

-- local functions
local freeTimerBar
local timerBarPool = {}
local numTimerBars = 0
local timerBar_OnUpdate

local function Replace()
	local QuestKing = _G["QuestKing"]
	local GetTimeStringFromSecondsShort = QuestKing.GetTimeStringFromSecondsShort
	local opt = QuestKing.options
	local opt_buttonWidth = opt.buttonWidth
	local opt_lineHeight = opt.lineHeight
	local opt_itemButtonScale = opt.itemButtonScale
	local opt_font = opt.font
	local opt_fontSize = opt.fontSize
	local opt_fontStyle = opt.fontStyle

	local function SetProgressBarsColor(timerBar)
		local COLOR
		if E.private.sle.skins.objectiveTracker.class then
			COLOR = classColor
		else
			COLOR = E.private.sle.skins.objectiveTracker.color
		end
		timerBar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
	end

	function freeTimerBar (self)
		self:Hide()
		self:ClearAllPoints()

		self.baseLine.timerBar = nil
		self.baseLine = nil
		self.baseButton = nil

		tinsert(timerBarPool, self)
	end

	function timerBar_OnUpdate(self, elapsed)
		local timeNow = GetTime()
		local timeRemaining = self.duration - (timeNow - self.startTime)
		self:SetValue(timeRemaining)

		if (timeRemaining < 0) then
			-- hold at 0 for a moment
			if (timeRemaining > -0.5) then
				timeRemaining = 0
			else
				QuestKing:UpdateTracker()
				return
			end
		end

		self.text:SetText(GetTimeStringFromSecondsShort(timeRemaining))
		-- self.text:SetTextColor(ObjectiveTrackerTimerBar_GetTextColor(self.duration, self.duration - timeRemaining));
	end

	function QuestKing.WatchButton:AddTimerBar (duration, startTime)
		local line = self:AddLine()
		local timerBar = line.timerBar

		if (not timerBar) then
			if (#timerBarPool > 0) then
				timerBar = tremove(timerBarPool)
			else
				numTimerBars = numTimerBars + 1

				timerBar = CreateFrame("StatusBar", "QuestKing_TimerBar"..numTimerBars, QuestKing.Tracker)
				timerBar:SetStatusBarTexture(LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
				timerBar:GetStatusBarTexture():SetHorizTile(false)
				SetProgressBarsColor(timerBar)
				timerBar:SetMinMaxValues(0, 100)
				timerBar:SetValue(100)
				timerBar:SetWidth(opt_buttonWidth - 36)
				timerBar:SetHeight(15)
				timerBar:CreateBackdrop("Transparent")
				-- timerBar.sle_skinned = true

				local text = timerBar:CreateFontString(nil, "OVERLAY")
				text:SetFont(opt_font, opt_fontSize, opt_fontStyle)
				text:SetJustifyH("CENTER")
				text:SetJustifyV("CENTER")
				text:SetAllPoints(true)
				text:SetTextColor(1, 1, 1)
				text:SetShadowOffset(1, -1)
				text:SetShadowColor(0, 0, 0, 1)
				text:SetWordWrap(false)
				text:SetText("0:00")
				timerBar.text = text

				timerBar:SetScript("OnUpdate", timerBar_OnUpdate)

				timerBar.Free = freeTimerBar
			end

			line.timerBar = timerBar
			line.timerBarText = timerBarText

			timerBar.baseButton = self
			timerBar.baseLine = line

			timerBar:SetPoint("TOPLEFT", line, "TOPLEFT", 16, -3)
			timerBar:Show()
		end

		timerBar:SetMinMaxValues(0, duration)
		timerBar.duration = duration
		timerBar.startTime = startTime
		timerBar.block = block

		return timerBar
	end
end

T.tinsert(QK.Replaces, Replace)