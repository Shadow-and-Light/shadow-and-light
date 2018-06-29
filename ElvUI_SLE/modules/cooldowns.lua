local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local ESC = SLE:NewModule("EverySecondCounts")
local LSM = LibStub("LibSharedMedia-3.0")

local floor = math.floor
--WoW API / Variables
local GetTime = GetTime
local CreateFrame = CreateFrame

-- Copied from ElvUI
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for calculating aura time text
local DAYISH, HOURISH, MINUTEISH = HOUR * 23.5, MINUTE * 59.5, 59.5 --used for caclculating aura time at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden

E.TimeFormats[5] = { '%d:%02d', '%d:%02d' }
E.TimeColors[5] = "|cffeeeeee"

ESC.RegisteredCDs = {}

function ESC:GetTimeInfo(s, threshhold)
		if s < MINUTE then
			if s >= threshhold then
				return floor(s), 3, 0.51
			else
				return s, 4, 0.051
			end
		elseif s < HOUR then
			if E.db.sle.cooldowns.enable and s < E.db.sle.cooldowns.mmssThreshold then
				return s/MINUTE, 5, 0.51, s%MINUTE
			else
				local minutes = floor((s/MINUTE)+.5)
				return ceil(s / MINUTE), 2, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
			end
		elseif s < DAY then
			local hours = floor((s/HOUR)+.5)
			return ceil(s / HOUR), 1, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
		else
			local days = floor((s/DAY)+.5)
			return ceil(s / DAY), 0,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
		end
	end

local function Cooldown_OnUpdate(cd, elapsed)
	if cd.nextUpdate > 0 then
		cd.nextUpdate = cd.nextUpdate - elapsed
		return
	end

	local remain = cd.duration - (GetTime() - cd.start)

	if remain > 0.05 then
		if (cd.fontScale * cd:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
			cd.text:SetText('')
			cd.nextUpdate = 500
		else
			local timeColors, timeThreshold = E.TimeColors, E.db.cooldown.threshold
			if cd.ColorOverride and (E.db[cd.ColorOverride] and E.db[cd.ColorOverride].cooldown.override and E.TimeColors[cd.ColorOverride]) then
				timeColors, timeThreshold = E.TimeColors[cd.ColorOverride], E.db[cd.ColorOverride].cooldown.threshold
			end
			if not timeThreshold then
				timeThreshold = E.TimeThreshold
			end

			local timervalue, formatid
			timervalue, formatid, cd.nextUpdate, timervalue2 = ESC:GetTimeInfo(remain, timeThreshold)
			cd.text:SetFormattedText(("%s%s|r"):format(timeColors[formatid], E.TimeFormats[formatid][2]), timervalue, timervalue2)
		end
	else
		E:Cooldown_StopTimer(cd)
	end
end

-- Copied from ElvUI, modified to allow for customizable font size
function E:Cooldown_OnSizeChanged(cd, width, height)
	local fontScale = floor(width +.5) / ICON_SIZE
	local override = cd:GetParent():GetParent().SizeOverride
	if override then 
		fontScale = override / FONT_SIZE
	end

	if fontScale == cd.fontScale then
		return
	end

	cd.fontScale = fontScale
	if fontScale < MIN_SCALE and not override then
		cd:Hide()
	else
		cd:Show()
		if E.db.sle.cooldowns.enable then
			cd.text:FontTemplate(LSM:Fetch("font", E.db.sle.cooldowns.font), fontScale * E.db.sle.cooldowns.fontSize, E.db.sle.cooldowns.fontOutline)
		else
			cd.text:FontTemplate(nil, fontScale * FONT_SIZE, 'OUTLINE')
		end
		if cd.enabled then
			self:Cooldown_ForceUpdate(cd)
		end
	end
end

	-- Copied from ElvUI, modified to set a modified OnUpdate function
function E:CreateCooldownTimer(parent)
	local scaler = CreateFrame('Frame', nil, parent)
	scaler:SetAllPoints()

	local timer = CreateFrame('Frame', nil, scaler); timer:Hide()
	timer:SetAllPoints()
	timer:SetScript('OnUpdate', Cooldown_OnUpdate)

	local text = timer:CreateFontString(nil, 'OVERLAY')
	text:Point('CENTER', 1, 1)
	text:SetJustifyH("CENTER")
	timer.text = text

	self:Cooldown_OnSizeChanged(timer, parent:GetSize())
	parent:SetScript('OnSizeChanged', function(_, ...) self:Cooldown_OnSizeChanged(timer, ...) end)

	parent.timer = timer

	-- used to style nameplate aura cooldown text with `cooldownFontOverride`
	if parent.FontOverride then
		parent.FontOverride(parent)
	end

	-- used by nameplate and bag module to override the cooldown color by its setting (if enabled)
	if parent.ColorOverride then
		timer.ColorOverride = parent.ColorOverride
	end

	return timer
end

function ESC:UpdateSettings(arg)
	for i = 1, #ESC.RegisteredCDs do
		local cooldown = ESC.RegisteredCDs[i]
		if arg == "text" or arg == "all" then
			local override = cooldown:GetParent().SizeOverride
			if cooldown.timer.fontScale < MIN_SCALE and not override then
				cooldown.timer:Hide()
			else
				if E.db.sle.cooldowns.enable then
					cooldown.timer.text:FontTemplate(LSM:Fetch("font", E.db.sle.cooldowns.font), cooldown.timer.fontScale * E.db.sle.cooldowns.fontSize, E.db.sle.cooldowns.fontOutline)
				else
					cooldown.timer.text:FontTemplate(nil, cooldown.timer.fontScale * FONT_SIZE, 'OUTLINE')
				end
				-- cooldown.timer.text:FontTemplate(LSM:Fetch("font", E.db.sle.cooldowns.font), cooldown.timer.fontScale * E.db.sle.cooldowns.fontSize, E.db.sle.cooldowns.fontOutline)
			end
		end
		if arg == "threshold" or arg == "all" then
			E:Cooldown_ForceUpdate(cooldown.timer)
		end
	end
end

function ESC:Initialize()
	if not E.private.cooldown.enable then return end
	ESC:UpdateSettings("all")
end

hooksecurefunc(E, "CreateCooldownTimer", function(self, cooldown)
	T.tinsert(ESC.RegisteredCDs, cooldown)
end)

SLE:RegisterModule(ESC:GetName())