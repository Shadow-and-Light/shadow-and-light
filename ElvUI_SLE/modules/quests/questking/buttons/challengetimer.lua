local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local LSM = LibStub("LibSharedMedia-3.0")

local function Replace()
	local QuestKing = _G["QuestKing"]
	local WatchButton = QuestKing.WatchButton
	local opt = QuestKing.options
	local opt_buttonWidth = opt.buttonWidth
	local opt_font = opt.font
	local opt_fontChallengeTimer = opt.fontChallengeTimer
	local opt_fontSize = opt.fontSize
	local opt_fontStyle = opt.fontStyle

	local function SetProgressBarsColor(challengeBar)
		local COLOR
		if E.private.sle.skins.objectiveTracker.class then
			COLOR = classColor
		else
			COLOR = E.private.sle.skins.objectiveTracker.color
		end
		challengeBar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
	end

	local cachedChallengeBar = nil
	function WatchButton:AddChallengeBar()
		local button = self

		if (button.challengeBar) then
			return button.challengeBar
		end

		local challengeBar
		if (not cachedChallengeBar) then
			challengeBar = CreateFrame("StatusBar", "QuestKing_ChallengeBar", QuestKing.Tracker)
			challengeBar:SetStatusBarTexture(LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
			challengeBar:GetStatusBarTexture():SetHorizTile(false)
			SetProgressBarsColor(challengeBar)
			challengeBar:SetMinMaxValues(0, 1)
			challengeBar:SetValue(1)
			challengeBar:SetWidth(opt_buttonWidth - 36)
			challengeBar:SetHeight(17)
			challengeBar:CreateBackdrop("Transparent")

			local barPulser = button:CreateTexture()
			barPulser:SetAllPoints(challengeBar)
			barPulser:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
			barPulser:SetVertexColor(1, 0.9, 0.7, 0)
			barPulser:SetBlendMode("ADD")
			challengeBar.barPulser = barPulser

			local animGroup = barPulser:CreateAnimationGroup()
			local a1 = animGroup:CreateAnimation("Alpha")
				a1:SetDuration(0.25); a1:SetChange(1); a1:SetOrder(1);
			local a2 = animGroup:CreateAnimation("Alpha")
				a2:SetDuration(0.3); a2:SetChange(-1); a2:SetOrder(2); a2:SetEndDelay(0.45);
			animGroup.cycles = 0
			animGroup:SetScript("OnFinished", function (self)
				if (self.cycles > 0) then
					self:Play()
					self.cycles = self.cycles - 1
				else
					self.cycles = 0
				end
			end)
			challengeBar.barPulserAnim = animGroup

			-- <Alpha childKey="BorderAnim" change="1" duration="0.25" order="1"/>
			-- <Alpha childKey="BorderAnim" endDelay="0.45" change="-1" duration="0.3" order="2"/>		

			local icon = challengeBar:CreateTexture(nil, "OVERLAY")
			icon:SetTexture([[Interface\Challenges\challenges-plat-sm]])
			icon:SetSize(22, 22)
			icon:SetPoint("RIGHT", challengeBar, "LEFT", -6, 0)
			icon:SetTexCoord(0.25, 0.7, 0.25, 0.7)
			challengeBar.icon = icon

			local text = challengeBar:CreateFontString(nil, "OVERLAY")
			text:SetFont(opt_font, opt_fontSize, opt_fontStyle)
			text:SetJustifyH("CENTER")
			text:SetJustifyV("CENTER")
			text:SetAllPoints(true)
			text:SetTextColor(1, 1, 1)
			text:SetShadowOffset(1, -1)
			text:SetShadowColor(0, 0, 0, 1)
			text:SetText(CHALLENGES_TIMER_NO_MEDAL)
			challengeBar.text = text

			local extraText = challengeBar:CreateFontString(nil, "OVERLAY")
			extraText:SetFont(opt_font, opt_fontSize, opt_fontStyle)
			extraText:SetPoint("BOTTOMLEFT", challengeBar, "TOPLEFT", 2, 4)
			extraText:SetTextColor(1, 1, 1)
			extraText:SetShadowOffset(1, -1)
			extraText:SetShadowColor(0, 0, 0, 1)
			extraText:SetText(PROVING_GROUNDS_WAVE.." 1/5")
			extraText:Hide()
			challengeBar.extraText = extraText

			local score = challengeBar:CreateFontString(nil, "OVERLAY")
			score:SetFont(opt_font, opt_fontSize, opt_fontStyle)
			score:SetJustifyH("RIGHT")
			score:SetPoint("BOTTOMRIGHT", challengeBar, "TOPRIGHT", -2, 4)
			score:SetTextColor(1, 1, 1)
			score:SetShadowOffset(1, -1)
			score:SetShadowColor(0, 0, 0, 1)
			score:SetText("0")
			score:Hide()
			challengeBar.score = score

			challengeBar.bonusHeight = 18

			challengeBar:SetScript("OnUpdate", nil)

			cachedChallengeBar = challengeBar
		else
			challengeBar = cachedChallengeBar
			challengeBar:ClearAllPoints()

			challengeBar.extraText:Hide()
			challengeBar.score:SetText("0")
			challengeBar.score:Hide()
			challengeBar.bonusHeight = 18

			challengeBar.barPulserAnim:Stop()
			challengeBar.barPulserAnim.cycles = 0

			challengeBar:SetScript("OnUpdate", nil)

			SetProgressBarsColor(challengeBar)
			challengeBar.text:SetText(CHALLENGES_TIMER_NO_MEDAL)

			challengeBar._medalTimes = nil
			challengeBar._currentMedalTime = nil
			challengeBar._startTime = nil
		end

		challengeBar:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 26, 5)
		challengeBar:Show()

		button.challengeBar = challengeBar
		button.challengeBarIcon = challengeBar.icon
		button.challengeBarText = challengeBar.text

		return challengeBar
	end
end

T.tinsert(QK.Replaces, Replace)