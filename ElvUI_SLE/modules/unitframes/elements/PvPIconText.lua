local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames
local UF = E.UnitFrames

function SUF:Construct_PvPTimerText(frame)
	local PvPIndicator = frame.PvPIndicator

	PvPIndicator.SL_TimerText = CreateFrame('Frame', nil, frame)
	PvPIndicator.SL_TimerText:Size(10,10)
	PvPIndicator.SL_TimerText:SetFrameLevel(PvPIndicator:GetParent():GetFrameLevel() + 3)

	PvPIndicator.SL_TimerText.value = PvPIndicator.SL_TimerText:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvPIndicator.SL_TimerText.value)
	PvPIndicator.SL_TimerText.value:Point('CENTER')
	PvPIndicator.SL_TimerText.value:SetText('')

	frame:Tag(PvPIndicator.SL_TimerText.value, '[sl:pvptimer]')
end

function SUF:Configure_PvPTimerText(frame)
	local unit = frame.unitframeType
	local PvPIndicator = frame.PvPIndicator
	local db = E.db.sle.unitframe.units[unit].pvpicontext.timer
	local enable = frame:IsElementEnabled('PvPIndicator') and db.enable

	PvPIndicator.SL_TimerText.value:FontTemplate(E.LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)

	PvPIndicator.SL_TimerText:ClearAllPoints()
	PvPIndicator.SL_TimerText:Point('CENTER', PvPIndicator, db.anchorPoint, db.xOffset, db.yOffset)

	PvPIndicator.SL_TimerText:SetShown(enable)
end

function SUF:Construct_PvPLevelText(frame)
	local PvPIndicator = frame.PvPIndicator

	PvPIndicator.SL_LevelText = CreateFrame('Frame', nil, frame)
	PvPIndicator.SL_LevelText:Size(10,10)
	PvPIndicator.SL_LevelText:SetFrameLevel(PvPIndicator:GetParent():GetFrameLevel() + 3)

	PvPIndicator.SL_LevelText.value = PvPIndicator.SL_LevelText:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(PvPIndicator.SL_LevelText.value)
	PvPIndicator.SL_LevelText.value:Point('CENTER')
	PvPIndicator.SL_LevelText.value:SetText('')

	frame:Tag(PvPIndicator.SL_LevelText.value, '[sl:pvplevel]')
end

function SUF:Configure_PvPLevelText(frame)
	local PvPIndicator = frame.PvPIndicator
	local unit = frame.unitframeType
	local db = E.db.sle.unitframe.units[unit].pvpicontext.level
	local enable = frame:IsElementEnabled('PvPIndicator') and db.enable

	PvPIndicator.SL_LevelText.value:FontTemplate(E.LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)

	PvPIndicator.SL_LevelText:ClearAllPoints()
	PvPIndicator.SL_LevelText:Point('CENTER', PvPIndicator, db.anchorPoint, db.xOffset, db.yOffset)

	PvPIndicator.SL_LevelText:SetShown(enable)
end
