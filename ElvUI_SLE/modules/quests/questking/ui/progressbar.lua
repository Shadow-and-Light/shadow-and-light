local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local LSM = LibStub("LibSharedMedia-3.0")
local classColor = RAID_CLASS_COLORS[E.myclass]
local progressBarPool = {}
QK.numProgressBars = 0
local freeProgressBar

local function Replace()
	local QuestKing = _G["QuestKing"]
	local opt = QuestKing.options
	local opt_buttonWidth = opt.buttonWidth
	local opt_lineHeight = opt.lineHeight
	local opt_itemButtonScale = opt.itemButtonScale
	local opt_font = opt.font
	local opt_fontSize = opt.fontSize
	local opt_fontStyle = opt.fontStyle

	local function SetProgressBarsColor(progressBar)
		local COLOR
		if E.private.sle.skins.objectiveTracker.class then
			COLOR = classColor
		else
			COLOR = E.private.sle.skins.objectiveTracker.color
		end
		progressBar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
	end

	function freeProgressBar (self)
		self:Hide()
		self:ClearAllPoints()

		self.baseLine.progressBar = nil
		self.baseLine = nil
		self.baseButton = nil

		self._lastPercent = nil

		T.tinsert(progressBarPool, self)
	end

	function QuestKing.WatchButton:AddProgressBar(duration, startTime)
		local line = self:AddLine()
		local progressBar = line.progressBar

		if (not progressBar) then
			if (#progressBarPool > 0) then
				progressBar = tremove(progressBarPool)
			else
				QK.numProgressBars = QK.numProgressBars + 1

				progressBar = CreateFrame("StatusBar", "QuestKing_ProgressBar"..QK.numProgressBars, QuestKing.Tracker)
				progressBar:SetStatusBarTexture(LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
				progressBar:GetStatusBarTexture():SetHorizTile(false)
				SetProgressBarsColor(progressBar)
				progressBar:SetMinMaxValues(0, 100)
				progressBar:SetValue(100)
				progressBar:SetWidth(opt_buttonWidth - 36)
				progressBar:SetHeight(15)
				progressBar:CreateBackdrop("Transparent")
				progressBar.sle_skinned = true

				local text = progressBar:CreateFontString(nil, "OVERLAY")
				text:SetFont(opt_font, opt_fontSize - 1, opt_fontStyle)
				text:SetJustifyH("CENTER")
				text:SetJustifyV("CENTER")
				
				text:SetPoint("TOPLEFT", progressBar, "TOPLEFT", 0, 0)
				text:SetPoint("BOTTOMRIGHT", progressBar, "BOTTOMRIGHT", 0, 2)
				
				text:SetTextColor(1, 1, 1)
				text:SetShadowOffset(1, -1)
				text:SetShadowColor(0, 0, 0, 1)
				text:SetWordWrap(false)
				text:SetVertexColor(0.8, 0.8, 0.8)
				text:SetText("0%")
				progressBar.text = text

				local glow = progressBar:CreateTexture(nil, "OVERLAY")
				glow:SetPoint("RIGHT", progressBar, "LEFT", 0, 0)
				glow:SetWidth(5)
				glow:SetHeight(progressBar:GetHeight() - 4)
				glow:SetTexture([[Interface\AddOns\QuestKing\textures\Full-Line-Glow-White]])
				glow:SetVertexColor(0.6, 0.8, 1, 0)
				glow:SetBlendMode("ADD")
				progressBar.glow = glow

				local animGroup = glow:CreateAnimationGroup()
				local a0 = animGroup:CreateAnimation("Alpha")
					a0:SetStartDelay(0); a0:SetChange(1); a0:SetDuration(0.25); a0:SetOrder(1);
				local a1 = animGroup:CreateAnimation("Alpha")
					a1:SetStartDelay(0.3); a1:SetChange(-1); a1:SetDuration(0.2); a1:SetOrder(1);
				glow.animGroup = animGroup

				local topLineBurst = progressBar:CreateTexture(nil, "OVERLAY")
				topLineBurst:SetPoint("CENTER", glow, "TOP", -3, 0)
				topLineBurst:SetWidth(progressBar:GetWidth() * 0.6)
				topLineBurst:SetHeight(8)
				topLineBurst:SetTexture([[Interface\QuestFrame\ObjectiveTracker]])
				topLineBurst:SetTexCoord(0.1640625, 0.33203125, 0.66796875, 0.74609375)
				topLineBurst:SetVertexColor(0.6, 0.8, 1, 0)
				topLineBurst:SetBlendMode("ADD")
				progressBar.topLineBurst = topLineBurst

				local animGroup = topLineBurst:CreateAnimationGroup()
				local a0 = animGroup:CreateAnimation("Alpha")
					a0:SetStartDelay(0); a0:SetChange(1); a0:SetDuration(0.25); a0:SetOrder(1);
				local a1 = animGroup:CreateAnimation("Alpha")
					a1:SetStartDelay(0.3); a1:SetChange(-1); a1:SetDuration(0.2); a1:SetOrder(1);
				local a2 = animGroup:CreateAnimation("Translation")
					a2:SetStartDelay(0); a2:SetOffset(5, 0); a2:SetDuration(0.25); a2:SetOrder(1);
				topLineBurst.animGroup = animGroup

				local bottomLineBurst = progressBar:CreateTexture(nil, "OVERLAY")
				bottomLineBurst:SetPoint("CENTER", glow, "BOTTOM", -3, 0)
				bottomLineBurst:SetWidth(progressBar:GetWidth() * 0.6)
				bottomLineBurst:SetHeight(8)
				bottomLineBurst:SetTexture([[Interface\QuestFrame\ObjectiveTracker]])
				bottomLineBurst:SetTexCoord(0.1640625, 0.33203125, 0.66796875, 0.74609375)
				bottomLineBurst:SetVertexColor(0.6, 0.8, 1, 0)
				bottomLineBurst:SetBlendMode("ADD")
				progressBar.bottomLineBurst = bottomLineBurst

				local animGroup = bottomLineBurst:CreateAnimationGroup()
				local a0 = animGroup:CreateAnimation("Alpha")
					a0:SetStartDelay(0); a0:SetChange(1); a0:SetDuration(0.25); a0:SetOrder(1);
				local a1 = animGroup:CreateAnimation("Alpha")
					a1:SetStartDelay(0.3); a1:SetChange(-1); a1:SetDuration(0.2); a1:SetOrder(1);
				local a2 = animGroup:CreateAnimation("Translation")
					a2:SetStartDelay(0); a2:SetOffset(5, 0); a2:SetDuration(0.25); a2:SetOrder(1);
				bottomLineBurst.animGroup = animGroup

				local pulse = progressBar:CreateTexture(nil, "OVERLAY")
				pulse:SetAllPoints(progressBar)
				pulse:SetTexture([[Interface\QuestFrame\UI-QuestLogTitleHighlight]])
				pulse:SetVertexColor(0.6, 0.8, 1, 0)
				pulse:SetBlendMode("ADD")		
				progressBar.pulse = pulse

				local animGroup = pulse:CreateAnimationGroup()
				local a1 = animGroup:CreateAnimation("Alpha")
					a1:SetStartDelay(0); a1:SetDuration(0.25); a1:SetChange(1); a1:SetOrder(1);
				local a2 = animGroup:CreateAnimation("Alpha")
					a2:SetStartDelay(0.3); a2:SetDuration(0.2); a2:SetChange(-1); a2:SetOrder(1);
				pulse.animGroup = animGroup

				progressBar.Free = freeProgressBar
				progressBar.SetPercent = setPercent
			end

			line.progressBar = progressBar
			line.progressBarText = progressBarText

			progressBar.baseButton = self
			progressBar.baseLine = line

			progressBar._lastPercent = nil

			progressBar:SetPoint("TOPLEFT", line, "TOPLEFT", 16, -3)
			progressBar:Show()
		end

		return progressBar
	end

	for i = 1, 3 do
		local progressBar = _G["QuestKing_ProgressBar"..i]
		if progressBar and not progressBar.sle_skinned then
			progressBar:StripTextures()
			progressBar:SetStatusBarTexture(LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
			progressBar:SetWidth(opt_buttonWidth - 36)
			SetProgressBarsColor(progressBar)
			progressBar:CreateBackdrop("Transparent")
		end
	end
end

T.tinsert(QK.Replaces, Replace)